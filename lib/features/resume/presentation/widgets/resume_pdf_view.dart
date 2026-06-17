/// Renders a hosted PDF inline.
///
/// The implementation is platform-specific: on web it embeds the PDF in an
/// `<iframe>` using the browser's native PDF viewer; elsewhere it falls back to
/// a stub since this app targets the web.
library;

export 'resume_pdf_view_stub.dart'
    if (dart.library.js_interop) 'resume_pdf_view_web.dart';
