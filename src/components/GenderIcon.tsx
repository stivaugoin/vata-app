import { Enums } from "@/database.types";
import { MarsIcon, VenusIcon } from "lucide-react";

export function GenderIcon({
  className,
  gender,
}: {
  className?: string;
  gender: Enums<"gender">;
}) {
  if (gender === "female") return <VenusIcon className={className} />;
  return <MarsIcon className={className} />;
}
