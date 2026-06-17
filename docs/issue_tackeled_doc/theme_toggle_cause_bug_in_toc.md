# Bug: Blog TOC taps stop working after toggling theme                                                               
                                      
  ## Symptom                                                                                                           
  - First page load: clicking a TOC entry scrolls the article to that heading. Works fine.                             
  - Toggle Light/Dark/System: clicking a TOC entry silently does nothing. Scrolling "works" (page scrolls) but the     
  sidebar's active-item highlight no longer tracks the current heading.                                                
                                                                                                                       
  ## Setup (how TOC was built)                                                                                         
  - Article rendered as a single `MarkdownBody` (flutter_markdown_plus).                                               
  - A custom `MarkdownElementBuilder` (`TocHeadingBuilder`) was injected for `h2`/`h3` tags. Its job: when the markdown
   renderer emitted a heading, wrap that heading in a `Container(key: headingKeys[id])` so the TOC could later call    
  `Scrollable.ensureVisible(key.currentContext)`.                                                                      
  - `headingKeys` was a `Map<String, GlobalKey>` created once in the page's State.                                     
                                                                                                                       
  ## Root cause
  `GlobalKey`s attached via `MarkdownElementBuilder` live inside widgets that                                          
  `MarkdownBody` regenerates on every stylesheet change. When the theme is                                             
  toggled:                                                                                                             
                                                                                                                       
  1. Theme data changes → the Theme widget notifies descendants.                                                       
  2. `BlogPostMarkdownCard.build` re-runs (it reads `Theme.of(context)`).
  3. A new `MarkdownStyleSheet` object is passed to `MarkdownBody`.                                                    
  4. `MarkdownBody` treats the stylesheet change as "rebuild tree," tears down the old heading `Container`s, then calls
   the builders again to build new ones.                                                                               
  5. In the small window during the rebuild, the `GlobalKey`s are detached from any mounted widget.                    
  `key.currentContext` returns `null`.                                                                                 
  6. `_scrollToHeading` has `if (ctx == null) return;` → silent no-op. That's the "tap does nothing" symptom.
                                                                                                                       
  The trigger was brittle because:                                                                                     
  - The same builder instance had a stateful `_matched` set used to dedupe heading matches. On re-render it could also 
  return `null` for a heading whose id was already in `_matched` — a second failure mode layered on top of the first.  
  - The keys were logically owned by the page but physically attached to widgets owned by a third-party renderer we
  don't control.                                                                                                       
                                                         
  ## What the diagnostic log showed                                                                                    
  // Initial render                                      
  [TOC] visit  ... alreadyAttached=false  ← expected (keys brand-new)

  // Tap after initial render (works)                                                                                  
  [TOC] tap keyNull=false ctxNull=false       ← key has a live context
  [TOC] visit  ... alreadyAttached=true   ← on re-render, old Containers still mounted; keys reattach cleanly          
                                                                                                                       
  // After theme toggle (broken)                                                                                       
  [TOC] visit  ... alreadyAttached=false  ← old Containers already torn down BEFORE new ones mounted                   
  `alreadyAttached=false` after a theme change was the smoking gun: it meant the key's old home was gone and its new   
  home wasn't up yet.                                                                                                  
                                                                                                                       
  ## Fix: own the widget the key is attached to                                                                        
  Split the markdown into sections upstream, render each section as its own                                            
  widget, and put the `GlobalKey` on that outer widget.                    
                                                                                                                       
  - New domain util `parseMarkdownDocument(markdown)` walks the markdown once and returns both the heading list and a  
  list of `BlogPostSection { heading, markdown }`. By construction they stay consistent.                               
  - `BlogPostMarkdownCard` is now a `Column` of `_Section` widgets. Each section with a heading carries its `GlobalKey`
   on the `_Section` itself.                                                                                           
  - Each section's body is still rendered by `MarkdownBody`, but the key is no longer inside `MarkdownBody`'s tree —   
  it's on a widget in our tree.                                                                                     
  - Deleted: `TocHeadingBuilder`, the `_matched` dedup, the `resetMatchState` workaround, all key-threading into       
  markdown internals.                                                                                           
                                                                                                                       
  Because the key is now attached to a widget at a stable position in our
  own widget tree, Flutter's normal reconciliation preserves the Element                                               
  across rebuilds. `key.currentContext` stays valid through theme toggles.
  `Scrollable.ensureVisible` works.                                                                                    
                                                                                                                       
  ## Lessons                                                                                                           
  1. **Don't attach `GlobalKey`s to widgets you don't own.** If a third-party widget can regenerate its subtree, any   
  key you injected can go stale. Keep keys on widgets at a stable position in your own tree.                        
  2. **Stateful deduplication inside a rebuild-on-every-tick object is a landmine.** The `_matched` set quietly broke  
  reattachment a second time for the same reason.                                                                    
  3. **Silent `if (ctx == null) return;` hides bugs.** Worth either asserting, logging, or surfacing during development
   so "tap does nothing" isn't the only signal.                                                                        
  4. **The simple design was simpler than the clever one.** Splitting the markdown into sections by heading upstream   
  removed the custom builder, the dedup, the reset ritual, and the fragility — all at once.