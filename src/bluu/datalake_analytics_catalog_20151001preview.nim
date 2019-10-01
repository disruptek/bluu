
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DataLakeAnalyticsCatalogManagementClient
## version: 2015-10-01-preview
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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  Call_CatalogListDatabases_567863 = ref object of OpenApiRestCall_567641
proc url_CatalogListDatabases_567865(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CatalogListDatabases_567864(path: JsonNode; query: JsonNode;
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
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var valid_568025 = query.getOrDefault("$orderby")
  valid_568025 = validateParameter(valid_568025, JString, required = false,
                                 default = nil)
  if valid_568025 != nil:
    section.add "$orderby", valid_568025
  var valid_568026 = query.getOrDefault("$expand")
  valid_568026 = validateParameter(valid_568026, JString, required = false,
                                 default = nil)
  if valid_568026 != nil:
    section.add "$expand", valid_568026
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568027 = query.getOrDefault("api-version")
  valid_568027 = validateParameter(valid_568027, JString, required = true,
                                 default = nil)
  if valid_568027 != nil:
    section.add "api-version", valid_568027
  var valid_568028 = query.getOrDefault("$top")
  valid_568028 = validateParameter(valid_568028, JInt, required = false, default = nil)
  if valid_568028 != nil:
    section.add "$top", valid_568028
  var valid_568029 = query.getOrDefault("$select")
  valid_568029 = validateParameter(valid_568029, JString, required = false,
                                 default = nil)
  if valid_568029 != nil:
    section.add "$select", valid_568029
  var valid_568030 = query.getOrDefault("$skip")
  valid_568030 = validateParameter(valid_568030, JInt, required = false, default = nil)
  if valid_568030 != nil:
    section.add "$skip", valid_568030
  var valid_568031 = query.getOrDefault("$count")
  valid_568031 = validateParameter(valid_568031, JBool, required = false, default = nil)
  if valid_568031 != nil:
    section.add "$count", valid_568031
  var valid_568032 = query.getOrDefault("$filter")
  valid_568032 = validateParameter(valid_568032, JString, required = false,
                                 default = nil)
  if valid_568032 != nil:
    section.add "$filter", valid_568032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568055: Call_CatalogListDatabases_567863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of databases from the Data Lake Analytics catalog.
  ## 
  let valid = call_568055.validator(path, query, header, formData, body)
  let scheme = call_568055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568055.url(scheme.get, call_568055.host, call_568055.base,
                         call_568055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568055, url, valid)

proc call*(call_568126: Call_CatalogListDatabases_567863; apiVersion: string;
          Orderby: string = ""; Expand: string = ""; Top: int = 0; Select: string = "";
          Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListDatabases
  ## Retrieves the list of databases from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var query_568127 = newJObject()
  add(query_568127, "$orderby", newJString(Orderby))
  add(query_568127, "$expand", newJString(Expand))
  add(query_568127, "api-version", newJString(apiVersion))
  add(query_568127, "$top", newJInt(Top))
  add(query_568127, "$select", newJString(Select))
  add(query_568127, "$skip", newJInt(Skip))
  add(query_568127, "$count", newJBool(Count))
  add(query_568127, "$filter", newJString(Filter))
  result = call_568126.call(nil, query_568127, nil, nil, nil)

var catalogListDatabases* = Call_CatalogListDatabases_567863(
    name: "catalogListDatabases", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases", validator: validate_CatalogListDatabases_567864,
    base: "", url: url_CatalogListDatabases_567865, schemes: {Scheme.Https})
type
  Call_CatalogGetDatabase_568167 = ref object of OpenApiRestCall_567641
proc url_CatalogGetDatabase_568169(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetDatabase_568168(path: JsonNode; query: JsonNode;
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
  var valid_568184 = path.getOrDefault("databaseName")
  valid_568184 = validateParameter(valid_568184, JString, required = true,
                                 default = nil)
  if valid_568184 != nil:
    section.add "databaseName", valid_568184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568185 = query.getOrDefault("api-version")
  valid_568185 = validateParameter(valid_568185, JString, required = true,
                                 default = nil)
  if valid_568185 != nil:
    section.add "api-version", valid_568185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568186: Call_CatalogGetDatabase_568167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified database from the Data Lake Analytics catalog.
  ## 
  let valid = call_568186.validator(path, query, header, formData, body)
  let scheme = call_568186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568186.url(scheme.get, call_568186.host, call_568186.base,
                         call_568186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568186, url, valid)

proc call*(call_568187: Call_CatalogGetDatabase_568167; apiVersion: string;
          databaseName: string): Recallable =
  ## catalogGetDatabase
  ## Retrieves the specified database from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database.
  var path_568188 = newJObject()
  var query_568189 = newJObject()
  add(query_568189, "api-version", newJString(apiVersion))
  add(path_568188, "databaseName", newJString(databaseName))
  result = call_568187.call(path_568188, query_568189, nil, nil, nil)

var catalogGetDatabase* = Call_CatalogGetDatabase_568167(
    name: "catalogGetDatabase", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}",
    validator: validate_CatalogGetDatabase_568168, base: "",
    url: url_CatalogGetDatabase_568169, schemes: {Scheme.Https})
type
  Call_CatalogListAssemblies_568190 = ref object of OpenApiRestCall_567641
proc url_CatalogListAssemblies_568192(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListAssemblies_568191(path: JsonNode; query: JsonNode;
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
  var valid_568193 = path.getOrDefault("databaseName")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "databaseName", valid_568193
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var valid_568195 = query.getOrDefault("$expand")
  valid_568195 = validateParameter(valid_568195, JString, required = false,
                                 default = nil)
  if valid_568195 != nil:
    section.add "$expand", valid_568195
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568196 = query.getOrDefault("api-version")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "api-version", valid_568196
  var valid_568197 = query.getOrDefault("$top")
  valid_568197 = validateParameter(valid_568197, JInt, required = false, default = nil)
  if valid_568197 != nil:
    section.add "$top", valid_568197
  var valid_568198 = query.getOrDefault("$select")
  valid_568198 = validateParameter(valid_568198, JString, required = false,
                                 default = nil)
  if valid_568198 != nil:
    section.add "$select", valid_568198
  var valid_568199 = query.getOrDefault("$skip")
  valid_568199 = validateParameter(valid_568199, JInt, required = false, default = nil)
  if valid_568199 != nil:
    section.add "$skip", valid_568199
  var valid_568200 = query.getOrDefault("$count")
  valid_568200 = validateParameter(valid_568200, JBool, required = false, default = nil)
  if valid_568200 != nil:
    section.add "$count", valid_568200
  var valid_568201 = query.getOrDefault("$filter")
  valid_568201 = validateParameter(valid_568201, JString, required = false,
                                 default = nil)
  if valid_568201 != nil:
    section.add "$filter", valid_568201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568202: Call_CatalogListAssemblies_568190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of assemblies from the Data Lake Analytics catalog.
  ## 
  let valid = call_568202.validator(path, query, header, formData, body)
  let scheme = call_568202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568202.url(scheme.get, call_568202.host, call_568202.base,
                         call_568202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568202, url, valid)

proc call*(call_568203: Call_CatalogListAssemblies_568190; apiVersion: string;
          databaseName: string; Orderby: string = ""; Expand: string = ""; Top: int = 0;
          Select: string = ""; Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListAssemblies
  ## Retrieves the list of assemblies from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_568204 = newJObject()
  var query_568205 = newJObject()
  add(query_568205, "$orderby", newJString(Orderby))
  add(query_568205, "$expand", newJString(Expand))
  add(query_568205, "api-version", newJString(apiVersion))
  add(query_568205, "$top", newJInt(Top))
  add(query_568205, "$select", newJString(Select))
  add(path_568204, "databaseName", newJString(databaseName))
  add(query_568205, "$skip", newJInt(Skip))
  add(query_568205, "$count", newJBool(Count))
  add(query_568205, "$filter", newJString(Filter))
  result = call_568203.call(path_568204, query_568205, nil, nil, nil)

var catalogListAssemblies* = Call_CatalogListAssemblies_568190(
    name: "catalogListAssemblies", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/assemblies",
    validator: validate_CatalogListAssemblies_568191, base: "",
    url: url_CatalogListAssemblies_568192, schemes: {Scheme.Https})
type
  Call_CatalogGetAssembly_568206 = ref object of OpenApiRestCall_567641
proc url_CatalogGetAssembly_568208(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetAssembly_568207(path: JsonNode; query: JsonNode;
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
  var valid_568209 = path.getOrDefault("databaseName")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "databaseName", valid_568209
  var valid_568210 = path.getOrDefault("assemblyName")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "assemblyName", valid_568210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568211 = query.getOrDefault("api-version")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "api-version", valid_568211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568212: Call_CatalogGetAssembly_568206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified assembly from the Data Lake Analytics catalog.
  ## 
  let valid = call_568212.validator(path, query, header, formData, body)
  let scheme = call_568212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568212.url(scheme.get, call_568212.host, call_568212.base,
                         call_568212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568212, url, valid)

proc call*(call_568213: Call_CatalogGetAssembly_568206; apiVersion: string;
          databaseName: string; assemblyName: string): Recallable =
  ## catalogGetAssembly
  ## Retrieves the specified assembly from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the assembly.
  ##   assemblyName: string (required)
  ##               : The name of the assembly.
  var path_568214 = newJObject()
  var query_568215 = newJObject()
  add(query_568215, "api-version", newJString(apiVersion))
  add(path_568214, "databaseName", newJString(databaseName))
  add(path_568214, "assemblyName", newJString(assemblyName))
  result = call_568213.call(path_568214, query_568215, nil, nil, nil)

var catalogGetAssembly* = Call_CatalogGetAssembly_568206(
    name: "catalogGetAssembly", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/assemblies/{assemblyName}",
    validator: validate_CatalogGetAssembly_568207, base: "",
    url: url_CatalogGetAssembly_568208, schemes: {Scheme.Https})
type
  Call_CatalogListCredentials_568216 = ref object of OpenApiRestCall_567641
proc url_CatalogListCredentials_568218(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListCredentials_568217(path: JsonNode; query: JsonNode;
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
  var valid_568219 = path.getOrDefault("databaseName")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "databaseName", valid_568219
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var valid_568220 = query.getOrDefault("$orderby")
  valid_568220 = validateParameter(valid_568220, JString, required = false,
                                 default = nil)
  if valid_568220 != nil:
    section.add "$orderby", valid_568220
  var valid_568221 = query.getOrDefault("$expand")
  valid_568221 = validateParameter(valid_568221, JString, required = false,
                                 default = nil)
  if valid_568221 != nil:
    section.add "$expand", valid_568221
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568222 = query.getOrDefault("api-version")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "api-version", valid_568222
  var valid_568223 = query.getOrDefault("$top")
  valid_568223 = validateParameter(valid_568223, JInt, required = false, default = nil)
  if valid_568223 != nil:
    section.add "$top", valid_568223
  var valid_568224 = query.getOrDefault("$select")
  valid_568224 = validateParameter(valid_568224, JString, required = false,
                                 default = nil)
  if valid_568224 != nil:
    section.add "$select", valid_568224
  var valid_568225 = query.getOrDefault("$skip")
  valid_568225 = validateParameter(valid_568225, JInt, required = false, default = nil)
  if valid_568225 != nil:
    section.add "$skip", valid_568225
  var valid_568226 = query.getOrDefault("$count")
  valid_568226 = validateParameter(valid_568226, JBool, required = false, default = nil)
  if valid_568226 != nil:
    section.add "$count", valid_568226
  var valid_568227 = query.getOrDefault("$filter")
  valid_568227 = validateParameter(valid_568227, JString, required = false,
                                 default = nil)
  if valid_568227 != nil:
    section.add "$filter", valid_568227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568228: Call_CatalogListCredentials_568216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of credentials from the Data Lake Analytics catalog.
  ## 
  let valid = call_568228.validator(path, query, header, formData, body)
  let scheme = call_568228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568228.url(scheme.get, call_568228.host, call_568228.base,
                         call_568228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568228, url, valid)

proc call*(call_568229: Call_CatalogListCredentials_568216; apiVersion: string;
          databaseName: string; Orderby: string = ""; Expand: string = ""; Top: int = 0;
          Select: string = ""; Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListCredentials
  ## Retrieves the list of credentials from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_568230 = newJObject()
  var query_568231 = newJObject()
  add(query_568231, "$orderby", newJString(Orderby))
  add(query_568231, "$expand", newJString(Expand))
  add(query_568231, "api-version", newJString(apiVersion))
  add(query_568231, "$top", newJInt(Top))
  add(query_568231, "$select", newJString(Select))
  add(path_568230, "databaseName", newJString(databaseName))
  add(query_568231, "$skip", newJInt(Skip))
  add(query_568231, "$count", newJBool(Count))
  add(query_568231, "$filter", newJString(Filter))
  result = call_568229.call(path_568230, query_568231, nil, nil, nil)

var catalogListCredentials* = Call_CatalogListCredentials_568216(
    name: "catalogListCredentials", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/credentials",
    validator: validate_CatalogListCredentials_568217, base: "",
    url: url_CatalogListCredentials_568218, schemes: {Scheme.Https})
type
  Call_CatalogGetCredential_568232 = ref object of OpenApiRestCall_567641
proc url_CatalogGetCredential_568234(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetCredential_568233(path: JsonNode; query: JsonNode;
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
  var valid_568235 = path.getOrDefault("databaseName")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "databaseName", valid_568235
  var valid_568236 = path.getOrDefault("credentialName")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "credentialName", valid_568236
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
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568238: Call_CatalogGetCredential_568232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified credential from the Data Lake Analytics catalog.
  ## 
  let valid = call_568238.validator(path, query, header, formData, body)
  let scheme = call_568238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568238.url(scheme.get, call_568238.host, call_568238.base,
                         call_568238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568238, url, valid)

proc call*(call_568239: Call_CatalogGetCredential_568232; apiVersion: string;
          databaseName: string; credentialName: string): Recallable =
  ## catalogGetCredential
  ## Retrieves the specified credential from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the schema.
  ##   credentialName: string (required)
  ##                 : The name of the credential.
  var path_568240 = newJObject()
  var query_568241 = newJObject()
  add(query_568241, "api-version", newJString(apiVersion))
  add(path_568240, "databaseName", newJString(databaseName))
  add(path_568240, "credentialName", newJString(credentialName))
  result = call_568239.call(path_568240, query_568241, nil, nil, nil)

var catalogGetCredential* = Call_CatalogGetCredential_568232(
    name: "catalogGetCredential", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/credentials/{credentialName}",
    validator: validate_CatalogGetCredential_568233, base: "",
    url: url_CatalogGetCredential_568234, schemes: {Scheme.Https})
type
  Call_CatalogListExternalDataSources_568242 = ref object of OpenApiRestCall_567641
proc url_CatalogListExternalDataSources_568244(protocol: Scheme; host: string;
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

proc validate_CatalogListExternalDataSources_568243(path: JsonNode;
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
  var valid_568245 = path.getOrDefault("databaseName")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "databaseName", valid_568245
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var valid_568247 = query.getOrDefault("$expand")
  valid_568247 = validateParameter(valid_568247, JString, required = false,
                                 default = nil)
  if valid_568247 != nil:
    section.add "$expand", valid_568247
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568248 = query.getOrDefault("api-version")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "api-version", valid_568248
  var valid_568249 = query.getOrDefault("$top")
  valid_568249 = validateParameter(valid_568249, JInt, required = false, default = nil)
  if valid_568249 != nil:
    section.add "$top", valid_568249
  var valid_568250 = query.getOrDefault("$select")
  valid_568250 = validateParameter(valid_568250, JString, required = false,
                                 default = nil)
  if valid_568250 != nil:
    section.add "$select", valid_568250
  var valid_568251 = query.getOrDefault("$skip")
  valid_568251 = validateParameter(valid_568251, JInt, required = false, default = nil)
  if valid_568251 != nil:
    section.add "$skip", valid_568251
  var valid_568252 = query.getOrDefault("$count")
  valid_568252 = validateParameter(valid_568252, JBool, required = false, default = nil)
  if valid_568252 != nil:
    section.add "$count", valid_568252
  var valid_568253 = query.getOrDefault("$filter")
  valid_568253 = validateParameter(valid_568253, JString, required = false,
                                 default = nil)
  if valid_568253 != nil:
    section.add "$filter", valid_568253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568254: Call_CatalogListExternalDataSources_568242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of external data sources from the Data Lake Analytics catalog.
  ## 
  let valid = call_568254.validator(path, query, header, formData, body)
  let scheme = call_568254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568254.url(scheme.get, call_568254.host, call_568254.base,
                         call_568254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568254, url, valid)

proc call*(call_568255: Call_CatalogListExternalDataSources_568242;
          apiVersion: string; databaseName: string; Orderby: string = "";
          Expand: string = ""; Top: int = 0; Select: string = ""; Skip: int = 0;
          Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListExternalDataSources
  ## Retrieves the list of external data sources from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_568256 = newJObject()
  var query_568257 = newJObject()
  add(query_568257, "$orderby", newJString(Orderby))
  add(query_568257, "$expand", newJString(Expand))
  add(query_568257, "api-version", newJString(apiVersion))
  add(query_568257, "$top", newJInt(Top))
  add(query_568257, "$select", newJString(Select))
  add(path_568256, "databaseName", newJString(databaseName))
  add(query_568257, "$skip", newJInt(Skip))
  add(query_568257, "$count", newJBool(Count))
  add(query_568257, "$filter", newJString(Filter))
  result = call_568255.call(path_568256, query_568257, nil, nil, nil)

var catalogListExternalDataSources* = Call_CatalogListExternalDataSources_568242(
    name: "catalogListExternalDataSources", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/externaldatasources",
    validator: validate_CatalogListExternalDataSources_568243, base: "",
    url: url_CatalogListExternalDataSources_568244, schemes: {Scheme.Https})
type
  Call_CatalogGetExternalDataSource_568258 = ref object of OpenApiRestCall_567641
proc url_CatalogGetExternalDataSource_568260(protocol: Scheme; host: string;
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

proc validate_CatalogGetExternalDataSource_568259(path: JsonNode; query: JsonNode;
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
  var valid_568261 = path.getOrDefault("externalDataSourceName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "externalDataSourceName", valid_568261
  var valid_568262 = path.getOrDefault("databaseName")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "databaseName", valid_568262
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568263 = query.getOrDefault("api-version")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "api-version", valid_568263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568264: Call_CatalogGetExternalDataSource_568258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified external data source from the Data Lake Analytics catalog.
  ## 
  let valid = call_568264.validator(path, query, header, formData, body)
  let scheme = call_568264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568264.url(scheme.get, call_568264.host, call_568264.base,
                         call_568264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568264, url, valid)

proc call*(call_568265: Call_CatalogGetExternalDataSource_568258;
          externalDataSourceName: string; apiVersion: string; databaseName: string): Recallable =
  ## catalogGetExternalDataSource
  ## Retrieves the specified external data source from the Data Lake Analytics catalog.
  ##   externalDataSourceName: string (required)
  ##                         : The name of the external data source.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the external data source.
  var path_568266 = newJObject()
  var query_568267 = newJObject()
  add(path_568266, "externalDataSourceName", newJString(externalDataSourceName))
  add(query_568267, "api-version", newJString(apiVersion))
  add(path_568266, "databaseName", newJString(databaseName))
  result = call_568265.call(path_568266, query_568267, nil, nil, nil)

var catalogGetExternalDataSource* = Call_CatalogGetExternalDataSource_568258(
    name: "catalogGetExternalDataSource", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/externaldatasources/{externalDataSourceName}",
    validator: validate_CatalogGetExternalDataSource_568259, base: "",
    url: url_CatalogGetExternalDataSource_568260, schemes: {Scheme.Https})
type
  Call_CatalogListSchemas_568268 = ref object of OpenApiRestCall_567641
proc url_CatalogListSchemas_568270(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListSchemas_568269(path: JsonNode; query: JsonNode;
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
  var valid_568271 = path.getOrDefault("databaseName")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "databaseName", valid_568271
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var valid_568272 = query.getOrDefault("$orderby")
  valid_568272 = validateParameter(valid_568272, JString, required = false,
                                 default = nil)
  if valid_568272 != nil:
    section.add "$orderby", valid_568272
  var valid_568273 = query.getOrDefault("$expand")
  valid_568273 = validateParameter(valid_568273, JString, required = false,
                                 default = nil)
  if valid_568273 != nil:
    section.add "$expand", valid_568273
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568274 = query.getOrDefault("api-version")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "api-version", valid_568274
  var valid_568275 = query.getOrDefault("$top")
  valid_568275 = validateParameter(valid_568275, JInt, required = false, default = nil)
  if valid_568275 != nil:
    section.add "$top", valid_568275
  var valid_568276 = query.getOrDefault("$select")
  valid_568276 = validateParameter(valid_568276, JString, required = false,
                                 default = nil)
  if valid_568276 != nil:
    section.add "$select", valid_568276
  var valid_568277 = query.getOrDefault("$skip")
  valid_568277 = validateParameter(valid_568277, JInt, required = false, default = nil)
  if valid_568277 != nil:
    section.add "$skip", valid_568277
  var valid_568278 = query.getOrDefault("$count")
  valid_568278 = validateParameter(valid_568278, JBool, required = false, default = nil)
  if valid_568278 != nil:
    section.add "$count", valid_568278
  var valid_568279 = query.getOrDefault("$filter")
  valid_568279 = validateParameter(valid_568279, JString, required = false,
                                 default = nil)
  if valid_568279 != nil:
    section.add "$filter", valid_568279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568280: Call_CatalogListSchemas_568268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of schemas from the Data Lake Analytics catalog.
  ## 
  let valid = call_568280.validator(path, query, header, formData, body)
  let scheme = call_568280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568280.url(scheme.get, call_568280.host, call_568280.base,
                         call_568280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568280, url, valid)

proc call*(call_568281: Call_CatalogListSchemas_568268; apiVersion: string;
          databaseName: string; Orderby: string = ""; Expand: string = ""; Top: int = 0;
          Select: string = ""; Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListSchemas
  ## Retrieves the list of schemas from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_568282 = newJObject()
  var query_568283 = newJObject()
  add(query_568283, "$orderby", newJString(Orderby))
  add(query_568283, "$expand", newJString(Expand))
  add(query_568283, "api-version", newJString(apiVersion))
  add(query_568283, "$top", newJInt(Top))
  add(query_568283, "$select", newJString(Select))
  add(path_568282, "databaseName", newJString(databaseName))
  add(query_568283, "$skip", newJInt(Skip))
  add(query_568283, "$count", newJBool(Count))
  add(query_568283, "$filter", newJString(Filter))
  result = call_568281.call(path_568282, query_568283, nil, nil, nil)

var catalogListSchemas* = Call_CatalogListSchemas_568268(
    name: "catalogListSchemas", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas",
    validator: validate_CatalogListSchemas_568269, base: "",
    url: url_CatalogListSchemas_568270, schemes: {Scheme.Https})
type
  Call_CatalogGetSchema_568284 = ref object of OpenApiRestCall_567641
proc url_CatalogGetSchema_568286(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetSchema_568285(path: JsonNode; query: JsonNode;
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
  var valid_568287 = path.getOrDefault("schemaName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "schemaName", valid_568287
  var valid_568288 = path.getOrDefault("databaseName")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "databaseName", valid_568288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568289 = query.getOrDefault("api-version")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "api-version", valid_568289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568290: Call_CatalogGetSchema_568284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified schema from the Data Lake Analytics catalog.
  ## 
  let valid = call_568290.validator(path, query, header, formData, body)
  let scheme = call_568290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568290.url(scheme.get, call_568290.host, call_568290.base,
                         call_568290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568290, url, valid)

proc call*(call_568291: Call_CatalogGetSchema_568284; apiVersion: string;
          schemaName: string; databaseName: string): Recallable =
  ## catalogGetSchema
  ## Retrieves the specified schema from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   schemaName: string (required)
  ##             : The name of the schema.
  ##   databaseName: string (required)
  ##               : The name of the database containing the schema.
  var path_568292 = newJObject()
  var query_568293 = newJObject()
  add(query_568293, "api-version", newJString(apiVersion))
  add(path_568292, "schemaName", newJString(schemaName))
  add(path_568292, "databaseName", newJString(databaseName))
  result = call_568291.call(path_568292, query_568293, nil, nil, nil)

var catalogGetSchema* = Call_CatalogGetSchema_568284(name: "catalogGetSchema",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}",
    validator: validate_CatalogGetSchema_568285, base: "",
    url: url_CatalogGetSchema_568286, schemes: {Scheme.Https})
type
  Call_CatalogListProcedures_568294 = ref object of OpenApiRestCall_567641
proc url_CatalogListProcedures_568296(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListProcedures_568295(path: JsonNode; query: JsonNode;
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
  var valid_568297 = path.getOrDefault("schemaName")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "schemaName", valid_568297
  var valid_568298 = path.getOrDefault("databaseName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "databaseName", valid_568298
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var valid_568299 = query.getOrDefault("$orderby")
  valid_568299 = validateParameter(valid_568299, JString, required = false,
                                 default = nil)
  if valid_568299 != nil:
    section.add "$orderby", valid_568299
  var valid_568300 = query.getOrDefault("$expand")
  valid_568300 = validateParameter(valid_568300, JString, required = false,
                                 default = nil)
  if valid_568300 != nil:
    section.add "$expand", valid_568300
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568301 = query.getOrDefault("api-version")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "api-version", valid_568301
  var valid_568302 = query.getOrDefault("$top")
  valid_568302 = validateParameter(valid_568302, JInt, required = false, default = nil)
  if valid_568302 != nil:
    section.add "$top", valid_568302
  var valid_568303 = query.getOrDefault("$select")
  valid_568303 = validateParameter(valid_568303, JString, required = false,
                                 default = nil)
  if valid_568303 != nil:
    section.add "$select", valid_568303
  var valid_568304 = query.getOrDefault("$skip")
  valid_568304 = validateParameter(valid_568304, JInt, required = false, default = nil)
  if valid_568304 != nil:
    section.add "$skip", valid_568304
  var valid_568305 = query.getOrDefault("$count")
  valid_568305 = validateParameter(valid_568305, JBool, required = false, default = nil)
  if valid_568305 != nil:
    section.add "$count", valid_568305
  var valid_568306 = query.getOrDefault("$filter")
  valid_568306 = validateParameter(valid_568306, JString, required = false,
                                 default = nil)
  if valid_568306 != nil:
    section.add "$filter", valid_568306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568307: Call_CatalogListProcedures_568294; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of procedures from the Data Lake Analytics catalog.
  ## 
  let valid = call_568307.validator(path, query, header, formData, body)
  let scheme = call_568307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568307.url(scheme.get, call_568307.host, call_568307.base,
                         call_568307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568307, url, valid)

proc call*(call_568308: Call_CatalogListProcedures_568294; apiVersion: string;
          schemaName: string; databaseName: string; Orderby: string = "";
          Expand: string = ""; Top: int = 0; Select: string = ""; Skip: int = 0;
          Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListProcedures
  ## Retrieves the list of procedures from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_568309 = newJObject()
  var query_568310 = newJObject()
  add(query_568310, "$orderby", newJString(Orderby))
  add(query_568310, "$expand", newJString(Expand))
  add(query_568310, "api-version", newJString(apiVersion))
  add(query_568310, "$top", newJInt(Top))
  add(path_568309, "schemaName", newJString(schemaName))
  add(query_568310, "$select", newJString(Select))
  add(path_568309, "databaseName", newJString(databaseName))
  add(query_568310, "$skip", newJInt(Skip))
  add(query_568310, "$count", newJBool(Count))
  add(query_568310, "$filter", newJString(Filter))
  result = call_568308.call(path_568309, query_568310, nil, nil, nil)

var catalogListProcedures* = Call_CatalogListProcedures_568294(
    name: "catalogListProcedures", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/procedures",
    validator: validate_CatalogListProcedures_568295, base: "",
    url: url_CatalogListProcedures_568296, schemes: {Scheme.Https})
type
  Call_CatalogGetProcedure_568311 = ref object of OpenApiRestCall_567641
proc url_CatalogGetProcedure_568313(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetProcedure_568312(path: JsonNode; query: JsonNode;
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
  var valid_568314 = path.getOrDefault("procedureName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "procedureName", valid_568314
  var valid_568315 = path.getOrDefault("schemaName")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "schemaName", valid_568315
  var valid_568316 = path.getOrDefault("databaseName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "databaseName", valid_568316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568317 = query.getOrDefault("api-version")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "api-version", valid_568317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568318: Call_CatalogGetProcedure_568311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified procedure from the Data Lake Analytics catalog.
  ## 
  let valid = call_568318.validator(path, query, header, formData, body)
  let scheme = call_568318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568318.url(scheme.get, call_568318.host, call_568318.base,
                         call_568318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568318, url, valid)

proc call*(call_568319: Call_CatalogGetProcedure_568311; apiVersion: string;
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
  var path_568320 = newJObject()
  var query_568321 = newJObject()
  add(query_568321, "api-version", newJString(apiVersion))
  add(path_568320, "procedureName", newJString(procedureName))
  add(path_568320, "schemaName", newJString(schemaName))
  add(path_568320, "databaseName", newJString(databaseName))
  result = call_568319.call(path_568320, query_568321, nil, nil, nil)

var catalogGetProcedure* = Call_CatalogGetProcedure_568311(
    name: "catalogGetProcedure", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/procedures/{procedureName}",
    validator: validate_CatalogGetProcedure_568312, base: "",
    url: url_CatalogGetProcedure_568313, schemes: {Scheme.Https})
type
  Call_CatalogListTables_568322 = ref object of OpenApiRestCall_567641
proc url_CatalogListTables_568324(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListTables_568323(path: JsonNode; query: JsonNode;
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
  var valid_568325 = path.getOrDefault("schemaName")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "schemaName", valid_568325
  var valid_568326 = path.getOrDefault("databaseName")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "databaseName", valid_568326
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var valid_568327 = query.getOrDefault("$orderby")
  valid_568327 = validateParameter(valid_568327, JString, required = false,
                                 default = nil)
  if valid_568327 != nil:
    section.add "$orderby", valid_568327
  var valid_568328 = query.getOrDefault("$expand")
  valid_568328 = validateParameter(valid_568328, JString, required = false,
                                 default = nil)
  if valid_568328 != nil:
    section.add "$expand", valid_568328
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568329 = query.getOrDefault("api-version")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "api-version", valid_568329
  var valid_568330 = query.getOrDefault("$top")
  valid_568330 = validateParameter(valid_568330, JInt, required = false, default = nil)
  if valid_568330 != nil:
    section.add "$top", valid_568330
  var valid_568331 = query.getOrDefault("$select")
  valid_568331 = validateParameter(valid_568331, JString, required = false,
                                 default = nil)
  if valid_568331 != nil:
    section.add "$select", valid_568331
  var valid_568332 = query.getOrDefault("$skip")
  valid_568332 = validateParameter(valid_568332, JInt, required = false, default = nil)
  if valid_568332 != nil:
    section.add "$skip", valid_568332
  var valid_568333 = query.getOrDefault("$count")
  valid_568333 = validateParameter(valid_568333, JBool, required = false, default = nil)
  if valid_568333 != nil:
    section.add "$count", valid_568333
  var valid_568334 = query.getOrDefault("$filter")
  valid_568334 = validateParameter(valid_568334, JString, required = false,
                                 default = nil)
  if valid_568334 != nil:
    section.add "$filter", valid_568334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568335: Call_CatalogListTables_568322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of tables from the Data Lake Analytics catalog.
  ## 
  let valid = call_568335.validator(path, query, header, formData, body)
  let scheme = call_568335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568335.url(scheme.get, call_568335.host, call_568335.base,
                         call_568335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568335, url, valid)

proc call*(call_568336: Call_CatalogListTables_568322; apiVersion: string;
          schemaName: string; databaseName: string; Orderby: string = "";
          Expand: string = ""; Top: int = 0; Select: string = ""; Skip: int = 0;
          Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListTables
  ## Retrieves the list of tables from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568337 = newJObject()
  var query_568338 = newJObject()
  add(query_568338, "$orderby", newJString(Orderby))
  add(query_568338, "$expand", newJString(Expand))
  add(query_568338, "api-version", newJString(apiVersion))
  add(query_568338, "$top", newJInt(Top))
  add(path_568337, "schemaName", newJString(schemaName))
  add(query_568338, "$select", newJString(Select))
  add(path_568337, "databaseName", newJString(databaseName))
  add(query_568338, "$skip", newJInt(Skip))
  add(query_568338, "$count", newJBool(Count))
  add(query_568338, "$filter", newJString(Filter))
  result = call_568336.call(path_568337, query_568338, nil, nil, nil)

var catalogListTables* = Call_CatalogListTables_568322(name: "catalogListTables",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables",
    validator: validate_CatalogListTables_568323, base: "",
    url: url_CatalogListTables_568324, schemes: {Scheme.Https})
type
  Call_CatalogGetTable_568339 = ref object of OpenApiRestCall_567641
proc url_CatalogGetTable_568341(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetTable_568340(path: JsonNode; query: JsonNode;
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
  var valid_568342 = path.getOrDefault("schemaName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "schemaName", valid_568342
  var valid_568343 = path.getOrDefault("tableName")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "tableName", valid_568343
  var valid_568344 = path.getOrDefault("databaseName")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "databaseName", valid_568344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568345 = query.getOrDefault("api-version")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "api-version", valid_568345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568346: Call_CatalogGetTable_568339; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table from the Data Lake Analytics catalog.
  ## 
  let valid = call_568346.validator(path, query, header, formData, body)
  let scheme = call_568346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568346.url(scheme.get, call_568346.host, call_568346.base,
                         call_568346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568346, url, valid)

proc call*(call_568347: Call_CatalogGetTable_568339; apiVersion: string;
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
  var path_568348 = newJObject()
  var query_568349 = newJObject()
  add(query_568349, "api-version", newJString(apiVersion))
  add(path_568348, "schemaName", newJString(schemaName))
  add(path_568348, "tableName", newJString(tableName))
  add(path_568348, "databaseName", newJString(databaseName))
  result = call_568347.call(path_568348, query_568349, nil, nil, nil)

var catalogGetTable* = Call_CatalogGetTable_568339(name: "catalogGetTable",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}",
    validator: validate_CatalogGetTable_568340, base: "", url: url_CatalogGetTable_568341,
    schemes: {Scheme.Https})
type
  Call_CatalogListTablePartitions_568350 = ref object of OpenApiRestCall_567641
proc url_CatalogListTablePartitions_568352(protocol: Scheme; host: string;
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

proc validate_CatalogListTablePartitions_568351(path: JsonNode; query: JsonNode;
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
  var valid_568353 = path.getOrDefault("schemaName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "schemaName", valid_568353
  var valid_568354 = path.getOrDefault("tableName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "tableName", valid_568354
  var valid_568355 = path.getOrDefault("databaseName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "databaseName", valid_568355
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var valid_568356 = query.getOrDefault("$orderby")
  valid_568356 = validateParameter(valid_568356, JString, required = false,
                                 default = nil)
  if valid_568356 != nil:
    section.add "$orderby", valid_568356
  var valid_568357 = query.getOrDefault("$expand")
  valid_568357 = validateParameter(valid_568357, JString, required = false,
                                 default = nil)
  if valid_568357 != nil:
    section.add "$expand", valid_568357
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568358 = query.getOrDefault("api-version")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "api-version", valid_568358
  var valid_568359 = query.getOrDefault("$top")
  valid_568359 = validateParameter(valid_568359, JInt, required = false, default = nil)
  if valid_568359 != nil:
    section.add "$top", valid_568359
  var valid_568360 = query.getOrDefault("$select")
  valid_568360 = validateParameter(valid_568360, JString, required = false,
                                 default = nil)
  if valid_568360 != nil:
    section.add "$select", valid_568360
  var valid_568361 = query.getOrDefault("$skip")
  valid_568361 = validateParameter(valid_568361, JInt, required = false, default = nil)
  if valid_568361 != nil:
    section.add "$skip", valid_568361
  var valid_568362 = query.getOrDefault("$count")
  valid_568362 = validateParameter(valid_568362, JBool, required = false, default = nil)
  if valid_568362 != nil:
    section.add "$count", valid_568362
  var valid_568363 = query.getOrDefault("$filter")
  valid_568363 = validateParameter(valid_568363, JString, required = false,
                                 default = nil)
  if valid_568363 != nil:
    section.add "$filter", valid_568363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568364: Call_CatalogListTablePartitions_568350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table partitions from the Data Lake Analytics catalog.
  ## 
  let valid = call_568364.validator(path, query, header, formData, body)
  let scheme = call_568364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568364.url(scheme.get, call_568364.host, call_568364.base,
                         call_568364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568364, url, valid)

proc call*(call_568365: Call_CatalogListTablePartitions_568350; apiVersion: string;
          schemaName: string; tableName: string; databaseName: string;
          Orderby: string = ""; Expand: string = ""; Top: int = 0; Select: string = "";
          Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListTablePartitions
  ## Retrieves the list of table partitions from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_568366 = newJObject()
  var query_568367 = newJObject()
  add(query_568367, "$orderby", newJString(Orderby))
  add(query_568367, "$expand", newJString(Expand))
  add(query_568367, "api-version", newJString(apiVersion))
  add(query_568367, "$top", newJInt(Top))
  add(path_568366, "schemaName", newJString(schemaName))
  add(path_568366, "tableName", newJString(tableName))
  add(query_568367, "$select", newJString(Select))
  add(path_568366, "databaseName", newJString(databaseName))
  add(query_568367, "$skip", newJInt(Skip))
  add(query_568367, "$count", newJBool(Count))
  add(query_568367, "$filter", newJString(Filter))
  result = call_568365.call(path_568366, query_568367, nil, nil, nil)

var catalogListTablePartitions* = Call_CatalogListTablePartitions_568350(
    name: "catalogListTablePartitions", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/partitions",
    validator: validate_CatalogListTablePartitions_568351, base: "",
    url: url_CatalogListTablePartitions_568352, schemes: {Scheme.Https})
type
  Call_CatalogGetTablePartition_568368 = ref object of OpenApiRestCall_567641
proc url_CatalogGetTablePartition_568370(protocol: Scheme; host: string;
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

proc validate_CatalogGetTablePartition_568369(path: JsonNode; query: JsonNode;
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
  var valid_568371 = path.getOrDefault("schemaName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "schemaName", valid_568371
  var valid_568372 = path.getOrDefault("tableName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "tableName", valid_568372
  var valid_568373 = path.getOrDefault("databaseName")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "databaseName", valid_568373
  var valid_568374 = path.getOrDefault("partitionName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "partitionName", valid_568374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568375 = query.getOrDefault("api-version")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "api-version", valid_568375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568376: Call_CatalogGetTablePartition_568368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table partition from the Data Lake Analytics catalog.
  ## 
  let valid = call_568376.validator(path, query, header, formData, body)
  let scheme = call_568376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568376.url(scheme.get, call_568376.host, call_568376.base,
                         call_568376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568376, url, valid)

proc call*(call_568377: Call_CatalogGetTablePartition_568368; apiVersion: string;
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
  var path_568378 = newJObject()
  var query_568379 = newJObject()
  add(query_568379, "api-version", newJString(apiVersion))
  add(path_568378, "schemaName", newJString(schemaName))
  add(path_568378, "tableName", newJString(tableName))
  add(path_568378, "databaseName", newJString(databaseName))
  add(path_568378, "partitionName", newJString(partitionName))
  result = call_568377.call(path_568378, query_568379, nil, nil, nil)

var catalogGetTablePartition* = Call_CatalogGetTablePartition_568368(
    name: "catalogGetTablePartition", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/partitions/{partitionName}",
    validator: validate_CatalogGetTablePartition_568369, base: "",
    url: url_CatalogGetTablePartition_568370, schemes: {Scheme.Https})
type
  Call_CatalogListTableStatistics_568380 = ref object of OpenApiRestCall_567641
proc url_CatalogListTableStatistics_568382(protocol: Scheme; host: string;
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

proc validate_CatalogListTableStatistics_568381(path: JsonNode; query: JsonNode;
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
  var valid_568383 = path.getOrDefault("schemaName")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "schemaName", valid_568383
  var valid_568384 = path.getOrDefault("tableName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "tableName", valid_568384
  var valid_568385 = path.getOrDefault("databaseName")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "databaseName", valid_568385
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var valid_568386 = query.getOrDefault("$orderby")
  valid_568386 = validateParameter(valid_568386, JString, required = false,
                                 default = nil)
  if valid_568386 != nil:
    section.add "$orderby", valid_568386
  var valid_568387 = query.getOrDefault("$expand")
  valid_568387 = validateParameter(valid_568387, JString, required = false,
                                 default = nil)
  if valid_568387 != nil:
    section.add "$expand", valid_568387
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568388 = query.getOrDefault("api-version")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "api-version", valid_568388
  var valid_568389 = query.getOrDefault("$top")
  valid_568389 = validateParameter(valid_568389, JInt, required = false, default = nil)
  if valid_568389 != nil:
    section.add "$top", valid_568389
  var valid_568390 = query.getOrDefault("$select")
  valid_568390 = validateParameter(valid_568390, JString, required = false,
                                 default = nil)
  if valid_568390 != nil:
    section.add "$select", valid_568390
  var valid_568391 = query.getOrDefault("$skip")
  valid_568391 = validateParameter(valid_568391, JInt, required = false, default = nil)
  if valid_568391 != nil:
    section.add "$skip", valid_568391
  var valid_568392 = query.getOrDefault("$count")
  valid_568392 = validateParameter(valid_568392, JBool, required = false, default = nil)
  if valid_568392 != nil:
    section.add "$count", valid_568392
  var valid_568393 = query.getOrDefault("$filter")
  valid_568393 = validateParameter(valid_568393, JString, required = false,
                                 default = nil)
  if valid_568393 != nil:
    section.add "$filter", valid_568393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568394: Call_CatalogListTableStatistics_568380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table statistics from the Data Lake Analytics catalog.
  ## 
  let valid = call_568394.validator(path, query, header, formData, body)
  let scheme = call_568394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568394.url(scheme.get, call_568394.host, call_568394.base,
                         call_568394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568394, url, valid)

proc call*(call_568395: Call_CatalogListTableStatistics_568380; apiVersion: string;
          schemaName: string; tableName: string; databaseName: string;
          Orderby: string = ""; Expand: string = ""; Top: int = 0; Select: string = "";
          Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListTableStatistics
  ## Retrieves the list of table statistics from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_568396 = newJObject()
  var query_568397 = newJObject()
  add(query_568397, "$orderby", newJString(Orderby))
  add(query_568397, "$expand", newJString(Expand))
  add(query_568397, "api-version", newJString(apiVersion))
  add(query_568397, "$top", newJInt(Top))
  add(path_568396, "schemaName", newJString(schemaName))
  add(path_568396, "tableName", newJString(tableName))
  add(query_568397, "$select", newJString(Select))
  add(path_568396, "databaseName", newJString(databaseName))
  add(query_568397, "$skip", newJInt(Skip))
  add(query_568397, "$count", newJBool(Count))
  add(query_568397, "$filter", newJString(Filter))
  result = call_568395.call(path_568396, query_568397, nil, nil, nil)

var catalogListTableStatistics* = Call_CatalogListTableStatistics_568380(
    name: "catalogListTableStatistics", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/statistics",
    validator: validate_CatalogListTableStatistics_568381, base: "",
    url: url_CatalogListTableStatistics_568382, schemes: {Scheme.Https})
type
  Call_CatalogGetTableStatistic_568398 = ref object of OpenApiRestCall_567641
proc url_CatalogGetTableStatistic_568400(protocol: Scheme; host: string;
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

proc validate_CatalogGetTableStatistic_568399(path: JsonNode; query: JsonNode;
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
  var valid_568401 = path.getOrDefault("statisticsName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "statisticsName", valid_568401
  var valid_568402 = path.getOrDefault("schemaName")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "schemaName", valid_568402
  var valid_568403 = path.getOrDefault("tableName")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "tableName", valid_568403
  var valid_568404 = path.getOrDefault("databaseName")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "databaseName", valid_568404
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568405 = query.getOrDefault("api-version")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "api-version", valid_568405
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568406: Call_CatalogGetTableStatistic_568398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table statistics from the Data Lake Analytics catalog.
  ## 
  let valid = call_568406.validator(path, query, header, formData, body)
  let scheme = call_568406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568406.url(scheme.get, call_568406.host, call_568406.base,
                         call_568406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568406, url, valid)

proc call*(call_568407: Call_CatalogGetTableStatistic_568398;
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
  var path_568408 = newJObject()
  var query_568409 = newJObject()
  add(path_568408, "statisticsName", newJString(statisticsName))
  add(query_568409, "api-version", newJString(apiVersion))
  add(path_568408, "schemaName", newJString(schemaName))
  add(path_568408, "tableName", newJString(tableName))
  add(path_568408, "databaseName", newJString(databaseName))
  result = call_568407.call(path_568408, query_568409, nil, nil, nil)

var catalogGetTableStatistic* = Call_CatalogGetTableStatistic_568398(
    name: "catalogGetTableStatistic", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/statistics/{statisticsName}",
    validator: validate_CatalogGetTableStatistic_568399, base: "",
    url: url_CatalogGetTableStatistic_568400, schemes: {Scheme.Https})
type
  Call_CatalogListTableTypes_568410 = ref object of OpenApiRestCall_567641
proc url_CatalogListTableTypes_568412(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListTableTypes_568411(path: JsonNode; query: JsonNode;
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
  var valid_568413 = path.getOrDefault("schemaName")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "schemaName", valid_568413
  var valid_568414 = path.getOrDefault("databaseName")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "databaseName", valid_568414
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var valid_568415 = query.getOrDefault("$orderby")
  valid_568415 = validateParameter(valid_568415, JString, required = false,
                                 default = nil)
  if valid_568415 != nil:
    section.add "$orderby", valid_568415
  var valid_568416 = query.getOrDefault("$expand")
  valid_568416 = validateParameter(valid_568416, JString, required = false,
                                 default = nil)
  if valid_568416 != nil:
    section.add "$expand", valid_568416
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568417 = query.getOrDefault("api-version")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "api-version", valid_568417
  var valid_568418 = query.getOrDefault("$top")
  valid_568418 = validateParameter(valid_568418, JInt, required = false, default = nil)
  if valid_568418 != nil:
    section.add "$top", valid_568418
  var valid_568419 = query.getOrDefault("$select")
  valid_568419 = validateParameter(valid_568419, JString, required = false,
                                 default = nil)
  if valid_568419 != nil:
    section.add "$select", valid_568419
  var valid_568420 = query.getOrDefault("$skip")
  valid_568420 = validateParameter(valid_568420, JInt, required = false, default = nil)
  if valid_568420 != nil:
    section.add "$skip", valid_568420
  var valid_568421 = query.getOrDefault("$count")
  valid_568421 = validateParameter(valid_568421, JBool, required = false, default = nil)
  if valid_568421 != nil:
    section.add "$count", valid_568421
  var valid_568422 = query.getOrDefault("$filter")
  valid_568422 = validateParameter(valid_568422, JString, required = false,
                                 default = nil)
  if valid_568422 != nil:
    section.add "$filter", valid_568422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568423: Call_CatalogListTableTypes_568410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table types from the Data Lake Analytics catalog.
  ## 
  let valid = call_568423.validator(path, query, header, formData, body)
  let scheme = call_568423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568423.url(scheme.get, call_568423.host, call_568423.base,
                         call_568423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568423, url, valid)

proc call*(call_568424: Call_CatalogListTableTypes_568410; apiVersion: string;
          schemaName: string; databaseName: string; Orderby: string = "";
          Expand: string = ""; Top: int = 0; Select: string = ""; Skip: int = 0;
          Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListTableTypes
  ## Retrieves the list of table types from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_568425 = newJObject()
  var query_568426 = newJObject()
  add(query_568426, "$orderby", newJString(Orderby))
  add(query_568426, "$expand", newJString(Expand))
  add(query_568426, "api-version", newJString(apiVersion))
  add(query_568426, "$top", newJInt(Top))
  add(path_568425, "schemaName", newJString(schemaName))
  add(query_568426, "$select", newJString(Select))
  add(path_568425, "databaseName", newJString(databaseName))
  add(query_568426, "$skip", newJInt(Skip))
  add(query_568426, "$count", newJBool(Count))
  add(query_568426, "$filter", newJString(Filter))
  result = call_568424.call(path_568425, query_568426, nil, nil, nil)

var catalogListTableTypes* = Call_CatalogListTableTypes_568410(
    name: "catalogListTableTypes", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tabletypes",
    validator: validate_CatalogListTableTypes_568411, base: "",
    url: url_CatalogListTableTypes_568412, schemes: {Scheme.Https})
type
  Call_CatalogGetTableType_568427 = ref object of OpenApiRestCall_567641
proc url_CatalogGetTableType_568429(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetTableType_568428(path: JsonNode; query: JsonNode;
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
  var valid_568430 = path.getOrDefault("schemaName")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "schemaName", valid_568430
  var valid_568431 = path.getOrDefault("databaseName")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "databaseName", valid_568431
  var valid_568432 = path.getOrDefault("tableTypeName")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "tableTypeName", valid_568432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568433 = query.getOrDefault("api-version")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "api-version", valid_568433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568434: Call_CatalogGetTableType_568427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table type from the Data Lake Analytics catalog.
  ## 
  let valid = call_568434.validator(path, query, header, formData, body)
  let scheme = call_568434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568434.url(scheme.get, call_568434.host, call_568434.base,
                         call_568434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568434, url, valid)

proc call*(call_568435: Call_CatalogGetTableType_568427; apiVersion: string;
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
  var path_568436 = newJObject()
  var query_568437 = newJObject()
  add(query_568437, "api-version", newJString(apiVersion))
  add(path_568436, "schemaName", newJString(schemaName))
  add(path_568436, "databaseName", newJString(databaseName))
  add(path_568436, "tableTypeName", newJString(tableTypeName))
  result = call_568435.call(path_568436, query_568437, nil, nil, nil)

var catalogGetTableType* = Call_CatalogGetTableType_568427(
    name: "catalogGetTableType", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tabletypes/{tableTypeName}",
    validator: validate_CatalogGetTableType_568428, base: "",
    url: url_CatalogGetTableType_568429, schemes: {Scheme.Https})
type
  Call_CatalogListTableValuedFunctions_568438 = ref object of OpenApiRestCall_567641
proc url_CatalogListTableValuedFunctions_568440(protocol: Scheme; host: string;
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

proc validate_CatalogListTableValuedFunctions_568439(path: JsonNode;
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
  var valid_568441 = path.getOrDefault("schemaName")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "schemaName", valid_568441
  var valid_568442 = path.getOrDefault("databaseName")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "databaseName", valid_568442
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var valid_568443 = query.getOrDefault("$orderby")
  valid_568443 = validateParameter(valid_568443, JString, required = false,
                                 default = nil)
  if valid_568443 != nil:
    section.add "$orderby", valid_568443
  var valid_568444 = query.getOrDefault("$expand")
  valid_568444 = validateParameter(valid_568444, JString, required = false,
                                 default = nil)
  if valid_568444 != nil:
    section.add "$expand", valid_568444
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568445 = query.getOrDefault("api-version")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "api-version", valid_568445
  var valid_568446 = query.getOrDefault("$top")
  valid_568446 = validateParameter(valid_568446, JInt, required = false, default = nil)
  if valid_568446 != nil:
    section.add "$top", valid_568446
  var valid_568447 = query.getOrDefault("$select")
  valid_568447 = validateParameter(valid_568447, JString, required = false,
                                 default = nil)
  if valid_568447 != nil:
    section.add "$select", valid_568447
  var valid_568448 = query.getOrDefault("$skip")
  valid_568448 = validateParameter(valid_568448, JInt, required = false, default = nil)
  if valid_568448 != nil:
    section.add "$skip", valid_568448
  var valid_568449 = query.getOrDefault("$count")
  valid_568449 = validateParameter(valid_568449, JBool, required = false, default = nil)
  if valid_568449 != nil:
    section.add "$count", valid_568449
  var valid_568450 = query.getOrDefault("$filter")
  valid_568450 = validateParameter(valid_568450, JString, required = false,
                                 default = nil)
  if valid_568450 != nil:
    section.add "$filter", valid_568450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568451: Call_CatalogListTableValuedFunctions_568438;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of table valued functions from the Data Lake Analytics catalog.
  ## 
  let valid = call_568451.validator(path, query, header, formData, body)
  let scheme = call_568451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568451.url(scheme.get, call_568451.host, call_568451.base,
                         call_568451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568451, url, valid)

proc call*(call_568452: Call_CatalogListTableValuedFunctions_568438;
          apiVersion: string; schemaName: string; databaseName: string;
          Orderby: string = ""; Expand: string = ""; Top: int = 0; Select: string = "";
          Skip: int = 0; Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListTableValuedFunctions
  ## Retrieves the list of table valued functions from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_568453 = newJObject()
  var query_568454 = newJObject()
  add(query_568454, "$orderby", newJString(Orderby))
  add(query_568454, "$expand", newJString(Expand))
  add(query_568454, "api-version", newJString(apiVersion))
  add(query_568454, "$top", newJInt(Top))
  add(path_568453, "schemaName", newJString(schemaName))
  add(query_568454, "$select", newJString(Select))
  add(path_568453, "databaseName", newJString(databaseName))
  add(query_568454, "$skip", newJInt(Skip))
  add(query_568454, "$count", newJBool(Count))
  add(query_568454, "$filter", newJString(Filter))
  result = call_568452.call(path_568453, query_568454, nil, nil, nil)

var catalogListTableValuedFunctions* = Call_CatalogListTableValuedFunctions_568438(
    name: "catalogListTableValuedFunctions", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tablevaluedfunctions",
    validator: validate_CatalogListTableValuedFunctions_568439, base: "",
    url: url_CatalogListTableValuedFunctions_568440, schemes: {Scheme.Https})
type
  Call_CatalogGetTableValuedFunction_568455 = ref object of OpenApiRestCall_567641
proc url_CatalogGetTableValuedFunction_568457(protocol: Scheme; host: string;
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

proc validate_CatalogGetTableValuedFunction_568456(path: JsonNode; query: JsonNode;
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
  var valid_568458 = path.getOrDefault("tableValuedFunctionName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "tableValuedFunctionName", valid_568458
  var valid_568459 = path.getOrDefault("schemaName")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "schemaName", valid_568459
  var valid_568460 = path.getOrDefault("databaseName")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "databaseName", valid_568460
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568461 = query.getOrDefault("api-version")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "api-version", valid_568461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568462: Call_CatalogGetTableValuedFunction_568455; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table valued function from the Data Lake Analytics catalog.
  ## 
  let valid = call_568462.validator(path, query, header, formData, body)
  let scheme = call_568462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568462.url(scheme.get, call_568462.host, call_568462.base,
                         call_568462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568462, url, valid)

proc call*(call_568463: Call_CatalogGetTableValuedFunction_568455;
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
  var path_568464 = newJObject()
  var query_568465 = newJObject()
  add(query_568465, "api-version", newJString(apiVersion))
  add(path_568464, "tableValuedFunctionName", newJString(tableValuedFunctionName))
  add(path_568464, "schemaName", newJString(schemaName))
  add(path_568464, "databaseName", newJString(databaseName))
  result = call_568463.call(path_568464, query_568465, nil, nil, nil)

var catalogGetTableValuedFunction* = Call_CatalogGetTableValuedFunction_568455(
    name: "catalogGetTableValuedFunction", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tablevaluedfunctions/{tableValuedFunctionName}",
    validator: validate_CatalogGetTableValuedFunction_568456, base: "",
    url: url_CatalogGetTableValuedFunction_568457, schemes: {Scheme.Https})
type
  Call_CatalogListTypes_568466 = ref object of OpenApiRestCall_567641
proc url_CatalogListTypes_568468(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListTypes_568467(path: JsonNode; query: JsonNode;
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
  var valid_568469 = path.getOrDefault("schemaName")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "schemaName", valid_568469
  var valid_568470 = path.getOrDefault("databaseName")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "databaseName", valid_568470
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var valid_568471 = query.getOrDefault("$orderby")
  valid_568471 = validateParameter(valid_568471, JString, required = false,
                                 default = nil)
  if valid_568471 != nil:
    section.add "$orderby", valid_568471
  var valid_568472 = query.getOrDefault("$expand")
  valid_568472 = validateParameter(valid_568472, JString, required = false,
                                 default = nil)
  if valid_568472 != nil:
    section.add "$expand", valid_568472
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568473 = query.getOrDefault("api-version")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "api-version", valid_568473
  var valid_568474 = query.getOrDefault("$top")
  valid_568474 = validateParameter(valid_568474, JInt, required = false, default = nil)
  if valid_568474 != nil:
    section.add "$top", valid_568474
  var valid_568475 = query.getOrDefault("$select")
  valid_568475 = validateParameter(valid_568475, JString, required = false,
                                 default = nil)
  if valid_568475 != nil:
    section.add "$select", valid_568475
  var valid_568476 = query.getOrDefault("$skip")
  valid_568476 = validateParameter(valid_568476, JInt, required = false, default = nil)
  if valid_568476 != nil:
    section.add "$skip", valid_568476
  var valid_568477 = query.getOrDefault("$count")
  valid_568477 = validateParameter(valid_568477, JBool, required = false, default = nil)
  if valid_568477 != nil:
    section.add "$count", valid_568477
  var valid_568478 = query.getOrDefault("$filter")
  valid_568478 = validateParameter(valid_568478, JString, required = false,
                                 default = nil)
  if valid_568478 != nil:
    section.add "$filter", valid_568478
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568479: Call_CatalogListTypes_568466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of types within the specified database and schema from the Data Lake Analytics catalog.
  ## 
  let valid = call_568479.validator(path, query, header, formData, body)
  let scheme = call_568479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568479.url(scheme.get, call_568479.host, call_568479.base,
                         call_568479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568479, url, valid)

proc call*(call_568480: Call_CatalogListTypes_568466; apiVersion: string;
          schemaName: string; databaseName: string; Orderby: string = "";
          Expand: string = ""; Top: int = 0; Select: string = ""; Skip: int = 0;
          Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListTypes
  ## Retrieves the list of types within the specified database and schema from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_568481 = newJObject()
  var query_568482 = newJObject()
  add(query_568482, "$orderby", newJString(Orderby))
  add(query_568482, "$expand", newJString(Expand))
  add(query_568482, "api-version", newJString(apiVersion))
  add(query_568482, "$top", newJInt(Top))
  add(path_568481, "schemaName", newJString(schemaName))
  add(query_568482, "$select", newJString(Select))
  add(path_568481, "databaseName", newJString(databaseName))
  add(query_568482, "$skip", newJInt(Skip))
  add(query_568482, "$count", newJBool(Count))
  add(query_568482, "$filter", newJString(Filter))
  result = call_568480.call(path_568481, query_568482, nil, nil, nil)

var catalogListTypes* = Call_CatalogListTypes_568466(name: "catalogListTypes",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/types",
    validator: validate_CatalogListTypes_568467, base: "",
    url: url_CatalogListTypes_568468, schemes: {Scheme.Https})
type
  Call_CatalogListViews_568483 = ref object of OpenApiRestCall_567641
proc url_CatalogListViews_568485(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListViews_568484(path: JsonNode; query: JsonNode;
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
  var valid_568486 = path.getOrDefault("schemaName")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "schemaName", valid_568486
  var valid_568487 = path.getOrDefault("databaseName")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "databaseName", valid_568487
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var valid_568488 = query.getOrDefault("$orderby")
  valid_568488 = validateParameter(valid_568488, JString, required = false,
                                 default = nil)
  if valid_568488 != nil:
    section.add "$orderby", valid_568488
  var valid_568489 = query.getOrDefault("$expand")
  valid_568489 = validateParameter(valid_568489, JString, required = false,
                                 default = nil)
  if valid_568489 != nil:
    section.add "$expand", valid_568489
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568490 = query.getOrDefault("api-version")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "api-version", valid_568490
  var valid_568491 = query.getOrDefault("$top")
  valid_568491 = validateParameter(valid_568491, JInt, required = false, default = nil)
  if valid_568491 != nil:
    section.add "$top", valid_568491
  var valid_568492 = query.getOrDefault("$select")
  valid_568492 = validateParameter(valid_568492, JString, required = false,
                                 default = nil)
  if valid_568492 != nil:
    section.add "$select", valid_568492
  var valid_568493 = query.getOrDefault("$skip")
  valid_568493 = validateParameter(valid_568493, JInt, required = false, default = nil)
  if valid_568493 != nil:
    section.add "$skip", valid_568493
  var valid_568494 = query.getOrDefault("$count")
  valid_568494 = validateParameter(valid_568494, JBool, required = false, default = nil)
  if valid_568494 != nil:
    section.add "$count", valid_568494
  var valid_568495 = query.getOrDefault("$filter")
  valid_568495 = validateParameter(valid_568495, JString, required = false,
                                 default = nil)
  if valid_568495 != nil:
    section.add "$filter", valid_568495
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568496: Call_CatalogListViews_568483; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of views from the Data Lake Analytics catalog.
  ## 
  let valid = call_568496.validator(path, query, header, formData, body)
  let scheme = call_568496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568496.url(scheme.get, call_568496.host, call_568496.base,
                         call_568496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568496, url, valid)

proc call*(call_568497: Call_CatalogListViews_568483; apiVersion: string;
          schemaName: string; databaseName: string; Orderby: string = "";
          Expand: string = ""; Top: int = 0; Select: string = ""; Skip: int = 0;
          Count: bool = false; Filter: string = ""): Recallable =
  ## catalogListViews
  ## Retrieves the list of views from the Data Lake Analytics catalog.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_568498 = newJObject()
  var query_568499 = newJObject()
  add(query_568499, "$orderby", newJString(Orderby))
  add(query_568499, "$expand", newJString(Expand))
  add(query_568499, "api-version", newJString(apiVersion))
  add(query_568499, "$top", newJInt(Top))
  add(path_568498, "schemaName", newJString(schemaName))
  add(query_568499, "$select", newJString(Select))
  add(path_568498, "databaseName", newJString(databaseName))
  add(query_568499, "$skip", newJInt(Skip))
  add(query_568499, "$count", newJBool(Count))
  add(query_568499, "$filter", newJString(Filter))
  result = call_568497.call(path_568498, query_568499, nil, nil, nil)

var catalogListViews* = Call_CatalogListViews_568483(name: "catalogListViews",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/views",
    validator: validate_CatalogListViews_568484, base: "",
    url: url_CatalogListViews_568485, schemes: {Scheme.Https})
type
  Call_CatalogGetView_568500 = ref object of OpenApiRestCall_567641
proc url_CatalogGetView_568502(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetView_568501(path: JsonNode; query: JsonNode;
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
  var valid_568503 = path.getOrDefault("viewName")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "viewName", valid_568503
  var valid_568504 = path.getOrDefault("schemaName")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "schemaName", valid_568504
  var valid_568505 = path.getOrDefault("databaseName")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "databaseName", valid_568505
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568506 = query.getOrDefault("api-version")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "api-version", valid_568506
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568507: Call_CatalogGetView_568500; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified view from the Data Lake Analytics catalog.
  ## 
  let valid = call_568507.validator(path, query, header, formData, body)
  let scheme = call_568507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568507.url(scheme.get, call_568507.host, call_568507.base,
                         call_568507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568507, url, valid)

proc call*(call_568508: Call_CatalogGetView_568500; apiVersion: string;
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
  var path_568509 = newJObject()
  var query_568510 = newJObject()
  add(query_568510, "api-version", newJString(apiVersion))
  add(path_568509, "viewName", newJString(viewName))
  add(path_568509, "schemaName", newJString(schemaName))
  add(path_568509, "databaseName", newJString(databaseName))
  result = call_568508.call(path_568509, query_568510, nil, nil, nil)

var catalogGetView* = Call_CatalogGetView_568500(name: "catalogGetView",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/views/{viewName}",
    validator: validate_CatalogGetView_568501, base: "", url: url_CatalogGetView_568502,
    schemes: {Scheme.Https})
type
  Call_CatalogDeleteAllSecrets_568511 = ref object of OpenApiRestCall_567641
proc url_CatalogDeleteAllSecrets_568513(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogDeleteAllSecrets_568512(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes all secrets in the specified database
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   databaseName: JString (required)
  ##               : The name of the database containing the secret.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `databaseName` field"
  var valid_568514 = path.getOrDefault("databaseName")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "databaseName", valid_568514
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568515 = query.getOrDefault("api-version")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "api-version", valid_568515
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568516: Call_CatalogDeleteAllSecrets_568511; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes all secrets in the specified database
  ## 
  let valid = call_568516.validator(path, query, header, formData, body)
  let scheme = call_568516.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568516.url(scheme.get, call_568516.host, call_568516.base,
                         call_568516.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568516, url, valid)

proc call*(call_568517: Call_CatalogDeleteAllSecrets_568511; apiVersion: string;
          databaseName: string): Recallable =
  ## catalogDeleteAllSecrets
  ## Deletes all secrets in the specified database
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  var path_568518 = newJObject()
  var query_568519 = newJObject()
  add(query_568519, "api-version", newJString(apiVersion))
  add(path_568518, "databaseName", newJString(databaseName))
  result = call_568517.call(path_568518, query_568519, nil, nil, nil)

var catalogDeleteAllSecrets* = Call_CatalogDeleteAllSecrets_568511(
    name: "catalogDeleteAllSecrets", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/secrets",
    validator: validate_CatalogDeleteAllSecrets_568512, base: "",
    url: url_CatalogDeleteAllSecrets_568513, schemes: {Scheme.Https})
type
  Call_CatalogCreateSecret_568530 = ref object of OpenApiRestCall_567641
proc url_CatalogCreateSecret_568532(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogCreateSecret_568531(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates the specified secret for use with external data sources in the specified database.
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
  var valid_568550 = path.getOrDefault("databaseName")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "databaseName", valid_568550
  var valid_568551 = path.getOrDefault("secretName")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "secretName", valid_568551
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568552 = query.getOrDefault("api-version")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "api-version", valid_568552
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

proc call*(call_568554: Call_CatalogCreateSecret_568530; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the specified secret for use with external data sources in the specified database.
  ## 
  let valid = call_568554.validator(path, query, header, formData, body)
  let scheme = call_568554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568554.url(scheme.get, call_568554.host, call_568554.base,
                         call_568554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568554, url, valid)

proc call*(call_568555: Call_CatalogCreateSecret_568530; apiVersion: string;
          databaseName: string; parameters: JsonNode; secretName: string): Recallable =
  ## catalogCreateSecret
  ## Creates the specified secret for use with external data sources in the specified database.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database in which to create the secret.
  ##   parameters: JObject (required)
  ##             : The parameters required to create the secret (name and password)
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_568556 = newJObject()
  var query_568557 = newJObject()
  var body_568558 = newJObject()
  add(query_568557, "api-version", newJString(apiVersion))
  add(path_568556, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_568558 = parameters
  add(path_568556, "secretName", newJString(secretName))
  result = call_568555.call(path_568556, query_568557, nil, nil, body_568558)

var catalogCreateSecret* = Call_CatalogCreateSecret_568530(
    name: "catalogCreateSecret", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogCreateSecret_568531, base: "",
    url: url_CatalogCreateSecret_568532, schemes: {Scheme.Https})
type
  Call_CatalogGetSecret_568520 = ref object of OpenApiRestCall_567641
proc url_CatalogGetSecret_568522(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetSecret_568521(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the specified secret in the specified database
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
  var valid_568523 = path.getOrDefault("databaseName")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "databaseName", valid_568523
  var valid_568524 = path.getOrDefault("secretName")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = nil)
  if valid_568524 != nil:
    section.add "secretName", valid_568524
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568525 = query.getOrDefault("api-version")
  valid_568525 = validateParameter(valid_568525, JString, required = true,
                                 default = nil)
  if valid_568525 != nil:
    section.add "api-version", valid_568525
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568526: Call_CatalogGetSecret_568520; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified secret in the specified database
  ## 
  let valid = call_568526.validator(path, query, header, formData, body)
  let scheme = call_568526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568526.url(scheme.get, call_568526.host, call_568526.base,
                         call_568526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568526, url, valid)

proc call*(call_568527: Call_CatalogGetSecret_568520; apiVersion: string;
          databaseName: string; secretName: string): Recallable =
  ## catalogGetSecret
  ## Gets the specified secret in the specified database
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  ##   secretName: string (required)
  ##             : The name of the secret to get
  var path_568528 = newJObject()
  var query_568529 = newJObject()
  add(query_568529, "api-version", newJString(apiVersion))
  add(path_568528, "databaseName", newJString(databaseName))
  add(path_568528, "secretName", newJString(secretName))
  result = call_568527.call(path_568528, query_568529, nil, nil, nil)

var catalogGetSecret* = Call_CatalogGetSecret_568520(name: "catalogGetSecret",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogGetSecret_568521, base: "",
    url: url_CatalogGetSecret_568522, schemes: {Scheme.Https})
type
  Call_CatalogUpdateSecret_568569 = ref object of OpenApiRestCall_567641
proc url_CatalogUpdateSecret_568571(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogUpdateSecret_568570(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Modifies the specified secret for use with external data sources in the specified database
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
  var valid_568572 = path.getOrDefault("databaseName")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "databaseName", valid_568572
  var valid_568573 = path.getOrDefault("secretName")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "secretName", valid_568573
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568574 = query.getOrDefault("api-version")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "api-version", valid_568574
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

proc call*(call_568576: Call_CatalogUpdateSecret_568569; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the specified secret for use with external data sources in the specified database
  ## 
  let valid = call_568576.validator(path, query, header, formData, body)
  let scheme = call_568576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568576.url(scheme.get, call_568576.host, call_568576.base,
                         call_568576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568576, url, valid)

proc call*(call_568577: Call_CatalogUpdateSecret_568569; apiVersion: string;
          databaseName: string; parameters: JsonNode; secretName: string): Recallable =
  ## catalogUpdateSecret
  ## Modifies the specified secret for use with external data sources in the specified database
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  ##   parameters: JObject (required)
  ##             : The parameters required to modify the secret (name and password)
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_568578 = newJObject()
  var query_568579 = newJObject()
  var body_568580 = newJObject()
  add(query_568579, "api-version", newJString(apiVersion))
  add(path_568578, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_568580 = parameters
  add(path_568578, "secretName", newJString(secretName))
  result = call_568577.call(path_568578, query_568579, nil, nil, body_568580)

var catalogUpdateSecret* = Call_CatalogUpdateSecret_568569(
    name: "catalogUpdateSecret", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogUpdateSecret_568570, base: "",
    url: url_CatalogUpdateSecret_568571, schemes: {Scheme.Https})
type
  Call_CatalogDeleteSecret_568559 = ref object of OpenApiRestCall_567641
proc url_CatalogDeleteSecret_568561(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogDeleteSecret_568560(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the specified secret in the specified database
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
  var valid_568562 = path.getOrDefault("databaseName")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "databaseName", valid_568562
  var valid_568563 = path.getOrDefault("secretName")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "secretName", valid_568563
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568564 = query.getOrDefault("api-version")
  valid_568564 = validateParameter(valid_568564, JString, required = true,
                                 default = nil)
  if valid_568564 != nil:
    section.add "api-version", valid_568564
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568565: Call_CatalogDeleteSecret_568559; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified secret in the specified database
  ## 
  let valid = call_568565.validator(path, query, header, formData, body)
  let scheme = call_568565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568565.url(scheme.get, call_568565.host, call_568565.base,
                         call_568565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568565, url, valid)

proc call*(call_568566: Call_CatalogDeleteSecret_568559; apiVersion: string;
          databaseName: string; secretName: string): Recallable =
  ## catalogDeleteSecret
  ## Deletes the specified secret in the specified database
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  ##   secretName: string (required)
  ##             : The name of the secret to delete
  var path_568567 = newJObject()
  var query_568568 = newJObject()
  add(query_568568, "api-version", newJString(apiVersion))
  add(path_568567, "databaseName", newJString(databaseName))
  add(path_568567, "secretName", newJString(secretName))
  result = call_568566.call(path_568567, query_568568, nil, nil, nil)

var catalogDeleteSecret* = Call_CatalogDeleteSecret_568559(
    name: "catalogDeleteSecret", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogDeleteSecret_568560, base: "",
    url: url_CatalogDeleteSecret_568561, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
