type CategoryPageProps = {
  params: Promise<{
    slug: string;
  }>;
};

export default async function CategoryPage({ params }: CategoryPageProps) {
  const { slug } = await params;

  return (
    <section className="space-y-4">
      <h1 className="text-2xl font-semibold tracking-tight text-zinc-900">Category: {slug}</h1>
      <p className="text-sm text-zinc-600">
        Category listing placeholder. Published entries for this category will be rendered here in
        later stages.
      </p>
    </section>
  );
}
