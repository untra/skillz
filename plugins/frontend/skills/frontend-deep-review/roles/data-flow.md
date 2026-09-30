# Data Flow (DF)

Expands: FE5, FE7

## Reading order

1. The diff, marking every `useQuery`, `useMutation`, query key, `API.*` or `fetch` call, and `localStorage`/`sessionStorage` access.
2. The query definitions (for example `api/queries/`) used by each mark.
3. The whole view for each query, to walk the loading, error, empty, and refetch states.

## Checkpoints

### DF1 Direct fetching (`blocking`)
Flag when: a component calls an `API` function or `fetch` directly, or manages server data with `useState` plus `useEffect`.
Not a finding: fetching inside a query or mutation function.

### DF2 Query keys (`should-fix`)
Flag when: a query key is re-typed as a string or array literal in a component, story, or test instead of importing the exported constant or key factory.
Not a finding: the key's own definition in the queries module.

### DF3 Loading vs fetching (`should-fix`)
Flag when: `isLoading || isFetching` gates rendering, or valid cached data is blanked or replaced by a spinner during a background refetch.
Not a finding: a subtle refetch indicator alongside the existing data.

### DF4 Mutation invalidation (`blocking`)
Flag when: a mutation does not invalidate or update every affected query, including on partial-failure paths of chained mutations.
Not a finding: optimistic updates that are rolled back and invalidated on settle.

### DF5 Mutation error handling (`should-fix`)
Flag when: `mutateAsync()` is wrapped in a `try/catch` with an empty or log-only catch, or `mutateAsync` is used where `mutate()` with callbacks would do.
Not a finding: `mutateAsync` whose result drives control flow and whose errors are surfaced.

### DF6 UI state matrix (`should-fix`)
Flag when: a view rendering server data lacks a loading state, an actionable error state, or a deliberate empty state.
Not a finding: states handled by a shared wrapper the view renders through.

### DF7 Clobbered user state (`blocking`)
Flag when: a background refetch or query data change reinitializes form state, selections, scroll position, or in-progress edits.
Not a finding: an explicit reset after a successful submit.

### DF8 Pagination (`should-fix`)
Flag when: a list or table of server data that can grow unbounded is fetched and rendered without pagination, or the API cannot paginate it safely.
Not a finding: bounded lists (enums, small config sets).

### DF9 Browser storage (`should-fix`)
Flag when: `localStorage`/`sessionStorage` access lacks try/catch, keys are unversioned or unnamespaced, parsed values are not validated, server data is cached in storage instead of the query cache, or cross-tab changes are ignored where they matter.
Not a finding: per-user UI preferences read through an existing storage helper.
