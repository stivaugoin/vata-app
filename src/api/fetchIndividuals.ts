import { supabase } from "../lib/supabase";
import { fetchIndividualsByName } from "./fetchIndividualsByName";
import { getPageRange } from "./getPageRange";

/**
 * Fetches a paginated list of individuals from the database
 * @param params.page - The page number to fetch (1-based)
 * @param params.query - Search query to filter individuals by name
 * @throws When there's an error fetching data from Supabase
 */
export async function fetchIndividuals({
  page,
  query,
}: {
  page: number;
  query: string;
}) {
  const { start, end } = getPageRange(page);

  if (query) return await fetchIndividualsByName({ page, query });

  const { count, data, error } = await supabase
    .from("individuals")
    .select("id, gender, names(first_name, last_name, is_primary)", {
      count: "exact",
    })
    .range(start, end);

  if (error) throw error;

  return { data, total: count };
}
