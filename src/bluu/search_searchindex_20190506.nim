
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593426 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593426](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593426): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_DocumentsSearchGet_593648 = ref object of OpenApiRestCall_593426
proc url_DocumentsSearchGet_593650(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsSearchGet_593649(path: JsonNode; query: JsonNode;
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
  ##               : The list of field names to which to scope the full-text search. When using fielded search (fieldName:searchExpression) in a full Lucene query, the field names of each fielded search expression take precedence over any field names listed in this parameter.
  section = newJObject()
  var valid_593810 = query.getOrDefault("$orderby")
  valid_593810 = validateParameter(valid_593810, JArray, required = false,
                                 default = nil)
  if valid_593810 != nil:
    section.add "$orderby", valid_593810
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593811 = query.getOrDefault("api-version")
  valid_593811 = validateParameter(valid_593811, JString, required = true,
                                 default = nil)
  if valid_593811 != nil:
    section.add "api-version", valid_593811
  var valid_593812 = query.getOrDefault("scoringProfile")
  valid_593812 = validateParameter(valid_593812, JString, required = false,
                                 default = nil)
  if valid_593812 != nil:
    section.add "scoringProfile", valid_593812
  var valid_593813 = query.getOrDefault("minimumCoverage")
  valid_593813 = validateParameter(valid_593813, JFloat, required = false,
                                 default = nil)
  if valid_593813 != nil:
    section.add "minimumCoverage", valid_593813
  var valid_593814 = query.getOrDefault("scoringParameter")
  valid_593814 = validateParameter(valid_593814, JArray, required = false,
                                 default = nil)
  if valid_593814 != nil:
    section.add "scoringParameter", valid_593814
  var valid_593815 = query.getOrDefault("$top")
  valid_593815 = validateParameter(valid_593815, JInt, required = false, default = nil)
  if valid_593815 != nil:
    section.add "$top", valid_593815
  var valid_593816 = query.getOrDefault("highlight")
  valid_593816 = validateParameter(valid_593816, JArray, required = false,
                                 default = nil)
  if valid_593816 != nil:
    section.add "highlight", valid_593816
  var valid_593817 = query.getOrDefault("$select")
  valid_593817 = validateParameter(valid_593817, JArray, required = false,
                                 default = nil)
  if valid_593817 != nil:
    section.add "$select", valid_593817
  var valid_593818 = query.getOrDefault("highlightPreTag")
  valid_593818 = validateParameter(valid_593818, JString, required = false,
                                 default = nil)
  if valid_593818 != nil:
    section.add "highlightPreTag", valid_593818
  var valid_593819 = query.getOrDefault("$skip")
  valid_593819 = validateParameter(valid_593819, JInt, required = false, default = nil)
  if valid_593819 != nil:
    section.add "$skip", valid_593819
  var valid_593820 = query.getOrDefault("search")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = nil)
  if valid_593820 != nil:
    section.add "search", valid_593820
  var valid_593821 = query.getOrDefault("$count")
  valid_593821 = validateParameter(valid_593821, JBool, required = false, default = nil)
  if valid_593821 != nil:
    section.add "$count", valid_593821
  var valid_593835 = query.getOrDefault("queryType")
  valid_593835 = validateParameter(valid_593835, JString, required = false,
                                 default = newJString("simple"))
  if valid_593835 != nil:
    section.add "queryType", valid_593835
  var valid_593836 = query.getOrDefault("searchMode")
  valid_593836 = validateParameter(valid_593836, JString, required = false,
                                 default = newJString("any"))
  if valid_593836 != nil:
    section.add "searchMode", valid_593836
  var valid_593837 = query.getOrDefault("$filter")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = nil)
  if valid_593837 != nil:
    section.add "$filter", valid_593837
  var valid_593838 = query.getOrDefault("facet")
  valid_593838 = validateParameter(valid_593838, JArray, required = false,
                                 default = nil)
  if valid_593838 != nil:
    section.add "facet", valid_593838
  var valid_593839 = query.getOrDefault("highlightPostTag")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "highlightPostTag", valid_593839
  var valid_593840 = query.getOrDefault("searchFields")
  valid_593840 = validateParameter(valid_593840, JArray, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "searchFields", valid_593840
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_593841 = header.getOrDefault("client-request-id")
  valid_593841 = validateParameter(valid_593841, JString, required = false,
                                 default = nil)
  if valid_593841 != nil:
    section.add "client-request-id", valid_593841
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593864: Call_DocumentsSearchGet_593648; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for documents in the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Search-Documents
  let valid = call_593864.validator(path, query, header, formData, body)
  let scheme = call_593864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593864.url(scheme.get, call_593864.host, call_593864.base,
                         call_593864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593864, url, valid)

proc call*(call_593935: Call_DocumentsSearchGet_593648; apiVersion: string;
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
  ##               : The list of field names to which to scope the full-text search. When using fielded search (fieldName:searchExpression) in a full Lucene query, the field names of each fielded search expression take precedence over any field names listed in this parameter.
  var query_593936 = newJObject()
  if Orderby != nil:
    query_593936.add "$orderby", Orderby
  add(query_593936, "api-version", newJString(apiVersion))
  add(query_593936, "scoringProfile", newJString(scoringProfile))
  add(query_593936, "minimumCoverage", newJFloat(minimumCoverage))
  if scoringParameter != nil:
    query_593936.add "scoringParameter", scoringParameter
  add(query_593936, "$top", newJInt(Top))
  if highlight != nil:
    query_593936.add "highlight", highlight
  if Select != nil:
    query_593936.add "$select", Select
  add(query_593936, "highlightPreTag", newJString(highlightPreTag))
  add(query_593936, "$skip", newJInt(Skip))
  add(query_593936, "search", newJString(search))
  add(query_593936, "$count", newJBool(Count))
  add(query_593936, "queryType", newJString(queryType))
  add(query_593936, "searchMode", newJString(searchMode))
  add(query_593936, "$filter", newJString(Filter))
  if facet != nil:
    query_593936.add "facet", facet
  add(query_593936, "highlightPostTag", newJString(highlightPostTag))
  if searchFields != nil:
    query_593936.add "searchFields", searchFields
  result = call_593935.call(nil, query_593936, nil, nil, nil)

var documentsSearchGet* = Call_DocumentsSearchGet_593648(
    name: "documentsSearchGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/docs", validator: validate_DocumentsSearchGet_593649, base: "",
    url: url_DocumentsSearchGet_593650, schemes: {Scheme.Https})
type
  Call_DocumentsGet_593976 = ref object of OpenApiRestCall_593426
proc url_DocumentsGet_593978(protocol: Scheme; host: string; base: string;
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

proc validate_DocumentsGet_593977(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593993 = path.getOrDefault("key")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "key", valid_593993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JArray
  ##          : List of field names to retrieve for the document; Any field not retrieved will be missing from the returned document.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593994 = query.getOrDefault("api-version")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "api-version", valid_593994
  var valid_593995 = query.getOrDefault("$select")
  valid_593995 = validateParameter(valid_593995, JArray, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "$select", valid_593995
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_593996 = header.getOrDefault("client-request-id")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "client-request-id", valid_593996
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593997: Call_DocumentsGet_593976; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a document from the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/lookup-document
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_DocumentsGet_593976; apiVersion: string; key: string;
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
  var path_593999 = newJObject()
  var query_594000 = newJObject()
  add(query_594000, "api-version", newJString(apiVersion))
  if Select != nil:
    query_594000.add "$select", Select
  add(path_593999, "key", newJString(key))
  result = call_593998.call(path_593999, query_594000, nil, nil, nil)

var documentsGet* = Call_DocumentsGet_593976(name: "documentsGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/docs(\'{key}\')",
    validator: validate_DocumentsGet_593977, base: "", url: url_DocumentsGet_593978,
    schemes: {Scheme.Https})
type
  Call_DocumentsCount_594001 = ref object of OpenApiRestCall_593426
proc url_DocumentsCount_594003(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsCount_594002(path: JsonNode; query: JsonNode;
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
  var valid_594004 = query.getOrDefault("api-version")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "api-version", valid_594004
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594005 = header.getOrDefault("client-request-id")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "client-request-id", valid_594005
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594006: Call_DocumentsCount_594001; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Queries the number of documents in the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Count-Documents
  let valid = call_594006.validator(path, query, header, formData, body)
  let scheme = call_594006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594006.url(scheme.get, call_594006.host, call_594006.base,
                         call_594006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594006, url, valid)

proc call*(call_594007: Call_DocumentsCount_594001; apiVersion: string): Recallable =
  ## documentsCount
  ## Queries the number of documents in the Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/Count-Documents
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_594008 = newJObject()
  add(query_594008, "api-version", newJString(apiVersion))
  result = call_594007.call(nil, query_594008, nil, nil, nil)

var documentsCount* = Call_DocumentsCount_594001(name: "documentsCount",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/docs/$count",
    validator: validate_DocumentsCount_594002, base: "", url: url_DocumentsCount_594003,
    schemes: {Scheme.Https})
type
  Call_DocumentsAutocompleteGet_594009 = ref object of OpenApiRestCall_593426
proc url_DocumentsAutocompleteGet_594011(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsAutocompleteGet_594010(path: JsonNode; query: JsonNode;
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
  var valid_594012 = query.getOrDefault("api-version")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "api-version", valid_594012
  var valid_594013 = query.getOrDefault("minimumCoverage")
  valid_594013 = validateParameter(valid_594013, JFloat, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "minimumCoverage", valid_594013
  var valid_594014 = query.getOrDefault("autocompleteMode")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = newJString("oneTerm"))
  if valid_594014 != nil:
    section.add "autocompleteMode", valid_594014
  var valid_594015 = query.getOrDefault("$top")
  valid_594015 = validateParameter(valid_594015, JInt, required = false, default = nil)
  if valid_594015 != nil:
    section.add "$top", valid_594015
  var valid_594016 = query.getOrDefault("fuzzy")
  valid_594016 = validateParameter(valid_594016, JBool, required = false, default = nil)
  if valid_594016 != nil:
    section.add "fuzzy", valid_594016
  var valid_594017 = query.getOrDefault("highlightPreTag")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "highlightPreTag", valid_594017
  var valid_594018 = query.getOrDefault("search")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "search", valid_594018
  var valid_594019 = query.getOrDefault("$filter")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "$filter", valid_594019
  var valid_594020 = query.getOrDefault("highlightPostTag")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "highlightPostTag", valid_594020
  var valid_594021 = query.getOrDefault("suggesterName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "suggesterName", valid_594021
  var valid_594022 = query.getOrDefault("searchFields")
  valid_594022 = validateParameter(valid_594022, JArray, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "searchFields", valid_594022
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594023 = header.getOrDefault("client-request-id")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "client-request-id", valid_594023
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594024: Call_DocumentsAutocompleteGet_594009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Autocompletes incomplete query terms based on input text and matching terms in the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/autocomplete
  let valid = call_594024.validator(path, query, header, formData, body)
  let scheme = call_594024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594024.url(scheme.get, call_594024.host, call_594024.base,
                         call_594024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594024, url, valid)

proc call*(call_594025: Call_DocumentsAutocompleteGet_594009; apiVersion: string;
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
  var query_594026 = newJObject()
  add(query_594026, "api-version", newJString(apiVersion))
  add(query_594026, "minimumCoverage", newJFloat(minimumCoverage))
  add(query_594026, "autocompleteMode", newJString(autocompleteMode))
  add(query_594026, "$top", newJInt(Top))
  add(query_594026, "fuzzy", newJBool(fuzzy))
  add(query_594026, "highlightPreTag", newJString(highlightPreTag))
  add(query_594026, "search", newJString(search))
  add(query_594026, "$filter", newJString(Filter))
  add(query_594026, "highlightPostTag", newJString(highlightPostTag))
  add(query_594026, "suggesterName", newJString(suggesterName))
  if searchFields != nil:
    query_594026.add "searchFields", searchFields
  result = call_594025.call(nil, query_594026, nil, nil, nil)

var documentsAutocompleteGet* = Call_DocumentsAutocompleteGet_594009(
    name: "documentsAutocompleteGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/docs/search.autocomplete",
    validator: validate_DocumentsAutocompleteGet_594010, base: "",
    url: url_DocumentsAutocompleteGet_594011, schemes: {Scheme.Https})
type
  Call_DocumentsIndex_594027 = ref object of OpenApiRestCall_593426
proc url_DocumentsIndex_594029(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsIndex_594028(path: JsonNode; query: JsonNode;
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
  var valid_594047 = query.getOrDefault("api-version")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "api-version", valid_594047
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594048 = header.getOrDefault("client-request-id")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "client-request-id", valid_594048
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

proc call*(call_594050: Call_DocumentsIndex_594027; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a batch of document write actions to the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/addupdate-or-delete-documents
  let valid = call_594050.validator(path, query, header, formData, body)
  let scheme = call_594050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594050.url(scheme.get, call_594050.host, call_594050.base,
                         call_594050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594050, url, valid)

proc call*(call_594051: Call_DocumentsIndex_594027; apiVersion: string;
          batch: JsonNode): Recallable =
  ## documentsIndex
  ## Sends a batch of document write actions to the Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/addupdate-or-delete-documents
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   batch: JObject (required)
  ##        : The batch of index actions.
  var query_594052 = newJObject()
  var body_594053 = newJObject()
  add(query_594052, "api-version", newJString(apiVersion))
  if batch != nil:
    body_594053 = batch
  result = call_594051.call(nil, query_594052, nil, nil, body_594053)

var documentsIndex* = Call_DocumentsIndex_594027(name: "documentsIndex",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/docs/search.index",
    validator: validate_DocumentsIndex_594028, base: "", url: url_DocumentsIndex_594029,
    schemes: {Scheme.Https})
type
  Call_DocumentsAutocompletePost_594054 = ref object of OpenApiRestCall_593426
proc url_DocumentsAutocompletePost_594056(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsAutocompletePost_594055(path: JsonNode; query: JsonNode;
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
  var valid_594057 = query.getOrDefault("api-version")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "api-version", valid_594057
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594058 = header.getOrDefault("client-request-id")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "client-request-id", valid_594058
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

proc call*(call_594060: Call_DocumentsAutocompletePost_594054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Autocompletes incomplete query terms based on input text and matching terms in the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/autocomplete
  let valid = call_594060.validator(path, query, header, formData, body)
  let scheme = call_594060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594060.url(scheme.get, call_594060.host, call_594060.base,
                         call_594060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594060, url, valid)

proc call*(call_594061: Call_DocumentsAutocompletePost_594054; apiVersion: string;
          autocompleteRequest: JsonNode): Recallable =
  ## documentsAutocompletePost
  ## Autocompletes incomplete query terms based on input text and matching terms in the Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/autocomplete
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   autocompleteRequest: JObject (required)
  ##                      : The definition of the Autocomplete request.
  var query_594062 = newJObject()
  var body_594063 = newJObject()
  add(query_594062, "api-version", newJString(apiVersion))
  if autocompleteRequest != nil:
    body_594063 = autocompleteRequest
  result = call_594061.call(nil, query_594062, nil, nil, body_594063)

var documentsAutocompletePost* = Call_DocumentsAutocompletePost_594054(
    name: "documentsAutocompletePost", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/docs/search.post.autocomplete",
    validator: validate_DocumentsAutocompletePost_594055, base: "",
    url: url_DocumentsAutocompletePost_594056, schemes: {Scheme.Https})
type
  Call_DocumentsSearchPost_594064 = ref object of OpenApiRestCall_593426
proc url_DocumentsSearchPost_594066(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsSearchPost_594065(path: JsonNode; query: JsonNode;
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
  var valid_594067 = query.getOrDefault("api-version")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "api-version", valid_594067
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594068 = header.getOrDefault("client-request-id")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "client-request-id", valid_594068
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

proc call*(call_594070: Call_DocumentsSearchPost_594064; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for documents in the Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Search-Documents
  let valid = call_594070.validator(path, query, header, formData, body)
  let scheme = call_594070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594070.url(scheme.get, call_594070.host, call_594070.base,
                         call_594070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594070, url, valid)

proc call*(call_594071: Call_DocumentsSearchPost_594064; apiVersion: string;
          searchRequest: JsonNode): Recallable =
  ## documentsSearchPost
  ## Searches for documents in the Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/Search-Documents
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   searchRequest: JObject (required)
  ##                : The definition of the Search request.
  var query_594072 = newJObject()
  var body_594073 = newJObject()
  add(query_594072, "api-version", newJString(apiVersion))
  if searchRequest != nil:
    body_594073 = searchRequest
  result = call_594071.call(nil, query_594072, nil, nil, body_594073)

var documentsSearchPost* = Call_DocumentsSearchPost_594064(
    name: "documentsSearchPost", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/docs/search.post.search", validator: validate_DocumentsSearchPost_594065,
    base: "", url: url_DocumentsSearchPost_594066, schemes: {Scheme.Https})
type
  Call_DocumentsSuggestPost_594074 = ref object of OpenApiRestCall_593426
proc url_DocumentsSuggestPost_594076(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsSuggestPost_594075(path: JsonNode; query: JsonNode;
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
  var valid_594077 = query.getOrDefault("api-version")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "api-version", valid_594077
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594078 = header.getOrDefault("client-request-id")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "client-request-id", valid_594078
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

proc call*(call_594080: Call_DocumentsSuggestPost_594074; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suggests documents in the Azure Search index that match the given partial query text.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/suggestions
  let valid = call_594080.validator(path, query, header, formData, body)
  let scheme = call_594080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594080.url(scheme.get, call_594080.host, call_594080.base,
                         call_594080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594080, url, valid)

proc call*(call_594081: Call_DocumentsSuggestPost_594074; apiVersion: string;
          suggestRequest: JsonNode): Recallable =
  ## documentsSuggestPost
  ## Suggests documents in the Azure Search index that match the given partial query text.
  ## https://docs.microsoft.com/rest/api/searchservice/suggestions
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   suggestRequest: JObject (required)
  ##                 : The Suggest request.
  var query_594082 = newJObject()
  var body_594083 = newJObject()
  add(query_594082, "api-version", newJString(apiVersion))
  if suggestRequest != nil:
    body_594083 = suggestRequest
  result = call_594081.call(nil, query_594082, nil, nil, body_594083)

var documentsSuggestPost* = Call_DocumentsSuggestPost_594074(
    name: "documentsSuggestPost", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/docs/search.post.suggest", validator: validate_DocumentsSuggestPost_594075,
    base: "", url: url_DocumentsSuggestPost_594076, schemes: {Scheme.Https})
type
  Call_DocumentsSuggestGet_594084 = ref object of OpenApiRestCall_593426
proc url_DocumentsSuggestGet_594086(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DocumentsSuggestGet_594085(path: JsonNode; query: JsonNode;
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
  var valid_594087 = query.getOrDefault("$orderby")
  valid_594087 = validateParameter(valid_594087, JArray, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "$orderby", valid_594087
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594088 = query.getOrDefault("api-version")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "api-version", valid_594088
  var valid_594089 = query.getOrDefault("minimumCoverage")
  valid_594089 = validateParameter(valid_594089, JFloat, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "minimumCoverage", valid_594089
  var valid_594090 = query.getOrDefault("$top")
  valid_594090 = validateParameter(valid_594090, JInt, required = false, default = nil)
  if valid_594090 != nil:
    section.add "$top", valid_594090
  var valid_594091 = query.getOrDefault("$select")
  valid_594091 = validateParameter(valid_594091, JArray, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "$select", valid_594091
  var valid_594092 = query.getOrDefault("fuzzy")
  valid_594092 = validateParameter(valid_594092, JBool, required = false, default = nil)
  if valid_594092 != nil:
    section.add "fuzzy", valid_594092
  var valid_594093 = query.getOrDefault("highlightPreTag")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "highlightPreTag", valid_594093
  var valid_594094 = query.getOrDefault("search")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "search", valid_594094
  var valid_594095 = query.getOrDefault("$filter")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "$filter", valid_594095
  var valid_594096 = query.getOrDefault("highlightPostTag")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "highlightPostTag", valid_594096
  var valid_594097 = query.getOrDefault("suggesterName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "suggesterName", valid_594097
  var valid_594098 = query.getOrDefault("searchFields")
  valid_594098 = validateParameter(valid_594098, JArray, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "searchFields", valid_594098
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594099 = header.getOrDefault("client-request-id")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "client-request-id", valid_594099
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594100: Call_DocumentsSuggestGet_594084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suggests documents in the Azure Search index that match the given partial query text.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/suggestions
  let valid = call_594100.validator(path, query, header, formData, body)
  let scheme = call_594100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594100.url(scheme.get, call_594100.host, call_594100.base,
                         call_594100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594100, url, valid)

proc call*(call_594101: Call_DocumentsSuggestGet_594084; apiVersion: string;
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
  var query_594102 = newJObject()
  if Orderby != nil:
    query_594102.add "$orderby", Orderby
  add(query_594102, "api-version", newJString(apiVersion))
  add(query_594102, "minimumCoverage", newJFloat(minimumCoverage))
  add(query_594102, "$top", newJInt(Top))
  if Select != nil:
    query_594102.add "$select", Select
  add(query_594102, "fuzzy", newJBool(fuzzy))
  add(query_594102, "highlightPreTag", newJString(highlightPreTag))
  add(query_594102, "search", newJString(search))
  add(query_594102, "$filter", newJString(Filter))
  add(query_594102, "highlightPostTag", newJString(highlightPostTag))
  add(query_594102, "suggesterName", newJString(suggesterName))
  if searchFields != nil:
    query_594102.add "searchFields", searchFields
  result = call_594101.call(nil, query_594102, nil, nil, nil)

var documentsSuggestGet* = Call_DocumentsSuggestGet_594084(
    name: "documentsSuggestGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/docs/search.suggest", validator: validate_DocumentsSuggestGet_594085,
    base: "", url: url_DocumentsSuggestGet_594086, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
