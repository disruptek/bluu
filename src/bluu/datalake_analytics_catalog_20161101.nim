
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: DataLakeAnalyticsCatalogManagementClient
## version: 2016-11-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Creates an Azure Data Lake Analytics catalog client.
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

  OpenApiRestCall_563564 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563564](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563564): Option[Scheme] {.used.} =
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
  macServiceName = "datalake-analytics-catalog"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CatalogListAcls_563786 = ref object of OpenApiRestCall_563564
proc url_CatalogListAcls_563788(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CatalogListAcls_563787(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Retrieves the list of access control list (ACL) entries for the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_563950 = query.getOrDefault("$top")
  valid_563950 = validateParameter(valid_563950, JInt, required = false, default = nil)
  if valid_563950 != nil:
    section.add "$top", valid_563950
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563951 = query.getOrDefault("api-version")
  valid_563951 = validateParameter(valid_563951, JString, required = true,
                                 default = nil)
  if valid_563951 != nil:
    section.add "api-version", valid_563951
  var valid_563952 = query.getOrDefault("$select")
  valid_563952 = validateParameter(valid_563952, JString, required = false,
                                 default = nil)
  if valid_563952 != nil:
    section.add "$select", valid_563952
  var valid_563953 = query.getOrDefault("$count")
  valid_563953 = validateParameter(valid_563953, JBool, required = false, default = nil)
  if valid_563953 != nil:
    section.add "$count", valid_563953
  var valid_563954 = query.getOrDefault("$orderby")
  valid_563954 = validateParameter(valid_563954, JString, required = false,
                                 default = nil)
  if valid_563954 != nil:
    section.add "$orderby", valid_563954
  var valid_563955 = query.getOrDefault("$skip")
  valid_563955 = validateParameter(valid_563955, JInt, required = false, default = nil)
  if valid_563955 != nil:
    section.add "$skip", valid_563955
  var valid_563956 = query.getOrDefault("$filter")
  valid_563956 = validateParameter(valid_563956, JString, required = false,
                                 default = nil)
  if valid_563956 != nil:
    section.add "$filter", valid_563956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563979: Call_CatalogListAcls_563786; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of access control list (ACL) entries for the Data Lake Analytics catalog.
  ## 
  let valid = call_563979.validator(path, query, header, formData, body)
  let scheme = call_563979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563979.url(scheme.get, call_563979.host, call_563979.base,
                         call_563979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563979, url, valid)

proc call*(call_564050: Call_CatalogListAcls_563786; apiVersion: string;
          Top: int = 0; Select: string = ""; Count: bool = false; Orderby: string = "";
          Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListAcls
  ## Retrieves the list of access control list (ACL) entries for the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var query_564051 = newJObject()
  add(query_564051, "$top", newJInt(Top))
  add(query_564051, "api-version", newJString(apiVersion))
  add(query_564051, "$select", newJString(Select))
  add(query_564051, "$count", newJBool(Count))
  add(query_564051, "$orderby", newJString(Orderby))
  add(query_564051, "$skip", newJInt(Skip))
  add(query_564051, "$filter", newJString(Filter))
  result = call_564050.call(nil, query_564051, nil, nil, nil)

var catalogListAcls* = Call_CatalogListAcls_563786(name: "catalogListAcls",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/acl",
    validator: validate_CatalogListAcls_563787, base: "", url: url_CatalogListAcls_563788,
    schemes: {Scheme.Https})
type
  Call_CatalogListDatabases_564091 = ref object of OpenApiRestCall_563564
proc url_CatalogListDatabases_564093(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CatalogListDatabases_564092(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of databases from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564094 = query.getOrDefault("$top")
  valid_564094 = validateParameter(valid_564094, JInt, required = false, default = nil)
  if valid_564094 != nil:
    section.add "$top", valid_564094
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564095 = query.getOrDefault("api-version")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "api-version", valid_564095
  var valid_564096 = query.getOrDefault("$select")
  valid_564096 = validateParameter(valid_564096, JString, required = false,
                                 default = nil)
  if valid_564096 != nil:
    section.add "$select", valid_564096
  var valid_564097 = query.getOrDefault("$count")
  valid_564097 = validateParameter(valid_564097, JBool, required = false, default = nil)
  if valid_564097 != nil:
    section.add "$count", valid_564097
  var valid_564098 = query.getOrDefault("$orderby")
  valid_564098 = validateParameter(valid_564098, JString, required = false,
                                 default = nil)
  if valid_564098 != nil:
    section.add "$orderby", valid_564098
  var valid_564099 = query.getOrDefault("$skip")
  valid_564099 = validateParameter(valid_564099, JInt, required = false, default = nil)
  if valid_564099 != nil:
    section.add "$skip", valid_564099
  var valid_564100 = query.getOrDefault("$filter")
  valid_564100 = validateParameter(valid_564100, JString, required = false,
                                 default = nil)
  if valid_564100 != nil:
    section.add "$filter", valid_564100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564101: Call_CatalogListDatabases_564091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of databases from the Data Lake Analytics catalog.
  ## 
  let valid = call_564101.validator(path, query, header, formData, body)
  let scheme = call_564101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564101.url(scheme.get, call_564101.host, call_564101.base,
                         call_564101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564101, url, valid)

proc call*(call_564102: Call_CatalogListDatabases_564091; apiVersion: string;
          Top: int = 0; Select: string = ""; Count: bool = false; Orderby: string = "";
          Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListDatabases
  ## Retrieves the list of databases from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var query_564103 = newJObject()
  add(query_564103, "$top", newJInt(Top))
  add(query_564103, "api-version", newJString(apiVersion))
  add(query_564103, "$select", newJString(Select))
  add(query_564103, "$count", newJBool(Count))
  add(query_564103, "$orderby", newJString(Orderby))
  add(query_564103, "$skip", newJInt(Skip))
  add(query_564103, "$filter", newJString(Filter))
  result = call_564102.call(nil, query_564103, nil, nil, nil)

var catalogListDatabases* = Call_CatalogListDatabases_564091(
    name: "catalogListDatabases", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases", validator: validate_CatalogListDatabases_564092,
    base: "", url: url_CatalogListDatabases_564093, schemes: {Scheme.Https})
type
  Call_CatalogGetDatabase_564104 = ref object of OpenApiRestCall_563564
proc url_CatalogGetDatabase_564106(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogGetDatabase_564105(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves the specified database from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564121 = path.getOrDefault("databaseName")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "databaseName", valid_564121
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564122 = query.getOrDefault("api-version")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "api-version", valid_564122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564123: Call_CatalogGetDatabase_564104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified database from the Data Lake Analytics catalog.
  ## 
  let valid = call_564123.validator(path, query, header, formData, body)
  let scheme = call_564123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564123.url(scheme.get, call_564123.host, call_564123.base,
                         call_564123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564123, url, valid)

proc call*(call_564124: Call_CatalogGetDatabase_564104; apiVersion: string;
          databaseName: string): Recallable =
  ## catalogGetDatabase
  ## Retrieves the specified database from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database.
  var path_564125 = newJObject()
  var query_564126 = newJObject()
  add(query_564126, "api-version", newJString(apiVersion))
  add(path_564125, "databaseName", newJString(databaseName))
  result = call_564124.call(path_564125, query_564126, nil, nil, nil)

var catalogGetDatabase* = Call_CatalogGetDatabase_564104(
    name: "catalogGetDatabase", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}",
    validator: validate_CatalogGetDatabase_564105, base: "",
    url: url_CatalogGetDatabase_564106, schemes: {Scheme.Https})
type
  Call_CatalogListAclsByDatabase_564127 = ref object of OpenApiRestCall_563564
proc url_CatalogListAclsByDatabase_564129(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/acl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogListAclsByDatabase_564128(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of access control list (ACL) entries for the database from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564130 = path.getOrDefault("databaseName")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "databaseName", valid_564130
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564131 = query.getOrDefault("$top")
  valid_564131 = validateParameter(valid_564131, JInt, required = false, default = nil)
  if valid_564131 != nil:
    section.add "$top", valid_564131
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564132 = query.getOrDefault("api-version")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "api-version", valid_564132
  var valid_564133 = query.getOrDefault("$select")
  valid_564133 = validateParameter(valid_564133, JString, required = false,
                                 default = nil)
  if valid_564133 != nil:
    section.add "$select", valid_564133
  var valid_564134 = query.getOrDefault("$count")
  valid_564134 = validateParameter(valid_564134, JBool, required = false, default = nil)
  if valid_564134 != nil:
    section.add "$count", valid_564134
  var valid_564135 = query.getOrDefault("$orderby")
  valid_564135 = validateParameter(valid_564135, JString, required = false,
                                 default = nil)
  if valid_564135 != nil:
    section.add "$orderby", valid_564135
  var valid_564136 = query.getOrDefault("$skip")
  valid_564136 = validateParameter(valid_564136, JInt, required = false, default = nil)
  if valid_564136 != nil:
    section.add "$skip", valid_564136
  var valid_564137 = query.getOrDefault("$filter")
  valid_564137 = validateParameter(valid_564137, JString, required = false,
                                 default = nil)
  if valid_564137 != nil:
    section.add "$filter", valid_564137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564138: Call_CatalogListAclsByDatabase_564127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of access control list (ACL) entries for the database from the Data Lake Analytics catalog.
  ## 
  let valid = call_564138.validator(path, query, header, formData, body)
  let scheme = call_564138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564138.url(scheme.get, call_564138.host, call_564138.base,
                         call_564138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564138, url, valid)

proc call*(call_564139: Call_CatalogListAclsByDatabase_564127; apiVersion: string;
          databaseName: string; Top: int = 0; Select: string = ""; Count: bool = false;
          Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListAclsByDatabase
  ## Retrieves the list of access control list (ACL) entries for the database from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_564140 = newJObject()
  var query_564141 = newJObject()
  add(query_564141, "$top", newJInt(Top))
  add(query_564141, "api-version", newJString(apiVersion))
  add(query_564141, "$select", newJString(Select))
  add(query_564141, "$count", newJBool(Count))
  add(path_564140, "databaseName", newJString(databaseName))
  add(query_564141, "$orderby", newJString(Orderby))
  add(query_564141, "$skip", newJInt(Skip))
  add(query_564141, "$filter", newJString(Filter))
  result = call_564139.call(path_564140, query_564141, nil, nil, nil)

var catalogListAclsByDatabase* = Call_CatalogListAclsByDatabase_564127(
    name: "catalogListAclsByDatabase", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/acl",
    validator: validate_CatalogListAclsByDatabase_564128, base: "",
    url: url_CatalogListAclsByDatabase_564129, schemes: {Scheme.Https})
type
  Call_CatalogListAssemblies_564142 = ref object of OpenApiRestCall_563564
proc url_CatalogListAssemblies_564144(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/assemblies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogListAssemblies_564143(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of assemblies from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the assembly.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564145 = path.getOrDefault("databaseName")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "databaseName", valid_564145
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564146 = query.getOrDefault("$top")
  valid_564146 = validateParameter(valid_564146, JInt, required = false, default = nil)
  if valid_564146 != nil:
    section.add "$top", valid_564146
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564147 = query.getOrDefault("api-version")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "api-version", valid_564147
  var valid_564148 = query.getOrDefault("$select")
  valid_564148 = validateParameter(valid_564148, JString, required = false,
                                 default = nil)
  if valid_564148 != nil:
    section.add "$select", valid_564148
  var valid_564149 = query.getOrDefault("$count")
  valid_564149 = validateParameter(valid_564149, JBool, required = false, default = nil)
  if valid_564149 != nil:
    section.add "$count", valid_564149
  var valid_564150 = query.getOrDefault("$orderby")
  valid_564150 = validateParameter(valid_564150, JString, required = false,
                                 default = nil)
  if valid_564150 != nil:
    section.add "$orderby", valid_564150
  var valid_564151 = query.getOrDefault("$skip")
  valid_564151 = validateParameter(valid_564151, JInt, required = false, default = nil)
  if valid_564151 != nil:
    section.add "$skip", valid_564151
  var valid_564152 = query.getOrDefault("$filter")
  valid_564152 = validateParameter(valid_564152, JString, required = false,
                                 default = nil)
  if valid_564152 != nil:
    section.add "$filter", valid_564152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564153: Call_CatalogListAssemblies_564142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of assemblies from the Data Lake Analytics catalog.
  ## 
  let valid = call_564153.validator(path, query, header, formData, body)
  let scheme = call_564153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564153.url(scheme.get, call_564153.host, call_564153.base,
                         call_564153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564153, url, valid)

proc call*(call_564154: Call_CatalogListAssemblies_564142; apiVersion: string;
          databaseName: string; Top: int = 0; Select: string = ""; Count: bool = false;
          Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListAssemblies
  ## Retrieves the list of assemblies from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the assembly.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_564155 = newJObject()
  var query_564156 = newJObject()
  add(query_564156, "$top", newJInt(Top))
  add(query_564156, "api-version", newJString(apiVersion))
  add(query_564156, "$select", newJString(Select))
  add(query_564156, "$count", newJBool(Count))
  add(path_564155, "databaseName", newJString(databaseName))
  add(query_564156, "$orderby", newJString(Orderby))
  add(query_564156, "$skip", newJInt(Skip))
  add(query_564156, "$filter", newJString(Filter))
  result = call_564154.call(path_564155, query_564156, nil, nil, nil)

var catalogListAssemblies* = Call_CatalogListAssemblies_564142(
    name: "catalogListAssemblies", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/assemblies",
    validator: validate_CatalogListAssemblies_564143, base: "",
    url: url_CatalogListAssemblies_564144, schemes: {Scheme.Https})
type
  Call_CatalogGetAssembly_564157 = ref object of OpenApiRestCall_563564
proc url_CatalogGetAssembly_564159(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "assemblyName" in path, "`assemblyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/assemblies/"),
               (kind: VariableSegment, value: "assemblyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogGetAssembly_564158(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves the specified assembly from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the assembly.
  ##   assemblyName: JString (required)
  ##               : The name of the assembly.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564160 = path.getOrDefault("databaseName")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "databaseName", valid_564160
  var valid_564161 = path.getOrDefault("assemblyName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "assemblyName", valid_564161
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564162 = query.getOrDefault("api-version")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "api-version", valid_564162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564163: Call_CatalogGetAssembly_564157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified assembly from the Data Lake Analytics catalog.
  ## 
  let valid = call_564163.validator(path, query, header, formData, body)
  let scheme = call_564163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564163.url(scheme.get, call_564163.host, call_564163.base,
                         call_564163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564163, url, valid)

proc call*(call_564164: Call_CatalogGetAssembly_564157; apiVersion: string;
          databaseName: string; assemblyName: string): Recallable =
  ## catalogGetAssembly
  ## Retrieves the specified assembly from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the assembly.
  ##   assemblyName: string (required)
  ##               : The name of the assembly.
  var path_564165 = newJObject()
  var query_564166 = newJObject()
  add(query_564166, "api-version", newJString(apiVersion))
  add(path_564165, "databaseName", newJString(databaseName))
  add(path_564165, "assemblyName", newJString(assemblyName))
  result = call_564164.call(path_564165, query_564166, nil, nil, nil)

var catalogGetAssembly* = Call_CatalogGetAssembly_564157(
    name: "catalogGetAssembly", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/assemblies/{assemblyName}",
    validator: validate_CatalogGetAssembly_564158, base: "",
    url: url_CatalogGetAssembly_564159, schemes: {Scheme.Https})
type
  Call_CatalogListCredentials_564167 = ref object of OpenApiRestCall_563564
proc url_CatalogListCredentials_564169(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/credentials")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogListCredentials_564168(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of credentials from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the schema.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564170 = path.getOrDefault("databaseName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "databaseName", valid_564170
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564171 = query.getOrDefault("$top")
  valid_564171 = validateParameter(valid_564171, JInt, required = false, default = nil)
  if valid_564171 != nil:
    section.add "$top", valid_564171
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564172 = query.getOrDefault("api-version")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "api-version", valid_564172
  var valid_564173 = query.getOrDefault("$select")
  valid_564173 = validateParameter(valid_564173, JString, required = false,
                                 default = nil)
  if valid_564173 != nil:
    section.add "$select", valid_564173
  var valid_564174 = query.getOrDefault("$count")
  valid_564174 = validateParameter(valid_564174, JBool, required = false, default = nil)
  if valid_564174 != nil:
    section.add "$count", valid_564174
  var valid_564175 = query.getOrDefault("$orderby")
  valid_564175 = validateParameter(valid_564175, JString, required = false,
                                 default = nil)
  if valid_564175 != nil:
    section.add "$orderby", valid_564175
  var valid_564176 = query.getOrDefault("$skip")
  valid_564176 = validateParameter(valid_564176, JInt, required = false, default = nil)
  if valid_564176 != nil:
    section.add "$skip", valid_564176
  var valid_564177 = query.getOrDefault("$filter")
  valid_564177 = validateParameter(valid_564177, JString, required = false,
                                 default = nil)
  if valid_564177 != nil:
    section.add "$filter", valid_564177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564178: Call_CatalogListCredentials_564167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of credentials from the Data Lake Analytics catalog.
  ## 
  let valid = call_564178.validator(path, query, header, formData, body)
  let scheme = call_564178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564178.url(scheme.get, call_564178.host, call_564178.base,
                         call_564178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564178, url, valid)

proc call*(call_564179: Call_CatalogListCredentials_564167; apiVersion: string;
          databaseName: string; Top: int = 0; Select: string = ""; Count: bool = false;
          Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListCredentials
  ## Retrieves the list of credentials from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the schema.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_564180 = newJObject()
  var query_564181 = newJObject()
  add(query_564181, "$top", newJInt(Top))
  add(query_564181, "api-version", newJString(apiVersion))
  add(query_564181, "$select", newJString(Select))
  add(query_564181, "$count", newJBool(Count))
  add(path_564180, "databaseName", newJString(databaseName))
  add(query_564181, "$orderby", newJString(Orderby))
  add(query_564181, "$skip", newJInt(Skip))
  add(query_564181, "$filter", newJString(Filter))
  result = call_564179.call(path_564180, query_564181, nil, nil, nil)

var catalogListCredentials* = Call_CatalogListCredentials_564167(
    name: "catalogListCredentials", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/credentials",
    validator: validate_CatalogListCredentials_564168, base: "",
    url: url_CatalogListCredentials_564169, schemes: {Scheme.Https})
type
  Call_CatalogCreateCredential_564192 = ref object of OpenApiRestCall_563564
proc url_CatalogCreateCredential_564194(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "credentialName" in path, "`credentialName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/credentials/"),
               (kind: VariableSegment, value: "credentialName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogCreateCredential_564193(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the specified credential for use with external data sources in the specified database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database in which to create the credential. Note: This is NOT an external database name, but the name of an existing U-SQL database that should contain the new credential object.
  ##   credentialName: JString (required)
  ##                 : The name of the credential.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564212 = path.getOrDefault("databaseName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "databaseName", valid_564212
  var valid_564213 = path.getOrDefault("credentialName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "credentialName", valid_564213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564214 = query.getOrDefault("api-version")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "api-version", valid_564214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters required to create the credential (name and password)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564216: Call_CatalogCreateCredential_564192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the specified credential for use with external data sources in the specified database.
  ## 
  let valid = call_564216.validator(path, query, header, formData, body)
  let scheme = call_564216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564216.url(scheme.get, call_564216.host, call_564216.base,
                         call_564216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564216, url, valid)

proc call*(call_564217: Call_CatalogCreateCredential_564192; apiVersion: string;
          databaseName: string; credentialName: string; parameters: JsonNode): Recallable =
  ## catalogCreateCredential
  ## Creates the specified credential for use with external data sources in the specified database.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database in which to create the credential. Note: This is NOT an external database name, but the name of an existing U-SQL database that should contain the new credential object.
  ##   credentialName: string (required)
  ##                 : The name of the credential.
  ##   parameters: JObject (required)
  ##             : The parameters required to create the credential (name and password)
  var path_564218 = newJObject()
  var query_564219 = newJObject()
  var body_564220 = newJObject()
  add(query_564219, "api-version", newJString(apiVersion))
  add(path_564218, "databaseName", newJString(databaseName))
  add(path_564218, "credentialName", newJString(credentialName))
  if parameters != nil:
    body_564220 = parameters
  result = call_564217.call(path_564218, query_564219, nil, nil, body_564220)

var catalogCreateCredential* = Call_CatalogCreateCredential_564192(
    name: "catalogCreateCredential", meth: HttpMethod.HttpPut, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/credentials/{credentialName}",
    validator: validate_CatalogCreateCredential_564193, base: "",
    url: url_CatalogCreateCredential_564194, schemes: {Scheme.Https})
type
  Call_CatalogDeleteCredential_564221 = ref object of OpenApiRestCall_563564
proc url_CatalogDeleteCredential_564223(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "credentialName" in path, "`credentialName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/credentials/"),
               (kind: VariableSegment, value: "credentialName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogDeleteCredential_564222(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified credential in the specified database
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the credential.
  ##   credentialName: JString (required)
  ##                 : The name of the credential to delete
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564224 = path.getOrDefault("databaseName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "databaseName", valid_564224
  var valid_564225 = path.getOrDefault("credentialName")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "credentialName", valid_564225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   cascade: JBool
  ##          : Indicates if the delete should be a cascading delete (which deletes all resources dependent on the credential as well as the credential) or not. If false will fail if there are any resources relying on the credential.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564226 = query.getOrDefault("api-version")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "api-version", valid_564226
  var valid_564240 = query.getOrDefault("cascade")
  valid_564240 = validateParameter(valid_564240, JBool, required = false,
                                 default = newJBool(false))
  if valid_564240 != nil:
    section.add "cascade", valid_564240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : The parameters to delete a credential if the current user is not the account owner.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564242: Call_CatalogDeleteCredential_564221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified credential in the specified database
  ## 
  let valid = call_564242.validator(path, query, header, formData, body)
  let scheme = call_564242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564242.url(scheme.get, call_564242.host, call_564242.base,
                         call_564242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564242, url, valid)

proc call*(call_564243: Call_CatalogDeleteCredential_564221; apiVersion: string;
          databaseName: string; credentialName: string; cascade: bool = false;
          parameters: JsonNode = nil): Recallable =
  ## catalogDeleteCredential
  ## Deletes the specified credential in the specified database
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the credential.
  ##   credentialName: string (required)
  ##                 : The name of the credential to delete
  ##   cascade: bool
  ##          : Indicates if the delete should be a cascading delete (which deletes all resources dependent on the credential as well as the credential) or not. If false will fail if there are any resources relying on the credential.
  ##   parameters: JObject
  ##             : The parameters to delete a credential if the current user is not the account owner.
  var path_564244 = newJObject()
  var query_564245 = newJObject()
  var body_564246 = newJObject()
  add(query_564245, "api-version", newJString(apiVersion))
  add(path_564244, "databaseName", newJString(databaseName))
  add(path_564244, "credentialName", newJString(credentialName))
  add(query_564245, "cascade", newJBool(cascade))
  if parameters != nil:
    body_564246 = parameters
  result = call_564243.call(path_564244, query_564245, nil, nil, body_564246)

var catalogDeleteCredential* = Call_CatalogDeleteCredential_564221(
    name: "catalogDeleteCredential", meth: HttpMethod.HttpPost, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/credentials/{credentialName}",
    validator: validate_CatalogDeleteCredential_564222, base: "",
    url: url_CatalogDeleteCredential_564223, schemes: {Scheme.Https})
type
  Call_CatalogGetCredential_564182 = ref object of OpenApiRestCall_563564
proc url_CatalogGetCredential_564184(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "credentialName" in path, "`credentialName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/credentials/"),
               (kind: VariableSegment, value: "credentialName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogGetCredential_564183(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the specified credential from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the schema.
  ##   credentialName: JString (required)
  ##                 : The name of the credential.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564185 = path.getOrDefault("databaseName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "databaseName", valid_564185
  var valid_564186 = path.getOrDefault("credentialName")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "credentialName", valid_564186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564187 = query.getOrDefault("api-version")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "api-version", valid_564187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564188: Call_CatalogGetCredential_564182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified credential from the Data Lake Analytics catalog.
  ## 
  let valid = call_564188.validator(path, query, header, formData, body)
  let scheme = call_564188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564188.url(scheme.get, call_564188.host, call_564188.base,
                         call_564188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564188, url, valid)

proc call*(call_564189: Call_CatalogGetCredential_564182; apiVersion: string;
          databaseName: string; credentialName: string): Recallable =
  ## catalogGetCredential
  ## Retrieves the specified credential from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the schema.
  ##   credentialName: string (required)
  ##                 : The name of the credential.
  var path_564190 = newJObject()
  var query_564191 = newJObject()
  add(query_564191, "api-version", newJString(apiVersion))
  add(path_564190, "databaseName", newJString(databaseName))
  add(path_564190, "credentialName", newJString(credentialName))
  result = call_564189.call(path_564190, query_564191, nil, nil, nil)

var catalogGetCredential* = Call_CatalogGetCredential_564182(
    name: "catalogGetCredential", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/credentials/{credentialName}",
    validator: validate_CatalogGetCredential_564183, base: "",
    url: url_CatalogGetCredential_564184, schemes: {Scheme.Https})
type
  Call_CatalogUpdateCredential_564247 = ref object of OpenApiRestCall_563564
proc url_CatalogUpdateCredential_564249(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "credentialName" in path, "`credentialName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/credentials/"),
               (kind: VariableSegment, value: "credentialName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogUpdateCredential_564248(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies the specified credential for use with external data sources in the specified database
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the credential.
  ##   credentialName: JString (required)
  ##                 : The name of the credential.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564250 = path.getOrDefault("databaseName")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "databaseName", valid_564250
  var valid_564251 = path.getOrDefault("credentialName")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "credentialName", valid_564251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564252 = query.getOrDefault("api-version")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "api-version", valid_564252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters required to modify the credential (name and password)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564254: Call_CatalogUpdateCredential_564247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the specified credential for use with external data sources in the specified database
  ## 
  let valid = call_564254.validator(path, query, header, formData, body)
  let scheme = call_564254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564254.url(scheme.get, call_564254.host, call_564254.base,
                         call_564254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564254, url, valid)

proc call*(call_564255: Call_CatalogUpdateCredential_564247; apiVersion: string;
          databaseName: string; credentialName: string; parameters: JsonNode): Recallable =
  ## catalogUpdateCredential
  ## Modifies the specified credential for use with external data sources in the specified database
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the credential.
  ##   credentialName: string (required)
  ##                 : The name of the credential.
  ##   parameters: JObject (required)
  ##             : The parameters required to modify the credential (name and password)
  var path_564256 = newJObject()
  var query_564257 = newJObject()
  var body_564258 = newJObject()
  add(query_564257, "api-version", newJString(apiVersion))
  add(path_564256, "databaseName", newJString(databaseName))
  add(path_564256, "credentialName", newJString(credentialName))
  if parameters != nil:
    body_564258 = parameters
  result = call_564255.call(path_564256, query_564257, nil, nil, body_564258)

var catalogUpdateCredential* = Call_CatalogUpdateCredential_564247(
    name: "catalogUpdateCredential", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/credentials/{credentialName}",
    validator: validate_CatalogUpdateCredential_564248, base: "",
    url: url_CatalogUpdateCredential_564249, schemes: {Scheme.Https})
type
  Call_CatalogListExternalDataSources_564259 = ref object of OpenApiRestCall_563564
proc url_CatalogListExternalDataSources_564261(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/externaldatasources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogListExternalDataSources_564260(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of external data sources from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the external data sources.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564262 = path.getOrDefault("databaseName")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "databaseName", valid_564262
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564263 = query.getOrDefault("$top")
  valid_564263 = validateParameter(valid_564263, JInt, required = false, default = nil)
  if valid_564263 != nil:
    section.add "$top", valid_564263
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564264 = query.getOrDefault("api-version")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "api-version", valid_564264
  var valid_564265 = query.getOrDefault("$select")
  valid_564265 = validateParameter(valid_564265, JString, required = false,
                                 default = nil)
  if valid_564265 != nil:
    section.add "$select", valid_564265
  var valid_564266 = query.getOrDefault("$count")
  valid_564266 = validateParameter(valid_564266, JBool, required = false, default = nil)
  if valid_564266 != nil:
    section.add "$count", valid_564266
  var valid_564267 = query.getOrDefault("$orderby")
  valid_564267 = validateParameter(valid_564267, JString, required = false,
                                 default = nil)
  if valid_564267 != nil:
    section.add "$orderby", valid_564267
  var valid_564268 = query.getOrDefault("$skip")
  valid_564268 = validateParameter(valid_564268, JInt, required = false, default = nil)
  if valid_564268 != nil:
    section.add "$skip", valid_564268
  var valid_564269 = query.getOrDefault("$filter")
  valid_564269 = validateParameter(valid_564269, JString, required = false,
                                 default = nil)
  if valid_564269 != nil:
    section.add "$filter", valid_564269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564270: Call_CatalogListExternalDataSources_564259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of external data sources from the Data Lake Analytics catalog.
  ## 
  let valid = call_564270.validator(path, query, header, formData, body)
  let scheme = call_564270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564270.url(scheme.get, call_564270.host, call_564270.base,
                         call_564270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564270, url, valid)

proc call*(call_564271: Call_CatalogListExternalDataSources_564259;
          apiVersion: string; databaseName: string; Top: int = 0; Select: string = "";
          Count: bool = false; Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListExternalDataSources
  ## Retrieves the list of external data sources from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the external data sources.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_564272 = newJObject()
  var query_564273 = newJObject()
  add(query_564273, "$top", newJInt(Top))
  add(query_564273, "api-version", newJString(apiVersion))
  add(query_564273, "$select", newJString(Select))
  add(query_564273, "$count", newJBool(Count))
  add(path_564272, "databaseName", newJString(databaseName))
  add(query_564273, "$orderby", newJString(Orderby))
  add(query_564273, "$skip", newJInt(Skip))
  add(query_564273, "$filter", newJString(Filter))
  result = call_564271.call(path_564272, query_564273, nil, nil, nil)

var catalogListExternalDataSources* = Call_CatalogListExternalDataSources_564259(
    name: "catalogListExternalDataSources", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/externaldatasources",
    validator: validate_CatalogListExternalDataSources_564260, base: "",
    url: url_CatalogListExternalDataSources_564261, schemes: {Scheme.Https})
type
  Call_CatalogGetExternalDataSource_564274 = ref object of OpenApiRestCall_563564
proc url_CatalogGetExternalDataSource_564276(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "externalDataSourceName" in path,
        "`externalDataSourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/externaldatasources/"),
               (kind: VariableSegment, value: "externalDataSourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogGetExternalDataSource_564275(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the specified external data source from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   externalDataSourceName: JString (required)
  ##                         : The name of the external data source.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the external data source.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `externalDataSourceName` field"
  var valid_564277 = path.getOrDefault("externalDataSourceName")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "externalDataSourceName", valid_564277
  var valid_564278 = path.getOrDefault("databaseName")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "databaseName", valid_564278
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564279 = query.getOrDefault("api-version")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "api-version", valid_564279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564280: Call_CatalogGetExternalDataSource_564274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified external data source from the Data Lake Analytics catalog.
  ## 
  let valid = call_564280.validator(path, query, header, formData, body)
  let scheme = call_564280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564280.url(scheme.get, call_564280.host, call_564280.base,
                         call_564280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564280, url, valid)

proc call*(call_564281: Call_CatalogGetExternalDataSource_564274;
          apiVersion: string; externalDataSourceName: string; databaseName: string): Recallable =
  ## catalogGetExternalDataSource
  ## Retrieves the specified external data source from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   externalDataSourceName: string (required)
  ##                         : The name of the external data source.
  ##   databaseName: string (required)
  ##               : The name of the database containing the external data source.
  var path_564282 = newJObject()
  var query_564283 = newJObject()
  add(query_564283, "api-version", newJString(apiVersion))
  add(path_564282, "externalDataSourceName", newJString(externalDataSourceName))
  add(path_564282, "databaseName", newJString(databaseName))
  result = call_564281.call(path_564282, query_564283, nil, nil, nil)

var catalogGetExternalDataSource* = Call_CatalogGetExternalDataSource_564274(
    name: "catalogGetExternalDataSource", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/externaldatasources/{externalDataSourceName}",
    validator: validate_CatalogGetExternalDataSource_564275, base: "",
    url: url_CatalogGetExternalDataSource_564276, schemes: {Scheme.Https})
type
  Call_CatalogListSchemas_564284 = ref object of OpenApiRestCall_563564
proc url_CatalogListSchemas_564286(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogListSchemas_564285(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves the list of schemas from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the schema.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564287 = path.getOrDefault("databaseName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "databaseName", valid_564287
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564288 = query.getOrDefault("$top")
  valid_564288 = validateParameter(valid_564288, JInt, required = false, default = nil)
  if valid_564288 != nil:
    section.add "$top", valid_564288
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564289 = query.getOrDefault("api-version")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "api-version", valid_564289
  var valid_564290 = query.getOrDefault("$select")
  valid_564290 = validateParameter(valid_564290, JString, required = false,
                                 default = nil)
  if valid_564290 != nil:
    section.add "$select", valid_564290
  var valid_564291 = query.getOrDefault("$count")
  valid_564291 = validateParameter(valid_564291, JBool, required = false, default = nil)
  if valid_564291 != nil:
    section.add "$count", valid_564291
  var valid_564292 = query.getOrDefault("$orderby")
  valid_564292 = validateParameter(valid_564292, JString, required = false,
                                 default = nil)
  if valid_564292 != nil:
    section.add "$orderby", valid_564292
  var valid_564293 = query.getOrDefault("$skip")
  valid_564293 = validateParameter(valid_564293, JInt, required = false, default = nil)
  if valid_564293 != nil:
    section.add "$skip", valid_564293
  var valid_564294 = query.getOrDefault("$filter")
  valid_564294 = validateParameter(valid_564294, JString, required = false,
                                 default = nil)
  if valid_564294 != nil:
    section.add "$filter", valid_564294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564295: Call_CatalogListSchemas_564284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of schemas from the Data Lake Analytics catalog.
  ## 
  let valid = call_564295.validator(path, query, header, formData, body)
  let scheme = call_564295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564295.url(scheme.get, call_564295.host, call_564295.base,
                         call_564295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564295, url, valid)

proc call*(call_564296: Call_CatalogListSchemas_564284; apiVersion: string;
          databaseName: string; Top: int = 0; Select: string = ""; Count: bool = false;
          Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListSchemas
  ## Retrieves the list of schemas from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the schema.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_564297 = newJObject()
  var query_564298 = newJObject()
  add(query_564298, "$top", newJInt(Top))
  add(query_564298, "api-version", newJString(apiVersion))
  add(query_564298, "$select", newJString(Select))
  add(query_564298, "$count", newJBool(Count))
  add(path_564297, "databaseName", newJString(databaseName))
  add(query_564298, "$orderby", newJString(Orderby))
  add(query_564298, "$skip", newJInt(Skip))
  add(query_564298, "$filter", newJString(Filter))
  result = call_564296.call(path_564297, query_564298, nil, nil, nil)

var catalogListSchemas* = Call_CatalogListSchemas_564284(
    name: "catalogListSchemas", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas",
    validator: validate_CatalogListSchemas_564285, base: "",
    url: url_CatalogListSchemas_564286, schemes: {Scheme.Https})
type
  Call_CatalogGetSchema_564299 = ref object of OpenApiRestCall_563564
proc url_CatalogGetSchema_564301(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogGetSchema_564300(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves the specified schema from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the schema.
  ##   schemaName: JString (required)
  ##             : The name of the schema.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564302 = path.getOrDefault("databaseName")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "databaseName", valid_564302
  var valid_564303 = path.getOrDefault("schemaName")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "schemaName", valid_564303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564304 = query.getOrDefault("api-version")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "api-version", valid_564304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564305: Call_CatalogGetSchema_564299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified schema from the Data Lake Analytics catalog.
  ## 
  let valid = call_564305.validator(path, query, header, formData, body)
  let scheme = call_564305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564305.url(scheme.get, call_564305.host, call_564305.base,
                         call_564305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564305, url, valid)

proc call*(call_564306: Call_CatalogGetSchema_564299; apiVersion: string;
          databaseName: string; schemaName: string): Recallable =
  ## catalogGetSchema
  ## Retrieves the specified schema from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the schema.
  ##   schemaName: string (required)
  ##             : The name of the schema.
  var path_564307 = newJObject()
  var query_564308 = newJObject()
  add(query_564308, "api-version", newJString(apiVersion))
  add(path_564307, "databaseName", newJString(databaseName))
  add(path_564307, "schemaName", newJString(schemaName))
  result = call_564306.call(path_564307, query_564308, nil, nil, nil)

var catalogGetSchema* = Call_CatalogGetSchema_564299(name: "catalogGetSchema",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}",
    validator: validate_CatalogGetSchema_564300, base: "",
    url: url_CatalogGetSchema_564301, schemes: {Scheme.Https})
type
  Call_CatalogListPackages_564309 = ref object of OpenApiRestCall_563564
proc url_CatalogListPackages_564311(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/packages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogListPackages_564310(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves the list of packages from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the packages.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the packages.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564312 = path.getOrDefault("databaseName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "databaseName", valid_564312
  var valid_564313 = path.getOrDefault("schemaName")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "schemaName", valid_564313
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564314 = query.getOrDefault("$top")
  valid_564314 = validateParameter(valid_564314, JInt, required = false, default = nil)
  if valid_564314 != nil:
    section.add "$top", valid_564314
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564315 = query.getOrDefault("api-version")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "api-version", valid_564315
  var valid_564316 = query.getOrDefault("$select")
  valid_564316 = validateParameter(valid_564316, JString, required = false,
                                 default = nil)
  if valid_564316 != nil:
    section.add "$select", valid_564316
  var valid_564317 = query.getOrDefault("$count")
  valid_564317 = validateParameter(valid_564317, JBool, required = false, default = nil)
  if valid_564317 != nil:
    section.add "$count", valid_564317
  var valid_564318 = query.getOrDefault("$orderby")
  valid_564318 = validateParameter(valid_564318, JString, required = false,
                                 default = nil)
  if valid_564318 != nil:
    section.add "$orderby", valid_564318
  var valid_564319 = query.getOrDefault("$skip")
  valid_564319 = validateParameter(valid_564319, JInt, required = false, default = nil)
  if valid_564319 != nil:
    section.add "$skip", valid_564319
  var valid_564320 = query.getOrDefault("$filter")
  valid_564320 = validateParameter(valid_564320, JString, required = false,
                                 default = nil)
  if valid_564320 != nil:
    section.add "$filter", valid_564320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564321: Call_CatalogListPackages_564309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of packages from the Data Lake Analytics catalog.
  ## 
  let valid = call_564321.validator(path, query, header, formData, body)
  let scheme = call_564321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564321.url(scheme.get, call_564321.host, call_564321.base,
                         call_564321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564321, url, valid)

proc call*(call_564322: Call_CatalogListPackages_564309; apiVersion: string;
          databaseName: string; schemaName: string; Top: int = 0; Select: string = "";
          Count: bool = false; Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListPackages
  ## Retrieves the list of packages from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the packages.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the packages.
  var path_564323 = newJObject()
  var query_564324 = newJObject()
  add(query_564324, "$top", newJInt(Top))
  add(query_564324, "api-version", newJString(apiVersion))
  add(query_564324, "$select", newJString(Select))
  add(query_564324, "$count", newJBool(Count))
  add(path_564323, "databaseName", newJString(databaseName))
  add(query_564324, "$orderby", newJString(Orderby))
  add(query_564324, "$skip", newJInt(Skip))
  add(query_564324, "$filter", newJString(Filter))
  add(path_564323, "schemaName", newJString(schemaName))
  result = call_564322.call(path_564323, query_564324, nil, nil, nil)

var catalogListPackages* = Call_CatalogListPackages_564309(
    name: "catalogListPackages", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/packages",
    validator: validate_CatalogListPackages_564310, base: "",
    url: url_CatalogListPackages_564311, schemes: {Scheme.Https})
type
  Call_CatalogGetPackage_564325 = ref object of OpenApiRestCall_563564
proc url_CatalogGetPackage_564327(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  assert "packageName" in path, "`packageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/packages/"),
               (kind: VariableSegment, value: "packageName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogGetPackage_564326(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves the specified package from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The name of the package.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the package.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the package.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_564328 = path.getOrDefault("packageName")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "packageName", valid_564328
  var valid_564329 = path.getOrDefault("databaseName")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "databaseName", valid_564329
  var valid_564330 = path.getOrDefault("schemaName")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "schemaName", valid_564330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564331 = query.getOrDefault("api-version")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "api-version", valid_564331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564332: Call_CatalogGetPackage_564325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified package from the Data Lake Analytics catalog.
  ## 
  let valid = call_564332.validator(path, query, header, formData, body)
  let scheme = call_564332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564332.url(scheme.get, call_564332.host, call_564332.base,
                         call_564332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564332, url, valid)

proc call*(call_564333: Call_CatalogGetPackage_564325; packageName: string;
          apiVersion: string; databaseName: string; schemaName: string): Recallable =
  ## catalogGetPackage
  ## Retrieves the specified package from the Data Lake Analytics catalog.
  ##   packageName: string (required)
  ##              : The name of the package.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the package.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the package.
  var path_564334 = newJObject()
  var query_564335 = newJObject()
  add(path_564334, "packageName", newJString(packageName))
  add(query_564335, "api-version", newJString(apiVersion))
  add(path_564334, "databaseName", newJString(databaseName))
  add(path_564334, "schemaName", newJString(schemaName))
  result = call_564333.call(path_564334, query_564335, nil, nil, nil)

var catalogGetPackage* = Call_CatalogGetPackage_564325(name: "catalogGetPackage",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/packages/{packageName}",
    validator: validate_CatalogGetPackage_564326, base: "",
    url: url_CatalogGetPackage_564327, schemes: {Scheme.Https})
type
  Call_CatalogListProcedures_564336 = ref object of OpenApiRestCall_563564
proc url_CatalogListProcedures_564338(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/procedures")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogListProcedures_564337(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of procedures from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the procedures.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the procedures.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564339 = path.getOrDefault("databaseName")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "databaseName", valid_564339
  var valid_564340 = path.getOrDefault("schemaName")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "schemaName", valid_564340
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564341 = query.getOrDefault("$top")
  valid_564341 = validateParameter(valid_564341, JInt, required = false, default = nil)
  if valid_564341 != nil:
    section.add "$top", valid_564341
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564342 = query.getOrDefault("api-version")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "api-version", valid_564342
  var valid_564343 = query.getOrDefault("$select")
  valid_564343 = validateParameter(valid_564343, JString, required = false,
                                 default = nil)
  if valid_564343 != nil:
    section.add "$select", valid_564343
  var valid_564344 = query.getOrDefault("$count")
  valid_564344 = validateParameter(valid_564344, JBool, required = false, default = nil)
  if valid_564344 != nil:
    section.add "$count", valid_564344
  var valid_564345 = query.getOrDefault("$orderby")
  valid_564345 = validateParameter(valid_564345, JString, required = false,
                                 default = nil)
  if valid_564345 != nil:
    section.add "$orderby", valid_564345
  var valid_564346 = query.getOrDefault("$skip")
  valid_564346 = validateParameter(valid_564346, JInt, required = false, default = nil)
  if valid_564346 != nil:
    section.add "$skip", valid_564346
  var valid_564347 = query.getOrDefault("$filter")
  valid_564347 = validateParameter(valid_564347, JString, required = false,
                                 default = nil)
  if valid_564347 != nil:
    section.add "$filter", valid_564347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564348: Call_CatalogListProcedures_564336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of procedures from the Data Lake Analytics catalog.
  ## 
  let valid = call_564348.validator(path, query, header, formData, body)
  let scheme = call_564348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564348.url(scheme.get, call_564348.host, call_564348.base,
                         call_564348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564348, url, valid)

proc call*(call_564349: Call_CatalogListProcedures_564336; apiVersion: string;
          databaseName: string; schemaName: string; Top: int = 0; Select: string = "";
          Count: bool = false; Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListProcedures
  ## Retrieves the list of procedures from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the procedures.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the procedures.
  var path_564350 = newJObject()
  var query_564351 = newJObject()
  add(query_564351, "$top", newJInt(Top))
  add(query_564351, "api-version", newJString(apiVersion))
  add(query_564351, "$select", newJString(Select))
  add(query_564351, "$count", newJBool(Count))
  add(path_564350, "databaseName", newJString(databaseName))
  add(query_564351, "$orderby", newJString(Orderby))
  add(query_564351, "$skip", newJInt(Skip))
  add(query_564351, "$filter", newJString(Filter))
  add(path_564350, "schemaName", newJString(schemaName))
  result = call_564349.call(path_564350, query_564351, nil, nil, nil)

var catalogListProcedures* = Call_CatalogListProcedures_564336(
    name: "catalogListProcedures", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/procedures",
    validator: validate_CatalogListProcedures_564337, base: "",
    url: url_CatalogListProcedures_564338, schemes: {Scheme.Https})
type
  Call_CatalogGetProcedure_564352 = ref object of OpenApiRestCall_563564
proc url_CatalogGetProcedure_564354(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  assert "procedureName" in path, "`procedureName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/procedures/"),
               (kind: VariableSegment, value: "procedureName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogGetProcedure_564353(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves the specified procedure from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   procedureName: JString (required)
  ##                : The name of the procedure.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the procedure.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the procedure.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `procedureName` field"
  var valid_564355 = path.getOrDefault("procedureName")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "procedureName", valid_564355
  var valid_564356 = path.getOrDefault("databaseName")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "databaseName", valid_564356
  var valid_564357 = path.getOrDefault("schemaName")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "schemaName", valid_564357
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564358 = query.getOrDefault("api-version")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "api-version", valid_564358
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564359: Call_CatalogGetProcedure_564352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified procedure from the Data Lake Analytics catalog.
  ## 
  let valid = call_564359.validator(path, query, header, formData, body)
  let scheme = call_564359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564359.url(scheme.get, call_564359.host, call_564359.base,
                         call_564359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564359, url, valid)

proc call*(call_564360: Call_CatalogGetProcedure_564352; procedureName: string;
          apiVersion: string; databaseName: string; schemaName: string): Recallable =
  ## catalogGetProcedure
  ## Retrieves the specified procedure from the Data Lake Analytics catalog.
  ##   procedureName: string (required)
  ##                : The name of the procedure.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the procedure.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the procedure.
  var path_564361 = newJObject()
  var query_564362 = newJObject()
  add(path_564361, "procedureName", newJString(procedureName))
  add(query_564362, "api-version", newJString(apiVersion))
  add(path_564361, "databaseName", newJString(databaseName))
  add(path_564361, "schemaName", newJString(schemaName))
  result = call_564360.call(path_564361, query_564362, nil, nil, nil)

var catalogGetProcedure* = Call_CatalogGetProcedure_564352(
    name: "catalogGetProcedure", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/procedures/{procedureName}",
    validator: validate_CatalogGetProcedure_564353, base: "",
    url: url_CatalogGetProcedure_564354, schemes: {Scheme.Https})
type
  Call_CatalogListTableStatisticsByDatabaseAndSchema_564363 = ref object of OpenApiRestCall_563564
proc url_CatalogListTableStatisticsByDatabaseAndSchema_564365(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/statistics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogListTableStatisticsByDatabaseAndSchema_564364(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves the list of all table statistics within the specified schema from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the statistics.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the statistics.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564366 = path.getOrDefault("databaseName")
  valid_564366 = validateParameter(valid_564366, JString, required = true,
                                 default = nil)
  if valid_564366 != nil:
    section.add "databaseName", valid_564366
  var valid_564367 = path.getOrDefault("schemaName")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "schemaName", valid_564367
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564368 = query.getOrDefault("$top")
  valid_564368 = validateParameter(valid_564368, JInt, required = false, default = nil)
  if valid_564368 != nil:
    section.add "$top", valid_564368
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564369 = query.getOrDefault("api-version")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "api-version", valid_564369
  var valid_564370 = query.getOrDefault("$select")
  valid_564370 = validateParameter(valid_564370, JString, required = false,
                                 default = nil)
  if valid_564370 != nil:
    section.add "$select", valid_564370
  var valid_564371 = query.getOrDefault("$count")
  valid_564371 = validateParameter(valid_564371, JBool, required = false, default = nil)
  if valid_564371 != nil:
    section.add "$count", valid_564371
  var valid_564372 = query.getOrDefault("$orderby")
  valid_564372 = validateParameter(valid_564372, JString, required = false,
                                 default = nil)
  if valid_564372 != nil:
    section.add "$orderby", valid_564372
  var valid_564373 = query.getOrDefault("$skip")
  valid_564373 = validateParameter(valid_564373, JInt, required = false, default = nil)
  if valid_564373 != nil:
    section.add "$skip", valid_564373
  var valid_564374 = query.getOrDefault("$filter")
  valid_564374 = validateParameter(valid_564374, JString, required = false,
                                 default = nil)
  if valid_564374 != nil:
    section.add "$filter", valid_564374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564375: Call_CatalogListTableStatisticsByDatabaseAndSchema_564363;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of all table statistics within the specified schema from the Data Lake Analytics catalog.
  ## 
  let valid = call_564375.validator(path, query, header, formData, body)
  let scheme = call_564375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564375.url(scheme.get, call_564375.host, call_564375.base,
                         call_564375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564375, url, valid)

proc call*(call_564376: Call_CatalogListTableStatisticsByDatabaseAndSchema_564363;
          apiVersion: string; databaseName: string; schemaName: string; Top: int = 0;
          Select: string = ""; Count: bool = false; Orderby: string = ""; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## catalogListTableStatisticsByDatabaseAndSchema
  ## Retrieves the list of all table statistics within the specified schema from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the statistics.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the statistics.
  var path_564377 = newJObject()
  var query_564378 = newJObject()
  add(query_564378, "$top", newJInt(Top))
  add(query_564378, "api-version", newJString(apiVersion))
  add(query_564378, "$select", newJString(Select))
  add(query_564378, "$count", newJBool(Count))
  add(path_564377, "databaseName", newJString(databaseName))
  add(query_564378, "$orderby", newJString(Orderby))
  add(query_564378, "$skip", newJInt(Skip))
  add(query_564378, "$filter", newJString(Filter))
  add(path_564377, "schemaName", newJString(schemaName))
  result = call_564376.call(path_564377, query_564378, nil, nil, nil)

var catalogListTableStatisticsByDatabaseAndSchema* = Call_CatalogListTableStatisticsByDatabaseAndSchema_564363(
    name: "catalogListTableStatisticsByDatabaseAndSchema",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/statistics",
    validator: validate_CatalogListTableStatisticsByDatabaseAndSchema_564364,
    base: "", url: url_CatalogListTableStatisticsByDatabaseAndSchema_564365,
    schemes: {Scheme.Https})
type
  Call_CatalogListTables_564379 = ref object of OpenApiRestCall_563564
proc url_CatalogListTables_564381(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/tables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogListTables_564380(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves the list of tables from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the tables.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the tables.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564382 = path.getOrDefault("databaseName")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "databaseName", valid_564382
  var valid_564383 = path.getOrDefault("schemaName")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "schemaName", valid_564383
  result.add "path", section
  ## parameters in `query` object:
  ##   basic: JBool
  ##        : The basic switch indicates what level of information to return when listing tables. When basic is true, only database_name, schema_name, table_name and version are returned for each table, otherwise all table metadata is returned. By default, it is false. Optional.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564384 = query.getOrDefault("basic")
  valid_564384 = validateParameter(valid_564384, JBool, required = false,
                                 default = newJBool(false))
  if valid_564384 != nil:
    section.add "basic", valid_564384
  var valid_564385 = query.getOrDefault("$top")
  valid_564385 = validateParameter(valid_564385, JInt, required = false, default = nil)
  if valid_564385 != nil:
    section.add "$top", valid_564385
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564386 = query.getOrDefault("api-version")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "api-version", valid_564386
  var valid_564387 = query.getOrDefault("$select")
  valid_564387 = validateParameter(valid_564387, JString, required = false,
                                 default = nil)
  if valid_564387 != nil:
    section.add "$select", valid_564387
  var valid_564388 = query.getOrDefault("$count")
  valid_564388 = validateParameter(valid_564388, JBool, required = false, default = nil)
  if valid_564388 != nil:
    section.add "$count", valid_564388
  var valid_564389 = query.getOrDefault("$orderby")
  valid_564389 = validateParameter(valid_564389, JString, required = false,
                                 default = nil)
  if valid_564389 != nil:
    section.add "$orderby", valid_564389
  var valid_564390 = query.getOrDefault("$skip")
  valid_564390 = validateParameter(valid_564390, JInt, required = false, default = nil)
  if valid_564390 != nil:
    section.add "$skip", valid_564390
  var valid_564391 = query.getOrDefault("$filter")
  valid_564391 = validateParameter(valid_564391, JString, required = false,
                                 default = nil)
  if valid_564391 != nil:
    section.add "$filter", valid_564391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564392: Call_CatalogListTables_564379; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of tables from the Data Lake Analytics catalog.
  ## 
  let valid = call_564392.validator(path, query, header, formData, body)
  let scheme = call_564392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564392.url(scheme.get, call_564392.host, call_564392.base,
                         call_564392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564392, url, valid)

proc call*(call_564393: Call_CatalogListTables_564379; apiVersion: string;
          databaseName: string; schemaName: string; basic: bool = false; Top: int = 0;
          Select: string = ""; Count: bool = false; Orderby: string = ""; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## catalogListTables
  ## Retrieves the list of tables from the Data Lake Analytics catalog.
  ##   basic: bool
  ##        : The basic switch indicates what level of information to return when listing tables. When basic is true, only database_name, schema_name, table_name and version are returned for each table, otherwise all table metadata is returned. By default, it is false. Optional.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the tables.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the tables.
  var path_564394 = newJObject()
  var query_564395 = newJObject()
  add(query_564395, "basic", newJBool(basic))
  add(query_564395, "$top", newJInt(Top))
  add(query_564395, "api-version", newJString(apiVersion))
  add(query_564395, "$select", newJString(Select))
  add(query_564395, "$count", newJBool(Count))
  add(path_564394, "databaseName", newJString(databaseName))
  add(query_564395, "$orderby", newJString(Orderby))
  add(query_564395, "$skip", newJInt(Skip))
  add(query_564395, "$filter", newJString(Filter))
  add(path_564394, "schemaName", newJString(schemaName))
  result = call_564393.call(path_564394, query_564395, nil, nil, nil)

var catalogListTables* = Call_CatalogListTables_564379(name: "catalogListTables",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables",
    validator: validate_CatalogListTables_564380, base: "",
    url: url_CatalogListTables_564381, schemes: {Scheme.Https})
type
  Call_CatalogGetTable_564396 = ref object of OpenApiRestCall_563564
proc url_CatalogGetTable_564398(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogGetTable_564397(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Retrieves the specified table from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the table.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the table.
  ##   tableName: JString (required)
  ##            : The name of the table.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564399 = path.getOrDefault("databaseName")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "databaseName", valid_564399
  var valid_564400 = path.getOrDefault("schemaName")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "schemaName", valid_564400
  var valid_564401 = path.getOrDefault("tableName")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "tableName", valid_564401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564402 = query.getOrDefault("api-version")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "api-version", valid_564402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564403: Call_CatalogGetTable_564396; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table from the Data Lake Analytics catalog.
  ## 
  let valid = call_564403.validator(path, query, header, formData, body)
  let scheme = call_564403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564403.url(scheme.get, call_564403.host, call_564403.base,
                         call_564403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564403, url, valid)

proc call*(call_564404: Call_CatalogGetTable_564396; apiVersion: string;
          databaseName: string; schemaName: string; tableName: string): Recallable =
  ## catalogGetTable
  ## Retrieves the specified table from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the table.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the table.
  ##   tableName: string (required)
  ##            : The name of the table.
  var path_564405 = newJObject()
  var query_564406 = newJObject()
  add(query_564406, "api-version", newJString(apiVersion))
  add(path_564405, "databaseName", newJString(databaseName))
  add(path_564405, "schemaName", newJString(schemaName))
  add(path_564405, "tableName", newJString(tableName))
  result = call_564404.call(path_564405, query_564406, nil, nil, nil)

var catalogGetTable* = Call_CatalogGetTable_564396(name: "catalogGetTable",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}",
    validator: validate_CatalogGetTable_564397, base: "", url: url_CatalogGetTable_564398,
    schemes: {Scheme.Https})
type
  Call_CatalogListTablePartitions_564407 = ref object of OpenApiRestCall_563564
proc url_CatalogListTablePartitions_564409(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName"),
               (kind: ConstantSegment, value: "/partitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogListTablePartitions_564408(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of table partitions from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the partitions.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the partitions.
  ##   tableName: JString (required)
  ##            : The name of the table containing the partitions.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564410 = path.getOrDefault("databaseName")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "databaseName", valid_564410
  var valid_564411 = path.getOrDefault("schemaName")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = nil)
  if valid_564411 != nil:
    section.add "schemaName", valid_564411
  var valid_564412 = path.getOrDefault("tableName")
  valid_564412 = validateParameter(valid_564412, JString, required = true,
                                 default = nil)
  if valid_564412 != nil:
    section.add "tableName", valid_564412
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564413 = query.getOrDefault("$top")
  valid_564413 = validateParameter(valid_564413, JInt, required = false, default = nil)
  if valid_564413 != nil:
    section.add "$top", valid_564413
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564414 = query.getOrDefault("api-version")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "api-version", valid_564414
  var valid_564415 = query.getOrDefault("$select")
  valid_564415 = validateParameter(valid_564415, JString, required = false,
                                 default = nil)
  if valid_564415 != nil:
    section.add "$select", valid_564415
  var valid_564416 = query.getOrDefault("$count")
  valid_564416 = validateParameter(valid_564416, JBool, required = false, default = nil)
  if valid_564416 != nil:
    section.add "$count", valid_564416
  var valid_564417 = query.getOrDefault("$orderby")
  valid_564417 = validateParameter(valid_564417, JString, required = false,
                                 default = nil)
  if valid_564417 != nil:
    section.add "$orderby", valid_564417
  var valid_564418 = query.getOrDefault("$skip")
  valid_564418 = validateParameter(valid_564418, JInt, required = false, default = nil)
  if valid_564418 != nil:
    section.add "$skip", valid_564418
  var valid_564419 = query.getOrDefault("$filter")
  valid_564419 = validateParameter(valid_564419, JString, required = false,
                                 default = nil)
  if valid_564419 != nil:
    section.add "$filter", valid_564419
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564420: Call_CatalogListTablePartitions_564407; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table partitions from the Data Lake Analytics catalog.
  ## 
  let valid = call_564420.validator(path, query, header, formData, body)
  let scheme = call_564420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564420.url(scheme.get, call_564420.host, call_564420.base,
                         call_564420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564420, url, valid)

proc call*(call_564421: Call_CatalogListTablePartitions_564407; apiVersion: string;
          databaseName: string; schemaName: string; tableName: string; Top: int = 0;
          Select: string = ""; Count: bool = false; Orderby: string = ""; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## catalogListTablePartitions
  ## Retrieves the list of table partitions from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the partitions.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the partitions.
  ##   tableName: string (required)
  ##            : The name of the table containing the partitions.
  var path_564422 = newJObject()
  var query_564423 = newJObject()
  add(query_564423, "$top", newJInt(Top))
  add(query_564423, "api-version", newJString(apiVersion))
  add(query_564423, "$select", newJString(Select))
  add(query_564423, "$count", newJBool(Count))
  add(path_564422, "databaseName", newJString(databaseName))
  add(query_564423, "$orderby", newJString(Orderby))
  add(query_564423, "$skip", newJInt(Skip))
  add(query_564423, "$filter", newJString(Filter))
  add(path_564422, "schemaName", newJString(schemaName))
  add(path_564422, "tableName", newJString(tableName))
  result = call_564421.call(path_564422, query_564423, nil, nil, nil)

var catalogListTablePartitions* = Call_CatalogListTablePartitions_564407(
    name: "catalogListTablePartitions", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/partitions",
    validator: validate_CatalogListTablePartitions_564408, base: "",
    url: url_CatalogListTablePartitions_564409, schemes: {Scheme.Https})
type
  Call_CatalogGetTablePartition_564424 = ref object of OpenApiRestCall_563564
proc url_CatalogGetTablePartition_564426(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  assert "partitionName" in path, "`partitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName"),
               (kind: ConstantSegment, value: "/partitions/"),
               (kind: VariableSegment, value: "partitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogGetTablePartition_564425(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the specified table partition from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the partition.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the partition.
  ##   tableName: JString (required)
  ##            : The name of the table containing the partition.
  ##   partitionName: JString (required)
  ##                : The name of the table partition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564427 = path.getOrDefault("databaseName")
  valid_564427 = validateParameter(valid_564427, JString, required = true,
                                 default = nil)
  if valid_564427 != nil:
    section.add "databaseName", valid_564427
  var valid_564428 = path.getOrDefault("schemaName")
  valid_564428 = validateParameter(valid_564428, JString, required = true,
                                 default = nil)
  if valid_564428 != nil:
    section.add "schemaName", valid_564428
  var valid_564429 = path.getOrDefault("tableName")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "tableName", valid_564429
  var valid_564430 = path.getOrDefault("partitionName")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "partitionName", valid_564430
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564431 = query.getOrDefault("api-version")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "api-version", valid_564431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564432: Call_CatalogGetTablePartition_564424; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table partition from the Data Lake Analytics catalog.
  ## 
  let valid = call_564432.validator(path, query, header, formData, body)
  let scheme = call_564432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564432.url(scheme.get, call_564432.host, call_564432.base,
                         call_564432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564432, url, valid)

proc call*(call_564433: Call_CatalogGetTablePartition_564424; apiVersion: string;
          databaseName: string; schemaName: string; tableName: string;
          partitionName: string): Recallable =
  ## catalogGetTablePartition
  ## Retrieves the specified table partition from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the partition.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the partition.
  ##   tableName: string (required)
  ##            : The name of the table containing the partition.
  ##   partitionName: string (required)
  ##                : The name of the table partition.
  var path_564434 = newJObject()
  var query_564435 = newJObject()
  add(query_564435, "api-version", newJString(apiVersion))
  add(path_564434, "databaseName", newJString(databaseName))
  add(path_564434, "schemaName", newJString(schemaName))
  add(path_564434, "tableName", newJString(tableName))
  add(path_564434, "partitionName", newJString(partitionName))
  result = call_564433.call(path_564434, query_564435, nil, nil, nil)

var catalogGetTablePartition* = Call_CatalogGetTablePartition_564424(
    name: "catalogGetTablePartition", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/partitions/{partitionName}",
    validator: validate_CatalogGetTablePartition_564425, base: "",
    url: url_CatalogGetTablePartition_564426, schemes: {Scheme.Https})
type
  Call_CatalogPreviewTablePartition_564436 = ref object of OpenApiRestCall_563564
proc url_CatalogPreviewTablePartition_564438(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  assert "partitionName" in path, "`partitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName"),
               (kind: ConstantSegment, value: "/partitions/"),
               (kind: VariableSegment, value: "partitionName"),
               (kind: ConstantSegment, value: "/previewrows")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogPreviewTablePartition_564437(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a preview set of rows in given partition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the partition.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the partition.
  ##   tableName: JString (required)
  ##            : The name of the table containing the partition.
  ##   partitionName: JString (required)
  ##                : The name of the table partition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564439 = path.getOrDefault("databaseName")
  valid_564439 = validateParameter(valid_564439, JString, required = true,
                                 default = nil)
  if valid_564439 != nil:
    section.add "databaseName", valid_564439
  var valid_564440 = path.getOrDefault("schemaName")
  valid_564440 = validateParameter(valid_564440, JString, required = true,
                                 default = nil)
  if valid_564440 != nil:
    section.add "schemaName", valid_564440
  var valid_564441 = path.getOrDefault("tableName")
  valid_564441 = validateParameter(valid_564441, JString, required = true,
                                 default = nil)
  if valid_564441 != nil:
    section.add "tableName", valid_564441
  var valid_564442 = path.getOrDefault("partitionName")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "partitionName", valid_564442
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   maxColumns: JInt
  ##             : The maximum number of columns to be retrieved.
  ##   maxRows: JInt
  ##          : The maximum number of preview rows to be retrieved.Rows returned may be less than or equal to this number depending on row sizes and number of rows in the partition.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564443 = query.getOrDefault("api-version")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "api-version", valid_564443
  var valid_564444 = query.getOrDefault("maxColumns")
  valid_564444 = validateParameter(valid_564444, JInt, required = false, default = nil)
  if valid_564444 != nil:
    section.add "maxColumns", valid_564444
  var valid_564445 = query.getOrDefault("maxRows")
  valid_564445 = validateParameter(valid_564445, JInt, required = false, default = nil)
  if valid_564445 != nil:
    section.add "maxRows", valid_564445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564446: Call_CatalogPreviewTablePartition_564436; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a preview set of rows in given partition.
  ## 
  let valid = call_564446.validator(path, query, header, formData, body)
  let scheme = call_564446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564446.url(scheme.get, call_564446.host, call_564446.base,
                         call_564446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564446, url, valid)

proc call*(call_564447: Call_CatalogPreviewTablePartition_564436;
          apiVersion: string; databaseName: string; schemaName: string;
          tableName: string; partitionName: string; maxColumns: int = 0;
          maxRows: int = 0): Recallable =
  ## catalogPreviewTablePartition
  ## Retrieves a preview set of rows in given partition.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   maxColumns: int
  ##             : The maximum number of columns to be retrieved.
  ##   databaseName: string (required)
  ##               : The name of the database containing the partition.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the partition.
  ##   tableName: string (required)
  ##            : The name of the table containing the partition.
  ##   maxRows: int
  ##          : The maximum number of preview rows to be retrieved.Rows returned may be less than or equal to this number depending on row sizes and number of rows in the partition.
  ##   partitionName: string (required)
  ##                : The name of the table partition.
  var path_564448 = newJObject()
  var query_564449 = newJObject()
  add(query_564449, "api-version", newJString(apiVersion))
  add(query_564449, "maxColumns", newJInt(maxColumns))
  add(path_564448, "databaseName", newJString(databaseName))
  add(path_564448, "schemaName", newJString(schemaName))
  add(path_564448, "tableName", newJString(tableName))
  add(query_564449, "maxRows", newJInt(maxRows))
  add(path_564448, "partitionName", newJString(partitionName))
  result = call_564447.call(path_564448, query_564449, nil, nil, nil)

var catalogPreviewTablePartition* = Call_CatalogPreviewTablePartition_564436(
    name: "catalogPreviewTablePartition", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/partitions/{partitionName}/previewrows",
    validator: validate_CatalogPreviewTablePartition_564437, base: "",
    url: url_CatalogPreviewTablePartition_564438, schemes: {Scheme.Https})
type
  Call_CatalogPreviewTable_564450 = ref object of OpenApiRestCall_563564
proc url_CatalogPreviewTable_564452(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName"),
               (kind: ConstantSegment, value: "/previewrows")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogPreviewTable_564451(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves a preview set of rows in given table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the table.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the table.
  ##   tableName: JString (required)
  ##            : The name of the table.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564453 = path.getOrDefault("databaseName")
  valid_564453 = validateParameter(valid_564453, JString, required = true,
                                 default = nil)
  if valid_564453 != nil:
    section.add "databaseName", valid_564453
  var valid_564454 = path.getOrDefault("schemaName")
  valid_564454 = validateParameter(valid_564454, JString, required = true,
                                 default = nil)
  if valid_564454 != nil:
    section.add "schemaName", valid_564454
  var valid_564455 = path.getOrDefault("tableName")
  valid_564455 = validateParameter(valid_564455, JString, required = true,
                                 default = nil)
  if valid_564455 != nil:
    section.add "tableName", valid_564455
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   maxColumns: JInt
  ##             : The maximum number of columns to be retrieved.
  ##   maxRows: JInt
  ##          : The maximum number of preview rows to be retrieved. Rows returned may be less than or equal to this number depending on row sizes and number of rows in the table.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564456 = query.getOrDefault("api-version")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "api-version", valid_564456
  var valid_564457 = query.getOrDefault("maxColumns")
  valid_564457 = validateParameter(valid_564457, JInt, required = false, default = nil)
  if valid_564457 != nil:
    section.add "maxColumns", valid_564457
  var valid_564458 = query.getOrDefault("maxRows")
  valid_564458 = validateParameter(valid_564458, JInt, required = false, default = nil)
  if valid_564458 != nil:
    section.add "maxRows", valid_564458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564459: Call_CatalogPreviewTable_564450; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a preview set of rows in given table.
  ## 
  let valid = call_564459.validator(path, query, header, formData, body)
  let scheme = call_564459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564459.url(scheme.get, call_564459.host, call_564459.base,
                         call_564459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564459, url, valid)

proc call*(call_564460: Call_CatalogPreviewTable_564450; apiVersion: string;
          databaseName: string; schemaName: string; tableName: string;
          maxColumns: int = 0; maxRows: int = 0): Recallable =
  ## catalogPreviewTable
  ## Retrieves a preview set of rows in given table.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   maxColumns: int
  ##             : The maximum number of columns to be retrieved.
  ##   databaseName: string (required)
  ##               : The name of the database containing the table.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the table.
  ##   tableName: string (required)
  ##            : The name of the table.
  ##   maxRows: int
  ##          : The maximum number of preview rows to be retrieved. Rows returned may be less than or equal to this number depending on row sizes and number of rows in the table.
  var path_564461 = newJObject()
  var query_564462 = newJObject()
  add(query_564462, "api-version", newJString(apiVersion))
  add(query_564462, "maxColumns", newJInt(maxColumns))
  add(path_564461, "databaseName", newJString(databaseName))
  add(path_564461, "schemaName", newJString(schemaName))
  add(path_564461, "tableName", newJString(tableName))
  add(query_564462, "maxRows", newJInt(maxRows))
  result = call_564460.call(path_564461, query_564462, nil, nil, nil)

var catalogPreviewTable* = Call_CatalogPreviewTable_564450(
    name: "catalogPreviewTable", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/previewrows",
    validator: validate_CatalogPreviewTable_564451, base: "",
    url: url_CatalogPreviewTable_564452, schemes: {Scheme.Https})
type
  Call_CatalogListTableStatistics_564463 = ref object of OpenApiRestCall_563564
proc url_CatalogListTableStatistics_564465(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName"),
               (kind: ConstantSegment, value: "/statistics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogListTableStatistics_564464(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of table statistics from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the statistics.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the statistics.
  ##   tableName: JString (required)
  ##            : The name of the table containing the statistics.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564466 = path.getOrDefault("databaseName")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "databaseName", valid_564466
  var valid_564467 = path.getOrDefault("schemaName")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "schemaName", valid_564467
  var valid_564468 = path.getOrDefault("tableName")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "tableName", valid_564468
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564469 = query.getOrDefault("$top")
  valid_564469 = validateParameter(valid_564469, JInt, required = false, default = nil)
  if valid_564469 != nil:
    section.add "$top", valid_564469
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564470 = query.getOrDefault("api-version")
  valid_564470 = validateParameter(valid_564470, JString, required = true,
                                 default = nil)
  if valid_564470 != nil:
    section.add "api-version", valid_564470
  var valid_564471 = query.getOrDefault("$select")
  valid_564471 = validateParameter(valid_564471, JString, required = false,
                                 default = nil)
  if valid_564471 != nil:
    section.add "$select", valid_564471
  var valid_564472 = query.getOrDefault("$count")
  valid_564472 = validateParameter(valid_564472, JBool, required = false, default = nil)
  if valid_564472 != nil:
    section.add "$count", valid_564472
  var valid_564473 = query.getOrDefault("$orderby")
  valid_564473 = validateParameter(valid_564473, JString, required = false,
                                 default = nil)
  if valid_564473 != nil:
    section.add "$orderby", valid_564473
  var valid_564474 = query.getOrDefault("$skip")
  valid_564474 = validateParameter(valid_564474, JInt, required = false, default = nil)
  if valid_564474 != nil:
    section.add "$skip", valid_564474
  var valid_564475 = query.getOrDefault("$filter")
  valid_564475 = validateParameter(valid_564475, JString, required = false,
                                 default = nil)
  if valid_564475 != nil:
    section.add "$filter", valid_564475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564476: Call_CatalogListTableStatistics_564463; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table statistics from the Data Lake Analytics catalog.
  ## 
  let valid = call_564476.validator(path, query, header, formData, body)
  let scheme = call_564476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564476.url(scheme.get, call_564476.host, call_564476.base,
                         call_564476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564476, url, valid)

proc call*(call_564477: Call_CatalogListTableStatistics_564463; apiVersion: string;
          databaseName: string; schemaName: string; tableName: string; Top: int = 0;
          Select: string = ""; Count: bool = false; Orderby: string = ""; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## catalogListTableStatistics
  ## Retrieves the list of table statistics from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the statistics.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the statistics.
  ##   tableName: string (required)
  ##            : The name of the table containing the statistics.
  var path_564478 = newJObject()
  var query_564479 = newJObject()
  add(query_564479, "$top", newJInt(Top))
  add(query_564479, "api-version", newJString(apiVersion))
  add(query_564479, "$select", newJString(Select))
  add(query_564479, "$count", newJBool(Count))
  add(path_564478, "databaseName", newJString(databaseName))
  add(query_564479, "$orderby", newJString(Orderby))
  add(query_564479, "$skip", newJInt(Skip))
  add(query_564479, "$filter", newJString(Filter))
  add(path_564478, "schemaName", newJString(schemaName))
  add(path_564478, "tableName", newJString(tableName))
  result = call_564477.call(path_564478, query_564479, nil, nil, nil)

var catalogListTableStatistics* = Call_CatalogListTableStatistics_564463(
    name: "catalogListTableStatistics", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/statistics",
    validator: validate_CatalogListTableStatistics_564464, base: "",
    url: url_CatalogListTableStatistics_564465, schemes: {Scheme.Https})
type
  Call_CatalogGetTableStatistic_564480 = ref object of OpenApiRestCall_563564
proc url_CatalogGetTableStatistic_564482(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  assert "statisticsName" in path, "`statisticsName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName"),
               (kind: ConstantSegment, value: "/statistics/"),
               (kind: VariableSegment, value: "statisticsName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogGetTableStatistic_564481(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the specified table statistics from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the statistics.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the statistics.
  ##   tableName: JString (required)
  ##            : The name of the table containing the statistics.
  ##   statisticsName: JString (required)
  ##                 : The name of the table statistics.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564483 = path.getOrDefault("databaseName")
  valid_564483 = validateParameter(valid_564483, JString, required = true,
                                 default = nil)
  if valid_564483 != nil:
    section.add "databaseName", valid_564483
  var valid_564484 = path.getOrDefault("schemaName")
  valid_564484 = validateParameter(valid_564484, JString, required = true,
                                 default = nil)
  if valid_564484 != nil:
    section.add "schemaName", valid_564484
  var valid_564485 = path.getOrDefault("tableName")
  valid_564485 = validateParameter(valid_564485, JString, required = true,
                                 default = nil)
  if valid_564485 != nil:
    section.add "tableName", valid_564485
  var valid_564486 = path.getOrDefault("statisticsName")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "statisticsName", valid_564486
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564487 = query.getOrDefault("api-version")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "api-version", valid_564487
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564488: Call_CatalogGetTableStatistic_564480; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table statistics from the Data Lake Analytics catalog.
  ## 
  let valid = call_564488.validator(path, query, header, formData, body)
  let scheme = call_564488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564488.url(scheme.get, call_564488.host, call_564488.base,
                         call_564488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564488, url, valid)

proc call*(call_564489: Call_CatalogGetTableStatistic_564480; apiVersion: string;
          databaseName: string; schemaName: string; tableName: string;
          statisticsName: string): Recallable =
  ## catalogGetTableStatistic
  ## Retrieves the specified table statistics from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the statistics.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the statistics.
  ##   tableName: string (required)
  ##            : The name of the table containing the statistics.
  ##   statisticsName: string (required)
  ##                 : The name of the table statistics.
  var path_564490 = newJObject()
  var query_564491 = newJObject()
  add(query_564491, "api-version", newJString(apiVersion))
  add(path_564490, "databaseName", newJString(databaseName))
  add(path_564490, "schemaName", newJString(schemaName))
  add(path_564490, "tableName", newJString(tableName))
  add(path_564490, "statisticsName", newJString(statisticsName))
  result = call_564489.call(path_564490, query_564491, nil, nil, nil)

var catalogGetTableStatistic* = Call_CatalogGetTableStatistic_564480(
    name: "catalogGetTableStatistic", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/statistics/{statisticsName}",
    validator: validate_CatalogGetTableStatistic_564481, base: "",
    url: url_CatalogGetTableStatistic_564482, schemes: {Scheme.Https})
type
  Call_CatalogListTableFragments_564492 = ref object of OpenApiRestCall_563564
proc url_CatalogListTableFragments_564494(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName"),
               (kind: ConstantSegment, value: "/tablefragments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogListTableFragments_564493(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of table fragments from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the table fragments.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the table fragments.
  ##   tableName: JString (required)
  ##            : The name of the table containing the table fragments.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564495 = path.getOrDefault("databaseName")
  valid_564495 = validateParameter(valid_564495, JString, required = true,
                                 default = nil)
  if valid_564495 != nil:
    section.add "databaseName", valid_564495
  var valid_564496 = path.getOrDefault("schemaName")
  valid_564496 = validateParameter(valid_564496, JString, required = true,
                                 default = nil)
  if valid_564496 != nil:
    section.add "schemaName", valid_564496
  var valid_564497 = path.getOrDefault("tableName")
  valid_564497 = validateParameter(valid_564497, JString, required = true,
                                 default = nil)
  if valid_564497 != nil:
    section.add "tableName", valid_564497
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564498 = query.getOrDefault("$top")
  valid_564498 = validateParameter(valid_564498, JInt, required = false, default = nil)
  if valid_564498 != nil:
    section.add "$top", valid_564498
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564499 = query.getOrDefault("api-version")
  valid_564499 = validateParameter(valid_564499, JString, required = true,
                                 default = nil)
  if valid_564499 != nil:
    section.add "api-version", valid_564499
  var valid_564500 = query.getOrDefault("$select")
  valid_564500 = validateParameter(valid_564500, JString, required = false,
                                 default = nil)
  if valid_564500 != nil:
    section.add "$select", valid_564500
  var valid_564501 = query.getOrDefault("$count")
  valid_564501 = validateParameter(valid_564501, JBool, required = false, default = nil)
  if valid_564501 != nil:
    section.add "$count", valid_564501
  var valid_564502 = query.getOrDefault("$orderby")
  valid_564502 = validateParameter(valid_564502, JString, required = false,
                                 default = nil)
  if valid_564502 != nil:
    section.add "$orderby", valid_564502
  var valid_564503 = query.getOrDefault("$skip")
  valid_564503 = validateParameter(valid_564503, JInt, required = false, default = nil)
  if valid_564503 != nil:
    section.add "$skip", valid_564503
  var valid_564504 = query.getOrDefault("$filter")
  valid_564504 = validateParameter(valid_564504, JString, required = false,
                                 default = nil)
  if valid_564504 != nil:
    section.add "$filter", valid_564504
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564505: Call_CatalogListTableFragments_564492; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table fragments from the Data Lake Analytics catalog.
  ## 
  let valid = call_564505.validator(path, query, header, formData, body)
  let scheme = call_564505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564505.url(scheme.get, call_564505.host, call_564505.base,
                         call_564505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564505, url, valid)

proc call*(call_564506: Call_CatalogListTableFragments_564492; apiVersion: string;
          databaseName: string; schemaName: string; tableName: string; Top: int = 0;
          Select: string = ""; Count: bool = false; Orderby: string = ""; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## catalogListTableFragments
  ## Retrieves the list of table fragments from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the table fragments.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the table fragments.
  ##   tableName: string (required)
  ##            : The name of the table containing the table fragments.
  var path_564507 = newJObject()
  var query_564508 = newJObject()
  add(query_564508, "$top", newJInt(Top))
  add(query_564508, "api-version", newJString(apiVersion))
  add(query_564508, "$select", newJString(Select))
  add(query_564508, "$count", newJBool(Count))
  add(path_564507, "databaseName", newJString(databaseName))
  add(query_564508, "$orderby", newJString(Orderby))
  add(query_564508, "$skip", newJInt(Skip))
  add(query_564508, "$filter", newJString(Filter))
  add(path_564507, "schemaName", newJString(schemaName))
  add(path_564507, "tableName", newJString(tableName))
  result = call_564506.call(path_564507, query_564508, nil, nil, nil)

var catalogListTableFragments* = Call_CatalogListTableFragments_564492(
    name: "catalogListTableFragments", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/tablefragments",
    validator: validate_CatalogListTableFragments_564493, base: "",
    url: url_CatalogListTableFragments_564494, schemes: {Scheme.Https})
type
  Call_CatalogListTableTypes_564509 = ref object of OpenApiRestCall_563564
proc url_CatalogListTableTypes_564511(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/tabletypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogListTableTypes_564510(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of table types from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the table types.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the table types.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564512 = path.getOrDefault("databaseName")
  valid_564512 = validateParameter(valid_564512, JString, required = true,
                                 default = nil)
  if valid_564512 != nil:
    section.add "databaseName", valid_564512
  var valid_564513 = path.getOrDefault("schemaName")
  valid_564513 = validateParameter(valid_564513, JString, required = true,
                                 default = nil)
  if valid_564513 != nil:
    section.add "schemaName", valid_564513
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564514 = query.getOrDefault("$top")
  valid_564514 = validateParameter(valid_564514, JInt, required = false, default = nil)
  if valid_564514 != nil:
    section.add "$top", valid_564514
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564515 = query.getOrDefault("api-version")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = nil)
  if valid_564515 != nil:
    section.add "api-version", valid_564515
  var valid_564516 = query.getOrDefault("$select")
  valid_564516 = validateParameter(valid_564516, JString, required = false,
                                 default = nil)
  if valid_564516 != nil:
    section.add "$select", valid_564516
  var valid_564517 = query.getOrDefault("$count")
  valid_564517 = validateParameter(valid_564517, JBool, required = false, default = nil)
  if valid_564517 != nil:
    section.add "$count", valid_564517
  var valid_564518 = query.getOrDefault("$orderby")
  valid_564518 = validateParameter(valid_564518, JString, required = false,
                                 default = nil)
  if valid_564518 != nil:
    section.add "$orderby", valid_564518
  var valid_564519 = query.getOrDefault("$skip")
  valid_564519 = validateParameter(valid_564519, JInt, required = false, default = nil)
  if valid_564519 != nil:
    section.add "$skip", valid_564519
  var valid_564520 = query.getOrDefault("$filter")
  valid_564520 = validateParameter(valid_564520, JString, required = false,
                                 default = nil)
  if valid_564520 != nil:
    section.add "$filter", valid_564520
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564521: Call_CatalogListTableTypes_564509; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table types from the Data Lake Analytics catalog.
  ## 
  let valid = call_564521.validator(path, query, header, formData, body)
  let scheme = call_564521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564521.url(scheme.get, call_564521.host, call_564521.base,
                         call_564521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564521, url, valid)

proc call*(call_564522: Call_CatalogListTableTypes_564509; apiVersion: string;
          databaseName: string; schemaName: string; Top: int = 0; Select: string = "";
          Count: bool = false; Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListTableTypes
  ## Retrieves the list of table types from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the table types.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the table types.
  var path_564523 = newJObject()
  var query_564524 = newJObject()
  add(query_564524, "$top", newJInt(Top))
  add(query_564524, "api-version", newJString(apiVersion))
  add(query_564524, "$select", newJString(Select))
  add(query_564524, "$count", newJBool(Count))
  add(path_564523, "databaseName", newJString(databaseName))
  add(query_564524, "$orderby", newJString(Orderby))
  add(query_564524, "$skip", newJInt(Skip))
  add(query_564524, "$filter", newJString(Filter))
  add(path_564523, "schemaName", newJString(schemaName))
  result = call_564522.call(path_564523, query_564524, nil, nil, nil)

var catalogListTableTypes* = Call_CatalogListTableTypes_564509(
    name: "catalogListTableTypes", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tabletypes",
    validator: validate_CatalogListTableTypes_564510, base: "",
    url: url_CatalogListTableTypes_564511, schemes: {Scheme.Https})
type
  Call_CatalogGetTableType_564525 = ref object of OpenApiRestCall_563564
proc url_CatalogGetTableType_564527(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  assert "tableTypeName" in path, "`tableTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/tabletypes/"),
               (kind: VariableSegment, value: "tableTypeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogGetTableType_564526(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves the specified table type from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableTypeName: JString (required)
  ##                : The name of the table type to retrieve.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the table type.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the table type.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `tableTypeName` field"
  var valid_564528 = path.getOrDefault("tableTypeName")
  valid_564528 = validateParameter(valid_564528, JString, required = true,
                                 default = nil)
  if valid_564528 != nil:
    section.add "tableTypeName", valid_564528
  var valid_564529 = path.getOrDefault("databaseName")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "databaseName", valid_564529
  var valid_564530 = path.getOrDefault("schemaName")
  valid_564530 = validateParameter(valid_564530, JString, required = true,
                                 default = nil)
  if valid_564530 != nil:
    section.add "schemaName", valid_564530
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564531 = query.getOrDefault("api-version")
  valid_564531 = validateParameter(valid_564531, JString, required = true,
                                 default = nil)
  if valid_564531 != nil:
    section.add "api-version", valid_564531
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564532: Call_CatalogGetTableType_564525; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table type from the Data Lake Analytics catalog.
  ## 
  let valid = call_564532.validator(path, query, header, formData, body)
  let scheme = call_564532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564532.url(scheme.get, call_564532.host, call_564532.base,
                         call_564532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564532, url, valid)

proc call*(call_564533: Call_CatalogGetTableType_564525; apiVersion: string;
          tableTypeName: string; databaseName: string; schemaName: string): Recallable =
  ## catalogGetTableType
  ## Retrieves the specified table type from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   tableTypeName: string (required)
  ##                : The name of the table type to retrieve.
  ##   databaseName: string (required)
  ##               : The name of the database containing the table type.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the table type.
  var path_564534 = newJObject()
  var query_564535 = newJObject()
  add(query_564535, "api-version", newJString(apiVersion))
  add(path_564534, "tableTypeName", newJString(tableTypeName))
  add(path_564534, "databaseName", newJString(databaseName))
  add(path_564534, "schemaName", newJString(schemaName))
  result = call_564533.call(path_564534, query_564535, nil, nil, nil)

var catalogGetTableType* = Call_CatalogGetTableType_564525(
    name: "catalogGetTableType", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tabletypes/{tableTypeName}",
    validator: validate_CatalogGetTableType_564526, base: "",
    url: url_CatalogGetTableType_564527, schemes: {Scheme.Https})
type
  Call_CatalogListTableValuedFunctions_564536 = ref object of OpenApiRestCall_563564
proc url_CatalogListTableValuedFunctions_564538(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/tablevaluedfunctions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogListTableValuedFunctions_564537(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of table valued functions from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the table valued functions.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the table valued functions.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564539 = path.getOrDefault("databaseName")
  valid_564539 = validateParameter(valid_564539, JString, required = true,
                                 default = nil)
  if valid_564539 != nil:
    section.add "databaseName", valid_564539
  var valid_564540 = path.getOrDefault("schemaName")
  valid_564540 = validateParameter(valid_564540, JString, required = true,
                                 default = nil)
  if valid_564540 != nil:
    section.add "schemaName", valid_564540
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564541 = query.getOrDefault("$top")
  valid_564541 = validateParameter(valid_564541, JInt, required = false, default = nil)
  if valid_564541 != nil:
    section.add "$top", valid_564541
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564542 = query.getOrDefault("api-version")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "api-version", valid_564542
  var valid_564543 = query.getOrDefault("$select")
  valid_564543 = validateParameter(valid_564543, JString, required = false,
                                 default = nil)
  if valid_564543 != nil:
    section.add "$select", valid_564543
  var valid_564544 = query.getOrDefault("$count")
  valid_564544 = validateParameter(valid_564544, JBool, required = false, default = nil)
  if valid_564544 != nil:
    section.add "$count", valid_564544
  var valid_564545 = query.getOrDefault("$orderby")
  valid_564545 = validateParameter(valid_564545, JString, required = false,
                                 default = nil)
  if valid_564545 != nil:
    section.add "$orderby", valid_564545
  var valid_564546 = query.getOrDefault("$skip")
  valid_564546 = validateParameter(valid_564546, JInt, required = false, default = nil)
  if valid_564546 != nil:
    section.add "$skip", valid_564546
  var valid_564547 = query.getOrDefault("$filter")
  valid_564547 = validateParameter(valid_564547, JString, required = false,
                                 default = nil)
  if valid_564547 != nil:
    section.add "$filter", valid_564547
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564548: Call_CatalogListTableValuedFunctions_564536;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of table valued functions from the Data Lake Analytics catalog.
  ## 
  let valid = call_564548.validator(path, query, header, formData, body)
  let scheme = call_564548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564548.url(scheme.get, call_564548.host, call_564548.base,
                         call_564548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564548, url, valid)

proc call*(call_564549: Call_CatalogListTableValuedFunctions_564536;
          apiVersion: string; databaseName: string; schemaName: string; Top: int = 0;
          Select: string = ""; Count: bool = false; Orderby: string = ""; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## catalogListTableValuedFunctions
  ## Retrieves the list of table valued functions from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the table valued functions.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the table valued functions.
  var path_564550 = newJObject()
  var query_564551 = newJObject()
  add(query_564551, "$top", newJInt(Top))
  add(query_564551, "api-version", newJString(apiVersion))
  add(query_564551, "$select", newJString(Select))
  add(query_564551, "$count", newJBool(Count))
  add(path_564550, "databaseName", newJString(databaseName))
  add(query_564551, "$orderby", newJString(Orderby))
  add(query_564551, "$skip", newJInt(Skip))
  add(query_564551, "$filter", newJString(Filter))
  add(path_564550, "schemaName", newJString(schemaName))
  result = call_564549.call(path_564550, query_564551, nil, nil, nil)

var catalogListTableValuedFunctions* = Call_CatalogListTableValuedFunctions_564536(
    name: "catalogListTableValuedFunctions", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tablevaluedfunctions",
    validator: validate_CatalogListTableValuedFunctions_564537, base: "",
    url: url_CatalogListTableValuedFunctions_564538, schemes: {Scheme.Https})
type
  Call_CatalogGetTableValuedFunction_564552 = ref object of OpenApiRestCall_563564
proc url_CatalogGetTableValuedFunction_564554(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  assert "tableValuedFunctionName" in path,
        "`tableValuedFunctionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/tablevaluedfunctions/"),
               (kind: VariableSegment, value: "tableValuedFunctionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogGetTableValuedFunction_564553(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the specified table valued function from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the table valued function.
  ##   tableValuedFunctionName: JString (required)
  ##                          : The name of the tableValuedFunction.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the table valued function.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564555 = path.getOrDefault("databaseName")
  valid_564555 = validateParameter(valid_564555, JString, required = true,
                                 default = nil)
  if valid_564555 != nil:
    section.add "databaseName", valid_564555
  var valid_564556 = path.getOrDefault("tableValuedFunctionName")
  valid_564556 = validateParameter(valid_564556, JString, required = true,
                                 default = nil)
  if valid_564556 != nil:
    section.add "tableValuedFunctionName", valid_564556
  var valid_564557 = path.getOrDefault("schemaName")
  valid_564557 = validateParameter(valid_564557, JString, required = true,
                                 default = nil)
  if valid_564557 != nil:
    section.add "schemaName", valid_564557
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564558 = query.getOrDefault("api-version")
  valid_564558 = validateParameter(valid_564558, JString, required = true,
                                 default = nil)
  if valid_564558 != nil:
    section.add "api-version", valid_564558
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564559: Call_CatalogGetTableValuedFunction_564552; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table valued function from the Data Lake Analytics catalog.
  ## 
  let valid = call_564559.validator(path, query, header, formData, body)
  let scheme = call_564559.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564559.url(scheme.get, call_564559.host, call_564559.base,
                         call_564559.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564559, url, valid)

proc call*(call_564560: Call_CatalogGetTableValuedFunction_564552;
          apiVersion: string; databaseName: string; tableValuedFunctionName: string;
          schemaName: string): Recallable =
  ## catalogGetTableValuedFunction
  ## Retrieves the specified table valued function from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the table valued function.
  ##   tableValuedFunctionName: string (required)
  ##                          : The name of the tableValuedFunction.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the table valued function.
  var path_564561 = newJObject()
  var query_564562 = newJObject()
  add(query_564562, "api-version", newJString(apiVersion))
  add(path_564561, "databaseName", newJString(databaseName))
  add(path_564561, "tableValuedFunctionName", newJString(tableValuedFunctionName))
  add(path_564561, "schemaName", newJString(schemaName))
  result = call_564560.call(path_564561, query_564562, nil, nil, nil)

var catalogGetTableValuedFunction* = Call_CatalogGetTableValuedFunction_564552(
    name: "catalogGetTableValuedFunction", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tablevaluedfunctions/{tableValuedFunctionName}",
    validator: validate_CatalogGetTableValuedFunction_564553, base: "",
    url: url_CatalogGetTableValuedFunction_564554, schemes: {Scheme.Https})
type
  Call_CatalogListTypes_564563 = ref object of OpenApiRestCall_563564
proc url_CatalogListTypes_564565(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/types")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogListTypes_564564(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves the list of types within the specified database and schema from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the types.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the types.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564566 = path.getOrDefault("databaseName")
  valid_564566 = validateParameter(valid_564566, JString, required = true,
                                 default = nil)
  if valid_564566 != nil:
    section.add "databaseName", valid_564566
  var valid_564567 = path.getOrDefault("schemaName")
  valid_564567 = validateParameter(valid_564567, JString, required = true,
                                 default = nil)
  if valid_564567 != nil:
    section.add "schemaName", valid_564567
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564568 = query.getOrDefault("$top")
  valid_564568 = validateParameter(valid_564568, JInt, required = false, default = nil)
  if valid_564568 != nil:
    section.add "$top", valid_564568
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564569 = query.getOrDefault("api-version")
  valid_564569 = validateParameter(valid_564569, JString, required = true,
                                 default = nil)
  if valid_564569 != nil:
    section.add "api-version", valid_564569
  var valid_564570 = query.getOrDefault("$select")
  valid_564570 = validateParameter(valid_564570, JString, required = false,
                                 default = nil)
  if valid_564570 != nil:
    section.add "$select", valid_564570
  var valid_564571 = query.getOrDefault("$count")
  valid_564571 = validateParameter(valid_564571, JBool, required = false, default = nil)
  if valid_564571 != nil:
    section.add "$count", valid_564571
  var valid_564572 = query.getOrDefault("$orderby")
  valid_564572 = validateParameter(valid_564572, JString, required = false,
                                 default = nil)
  if valid_564572 != nil:
    section.add "$orderby", valid_564572
  var valid_564573 = query.getOrDefault("$skip")
  valid_564573 = validateParameter(valid_564573, JInt, required = false, default = nil)
  if valid_564573 != nil:
    section.add "$skip", valid_564573
  var valid_564574 = query.getOrDefault("$filter")
  valid_564574 = validateParameter(valid_564574, JString, required = false,
                                 default = nil)
  if valid_564574 != nil:
    section.add "$filter", valid_564574
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564575: Call_CatalogListTypes_564563; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of types within the specified database and schema from the Data Lake Analytics catalog.
  ## 
  let valid = call_564575.validator(path, query, header, formData, body)
  let scheme = call_564575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564575.url(scheme.get, call_564575.host, call_564575.base,
                         call_564575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564575, url, valid)

proc call*(call_564576: Call_CatalogListTypes_564563; apiVersion: string;
          databaseName: string; schemaName: string; Top: int = 0; Select: string = "";
          Count: bool = false; Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListTypes
  ## Retrieves the list of types within the specified database and schema from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the types.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the types.
  var path_564577 = newJObject()
  var query_564578 = newJObject()
  add(query_564578, "$top", newJInt(Top))
  add(query_564578, "api-version", newJString(apiVersion))
  add(query_564578, "$select", newJString(Select))
  add(query_564578, "$count", newJBool(Count))
  add(path_564577, "databaseName", newJString(databaseName))
  add(query_564578, "$orderby", newJString(Orderby))
  add(query_564578, "$skip", newJInt(Skip))
  add(query_564578, "$filter", newJString(Filter))
  add(path_564577, "schemaName", newJString(schemaName))
  result = call_564576.call(path_564577, query_564578, nil, nil, nil)

var catalogListTypes* = Call_CatalogListTypes_564563(name: "catalogListTypes",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/types",
    validator: validate_CatalogListTypes_564564, base: "",
    url: url_CatalogListTypes_564565, schemes: {Scheme.Https})
type
  Call_CatalogListViews_564579 = ref object of OpenApiRestCall_563564
proc url_CatalogListViews_564581(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/views")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogListViews_564580(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves the list of views from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the views.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the views.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564582 = path.getOrDefault("databaseName")
  valid_564582 = validateParameter(valid_564582, JString, required = true,
                                 default = nil)
  if valid_564582 != nil:
    section.add "databaseName", valid_564582
  var valid_564583 = path.getOrDefault("schemaName")
  valid_564583 = validateParameter(valid_564583, JString, required = true,
                                 default = nil)
  if valid_564583 != nil:
    section.add "schemaName", valid_564583
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564584 = query.getOrDefault("$top")
  valid_564584 = validateParameter(valid_564584, JInt, required = false, default = nil)
  if valid_564584 != nil:
    section.add "$top", valid_564584
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564585 = query.getOrDefault("api-version")
  valid_564585 = validateParameter(valid_564585, JString, required = true,
                                 default = nil)
  if valid_564585 != nil:
    section.add "api-version", valid_564585
  var valid_564586 = query.getOrDefault("$select")
  valid_564586 = validateParameter(valid_564586, JString, required = false,
                                 default = nil)
  if valid_564586 != nil:
    section.add "$select", valid_564586
  var valid_564587 = query.getOrDefault("$count")
  valid_564587 = validateParameter(valid_564587, JBool, required = false, default = nil)
  if valid_564587 != nil:
    section.add "$count", valid_564587
  var valid_564588 = query.getOrDefault("$orderby")
  valid_564588 = validateParameter(valid_564588, JString, required = false,
                                 default = nil)
  if valid_564588 != nil:
    section.add "$orderby", valid_564588
  var valid_564589 = query.getOrDefault("$skip")
  valid_564589 = validateParameter(valid_564589, JInt, required = false, default = nil)
  if valid_564589 != nil:
    section.add "$skip", valid_564589
  var valid_564590 = query.getOrDefault("$filter")
  valid_564590 = validateParameter(valid_564590, JString, required = false,
                                 default = nil)
  if valid_564590 != nil:
    section.add "$filter", valid_564590
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564591: Call_CatalogListViews_564579; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of views from the Data Lake Analytics catalog.
  ## 
  let valid = call_564591.validator(path, query, header, formData, body)
  let scheme = call_564591.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564591.url(scheme.get, call_564591.host, call_564591.base,
                         call_564591.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564591, url, valid)

proc call*(call_564592: Call_CatalogListViews_564579; apiVersion: string;
          databaseName: string; schemaName: string; Top: int = 0; Select: string = "";
          Count: bool = false; Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListViews
  ## Retrieves the list of views from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the views.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the views.
  var path_564593 = newJObject()
  var query_564594 = newJObject()
  add(query_564594, "$top", newJInt(Top))
  add(query_564594, "api-version", newJString(apiVersion))
  add(query_564594, "$select", newJString(Select))
  add(query_564594, "$count", newJBool(Count))
  add(path_564593, "databaseName", newJString(databaseName))
  add(query_564594, "$orderby", newJString(Orderby))
  add(query_564594, "$skip", newJInt(Skip))
  add(query_564594, "$filter", newJString(Filter))
  add(path_564593, "schemaName", newJString(schemaName))
  result = call_564592.call(path_564593, query_564594, nil, nil, nil)

var catalogListViews* = Call_CatalogListViews_564579(name: "catalogListViews",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/views",
    validator: validate_CatalogListViews_564580, base: "",
    url: url_CatalogListViews_564581, schemes: {Scheme.Https})
type
  Call_CatalogGetView_564595 = ref object of OpenApiRestCall_563564
proc url_CatalogGetView_564597(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  assert "viewName" in path, "`viewName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/views/"),
               (kind: VariableSegment, value: "viewName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogGetView_564596(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieves the specified view from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the view.
  ##   viewName: JString (required)
  ##           : The name of the view.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564598 = path.getOrDefault("databaseName")
  valid_564598 = validateParameter(valid_564598, JString, required = true,
                                 default = nil)
  if valid_564598 != nil:
    section.add "databaseName", valid_564598
  var valid_564599 = path.getOrDefault("viewName")
  valid_564599 = validateParameter(valid_564599, JString, required = true,
                                 default = nil)
  if valid_564599 != nil:
    section.add "viewName", valid_564599
  var valid_564600 = path.getOrDefault("schemaName")
  valid_564600 = validateParameter(valid_564600, JString, required = true,
                                 default = nil)
  if valid_564600 != nil:
    section.add "schemaName", valid_564600
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564601 = query.getOrDefault("api-version")
  valid_564601 = validateParameter(valid_564601, JString, required = true,
                                 default = nil)
  if valid_564601 != nil:
    section.add "api-version", valid_564601
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564602: Call_CatalogGetView_564595; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified view from the Data Lake Analytics catalog.
  ## 
  let valid = call_564602.validator(path, query, header, formData, body)
  let scheme = call_564602.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564602.url(scheme.get, call_564602.host, call_564602.base,
                         call_564602.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564602, url, valid)

proc call*(call_564603: Call_CatalogGetView_564595; apiVersion: string;
          databaseName: string; viewName: string; schemaName: string): Recallable =
  ## catalogGetView
  ## Retrieves the specified view from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the view.
  ##   viewName: string (required)
  ##           : The name of the view.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the view.
  var path_564604 = newJObject()
  var query_564605 = newJObject()
  add(query_564605, "api-version", newJString(apiVersion))
  add(path_564604, "databaseName", newJString(databaseName))
  add(path_564604, "viewName", newJString(viewName))
  add(path_564604, "schemaName", newJString(schemaName))
  result = call_564603.call(path_564604, query_564605, nil, nil, nil)

var catalogGetView* = Call_CatalogGetView_564595(name: "catalogGetView",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/views/{viewName}",
    validator: validate_CatalogGetView_564596, base: "", url: url_CatalogGetView_564597,
    schemes: {Scheme.Https})
type
  Call_CatalogDeleteAllSecrets_564606 = ref object of OpenApiRestCall_563564
proc url_CatalogDeleteAllSecrets_564608(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/secrets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogDeleteAllSecrets_564607(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes all secrets in the specified database. This is deprecated and will be removed in the next release. In the future, please only drop individual credentials using DeleteCredential
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the secret.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564609 = path.getOrDefault("databaseName")
  valid_564609 = validateParameter(valid_564609, JString, required = true,
                                 default = nil)
  if valid_564609 != nil:
    section.add "databaseName", valid_564609
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564610 = query.getOrDefault("api-version")
  valid_564610 = validateParameter(valid_564610, JString, required = true,
                                 default = nil)
  if valid_564610 != nil:
    section.add "api-version", valid_564610
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564611: Call_CatalogDeleteAllSecrets_564606; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes all secrets in the specified database. This is deprecated and will be removed in the next release. In the future, please only drop individual credentials using DeleteCredential
  ## 
  let valid = call_564611.validator(path, query, header, formData, body)
  let scheme = call_564611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564611.url(scheme.get, call_564611.host, call_564611.base,
                         call_564611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564611, url, valid)

proc call*(call_564612: Call_CatalogDeleteAllSecrets_564606; apiVersion: string;
          databaseName: string): Recallable =
  ## catalogDeleteAllSecrets
  ## Deletes all secrets in the specified database. This is deprecated and will be removed in the next release. In the future, please only drop individual credentials using DeleteCredential
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  var path_564613 = newJObject()
  var query_564614 = newJObject()
  add(query_564614, "api-version", newJString(apiVersion))
  add(path_564613, "databaseName", newJString(databaseName))
  result = call_564612.call(path_564613, query_564614, nil, nil, nil)

var catalogDeleteAllSecrets* = Call_CatalogDeleteAllSecrets_564606(
    name: "catalogDeleteAllSecrets", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/secrets",
    validator: validate_CatalogDeleteAllSecrets_564607, base: "",
    url: url_CatalogDeleteAllSecrets_564608, schemes: {Scheme.Https})
type
  Call_CatalogCreateSecret_564625 = ref object of OpenApiRestCall_563564
proc url_CatalogCreateSecret_564627(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "secretName" in path, "`secretName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/secrets/"),
               (kind: VariableSegment, value: "secretName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogCreateSecret_564626(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates the specified secret for use with external data sources in the specified database. This is deprecated and will be removed in the next release. Please use CreateCredential instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secretName: JString (required)
  ##             : The name of the secret.
  ##   databaseName: JString (required)
  ##               : The name of the database in which to create the secret.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secretName` field"
  var valid_564628 = path.getOrDefault("secretName")
  valid_564628 = validateParameter(valid_564628, JString, required = true,
                                 default = nil)
  if valid_564628 != nil:
    section.add "secretName", valid_564628
  var valid_564629 = path.getOrDefault("databaseName")
  valid_564629 = validateParameter(valid_564629, JString, required = true,
                                 default = nil)
  if valid_564629 != nil:
    section.add "databaseName", valid_564629
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564630 = query.getOrDefault("api-version")
  valid_564630 = validateParameter(valid_564630, JString, required = true,
                                 default = nil)
  if valid_564630 != nil:
    section.add "api-version", valid_564630
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters required to create the secret (name and password)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564632: Call_CatalogCreateSecret_564625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the specified secret for use with external data sources in the specified database. This is deprecated and will be removed in the next release. Please use CreateCredential instead.
  ## 
  let valid = call_564632.validator(path, query, header, formData, body)
  let scheme = call_564632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564632.url(scheme.get, call_564632.host, call_564632.base,
                         call_564632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564632, url, valid)

proc call*(call_564633: Call_CatalogCreateSecret_564625; apiVersion: string;
          secretName: string; databaseName: string; parameters: JsonNode): Recallable =
  ## catalogCreateSecret
  ## Creates the specified secret for use with external data sources in the specified database. This is deprecated and will be removed in the next release. Please use CreateCredential instead.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  ##   databaseName: string (required)
  ##               : The name of the database in which to create the secret.
  ##   parameters: JObject (required)
  ##             : The parameters required to create the secret (name and password)
  var path_564634 = newJObject()
  var query_564635 = newJObject()
  var body_564636 = newJObject()
  add(query_564635, "api-version", newJString(apiVersion))
  add(path_564634, "secretName", newJString(secretName))
  add(path_564634, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_564636 = parameters
  result = call_564633.call(path_564634, query_564635, nil, nil, body_564636)

var catalogCreateSecret* = Call_CatalogCreateSecret_564625(
    name: "catalogCreateSecret", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogCreateSecret_564626, base: "",
    url: url_CatalogCreateSecret_564627, schemes: {Scheme.Https})
type
  Call_CatalogGetSecret_564615 = ref object of OpenApiRestCall_563564
proc url_CatalogGetSecret_564617(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "secretName" in path, "`secretName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/secrets/"),
               (kind: VariableSegment, value: "secretName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogGetSecret_564616(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the specified secret in the specified database. This is deprecated and will be removed in the next release. Please use GetCredential instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secretName: JString (required)
  ##             : The name of the secret to get
  ##   databaseName: JString (required)
  ##               : The name of the database containing the secret.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secretName` field"
  var valid_564618 = path.getOrDefault("secretName")
  valid_564618 = validateParameter(valid_564618, JString, required = true,
                                 default = nil)
  if valid_564618 != nil:
    section.add "secretName", valid_564618
  var valid_564619 = path.getOrDefault("databaseName")
  valid_564619 = validateParameter(valid_564619, JString, required = true,
                                 default = nil)
  if valid_564619 != nil:
    section.add "databaseName", valid_564619
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564620 = query.getOrDefault("api-version")
  valid_564620 = validateParameter(valid_564620, JString, required = true,
                                 default = nil)
  if valid_564620 != nil:
    section.add "api-version", valid_564620
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564621: Call_CatalogGetSecret_564615; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified secret in the specified database. This is deprecated and will be removed in the next release. Please use GetCredential instead.
  ## 
  let valid = call_564621.validator(path, query, header, formData, body)
  let scheme = call_564621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564621.url(scheme.get, call_564621.host, call_564621.base,
                         call_564621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564621, url, valid)

proc call*(call_564622: Call_CatalogGetSecret_564615; apiVersion: string;
          secretName: string; databaseName: string): Recallable =
  ## catalogGetSecret
  ## Gets the specified secret in the specified database. This is deprecated and will be removed in the next release. Please use GetCredential instead.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   secretName: string (required)
  ##             : The name of the secret to get
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  var path_564623 = newJObject()
  var query_564624 = newJObject()
  add(query_564624, "api-version", newJString(apiVersion))
  add(path_564623, "secretName", newJString(secretName))
  add(path_564623, "databaseName", newJString(databaseName))
  result = call_564622.call(path_564623, query_564624, nil, nil, nil)

var catalogGetSecret* = Call_CatalogGetSecret_564615(name: "catalogGetSecret",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogGetSecret_564616, base: "",
    url: url_CatalogGetSecret_564617, schemes: {Scheme.Https})
type
  Call_CatalogUpdateSecret_564647 = ref object of OpenApiRestCall_563564
proc url_CatalogUpdateSecret_564649(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "secretName" in path, "`secretName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/secrets/"),
               (kind: VariableSegment, value: "secretName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogUpdateSecret_564648(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Modifies the specified secret for use with external data sources in the specified database. This is deprecated and will be removed in the next release. Please use UpdateCredential instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secretName: JString (required)
  ##             : The name of the secret.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the secret.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secretName` field"
  var valid_564650 = path.getOrDefault("secretName")
  valid_564650 = validateParameter(valid_564650, JString, required = true,
                                 default = nil)
  if valid_564650 != nil:
    section.add "secretName", valid_564650
  var valid_564651 = path.getOrDefault("databaseName")
  valid_564651 = validateParameter(valid_564651, JString, required = true,
                                 default = nil)
  if valid_564651 != nil:
    section.add "databaseName", valid_564651
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564652 = query.getOrDefault("api-version")
  valid_564652 = validateParameter(valid_564652, JString, required = true,
                                 default = nil)
  if valid_564652 != nil:
    section.add "api-version", valid_564652
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters required to modify the secret (name and password)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564654: Call_CatalogUpdateSecret_564647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the specified secret for use with external data sources in the specified database. This is deprecated and will be removed in the next release. Please use UpdateCredential instead.
  ## 
  let valid = call_564654.validator(path, query, header, formData, body)
  let scheme = call_564654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564654.url(scheme.get, call_564654.host, call_564654.base,
                         call_564654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564654, url, valid)

proc call*(call_564655: Call_CatalogUpdateSecret_564647; apiVersion: string;
          secretName: string; databaseName: string; parameters: JsonNode): Recallable =
  ## catalogUpdateSecret
  ## Modifies the specified secret for use with external data sources in the specified database. This is deprecated and will be removed in the next release. Please use UpdateCredential instead.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  ##   parameters: JObject (required)
  ##             : The parameters required to modify the secret (name and password)
  var path_564656 = newJObject()
  var query_564657 = newJObject()
  var body_564658 = newJObject()
  add(query_564657, "api-version", newJString(apiVersion))
  add(path_564656, "secretName", newJString(secretName))
  add(path_564656, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_564658 = parameters
  result = call_564655.call(path_564656, query_564657, nil, nil, body_564658)

var catalogUpdateSecret* = Call_CatalogUpdateSecret_564647(
    name: "catalogUpdateSecret", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogUpdateSecret_564648, base: "",
    url: url_CatalogUpdateSecret_564649, schemes: {Scheme.Https})
type
  Call_CatalogDeleteSecret_564637 = ref object of OpenApiRestCall_563564
proc url_CatalogDeleteSecret_564639(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "secretName" in path, "`secretName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/secrets/"),
               (kind: VariableSegment, value: "secretName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogDeleteSecret_564638(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the specified secret in the specified database. This is deprecated and will be removed in the next release. Please use DeleteCredential instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secretName: JString (required)
  ##             : The name of the secret to delete
  ##   databaseName: JString (required)
  ##               : The name of the database containing the secret.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secretName` field"
  var valid_564640 = path.getOrDefault("secretName")
  valid_564640 = validateParameter(valid_564640, JString, required = true,
                                 default = nil)
  if valid_564640 != nil:
    section.add "secretName", valid_564640
  var valid_564641 = path.getOrDefault("databaseName")
  valid_564641 = validateParameter(valid_564641, JString, required = true,
                                 default = nil)
  if valid_564641 != nil:
    section.add "databaseName", valid_564641
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564642 = query.getOrDefault("api-version")
  valid_564642 = validateParameter(valid_564642, JString, required = true,
                                 default = nil)
  if valid_564642 != nil:
    section.add "api-version", valid_564642
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564643: Call_CatalogDeleteSecret_564637; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified secret in the specified database. This is deprecated and will be removed in the next release. Please use DeleteCredential instead.
  ## 
  let valid = call_564643.validator(path, query, header, formData, body)
  let scheme = call_564643.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564643.url(scheme.get, call_564643.host, call_564643.base,
                         call_564643.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564643, url, valid)

proc call*(call_564644: Call_CatalogDeleteSecret_564637; apiVersion: string;
          secretName: string; databaseName: string): Recallable =
  ## catalogDeleteSecret
  ## Deletes the specified secret in the specified database. This is deprecated and will be removed in the next release. Please use DeleteCredential instead.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   secretName: string (required)
  ##             : The name of the secret to delete
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  var path_564645 = newJObject()
  var query_564646 = newJObject()
  add(query_564646, "api-version", newJString(apiVersion))
  add(path_564645, "secretName", newJString(secretName))
  add(path_564645, "databaseName", newJString(databaseName))
  result = call_564644.call(path_564645, query_564646, nil, nil, nil)

var catalogDeleteSecret* = Call_CatalogDeleteSecret_564637(
    name: "catalogDeleteSecret", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogDeleteSecret_564638, base: "",
    url: url_CatalogDeleteSecret_564639, schemes: {Scheme.Https})
type
  Call_CatalogListTableStatisticsByDatabase_564659 = ref object of OpenApiRestCall_563564
proc url_CatalogListTableStatisticsByDatabase_564661(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/statistics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogListTableStatisticsByDatabase_564660(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of all statistics in a database from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the table statistics.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564662 = path.getOrDefault("databaseName")
  valid_564662 = validateParameter(valid_564662, JString, required = true,
                                 default = nil)
  if valid_564662 != nil:
    section.add "databaseName", valid_564662
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564663 = query.getOrDefault("$top")
  valid_564663 = validateParameter(valid_564663, JInt, required = false, default = nil)
  if valid_564663 != nil:
    section.add "$top", valid_564663
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564664 = query.getOrDefault("api-version")
  valid_564664 = validateParameter(valid_564664, JString, required = true,
                                 default = nil)
  if valid_564664 != nil:
    section.add "api-version", valid_564664
  var valid_564665 = query.getOrDefault("$select")
  valid_564665 = validateParameter(valid_564665, JString, required = false,
                                 default = nil)
  if valid_564665 != nil:
    section.add "$select", valid_564665
  var valid_564666 = query.getOrDefault("$count")
  valid_564666 = validateParameter(valid_564666, JBool, required = false, default = nil)
  if valid_564666 != nil:
    section.add "$count", valid_564666
  var valid_564667 = query.getOrDefault("$orderby")
  valid_564667 = validateParameter(valid_564667, JString, required = false,
                                 default = nil)
  if valid_564667 != nil:
    section.add "$orderby", valid_564667
  var valid_564668 = query.getOrDefault("$skip")
  valid_564668 = validateParameter(valid_564668, JInt, required = false, default = nil)
  if valid_564668 != nil:
    section.add "$skip", valid_564668
  var valid_564669 = query.getOrDefault("$filter")
  valid_564669 = validateParameter(valid_564669, JString, required = false,
                                 default = nil)
  if valid_564669 != nil:
    section.add "$filter", valid_564669
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564670: Call_CatalogListTableStatisticsByDatabase_564659;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of all statistics in a database from the Data Lake Analytics catalog.
  ## 
  let valid = call_564670.validator(path, query, header, formData, body)
  let scheme = call_564670.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564670.url(scheme.get, call_564670.host, call_564670.base,
                         call_564670.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564670, url, valid)

proc call*(call_564671: Call_CatalogListTableStatisticsByDatabase_564659;
          apiVersion: string; databaseName: string; Top: int = 0; Select: string = "";
          Count: bool = false; Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListTableStatisticsByDatabase
  ## Retrieves the list of all statistics in a database from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the table statistics.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_564672 = newJObject()
  var query_564673 = newJObject()
  add(query_564673, "$top", newJInt(Top))
  add(query_564673, "api-version", newJString(apiVersion))
  add(query_564673, "$select", newJString(Select))
  add(query_564673, "$count", newJBool(Count))
  add(path_564672, "databaseName", newJString(databaseName))
  add(query_564673, "$orderby", newJString(Orderby))
  add(query_564673, "$skip", newJInt(Skip))
  add(query_564673, "$filter", newJString(Filter))
  result = call_564671.call(path_564672, query_564673, nil, nil, nil)

var catalogListTableStatisticsByDatabase* = Call_CatalogListTableStatisticsByDatabase_564659(
    name: "catalogListTableStatisticsByDatabase", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/statistics",
    validator: validate_CatalogListTableStatisticsByDatabase_564660, base: "",
    url: url_CatalogListTableStatisticsByDatabase_564661, schemes: {Scheme.Https})
type
  Call_CatalogListTablesByDatabase_564674 = ref object of OpenApiRestCall_563564
proc url_CatalogListTablesByDatabase_564676(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/tables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogListTablesByDatabase_564675(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of all tables in a database from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the tables.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564677 = path.getOrDefault("databaseName")
  valid_564677 = validateParameter(valid_564677, JString, required = true,
                                 default = nil)
  if valid_564677 != nil:
    section.add "databaseName", valid_564677
  result.add "path", section
  ## parameters in `query` object:
  ##   basic: JBool
  ##        : The basic switch indicates what level of information to return when listing tables. When basic is true, only database_name, schema_name, table_name and version are returned for each table, otherwise all table metadata is returned. By default, it is false
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564678 = query.getOrDefault("basic")
  valid_564678 = validateParameter(valid_564678, JBool, required = false,
                                 default = newJBool(false))
  if valid_564678 != nil:
    section.add "basic", valid_564678
  var valid_564679 = query.getOrDefault("$top")
  valid_564679 = validateParameter(valid_564679, JInt, required = false, default = nil)
  if valid_564679 != nil:
    section.add "$top", valid_564679
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564680 = query.getOrDefault("api-version")
  valid_564680 = validateParameter(valid_564680, JString, required = true,
                                 default = nil)
  if valid_564680 != nil:
    section.add "api-version", valid_564680
  var valid_564681 = query.getOrDefault("$select")
  valid_564681 = validateParameter(valid_564681, JString, required = false,
                                 default = nil)
  if valid_564681 != nil:
    section.add "$select", valid_564681
  var valid_564682 = query.getOrDefault("$count")
  valid_564682 = validateParameter(valid_564682, JBool, required = false, default = nil)
  if valid_564682 != nil:
    section.add "$count", valid_564682
  var valid_564683 = query.getOrDefault("$orderby")
  valid_564683 = validateParameter(valid_564683, JString, required = false,
                                 default = nil)
  if valid_564683 != nil:
    section.add "$orderby", valid_564683
  var valid_564684 = query.getOrDefault("$skip")
  valid_564684 = validateParameter(valid_564684, JInt, required = false, default = nil)
  if valid_564684 != nil:
    section.add "$skip", valid_564684
  var valid_564685 = query.getOrDefault("$filter")
  valid_564685 = validateParameter(valid_564685, JString, required = false,
                                 default = nil)
  if valid_564685 != nil:
    section.add "$filter", valid_564685
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564686: Call_CatalogListTablesByDatabase_564674; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of all tables in a database from the Data Lake Analytics catalog.
  ## 
  let valid = call_564686.validator(path, query, header, formData, body)
  let scheme = call_564686.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564686.url(scheme.get, call_564686.host, call_564686.base,
                         call_564686.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564686, url, valid)

proc call*(call_564687: Call_CatalogListTablesByDatabase_564674;
          apiVersion: string; databaseName: string; basic: bool = false; Top: int = 0;
          Select: string = ""; Count: bool = false; Orderby: string = ""; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## catalogListTablesByDatabase
  ## Retrieves the list of all tables in a database from the Data Lake Analytics catalog.
  ##   basic: bool
  ##        : The basic switch indicates what level of information to return when listing tables. When basic is true, only database_name, schema_name, table_name and version are returned for each table, otherwise all table metadata is returned. By default, it is false
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the tables.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_564688 = newJObject()
  var query_564689 = newJObject()
  add(query_564689, "basic", newJBool(basic))
  add(query_564689, "$top", newJInt(Top))
  add(query_564689, "api-version", newJString(apiVersion))
  add(query_564689, "$select", newJString(Select))
  add(query_564689, "$count", newJBool(Count))
  add(path_564688, "databaseName", newJString(databaseName))
  add(query_564689, "$orderby", newJString(Orderby))
  add(query_564689, "$skip", newJInt(Skip))
  add(query_564689, "$filter", newJString(Filter))
  result = call_564687.call(path_564688, query_564689, nil, nil, nil)

var catalogListTablesByDatabase* = Call_CatalogListTablesByDatabase_564674(
    name: "catalogListTablesByDatabase", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/tables",
    validator: validate_CatalogListTablesByDatabase_564675, base: "",
    url: url_CatalogListTablesByDatabase_564676, schemes: {Scheme.Https})
type
  Call_CatalogListTableValuedFunctionsByDatabase_564690 = ref object of OpenApiRestCall_563564
proc url_CatalogListTableValuedFunctionsByDatabase_564692(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/tablevaluedfunctions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogListTableValuedFunctionsByDatabase_564691(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of all table valued functions in a database from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the table valued functions.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564693 = path.getOrDefault("databaseName")
  valid_564693 = validateParameter(valid_564693, JString, required = true,
                                 default = nil)
  if valid_564693 != nil:
    section.add "databaseName", valid_564693
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564694 = query.getOrDefault("$top")
  valid_564694 = validateParameter(valid_564694, JInt, required = false, default = nil)
  if valid_564694 != nil:
    section.add "$top", valid_564694
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564695 = query.getOrDefault("api-version")
  valid_564695 = validateParameter(valid_564695, JString, required = true,
                                 default = nil)
  if valid_564695 != nil:
    section.add "api-version", valid_564695
  var valid_564696 = query.getOrDefault("$select")
  valid_564696 = validateParameter(valid_564696, JString, required = false,
                                 default = nil)
  if valid_564696 != nil:
    section.add "$select", valid_564696
  var valid_564697 = query.getOrDefault("$count")
  valid_564697 = validateParameter(valid_564697, JBool, required = false, default = nil)
  if valid_564697 != nil:
    section.add "$count", valid_564697
  var valid_564698 = query.getOrDefault("$orderby")
  valid_564698 = validateParameter(valid_564698, JString, required = false,
                                 default = nil)
  if valid_564698 != nil:
    section.add "$orderby", valid_564698
  var valid_564699 = query.getOrDefault("$skip")
  valid_564699 = validateParameter(valid_564699, JInt, required = false, default = nil)
  if valid_564699 != nil:
    section.add "$skip", valid_564699
  var valid_564700 = query.getOrDefault("$filter")
  valid_564700 = validateParameter(valid_564700, JString, required = false,
                                 default = nil)
  if valid_564700 != nil:
    section.add "$filter", valid_564700
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564701: Call_CatalogListTableValuedFunctionsByDatabase_564690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of all table valued functions in a database from the Data Lake Analytics catalog.
  ## 
  let valid = call_564701.validator(path, query, header, formData, body)
  let scheme = call_564701.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564701.url(scheme.get, call_564701.host, call_564701.base,
                         call_564701.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564701, url, valid)

proc call*(call_564702: Call_CatalogListTableValuedFunctionsByDatabase_564690;
          apiVersion: string; databaseName: string; Top: int = 0; Select: string = "";
          Count: bool = false; Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListTableValuedFunctionsByDatabase
  ## Retrieves the list of all table valued functions in a database from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the table valued functions.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_564703 = newJObject()
  var query_564704 = newJObject()
  add(query_564704, "$top", newJInt(Top))
  add(query_564704, "api-version", newJString(apiVersion))
  add(query_564704, "$select", newJString(Select))
  add(query_564704, "$count", newJBool(Count))
  add(path_564703, "databaseName", newJString(databaseName))
  add(query_564704, "$orderby", newJString(Orderby))
  add(query_564704, "$skip", newJInt(Skip))
  add(query_564704, "$filter", newJString(Filter))
  result = call_564702.call(path_564703, query_564704, nil, nil, nil)

var catalogListTableValuedFunctionsByDatabase* = Call_CatalogListTableValuedFunctionsByDatabase_564690(
    name: "catalogListTableValuedFunctionsByDatabase", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/tablevaluedfunctions",
    validator: validate_CatalogListTableValuedFunctionsByDatabase_564691,
    base: "", url: url_CatalogListTableValuedFunctionsByDatabase_564692,
    schemes: {Scheme.Https})
type
  Call_CatalogListViewsByDatabase_564705 = ref object of OpenApiRestCall_563564
proc url_CatalogListViewsByDatabase_564707(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/catalog/usql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/views")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CatalogListViewsByDatabase_564706(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of all views in a database from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the views.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_564708 = path.getOrDefault("databaseName")
  valid_564708 = validateParameter(valid_564708, JString, required = true,
                                 default = nil)
  if valid_564708 != nil:
    section.add "databaseName", valid_564708
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564709 = query.getOrDefault("$top")
  valid_564709 = validateParameter(valid_564709, JInt, required = false, default = nil)
  if valid_564709 != nil:
    section.add "$top", valid_564709
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564710 = query.getOrDefault("api-version")
  valid_564710 = validateParameter(valid_564710, JString, required = true,
                                 default = nil)
  if valid_564710 != nil:
    section.add "api-version", valid_564710
  var valid_564711 = query.getOrDefault("$select")
  valid_564711 = validateParameter(valid_564711, JString, required = false,
                                 default = nil)
  if valid_564711 != nil:
    section.add "$select", valid_564711
  var valid_564712 = query.getOrDefault("$count")
  valid_564712 = validateParameter(valid_564712, JBool, required = false, default = nil)
  if valid_564712 != nil:
    section.add "$count", valid_564712
  var valid_564713 = query.getOrDefault("$orderby")
  valid_564713 = validateParameter(valid_564713, JString, required = false,
                                 default = nil)
  if valid_564713 != nil:
    section.add "$orderby", valid_564713
  var valid_564714 = query.getOrDefault("$skip")
  valid_564714 = validateParameter(valid_564714, JInt, required = false, default = nil)
  if valid_564714 != nil:
    section.add "$skip", valid_564714
  var valid_564715 = query.getOrDefault("$filter")
  valid_564715 = validateParameter(valid_564715, JString, required = false,
                                 default = nil)
  if valid_564715 != nil:
    section.add "$filter", valid_564715
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564716: Call_CatalogListViewsByDatabase_564705; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of all views in a database from the Data Lake Analytics catalog.
  ## 
  let valid = call_564716.validator(path, query, header, formData, body)
  let scheme = call_564716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564716.url(scheme.get, call_564716.host, call_564716.base,
                         call_564716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564716, url, valid)

proc call*(call_564717: Call_CatalogListViewsByDatabase_564705; apiVersion: string;
          databaseName: string; Top: int = 0; Select: string = ""; Count: bool = false;
          Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListViewsByDatabase
  ## Retrieves the list of all views in a database from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the views.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_564718 = newJObject()
  var query_564719 = newJObject()
  add(query_564719, "$top", newJInt(Top))
  add(query_564719, "api-version", newJString(apiVersion))
  add(query_564719, "$select", newJString(Select))
  add(query_564719, "$count", newJBool(Count))
  add(path_564718, "databaseName", newJString(databaseName))
  add(query_564719, "$orderby", newJString(Orderby))
  add(query_564719, "$skip", newJInt(Skip))
  add(query_564719, "$filter", newJString(Filter))
  result = call_564717.call(path_564718, query_564719, nil, nil, nil)

var catalogListViewsByDatabase* = Call_CatalogListViewsByDatabase_564705(
    name: "catalogListViewsByDatabase", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/views",
    validator: validate_CatalogListViewsByDatabase_564706, base: "",
    url: url_CatalogListViewsByDatabase_564707, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
