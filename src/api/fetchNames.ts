import type { Database } from "@/database.types";
import { supabase } from "@/lib/supabase";

type Name = Database["public"]["Tables"]["names"]["Row"];

/**
 * Fetch all names for a specific individual
 */
export async function fetchNames(individualId: string): Promise<Name[]> {
  const { data, error } = await supabase
    .from("names")
    .select("*")
    .eq("individual_id", individualId)
    .order("is_primary", { ascending: false });

  if (error) {
    throw error;
  }

  return data;
}
