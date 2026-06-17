import { logger } from "firebase-functions";
import { defineSecret } from "firebase-functions/params";
import { HttpsError, onCall } from "firebase-functions/v2/https";

// Held server-side so the Buttondown key never ships in the web bundle.
// Set it once with: firebase functions:secrets:set BUTTONDOWN_API_KEY
const buttondownApiKey = defineSecret("BUTTONDOWN_API_KEY");

const BUTTONDOWN_SUBSCRIBERS_URL = "https://api.buttondown.com/v1/subscribers";
const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

interface ButtondownErrorBody {
  code?: string;
  detail?: string;
}

type SubscribeResponse = { result: "success" | "already_subscribed" };

export const subscribeToNewsletter = onCall(
  {
    region: "australia-southeast1",
    secrets: [buttondownApiKey],
    enforceAppCheck: true,
  },
  async (request): Promise<SubscribeResponse> => {
    const rawEmail = (request.data as { email?: unknown } | null)?.email;
    const email = typeof rawEmail === "string" ? rawEmail.trim() : "";
    if (!EMAIL_PATTERN.test(email)) {
      throw new HttpsError(
        "invalid-argument",
        "A valid email address is required.",
      );
    }

    const response = await fetch(BUTTONDOWN_SUBSCRIBERS_URL, {
      method: "POST",
      headers: {
        Authorization: `Token ${buttondownApiKey.value()}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ email_address: email }),
    });

    if (response.status === 201) {
      return { result: "success" };
    }

    const body = (await response
      .json()
      .catch(() => null)) as ButtondownErrorBody | null;

    // Buttondown rejects duplicates with a 400 instead of upserting, so the
    // client can tell the reader they are already on the list.
    if (response.status === 400 && body?.code?.includes("already_exists")) {
      return { result: "already_subscribed" };
    }

    logger.error("Buttondown subscribe failed", {
      status: response.status,
      code: body?.code,
      detail: body?.detail,
    });

    if (response.status === 400) {
      throw new HttpsError(
        "invalid-argument",
        body?.detail ?? "Buttondown rejected that email address.",
      );
    }

    throw new HttpsError(
      "unavailable",
      "The newsletter service is unavailable right now. Please try again later.",
    );
  },
);
