import Link from "next/link";

export default function HomePage() {
  return (
    <section className="space-y-6">
      <h1 className="text-3xl font-semibold tracking-tight text-zinc-900">Holy Shorts</h1>
      <p className="max-w-2xl text-base leading-7 text-zinc-600">
        Weekly one-page Jewish religious content, available in German, English, and Hebrew.
      </p>

      <div className="space-y-3">
        <Link
          href="/p/sample-weekly-item"
          className="block rounded-md border border-zinc-200 bg-white px-4 py-3 text-sm text-zinc-800 transition-colors hover:border-zinc-300"
        >
          Open sample weekly item
        </Link>
        <Link
          href="/category/general"
          className="block rounded-md border border-zinc-200 bg-white px-4 py-3 text-sm text-zinc-800 transition-colors hover:border-zinc-300"
        >
          Browse sample category
        </Link>
      </div>
    </section>
  );
}
