
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567666): Option[Scheme] {.used.} =
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
  macServiceName = "datalake-analytics-catalog"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CatalogListAcls_567888 = ref object of OpenApiRestCall_567666
proc url_CatalogListAcls_567890(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CatalogListAcls_567889(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Retrieves the list of access control list (ACL) entries for the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568050 = query.getOrDefault("$orderby")
  valid_568050 = validateParameter(valid_568050, JString, required = false,
                                 default = nil)
  if valid_568050 != nil:
    section.add "$orderby", valid_568050
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568051 = query.getOrDefault("api-version")
  valid_568051 = validateParameter(valid_568051, JString, required = true,
                                 default = nil)
  if valid_568051 != nil:
    section.add "api-version", valid_568051
  var valid_568052 = query.getOrDefault("$top")
  valid_568052 = validateParameter(valid_568052, JInt, required = false, default = nil)
  if valid_568052 != nil:
    section.add "$top", valid_568052
  var valid_568053 = query.getOrDefault("$select")
  valid_568053 = validateParameter(valid_568053, JString, required = false,
                                 default = nil)
  if valid_568053 != nil:
    section.add "$select", valid_568053
  var valid_568054 = query.getOrDefault("$skip")
  valid_568054 = validateParameter(valid_568054, JInt, required = false, default = nil)
  if valid_568054 != nil:
    section.add "$skip", valid_568054
  var valid_568055 = query.getOrDefault("$count")
  valid_568055 = validateParameter(valid_568055, JBool, required = false, default = nil)
  if valid_568055 != nil:
    section.add "$count", valid_568055
  var valid_568056 = query.getOrDefault("$filter")
  valid_568056 = validateParameter(valid_568056, JString, required = false,
                                 default = nil)
  if valid_568056 != nil:
    section.add "$filter", valid_568056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568079: Call_CatalogListAcls_567888; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of access control list (ACL) entries for the Data Lake Analytics catalog.
  ## 
  let valid = call_568079.validator(path, query, header, formData, body)
  let scheme = call_568079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568079.url(scheme.get, call_568079.host, call_568079.base,
                         call_568079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568079, url, valid)

proc call*(call_568150: Call_CatalogListAcls_567888; apiVersion: string;
          Orderby: string = ""; Top: int = 0; Select: string = ""; Skip: int = 0;
          Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListAcls
  ## Retrieves the list of access control list (ACL) entries for the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var query_568151 = newJObject()
  add(query_568151, "$orderby", newJString(Orderby))
  add(query_568151, "api-version", newJString(apiVersion))
  add(query_568151, "$top", newJInt(Top))
  add(query_568151, "$select", newJString(Select))
  add(query_568151, "$skip", newJInt(Skip))
  add(query_568151, "$count", newJBool(Count))
  add(query_568151, "$filter", newJString(Filter))
  result = call_568150.call(nil, query_568151, nil, nil, nil)

var catalogListAcls* = Call_CatalogListAcls_567888(name: "catalogListAcls",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/acl",
    validator: validate_CatalogListAcls_567889, base: "", url: url_CatalogListAcls_567890,
    schemes: {Scheme.Https})
type
  Call_CatalogListDatabases_568191 = ref object of OpenApiRestCall_567666
proc url_CatalogListDatabases_568193(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CatalogListDatabases_568192(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of databases from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568194 = query.getOrDefault("$orderby")
  valid_568194 = validateParameter(valid_568194, JString, required = false,
                                 default = nil)
  if valid_568194 != nil:
    section.add "$orderby", valid_568194
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568195 = query.getOrDefault("api-version")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "api-version", valid_568195
  var valid_568196 = query.getOrDefault("$top")
  valid_568196 = validateParameter(valid_568196, JInt, required = false, default = nil)
  if valid_568196 != nil:
    section.add "$top", valid_568196
  var valid_568197 = query.getOrDefault("$select")
  valid_568197 = validateParameter(valid_568197, JString, required = false,
                                 default = nil)
  if valid_568197 != nil:
    section.add "$select", valid_568197
  var valid_568198 = query.getOrDefault("$skip")
  valid_568198 = validateParameter(valid_568198, JInt, required = false, default = nil)
  if valid_568198 != nil:
    section.add "$skip", valid_568198
  var valid_568199 = query.getOrDefault("$count")
  valid_568199 = validateParameter(valid_568199, JBool, required = false, default = nil)
  if valid_568199 != nil:
    section.add "$count", valid_568199
  var valid_568200 = query.getOrDefault("$filter")
  valid_568200 = validateParameter(valid_568200, JString, required = false,
                                 default = nil)
  if valid_568200 != nil:
    section.add "$filter", valid_568200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568201: Call_CatalogListDatabases_568191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of databases from the Data Lake Analytics catalog.
  ## 
  let valid = call_568201.validator(path, query, header, formData, body)
  let scheme = call_568201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568201.url(scheme.get, call_568201.host, call_568201.base,
                         call_568201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568201, url, valid)

proc call*(call_568202: Call_CatalogListDatabases_568191; apiVersion: string;
          Orderby: string = ""; Top: int = 0; Select: string = ""; Skip: int = 0;
          Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListDatabases
  ## Retrieves the list of databases from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var query_568203 = newJObject()
  add(query_568203, "$orderby", newJString(Orderby))
  add(query_568203, "api-version", newJString(apiVersion))
  add(query_568203, "$top", newJInt(Top))
  add(query_568203, "$select", newJString(Select))
  add(query_568203, "$skip", newJInt(Skip))
  add(query_568203, "$count", newJBool(Count))
  add(query_568203, "$filter", newJString(Filter))
  result = call_568202.call(nil, query_568203, nil, nil, nil)

var catalogListDatabases* = Call_CatalogListDatabases_568191(
    name: "catalogListDatabases", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases", validator: validate_CatalogListDatabases_568192,
    base: "", url: url_CatalogListDatabases_568193, schemes: {Scheme.Https})
type
  Call_CatalogGetDatabase_568204 = ref object of OpenApiRestCall_567666
proc url_CatalogGetDatabase_568206(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetDatabase_568205(path: JsonNode; query: JsonNode;
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
  var valid_568221 = path.getOrDefault("databaseName")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "databaseName", valid_568221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568222 = query.getOrDefault("api-version")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "api-version", valid_568222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568223: Call_CatalogGetDatabase_568204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified database from the Data Lake Analytics catalog.
  ## 
  let valid = call_568223.validator(path, query, header, formData, body)
  let scheme = call_568223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568223.url(scheme.get, call_568223.host, call_568223.base,
                         call_568223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568223, url, valid)

proc call*(call_568224: Call_CatalogGetDatabase_568204; apiVersion: string;
          databaseName: string): Recallable =
  ## catalogGetDatabase
  ## Retrieves the specified database from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database.
  var path_568225 = newJObject()
  var query_568226 = newJObject()
  add(query_568226, "api-version", newJString(apiVersion))
  add(path_568225, "databaseName", newJString(databaseName))
  result = call_568224.call(path_568225, query_568226, nil, nil, nil)

var catalogGetDatabase* = Call_CatalogGetDatabase_568204(
    name: "catalogGetDatabase", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}",
    validator: validate_CatalogGetDatabase_568205, base: "",
    url: url_CatalogGetDatabase_568206, schemes: {Scheme.Https})
type
  Call_CatalogListAclsByDatabase_568227 = ref object of OpenApiRestCall_567666
proc url_CatalogListAclsByDatabase_568229(protocol: Scheme; host: string;
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

proc validate_CatalogListAclsByDatabase_568228(path: JsonNode; query: JsonNode;
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
  var valid_568230 = path.getOrDefault("databaseName")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "databaseName", valid_568230
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568231 = query.getOrDefault("$orderby")
  valid_568231 = validateParameter(valid_568231, JString, required = false,
                                 default = nil)
  if valid_568231 != nil:
    section.add "$orderby", valid_568231
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568232 = query.getOrDefault("api-version")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "api-version", valid_568232
  var valid_568233 = query.getOrDefault("$top")
  valid_568233 = validateParameter(valid_568233, JInt, required = false, default = nil)
  if valid_568233 != nil:
    section.add "$top", valid_568233
  var valid_568234 = query.getOrDefault("$select")
  valid_568234 = validateParameter(valid_568234, JString, required = false,
                                 default = nil)
  if valid_568234 != nil:
    section.add "$select", valid_568234
  var valid_568235 = query.getOrDefault("$skip")
  valid_568235 = validateParameter(valid_568235, JInt, required = false, default = nil)
  if valid_568235 != nil:
    section.add "$skip", valid_568235
  var valid_568236 = query.getOrDefault("$count")
  valid_568236 = validateParameter(valid_568236, JBool, required = false, default = nil)
  if valid_568236 != nil:
    section.add "$count", valid_568236
  var valid_568237 = query.getOrDefault("$filter")
  valid_568237 = validateParameter(valid_568237, JString, required = false,
                                 default = nil)
  if valid_568237 != nil:
    section.add "$filter", valid_568237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568238: Call_CatalogListAclsByDatabase_568227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of access control list (ACL) entries for the database from the Data Lake Analytics catalog.
  ## 
  let valid = call_568238.validator(path, query, header, formData, body)
  let scheme = call_568238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568238.url(scheme.get, call_568238.host, call_568238.base,
                         call_568238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568238, url, valid)

proc call*(call_568239: Call_CatalogListAclsByDatabase_568227; apiVersion: string;
          databaseName: string; Orderby: string = ""; Top: int = 0; Select: string = "";
          Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListAclsByDatabase
  ## Retrieves the list of access control list (ACL) entries for the database from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568240 = newJObject()
  var query_568241 = newJObject()
  add(query_568241, "$orderby", newJString(Orderby))
  add(query_568241, "api-version", newJString(apiVersion))
  add(query_568241, "$top", newJInt(Top))
  add(query_568241, "$select", newJString(Select))
  add(path_568240, "databaseName", newJString(databaseName))
  add(query_568241, "$skip", newJInt(Skip))
  add(query_568241, "$count", newJBool(Count))
  add(query_568241, "$filter", newJString(Filter))
  result = call_568239.call(path_568240, query_568241, nil, nil, nil)

var catalogListAclsByDatabase* = Call_CatalogListAclsByDatabase_568227(
    name: "catalogListAclsByDatabase", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/acl",
    validator: validate_CatalogListAclsByDatabase_568228, base: "",
    url: url_CatalogListAclsByDatabase_568229, schemes: {Scheme.Https})
type
  Call_CatalogListAssemblies_568242 = ref object of OpenApiRestCall_567666
proc url_CatalogListAssemblies_568244(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListAssemblies_568243(path: JsonNode; query: JsonNode;
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
  var valid_568245 = path.getOrDefault("databaseName")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "databaseName", valid_568245
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568246 = query.getOrDefault("$orderby")
  valid_568246 = validateParameter(valid_568246, JString, required = false,
                                 default = nil)
  if valid_568246 != nil:
    section.add "$orderby", valid_568246
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568247 = query.getOrDefault("api-version")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "api-version", valid_568247
  var valid_568248 = query.getOrDefault("$top")
  valid_568248 = validateParameter(valid_568248, JInt, required = false, default = nil)
  if valid_568248 != nil:
    section.add "$top", valid_568248
  var valid_568249 = query.getOrDefault("$select")
  valid_568249 = validateParameter(valid_568249, JString, required = false,
                                 default = nil)
  if valid_568249 != nil:
    section.add "$select", valid_568249
  var valid_568250 = query.getOrDefault("$skip")
  valid_568250 = validateParameter(valid_568250, JInt, required = false, default = nil)
  if valid_568250 != nil:
    section.add "$skip", valid_568250
  var valid_568251 = query.getOrDefault("$count")
  valid_568251 = validateParameter(valid_568251, JBool, required = false, default = nil)
  if valid_568251 != nil:
    section.add "$count", valid_568251
  var valid_568252 = query.getOrDefault("$filter")
  valid_568252 = validateParameter(valid_568252, JString, required = false,
                                 default = nil)
  if valid_568252 != nil:
    section.add "$filter", valid_568252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568253: Call_CatalogListAssemblies_568242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of assemblies from the Data Lake Analytics catalog.
  ## 
  let valid = call_568253.validator(path, query, header, formData, body)
  let scheme = call_568253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568253.url(scheme.get, call_568253.host, call_568253.base,
                         call_568253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568253, url, valid)

proc call*(call_568254: Call_CatalogListAssemblies_568242; apiVersion: string;
          databaseName: string; Orderby: string = ""; Top: int = 0; Select: string = "";
          Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListAssemblies
  ## Retrieves the list of assemblies from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the assembly.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568255 = newJObject()
  var query_568256 = newJObject()
  add(query_568256, "$orderby", newJString(Orderby))
  add(query_568256, "api-version", newJString(apiVersion))
  add(query_568256, "$top", newJInt(Top))
  add(query_568256, "$select", newJString(Select))
  add(path_568255, "databaseName", newJString(databaseName))
  add(query_568256, "$skip", newJInt(Skip))
  add(query_568256, "$count", newJBool(Count))
  add(query_568256, "$filter", newJString(Filter))
  result = call_568254.call(path_568255, query_568256, nil, nil, nil)

var catalogListAssemblies* = Call_CatalogListAssemblies_568242(
    name: "catalogListAssemblies", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/assemblies",
    validator: validate_CatalogListAssemblies_568243, base: "",
    url: url_CatalogListAssemblies_568244, schemes: {Scheme.Https})
type
  Call_CatalogGetAssembly_568257 = ref object of OpenApiRestCall_567666
proc url_CatalogGetAssembly_568259(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetAssembly_568258(path: JsonNode; query: JsonNode;
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
  var valid_568260 = path.getOrDefault("databaseName")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "databaseName", valid_568260
  var valid_568261 = path.getOrDefault("assemblyName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "assemblyName", valid_568261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568262 = query.getOrDefault("api-version")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "api-version", valid_568262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568263: Call_CatalogGetAssembly_568257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified assembly from the Data Lake Analytics catalog.
  ## 
  let valid = call_568263.validator(path, query, header, formData, body)
  let scheme = call_568263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568263.url(scheme.get, call_568263.host, call_568263.base,
                         call_568263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568263, url, valid)

proc call*(call_568264: Call_CatalogGetAssembly_568257; apiVersion: string;
          databaseName: string; assemblyName: string): Recallable =
  ## catalogGetAssembly
  ## Retrieves the specified assembly from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the assembly.
  ##   assemblyName: string (required)
  ##               : The name of the assembly.
  var path_568265 = newJObject()
  var query_568266 = newJObject()
  add(query_568266, "api-version", newJString(apiVersion))
  add(path_568265, "databaseName", newJString(databaseName))
  add(path_568265, "assemblyName", newJString(assemblyName))
  result = call_568264.call(path_568265, query_568266, nil, nil, nil)

var catalogGetAssembly* = Call_CatalogGetAssembly_568257(
    name: "catalogGetAssembly", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/assemblies/{assemblyName}",
    validator: validate_CatalogGetAssembly_568258, base: "",
    url: url_CatalogGetAssembly_568259, schemes: {Scheme.Https})
type
  Call_CatalogListCredentials_568267 = ref object of OpenApiRestCall_567666
proc url_CatalogListCredentials_568269(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListCredentials_568268(path: JsonNode; query: JsonNode;
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
  var valid_568270 = path.getOrDefault("databaseName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "databaseName", valid_568270
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568271 = query.getOrDefault("$orderby")
  valid_568271 = validateParameter(valid_568271, JString, required = false,
                                 default = nil)
  if valid_568271 != nil:
    section.add "$orderby", valid_568271
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568272 = query.getOrDefault("api-version")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "api-version", valid_568272
  var valid_568273 = query.getOrDefault("$top")
  valid_568273 = validateParameter(valid_568273, JInt, required = false, default = nil)
  if valid_568273 != nil:
    section.add "$top", valid_568273
  var valid_568274 = query.getOrDefault("$select")
  valid_568274 = validateParameter(valid_568274, JString, required = false,
                                 default = nil)
  if valid_568274 != nil:
    section.add "$select", valid_568274
  var valid_568275 = query.getOrDefault("$skip")
  valid_568275 = validateParameter(valid_568275, JInt, required = false, default = nil)
  if valid_568275 != nil:
    section.add "$skip", valid_568275
  var valid_568276 = query.getOrDefault("$count")
  valid_568276 = validateParameter(valid_568276, JBool, required = false, default = nil)
  if valid_568276 != nil:
    section.add "$count", valid_568276
  var valid_568277 = query.getOrDefault("$filter")
  valid_568277 = validateParameter(valid_568277, JString, required = false,
                                 default = nil)
  if valid_568277 != nil:
    section.add "$filter", valid_568277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568278: Call_CatalogListCredentials_568267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of credentials from the Data Lake Analytics catalog.
  ## 
  let valid = call_568278.validator(path, query, header, formData, body)
  let scheme = call_568278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568278.url(scheme.get, call_568278.host, call_568278.base,
                         call_568278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568278, url, valid)

proc call*(call_568279: Call_CatalogListCredentials_568267; apiVersion: string;
          databaseName: string; Orderby: string = ""; Top: int = 0; Select: string = "";
          Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListCredentials
  ## Retrieves the list of credentials from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the schema.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568280 = newJObject()
  var query_568281 = newJObject()
  add(query_568281, "$orderby", newJString(Orderby))
  add(query_568281, "api-version", newJString(apiVersion))
  add(query_568281, "$top", newJInt(Top))
  add(query_568281, "$select", newJString(Select))
  add(path_568280, "databaseName", newJString(databaseName))
  add(query_568281, "$skip", newJInt(Skip))
  add(query_568281, "$count", newJBool(Count))
  add(query_568281, "$filter", newJString(Filter))
  result = call_568279.call(path_568280, query_568281, nil, nil, nil)

var catalogListCredentials* = Call_CatalogListCredentials_568267(
    name: "catalogListCredentials", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/credentials",
    validator: validate_CatalogListCredentials_568268, base: "",
    url: url_CatalogListCredentials_568269, schemes: {Scheme.Https})
type
  Call_CatalogCreateCredential_568292 = ref object of OpenApiRestCall_567666
proc url_CatalogCreateCredential_568294(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogCreateCredential_568293(path: JsonNode; query: JsonNode;
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
  var valid_568312 = path.getOrDefault("databaseName")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "databaseName", valid_568312
  var valid_568313 = path.getOrDefault("credentialName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "credentialName", valid_568313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568314 = query.getOrDefault("api-version")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "api-version", valid_568314
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

proc call*(call_568316: Call_CatalogCreateCredential_568292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the specified credential for use with external data sources in the specified database.
  ## 
  let valid = call_568316.validator(path, query, header, formData, body)
  let scheme = call_568316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568316.url(scheme.get, call_568316.host, call_568316.base,
                         call_568316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568316, url, valid)

proc call*(call_568317: Call_CatalogCreateCredential_568292; apiVersion: string;
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
  var path_568318 = newJObject()
  var query_568319 = newJObject()
  var body_568320 = newJObject()
  add(query_568319, "api-version", newJString(apiVersion))
  add(path_568318, "databaseName", newJString(databaseName))
  add(path_568318, "credentialName", newJString(credentialName))
  if parameters != nil:
    body_568320 = parameters
  result = call_568317.call(path_568318, query_568319, nil, nil, body_568320)

var catalogCreateCredential* = Call_CatalogCreateCredential_568292(
    name: "catalogCreateCredential", meth: HttpMethod.HttpPut, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/credentials/{credentialName}",
    validator: validate_CatalogCreateCredential_568293, base: "",
    url: url_CatalogCreateCredential_568294, schemes: {Scheme.Https})
type
  Call_CatalogDeleteCredential_568321 = ref object of OpenApiRestCall_567666
proc url_CatalogDeleteCredential_568323(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogDeleteCredential_568322(path: JsonNode; query: JsonNode;
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
  var valid_568324 = path.getOrDefault("databaseName")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "databaseName", valid_568324
  var valid_568325 = path.getOrDefault("credentialName")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "credentialName", valid_568325
  result.add "path", section
  ## parameters in `query` object:
  ##   cascade: JBool
  ##          : Indicates if the delete should be a cascading delete (which deletes all resources dependent on the credential as well as the credential) or not. If false will fail if there are any resources relying on the credential.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_568339 = query.getOrDefault("cascade")
  valid_568339 = validateParameter(valid_568339, JBool, required = false,
                                 default = newJBool(false))
  if valid_568339 != nil:
    section.add "cascade", valid_568339
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568340 = query.getOrDefault("api-version")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "api-version", valid_568340
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

proc call*(call_568342: Call_CatalogDeleteCredential_568321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified credential in the specified database
  ## 
  let valid = call_568342.validator(path, query, header, formData, body)
  let scheme = call_568342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568342.url(scheme.get, call_568342.host, call_568342.base,
                         call_568342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568342, url, valid)

proc call*(call_568343: Call_CatalogDeleteCredential_568321; apiVersion: string;
          databaseName: string; credentialName: string; cascade: bool = false;
          parameters: JsonNode = nil): Recallable =
  ## catalogDeleteCredential
  ## Deletes the specified credential in the specified database
  ##   cascade: bool
  ##          : Indicates if the delete should be a cascading delete (which deletes all resources dependent on the credential as well as the credential) or not. If false will fail if there are any resources relying on the credential.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the credential.
  ##   credentialName: string (required)
  ##                 : The name of the credential to delete
  ##   parameters: JObject
  ##             : The parameters to delete a credential if the current user is not the account owner.
  var path_568344 = newJObject()
  var query_568345 = newJObject()
  var body_568346 = newJObject()
  add(query_568345, "cascade", newJBool(cascade))
  add(query_568345, "api-version", newJString(apiVersion))
  add(path_568344, "databaseName", newJString(databaseName))
  add(path_568344, "credentialName", newJString(credentialName))
  if parameters != nil:
    body_568346 = parameters
  result = call_568343.call(path_568344, query_568345, nil, nil, body_568346)

var catalogDeleteCredential* = Call_CatalogDeleteCredential_568321(
    name: "catalogDeleteCredential", meth: HttpMethod.HttpPost, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/credentials/{credentialName}",
    validator: validate_CatalogDeleteCredential_568322, base: "",
    url: url_CatalogDeleteCredential_568323, schemes: {Scheme.Https})
type
  Call_CatalogGetCredential_568282 = ref object of OpenApiRestCall_567666
proc url_CatalogGetCredential_568284(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetCredential_568283(path: JsonNode; query: JsonNode;
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
  var valid_568285 = path.getOrDefault("databaseName")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "databaseName", valid_568285
  var valid_568286 = path.getOrDefault("credentialName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "credentialName", valid_568286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568287 = query.getOrDefault("api-version")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "api-version", valid_568287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568288: Call_CatalogGetCredential_568282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified credential from the Data Lake Analytics catalog.
  ## 
  let valid = call_568288.validator(path, query, header, formData, body)
  let scheme = call_568288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568288.url(scheme.get, call_568288.host, call_568288.base,
                         call_568288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568288, url, valid)

proc call*(call_568289: Call_CatalogGetCredential_568282; apiVersion: string;
          databaseName: string; credentialName: string): Recallable =
  ## catalogGetCredential
  ## Retrieves the specified credential from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the schema.
  ##   credentialName: string (required)
  ##                 : The name of the credential.
  var path_568290 = newJObject()
  var query_568291 = newJObject()
  add(query_568291, "api-version", newJString(apiVersion))
  add(path_568290, "databaseName", newJString(databaseName))
  add(path_568290, "credentialName", newJString(credentialName))
  result = call_568289.call(path_568290, query_568291, nil, nil, nil)

var catalogGetCredential* = Call_CatalogGetCredential_568282(
    name: "catalogGetCredential", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/credentials/{credentialName}",
    validator: validate_CatalogGetCredential_568283, base: "",
    url: url_CatalogGetCredential_568284, schemes: {Scheme.Https})
type
  Call_CatalogUpdateCredential_568347 = ref object of OpenApiRestCall_567666
proc url_CatalogUpdateCredential_568349(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogUpdateCredential_568348(path: JsonNode; query: JsonNode;
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
  var valid_568350 = path.getOrDefault("databaseName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "databaseName", valid_568350
  var valid_568351 = path.getOrDefault("credentialName")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "credentialName", valid_568351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568352 = query.getOrDefault("api-version")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "api-version", valid_568352
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

proc call*(call_568354: Call_CatalogUpdateCredential_568347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the specified credential for use with external data sources in the specified database
  ## 
  let valid = call_568354.validator(path, query, header, formData, body)
  let scheme = call_568354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568354.url(scheme.get, call_568354.host, call_568354.base,
                         call_568354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568354, url, valid)

proc call*(call_568355: Call_CatalogUpdateCredential_568347; apiVersion: string;
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
  var path_568356 = newJObject()
  var query_568357 = newJObject()
  var body_568358 = newJObject()
  add(query_568357, "api-version", newJString(apiVersion))
  add(path_568356, "databaseName", newJString(databaseName))
  add(path_568356, "credentialName", newJString(credentialName))
  if parameters != nil:
    body_568358 = parameters
  result = call_568355.call(path_568356, query_568357, nil, nil, body_568358)

var catalogUpdateCredential* = Call_CatalogUpdateCredential_568347(
    name: "catalogUpdateCredential", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/credentials/{credentialName}",
    validator: validate_CatalogUpdateCredential_568348, base: "",
    url: url_CatalogUpdateCredential_568349, schemes: {Scheme.Https})
type
  Call_CatalogListExternalDataSources_568359 = ref object of OpenApiRestCall_567666
proc url_CatalogListExternalDataSources_568361(protocol: Scheme; host: string;
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

proc validate_CatalogListExternalDataSources_568360(path: JsonNode;
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
  var valid_568362 = path.getOrDefault("databaseName")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "databaseName", valid_568362
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568363 = query.getOrDefault("$orderby")
  valid_568363 = validateParameter(valid_568363, JString, required = false,
                                 default = nil)
  if valid_568363 != nil:
    section.add "$orderby", valid_568363
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568364 = query.getOrDefault("api-version")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "api-version", valid_568364
  var valid_568365 = query.getOrDefault("$top")
  valid_568365 = validateParameter(valid_568365, JInt, required = false, default = nil)
  if valid_568365 != nil:
    section.add "$top", valid_568365
  var valid_568366 = query.getOrDefault("$select")
  valid_568366 = validateParameter(valid_568366, JString, required = false,
                                 default = nil)
  if valid_568366 != nil:
    section.add "$select", valid_568366
  var valid_568367 = query.getOrDefault("$skip")
  valid_568367 = validateParameter(valid_568367, JInt, required = false, default = nil)
  if valid_568367 != nil:
    section.add "$skip", valid_568367
  var valid_568368 = query.getOrDefault("$count")
  valid_568368 = validateParameter(valid_568368, JBool, required = false, default = nil)
  if valid_568368 != nil:
    section.add "$count", valid_568368
  var valid_568369 = query.getOrDefault("$filter")
  valid_568369 = validateParameter(valid_568369, JString, required = false,
                                 default = nil)
  if valid_568369 != nil:
    section.add "$filter", valid_568369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568370: Call_CatalogListExternalDataSources_568359; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of external data sources from the Data Lake Analytics catalog.
  ## 
  let valid = call_568370.validator(path, query, header, formData, body)
  let scheme = call_568370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568370.url(scheme.get, call_568370.host, call_568370.base,
                         call_568370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568370, url, valid)

proc call*(call_568371: Call_CatalogListExternalDataSources_568359;
          apiVersion: string; databaseName: string; Orderby: string = ""; Top: int = 0;
          Select: string = ""; Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListExternalDataSources
  ## Retrieves the list of external data sources from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the external data sources.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568372 = newJObject()
  var query_568373 = newJObject()
  add(query_568373, "$orderby", newJString(Orderby))
  add(query_568373, "api-version", newJString(apiVersion))
  add(query_568373, "$top", newJInt(Top))
  add(query_568373, "$select", newJString(Select))
  add(path_568372, "databaseName", newJString(databaseName))
  add(query_568373, "$skip", newJInt(Skip))
  add(query_568373, "$count", newJBool(Count))
  add(query_568373, "$filter", newJString(Filter))
  result = call_568371.call(path_568372, query_568373, nil, nil, nil)

var catalogListExternalDataSources* = Call_CatalogListExternalDataSources_568359(
    name: "catalogListExternalDataSources", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/externaldatasources",
    validator: validate_CatalogListExternalDataSources_568360, base: "",
    url: url_CatalogListExternalDataSources_568361, schemes: {Scheme.Https})
type
  Call_CatalogGetExternalDataSource_568374 = ref object of OpenApiRestCall_567666
proc url_CatalogGetExternalDataSource_568376(protocol: Scheme; host: string;
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

proc validate_CatalogGetExternalDataSource_568375(path: JsonNode; query: JsonNode;
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
  var valid_568377 = path.getOrDefault("externalDataSourceName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "externalDataSourceName", valid_568377
  var valid_568378 = path.getOrDefault("databaseName")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "databaseName", valid_568378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568379 = query.getOrDefault("api-version")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "api-version", valid_568379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568380: Call_CatalogGetExternalDataSource_568374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified external data source from the Data Lake Analytics catalog.
  ## 
  let valid = call_568380.validator(path, query, header, formData, body)
  let scheme = call_568380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568380.url(scheme.get, call_568380.host, call_568380.base,
                         call_568380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568380, url, valid)

proc call*(call_568381: Call_CatalogGetExternalDataSource_568374;
          externalDataSourceName: string; apiVersion: string; databaseName: string): Recallable =
  ## catalogGetExternalDataSource
  ## Retrieves the specified external data source from the Data Lake Analytics catalog.
  ##   externalDataSourceName: string (required)
  ##                         : The name of the external data source.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the external data source.
  var path_568382 = newJObject()
  var query_568383 = newJObject()
  add(path_568382, "externalDataSourceName", newJString(externalDataSourceName))
  add(query_568383, "api-version", newJString(apiVersion))
  add(path_568382, "databaseName", newJString(databaseName))
  result = call_568381.call(path_568382, query_568383, nil, nil, nil)

var catalogGetExternalDataSource* = Call_CatalogGetExternalDataSource_568374(
    name: "catalogGetExternalDataSource", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/externaldatasources/{externalDataSourceName}",
    validator: validate_CatalogGetExternalDataSource_568375, base: "",
    url: url_CatalogGetExternalDataSource_568376, schemes: {Scheme.Https})
type
  Call_CatalogListSchemas_568384 = ref object of OpenApiRestCall_567666
proc url_CatalogListSchemas_568386(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListSchemas_568385(path: JsonNode; query: JsonNode;
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
  var valid_568387 = path.getOrDefault("databaseName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "databaseName", valid_568387
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568388 = query.getOrDefault("$orderby")
  valid_568388 = validateParameter(valid_568388, JString, required = false,
                                 default = nil)
  if valid_568388 != nil:
    section.add "$orderby", valid_568388
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568389 = query.getOrDefault("api-version")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "api-version", valid_568389
  var valid_568390 = query.getOrDefault("$top")
  valid_568390 = validateParameter(valid_568390, JInt, required = false, default = nil)
  if valid_568390 != nil:
    section.add "$top", valid_568390
  var valid_568391 = query.getOrDefault("$select")
  valid_568391 = validateParameter(valid_568391, JString, required = false,
                                 default = nil)
  if valid_568391 != nil:
    section.add "$select", valid_568391
  var valid_568392 = query.getOrDefault("$skip")
  valid_568392 = validateParameter(valid_568392, JInt, required = false, default = nil)
  if valid_568392 != nil:
    section.add "$skip", valid_568392
  var valid_568393 = query.getOrDefault("$count")
  valid_568393 = validateParameter(valid_568393, JBool, required = false, default = nil)
  if valid_568393 != nil:
    section.add "$count", valid_568393
  var valid_568394 = query.getOrDefault("$filter")
  valid_568394 = validateParameter(valid_568394, JString, required = false,
                                 default = nil)
  if valid_568394 != nil:
    section.add "$filter", valid_568394
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568395: Call_CatalogListSchemas_568384; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of schemas from the Data Lake Analytics catalog.
  ## 
  let valid = call_568395.validator(path, query, header, formData, body)
  let scheme = call_568395.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568395.url(scheme.get, call_568395.host, call_568395.base,
                         call_568395.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568395, url, valid)

proc call*(call_568396: Call_CatalogListSchemas_568384; apiVersion: string;
          databaseName: string; Orderby: string = ""; Top: int = 0; Select: string = "";
          Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListSchemas
  ## Retrieves the list of schemas from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the schema.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568397 = newJObject()
  var query_568398 = newJObject()
  add(query_568398, "$orderby", newJString(Orderby))
  add(query_568398, "api-version", newJString(apiVersion))
  add(query_568398, "$top", newJInt(Top))
  add(query_568398, "$select", newJString(Select))
  add(path_568397, "databaseName", newJString(databaseName))
  add(query_568398, "$skip", newJInt(Skip))
  add(query_568398, "$count", newJBool(Count))
  add(query_568398, "$filter", newJString(Filter))
  result = call_568396.call(path_568397, query_568398, nil, nil, nil)

var catalogListSchemas* = Call_CatalogListSchemas_568384(
    name: "catalogListSchemas", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas",
    validator: validate_CatalogListSchemas_568385, base: "",
    url: url_CatalogListSchemas_568386, schemes: {Scheme.Https})
type
  Call_CatalogGetSchema_568399 = ref object of OpenApiRestCall_567666
proc url_CatalogGetSchema_568401(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetSchema_568400(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves the specified schema from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaName: JString (required)
  ##             : The name of the schema.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the schema.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `schemaName` field"
  var valid_568402 = path.getOrDefault("schemaName")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "schemaName", valid_568402
  var valid_568403 = path.getOrDefault("databaseName")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "databaseName", valid_568403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568404 = query.getOrDefault("api-version")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "api-version", valid_568404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568405: Call_CatalogGetSchema_568399; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified schema from the Data Lake Analytics catalog.
  ## 
  let valid = call_568405.validator(path, query, header, formData, body)
  let scheme = call_568405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568405.url(scheme.get, call_568405.host, call_568405.base,
                         call_568405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568405, url, valid)

proc call*(call_568406: Call_CatalogGetSchema_568399; apiVersion: string;
          schemaName: string; databaseName: string): Recallable =
  ## catalogGetSchema
  ## Retrieves the specified schema from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   schemaName: string (required)
  ##             : The name of the schema.
  ##   databaseName: string (required)
  ##               : The name of the database containing the schema.
  var path_568407 = newJObject()
  var query_568408 = newJObject()
  add(query_568408, "api-version", newJString(apiVersion))
  add(path_568407, "schemaName", newJString(schemaName))
  add(path_568407, "databaseName", newJString(databaseName))
  result = call_568406.call(path_568407, query_568408, nil, nil, nil)

var catalogGetSchema* = Call_CatalogGetSchema_568399(name: "catalogGetSchema",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}",
    validator: validate_CatalogGetSchema_568400, base: "",
    url: url_CatalogGetSchema_568401, schemes: {Scheme.Https})
type
  Call_CatalogListPackages_568409 = ref object of OpenApiRestCall_567666
proc url_CatalogListPackages_568411(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListPackages_568410(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves the list of packages from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the packages.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the packages.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `schemaName` field"
  var valid_568412 = path.getOrDefault("schemaName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "schemaName", valid_568412
  var valid_568413 = path.getOrDefault("databaseName")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "databaseName", valid_568413
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568414 = query.getOrDefault("$orderby")
  valid_568414 = validateParameter(valid_568414, JString, required = false,
                                 default = nil)
  if valid_568414 != nil:
    section.add "$orderby", valid_568414
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568415 = query.getOrDefault("api-version")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "api-version", valid_568415
  var valid_568416 = query.getOrDefault("$top")
  valid_568416 = validateParameter(valid_568416, JInt, required = false, default = nil)
  if valid_568416 != nil:
    section.add "$top", valid_568416
  var valid_568417 = query.getOrDefault("$select")
  valid_568417 = validateParameter(valid_568417, JString, required = false,
                                 default = nil)
  if valid_568417 != nil:
    section.add "$select", valid_568417
  var valid_568418 = query.getOrDefault("$skip")
  valid_568418 = validateParameter(valid_568418, JInt, required = false, default = nil)
  if valid_568418 != nil:
    section.add "$skip", valid_568418
  var valid_568419 = query.getOrDefault("$count")
  valid_568419 = validateParameter(valid_568419, JBool, required = false, default = nil)
  if valid_568419 != nil:
    section.add "$count", valid_568419
  var valid_568420 = query.getOrDefault("$filter")
  valid_568420 = validateParameter(valid_568420, JString, required = false,
                                 default = nil)
  if valid_568420 != nil:
    section.add "$filter", valid_568420
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568421: Call_CatalogListPackages_568409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of packages from the Data Lake Analytics catalog.
  ## 
  let valid = call_568421.validator(path, query, header, formData, body)
  let scheme = call_568421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568421.url(scheme.get, call_568421.host, call_568421.base,
                         call_568421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568421, url, valid)

proc call*(call_568422: Call_CatalogListPackages_568409; apiVersion: string;
          schemaName: string; databaseName: string; Orderby: string = ""; Top: int = 0;
          Select: string = ""; Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListPackages
  ## Retrieves the list of packages from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the packages.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the packages.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568423 = newJObject()
  var query_568424 = newJObject()
  add(query_568424, "$orderby", newJString(Orderby))
  add(query_568424, "api-version", newJString(apiVersion))
  add(query_568424, "$top", newJInt(Top))
  add(path_568423, "schemaName", newJString(schemaName))
  add(query_568424, "$select", newJString(Select))
  add(path_568423, "databaseName", newJString(databaseName))
  add(query_568424, "$skip", newJInt(Skip))
  add(query_568424, "$count", newJBool(Count))
  add(query_568424, "$filter", newJString(Filter))
  result = call_568422.call(path_568423, query_568424, nil, nil, nil)

var catalogListPackages* = Call_CatalogListPackages_568409(
    name: "catalogListPackages", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/packages",
    validator: validate_CatalogListPackages_568410, base: "",
    url: url_CatalogListPackages_568411, schemes: {Scheme.Https})
type
  Call_CatalogGetPackage_568425 = ref object of OpenApiRestCall_567666
proc url_CatalogGetPackage_568427(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetPackage_568426(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves the specified package from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The name of the package.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the package.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the package.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_568428 = path.getOrDefault("packageName")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "packageName", valid_568428
  var valid_568429 = path.getOrDefault("schemaName")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "schemaName", valid_568429
  var valid_568430 = path.getOrDefault("databaseName")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "databaseName", valid_568430
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568431 = query.getOrDefault("api-version")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "api-version", valid_568431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568432: Call_CatalogGetPackage_568425; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified package from the Data Lake Analytics catalog.
  ## 
  let valid = call_568432.validator(path, query, header, formData, body)
  let scheme = call_568432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568432.url(scheme.get, call_568432.host, call_568432.base,
                         call_568432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568432, url, valid)

proc call*(call_568433: Call_CatalogGetPackage_568425; packageName: string;
          apiVersion: string; schemaName: string; databaseName: string): Recallable =
  ## catalogGetPackage
  ## Retrieves the specified package from the Data Lake Analytics catalog.
  ##   packageName: string (required)
  ##              : The name of the package.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the package.
  ##   databaseName: string (required)
  ##               : The name of the database containing the package.
  var path_568434 = newJObject()
  var query_568435 = newJObject()
  add(path_568434, "packageName", newJString(packageName))
  add(query_568435, "api-version", newJString(apiVersion))
  add(path_568434, "schemaName", newJString(schemaName))
  add(path_568434, "databaseName", newJString(databaseName))
  result = call_568433.call(path_568434, query_568435, nil, nil, nil)

var catalogGetPackage* = Call_CatalogGetPackage_568425(name: "catalogGetPackage",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/packages/{packageName}",
    validator: validate_CatalogGetPackage_568426, base: "",
    url: url_CatalogGetPackage_568427, schemes: {Scheme.Https})
type
  Call_CatalogListProcedures_568436 = ref object of OpenApiRestCall_567666
proc url_CatalogListProcedures_568438(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListProcedures_568437(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of procedures from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the procedures.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the procedures.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `schemaName` field"
  var valid_568439 = path.getOrDefault("schemaName")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "schemaName", valid_568439
  var valid_568440 = path.getOrDefault("databaseName")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "databaseName", valid_568440
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568441 = query.getOrDefault("$orderby")
  valid_568441 = validateParameter(valid_568441, JString, required = false,
                                 default = nil)
  if valid_568441 != nil:
    section.add "$orderby", valid_568441
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568442 = query.getOrDefault("api-version")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "api-version", valid_568442
  var valid_568443 = query.getOrDefault("$top")
  valid_568443 = validateParameter(valid_568443, JInt, required = false, default = nil)
  if valid_568443 != nil:
    section.add "$top", valid_568443
  var valid_568444 = query.getOrDefault("$select")
  valid_568444 = validateParameter(valid_568444, JString, required = false,
                                 default = nil)
  if valid_568444 != nil:
    section.add "$select", valid_568444
  var valid_568445 = query.getOrDefault("$skip")
  valid_568445 = validateParameter(valid_568445, JInt, required = false, default = nil)
  if valid_568445 != nil:
    section.add "$skip", valid_568445
  var valid_568446 = query.getOrDefault("$count")
  valid_568446 = validateParameter(valid_568446, JBool, required = false, default = nil)
  if valid_568446 != nil:
    section.add "$count", valid_568446
  var valid_568447 = query.getOrDefault("$filter")
  valid_568447 = validateParameter(valid_568447, JString, required = false,
                                 default = nil)
  if valid_568447 != nil:
    section.add "$filter", valid_568447
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568448: Call_CatalogListProcedures_568436; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of procedures from the Data Lake Analytics catalog.
  ## 
  let valid = call_568448.validator(path, query, header, formData, body)
  let scheme = call_568448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568448.url(scheme.get, call_568448.host, call_568448.base,
                         call_568448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568448, url, valid)

proc call*(call_568449: Call_CatalogListProcedures_568436; apiVersion: string;
          schemaName: string; databaseName: string; Orderby: string = ""; Top: int = 0;
          Select: string = ""; Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListProcedures
  ## Retrieves the list of procedures from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the procedures.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the procedures.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568450 = newJObject()
  var query_568451 = newJObject()
  add(query_568451, "$orderby", newJString(Orderby))
  add(query_568451, "api-version", newJString(apiVersion))
  add(query_568451, "$top", newJInt(Top))
  add(path_568450, "schemaName", newJString(schemaName))
  add(query_568451, "$select", newJString(Select))
  add(path_568450, "databaseName", newJString(databaseName))
  add(query_568451, "$skip", newJInt(Skip))
  add(query_568451, "$count", newJBool(Count))
  add(query_568451, "$filter", newJString(Filter))
  result = call_568449.call(path_568450, query_568451, nil, nil, nil)

var catalogListProcedures* = Call_CatalogListProcedures_568436(
    name: "catalogListProcedures", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/procedures",
    validator: validate_CatalogListProcedures_568437, base: "",
    url: url_CatalogListProcedures_568438, schemes: {Scheme.Https})
type
  Call_CatalogGetProcedure_568452 = ref object of OpenApiRestCall_567666
proc url_CatalogGetProcedure_568454(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetProcedure_568453(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves the specified procedure from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   procedureName: JString (required)
  ##                : The name of the procedure.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the procedure.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the procedure.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `procedureName` field"
  var valid_568455 = path.getOrDefault("procedureName")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "procedureName", valid_568455
  var valid_568456 = path.getOrDefault("schemaName")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "schemaName", valid_568456
  var valid_568457 = path.getOrDefault("databaseName")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "databaseName", valid_568457
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568458 = query.getOrDefault("api-version")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "api-version", valid_568458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568459: Call_CatalogGetProcedure_568452; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified procedure from the Data Lake Analytics catalog.
  ## 
  let valid = call_568459.validator(path, query, header, formData, body)
  let scheme = call_568459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568459.url(scheme.get, call_568459.host, call_568459.base,
                         call_568459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568459, url, valid)

proc call*(call_568460: Call_CatalogGetProcedure_568452; apiVersion: string;
          procedureName: string; schemaName: string; databaseName: string): Recallable =
  ## catalogGetProcedure
  ## Retrieves the specified procedure from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   procedureName: string (required)
  ##                : The name of the procedure.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the procedure.
  ##   databaseName: string (required)
  ##               : The name of the database containing the procedure.
  var path_568461 = newJObject()
  var query_568462 = newJObject()
  add(query_568462, "api-version", newJString(apiVersion))
  add(path_568461, "procedureName", newJString(procedureName))
  add(path_568461, "schemaName", newJString(schemaName))
  add(path_568461, "databaseName", newJString(databaseName))
  result = call_568460.call(path_568461, query_568462, nil, nil, nil)

var catalogGetProcedure* = Call_CatalogGetProcedure_568452(
    name: "catalogGetProcedure", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/procedures/{procedureName}",
    validator: validate_CatalogGetProcedure_568453, base: "",
    url: url_CatalogGetProcedure_568454, schemes: {Scheme.Https})
type
  Call_CatalogListTableStatisticsByDatabaseAndSchema_568463 = ref object of OpenApiRestCall_567666
proc url_CatalogListTableStatisticsByDatabaseAndSchema_568465(protocol: Scheme;
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

proc validate_CatalogListTableStatisticsByDatabaseAndSchema_568464(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves the list of all table statistics within the specified schema from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the statistics.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the statistics.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `schemaName` field"
  var valid_568466 = path.getOrDefault("schemaName")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "schemaName", valid_568466
  var valid_568467 = path.getOrDefault("databaseName")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "databaseName", valid_568467
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568468 = query.getOrDefault("$orderby")
  valid_568468 = validateParameter(valid_568468, JString, required = false,
                                 default = nil)
  if valid_568468 != nil:
    section.add "$orderby", valid_568468
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568469 = query.getOrDefault("api-version")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "api-version", valid_568469
  var valid_568470 = query.getOrDefault("$top")
  valid_568470 = validateParameter(valid_568470, JInt, required = false, default = nil)
  if valid_568470 != nil:
    section.add "$top", valid_568470
  var valid_568471 = query.getOrDefault("$select")
  valid_568471 = validateParameter(valid_568471, JString, required = false,
                                 default = nil)
  if valid_568471 != nil:
    section.add "$select", valid_568471
  var valid_568472 = query.getOrDefault("$skip")
  valid_568472 = validateParameter(valid_568472, JInt, required = false, default = nil)
  if valid_568472 != nil:
    section.add "$skip", valid_568472
  var valid_568473 = query.getOrDefault("$count")
  valid_568473 = validateParameter(valid_568473, JBool, required = false, default = nil)
  if valid_568473 != nil:
    section.add "$count", valid_568473
  var valid_568474 = query.getOrDefault("$filter")
  valid_568474 = validateParameter(valid_568474, JString, required = false,
                                 default = nil)
  if valid_568474 != nil:
    section.add "$filter", valid_568474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568475: Call_CatalogListTableStatisticsByDatabaseAndSchema_568463;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of all table statistics within the specified schema from the Data Lake Analytics catalog.
  ## 
  let valid = call_568475.validator(path, query, header, formData, body)
  let scheme = call_568475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568475.url(scheme.get, call_568475.host, call_568475.base,
                         call_568475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568475, url, valid)

proc call*(call_568476: Call_CatalogListTableStatisticsByDatabaseAndSchema_568463;
          apiVersion: string; schemaName: string; databaseName: string;
          Orderby: string = ""; Top: int = 0; Select: string = ""; Skip: int = 0;
          Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListTableStatisticsByDatabaseAndSchema
  ## Retrieves the list of all table statistics within the specified schema from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the statistics.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the statistics.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568477 = newJObject()
  var query_568478 = newJObject()
  add(query_568478, "$orderby", newJString(Orderby))
  add(query_568478, "api-version", newJString(apiVersion))
  add(query_568478, "$top", newJInt(Top))
  add(path_568477, "schemaName", newJString(schemaName))
  add(query_568478, "$select", newJString(Select))
  add(path_568477, "databaseName", newJString(databaseName))
  add(query_568478, "$skip", newJInt(Skip))
  add(query_568478, "$count", newJBool(Count))
  add(query_568478, "$filter", newJString(Filter))
  result = call_568476.call(path_568477, query_568478, nil, nil, nil)

var catalogListTableStatisticsByDatabaseAndSchema* = Call_CatalogListTableStatisticsByDatabaseAndSchema_568463(
    name: "catalogListTableStatisticsByDatabaseAndSchema",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/statistics",
    validator: validate_CatalogListTableStatisticsByDatabaseAndSchema_568464,
    base: "", url: url_CatalogListTableStatisticsByDatabaseAndSchema_568465,
    schemes: {Scheme.Https})
type
  Call_CatalogListTables_568479 = ref object of OpenApiRestCall_567666
proc url_CatalogListTables_568481(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListTables_568480(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves the list of tables from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the tables.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the tables.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `schemaName` field"
  var valid_568482 = path.getOrDefault("schemaName")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "schemaName", valid_568482
  var valid_568483 = path.getOrDefault("databaseName")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "databaseName", valid_568483
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   basic: JBool
  ##        : The basic switch indicates what level of information to return when listing tables. When basic is true, only database_name, schema_name, table_name and version are returned for each table, otherwise all table metadata is returned. By default, it is false. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568484 = query.getOrDefault("$orderby")
  valid_568484 = validateParameter(valid_568484, JString, required = false,
                                 default = nil)
  if valid_568484 != nil:
    section.add "$orderby", valid_568484
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568485 = query.getOrDefault("api-version")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "api-version", valid_568485
  var valid_568486 = query.getOrDefault("$top")
  valid_568486 = validateParameter(valid_568486, JInt, required = false, default = nil)
  if valid_568486 != nil:
    section.add "$top", valid_568486
  var valid_568487 = query.getOrDefault("$select")
  valid_568487 = validateParameter(valid_568487, JString, required = false,
                                 default = nil)
  if valid_568487 != nil:
    section.add "$select", valid_568487
  var valid_568488 = query.getOrDefault("$skip")
  valid_568488 = validateParameter(valid_568488, JInt, required = false, default = nil)
  if valid_568488 != nil:
    section.add "$skip", valid_568488
  var valid_568489 = query.getOrDefault("$count")
  valid_568489 = validateParameter(valid_568489, JBool, required = false, default = nil)
  if valid_568489 != nil:
    section.add "$count", valid_568489
  var valid_568490 = query.getOrDefault("basic")
  valid_568490 = validateParameter(valid_568490, JBool, required = false,
                                 default = newJBool(false))
  if valid_568490 != nil:
    section.add "basic", valid_568490
  var valid_568491 = query.getOrDefault("$filter")
  valid_568491 = validateParameter(valid_568491, JString, required = false,
                                 default = nil)
  if valid_568491 != nil:
    section.add "$filter", valid_568491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568492: Call_CatalogListTables_568479; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of tables from the Data Lake Analytics catalog.
  ## 
  let valid = call_568492.validator(path, query, header, formData, body)
  let scheme = call_568492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568492.url(scheme.get, call_568492.host, call_568492.base,
                         call_568492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568492, url, valid)

proc call*(call_568493: Call_CatalogListTables_568479; apiVersion: string;
          schemaName: string; databaseName: string; Orderby: string = ""; Top: int = 0;
          Select: string = ""; Skip: int = 0; Count: bool = false; basic: bool = false;
          Filter: string = ""): Recallable =
  ## catalogListTables
  ## Retrieves the list of tables from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the tables.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the tables.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   basic: bool
  ##        : The basic switch indicates what level of information to return when listing tables. When basic is true, only database_name, schema_name, table_name and version are returned for each table, otherwise all table metadata is returned. By default, it is false. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568494 = newJObject()
  var query_568495 = newJObject()
  add(query_568495, "$orderby", newJString(Orderby))
  add(query_568495, "api-version", newJString(apiVersion))
  add(query_568495, "$top", newJInt(Top))
  add(path_568494, "schemaName", newJString(schemaName))
  add(query_568495, "$select", newJString(Select))
  add(path_568494, "databaseName", newJString(databaseName))
  add(query_568495, "$skip", newJInt(Skip))
  add(query_568495, "$count", newJBool(Count))
  add(query_568495, "basic", newJBool(basic))
  add(query_568495, "$filter", newJString(Filter))
  result = call_568493.call(path_568494, query_568495, nil, nil, nil)

var catalogListTables* = Call_CatalogListTables_568479(name: "catalogListTables",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables",
    validator: validate_CatalogListTables_568480, base: "",
    url: url_CatalogListTables_568481, schemes: {Scheme.Https})
type
  Call_CatalogGetTable_568496 = ref object of OpenApiRestCall_567666
proc url_CatalogGetTable_568498(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetTable_568497(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Retrieves the specified table from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the table.
  ##   tableName: JString (required)
  ##            : The name of the table.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the table.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `schemaName` field"
  var valid_568499 = path.getOrDefault("schemaName")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = nil)
  if valid_568499 != nil:
    section.add "schemaName", valid_568499
  var valid_568500 = path.getOrDefault("tableName")
  valid_568500 = validateParameter(valid_568500, JString, required = true,
                                 default = nil)
  if valid_568500 != nil:
    section.add "tableName", valid_568500
  var valid_568501 = path.getOrDefault("databaseName")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "databaseName", valid_568501
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568502 = query.getOrDefault("api-version")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "api-version", valid_568502
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568503: Call_CatalogGetTable_568496; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table from the Data Lake Analytics catalog.
  ## 
  let valid = call_568503.validator(path, query, header, formData, body)
  let scheme = call_568503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568503.url(scheme.get, call_568503.host, call_568503.base,
                         call_568503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568503, url, valid)

proc call*(call_568504: Call_CatalogGetTable_568496; apiVersion: string;
          schemaName: string; tableName: string; databaseName: string): Recallable =
  ## catalogGetTable
  ## Retrieves the specified table from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the table.
  ##   tableName: string (required)
  ##            : The name of the table.
  ##   databaseName: string (required)
  ##               : The name of the database containing the table.
  var path_568505 = newJObject()
  var query_568506 = newJObject()
  add(query_568506, "api-version", newJString(apiVersion))
  add(path_568505, "schemaName", newJString(schemaName))
  add(path_568505, "tableName", newJString(tableName))
  add(path_568505, "databaseName", newJString(databaseName))
  result = call_568504.call(path_568505, query_568506, nil, nil, nil)

var catalogGetTable* = Call_CatalogGetTable_568496(name: "catalogGetTable",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}",
    validator: validate_CatalogGetTable_568497, base: "", url: url_CatalogGetTable_568498,
    schemes: {Scheme.Https})
type
  Call_CatalogListTablePartitions_568507 = ref object of OpenApiRestCall_567666
proc url_CatalogListTablePartitions_568509(protocol: Scheme; host: string;
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

proc validate_CatalogListTablePartitions_568508(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of table partitions from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the partitions.
  ##   tableName: JString (required)
  ##            : The name of the table containing the partitions.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the partitions.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `schemaName` field"
  var valid_568510 = path.getOrDefault("schemaName")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "schemaName", valid_568510
  var valid_568511 = path.getOrDefault("tableName")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = nil)
  if valid_568511 != nil:
    section.add "tableName", valid_568511
  var valid_568512 = path.getOrDefault("databaseName")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "databaseName", valid_568512
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568513 = query.getOrDefault("$orderby")
  valid_568513 = validateParameter(valid_568513, JString, required = false,
                                 default = nil)
  if valid_568513 != nil:
    section.add "$orderby", valid_568513
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568514 = query.getOrDefault("api-version")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "api-version", valid_568514
  var valid_568515 = query.getOrDefault("$top")
  valid_568515 = validateParameter(valid_568515, JInt, required = false, default = nil)
  if valid_568515 != nil:
    section.add "$top", valid_568515
  var valid_568516 = query.getOrDefault("$select")
  valid_568516 = validateParameter(valid_568516, JString, required = false,
                                 default = nil)
  if valid_568516 != nil:
    section.add "$select", valid_568516
  var valid_568517 = query.getOrDefault("$skip")
  valid_568517 = validateParameter(valid_568517, JInt, required = false, default = nil)
  if valid_568517 != nil:
    section.add "$skip", valid_568517
  var valid_568518 = query.getOrDefault("$count")
  valid_568518 = validateParameter(valid_568518, JBool, required = false, default = nil)
  if valid_568518 != nil:
    section.add "$count", valid_568518
  var valid_568519 = query.getOrDefault("$filter")
  valid_568519 = validateParameter(valid_568519, JString, required = false,
                                 default = nil)
  if valid_568519 != nil:
    section.add "$filter", valid_568519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568520: Call_CatalogListTablePartitions_568507; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table partitions from the Data Lake Analytics catalog.
  ## 
  let valid = call_568520.validator(path, query, header, formData, body)
  let scheme = call_568520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568520.url(scheme.get, call_568520.host, call_568520.base,
                         call_568520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568520, url, valid)

proc call*(call_568521: Call_CatalogListTablePartitions_568507; apiVersion: string;
          schemaName: string; tableName: string; databaseName: string;
          Orderby: string = ""; Top: int = 0; Select: string = ""; Skip: int = 0;
          Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListTablePartitions
  ## Retrieves the list of table partitions from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the partitions.
  ##   tableName: string (required)
  ##            : The name of the table containing the partitions.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the partitions.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568522 = newJObject()
  var query_568523 = newJObject()
  add(query_568523, "$orderby", newJString(Orderby))
  add(query_568523, "api-version", newJString(apiVersion))
  add(query_568523, "$top", newJInt(Top))
  add(path_568522, "schemaName", newJString(schemaName))
  add(path_568522, "tableName", newJString(tableName))
  add(query_568523, "$select", newJString(Select))
  add(path_568522, "databaseName", newJString(databaseName))
  add(query_568523, "$skip", newJInt(Skip))
  add(query_568523, "$count", newJBool(Count))
  add(query_568523, "$filter", newJString(Filter))
  result = call_568521.call(path_568522, query_568523, nil, nil, nil)

var catalogListTablePartitions* = Call_CatalogListTablePartitions_568507(
    name: "catalogListTablePartitions", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/partitions",
    validator: validate_CatalogListTablePartitions_568508, base: "",
    url: url_CatalogListTablePartitions_568509, schemes: {Scheme.Https})
type
  Call_CatalogGetTablePartition_568524 = ref object of OpenApiRestCall_567666
proc url_CatalogGetTablePartition_568526(protocol: Scheme; host: string;
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

proc validate_CatalogGetTablePartition_568525(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the specified table partition from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the partition.
  ##   tableName: JString (required)
  ##            : The name of the table containing the partition.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the partition.
  ##   partitionName: JString (required)
  ##                : The name of the table partition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `schemaName` field"
  var valid_568527 = path.getOrDefault("schemaName")
  valid_568527 = validateParameter(valid_568527, JString, required = true,
                                 default = nil)
  if valid_568527 != nil:
    section.add "schemaName", valid_568527
  var valid_568528 = path.getOrDefault("tableName")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "tableName", valid_568528
  var valid_568529 = path.getOrDefault("databaseName")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "databaseName", valid_568529
  var valid_568530 = path.getOrDefault("partitionName")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "partitionName", valid_568530
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568531 = query.getOrDefault("api-version")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "api-version", valid_568531
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568532: Call_CatalogGetTablePartition_568524; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table partition from the Data Lake Analytics catalog.
  ## 
  let valid = call_568532.validator(path, query, header, formData, body)
  let scheme = call_568532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568532.url(scheme.get, call_568532.host, call_568532.base,
                         call_568532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568532, url, valid)

proc call*(call_568533: Call_CatalogGetTablePartition_568524; apiVersion: string;
          schemaName: string; tableName: string; databaseName: string;
          partitionName: string): Recallable =
  ## catalogGetTablePartition
  ## Retrieves the specified table partition from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the partition.
  ##   tableName: string (required)
  ##            : The name of the table containing the partition.
  ##   databaseName: string (required)
  ##               : The name of the database containing the partition.
  ##   partitionName: string (required)
  ##                : The name of the table partition.
  var path_568534 = newJObject()
  var query_568535 = newJObject()
  add(query_568535, "api-version", newJString(apiVersion))
  add(path_568534, "schemaName", newJString(schemaName))
  add(path_568534, "tableName", newJString(tableName))
  add(path_568534, "databaseName", newJString(databaseName))
  add(path_568534, "partitionName", newJString(partitionName))
  result = call_568533.call(path_568534, query_568535, nil, nil, nil)

var catalogGetTablePartition* = Call_CatalogGetTablePartition_568524(
    name: "catalogGetTablePartition", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/partitions/{partitionName}",
    validator: validate_CatalogGetTablePartition_568525, base: "",
    url: url_CatalogGetTablePartition_568526, schemes: {Scheme.Https})
type
  Call_CatalogPreviewTablePartition_568536 = ref object of OpenApiRestCall_567666
proc url_CatalogPreviewTablePartition_568538(protocol: Scheme; host: string;
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

proc validate_CatalogPreviewTablePartition_568537(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a preview set of rows in given partition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the partition.
  ##   tableName: JString (required)
  ##            : The name of the table containing the partition.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the partition.
  ##   partitionName: JString (required)
  ##                : The name of the table partition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `schemaName` field"
  var valid_568539 = path.getOrDefault("schemaName")
  valid_568539 = validateParameter(valid_568539, JString, required = true,
                                 default = nil)
  if valid_568539 != nil:
    section.add "schemaName", valid_568539
  var valid_568540 = path.getOrDefault("tableName")
  valid_568540 = validateParameter(valid_568540, JString, required = true,
                                 default = nil)
  if valid_568540 != nil:
    section.add "tableName", valid_568540
  var valid_568541 = path.getOrDefault("databaseName")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = nil)
  if valid_568541 != nil:
    section.add "databaseName", valid_568541
  var valid_568542 = path.getOrDefault("partitionName")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "partitionName", valid_568542
  result.add "path", section
  ## parameters in `query` object:
  ##   maxRows: JInt
  ##          : The maximum number of preview rows to be retrieved.Rows returned may be less than or equal to this number depending on row sizes and number of rows in the partition.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   maxColumns: JInt
  ##             : The maximum number of columns to be retrieved.
  section = newJObject()
  var valid_568543 = query.getOrDefault("maxRows")
  valid_568543 = validateParameter(valid_568543, JInt, required = false, default = nil)
  if valid_568543 != nil:
    section.add "maxRows", valid_568543
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568544 = query.getOrDefault("api-version")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "api-version", valid_568544
  var valid_568545 = query.getOrDefault("maxColumns")
  valid_568545 = validateParameter(valid_568545, JInt, required = false, default = nil)
  if valid_568545 != nil:
    section.add "maxColumns", valid_568545
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568546: Call_CatalogPreviewTablePartition_568536; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a preview set of rows in given partition.
  ## 
  let valid = call_568546.validator(path, query, header, formData, body)
  let scheme = call_568546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568546.url(scheme.get, call_568546.host, call_568546.base,
                         call_568546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568546, url, valid)

proc call*(call_568547: Call_CatalogPreviewTablePartition_568536;
          apiVersion: string; schemaName: string; tableName: string;
          databaseName: string; partitionName: string; maxRows: int = 0;
          maxColumns: int = 0): Recallable =
  ## catalogPreviewTablePartition
  ## Retrieves a preview set of rows in given partition.
  ##   maxRows: int
  ##          : The maximum number of preview rows to be retrieved.Rows returned may be less than or equal to this number depending on row sizes and number of rows in the partition.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the partition.
  ##   tableName: string (required)
  ##            : The name of the table containing the partition.
  ##   databaseName: string (required)
  ##               : The name of the database containing the partition.
  ##   maxColumns: int
  ##             : The maximum number of columns to be retrieved.
  ##   partitionName: string (required)
  ##                : The name of the table partition.
  var path_568548 = newJObject()
  var query_568549 = newJObject()
  add(query_568549, "maxRows", newJInt(maxRows))
  add(query_568549, "api-version", newJString(apiVersion))
  add(path_568548, "schemaName", newJString(schemaName))
  add(path_568548, "tableName", newJString(tableName))
  add(path_568548, "databaseName", newJString(databaseName))
  add(query_568549, "maxColumns", newJInt(maxColumns))
  add(path_568548, "partitionName", newJString(partitionName))
  result = call_568547.call(path_568548, query_568549, nil, nil, nil)

var catalogPreviewTablePartition* = Call_CatalogPreviewTablePartition_568536(
    name: "catalogPreviewTablePartition", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/partitions/{partitionName}/previewrows",
    validator: validate_CatalogPreviewTablePartition_568537, base: "",
    url: url_CatalogPreviewTablePartition_568538, schemes: {Scheme.Https})
type
  Call_CatalogPreviewTable_568550 = ref object of OpenApiRestCall_567666
proc url_CatalogPreviewTable_568552(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogPreviewTable_568551(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves a preview set of rows in given table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the table.
  ##   tableName: JString (required)
  ##            : The name of the table.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the table.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `schemaName` field"
  var valid_568553 = path.getOrDefault("schemaName")
  valid_568553 = validateParameter(valid_568553, JString, required = true,
                                 default = nil)
  if valid_568553 != nil:
    section.add "schemaName", valid_568553
  var valid_568554 = path.getOrDefault("tableName")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = nil)
  if valid_568554 != nil:
    section.add "tableName", valid_568554
  var valid_568555 = path.getOrDefault("databaseName")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = nil)
  if valid_568555 != nil:
    section.add "databaseName", valid_568555
  result.add "path", section
  ## parameters in `query` object:
  ##   maxRows: JInt
  ##          : The maximum number of preview rows to be retrieved. Rows returned may be less than or equal to this number depending on row sizes and number of rows in the table.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   maxColumns: JInt
  ##             : The maximum number of columns to be retrieved.
  section = newJObject()
  var valid_568556 = query.getOrDefault("maxRows")
  valid_568556 = validateParameter(valid_568556, JInt, required = false, default = nil)
  if valid_568556 != nil:
    section.add "maxRows", valid_568556
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568557 = query.getOrDefault("api-version")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "api-version", valid_568557
  var valid_568558 = query.getOrDefault("maxColumns")
  valid_568558 = validateParameter(valid_568558, JInt, required = false, default = nil)
  if valid_568558 != nil:
    section.add "maxColumns", valid_568558
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568559: Call_CatalogPreviewTable_568550; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a preview set of rows in given table.
  ## 
  let valid = call_568559.validator(path, query, header, formData, body)
  let scheme = call_568559.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568559.url(scheme.get, call_568559.host, call_568559.base,
                         call_568559.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568559, url, valid)

proc call*(call_568560: Call_CatalogPreviewTable_568550; apiVersion: string;
          schemaName: string; tableName: string; databaseName: string;
          maxRows: int = 0; maxColumns: int = 0): Recallable =
  ## catalogPreviewTable
  ## Retrieves a preview set of rows in given table.
  ##   maxRows: int
  ##          : The maximum number of preview rows to be retrieved. Rows returned may be less than or equal to this number depending on row sizes and number of rows in the table.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the table.
  ##   tableName: string (required)
  ##            : The name of the table.
  ##   databaseName: string (required)
  ##               : The name of the database containing the table.
  ##   maxColumns: int
  ##             : The maximum number of columns to be retrieved.
  var path_568561 = newJObject()
  var query_568562 = newJObject()
  add(query_568562, "maxRows", newJInt(maxRows))
  add(query_568562, "api-version", newJString(apiVersion))
  add(path_568561, "schemaName", newJString(schemaName))
  add(path_568561, "tableName", newJString(tableName))
  add(path_568561, "databaseName", newJString(databaseName))
  add(query_568562, "maxColumns", newJInt(maxColumns))
  result = call_568560.call(path_568561, query_568562, nil, nil, nil)

var catalogPreviewTable* = Call_CatalogPreviewTable_568550(
    name: "catalogPreviewTable", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/previewrows",
    validator: validate_CatalogPreviewTable_568551, base: "",
    url: url_CatalogPreviewTable_568552, schemes: {Scheme.Https})
type
  Call_CatalogListTableStatistics_568563 = ref object of OpenApiRestCall_567666
proc url_CatalogListTableStatistics_568565(protocol: Scheme; host: string;
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

proc validate_CatalogListTableStatistics_568564(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of table statistics from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the statistics.
  ##   tableName: JString (required)
  ##            : The name of the table containing the statistics.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the statistics.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `schemaName` field"
  var valid_568566 = path.getOrDefault("schemaName")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "schemaName", valid_568566
  var valid_568567 = path.getOrDefault("tableName")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "tableName", valid_568567
  var valid_568568 = path.getOrDefault("databaseName")
  valid_568568 = validateParameter(valid_568568, JString, required = true,
                                 default = nil)
  if valid_568568 != nil:
    section.add "databaseName", valid_568568
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568569 = query.getOrDefault("$orderby")
  valid_568569 = validateParameter(valid_568569, JString, required = false,
                                 default = nil)
  if valid_568569 != nil:
    section.add "$orderby", valid_568569
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568570 = query.getOrDefault("api-version")
  valid_568570 = validateParameter(valid_568570, JString, required = true,
                                 default = nil)
  if valid_568570 != nil:
    section.add "api-version", valid_568570
  var valid_568571 = query.getOrDefault("$top")
  valid_568571 = validateParameter(valid_568571, JInt, required = false, default = nil)
  if valid_568571 != nil:
    section.add "$top", valid_568571
  var valid_568572 = query.getOrDefault("$select")
  valid_568572 = validateParameter(valid_568572, JString, required = false,
                                 default = nil)
  if valid_568572 != nil:
    section.add "$select", valid_568572
  var valid_568573 = query.getOrDefault("$skip")
  valid_568573 = validateParameter(valid_568573, JInt, required = false, default = nil)
  if valid_568573 != nil:
    section.add "$skip", valid_568573
  var valid_568574 = query.getOrDefault("$count")
  valid_568574 = validateParameter(valid_568574, JBool, required = false, default = nil)
  if valid_568574 != nil:
    section.add "$count", valid_568574
  var valid_568575 = query.getOrDefault("$filter")
  valid_568575 = validateParameter(valid_568575, JString, required = false,
                                 default = nil)
  if valid_568575 != nil:
    section.add "$filter", valid_568575
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568576: Call_CatalogListTableStatistics_568563; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table statistics from the Data Lake Analytics catalog.
  ## 
  let valid = call_568576.validator(path, query, header, formData, body)
  let scheme = call_568576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568576.url(scheme.get, call_568576.host, call_568576.base,
                         call_568576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568576, url, valid)

proc call*(call_568577: Call_CatalogListTableStatistics_568563; apiVersion: string;
          schemaName: string; tableName: string; databaseName: string;
          Orderby: string = ""; Top: int = 0; Select: string = ""; Skip: int = 0;
          Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListTableStatistics
  ## Retrieves the list of table statistics from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the statistics.
  ##   tableName: string (required)
  ##            : The name of the table containing the statistics.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the statistics.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568578 = newJObject()
  var query_568579 = newJObject()
  add(query_568579, "$orderby", newJString(Orderby))
  add(query_568579, "api-version", newJString(apiVersion))
  add(query_568579, "$top", newJInt(Top))
  add(path_568578, "schemaName", newJString(schemaName))
  add(path_568578, "tableName", newJString(tableName))
  add(query_568579, "$select", newJString(Select))
  add(path_568578, "databaseName", newJString(databaseName))
  add(query_568579, "$skip", newJInt(Skip))
  add(query_568579, "$count", newJBool(Count))
  add(query_568579, "$filter", newJString(Filter))
  result = call_568577.call(path_568578, query_568579, nil, nil, nil)

var catalogListTableStatistics* = Call_CatalogListTableStatistics_568563(
    name: "catalogListTableStatistics", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/statistics",
    validator: validate_CatalogListTableStatistics_568564, base: "",
    url: url_CatalogListTableStatistics_568565, schemes: {Scheme.Https})
type
  Call_CatalogGetTableStatistic_568580 = ref object of OpenApiRestCall_567666
proc url_CatalogGetTableStatistic_568582(protocol: Scheme; host: string;
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

proc validate_CatalogGetTableStatistic_568581(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the specified table statistics from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   statisticsName: JString (required)
  ##                 : The name of the table statistics.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the statistics.
  ##   tableName: JString (required)
  ##            : The name of the table containing the statistics.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the statistics.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `statisticsName` field"
  var valid_568583 = path.getOrDefault("statisticsName")
  valid_568583 = validateParameter(valid_568583, JString, required = true,
                                 default = nil)
  if valid_568583 != nil:
    section.add "statisticsName", valid_568583
  var valid_568584 = path.getOrDefault("schemaName")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "schemaName", valid_568584
  var valid_568585 = path.getOrDefault("tableName")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "tableName", valid_568585
  var valid_568586 = path.getOrDefault("databaseName")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "databaseName", valid_568586
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568587 = query.getOrDefault("api-version")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "api-version", valid_568587
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568588: Call_CatalogGetTableStatistic_568580; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table statistics from the Data Lake Analytics catalog.
  ## 
  let valid = call_568588.validator(path, query, header, formData, body)
  let scheme = call_568588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568588.url(scheme.get, call_568588.host, call_568588.base,
                         call_568588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568588, url, valid)

proc call*(call_568589: Call_CatalogGetTableStatistic_568580;
          statisticsName: string; apiVersion: string; schemaName: string;
          tableName: string; databaseName: string): Recallable =
  ## catalogGetTableStatistic
  ## Retrieves the specified table statistics from the Data Lake Analytics catalog.
  ##   statisticsName: string (required)
  ##                 : The name of the table statistics.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the statistics.
  ##   tableName: string (required)
  ##            : The name of the table containing the statistics.
  ##   databaseName: string (required)
  ##               : The name of the database containing the statistics.
  var path_568590 = newJObject()
  var query_568591 = newJObject()
  add(path_568590, "statisticsName", newJString(statisticsName))
  add(query_568591, "api-version", newJString(apiVersion))
  add(path_568590, "schemaName", newJString(schemaName))
  add(path_568590, "tableName", newJString(tableName))
  add(path_568590, "databaseName", newJString(databaseName))
  result = call_568589.call(path_568590, query_568591, nil, nil, nil)

var catalogGetTableStatistic* = Call_CatalogGetTableStatistic_568580(
    name: "catalogGetTableStatistic", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/statistics/{statisticsName}",
    validator: validate_CatalogGetTableStatistic_568581, base: "",
    url: url_CatalogGetTableStatistic_568582, schemes: {Scheme.Https})
type
  Call_CatalogListTableFragments_568592 = ref object of OpenApiRestCall_567666
proc url_CatalogListTableFragments_568594(protocol: Scheme; host: string;
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

proc validate_CatalogListTableFragments_568593(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of table fragments from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the table fragments.
  ##   tableName: JString (required)
  ##            : The name of the table containing the table fragments.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the table fragments.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `schemaName` field"
  var valid_568595 = path.getOrDefault("schemaName")
  valid_568595 = validateParameter(valid_568595, JString, required = true,
                                 default = nil)
  if valid_568595 != nil:
    section.add "schemaName", valid_568595
  var valid_568596 = path.getOrDefault("tableName")
  valid_568596 = validateParameter(valid_568596, JString, required = true,
                                 default = nil)
  if valid_568596 != nil:
    section.add "tableName", valid_568596
  var valid_568597 = path.getOrDefault("databaseName")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "databaseName", valid_568597
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568598 = query.getOrDefault("$orderby")
  valid_568598 = validateParameter(valid_568598, JString, required = false,
                                 default = nil)
  if valid_568598 != nil:
    section.add "$orderby", valid_568598
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568599 = query.getOrDefault("api-version")
  valid_568599 = validateParameter(valid_568599, JString, required = true,
                                 default = nil)
  if valid_568599 != nil:
    section.add "api-version", valid_568599
  var valid_568600 = query.getOrDefault("$top")
  valid_568600 = validateParameter(valid_568600, JInt, required = false, default = nil)
  if valid_568600 != nil:
    section.add "$top", valid_568600
  var valid_568601 = query.getOrDefault("$select")
  valid_568601 = validateParameter(valid_568601, JString, required = false,
                                 default = nil)
  if valid_568601 != nil:
    section.add "$select", valid_568601
  var valid_568602 = query.getOrDefault("$skip")
  valid_568602 = validateParameter(valid_568602, JInt, required = false, default = nil)
  if valid_568602 != nil:
    section.add "$skip", valid_568602
  var valid_568603 = query.getOrDefault("$count")
  valid_568603 = validateParameter(valid_568603, JBool, required = false, default = nil)
  if valid_568603 != nil:
    section.add "$count", valid_568603
  var valid_568604 = query.getOrDefault("$filter")
  valid_568604 = validateParameter(valid_568604, JString, required = false,
                                 default = nil)
  if valid_568604 != nil:
    section.add "$filter", valid_568604
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568605: Call_CatalogListTableFragments_568592; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table fragments from the Data Lake Analytics catalog.
  ## 
  let valid = call_568605.validator(path, query, header, formData, body)
  let scheme = call_568605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568605.url(scheme.get, call_568605.host, call_568605.base,
                         call_568605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568605, url, valid)

proc call*(call_568606: Call_CatalogListTableFragments_568592; apiVersion: string;
          schemaName: string; tableName: string; databaseName: string;
          Orderby: string = ""; Top: int = 0; Select: string = ""; Skip: int = 0;
          Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListTableFragments
  ## Retrieves the list of table fragments from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the table fragments.
  ##   tableName: string (required)
  ##            : The name of the table containing the table fragments.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the table fragments.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568607 = newJObject()
  var query_568608 = newJObject()
  add(query_568608, "$orderby", newJString(Orderby))
  add(query_568608, "api-version", newJString(apiVersion))
  add(query_568608, "$top", newJInt(Top))
  add(path_568607, "schemaName", newJString(schemaName))
  add(path_568607, "tableName", newJString(tableName))
  add(query_568608, "$select", newJString(Select))
  add(path_568607, "databaseName", newJString(databaseName))
  add(query_568608, "$skip", newJInt(Skip))
  add(query_568608, "$count", newJBool(Count))
  add(query_568608, "$filter", newJString(Filter))
  result = call_568606.call(path_568607, query_568608, nil, nil, nil)

var catalogListTableFragments* = Call_CatalogListTableFragments_568592(
    name: "catalogListTableFragments", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/tablefragments",
    validator: validate_CatalogListTableFragments_568593, base: "",
    url: url_CatalogListTableFragments_568594, schemes: {Scheme.Https})
type
  Call_CatalogListTableTypes_568609 = ref object of OpenApiRestCall_567666
proc url_CatalogListTableTypes_568611(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListTableTypes_568610(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of table types from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the table types.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the table types.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `schemaName` field"
  var valid_568612 = path.getOrDefault("schemaName")
  valid_568612 = validateParameter(valid_568612, JString, required = true,
                                 default = nil)
  if valid_568612 != nil:
    section.add "schemaName", valid_568612
  var valid_568613 = path.getOrDefault("databaseName")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "databaseName", valid_568613
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568614 = query.getOrDefault("$orderby")
  valid_568614 = validateParameter(valid_568614, JString, required = false,
                                 default = nil)
  if valid_568614 != nil:
    section.add "$orderby", valid_568614
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568615 = query.getOrDefault("api-version")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "api-version", valid_568615
  var valid_568616 = query.getOrDefault("$top")
  valid_568616 = validateParameter(valid_568616, JInt, required = false, default = nil)
  if valid_568616 != nil:
    section.add "$top", valid_568616
  var valid_568617 = query.getOrDefault("$select")
  valid_568617 = validateParameter(valid_568617, JString, required = false,
                                 default = nil)
  if valid_568617 != nil:
    section.add "$select", valid_568617
  var valid_568618 = query.getOrDefault("$skip")
  valid_568618 = validateParameter(valid_568618, JInt, required = false, default = nil)
  if valid_568618 != nil:
    section.add "$skip", valid_568618
  var valid_568619 = query.getOrDefault("$count")
  valid_568619 = validateParameter(valid_568619, JBool, required = false, default = nil)
  if valid_568619 != nil:
    section.add "$count", valid_568619
  var valid_568620 = query.getOrDefault("$filter")
  valid_568620 = validateParameter(valid_568620, JString, required = false,
                                 default = nil)
  if valid_568620 != nil:
    section.add "$filter", valid_568620
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568621: Call_CatalogListTableTypes_568609; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table types from the Data Lake Analytics catalog.
  ## 
  let valid = call_568621.validator(path, query, header, formData, body)
  let scheme = call_568621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568621.url(scheme.get, call_568621.host, call_568621.base,
                         call_568621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568621, url, valid)

proc call*(call_568622: Call_CatalogListTableTypes_568609; apiVersion: string;
          schemaName: string; databaseName: string; Orderby: string = ""; Top: int = 0;
          Select: string = ""; Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListTableTypes
  ## Retrieves the list of table types from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the table types.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the table types.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568623 = newJObject()
  var query_568624 = newJObject()
  add(query_568624, "$orderby", newJString(Orderby))
  add(query_568624, "api-version", newJString(apiVersion))
  add(query_568624, "$top", newJInt(Top))
  add(path_568623, "schemaName", newJString(schemaName))
  add(query_568624, "$select", newJString(Select))
  add(path_568623, "databaseName", newJString(databaseName))
  add(query_568624, "$skip", newJInt(Skip))
  add(query_568624, "$count", newJBool(Count))
  add(query_568624, "$filter", newJString(Filter))
  result = call_568622.call(path_568623, query_568624, nil, nil, nil)

var catalogListTableTypes* = Call_CatalogListTableTypes_568609(
    name: "catalogListTableTypes", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tabletypes",
    validator: validate_CatalogListTableTypes_568610, base: "",
    url: url_CatalogListTableTypes_568611, schemes: {Scheme.Https})
type
  Call_CatalogGetTableType_568625 = ref object of OpenApiRestCall_567666
proc url_CatalogGetTableType_568627(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetTableType_568626(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves the specified table type from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the table type.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the table type.
  ##   tableTypeName: JString (required)
  ##                : The name of the table type to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `schemaName` field"
  var valid_568628 = path.getOrDefault("schemaName")
  valid_568628 = validateParameter(valid_568628, JString, required = true,
                                 default = nil)
  if valid_568628 != nil:
    section.add "schemaName", valid_568628
  var valid_568629 = path.getOrDefault("databaseName")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = nil)
  if valid_568629 != nil:
    section.add "databaseName", valid_568629
  var valid_568630 = path.getOrDefault("tableTypeName")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "tableTypeName", valid_568630
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568631 = query.getOrDefault("api-version")
  valid_568631 = validateParameter(valid_568631, JString, required = true,
                                 default = nil)
  if valid_568631 != nil:
    section.add "api-version", valid_568631
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568632: Call_CatalogGetTableType_568625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table type from the Data Lake Analytics catalog.
  ## 
  let valid = call_568632.validator(path, query, header, formData, body)
  let scheme = call_568632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568632.url(scheme.get, call_568632.host, call_568632.base,
                         call_568632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568632, url, valid)

proc call*(call_568633: Call_CatalogGetTableType_568625; apiVersion: string;
          schemaName: string; databaseName: string; tableTypeName: string): Recallable =
  ## catalogGetTableType
  ## Retrieves the specified table type from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the table type.
  ##   databaseName: string (required)
  ##               : The name of the database containing the table type.
  ##   tableTypeName: string (required)
  ##                : The name of the table type to retrieve.
  var path_568634 = newJObject()
  var query_568635 = newJObject()
  add(query_568635, "api-version", newJString(apiVersion))
  add(path_568634, "schemaName", newJString(schemaName))
  add(path_568634, "databaseName", newJString(databaseName))
  add(path_568634, "tableTypeName", newJString(tableTypeName))
  result = call_568633.call(path_568634, query_568635, nil, nil, nil)

var catalogGetTableType* = Call_CatalogGetTableType_568625(
    name: "catalogGetTableType", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tabletypes/{tableTypeName}",
    validator: validate_CatalogGetTableType_568626, base: "",
    url: url_CatalogGetTableType_568627, schemes: {Scheme.Https})
type
  Call_CatalogListTableValuedFunctions_568636 = ref object of OpenApiRestCall_567666
proc url_CatalogListTableValuedFunctions_568638(protocol: Scheme; host: string;
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

proc validate_CatalogListTableValuedFunctions_568637(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of table valued functions from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the table valued functions.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the table valued functions.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `schemaName` field"
  var valid_568639 = path.getOrDefault("schemaName")
  valid_568639 = validateParameter(valid_568639, JString, required = true,
                                 default = nil)
  if valid_568639 != nil:
    section.add "schemaName", valid_568639
  var valid_568640 = path.getOrDefault("databaseName")
  valid_568640 = validateParameter(valid_568640, JString, required = true,
                                 default = nil)
  if valid_568640 != nil:
    section.add "databaseName", valid_568640
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568641 = query.getOrDefault("$orderby")
  valid_568641 = validateParameter(valid_568641, JString, required = false,
                                 default = nil)
  if valid_568641 != nil:
    section.add "$orderby", valid_568641
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568642 = query.getOrDefault("api-version")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "api-version", valid_568642
  var valid_568643 = query.getOrDefault("$top")
  valid_568643 = validateParameter(valid_568643, JInt, required = false, default = nil)
  if valid_568643 != nil:
    section.add "$top", valid_568643
  var valid_568644 = query.getOrDefault("$select")
  valid_568644 = validateParameter(valid_568644, JString, required = false,
                                 default = nil)
  if valid_568644 != nil:
    section.add "$select", valid_568644
  var valid_568645 = query.getOrDefault("$skip")
  valid_568645 = validateParameter(valid_568645, JInt, required = false, default = nil)
  if valid_568645 != nil:
    section.add "$skip", valid_568645
  var valid_568646 = query.getOrDefault("$count")
  valid_568646 = validateParameter(valid_568646, JBool, required = false, default = nil)
  if valid_568646 != nil:
    section.add "$count", valid_568646
  var valid_568647 = query.getOrDefault("$filter")
  valid_568647 = validateParameter(valid_568647, JString, required = false,
                                 default = nil)
  if valid_568647 != nil:
    section.add "$filter", valid_568647
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568648: Call_CatalogListTableValuedFunctions_568636;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of table valued functions from the Data Lake Analytics catalog.
  ## 
  let valid = call_568648.validator(path, query, header, formData, body)
  let scheme = call_568648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568648.url(scheme.get, call_568648.host, call_568648.base,
                         call_568648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568648, url, valid)

proc call*(call_568649: Call_CatalogListTableValuedFunctions_568636;
          apiVersion: string; schemaName: string; databaseName: string;
          Orderby: string = ""; Top: int = 0; Select: string = ""; Skip: int = 0;
          Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListTableValuedFunctions
  ## Retrieves the list of table valued functions from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the table valued functions.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the table valued functions.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568650 = newJObject()
  var query_568651 = newJObject()
  add(query_568651, "$orderby", newJString(Orderby))
  add(query_568651, "api-version", newJString(apiVersion))
  add(query_568651, "$top", newJInt(Top))
  add(path_568650, "schemaName", newJString(schemaName))
  add(query_568651, "$select", newJString(Select))
  add(path_568650, "databaseName", newJString(databaseName))
  add(query_568651, "$skip", newJInt(Skip))
  add(query_568651, "$count", newJBool(Count))
  add(query_568651, "$filter", newJString(Filter))
  result = call_568649.call(path_568650, query_568651, nil, nil, nil)

var catalogListTableValuedFunctions* = Call_CatalogListTableValuedFunctions_568636(
    name: "catalogListTableValuedFunctions", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tablevaluedfunctions",
    validator: validate_CatalogListTableValuedFunctions_568637, base: "",
    url: url_CatalogListTableValuedFunctions_568638, schemes: {Scheme.Https})
type
  Call_CatalogGetTableValuedFunction_568652 = ref object of OpenApiRestCall_567666
proc url_CatalogGetTableValuedFunction_568654(protocol: Scheme; host: string;
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

proc validate_CatalogGetTableValuedFunction_568653(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the specified table valued function from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableValuedFunctionName: JString (required)
  ##                          : The name of the tableValuedFunction.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the table valued function.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the table valued function.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableValuedFunctionName` field"
  var valid_568655 = path.getOrDefault("tableValuedFunctionName")
  valid_568655 = validateParameter(valid_568655, JString, required = true,
                                 default = nil)
  if valid_568655 != nil:
    section.add "tableValuedFunctionName", valid_568655
  var valid_568656 = path.getOrDefault("schemaName")
  valid_568656 = validateParameter(valid_568656, JString, required = true,
                                 default = nil)
  if valid_568656 != nil:
    section.add "schemaName", valid_568656
  var valid_568657 = path.getOrDefault("databaseName")
  valid_568657 = validateParameter(valid_568657, JString, required = true,
                                 default = nil)
  if valid_568657 != nil:
    section.add "databaseName", valid_568657
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568658 = query.getOrDefault("api-version")
  valid_568658 = validateParameter(valid_568658, JString, required = true,
                                 default = nil)
  if valid_568658 != nil:
    section.add "api-version", valid_568658
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568659: Call_CatalogGetTableValuedFunction_568652; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table valued function from the Data Lake Analytics catalog.
  ## 
  let valid = call_568659.validator(path, query, header, formData, body)
  let scheme = call_568659.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568659.url(scheme.get, call_568659.host, call_568659.base,
                         call_568659.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568659, url, valid)

proc call*(call_568660: Call_CatalogGetTableValuedFunction_568652;
          apiVersion: string; tableValuedFunctionName: string; schemaName: string;
          databaseName: string): Recallable =
  ## catalogGetTableValuedFunction
  ## Retrieves the specified table valued function from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   tableValuedFunctionName: string (required)
  ##                          : The name of the tableValuedFunction.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the table valued function.
  ##   databaseName: string (required)
  ##               : The name of the database containing the table valued function.
  var path_568661 = newJObject()
  var query_568662 = newJObject()
  add(query_568662, "api-version", newJString(apiVersion))
  add(path_568661, "tableValuedFunctionName", newJString(tableValuedFunctionName))
  add(path_568661, "schemaName", newJString(schemaName))
  add(path_568661, "databaseName", newJString(databaseName))
  result = call_568660.call(path_568661, query_568662, nil, nil, nil)

var catalogGetTableValuedFunction* = Call_CatalogGetTableValuedFunction_568652(
    name: "catalogGetTableValuedFunction", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tablevaluedfunctions/{tableValuedFunctionName}",
    validator: validate_CatalogGetTableValuedFunction_568653, base: "",
    url: url_CatalogGetTableValuedFunction_568654, schemes: {Scheme.Https})
type
  Call_CatalogListTypes_568663 = ref object of OpenApiRestCall_567666
proc url_CatalogListTypes_568665(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListTypes_568664(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves the list of types within the specified database and schema from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the types.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the types.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `schemaName` field"
  var valid_568666 = path.getOrDefault("schemaName")
  valid_568666 = validateParameter(valid_568666, JString, required = true,
                                 default = nil)
  if valid_568666 != nil:
    section.add "schemaName", valid_568666
  var valid_568667 = path.getOrDefault("databaseName")
  valid_568667 = validateParameter(valid_568667, JString, required = true,
                                 default = nil)
  if valid_568667 != nil:
    section.add "databaseName", valid_568667
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568668 = query.getOrDefault("$orderby")
  valid_568668 = validateParameter(valid_568668, JString, required = false,
                                 default = nil)
  if valid_568668 != nil:
    section.add "$orderby", valid_568668
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568669 = query.getOrDefault("api-version")
  valid_568669 = validateParameter(valid_568669, JString, required = true,
                                 default = nil)
  if valid_568669 != nil:
    section.add "api-version", valid_568669
  var valid_568670 = query.getOrDefault("$top")
  valid_568670 = validateParameter(valid_568670, JInt, required = false, default = nil)
  if valid_568670 != nil:
    section.add "$top", valid_568670
  var valid_568671 = query.getOrDefault("$select")
  valid_568671 = validateParameter(valid_568671, JString, required = false,
                                 default = nil)
  if valid_568671 != nil:
    section.add "$select", valid_568671
  var valid_568672 = query.getOrDefault("$skip")
  valid_568672 = validateParameter(valid_568672, JInt, required = false, default = nil)
  if valid_568672 != nil:
    section.add "$skip", valid_568672
  var valid_568673 = query.getOrDefault("$count")
  valid_568673 = validateParameter(valid_568673, JBool, required = false, default = nil)
  if valid_568673 != nil:
    section.add "$count", valid_568673
  var valid_568674 = query.getOrDefault("$filter")
  valid_568674 = validateParameter(valid_568674, JString, required = false,
                                 default = nil)
  if valid_568674 != nil:
    section.add "$filter", valid_568674
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568675: Call_CatalogListTypes_568663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of types within the specified database and schema from the Data Lake Analytics catalog.
  ## 
  let valid = call_568675.validator(path, query, header, formData, body)
  let scheme = call_568675.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568675.url(scheme.get, call_568675.host, call_568675.base,
                         call_568675.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568675, url, valid)

proc call*(call_568676: Call_CatalogListTypes_568663; apiVersion: string;
          schemaName: string; databaseName: string; Orderby: string = ""; Top: int = 0;
          Select: string = ""; Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListTypes
  ## Retrieves the list of types within the specified database and schema from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the types.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the types.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568677 = newJObject()
  var query_568678 = newJObject()
  add(query_568678, "$orderby", newJString(Orderby))
  add(query_568678, "api-version", newJString(apiVersion))
  add(query_568678, "$top", newJInt(Top))
  add(path_568677, "schemaName", newJString(schemaName))
  add(query_568678, "$select", newJString(Select))
  add(path_568677, "databaseName", newJString(databaseName))
  add(query_568678, "$skip", newJInt(Skip))
  add(query_568678, "$count", newJBool(Count))
  add(query_568678, "$filter", newJString(Filter))
  result = call_568676.call(path_568677, query_568678, nil, nil, nil)

var catalogListTypes* = Call_CatalogListTypes_568663(name: "catalogListTypes",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/types",
    validator: validate_CatalogListTypes_568664, base: "",
    url: url_CatalogListTypes_568665, schemes: {Scheme.Https})
type
  Call_CatalogListViews_568679 = ref object of OpenApiRestCall_567666
proc url_CatalogListViews_568681(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListViews_568680(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves the list of views from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the views.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the views.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `schemaName` field"
  var valid_568682 = path.getOrDefault("schemaName")
  valid_568682 = validateParameter(valid_568682, JString, required = true,
                                 default = nil)
  if valid_568682 != nil:
    section.add "schemaName", valid_568682
  var valid_568683 = path.getOrDefault("databaseName")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = nil)
  if valid_568683 != nil:
    section.add "databaseName", valid_568683
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568684 = query.getOrDefault("$orderby")
  valid_568684 = validateParameter(valid_568684, JString, required = false,
                                 default = nil)
  if valid_568684 != nil:
    section.add "$orderby", valid_568684
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568685 = query.getOrDefault("api-version")
  valid_568685 = validateParameter(valid_568685, JString, required = true,
                                 default = nil)
  if valid_568685 != nil:
    section.add "api-version", valid_568685
  var valid_568686 = query.getOrDefault("$top")
  valid_568686 = validateParameter(valid_568686, JInt, required = false, default = nil)
  if valid_568686 != nil:
    section.add "$top", valid_568686
  var valid_568687 = query.getOrDefault("$select")
  valid_568687 = validateParameter(valid_568687, JString, required = false,
                                 default = nil)
  if valid_568687 != nil:
    section.add "$select", valid_568687
  var valid_568688 = query.getOrDefault("$skip")
  valid_568688 = validateParameter(valid_568688, JInt, required = false, default = nil)
  if valid_568688 != nil:
    section.add "$skip", valid_568688
  var valid_568689 = query.getOrDefault("$count")
  valid_568689 = validateParameter(valid_568689, JBool, required = false, default = nil)
  if valid_568689 != nil:
    section.add "$count", valid_568689
  var valid_568690 = query.getOrDefault("$filter")
  valid_568690 = validateParameter(valid_568690, JString, required = false,
                                 default = nil)
  if valid_568690 != nil:
    section.add "$filter", valid_568690
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568691: Call_CatalogListViews_568679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of views from the Data Lake Analytics catalog.
  ## 
  let valid = call_568691.validator(path, query, header, formData, body)
  let scheme = call_568691.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568691.url(scheme.get, call_568691.host, call_568691.base,
                         call_568691.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568691, url, valid)

proc call*(call_568692: Call_CatalogListViews_568679; apiVersion: string;
          schemaName: string; databaseName: string; Orderby: string = ""; Top: int = 0;
          Select: string = ""; Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListViews
  ## Retrieves the list of views from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the views.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the views.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568693 = newJObject()
  var query_568694 = newJObject()
  add(query_568694, "$orderby", newJString(Orderby))
  add(query_568694, "api-version", newJString(apiVersion))
  add(query_568694, "$top", newJInt(Top))
  add(path_568693, "schemaName", newJString(schemaName))
  add(query_568694, "$select", newJString(Select))
  add(path_568693, "databaseName", newJString(databaseName))
  add(query_568694, "$skip", newJInt(Skip))
  add(query_568694, "$count", newJBool(Count))
  add(query_568694, "$filter", newJString(Filter))
  result = call_568692.call(path_568693, query_568694, nil, nil, nil)

var catalogListViews* = Call_CatalogListViews_568679(name: "catalogListViews",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/views",
    validator: validate_CatalogListViews_568680, base: "",
    url: url_CatalogListViews_568681, schemes: {Scheme.Https})
type
  Call_CatalogGetView_568695 = ref object of OpenApiRestCall_567666
proc url_CatalogGetView_568697(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetView_568696(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieves the specified view from the Data Lake Analytics catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   viewName: JString (required)
  ##           : The name of the view.
  ##   schemaName: JString (required)
  ##             : The name of the schema containing the view.
  ##   databaseName: JString (required)
  ##               : The name of the database containing the view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `viewName` field"
  var valid_568698 = path.getOrDefault("viewName")
  valid_568698 = validateParameter(valid_568698, JString, required = true,
                                 default = nil)
  if valid_568698 != nil:
    section.add "viewName", valid_568698
  var valid_568699 = path.getOrDefault("schemaName")
  valid_568699 = validateParameter(valid_568699, JString, required = true,
                                 default = nil)
  if valid_568699 != nil:
    section.add "schemaName", valid_568699
  var valid_568700 = path.getOrDefault("databaseName")
  valid_568700 = validateParameter(valid_568700, JString, required = true,
                                 default = nil)
  if valid_568700 != nil:
    section.add "databaseName", valid_568700
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568701 = query.getOrDefault("api-version")
  valid_568701 = validateParameter(valid_568701, JString, required = true,
                                 default = nil)
  if valid_568701 != nil:
    section.add "api-version", valid_568701
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568702: Call_CatalogGetView_568695; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified view from the Data Lake Analytics catalog.
  ## 
  let valid = call_568702.validator(path, query, header, formData, body)
  let scheme = call_568702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568702.url(scheme.get, call_568702.host, call_568702.base,
                         call_568702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568702, url, valid)

proc call*(call_568703: Call_CatalogGetView_568695; apiVersion: string;
          viewName: string; schemaName: string; databaseName: string): Recallable =
  ## catalogGetView
  ## Retrieves the specified view from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   viewName: string (required)
  ##           : The name of the view.
  ##   schemaName: string (required)
  ##             : The name of the schema containing the view.
  ##   databaseName: string (required)
  ##               : The name of the database containing the view.
  var path_568704 = newJObject()
  var query_568705 = newJObject()
  add(query_568705, "api-version", newJString(apiVersion))
  add(path_568704, "viewName", newJString(viewName))
  add(path_568704, "schemaName", newJString(schemaName))
  add(path_568704, "databaseName", newJString(databaseName))
  result = call_568703.call(path_568704, query_568705, nil, nil, nil)

var catalogGetView* = Call_CatalogGetView_568695(name: "catalogGetView",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/views/{viewName}",
    validator: validate_CatalogGetView_568696, base: "", url: url_CatalogGetView_568697,
    schemes: {Scheme.Https})
type
  Call_CatalogDeleteAllSecrets_568706 = ref object of OpenApiRestCall_567666
proc url_CatalogDeleteAllSecrets_568708(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogDeleteAllSecrets_568707(path: JsonNode; query: JsonNode;
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
  var valid_568709 = path.getOrDefault("databaseName")
  valid_568709 = validateParameter(valid_568709, JString, required = true,
                                 default = nil)
  if valid_568709 != nil:
    section.add "databaseName", valid_568709
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568710 = query.getOrDefault("api-version")
  valid_568710 = validateParameter(valid_568710, JString, required = true,
                                 default = nil)
  if valid_568710 != nil:
    section.add "api-version", valid_568710
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568711: Call_CatalogDeleteAllSecrets_568706; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes all secrets in the specified database. This is deprecated and will be removed in the next release. In the future, please only drop individual credentials using DeleteCredential
  ## 
  let valid = call_568711.validator(path, query, header, formData, body)
  let scheme = call_568711.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568711.url(scheme.get, call_568711.host, call_568711.base,
                         call_568711.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568711, url, valid)

proc call*(call_568712: Call_CatalogDeleteAllSecrets_568706; apiVersion: string;
          databaseName: string): Recallable =
  ## catalogDeleteAllSecrets
  ## Deletes all secrets in the specified database. This is deprecated and will be removed in the next release. In the future, please only drop individual credentials using DeleteCredential
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  var path_568713 = newJObject()
  var query_568714 = newJObject()
  add(query_568714, "api-version", newJString(apiVersion))
  add(path_568713, "databaseName", newJString(databaseName))
  result = call_568712.call(path_568713, query_568714, nil, nil, nil)

var catalogDeleteAllSecrets* = Call_CatalogDeleteAllSecrets_568706(
    name: "catalogDeleteAllSecrets", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/secrets",
    validator: validate_CatalogDeleteAllSecrets_568707, base: "",
    url: url_CatalogDeleteAllSecrets_568708, schemes: {Scheme.Https})
type
  Call_CatalogCreateSecret_568725 = ref object of OpenApiRestCall_567666
proc url_CatalogCreateSecret_568727(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogCreateSecret_568726(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates the specified secret for use with external data sources in the specified database. This is deprecated and will be removed in the next release. Please use CreateCredential instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database in which to create the secret.
  ##   secretName: JString (required)
  ##             : The name of the secret.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_568728 = path.getOrDefault("databaseName")
  valid_568728 = validateParameter(valid_568728, JString, required = true,
                                 default = nil)
  if valid_568728 != nil:
    section.add "databaseName", valid_568728
  var valid_568729 = path.getOrDefault("secretName")
  valid_568729 = validateParameter(valid_568729, JString, required = true,
                                 default = nil)
  if valid_568729 != nil:
    section.add "secretName", valid_568729
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568730 = query.getOrDefault("api-version")
  valid_568730 = validateParameter(valid_568730, JString, required = true,
                                 default = nil)
  if valid_568730 != nil:
    section.add "api-version", valid_568730
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

proc call*(call_568732: Call_CatalogCreateSecret_568725; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the specified secret for use with external data sources in the specified database. This is deprecated and will be removed in the next release. Please use CreateCredential instead.
  ## 
  let valid = call_568732.validator(path, query, header, formData, body)
  let scheme = call_568732.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568732.url(scheme.get, call_568732.host, call_568732.base,
                         call_568732.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568732, url, valid)

proc call*(call_568733: Call_CatalogCreateSecret_568725; apiVersion: string;
          databaseName: string; parameters: JsonNode; secretName: string): Recallable =
  ## catalogCreateSecret
  ## Creates the specified secret for use with external data sources in the specified database. This is deprecated and will be removed in the next release. Please use CreateCredential instead.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database in which to create the secret.
  ##   parameters: JObject (required)
  ##             : The parameters required to create the secret (name and password)
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_568734 = newJObject()
  var query_568735 = newJObject()
  var body_568736 = newJObject()
  add(query_568735, "api-version", newJString(apiVersion))
  add(path_568734, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_568736 = parameters
  add(path_568734, "secretName", newJString(secretName))
  result = call_568733.call(path_568734, query_568735, nil, nil, body_568736)

var catalogCreateSecret* = Call_CatalogCreateSecret_568725(
    name: "catalogCreateSecret", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogCreateSecret_568726, base: "",
    url: url_CatalogCreateSecret_568727, schemes: {Scheme.Https})
type
  Call_CatalogGetSecret_568715 = ref object of OpenApiRestCall_567666
proc url_CatalogGetSecret_568717(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetSecret_568716(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the specified secret in the specified database. This is deprecated and will be removed in the next release. Please use GetCredential instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the secret.
  ##   secretName: JString (required)
  ##             : The name of the secret to get
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_568718 = path.getOrDefault("databaseName")
  valid_568718 = validateParameter(valid_568718, JString, required = true,
                                 default = nil)
  if valid_568718 != nil:
    section.add "databaseName", valid_568718
  var valid_568719 = path.getOrDefault("secretName")
  valid_568719 = validateParameter(valid_568719, JString, required = true,
                                 default = nil)
  if valid_568719 != nil:
    section.add "secretName", valid_568719
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568720 = query.getOrDefault("api-version")
  valid_568720 = validateParameter(valid_568720, JString, required = true,
                                 default = nil)
  if valid_568720 != nil:
    section.add "api-version", valid_568720
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568721: Call_CatalogGetSecret_568715; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified secret in the specified database. This is deprecated and will be removed in the next release. Please use GetCredential instead.
  ## 
  let valid = call_568721.validator(path, query, header, formData, body)
  let scheme = call_568721.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568721.url(scheme.get, call_568721.host, call_568721.base,
                         call_568721.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568721, url, valid)

proc call*(call_568722: Call_CatalogGetSecret_568715; apiVersion: string;
          databaseName: string; secretName: string): Recallable =
  ## catalogGetSecret
  ## Gets the specified secret in the specified database. This is deprecated and will be removed in the next release. Please use GetCredential instead.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  ##   secretName: string (required)
  ##             : The name of the secret to get
  var path_568723 = newJObject()
  var query_568724 = newJObject()
  add(query_568724, "api-version", newJString(apiVersion))
  add(path_568723, "databaseName", newJString(databaseName))
  add(path_568723, "secretName", newJString(secretName))
  result = call_568722.call(path_568723, query_568724, nil, nil, nil)

var catalogGetSecret* = Call_CatalogGetSecret_568715(name: "catalogGetSecret",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogGetSecret_568716, base: "",
    url: url_CatalogGetSecret_568717, schemes: {Scheme.Https})
type
  Call_CatalogUpdateSecret_568747 = ref object of OpenApiRestCall_567666
proc url_CatalogUpdateSecret_568749(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogUpdateSecret_568748(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Modifies the specified secret for use with external data sources in the specified database. This is deprecated and will be removed in the next release. Please use UpdateCredential instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the secret.
  ##   secretName: JString (required)
  ##             : The name of the secret.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_568750 = path.getOrDefault("databaseName")
  valid_568750 = validateParameter(valid_568750, JString, required = true,
                                 default = nil)
  if valid_568750 != nil:
    section.add "databaseName", valid_568750
  var valid_568751 = path.getOrDefault("secretName")
  valid_568751 = validateParameter(valid_568751, JString, required = true,
                                 default = nil)
  if valid_568751 != nil:
    section.add "secretName", valid_568751
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568752 = query.getOrDefault("api-version")
  valid_568752 = validateParameter(valid_568752, JString, required = true,
                                 default = nil)
  if valid_568752 != nil:
    section.add "api-version", valid_568752
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

proc call*(call_568754: Call_CatalogUpdateSecret_568747; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the specified secret for use with external data sources in the specified database. This is deprecated and will be removed in the next release. Please use UpdateCredential instead.
  ## 
  let valid = call_568754.validator(path, query, header, formData, body)
  let scheme = call_568754.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568754.url(scheme.get, call_568754.host, call_568754.base,
                         call_568754.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568754, url, valid)

proc call*(call_568755: Call_CatalogUpdateSecret_568747; apiVersion: string;
          databaseName: string; parameters: JsonNode; secretName: string): Recallable =
  ## catalogUpdateSecret
  ## Modifies the specified secret for use with external data sources in the specified database. This is deprecated and will be removed in the next release. Please use UpdateCredential instead.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  ##   parameters: JObject (required)
  ##             : The parameters required to modify the secret (name and password)
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_568756 = newJObject()
  var query_568757 = newJObject()
  var body_568758 = newJObject()
  add(query_568757, "api-version", newJString(apiVersion))
  add(path_568756, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_568758 = parameters
  add(path_568756, "secretName", newJString(secretName))
  result = call_568755.call(path_568756, query_568757, nil, nil, body_568758)

var catalogUpdateSecret* = Call_CatalogUpdateSecret_568747(
    name: "catalogUpdateSecret", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogUpdateSecret_568748, base: "",
    url: url_CatalogUpdateSecret_568749, schemes: {Scheme.Https})
type
  Call_CatalogDeleteSecret_568737 = ref object of OpenApiRestCall_567666
proc url_CatalogDeleteSecret_568739(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogDeleteSecret_568738(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the specified secret in the specified database. This is deprecated and will be removed in the next release. Please use DeleteCredential instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the secret.
  ##   secretName: JString (required)
  ##             : The name of the secret to delete
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_568740 = path.getOrDefault("databaseName")
  valid_568740 = validateParameter(valid_568740, JString, required = true,
                                 default = nil)
  if valid_568740 != nil:
    section.add "databaseName", valid_568740
  var valid_568741 = path.getOrDefault("secretName")
  valid_568741 = validateParameter(valid_568741, JString, required = true,
                                 default = nil)
  if valid_568741 != nil:
    section.add "secretName", valid_568741
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568742 = query.getOrDefault("api-version")
  valid_568742 = validateParameter(valid_568742, JString, required = true,
                                 default = nil)
  if valid_568742 != nil:
    section.add "api-version", valid_568742
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568743: Call_CatalogDeleteSecret_568737; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified secret in the specified database. This is deprecated and will be removed in the next release. Please use DeleteCredential instead.
  ## 
  let valid = call_568743.validator(path, query, header, formData, body)
  let scheme = call_568743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568743.url(scheme.get, call_568743.host, call_568743.base,
                         call_568743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568743, url, valid)

proc call*(call_568744: Call_CatalogDeleteSecret_568737; apiVersion: string;
          databaseName: string; secretName: string): Recallable =
  ## catalogDeleteSecret
  ## Deletes the specified secret in the specified database. This is deprecated and will be removed in the next release. Please use DeleteCredential instead.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  ##   secretName: string (required)
  ##             : The name of the secret to delete
  var path_568745 = newJObject()
  var query_568746 = newJObject()
  add(query_568746, "api-version", newJString(apiVersion))
  add(path_568745, "databaseName", newJString(databaseName))
  add(path_568745, "secretName", newJString(secretName))
  result = call_568744.call(path_568745, query_568746, nil, nil, nil)

var catalogDeleteSecret* = Call_CatalogDeleteSecret_568737(
    name: "catalogDeleteSecret", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogDeleteSecret_568738, base: "",
    url: url_CatalogDeleteSecret_568739, schemes: {Scheme.Https})
type
  Call_CatalogListTableStatisticsByDatabase_568759 = ref object of OpenApiRestCall_567666
proc url_CatalogListTableStatisticsByDatabase_568761(protocol: Scheme;
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

proc validate_CatalogListTableStatisticsByDatabase_568760(path: JsonNode;
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
  var valid_568762 = path.getOrDefault("databaseName")
  valid_568762 = validateParameter(valid_568762, JString, required = true,
                                 default = nil)
  if valid_568762 != nil:
    section.add "databaseName", valid_568762
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568763 = query.getOrDefault("$orderby")
  valid_568763 = validateParameter(valid_568763, JString, required = false,
                                 default = nil)
  if valid_568763 != nil:
    section.add "$orderby", valid_568763
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568764 = query.getOrDefault("api-version")
  valid_568764 = validateParameter(valid_568764, JString, required = true,
                                 default = nil)
  if valid_568764 != nil:
    section.add "api-version", valid_568764
  var valid_568765 = query.getOrDefault("$top")
  valid_568765 = validateParameter(valid_568765, JInt, required = false, default = nil)
  if valid_568765 != nil:
    section.add "$top", valid_568765
  var valid_568766 = query.getOrDefault("$select")
  valid_568766 = validateParameter(valid_568766, JString, required = false,
                                 default = nil)
  if valid_568766 != nil:
    section.add "$select", valid_568766
  var valid_568767 = query.getOrDefault("$skip")
  valid_568767 = validateParameter(valid_568767, JInt, required = false, default = nil)
  if valid_568767 != nil:
    section.add "$skip", valid_568767
  var valid_568768 = query.getOrDefault("$count")
  valid_568768 = validateParameter(valid_568768, JBool, required = false, default = nil)
  if valid_568768 != nil:
    section.add "$count", valid_568768
  var valid_568769 = query.getOrDefault("$filter")
  valid_568769 = validateParameter(valid_568769, JString, required = false,
                                 default = nil)
  if valid_568769 != nil:
    section.add "$filter", valid_568769
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568770: Call_CatalogListTableStatisticsByDatabase_568759;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of all statistics in a database from the Data Lake Analytics catalog.
  ## 
  let valid = call_568770.validator(path, query, header, formData, body)
  let scheme = call_568770.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568770.url(scheme.get, call_568770.host, call_568770.base,
                         call_568770.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568770, url, valid)

proc call*(call_568771: Call_CatalogListTableStatisticsByDatabase_568759;
          apiVersion: string; databaseName: string; Orderby: string = ""; Top: int = 0;
          Select: string = ""; Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListTableStatisticsByDatabase
  ## Retrieves the list of all statistics in a database from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the table statistics.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568772 = newJObject()
  var query_568773 = newJObject()
  add(query_568773, "$orderby", newJString(Orderby))
  add(query_568773, "api-version", newJString(apiVersion))
  add(query_568773, "$top", newJInt(Top))
  add(query_568773, "$select", newJString(Select))
  add(path_568772, "databaseName", newJString(databaseName))
  add(query_568773, "$skip", newJInt(Skip))
  add(query_568773, "$count", newJBool(Count))
  add(query_568773, "$filter", newJString(Filter))
  result = call_568771.call(path_568772, query_568773, nil, nil, nil)

var catalogListTableStatisticsByDatabase* = Call_CatalogListTableStatisticsByDatabase_568759(
    name: "catalogListTableStatisticsByDatabase", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/statistics",
    validator: validate_CatalogListTableStatisticsByDatabase_568760, base: "",
    url: url_CatalogListTableStatisticsByDatabase_568761, schemes: {Scheme.Https})
type
  Call_CatalogListTablesByDatabase_568774 = ref object of OpenApiRestCall_567666
proc url_CatalogListTablesByDatabase_568776(protocol: Scheme; host: string;
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

proc validate_CatalogListTablesByDatabase_568775(path: JsonNode; query: JsonNode;
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
  var valid_568777 = path.getOrDefault("databaseName")
  valid_568777 = validateParameter(valid_568777, JString, required = true,
                                 default = nil)
  if valid_568777 != nil:
    section.add "databaseName", valid_568777
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   basic: JBool
  ##        : The basic switch indicates what level of information to return when listing tables. When basic is true, only database_name, schema_name, table_name and version are returned for each table, otherwise all table metadata is returned. By default, it is false
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568778 = query.getOrDefault("$orderby")
  valid_568778 = validateParameter(valid_568778, JString, required = false,
                                 default = nil)
  if valid_568778 != nil:
    section.add "$orderby", valid_568778
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568779 = query.getOrDefault("api-version")
  valid_568779 = validateParameter(valid_568779, JString, required = true,
                                 default = nil)
  if valid_568779 != nil:
    section.add "api-version", valid_568779
  var valid_568780 = query.getOrDefault("$top")
  valid_568780 = validateParameter(valid_568780, JInt, required = false, default = nil)
  if valid_568780 != nil:
    section.add "$top", valid_568780
  var valid_568781 = query.getOrDefault("$select")
  valid_568781 = validateParameter(valid_568781, JString, required = false,
                                 default = nil)
  if valid_568781 != nil:
    section.add "$select", valid_568781
  var valid_568782 = query.getOrDefault("$skip")
  valid_568782 = validateParameter(valid_568782, JInt, required = false, default = nil)
  if valid_568782 != nil:
    section.add "$skip", valid_568782
  var valid_568783 = query.getOrDefault("$count")
  valid_568783 = validateParameter(valid_568783, JBool, required = false, default = nil)
  if valid_568783 != nil:
    section.add "$count", valid_568783
  var valid_568784 = query.getOrDefault("basic")
  valid_568784 = validateParameter(valid_568784, JBool, required = false,
                                 default = newJBool(false))
  if valid_568784 != nil:
    section.add "basic", valid_568784
  var valid_568785 = query.getOrDefault("$filter")
  valid_568785 = validateParameter(valid_568785, JString, required = false,
                                 default = nil)
  if valid_568785 != nil:
    section.add "$filter", valid_568785
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568786: Call_CatalogListTablesByDatabase_568774; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of all tables in a database from the Data Lake Analytics catalog.
  ## 
  let valid = call_568786.validator(path, query, header, formData, body)
  let scheme = call_568786.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568786.url(scheme.get, call_568786.host, call_568786.base,
                         call_568786.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568786, url, valid)

proc call*(call_568787: Call_CatalogListTablesByDatabase_568774;
          apiVersion: string; databaseName: string; Orderby: string = ""; Top: int = 0;
          Select: string = ""; Skip: int = 0; Count: bool = false; basic: bool = false;
          Filter: string = ""): Recallable =
  ## catalogListTablesByDatabase
  ## Retrieves the list of all tables in a database from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the tables.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   basic: bool
  ##        : The basic switch indicates what level of information to return when listing tables. When basic is true, only database_name, schema_name, table_name and version are returned for each table, otherwise all table metadata is returned. By default, it is false
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568788 = newJObject()
  var query_568789 = newJObject()
  add(query_568789, "$orderby", newJString(Orderby))
  add(query_568789, "api-version", newJString(apiVersion))
  add(query_568789, "$top", newJInt(Top))
  add(query_568789, "$select", newJString(Select))
  add(path_568788, "databaseName", newJString(databaseName))
  add(query_568789, "$skip", newJInt(Skip))
  add(query_568789, "$count", newJBool(Count))
  add(query_568789, "basic", newJBool(basic))
  add(query_568789, "$filter", newJString(Filter))
  result = call_568787.call(path_568788, query_568789, nil, nil, nil)

var catalogListTablesByDatabase* = Call_CatalogListTablesByDatabase_568774(
    name: "catalogListTablesByDatabase", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/tables",
    validator: validate_CatalogListTablesByDatabase_568775, base: "",
    url: url_CatalogListTablesByDatabase_568776, schemes: {Scheme.Https})
type
  Call_CatalogListTableValuedFunctionsByDatabase_568790 = ref object of OpenApiRestCall_567666
proc url_CatalogListTableValuedFunctionsByDatabase_568792(protocol: Scheme;
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

proc validate_CatalogListTableValuedFunctionsByDatabase_568791(path: JsonNode;
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
  var valid_568793 = path.getOrDefault("databaseName")
  valid_568793 = validateParameter(valid_568793, JString, required = true,
                                 default = nil)
  if valid_568793 != nil:
    section.add "databaseName", valid_568793
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568794 = query.getOrDefault("$orderby")
  valid_568794 = validateParameter(valid_568794, JString, required = false,
                                 default = nil)
  if valid_568794 != nil:
    section.add "$orderby", valid_568794
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568795 = query.getOrDefault("api-version")
  valid_568795 = validateParameter(valid_568795, JString, required = true,
                                 default = nil)
  if valid_568795 != nil:
    section.add "api-version", valid_568795
  var valid_568796 = query.getOrDefault("$top")
  valid_568796 = validateParameter(valid_568796, JInt, required = false, default = nil)
  if valid_568796 != nil:
    section.add "$top", valid_568796
  var valid_568797 = query.getOrDefault("$select")
  valid_568797 = validateParameter(valid_568797, JString, required = false,
                                 default = nil)
  if valid_568797 != nil:
    section.add "$select", valid_568797
  var valid_568798 = query.getOrDefault("$skip")
  valid_568798 = validateParameter(valid_568798, JInt, required = false, default = nil)
  if valid_568798 != nil:
    section.add "$skip", valid_568798
  var valid_568799 = query.getOrDefault("$count")
  valid_568799 = validateParameter(valid_568799, JBool, required = false, default = nil)
  if valid_568799 != nil:
    section.add "$count", valid_568799
  var valid_568800 = query.getOrDefault("$filter")
  valid_568800 = validateParameter(valid_568800, JString, required = false,
                                 default = nil)
  if valid_568800 != nil:
    section.add "$filter", valid_568800
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568801: Call_CatalogListTableValuedFunctionsByDatabase_568790;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of all table valued functions in a database from the Data Lake Analytics catalog.
  ## 
  let valid = call_568801.validator(path, query, header, formData, body)
  let scheme = call_568801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568801.url(scheme.get, call_568801.host, call_568801.base,
                         call_568801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568801, url, valid)

proc call*(call_568802: Call_CatalogListTableValuedFunctionsByDatabase_568790;
          apiVersion: string; databaseName: string; Orderby: string = ""; Top: int = 0;
          Select: string = ""; Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListTableValuedFunctionsByDatabase
  ## Retrieves the list of all table valued functions in a database from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the table valued functions.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568803 = newJObject()
  var query_568804 = newJObject()
  add(query_568804, "$orderby", newJString(Orderby))
  add(query_568804, "api-version", newJString(apiVersion))
  add(query_568804, "$top", newJInt(Top))
  add(query_568804, "$select", newJString(Select))
  add(path_568803, "databaseName", newJString(databaseName))
  add(query_568804, "$skip", newJInt(Skip))
  add(query_568804, "$count", newJBool(Count))
  add(query_568804, "$filter", newJString(Filter))
  result = call_568802.call(path_568803, query_568804, nil, nil, nil)

var catalogListTableValuedFunctionsByDatabase* = Call_CatalogListTableValuedFunctionsByDatabase_568790(
    name: "catalogListTableValuedFunctionsByDatabase", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/tablevaluedfunctions",
    validator: validate_CatalogListTableValuedFunctionsByDatabase_568791,
    base: "", url: url_CatalogListTableValuedFunctionsByDatabase_568792,
    schemes: {Scheme.Https})
type
  Call_CatalogListViewsByDatabase_568805 = ref object of OpenApiRestCall_567666
proc url_CatalogListViewsByDatabase_568807(protocol: Scheme; host: string;
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

proc validate_CatalogListViewsByDatabase_568806(path: JsonNode; query: JsonNode;
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
  var valid_568808 = path.getOrDefault("databaseName")
  valid_568808 = validateParameter(valid_568808, JString, required = true,
                                 default = nil)
  if valid_568808 != nil:
    section.add "databaseName", valid_568808
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_568809 = query.getOrDefault("$orderby")
  valid_568809 = validateParameter(valid_568809, JString, required = false,
                                 default = nil)
  if valid_568809 != nil:
    section.add "$orderby", valid_568809
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568810 = query.getOrDefault("api-version")
  valid_568810 = validateParameter(valid_568810, JString, required = true,
                                 default = nil)
  if valid_568810 != nil:
    section.add "api-version", valid_568810
  var valid_568811 = query.getOrDefault("$top")
  valid_568811 = validateParameter(valid_568811, JInt, required = false, default = nil)
  if valid_568811 != nil:
    section.add "$top", valid_568811
  var valid_568812 = query.getOrDefault("$select")
  valid_568812 = validateParameter(valid_568812, JString, required = false,
                                 default = nil)
  if valid_568812 != nil:
    section.add "$select", valid_568812
  var valid_568813 = query.getOrDefault("$skip")
  valid_568813 = validateParameter(valid_568813, JInt, required = false, default = nil)
  if valid_568813 != nil:
    section.add "$skip", valid_568813
  var valid_568814 = query.getOrDefault("$count")
  valid_568814 = validateParameter(valid_568814, JBool, required = false, default = nil)
  if valid_568814 != nil:
    section.add "$count", valid_568814
  var valid_568815 = query.getOrDefault("$filter")
  valid_568815 = validateParameter(valid_568815, JString, required = false,
                                 default = nil)
  if valid_568815 != nil:
    section.add "$filter", valid_568815
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568816: Call_CatalogListViewsByDatabase_568805; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of all views in a database from the Data Lake Analytics catalog.
  ## 
  let valid = call_568816.validator(path, query, header, formData, body)
  let scheme = call_568816.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568816.url(scheme.get, call_568816.host, call_568816.base,
                         call_568816.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568816, url, valid)

proc call*(call_568817: Call_CatalogListViewsByDatabase_568805; apiVersion: string;
          databaseName: string; Orderby: string = ""; Top: int = 0; Select: string = "";
          Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListViewsByDatabase
  ## Retrieves the list of all views in a database from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   databaseName: string (required)
  ##               : The name of the database containing the views.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568818 = newJObject()
  var query_568819 = newJObject()
  add(query_568819, "$orderby", newJString(Orderby))
  add(query_568819, "api-version", newJString(apiVersion))
  add(query_568819, "$top", newJInt(Top))
  add(query_568819, "$select", newJString(Select))
  add(path_568818, "databaseName", newJString(databaseName))
  add(query_568819, "$skip", newJInt(Skip))
  add(query_568819, "$count", newJBool(Count))
  add(query_568819, "$filter", newJString(Filter))
  result = call_568817.call(path_568818, query_568819, nil, nil, nil)

var catalogListViewsByDatabase* = Call_CatalogListViewsByDatabase_568805(
    name: "catalogListViewsByDatabase", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/views",
    validator: validate_CatalogListViewsByDatabase_568806, base: "",
    url: url_CatalogListViewsByDatabase_568807, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
