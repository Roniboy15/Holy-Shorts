type PublicItemPageProps = {
  params: Promise<{
    slug: string;
  }>;
};

export default async function PublicItemPage({ params }: PublicItemPageProps) {
  const { slug } = await params;

  return (
    <section className="space-y-4">
      <h1 className="text-2xl font-semibold tracking-tight text-zinc-900">{slug}</h1>
      <p className="text-sm text-zinc-600">
        Public PDF detail page placeholder. PDF viewer, print, and share actions will be added in
        upcoming stages.
      </p>
    </section>
  );
}
