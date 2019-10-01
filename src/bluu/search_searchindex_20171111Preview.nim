
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SearchIndexClient
## version: 2017-11-11-Preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Client that can be used to query an Azure Search index and upload, merge, or delete documents.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_567659 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567659](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567659): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "search-searchindex"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DocumentsSearchGet_567881 = ref object of OpenApiRestCall_567659
proc url_DocumentsSearchGet_567883(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsSearchGet_567882(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Searches for documents in the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Search-Documents
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JArray
  ##           : The list of OData $orderby expressions by which to sort the results. Each expression can be either a field name or a call to either the geo.distance() or the search.score() functions. Each expression can be followed by asc to indicate ascending, and desc to indicate descending. The default is ascending order. Ties will be broken by the match scores of documents. If no OrderBy is specified, the default sort order is descending by document match score. There can be at most 32 $orderby clauses.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   scoringProfile: JString
  ##                 : The name of a scoring profile to evaluate match scores for matching documents in order to sort the results.
  ##   minimumCoverage: JFloat
  ##                  : A number between 0 and 100 indicating the percentage of the index that must be covered by a search query in order for the query to be reported as a success. This parameter can be useful for ensuring search availability even for services with only one replica. The default is 100.
  ##   scoringParameter: JArray
  ##                   : The list of parameter values to be used in scoring functions (for example, referencePointParameter) using the format name-values. For example, if the scoring profile defines a function with a parameter called 'mylocation' the parameter string would be "mylocation--122.2,44.8" (without the quotes).
  ##   $top: JInt
  ##       : The number of search results to retrieve. This can be used in conjunction with $skip to implement client-side paging of search results. If results are truncated due to server-side paging, the response will include a continuation token that can be used to issue another Search request for the next page of results.
  ##   highlight: JArray
  ##            : The list of field names to use for hit highlights. Only searchable fields can be used for hit highlighting.
  ##   $select: JArray
  ##          : The list of fields to retrieve. If unspecified, all fields marked as retrievable in the schema are included.
  ##   highlightPreTag: JString
  ##                  : A string tag that is prepended to hit highlights. Must be set with highlightPostTag. Default is &lt;em&gt;.
  ##   $skip: JInt
  ##        : The number of search results to skip. This value cannot be greater than 100,000. If you need to scan documents in sequence, but cannot use $skip due to this limitation, consider using $orderby on a totally-ordered key and $filter with a range query instead.
  ##   search: JString
  ##         : A full-text search query expression; Use "*" or omit this parameter to match all documents.
  ##   $count: JBool
  ##         : A value that specifies whether to fetch the total count of results. Default is false. Setting this value to true may have a performance impact. Note that the count returned is an approximation.
  ##   queryType: JString
  ##            : A value that specifies the syntax of the search query. The default is 'simple'. Use 'full' if your query uses the Lucene query syntax.
  ##   searchMode: JString
  ##             : A value that specifies whether any or all of the search terms must be matched in order to count the document as a match.
  ##   $filter: JString
  ##          : The OData $filter expression to apply to the search query.
  ##   facet: JArray
  ##        : The list of facet expressions to apply to the search query. Each facet expression contains a field name, optionally followed by a comma-separated list of name:value pairs.
  ##   highlightPostTag: JString
  ##                   : A string tag that is appended to hit highlights. Must be set with highlightPreTag. Default is &lt;/em&gt;.
  ##   searchFields: JArray
  ##               : The list of field names to include in the full-text search.
  section = newJObject()
  var valid_568043 = query.getOrDefault("$orderby")
  valid_568043 = validateParameter(valid_568043, JArray, required = false,
                                 default = nil)
  if valid_568043 != nil:
    section.add "$orderby", valid_568043
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568044 = query.getOrDefault("api-version")
  valid_568044 = validateParameter(valid_568044, JString, required = true,
                                 default = nil)
  if valid_568044 != nil:
    section.add "api-version", valid_568044
  var valid_568045 = query.getOrDefault("scoringProfile")
  valid_568045 = validateParameter(valid_568045, JString, required = false,
                                 default = nil)
  if valid_568045 != nil:
    section.add "scoringProfile", valid_568045
  var valid_568046 = query.getOrDefault("minimumCoverage")
  valid_568046 = validateParameter(valid_568046, JFloat, required = false,
                                 default = nil)
  if valid_568046 != nil:
    section.add "minimumCoverage", valid_568046
  var valid_568047 = query.getOrDefault("scoringParameter")
  valid_568047 = validateParameter(valid_568047, JArray, required = false,
                                 default = nil)
  if valid_568047 != nil:
    section.add "scoringParameter", valid_568047
  var valid_568048 = query.getOrDefault("$top")
  valid_568048 = validateParameter(valid_568048, JInt, required = false, default = nil)
  if valid_568048 != nil:
    section.add "$top", valid_568048
  var valid_568049 = query.getOrDefault("highlight")
  valid_568049 = validateParameter(valid_568049, JArray, required = false,
                                 default = nil)
  if valid_568049 != nil:
    section.add "highlight", valid_568049
  var valid_568050 = query.getOrDefault("$select")
  valid_568050 = validateParameter(valid_568050, JArray, required = false,
                                 default = nil)
  if valid_568050 != nil:
    section.add "$select", valid_568050
  var valid_568051 = query.getOrDefault("highlightPreTag")
  valid_568051 = validateParameter(valid_568051, JString, required = false,
                                 default = nil)
  if valid_568051 != nil:
    section.add "highlightPreTag", valid_568051
  var valid_568052 = query.getOrDefault("$skip")
  valid_568052 = validateParameter(valid_568052, JInt, required = false, default = nil)
  if valid_568052 != nil:
    section.add "$skip", valid_568052
  var valid_568053 = query.getOrDefault("search")
  valid_568053 = validateParameter(valid_568053, JString, required = false,
                                 default = nil)
  if valid_568053 != nil:
    section.add "search", valid_568053
  var valid_568054 = query.getOrDefault("$count")
  valid_568054 = validateParameter(valid_568054, JBool, required = false, default = nil)
  if valid_568054 != nil:
    section.add "$count", valid_568054
  var valid_568068 = query.getOrDefault("queryType")
  valid_568068 = validateParameter(valid_568068, JString, required = false,
                                 default = newJString("simple"))
  if valid_568068 != nil:
    section.add "queryType", valid_568068
  var valid_568069 = query.getOrDefault("searchMode")
  valid_568069 = validateParameter(valid_568069, JString, required = false,
                                 default = newJString("any"))
  if valid_568069 != nil:
    section.add "searchMode", valid_568069
  var valid_568070 = query.getOrDefault("$filter")
  valid_568070 = validateParameter(valid_568070, JString, required = false,
                                 default = nil)
  if valid_568070 != nil:
    section.add "$filter", valid_568070
  var valid_568071 = query.getOrDefault("facet")
  valid_568071 = validateParameter(valid_568071, JArray, required = false,
                                 default = nil)
  if valid_568071 != nil:
    section.add "facet", valid_568071
  var valid_568072 = query.getOrDefault("highlightPostTag")
  valid_568072 = validateParameter(valid_568072, JString, required = false,
                                 default = nil)
  if valid_568072 != nil:
    section.add "highlightPostTag", valid_568072
  var valid_568073 = query.getOrDefault("searchFields")
  valid_568073 = validateParameter(valid_568073, JArray, required = false,
                                 default = nil)
  if valid_568073 != nil:
    section.add "searchFields", valid_568073
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568074 = header.getOrDefault("client-request-id")
  valid_568074 = validateParameter(valid_568074, JString, required = false,
                                 default = nil)
  if valid_568074 != nil:
    section.add "client-request-id", valid_568074
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568097: Call_DocumentsSearchGet_567881; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for documents in the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Search-Documents
  let valid = call_568097.validator(path, query, header, formData, body)
  let scheme = call_568097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568097.url(scheme.get, call_568097.host, call_568097.base,
                         call_568097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568097, url, valid)

proc call*(call_568168: Call_DocumentsSearchGet_567881; apiVersion: string;
          Orderby: JsonNode = nil; scoringProfile: string = "";
          minimumCoverage: float = 0.0; scoringParameter: JsonNode = nil; Top: int = 0;
          highlight: JsonNode = nil; Select: JsonNode = nil;
          highlightPreTag: string = ""; Skip: int = 0; search: string = "";
          Count: bool = false; queryType: string = "simple"; searchMode: string = "any";
          Filter: string = ""; facet: JsonNode = nil; highlightPostTag: string = "";
          searchFields: JsonNode = nil): Recallable =
  ## documentsSearchGet
  ## Searches for documents in the Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/Search-Documents
  ##   Orderby: JArray
  ##          : The list of OData $orderby expressions by which to sort the results. Each expression can be either a field name or a call to either the geo.distance() or the search.score() functions. Each expression can be followed by asc to indicate ascending, and desc to indicate descending. The default is ascending order. Ties will be broken by the match scores of documents. If no OrderBy is specified, the default sort order is descending by document match score. There can be at most 32 $orderby clauses.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   scoringProfile: string
  ##                 : The name of a scoring profile to evaluate match scores for matching documents in order to sort the results.
  ##   minimumCoverage: float
  ##                  : A number between 0 and 100 indicating the percentage of the index that must be covered by a search query in order for the query to be reported as a success. This parameter can be useful for ensuring search availability even for services with only one replica. The default is 100.
  ##   scoringParameter: JArray
  ##                   : The list of parameter values to be used in scoring functions (for example, referencePointParameter) using the format name-values. For example, if the scoring profile defines a function with a parameter called 'mylocation' the parameter string would be "mylocation--122.2,44.8" (without the quotes).
  ##   Top: int
  ##      : The number of search results to retrieve. This can be used in conjunction with $skip to implement client-side paging of search results. If results are truncated due to server-side paging, the response will include a continuation token that can be used to issue another Search request for the next page of results.
  ##   highlight: JArray
  ##            : The list of field names to use for hit highlights. Only searchable fields can be used for hit highlighting.
  ##   Select: JArray
  ##         : The list of fields to retrieve. If unspecified, all fields marked as retrievable in the schema are included.
  ##   highlightPreTag: string
  ##                  : A string tag that is prepended to hit highlights. Must be set with highlightPostTag. Default is &lt;em&gt;.
  ##   Skip: int
  ##       : The number of search results to skip. This value cannot be greater than 100,000. If you need to scan documents in sequence, but cannot use $skip due to this limitation, consider using $orderby on a totally-ordered key and $filter with a range query instead.
  ##   search: string
  ##         : A full-text search query expression; Use "*" or omit this parameter to match all documents.
  ##   Count: bool
  ##        : A value that specifies whether to fetch the total count of results. Default is false. Setting this value to true may have a performance impact. Note that the count returned is an approximation.
  ##   queryType: string
  ##            : A value that specifies the syntax of the search query. The default is 'simple'. Use 'full' if your query uses the Lucene query syntax.
  ##   searchMode: string
  ##             : A value that specifies whether any or all of the search terms must be matched in order to count the document as a match.
  ##   Filter: string
  ##         : The OData $filter expression to apply to the search query.
  ##   facet: JArray
  ##        : The list of facet expressions to apply to the search query. Each facet expression contains a field name, optionally followed by a comma-separated list of name:value pairs.
  ##   highlightPostTag: string
  ##                   : A string tag that is appended to hit highlights. Must be set with highlightPreTag. Default is &lt;/em&gt;.
  ##   searchFields: JArray
  ##               : The list of field names to include in the full-text search.
  var query_568169 = newJObject()
  if Orderby != nil:
    query_568169.add "$orderby", Orderby
  add(query_568169, "api-version", newJString(apiVersion))
  add(query_568169, "scoringProfile", newJString(scoringProfile))
  add(query_568169, "minimumCoverage", newJFloat(minimumCoverage))
  if scoringParameter != nil:
    query_568169.add "scoringParameter", scoringParameter
  add(query_568169, "$top", newJInt(Top))
  if highlight != nil:
    query_568169.add "highlight", highlight
  if Select != nil:
    query_568169.add "$select", Select
  add(query_568169, "highlightPreTag", newJString(highlightPreTag))
  add(query_568169, "$skip", newJInt(Skip))
  add(query_568169, "search", newJString(search))
  add(query_568169, "$count", newJBool(Count))
  add(query_568169, "queryType", newJString(queryType))
  add(query_568169, "searchMode", newJString(searchMode))
  add(query_568169, "$filter", newJString(Filter))
  if facet != nil:
    query_568169.add "facet", facet
  add(query_568169, "highlightPostTag", newJString(highlightPostTag))
  if searchFields != nil:
    query_568169.add "searchFields", searchFields
  result = call_568168.call(nil, query_568169, nil, nil, nil)

var documentsSearchGet* = Call_DocumentsSearchGet_567881(
    name: "documentsSearchGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/docs", validator: validate_DocumentsSearchGet_567882, base: "",
    url: url_DocumentsSearchGet_567883, schemes: {Scheme.Https})
type
  Call_DocumentsGet_568209 = ref object of OpenApiRestCall_567659
proc url_DocumentsGet_568211(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "key" in path, "`key` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/docs(\'"),
               (kind: VariableSegment, value: "key"),
               (kind: ConstantSegment, value: "\')")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DocumentsGet_568210(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a document from the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/lookup-document
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key: JString (required)
  ##      : The key of the document to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `key` field"
  var valid_568226 = path.getOrDefault("key")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "key", valid_568226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JArray
  ##          : List of field names to retrieve for the document; Any field not retrieved will be missing from the returned document.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568227 = query.getOrDefault("api-version")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "api-version", valid_568227
  var valid_568228 = query.getOrDefault("$select")
  valid_568228 = validateParameter(valid_568228, JArray, required = false,
                                 default = nil)
  if valid_568228 != nil:
    section.add "$select", valid_568228
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568229 = header.getOrDefault("client-request-id")
  valid_568229 = validateParameter(valid_568229, JString, required = false,
                                 default = nil)
  if valid_568229 != nil:
    section.add "client-request-id", valid_568229
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568230: Call_DocumentsGet_568209; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a document from the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/lookup-document
  let valid = call_568230.validator(path, query, header, formData, body)
  let scheme = call_568230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568230.url(scheme.get, call_568230.host, call_568230.base,
                         call_568230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568230, url, valid)

proc call*(call_568231: Call_DocumentsGet_568209; apiVersion: string; key: string;
          Select: JsonNode = nil): Recallable =
  ## documentsGet
  ## Retrieves a document from the Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/lookup-document
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: JArray
  ##         : List of field names to retrieve for the document; Any field not retrieved will be missing from the returned document.
  ##   key: string (required)
  ##      : The key of the document to retrieve.
  var path_568232 = newJObject()
  var query_568233 = newJObject()
  add(query_568233, "api-version", newJString(apiVersion))
  if Select != nil:
    query_568233.add "$select", Select
  add(path_568232, "key", newJString(key))
  result = call_568231.call(path_568232, query_568233, nil, nil, nil)

var documentsGet* = Call_DocumentsGet_568209(name: "documentsGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/docs(\'{key}\')",
    validator: validate_DocumentsGet_568210, base: "", url: url_DocumentsGet_568211,
    schemes: {Scheme.Https})
type
  Call_DocumentsCount_568234 = ref object of OpenApiRestCall_567659
proc url_DocumentsCount_568236(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsCount_568235(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Queries the number of documents in the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Count-Documents
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568237 = query.getOrDefault("api-version")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "api-version", valid_568237
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568238 = header.getOrDefault("client-request-id")
  valid_568238 = validateParameter(valid_568238, JString, required = false,
                                 default = nil)
  if valid_568238 != nil:
    section.add "client-request-id", valid_568238
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568239: Call_DocumentsCount_568234; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Queries the number of documents in the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Count-Documents
  let valid = call_568239.validator(path, query, header, formData, body)
  let scheme = call_568239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568239.url(scheme.get, call_568239.host, call_568239.base,
                         call_568239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568239, url, valid)

proc call*(call_568240: Call_DocumentsCount_568234; apiVersion: string): Recallable =
  ## documentsCount
  ## Queries the number of documents in the Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/Count-Documents
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568241 = newJObject()
  add(query_568241, "api-version", newJString(apiVersion))
  result = call_568240.call(nil, query_568241, nil, nil, nil)

var documentsCount* = Call_DocumentsCount_568234(name: "documentsCount",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/docs/$count",
    validator: validate_DocumentsCount_568235, base: "", url: url_DocumentsCount_568236,
    schemes: {Scheme.Https})
type
  Call_DocumentsAutocompleteGet_568242 = ref object of OpenApiRestCall_567659
proc url_DocumentsAutocompleteGet_568244(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsAutocompleteGet_568243(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Autocompletes incomplete query terms based on input text and matching terms in the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/autocomplete
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   minimumCoverage: JFloat
  ##                  : A number between 0 and 100 indicating the percentage of the index that must be covered by an autocomplete query in order for the query to be reported as a success. This parameter can be useful for ensuring search availability even for services with only one replica. The default is 80.
  ##   autocompleteMode: JString
  ##                   : Specifies the mode for Autocomplete. The default is 'oneTerm'. Use 'twoTerms' to get shingles and 'oneTermWithContext' to use the current context while producing auto-completed terms.
  ##   $top: JInt
  ##       : The number of auto-completed terms to retrieve. This must be a value between 1 and 100. The default is 5.
  ##   fuzzy: JBool
  ##        : A value indicating whether to use fuzzy matching for the autocomplete query. Default is false. When set to true, the query will find terms even if there's a substituted or missing character in the search text. While this provides a better experience in some scenarios, it comes at a performance cost as fuzzy autocomplete queries are slower and consume more resources.
  ##   highlightPreTag: JString
  ##                  : A string tag that is prepended to hit highlights. Must be set with highlightPostTag. If omitted, hit highlighting is disabled.
  ##   search: JString (required)
  ##         : The incomplete term which should be auto-completed.
  ##   $filter: JString
  ##          : An OData expression that filters the documents used to produce completed terms for the Autocomplete result.
  ##   highlightPostTag: JString
  ##                   : A string tag that is appended to hit highlights. Must be set with highlightPreTag. If omitted, hit highlighting is disabled.
  ##   suggesterName: JString (required)
  ##                : The name of the suggester as specified in the suggesters collection that's part of the index definition.
  ##   searchFields: JArray
  ##               : The list of field names to consider when querying for auto-completed terms. Target fields must be included in the specified suggester.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568245 = query.getOrDefault("api-version")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "api-version", valid_568245
  var valid_568246 = query.getOrDefault("minimumCoverage")
  valid_568246 = validateParameter(valid_568246, JFloat, required = false,
                                 default = nil)
  if valid_568246 != nil:
    section.add "minimumCoverage", valid_568246
  var valid_568247 = query.getOrDefault("autocompleteMode")
  valid_568247 = validateParameter(valid_568247, JString, required = false,
                                 default = newJString("oneTerm"))
  if valid_568247 != nil:
    section.add "autocompleteMode", valid_568247
  var valid_568248 = query.getOrDefault("$top")
  valid_568248 = validateParameter(valid_568248, JInt, required = false, default = nil)
  if valid_568248 != nil:
    section.add "$top", valid_568248
  var valid_568249 = query.getOrDefault("fuzzy")
  valid_568249 = validateParameter(valid_568249, JBool, required = false, default = nil)
  if valid_568249 != nil:
    section.add "fuzzy", valid_568249
  var valid_568250 = query.getOrDefault("highlightPreTag")
  valid_568250 = validateParameter(valid_568250, JString, required = false,
                                 default = nil)
  if valid_568250 != nil:
    section.add "highlightPreTag", valid_568250
  var valid_568251 = query.getOrDefault("search")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "search", valid_568251
  var valid_568252 = query.getOrDefault("$filter")
  valid_568252 = validateParameter(valid_568252, JString, required = false,
                                 default = nil)
  if valid_568252 != nil:
    section.add "$filter", valid_568252
  var valid_568253 = query.getOrDefault("highlightPostTag")
  valid_568253 = validateParameter(valid_568253, JString, required = false,
                                 default = nil)
  if valid_568253 != nil:
    section.add "highlightPostTag", valid_568253
  var valid_568254 = query.getOrDefault("suggesterName")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "suggesterName", valid_568254
  var valid_568255 = query.getOrDefault("searchFields")
  valid_568255 = validateParameter(valid_568255, JArray, required = false,
                                 default = nil)
  if valid_568255 != nil:
    section.add "searchFields", valid_568255
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568256 = header.getOrDefault("client-request-id")
  valid_568256 = validateParameter(valid_568256, JString, required = false,
                                 default = nil)
  if valid_568256 != nil:
    section.add "client-request-id", valid_568256
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568257: Call_DocumentsAutocompleteGet_568242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Autocompletes incomplete query terms based on input text and matching terms in the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/autocomplete
  let valid = call_568257.validator(path, query, header, formData, body)
  let scheme = call_568257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568257.url(scheme.get, call_568257.host, call_568257.base,
                         call_568257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568257, url, valid)

proc call*(call_568258: Call_DocumentsAutocompleteGet_568242; apiVersion: string;
          search: string; suggesterName: string; minimumCoverage: float = 0.0;
          autocompleteMode: string = "oneTerm"; Top: int = 0; fuzzy: bool = false;
          highlightPreTag: string = ""; Filter: string = "";
          highlightPostTag: string = ""; searchFields: JsonNode = nil): Recallable =
  ## documentsAutocompleteGet
  ## Autocompletes incomplete query terms based on input text and matching terms in the Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/autocomplete
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   minimumCoverage: float
  ##                  : A number between 0 and 100 indicating the percentage of the index that must be covered by an autocomplete query in order for the query to be reported as a success. This parameter can be useful for ensuring search availability even for services with only one replica. The default is 80.
  ##   autocompleteMode: string
  ##                   : Specifies the mode for Autocomplete. The default is 'oneTerm'. Use 'twoTerms' to get shingles and 'oneTermWithContext' to use the current context while producing auto-completed terms.
  ##   Top: int
  ##      : The number of auto-completed terms to retrieve. This must be a value between 1 and 100. The default is 5.
  ##   fuzzy: bool
  ##        : A value indicating whether to use fuzzy matching for the autocomplete query. Default is false. When set to true, the query will find terms even if there's a substituted or missing character in the search text. While this provides a better experience in some scenarios, it comes at a performance cost as fuzzy autocomplete queries are slower and consume more resources.
  ##   highlightPreTag: string
  ##                  : A string tag that is prepended to hit highlights. Must be set with highlightPostTag. If omitted, hit highlighting is disabled.
  ##   search: string (required)
  ##         : The incomplete term which should be auto-completed.
  ##   Filter: string
  ##         : An OData expression that filters the documents used to produce completed terms for the Autocomplete result.
  ##   highlightPostTag: string
  ##                   : A string tag that is appended to hit highlights. Must be set with highlightPreTag. If omitted, hit highlighting is disabled.
  ##   suggesterName: string (required)
  ##                : The name of the suggester as specified in the suggesters collection that's part of the index definition.
  ##   searchFields: JArray
  ##               : The list of field names to consider when querying for auto-completed terms. Target fields must be included in the specified suggester.
  var query_568259 = newJObject()
  add(query_568259, "api-version", newJString(apiVersion))
  add(query_568259, "minimumCoverage", newJFloat(minimumCoverage))
  add(query_568259, "autocompleteMode", newJString(autocompleteMode))
  add(query_568259, "$top", newJInt(Top))
  add(query_568259, "fuzzy", newJBool(fuzzy))
  add(query_568259, "highlightPreTag", newJString(highlightPreTag))
  add(query_568259, "search", newJString(search))
  add(query_568259, "$filter", newJString(Filter))
  add(query_568259, "highlightPostTag", newJString(highlightPostTag))
  add(query_568259, "suggesterName", newJString(suggesterName))
  if searchFields != nil:
    query_568259.add "searchFields", searchFields
  result = call_568258.call(nil, query_568259, nil, nil, nil)

var documentsAutocompleteGet* = Call_DocumentsAutocompleteGet_568242(
    name: "documentsAutocompleteGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/docs/search.autocomplete",
    validator: validate_DocumentsAutocompleteGet_568243, base: "",
    url: url_DocumentsAutocompleteGet_568244, schemes: {Scheme.Https})
type
  Call_DocumentsIndex_568260 = ref object of OpenApiRestCall_567659
proc url_DocumentsIndex_568262(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsIndex_568261(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Sends a batch of document write actions to the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/addupdate-or-delete-documents
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568280 = query.getOrDefault("api-version")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "api-version", valid_568280
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568281 = header.getOrDefault("client-request-id")
  valid_568281 = validateParameter(valid_568281, JString, required = false,
                                 default = nil)
  if valid_568281 != nil:
    section.add "client-request-id", valid_568281
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   batch: JObject (required)
  ##        : The batch of index actions.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568283: Call_DocumentsIndex_568260; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a batch of document write actions to the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/addupdate-or-delete-documents
  let valid = call_568283.validator(path, query, header, formData, body)
  let scheme = call_568283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568283.url(scheme.get, call_568283.host, call_568283.base,
                         call_568283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568283, url, valid)

proc call*(call_568284: Call_DocumentsIndex_568260; apiVersion: string;
          batch: JsonNode): Recallable =
  ## documentsIndex
  ## Sends a batch of document write actions to the Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/addupdate-or-delete-documents
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   batch: JObject (required)
  ##        : The batch of index actions.
  var query_568285 = newJObject()
  var body_568286 = newJObject()
  add(query_568285, "api-version", newJString(apiVersion))
  if batch != nil:
    body_568286 = batch
  result = call_568284.call(nil, query_568285, nil, nil, body_568286)

var documentsIndex* = Call_DocumentsIndex_568260(name: "documentsIndex",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/docs/search.index",
    validator: validate_DocumentsIndex_568261, base: "", url: url_DocumentsIndex_568262,
    schemes: {Scheme.Https})
type
  Call_DocumentsAutocompletePost_568287 = ref object of OpenApiRestCall_567659
proc url_DocumentsAutocompletePost_568289(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsAutocompletePost_568288(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Autocompletes incomplete query terms based on input text and matching terms in the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/autocomplete
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568290 = query.getOrDefault("api-version")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "api-version", valid_568290
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568291 = header.getOrDefault("client-request-id")
  valid_568291 = validateParameter(valid_568291, JString, required = false,
                                 default = nil)
  if valid_568291 != nil:
    section.add "client-request-id", valid_568291
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   autocompleteRequest: JObject (required)
  ##                      : The definition of the Autocomplete request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568293: Call_DocumentsAutocompletePost_568287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Autocompletes incomplete query terms based on input text and matching terms in the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/autocomplete
  let valid = call_568293.validator(path, query, header, formData, body)
  let scheme = call_568293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568293.url(scheme.get, call_568293.host, call_568293.base,
                         call_568293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568293, url, valid)

proc call*(call_568294: Call_DocumentsAutocompletePost_568287; apiVersion: string;
          autocompleteRequest: JsonNode): Recallable =
  ## documentsAutocompletePost
  ## Autocompletes incomplete query terms based on input text and matching terms in the Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/autocomplete
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   autocompleteRequest: JObject (required)
  ##                      : The definition of the Autocomplete request.
  var query_568295 = newJObject()
  var body_568296 = newJObject()
  add(query_568295, "api-version", newJString(apiVersion))
  if autocompleteRequest != nil:
    body_568296 = autocompleteRequest
  result = call_568294.call(nil, query_568295, nil, nil, body_568296)

var documentsAutocompletePost* = Call_DocumentsAutocompletePost_568287(
    name: "documentsAutocompletePost", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/docs/search.post.autocomplete",
    validator: validate_DocumentsAutocompletePost_568288, base: "",
    url: url_DocumentsAutocompletePost_568289, schemes: {Scheme.Https})
type
  Call_DocumentsSearchPost_568297 = ref object of OpenApiRestCall_567659
proc url_DocumentsSearchPost_568299(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsSearchPost_568298(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Searches for documents in the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Search-Documents
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568300 = query.getOrDefault("api-version")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "api-version", valid_568300
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568301 = header.getOrDefault("client-request-id")
  valid_568301 = validateParameter(valid_568301, JString, required = false,
                                 default = nil)
  if valid_568301 != nil:
    section.add "client-request-id", valid_568301
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   searchRequest: JObject (required)
  ##                : The definition of the Search request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568303: Call_DocumentsSearchPost_568297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for documents in the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Search-Documents
  let valid = call_568303.validator(path, query, header, formData, body)
  let scheme = call_568303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568303.url(scheme.get, call_568303.host, call_568303.base,
                         call_568303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568303, url, valid)

proc call*(call_568304: Call_DocumentsSearchPost_568297; apiVersion: string;
          searchRequest: JsonNode): Recallable =
  ## documentsSearchPost
  ## Searches for documents in the Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/Search-Documents
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   searchRequest: JObject (required)
  ##                : The definition of the Search request.
  var query_568305 = newJObject()
  var body_568306 = newJObject()
  add(query_568305, "api-version", newJString(apiVersion))
  if searchRequest != nil:
    body_568306 = searchRequest
  result = call_568304.call(nil, query_568305, nil, nil, body_568306)

var documentsSearchPost* = Call_DocumentsSearchPost_568297(
    name: "documentsSearchPost", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/docs/search.post.search", validator: validate_DocumentsSearchPost_568298,
    base: "", url: url_DocumentsSearchPost_568299, schemes: {Scheme.Https})
type
  Call_DocumentsSuggestPost_568307 = ref object of OpenApiRestCall_567659
proc url_DocumentsSuggestPost_568309(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsSuggestPost_568308(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Suggests documents in the Azure Search index that match the given partial query text.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/suggestions
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568310 = query.getOrDefault("api-version")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "api-version", valid_568310
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568311 = header.getOrDefault("client-request-id")
  valid_568311 = validateParameter(valid_568311, JString, required = false,
                                 default = nil)
  if valid_568311 != nil:
    section.add "client-request-id", valid_568311
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   suggestRequest: JObject (required)
  ##                 : The Suggest request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568313: Call_DocumentsSuggestPost_568307; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suggests documents in the Azure Search index that match the given partial query text.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/suggestions
  let valid = call_568313.validator(path, query, header, formData, body)
  let scheme = call_568313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568313.url(scheme.get, call_568313.host, call_568313.base,
                         call_568313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568313, url, valid)

proc call*(call_568314: Call_DocumentsSuggestPost_568307; apiVersion: string;
          suggestRequest: JsonNode): Recallable =
  ## documentsSuggestPost
  ## Suggests documents in the Azure Search index that match the given partial query text.
  ## https://docs.microsoft.com/rest/api/searchservice/suggestions
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   suggestRequest: JObject (required)
  ##                 : The Suggest request.
  var query_568315 = newJObject()
  var body_568316 = newJObject()
  add(query_568315, "api-version", newJString(apiVersion))
  if suggestRequest != nil:
    body_568316 = suggestRequest
  result = call_568314.call(nil, query_568315, nil, nil, body_568316)

var documentsSuggestPost* = Call_DocumentsSuggestPost_568307(
    name: "documentsSuggestPost", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/docs/search.post.suggest", validator: validate_DocumentsSuggestPost_568308,
    base: "", url: url_DocumentsSuggestPost_568309, schemes: {Scheme.Https})
type
  Call_DocumentsSuggestGet_568317 = ref object of OpenApiRestCall_567659
proc url_DocumentsSuggestGet_568319(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsSuggestGet_568318(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Suggests documents in the Azure Search index that match the given partial query text.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/suggestions
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JArray
  ##           : The list of OData $orderby expressions by which to sort the results. Each expression can be either a field name or a call to either the geo.distance() or the search.score() functions. Each expression can be followed by asc to indicate ascending, or desc to indicate descending. The default is ascending order. Ties will be broken by the match scores of documents. If no $orderby is specified, the default sort order is descending by document match score. There can be at most 32 $orderby clauses.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   minimumCoverage: JFloat
  ##                  : A number between 0 and 100 indicating the percentage of the index that must be covered by a suggestions query in order for the query to be reported as a success. This parameter can be useful for ensuring search availability even for services with only one replica. The default is 80.
  ##   $top: JInt
  ##       : The number of suggestions to retrieve. The value must be a number between 1 and 100. The default is 5.
  ##   $select: JArray
  ##          : The list of fields to retrieve. If unspecified, only the key field will be included in the results.
  ##   fuzzy: JBool
  ##        : A value indicating whether to use fuzzy matching for the suggestions query. Default is false. When set to true, the query will find terms even if there's a substituted or missing character in the search text. While this provides a better experience in some scenarios, it comes at a performance cost as fuzzy suggestions queries are slower and consume more resources.
  ##   highlightPreTag: JString
  ##                  : A string tag that is prepended to hit highlights. Must be set with highlightPostTag. If omitted, hit highlighting of suggestions is disabled.
  ##   search: JString (required)
  ##         : The search text to use to suggest documents. Must be at least 1 character, and no more than 100 characters.
  ##   $filter: JString
  ##          : An OData expression that filters the documents considered for suggestions.
  ##   highlightPostTag: JString
  ##                   : A string tag that is appended to hit highlights. Must be set with highlightPreTag. If omitted, hit highlighting of suggestions is disabled.
  ##   suggesterName: JString (required)
  ##                : The name of the suggester as specified in the suggesters collection that's part of the index definition.
  ##   searchFields: JArray
  ##               : The list of field names to search for the specified search text. Target fields must be included in the specified suggester.
  section = newJObject()
  var valid_568320 = query.getOrDefault("$orderby")
  valid_568320 = validateParameter(valid_568320, JArray, required = false,
                                 default = nil)
  if valid_568320 != nil:
    section.add "$orderby", valid_568320
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568321 = query.getOrDefault("api-version")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "api-version", valid_568321
  var valid_568322 = query.getOrDefault("minimumCoverage")
  valid_568322 = validateParameter(valid_568322, JFloat, required = false,
                                 default = nil)
  if valid_568322 != nil:
    section.add "minimumCoverage", valid_568322
  var valid_568323 = query.getOrDefault("$top")
  valid_568323 = validateParameter(valid_568323, JInt, required = false, default = nil)
  if valid_568323 != nil:
    section.add "$top", valid_568323
  var valid_568324 = query.getOrDefault("$select")
  valid_568324 = validateParameter(valid_568324, JArray, required = false,
                                 default = nil)
  if valid_568324 != nil:
    section.add "$select", valid_568324
  var valid_568325 = query.getOrDefault("fuzzy")
  valid_568325 = validateParameter(valid_568325, JBool, required = false, default = nil)
  if valid_568325 != nil:
    section.add "fuzzy", valid_568325
  var valid_568326 = query.getOrDefault("highlightPreTag")
  valid_568326 = validateParameter(valid_568326, JString, required = false,
                                 default = nil)
  if valid_568326 != nil:
    section.add "highlightPreTag", valid_568326
  var valid_568327 = query.getOrDefault("search")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "search", valid_568327
  var valid_568328 = query.getOrDefault("$filter")
  valid_568328 = validateParameter(valid_568328, JString, required = false,
                                 default = nil)
  if valid_568328 != nil:
    section.add "$filter", valid_568328
  var valid_568329 = query.getOrDefault("highlightPostTag")
  valid_568329 = validateParameter(valid_568329, JString, required = false,
                                 default = nil)
  if valid_568329 != nil:
    section.add "highlightPostTag", valid_568329
  var valid_568330 = query.getOrDefault("suggesterName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "suggesterName", valid_568330
  var valid_568331 = query.getOrDefault("searchFields")
  valid_568331 = validateParameter(valid_568331, JArray, required = false,
                                 default = nil)
  if valid_568331 != nil:
    section.add "searchFields", valid_568331
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568332 = header.getOrDefault("client-request-id")
  valid_568332 = validateParameter(valid_568332, JString, required = false,
                                 default = nil)
  if valid_568332 != nil:
    section.add "client-request-id", valid_568332
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568333: Call_DocumentsSuggestGet_568317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suggests documents in the Azure Search index that match the given partial query text.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/suggestions
  let valid = call_568333.validator(path, query, header, formData, body)
  let scheme = call_568333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568333.url(scheme.get, call_568333.host, call_568333.base,
                         call_568333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568333, url, valid)

proc call*(call_568334: Call_DocumentsSuggestGet_568317; apiVersion: string;
          search: string; suggesterName: string; Orderby: JsonNode = nil;
          minimumCoverage: float = 0.0; Top: int = 0; Select: JsonNode = nil;
          fuzzy: bool = false; highlightPreTag: string = ""; Filter: string = "";
          highlightPostTag: string = ""; searchFields: JsonNode = nil): Recallable =
  ## documentsSuggestGet
  ## Suggests documents in the Azure Search index that match the given partial query text.
  ## https://docs.microsoft.com/rest/api/searchservice/suggestions
  ##   Orderby: JArray
  ##          : The list of OData $orderby expressions by which to sort the results. Each expression can be either a field name or a call to either the geo.distance() or the search.score() functions. Each expression can be followed by asc to indicate ascending, or desc to indicate descending. The default is ascending order. Ties will be broken by the match scores of documents. If no $orderby is specified, the default sort order is descending by document match score. There can be at most 32 $orderby clauses.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   minimumCoverage: float
  ##                  : A number between 0 and 100 indicating the percentage of the index that must be covered by a suggestions query in order for the query to be reported as a success. This parameter can be useful for ensuring search availability even for services with only one replica. The default is 80.
  ##   Top: int
  ##      : The number of suggestions to retrieve. The value must be a number between 1 and 100. The default is 5.
  ##   Select: JArray
  ##         : The list of fields to retrieve. If unspecified, only the key field will be included in the results.
  ##   fuzzy: bool
  ##        : A value indicating whether to use fuzzy matching for the suggestions query. Default is false. When set to true, the query will find terms even if there's a substituted or missing character in the search text. While this provides a better experience in some scenarios, it comes at a performance cost as fuzzy suggestions queries are slower and consume more resources.
  ##   highlightPreTag: string
  ##                  : A string tag that is prepended to hit highlights. Must be set with highlightPostTag. If omitted, hit highlighting of suggestions is disabled.
  ##   search: string (required)
  ##         : The search text to use to suggest documents. Must be at least 1 character, and no more than 100 characters.
  ##   Filter: string
  ##         : An OData expression that filters the documents considered for suggestions.
  ##   highlightPostTag: string
  ##                   : A string tag that is appended to hit highlights. Must be set with highlightPreTag. If omitted, hit highlighting of suggestions is disabled.
  ##   suggesterName: string (required)
  ##                : The name of the suggester as specified in the suggesters collection that's part of the index definition.
  ##   searchFields: JArray
  ##               : The list of field names to search for the specified search text. Target fields must be included in the specified suggester.
  var query_568335 = newJObject()
  if Orderby != nil:
    query_568335.add "$orderby", Orderby
  add(query_568335, "api-version", newJString(apiVersion))
  add(query_568335, "minimumCoverage", newJFloat(minimumCoverage))
  add(query_568335, "$top", newJInt(Top))
  if Select != nil:
    query_568335.add "$select", Select
  add(query_568335, "fuzzy", newJBool(fuzzy))
  add(query_568335, "highlightPreTag", newJString(highlightPreTag))
  add(query_568335, "search", newJString(search))
  add(query_568335, "$filter", newJString(Filter))
  add(query_568335, "highlightPostTag", newJString(highlightPostTag))
  add(query_568335, "suggesterName", newJString(suggesterName))
  if searchFields != nil:
    query_568335.add "searchFields", searchFields
  result = call_568334.call(nil, query_568335, nil, nil, nil)

var documentsSuggestGet* = Call_DocumentsSuggestGet_568317(
    name: "documentsSuggestGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/docs/search.suggest", validator: validate_DocumentsSuggestGet_568318,
    base: "", url: url_DocumentsSuggestGet_568319, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
