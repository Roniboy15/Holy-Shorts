import type { ReactNode } from "react";

type PublicLayoutProps = {
  children: ReactNode;
};

export default function PublicLayout({ children }: PublicLayoutProps) {
  return (
    <div className="min-h-screen bg-white">
      <header className="border-b border-zinc-200">
        <div className="mx-auto flex w-full max-w-5xl items-center justify-between px-4 py-4 sm:px-6">
          <div>
            <label htmlFor="category-placeholder" className="sr-only">
              Category
            </label>
            <select
              id="category-placeholder"
              disabled
              className="rounded-md border border-zinc-300 bg-white px-3 py-1.5 text-sm text-zinc-700"
            >
              <option>Categories (coming soon)</option>
            </select>
          </div>

          <div>
            <label htmlFor="language-placeholder" className="sr-only">
              Language
            </label>
            <select
              id="language-placeholder"
              disabled
              className="rounded-md border border-zinc-300 bg-white px-3 py-1.5 text-sm text-zinc-700"
            >
              <option>DE / EN / HE</option>
            </select>
          </div>
        </div>
      </header>

      <main className="mx-auto w-full max-w-5xl px-4 py-10 sm:px-6">{children}</main>
    </div>
  );
}
