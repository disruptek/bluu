
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: SearchIndexClient
## version: 2019-05-06
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

  OpenApiRestCall_563557 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563557](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563557): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "search-searchindex"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DocumentsSearchGet_563779 = ref object of OpenApiRestCall_563557
proc url_DocumentsSearchGet_563781(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsSearchGet_563780(path: JsonNode; query: JsonNode;
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
  ##   $top: JInt
  ##       : The number of search results to retrieve. This can be used in conjunction with $skip to implement client-side paging of search results. If results are truncated due to server-side paging, the response will include a continuation token that can be used to issue another Search request for the next page of results.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JArray
  ##          : The list of fields to retrieve. If unspecified, all fields marked as retrievable in the schema are included.
  ##   searchMode: JString
  ##             : A value that specifies whether any or all of the search terms must be matched in order to count the document as a match.
  ##   minimumCoverage: JFloat
  ##                  : A number between 0 and 100 indicating the percentage of the index that must be covered by a search query in order for the query to be reported as a success. This parameter can be useful for ensuring search availability even for services with only one replica. The default is 100.
  ##   $count: JBool
  ##         : A value that specifies whether to fetch the total count of results. Default is false. Setting this value to true may have a performance impact. Note that the count returned is an approximation.
  ##   queryType: JString
  ##            : A value that specifies the syntax of the search query. The default is 'simple'. Use 'full' if your query uses the Lucene query syntax.
  ##   $orderby: JArray
  ##           : The list of OData $orderby expressions by which to sort the results. Each expression can be either a field name or a call to either the geo.distance() or the search.score() functions. Each expression can be followed by asc to indicate ascending, and desc to indicate descending. The default is ascending order. Ties will be broken by the match scores of documents. If no OrderBy is specified, the default sort order is descending by document match score. There can be at most 32 $orderby clauses.
  ##   $skip: JInt
  ##        : The number of search results to skip. This value cannot be greater than 100,000. If you need to scan documents in sequence, but cannot use $skip due to this limitation, consider using $orderby on a totally-ordered key and $filter with a range query instead.
  ##   highlightPostTag: JString
  ##                   : A string tag that is appended to hit highlights. Must be set with highlightPreTag. Default is &lt;/em&gt;.
  ##   $filter: JString
  ##          : The OData $filter expression to apply to the search query.
  ##   searchFields: JArray
  ##               : The list of field names to which to scope the full-text search. When using fielded search (fieldName:searchExpression) in a full Lucene query, the field names of each fielded search expression take precedence over any field names listed in this parameter.
  ##   highlightPreTag: JString
  ##                  : A string tag that is prepended to hit highlights. Must be set with highlightPostTag. Default is &lt;em&gt;.
  ##   facet: JArray
  ##        : The list of facet expressions to apply to the search query. Each facet expression contains a field name, optionally followed by a comma-separated list of name:value pairs.
  ##   scoringParameter: JArray
  ##                   : The list of parameter values to be used in scoring functions (for example, referencePointParameter) using the format name-values. For example, if the scoring profile defines a function with a parameter called 'mylocation' the parameter string would be "mylocation--122.2,44.8" (without the quotes).
  ##   search: JString
  ##         : A full-text search query expression; Use "*" or omit this parameter to match all documents.
  ##   highlight: JArray
  ##            : The list of field names to use for hit highlights. Only searchable fields can be used for hit highlighting.
  ##   scoringProfile: JString
  ##                 : The name of a scoring profile to evaluate match scores for matching documents in order to sort the results.
  section = newJObject()
  var valid_563943 = query.getOrDefault("$top")
  valid_563943 = validateParameter(valid_563943, JInt, required = false, default = nil)
  if valid_563943 != nil:
    section.add "$top", valid_563943
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563944 = query.getOrDefault("api-version")
  valid_563944 = validateParameter(valid_563944, JString, required = true,
                                 default = nil)
  if valid_563944 != nil:
    section.add "api-version", valid_563944
  var valid_563945 = query.getOrDefault("$select")
  valid_563945 = validateParameter(valid_563945, JArray, required = false,
                                 default = nil)
  if valid_563945 != nil:
    section.add "$select", valid_563945
  var valid_563959 = query.getOrDefault("searchMode")
  valid_563959 = validateParameter(valid_563959, JString, required = false,
                                 default = newJString("any"))
  if valid_563959 != nil:
    section.add "searchMode", valid_563959
  var valid_563960 = query.getOrDefault("minimumCoverage")
  valid_563960 = validateParameter(valid_563960, JFloat, required = false,
                                 default = nil)
  if valid_563960 != nil:
    section.add "minimumCoverage", valid_563960
  var valid_563961 = query.getOrDefault("$count")
  valid_563961 = validateParameter(valid_563961, JBool, required = false, default = nil)
  if valid_563961 != nil:
    section.add "$count", valid_563961
  var valid_563962 = query.getOrDefault("queryType")
  valid_563962 = validateParameter(valid_563962, JString, required = false,
                                 default = newJString("simple"))
  if valid_563962 != nil:
    section.add "queryType", valid_563962
  var valid_563963 = query.getOrDefault("$orderby")
  valid_563963 = validateParameter(valid_563963, JArray, required = false,
                                 default = nil)
  if valid_563963 != nil:
    section.add "$orderby", valid_563963
  var valid_563964 = query.getOrDefault("$skip")
  valid_563964 = validateParameter(valid_563964, JInt, required = false, default = nil)
  if valid_563964 != nil:
    section.add "$skip", valid_563964
  var valid_563965 = query.getOrDefault("highlightPostTag")
  valid_563965 = validateParameter(valid_563965, JString, required = false,
                                 default = nil)
  if valid_563965 != nil:
    section.add "highlightPostTag", valid_563965
  var valid_563966 = query.getOrDefault("$filter")
  valid_563966 = validateParameter(valid_563966, JString, required = false,
                                 default = nil)
  if valid_563966 != nil:
    section.add "$filter", valid_563966
  var valid_563967 = query.getOrDefault("searchFields")
  valid_563967 = validateParameter(valid_563967, JArray, required = false,
                                 default = nil)
  if valid_563967 != nil:
    section.add "searchFields", valid_563967
  var valid_563968 = query.getOrDefault("highlightPreTag")
  valid_563968 = validateParameter(valid_563968, JString, required = false,
                                 default = nil)
  if valid_563968 != nil:
    section.add "highlightPreTag", valid_563968
  var valid_563969 = query.getOrDefault("facet")
  valid_563969 = validateParameter(valid_563969, JArray, required = false,
                                 default = nil)
  if valid_563969 != nil:
    section.add "facet", valid_563969
  var valid_563970 = query.getOrDefault("scoringParameter")
  valid_563970 = validateParameter(valid_563970, JArray, required = false,
                                 default = nil)
  if valid_563970 != nil:
    section.add "scoringParameter", valid_563970
  var valid_563971 = query.getOrDefault("search")
  valid_563971 = validateParameter(valid_563971, JString, required = false,
                                 default = nil)
  if valid_563971 != nil:
    section.add "search", valid_563971
  var valid_563972 = query.getOrDefault("highlight")
  valid_563972 = validateParameter(valid_563972, JArray, required = false,
                                 default = nil)
  if valid_563972 != nil:
    section.add "highlight", valid_563972
  var valid_563973 = query.getOrDefault("scoringProfile")
  valid_563973 = validateParameter(valid_563973, JString, required = false,
                                 default = nil)
  if valid_563973 != nil:
    section.add "scoringProfile", valid_563973
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_563974 = header.getOrDefault("client-request-id")
  valid_563974 = validateParameter(valid_563974, JString, required = false,
                                 default = nil)
  if valid_563974 != nil:
    section.add "client-request-id", valid_563974
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563997: Call_DocumentsSearchGet_563779; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for documents in the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Search-Documents
  let valid = call_563997.validator(path, query, header, formData, body)
  let scheme = call_563997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563997.url(scheme.get, call_563997.host, call_563997.base,
                         call_563997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563997, url, valid)

proc call*(call_564068: Call_DocumentsSearchGet_563779; apiVersion: string;
          Top: int = 0; Select: JsonNode = nil; searchMode: string = "any";
          minimumCoverage: float = 0.0; Count: bool = false;
          queryType: string = "simple"; Orderby: JsonNode = nil; Skip: int = 0;
          highlightPostTag: string = ""; Filter: string = "";
          searchFields: JsonNode = nil; highlightPreTag: string = "";
          facet: JsonNode = nil; scoringParameter: JsonNode = nil; search: string = "";
          highlight: JsonNode = nil; scoringProfile: string = ""): Recallable =
  ## documentsSearchGet
  ## Searches for documents in the Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/Search-Documents
  ##   Top: int
  ##      : The number of search results to retrieve. This can be used in conjunction with $skip to implement client-side paging of search results. If results are truncated due to server-side paging, the response will include a continuation token that can be used to issue another Search request for the next page of results.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: JArray
  ##         : The list of fields to retrieve. If unspecified, all fields marked as retrievable in the schema are included.
  ##   searchMode: string
  ##             : A value that specifies whether any or all of the search terms must be matched in order to count the document as a match.
  ##   minimumCoverage: float
  ##                  : A number between 0 and 100 indicating the percentage of the index that must be covered by a search query in order for the query to be reported as a success. This parameter can be useful for ensuring search availability even for services with only one replica. The default is 100.
  ##   Count: bool
  ##        : A value that specifies whether to fetch the total count of results. Default is false. Setting this value to true may have a performance impact. Note that the count returned is an approximation.
  ##   queryType: string
  ##            : A value that specifies the syntax of the search query. The default is 'simple'. Use 'full' if your query uses the Lucene query syntax.
  ##   Orderby: JArray
  ##          : The list of OData $orderby expressions by which to sort the results. Each expression can be either a field name or a call to either the geo.distance() or the search.score() functions. Each expression can be followed by asc to indicate ascending, and desc to indicate descending. The default is ascending order. Ties will be broken by the match scores of documents. If no OrderBy is specified, the default sort order is descending by document match score. There can be at most 32 $orderby clauses.
  ##   Skip: int
  ##       : The number of search results to skip. This value cannot be greater than 100,000. If you need to scan documents in sequence, but cannot use $skip due to this limitation, consider using $orderby on a totally-ordered key and $filter with a range query instead.
  ##   highlightPostTag: string
  ##                   : A string tag that is appended to hit highlights. Must be set with highlightPreTag. Default is &lt;/em&gt;.
  ##   Filter: string
  ##         : The OData $filter expression to apply to the search query.
  ##   searchFields: JArray
  ##               : The list of field names to which to scope the full-text search. When using fielded search (fieldName:searchExpression) in a full Lucene query, the field names of each fielded search expression take precedence over any field names listed in this parameter.
  ##   highlightPreTag: string
  ##                  : A string tag that is prepended to hit highlights. Must be set with highlightPostTag. Default is &lt;em&gt;.
  ##   facet: JArray
  ##        : The list of facet expressions to apply to the search query. Each facet expression contains a field name, optionally followed by a comma-separated list of name:value pairs.
  ##   scoringParameter: JArray
  ##                   : The list of parameter values to be used in scoring functions (for example, referencePointParameter) using the format name-values. For example, if the scoring profile defines a function with a parameter called 'mylocation' the parameter string would be "mylocation--122.2,44.8" (without the quotes).
  ##   search: string
  ##         : A full-text search query expression; Use "*" or omit this parameter to match all documents.
  ##   highlight: JArray
  ##            : The list of field names to use for hit highlights. Only searchable fields can be used for hit highlighting.
  ##   scoringProfile: string
  ##                 : The name of a scoring profile to evaluate match scores for matching documents in order to sort the results.
  var query_564069 = newJObject()
  add(query_564069, "$top", newJInt(Top))
  add(query_564069, "api-version", newJString(apiVersion))
  if Select != nil:
    query_564069.add "$select", Select
  add(query_564069, "searchMode", newJString(searchMode))
  add(query_564069, "minimumCoverage", newJFloat(minimumCoverage))
  add(query_564069, "$count", newJBool(Count))
  add(query_564069, "queryType", newJString(queryType))
  if Orderby != nil:
    query_564069.add "$orderby", Orderby
  add(query_564069, "$skip", newJInt(Skip))
  add(query_564069, "highlightPostTag", newJString(highlightPostTag))
  add(query_564069, "$filter", newJString(Filter))
  if searchFields != nil:
    query_564069.add "searchFields", searchFields
  add(query_564069, "highlightPreTag", newJString(highlightPreTag))
  if facet != nil:
    query_564069.add "facet", facet
  if scoringParameter != nil:
    query_564069.add "scoringParameter", scoringParameter
  add(query_564069, "search", newJString(search))
  if highlight != nil:
    query_564069.add "highlight", highlight
  add(query_564069, "scoringProfile", newJString(scoringProfile))
  result = call_564068.call(nil, query_564069, nil, nil, nil)

var documentsSearchGet* = Call_DocumentsSearchGet_563779(
    name: "documentsSearchGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/docs", validator: validate_DocumentsSearchGet_563780, base: "",
    url: url_DocumentsSearchGet_563781, schemes: {Scheme.Https})
type
  Call_DocumentsGet_564109 = ref object of OpenApiRestCall_563557
proc url_DocumentsGet_564111(protocol: Scheme; host: string; base: string;
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

proc validate_DocumentsGet_564110(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564126 = path.getOrDefault("key")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "key", valid_564126
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JArray
  ##          : List of field names to retrieve for the document; Any field not retrieved will be missing from the returned document.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564127 = query.getOrDefault("api-version")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "api-version", valid_564127
  var valid_564128 = query.getOrDefault("$select")
  valid_564128 = validateParameter(valid_564128, JArray, required = false,
                                 default = nil)
  if valid_564128 != nil:
    section.add "$select", valid_564128
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564129 = header.getOrDefault("client-request-id")
  valid_564129 = validateParameter(valid_564129, JString, required = false,
                                 default = nil)
  if valid_564129 != nil:
    section.add "client-request-id", valid_564129
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564130: Call_DocumentsGet_564109; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a document from the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/lookup-document
  let valid = call_564130.validator(path, query, header, formData, body)
  let scheme = call_564130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564130.url(scheme.get, call_564130.host, call_564130.base,
                         call_564130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564130, url, valid)

proc call*(call_564131: Call_DocumentsGet_564109; apiVersion: string; key: string;
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
  var path_564132 = newJObject()
  var query_564133 = newJObject()
  add(query_564133, "api-version", newJString(apiVersion))
  if Select != nil:
    query_564133.add "$select", Select
  add(path_564132, "key", newJString(key))
  result = call_564131.call(path_564132, query_564133, nil, nil, nil)

var documentsGet* = Call_DocumentsGet_564109(name: "documentsGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/docs(\'{key}\')",
    validator: validate_DocumentsGet_564110, base: "", url: url_DocumentsGet_564111,
    schemes: {Scheme.Https})
type
  Call_DocumentsCount_564134 = ref object of OpenApiRestCall_563557
proc url_DocumentsCount_564136(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsCount_564135(path: JsonNode; query: JsonNode;
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
  var valid_564137 = query.getOrDefault("api-version")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "api-version", valid_564137
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564138 = header.getOrDefault("client-request-id")
  valid_564138 = validateParameter(valid_564138, JString, required = false,
                                 default = nil)
  if valid_564138 != nil:
    section.add "client-request-id", valid_564138
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564139: Call_DocumentsCount_564134; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Queries the number of documents in the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Count-Documents
  let valid = call_564139.validator(path, query, header, formData, body)
  let scheme = call_564139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564139.url(scheme.get, call_564139.host, call_564139.base,
                         call_564139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564139, url, valid)

proc call*(call_564140: Call_DocumentsCount_564134; apiVersion: string): Recallable =
  ## documentsCount
  ## Queries the number of documents in the Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/Count-Documents
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564141 = newJObject()
  add(query_564141, "api-version", newJString(apiVersion))
  result = call_564140.call(nil, query_564141, nil, nil, nil)

var documentsCount* = Call_DocumentsCount_564134(name: "documentsCount",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/docs/$count",
    validator: validate_DocumentsCount_564135, base: "", url: url_DocumentsCount_564136,
    schemes: {Scheme.Https})
type
  Call_DocumentsAutocompleteGet_564142 = ref object of OpenApiRestCall_563557
proc url_DocumentsAutocompleteGet_564144(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsAutocompleteGet_564143(path: JsonNode; query: JsonNode;
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
  ##   $top: JInt
  ##       : The number of auto-completed terms to retrieve. This must be a value between 1 and 100. The default is 5.
  ##   suggesterName: JString (required)
  ##                : The name of the suggester as specified in the suggesters collection that's part of the index definition.
  ##   fuzzy: JBool
  ##        : A value indicating whether to use fuzzy matching for the autocomplete query. Default is false. When set to true, the query will find terms even if there's a substituted or missing character in the search text. While this provides a better experience in some scenarios, it comes at a performance cost as fuzzy autocomplete queries are slower and consume more resources.
  ##   minimumCoverage: JFloat
  ##                  : A number between 0 and 100 indicating the percentage of the index that must be covered by an autocomplete query in order for the query to be reported as a success. This parameter can be useful for ensuring search availability even for services with only one replica. The default is 80.
  ##   highlightPostTag: JString
  ##                   : A string tag that is appended to hit highlights. Must be set with highlightPreTag. If omitted, hit highlighting is disabled.
  ##   $filter: JString
  ##          : An OData expression that filters the documents used to produce completed terms for the Autocomplete result.
  ##   searchFields: JArray
  ##               : The list of field names to consider when querying for auto-completed terms. Target fields must be included in the specified suggester.
  ##   highlightPreTag: JString
  ##                  : A string tag that is prepended to hit highlights. Must be set with highlightPostTag. If omitted, hit highlighting is disabled.
  ##   autocompleteMode: JString
  ##                   : Specifies the mode for Autocomplete. The default is 'oneTerm'. Use 'twoTerms' to get shingles and 'oneTermWithContext' to use the current context while producing auto-completed terms.
  ##   search: JString (required)
  ##         : The incomplete term which should be auto-completed.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564145 = query.getOrDefault("api-version")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "api-version", valid_564145
  var valid_564146 = query.getOrDefault("$top")
  valid_564146 = validateParameter(valid_564146, JInt, required = false, default = nil)
  if valid_564146 != nil:
    section.add "$top", valid_564146
  var valid_564147 = query.getOrDefault("suggesterName")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "suggesterName", valid_564147
  var valid_564148 = query.getOrDefault("fuzzy")
  valid_564148 = validateParameter(valid_564148, JBool, required = false, default = nil)
  if valid_564148 != nil:
    section.add "fuzzy", valid_564148
  var valid_564149 = query.getOrDefault("minimumCoverage")
  valid_564149 = validateParameter(valid_564149, JFloat, required = false,
                                 default = nil)
  if valid_564149 != nil:
    section.add "minimumCoverage", valid_564149
  var valid_564150 = query.getOrDefault("highlightPostTag")
  valid_564150 = validateParameter(valid_564150, JString, required = false,
                                 default = nil)
  if valid_564150 != nil:
    section.add "highlightPostTag", valid_564150
  var valid_564151 = query.getOrDefault("$filter")
  valid_564151 = validateParameter(valid_564151, JString, required = false,
                                 default = nil)
  if valid_564151 != nil:
    section.add "$filter", valid_564151
  var valid_564152 = query.getOrDefault("searchFields")
  valid_564152 = validateParameter(valid_564152, JArray, required = false,
                                 default = nil)
  if valid_564152 != nil:
    section.add "searchFields", valid_564152
  var valid_564153 = query.getOrDefault("highlightPreTag")
  valid_564153 = validateParameter(valid_564153, JString, required = false,
                                 default = nil)
  if valid_564153 != nil:
    section.add "highlightPreTag", valid_564153
  var valid_564154 = query.getOrDefault("autocompleteMode")
  valid_564154 = validateParameter(valid_564154, JString, required = false,
                                 default = newJString("oneTerm"))
  if valid_564154 != nil:
    section.add "autocompleteMode", valid_564154
  var valid_564155 = query.getOrDefault("search")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "search", valid_564155
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564156 = header.getOrDefault("client-request-id")
  valid_564156 = validateParameter(valid_564156, JString, required = false,
                                 default = nil)
  if valid_564156 != nil:
    section.add "client-request-id", valid_564156
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564157: Call_DocumentsAutocompleteGet_564142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Autocompletes incomplete query terms based on input text and matching terms in the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/autocomplete
  let valid = call_564157.validator(path, query, header, formData, body)
  let scheme = call_564157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564157.url(scheme.get, call_564157.host, call_564157.base,
                         call_564157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564157, url, valid)

proc call*(call_564158: Call_DocumentsAutocompleteGet_564142; apiVersion: string;
          suggesterName: string; search: string; Top: int = 0; fuzzy: bool = false;
          minimumCoverage: float = 0.0; highlightPostTag: string = "";
          Filter: string = ""; searchFields: JsonNode = nil;
          highlightPreTag: string = ""; autocompleteMode: string = "oneTerm"): Recallable =
  ## documentsAutocompleteGet
  ## Autocompletes incomplete query terms based on input text and matching terms in the Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/autocomplete
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of auto-completed terms to retrieve. This must be a value between 1 and 100. The default is 5.
  ##   suggesterName: string (required)
  ##                : The name of the suggester as specified in the suggesters collection that's part of the index definition.
  ##   fuzzy: bool
  ##        : A value indicating whether to use fuzzy matching for the autocomplete query. Default is false. When set to true, the query will find terms even if there's a substituted or missing character in the search text. While this provides a better experience in some scenarios, it comes at a performance cost as fuzzy autocomplete queries are slower and consume more resources.
  ##   minimumCoverage: float
  ##                  : A number between 0 and 100 indicating the percentage of the index that must be covered by an autocomplete query in order for the query to be reported as a success. This parameter can be useful for ensuring search availability even for services with only one replica. The default is 80.
  ##   highlightPostTag: string
  ##                   : A string tag that is appended to hit highlights. Must be set with highlightPreTag. If omitted, hit highlighting is disabled.
  ##   Filter: string
  ##         : An OData expression that filters the documents used to produce completed terms for the Autocomplete result.
  ##   searchFields: JArray
  ##               : The list of field names to consider when querying for auto-completed terms. Target fields must be included in the specified suggester.
  ##   highlightPreTag: string
  ##                  : A string tag that is prepended to hit highlights. Must be set with highlightPostTag. If omitted, hit highlighting is disabled.
  ##   autocompleteMode: string
  ##                   : Specifies the mode for Autocomplete. The default is 'oneTerm'. Use 'twoTerms' to get shingles and 'oneTermWithContext' to use the current context while producing auto-completed terms.
  ##   search: string (required)
  ##         : The incomplete term which should be auto-completed.
  var query_564159 = newJObject()
  add(query_564159, "api-version", newJString(apiVersion))
  add(query_564159, "$top", newJInt(Top))
  add(query_564159, "suggesterName", newJString(suggesterName))
  add(query_564159, "fuzzy", newJBool(fuzzy))
  add(query_564159, "minimumCoverage", newJFloat(minimumCoverage))
  add(query_564159, "highlightPostTag", newJString(highlightPostTag))
  add(query_564159, "$filter", newJString(Filter))
  if searchFields != nil:
    query_564159.add "searchFields", searchFields
  add(query_564159, "highlightPreTag", newJString(highlightPreTag))
  add(query_564159, "autocompleteMode", newJString(autocompleteMode))
  add(query_564159, "search", newJString(search))
  result = call_564158.call(nil, query_564159, nil, nil, nil)

var documentsAutocompleteGet* = Call_DocumentsAutocompleteGet_564142(
    name: "documentsAutocompleteGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/docs/search.autocomplete",
    validator: validate_DocumentsAutocompleteGet_564143, base: "",
    url: url_DocumentsAutocompleteGet_564144, schemes: {Scheme.Https})
type
  Call_DocumentsIndex_564160 = ref object of OpenApiRestCall_563557
proc url_DocumentsIndex_564162(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsIndex_564161(path: JsonNode; query: JsonNode;
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
  var valid_564180 = query.getOrDefault("api-version")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "api-version", valid_564180
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564181 = header.getOrDefault("client-request-id")
  valid_564181 = validateParameter(valid_564181, JString, required = false,
                                 default = nil)
  if valid_564181 != nil:
    section.add "client-request-id", valid_564181
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

proc call*(call_564183: Call_DocumentsIndex_564160; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a batch of document write actions to the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/addupdate-or-delete-documents
  let valid = call_564183.validator(path, query, header, formData, body)
  let scheme = call_564183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564183.url(scheme.get, call_564183.host, call_564183.base,
                         call_564183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564183, url, valid)

proc call*(call_564184: Call_DocumentsIndex_564160; apiVersion: string;
          batch: JsonNode): Recallable =
  ## documentsIndex
  ## Sends a batch of document write actions to the Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/addupdate-or-delete-documents
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   batch: JObject (required)
  ##        : The batch of index actions.
  var query_564185 = newJObject()
  var body_564186 = newJObject()
  add(query_564185, "api-version", newJString(apiVersion))
  if batch != nil:
    body_564186 = batch
  result = call_564184.call(nil, query_564185, nil, nil, body_564186)

var documentsIndex* = Call_DocumentsIndex_564160(name: "documentsIndex",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/docs/search.index",
    validator: validate_DocumentsIndex_564161, base: "", url: url_DocumentsIndex_564162,
    schemes: {Scheme.Https})
type
  Call_DocumentsAutocompletePost_564187 = ref object of OpenApiRestCall_563557
proc url_DocumentsAutocompletePost_564189(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsAutocompletePost_564188(path: JsonNode; query: JsonNode;
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
  var valid_564190 = query.getOrDefault("api-version")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "api-version", valid_564190
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564191 = header.getOrDefault("client-request-id")
  valid_564191 = validateParameter(valid_564191, JString, required = false,
                                 default = nil)
  if valid_564191 != nil:
    section.add "client-request-id", valid_564191
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

proc call*(call_564193: Call_DocumentsAutocompletePost_564187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Autocompletes incomplete query terms based on input text and matching terms in the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/autocomplete
  let valid = call_564193.validator(path, query, header, formData, body)
  let scheme = call_564193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564193.url(scheme.get, call_564193.host, call_564193.base,
                         call_564193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564193, url, valid)

proc call*(call_564194: Call_DocumentsAutocompletePost_564187; apiVersion: string;
          autocompleteRequest: JsonNode): Recallable =
  ## documentsAutocompletePost
  ## Autocompletes incomplete query terms based on input text and matching terms in the Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/autocomplete
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   autocompleteRequest: JObject (required)
  ##                      : The definition of the Autocomplete request.
  var query_564195 = newJObject()
  var body_564196 = newJObject()
  add(query_564195, "api-version", newJString(apiVersion))
  if autocompleteRequest != nil:
    body_564196 = autocompleteRequest
  result = call_564194.call(nil, query_564195, nil, nil, body_564196)

var documentsAutocompletePost* = Call_DocumentsAutocompletePost_564187(
    name: "documentsAutocompletePost", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/docs/search.post.autocomplete",
    validator: validate_DocumentsAutocompletePost_564188, base: "",
    url: url_DocumentsAutocompletePost_564189, schemes: {Scheme.Https})
type
  Call_DocumentsSearchPost_564197 = ref object of OpenApiRestCall_563557
proc url_DocumentsSearchPost_564199(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsSearchPost_564198(path: JsonNode; query: JsonNode;
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
  var valid_564200 = query.getOrDefault("api-version")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "api-version", valid_564200
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564201 = header.getOrDefault("client-request-id")
  valid_564201 = validateParameter(valid_564201, JString, required = false,
                                 default = nil)
  if valid_564201 != nil:
    section.add "client-request-id", valid_564201
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

proc call*(call_564203: Call_DocumentsSearchPost_564197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for documents in the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Search-Documents
  let valid = call_564203.validator(path, query, header, formData, body)
  let scheme = call_564203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564203.url(scheme.get, call_564203.host, call_564203.base,
                         call_564203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564203, url, valid)

proc call*(call_564204: Call_DocumentsSearchPost_564197; apiVersion: string;
          searchRequest: JsonNode): Recallable =
  ## documentsSearchPost
  ## Searches for documents in the Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/Search-Documents
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   searchRequest: JObject (required)
  ##                : The definition of the Search request.
  var query_564205 = newJObject()
  var body_564206 = newJObject()
  add(query_564205, "api-version", newJString(apiVersion))
  if searchRequest != nil:
    body_564206 = searchRequest
  result = call_564204.call(nil, query_564205, nil, nil, body_564206)

var documentsSearchPost* = Call_DocumentsSearchPost_564197(
    name: "documentsSearchPost", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/docs/search.post.search", validator: validate_DocumentsSearchPost_564198,
    base: "", url: url_DocumentsSearchPost_564199, schemes: {Scheme.Https})
type
  Call_DocumentsSuggestPost_564207 = ref object of OpenApiRestCall_563557
proc url_DocumentsSuggestPost_564209(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsSuggestPost_564208(path: JsonNode; query: JsonNode;
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
  var valid_564210 = query.getOrDefault("api-version")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "api-version", valid_564210
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564211 = header.getOrDefault("client-request-id")
  valid_564211 = validateParameter(valid_564211, JString, required = false,
                                 default = nil)
  if valid_564211 != nil:
    section.add "client-request-id", valid_564211
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

proc call*(call_564213: Call_DocumentsSuggestPost_564207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suggests documents in the Azure Search index that match the given partial query text.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/suggestions
  let valid = call_564213.validator(path, query, header, formData, body)
  let scheme = call_564213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564213.url(scheme.get, call_564213.host, call_564213.base,
                         call_564213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564213, url, valid)

proc call*(call_564214: Call_DocumentsSuggestPost_564207; apiVersion: string;
          suggestRequest: JsonNode): Recallable =
  ## documentsSuggestPost
  ## Suggests documents in the Azure Search index that match the given partial query text.
  ## https://docs.microsoft.com/rest/api/searchservice/suggestions
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   suggestRequest: JObject (required)
  ##                 : The Suggest request.
  var query_564215 = newJObject()
  var body_564216 = newJObject()
  add(query_564215, "api-version", newJString(apiVersion))
  if suggestRequest != nil:
    body_564216 = suggestRequest
  result = call_564214.call(nil, query_564215, nil, nil, body_564216)

var documentsSuggestPost* = Call_DocumentsSuggestPost_564207(
    name: "documentsSuggestPost", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/docs/search.post.suggest", validator: validate_DocumentsSuggestPost_564208,
    base: "", url: url_DocumentsSuggestPost_564209, schemes: {Scheme.Https})
type
  Call_DocumentsSuggestGet_564217 = ref object of OpenApiRestCall_563557
proc url_DocumentsSuggestGet_564219(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsSuggestGet_564218(path: JsonNode; query: JsonNode;
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
  ##   $top: JInt
  ##       : The number of suggestions to retrieve. The value must be a number between 1 and 100. The default is 5.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   suggesterName: JString (required)
  ##                : The name of the suggester as specified in the suggesters collection that's part of the index definition.
  ##   fuzzy: JBool
  ##        : A value indicating whether to use fuzzy matching for the suggestions query. Default is false. When set to true, the query will find terms even if there's a substituted or missing character in the search text. While this provides a better experience in some scenarios, it comes at a performance cost as fuzzy suggestions queries are slower and consume more resources.
  ##   $select: JArray
  ##          : The list of fields to retrieve. If unspecified, only the key field will be included in the results.
  ##   minimumCoverage: JFloat
  ##                  : A number between 0 and 100 indicating the percentage of the index that must be covered by a suggestions query in order for the query to be reported as a success. This parameter can be useful for ensuring search availability even for services with only one replica. The default is 80.
  ##   $orderby: JArray
  ##           : The list of OData $orderby expressions by which to sort the results. Each expression can be either a field name or a call to either the geo.distance() or the search.score() functions. Each expression can be followed by asc to indicate ascending, or desc to indicate descending. The default is ascending order. Ties will be broken by the match scores of documents. If no $orderby is specified, the default sort order is descending by document match score. There can be at most 32 $orderby clauses.
  ##   highlightPostTag: JString
  ##                   : A string tag that is appended to hit highlights. Must be set with highlightPreTag. If omitted, hit highlighting of suggestions is disabled.
  ##   $filter: JString
  ##          : An OData expression that filters the documents considered for suggestions.
  ##   searchFields: JArray
  ##               : The list of field names to search for the specified search text. Target fields must be included in the specified suggester.
  ##   highlightPreTag: JString
  ##                  : A string tag that is prepended to hit highlights. Must be set with highlightPostTag. If omitted, hit highlighting of suggestions is disabled.
  ##   search: JString (required)
  ##         : The search text to use to suggest documents. Must be at least 1 character, and no more than 100 characters.
  section = newJObject()
  var valid_564220 = query.getOrDefault("$top")
  valid_564220 = validateParameter(valid_564220, JInt, required = false, default = nil)
  if valid_564220 != nil:
    section.add "$top", valid_564220
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564221 = query.getOrDefault("api-version")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "api-version", valid_564221
  var valid_564222 = query.getOrDefault("suggesterName")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "suggesterName", valid_564222
  var valid_564223 = query.getOrDefault("fuzzy")
  valid_564223 = validateParameter(valid_564223, JBool, required = false, default = nil)
  if valid_564223 != nil:
    section.add "fuzzy", valid_564223
  var valid_564224 = query.getOrDefault("$select")
  valid_564224 = validateParameter(valid_564224, JArray, required = false,
                                 default = nil)
  if valid_564224 != nil:
    section.add "$select", valid_564224
  var valid_564225 = query.getOrDefault("minimumCoverage")
  valid_564225 = validateParameter(valid_564225, JFloat, required = false,
                                 default = nil)
  if valid_564225 != nil:
    section.add "minimumCoverage", valid_564225
  var valid_564226 = query.getOrDefault("$orderby")
  valid_564226 = validateParameter(valid_564226, JArray, required = false,
                                 default = nil)
  if valid_564226 != nil:
    section.add "$orderby", valid_564226
  var valid_564227 = query.getOrDefault("highlightPostTag")
  valid_564227 = validateParameter(valid_564227, JString, required = false,
                                 default = nil)
  if valid_564227 != nil:
    section.add "highlightPostTag", valid_564227
  var valid_564228 = query.getOrDefault("$filter")
  valid_564228 = validateParameter(valid_564228, JString, required = false,
                                 default = nil)
  if valid_564228 != nil:
    section.add "$filter", valid_564228
  var valid_564229 = query.getOrDefault("searchFields")
  valid_564229 = validateParameter(valid_564229, JArray, required = false,
                                 default = nil)
  if valid_564229 != nil:
    section.add "searchFields", valid_564229
  var valid_564230 = query.getOrDefault("highlightPreTag")
  valid_564230 = validateParameter(valid_564230, JString, required = false,
                                 default = nil)
  if valid_564230 != nil:
    section.add "highlightPreTag", valid_564230
  var valid_564231 = query.getOrDefault("search")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "search", valid_564231
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564232 = header.getOrDefault("client-request-id")
  valid_564232 = validateParameter(valid_564232, JString, required = false,
                                 default = nil)
  if valid_564232 != nil:
    section.add "client-request-id", valid_564232
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564233: Call_DocumentsSuggestGet_564217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suggests documents in the Azure Search index that match the given partial query text.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/suggestions
  let valid = call_564233.validator(path, query, header, formData, body)
  let scheme = call_564233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564233.url(scheme.get, call_564233.host, call_564233.base,
                         call_564233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564233, url, valid)

proc call*(call_564234: Call_DocumentsSuggestGet_564217; apiVersion: string;
          suggesterName: string; search: string; Top: int = 0; fuzzy: bool = false;
          Select: JsonNode = nil; minimumCoverage: float = 0.0; Orderby: JsonNode = nil;
          highlightPostTag: string = ""; Filter: string = "";
          searchFields: JsonNode = nil; highlightPreTag: string = ""): Recallable =
  ## documentsSuggestGet
  ## Suggests documents in the Azure Search index that match the given partial query text.
  ## https://docs.microsoft.com/rest/api/searchservice/suggestions
  ##   Top: int
  ##      : The number of suggestions to retrieve. The value must be a number between 1 and 100. The default is 5.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   suggesterName: string (required)
  ##                : The name of the suggester as specified in the suggesters collection that's part of the index definition.
  ##   fuzzy: bool
  ##        : A value indicating whether to use fuzzy matching for the suggestions query. Default is false. When set to true, the query will find terms even if there's a substituted or missing character in the search text. While this provides a better experience in some scenarios, it comes at a performance cost as fuzzy suggestions queries are slower and consume more resources.
  ##   Select: JArray
  ##         : The list of fields to retrieve. If unspecified, only the key field will be included in the results.
  ##   minimumCoverage: float
  ##                  : A number between 0 and 100 indicating the percentage of the index that must be covered by a suggestions query in order for the query to be reported as a success. This parameter can be useful for ensuring search availability even for services with only one replica. The default is 80.
  ##   Orderby: JArray
  ##          : The list of OData $orderby expressions by which to sort the results. Each expression can be either a field name or a call to either the geo.distance() or the search.score() functions. Each expression can be followed by asc to indicate ascending, or desc to indicate descending. The default is ascending order. Ties will be broken by the match scores of documents. If no $orderby is specified, the default sort order is descending by document match score. There can be at most 32 $orderby clauses.
  ##   highlightPostTag: string
  ##                   : A string tag that is appended to hit highlights. Must be set with highlightPreTag. If omitted, hit highlighting of suggestions is disabled.
  ##   Filter: string
  ##         : An OData expression that filters the documents considered for suggestions.
  ##   searchFields: JArray
  ##               : The list of field names to search for the specified search text. Target fields must be included in the specified suggester.
  ##   highlightPreTag: string
  ##                  : A string tag that is prepended to hit highlights. Must be set with highlightPostTag. If omitted, hit highlighting of suggestions is disabled.
  ##   search: string (required)
  ##         : The search text to use to suggest documents. Must be at least 1 character, and no more than 100 characters.
  var query_564235 = newJObject()
  add(query_564235, "$top", newJInt(Top))
  add(query_564235, "api-version", newJString(apiVersion))
  add(query_564235, "suggesterName", newJString(suggesterName))
  add(query_564235, "fuzzy", newJBool(fuzzy))
  if Select != nil:
    query_564235.add "$select", Select
  add(query_564235, "minimumCoverage", newJFloat(minimumCoverage))
  if Orderby != nil:
    query_564235.add "$orderby", Orderby
  add(query_564235, "highlightPostTag", newJString(highlightPostTag))
  add(query_564235, "$filter", newJString(Filter))
  if searchFields != nil:
    query_564235.add "searchFields", searchFields
  add(query_564235, "highlightPreTag", newJString(highlightPreTag))
  add(query_564235, "search", newJString(search))
  result = call_564234.call(nil, query_564235, nil, nil, nil)

var documentsSuggestGet* = Call_DocumentsSuggestGet_564217(
    name: "documentsSuggestGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/docs/search.suggest", validator: validate_DocumentsSuggestGet_564218,
    base: "", url: url_DocumentsSuggestGet_564219, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
