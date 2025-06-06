import { fetchPlaces } from "@/api";
import { PageHeader } from "@/components/PageHeader";
import { TableData } from "@/components/table-data";
import { PlaceWithTypeSimple } from "@/types";
import { PlaceSortField } from "@/types/sort";
import { capitalize } from "@/utils/strings";
import { Stack } from "@mantine/core";
import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { ColumnDef } from "@tanstack/react-table";

type TableState = {
  globalFilter: string;
  sorting: { id: string; desc: boolean } | null;
  pagination: { pageIndex: number; pageSize: number };
};

const columns: ColumnDef<PlaceWithTypeSimple, unknown>[] = [
  {
    accessorKey: "name",
    header: "Name",
    cell: ({ row }) => (
      <TableData.Text fw={500}>{row.original.name}</TableData.Text>
    ),
    size: 400,
  },
  {
    accessorKey: "type",
    header: "Type",
    cell: ({ row }) => capitalize(row.original.place_type?.name || ""),
    size: 150,
  },
  {
    accessorKey: "parent",
    header: "Parent",
    cell: ({ row }) =>
      row.original.parent?.name ? (
        row.original.parent.name
      ) : (
        <TableData.Text c="dimmed" fs="italic">
          None
        </TableData.Text>
      ),
    size: 300,
  },
];

export const Route = createFileRoute("/places/")({
  component: PlacesPage,
});

function PlacesPage() {
  const navigate = useNavigate();

  const fetchTableData = async (state: TableState) => {
    const response = await fetchPlaces({
      page: state.pagination.pageIndex + 1,
      query: state.globalFilter,
      sortConfig: state.sorting
        ? {
            field: state.sorting.id as PlaceSortField,
            direction: state.sorting.desc ? "desc" : "asc",
          }
        : { field: "name", direction: "asc" },
    });

    return {
      data: response.data,
      total: response.total ?? 0,
    };
  };

  const handleRowClick = (place: PlaceWithTypeSimple) => {
    navigate({ to: `/places/${place.id}` });
  };

  return (
    <Stack>
      <PageHeader title="Places" />

      <TableData<PlaceWithTypeSimple>
        queryKey={["places"]}
        fetchData={fetchTableData}
        columns={columns}
        defaultSorting={{ id: "name", desc: false }}
        onRowClick={handleRowClick}
      >
        <TableData.Toolbar>
          <TableData.AddButton to="/places/new" />
          <TableData.Search placeholder="Search places" />
          <TableData.SortBy
            sortOptions={[
              { desc: false, id: "name", label: "Name (A - Z)" },
              { desc: true, id: "name", label: "Name (Z - A)" },
              { desc: false, id: "type", label: "Type (A - Z)" },
              { desc: true, id: "type", label: "Type (Z - A)" },
            ]}
          />
        </TableData.Toolbar>

        <TableData.Table />
      </TableData>
    </Stack>
  );
}

export default PlacesPage;
