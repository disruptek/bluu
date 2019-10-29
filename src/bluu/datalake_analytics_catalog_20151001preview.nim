
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
  Call_CatalogListDatabases_563761 = ref object of OpenApiRestCall_563539
proc url_CatalogListDatabases_563763(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CatalogListDatabases_563762(path: JsonNode; query: JsonNode;
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
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_563925 = query.getOrDefault("$top")
  valid_563925 = validateParameter(valid_563925, JInt, required = false, default = nil)
  if valid_563925 != nil:
    section.add "$top", valid_563925
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563926 = query.getOrDefault("api-version")
  valid_563926 = validateParameter(valid_563926, JString, required = true,
                                 default = nil)
  if valid_563926 != nil:
    section.add "api-version", valid_563926
  var valid_563927 = query.getOrDefault("$select")
  valid_563927 = validateParameter(valid_563927, JString, required = false,
                                 default = nil)
  if valid_563927 != nil:
    section.add "$select", valid_563927
  var valid_563928 = query.getOrDefault("$expand")
  valid_563928 = validateParameter(valid_563928, JString, required = false,
                                 default = nil)
  if valid_563928 != nil:
    section.add "$expand", valid_563928
  var valid_563929 = query.getOrDefault("$count")
  valid_563929 = validateParameter(valid_563929, JBool, required = false, default = nil)
  if valid_563929 != nil:
    section.add "$count", valid_563929
  var valid_563930 = query.getOrDefault("$orderby")
  valid_563930 = validateParameter(valid_563930, JString, required = false,
                                 default = nil)
  if valid_563930 != nil:
    section.add "$orderby", valid_563930
  var valid_563931 = query.getOrDefault("$skip")
  valid_563931 = validateParameter(valid_563931, JInt, required = false, default = nil)
  if valid_563931 != nil:
    section.add "$skip", valid_563931
  var valid_563932 = query.getOrDefault("$filter")
  valid_563932 = validateParameter(valid_563932, JString, required = false,
                                 default = nil)
  if valid_563932 != nil:
    section.add "$filter", valid_563932
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563955: Call_CatalogListDatabases_563761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of databases from the Data Lake Analytics catalog.
  ## 
  let valid = call_563955.validator(path, query, header, formData, body)
  let scheme = call_563955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563955.url(scheme.get, call_563955.host, call_563955.base,
                         call_563955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563955, url, valid)

proc call*(call_564026: Call_CatalogListDatabases_563761; apiVersion: string;
          Top: int = 0; Select: string = ""; Expand: string = ""; Count: bool = false;
          Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListDatabases
  ## Retrieves the list of databases from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   Count: bool
  ##        : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   Orderby: string
  ##          : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   Skip: int
  ##       : The number of items to skip over before returning elements. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var query_564027 = newJObject()
  add(query_564027, "$top", newJInt(Top))
  add(query_564027, "api-version", newJString(apiVersion))
  add(query_564027, "$select", newJString(Select))
  add(query_564027, "$expand", newJString(Expand))
  add(query_564027, "$count", newJBool(Count))
  add(query_564027, "$orderby", newJString(Orderby))
  add(query_564027, "$skip", newJInt(Skip))
  add(query_564027, "$filter", newJString(Filter))
  result = call_564026.call(nil, query_564027, nil, nil, nil)

var catalogListDatabases* = Call_CatalogListDatabases_563761(
    name: "catalogListDatabases", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases", validator: validate_CatalogListDatabases_563762,
    base: "", url: url_CatalogListDatabases_563763, schemes: {Scheme.Https})
type
  Call_CatalogGetDatabase_564067 = ref object of OpenApiRestCall_563539
proc url_CatalogGetDatabase_564069(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetDatabase_564068(path: JsonNode; query: JsonNode;
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
  var valid_564084 = path.getOrDefault("databaseName")
  valid_564084 = validateParameter(valid_564084, JString, required = true,
                                 default = nil)
  if valid_564084 != nil:
    section.add "databaseName", valid_564084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564085 = query.getOrDefault("api-version")
  valid_564085 = validateParameter(valid_564085, JString, required = true,
                                 default = nil)
  if valid_564085 != nil:
    section.add "api-version", valid_564085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564086: Call_CatalogGetDatabase_564067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified database from the Data Lake Analytics catalog.
  ## 
  let valid = call_564086.validator(path, query, header, formData, body)
  let scheme = call_564086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564086.url(scheme.get, call_564086.host, call_564086.base,
                         call_564086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564086, url, valid)

proc call*(call_564087: Call_CatalogGetDatabase_564067; apiVersion: string;
          databaseName: string): Recallable =
  ## catalogGetDatabase
  ## Retrieves the specified database from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database.
  var path_564088 = newJObject()
  var query_564089 = newJObject()
  add(query_564089, "api-version", newJString(apiVersion))
  add(path_564088, "databaseName", newJString(databaseName))
  result = call_564087.call(path_564088, query_564089, nil, nil, nil)

var catalogGetDatabase* = Call_CatalogGetDatabase_564067(
    name: "catalogGetDatabase", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}",
    validator: validate_CatalogGetDatabase_564068, base: "",
    url: url_CatalogGetDatabase_564069, schemes: {Scheme.Https})
type
  Call_CatalogListAssemblies_564090 = ref object of OpenApiRestCall_563539
proc url_CatalogListAssemblies_564092(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListAssemblies_564091(path: JsonNode; query: JsonNode;
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
  var valid_564093 = path.getOrDefault("databaseName")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "databaseName", valid_564093
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var valid_564097 = query.getOrDefault("$expand")
  valid_564097 = validateParameter(valid_564097, JString, required = false,
                                 default = nil)
  if valid_564097 != nil:
    section.add "$expand", valid_564097
  var valid_564098 = query.getOrDefault("$count")
  valid_564098 = validateParameter(valid_564098, JBool, required = false, default = nil)
  if valid_564098 != nil:
    section.add "$count", valid_564098
  var valid_564099 = query.getOrDefault("$orderby")
  valid_564099 = validateParameter(valid_564099, JString, required = false,
                                 default = nil)
  if valid_564099 != nil:
    section.add "$orderby", valid_564099
  var valid_564100 = query.getOrDefault("$skip")
  valid_564100 = validateParameter(valid_564100, JInt, required = false, default = nil)
  if valid_564100 != nil:
    section.add "$skip", valid_564100
  var valid_564101 = query.getOrDefault("$filter")
  valid_564101 = validateParameter(valid_564101, JString, required = false,
                                 default = nil)
  if valid_564101 != nil:
    section.add "$filter", valid_564101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564102: Call_CatalogListAssemblies_564090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of assemblies from the Data Lake Analytics catalog.
  ## 
  let valid = call_564102.validator(path, query, header, formData, body)
  let scheme = call_564102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564102.url(scheme.get, call_564102.host, call_564102.base,
                         call_564102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564102, url, valid)

proc call*(call_564103: Call_CatalogListAssemblies_564090; apiVersion: string;
          databaseName: string; Top: int = 0; Select: string = ""; Expand: string = "";
          Count: bool = false; Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListAssemblies
  ## Retrieves the list of assemblies from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_564104 = newJObject()
  var query_564105 = newJObject()
  add(query_564105, "$top", newJInt(Top))
  add(query_564105, "api-version", newJString(apiVersion))
  add(query_564105, "$select", newJString(Select))
  add(query_564105, "$expand", newJString(Expand))
  add(query_564105, "$count", newJBool(Count))
  add(path_564104, "databaseName", newJString(databaseName))
  add(query_564105, "$orderby", newJString(Orderby))
  add(query_564105, "$skip", newJInt(Skip))
  add(query_564105, "$filter", newJString(Filter))
  result = call_564103.call(path_564104, query_564105, nil, nil, nil)

var catalogListAssemblies* = Call_CatalogListAssemblies_564090(
    name: "catalogListAssemblies", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/assemblies",
    validator: validate_CatalogListAssemblies_564091, base: "",
    url: url_CatalogListAssemblies_564092, schemes: {Scheme.Https})
type
  Call_CatalogGetAssembly_564106 = ref object of OpenApiRestCall_563539
proc url_CatalogGetAssembly_564108(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetAssembly_564107(path: JsonNode; query: JsonNode;
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
  var valid_564109 = path.getOrDefault("databaseName")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "databaseName", valid_564109
  var valid_564110 = path.getOrDefault("assemblyName")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "assemblyName", valid_564110
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564111 = query.getOrDefault("api-version")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "api-version", valid_564111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564112: Call_CatalogGetAssembly_564106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified assembly from the Data Lake Analytics catalog.
  ## 
  let valid = call_564112.validator(path, query, header, formData, body)
  let scheme = call_564112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564112.url(scheme.get, call_564112.host, call_564112.base,
                         call_564112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564112, url, valid)

proc call*(call_564113: Call_CatalogGetAssembly_564106; apiVersion: string;
          databaseName: string; assemblyName: string): Recallable =
  ## catalogGetAssembly
  ## Retrieves the specified assembly from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the assembly.
  ##   assemblyName: string (required)
  ##               : The name of the assembly.
  var path_564114 = newJObject()
  var query_564115 = newJObject()
  add(query_564115, "api-version", newJString(apiVersion))
  add(path_564114, "databaseName", newJString(databaseName))
  add(path_564114, "assemblyName", newJString(assemblyName))
  result = call_564113.call(path_564114, query_564115, nil, nil, nil)

var catalogGetAssembly* = Call_CatalogGetAssembly_564106(
    name: "catalogGetAssembly", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/assemblies/{assemblyName}",
    validator: validate_CatalogGetAssembly_564107, base: "",
    url: url_CatalogGetAssembly_564108, schemes: {Scheme.Https})
type
  Call_CatalogListCredentials_564116 = ref object of OpenApiRestCall_563539
proc url_CatalogListCredentials_564118(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListCredentials_564117(path: JsonNode; query: JsonNode;
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
  var valid_564119 = path.getOrDefault("databaseName")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "databaseName", valid_564119
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564120 = query.getOrDefault("$top")
  valid_564120 = validateParameter(valid_564120, JInt, required = false, default = nil)
  if valid_564120 != nil:
    section.add "$top", valid_564120
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564121 = query.getOrDefault("api-version")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "api-version", valid_564121
  var valid_564122 = query.getOrDefault("$select")
  valid_564122 = validateParameter(valid_564122, JString, required = false,
                                 default = nil)
  if valid_564122 != nil:
    section.add "$select", valid_564122
  var valid_564123 = query.getOrDefault("$expand")
  valid_564123 = validateParameter(valid_564123, JString, required = false,
                                 default = nil)
  if valid_564123 != nil:
    section.add "$expand", valid_564123
  var valid_564124 = query.getOrDefault("$count")
  valid_564124 = validateParameter(valid_564124, JBool, required = false, default = nil)
  if valid_564124 != nil:
    section.add "$count", valid_564124
  var valid_564125 = query.getOrDefault("$orderby")
  valid_564125 = validateParameter(valid_564125, JString, required = false,
                                 default = nil)
  if valid_564125 != nil:
    section.add "$orderby", valid_564125
  var valid_564126 = query.getOrDefault("$skip")
  valid_564126 = validateParameter(valid_564126, JInt, required = false, default = nil)
  if valid_564126 != nil:
    section.add "$skip", valid_564126
  var valid_564127 = query.getOrDefault("$filter")
  valid_564127 = validateParameter(valid_564127, JString, required = false,
                                 default = nil)
  if valid_564127 != nil:
    section.add "$filter", valid_564127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564128: Call_CatalogListCredentials_564116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of credentials from the Data Lake Analytics catalog.
  ## 
  let valid = call_564128.validator(path, query, header, formData, body)
  let scheme = call_564128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564128.url(scheme.get, call_564128.host, call_564128.base,
                         call_564128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564128, url, valid)

proc call*(call_564129: Call_CatalogListCredentials_564116; apiVersion: string;
          databaseName: string; Top: int = 0; Select: string = ""; Expand: string = "";
          Count: bool = false; Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListCredentials
  ## Retrieves the list of credentials from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_564130 = newJObject()
  var query_564131 = newJObject()
  add(query_564131, "$top", newJInt(Top))
  add(query_564131, "api-version", newJString(apiVersion))
  add(query_564131, "$select", newJString(Select))
  add(query_564131, "$expand", newJString(Expand))
  add(query_564131, "$count", newJBool(Count))
  add(path_564130, "databaseName", newJString(databaseName))
  add(query_564131, "$orderby", newJString(Orderby))
  add(query_564131, "$skip", newJInt(Skip))
  add(query_564131, "$filter", newJString(Filter))
  result = call_564129.call(path_564130, query_564131, nil, nil, nil)

var catalogListCredentials* = Call_CatalogListCredentials_564116(
    name: "catalogListCredentials", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/credentials",
    validator: validate_CatalogListCredentials_564117, base: "",
    url: url_CatalogListCredentials_564118, schemes: {Scheme.Https})
type
  Call_CatalogGetCredential_564132 = ref object of OpenApiRestCall_563539
proc url_CatalogGetCredential_564134(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetCredential_564133(path: JsonNode; query: JsonNode;
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
  var valid_564135 = path.getOrDefault("databaseName")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "databaseName", valid_564135
  var valid_564136 = path.getOrDefault("credentialName")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "credentialName", valid_564136
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
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564138: Call_CatalogGetCredential_564132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified credential from the Data Lake Analytics catalog.
  ## 
  let valid = call_564138.validator(path, query, header, formData, body)
  let scheme = call_564138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564138.url(scheme.get, call_564138.host, call_564138.base,
                         call_564138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564138, url, valid)

proc call*(call_564139: Call_CatalogGetCredential_564132; apiVersion: string;
          databaseName: string; credentialName: string): Recallable =
  ## catalogGetCredential
  ## Retrieves the specified credential from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the schema.
  ##   credentialName: string (required)
  ##                 : The name of the credential.
  var path_564140 = newJObject()
  var query_564141 = newJObject()
  add(query_564141, "api-version", newJString(apiVersion))
  add(path_564140, "databaseName", newJString(databaseName))
  add(path_564140, "credentialName", newJString(credentialName))
  result = call_564139.call(path_564140, query_564141, nil, nil, nil)

var catalogGetCredential* = Call_CatalogGetCredential_564132(
    name: "catalogGetCredential", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/credentials/{credentialName}",
    validator: validate_CatalogGetCredential_564133, base: "",
    url: url_CatalogGetCredential_564134, schemes: {Scheme.Https})
type
  Call_CatalogListExternalDataSources_564142 = ref object of OpenApiRestCall_563539
proc url_CatalogListExternalDataSources_564144(protocol: Scheme; host: string;
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

proc validate_CatalogListExternalDataSources_564143(path: JsonNode;
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
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var valid_564149 = query.getOrDefault("$expand")
  valid_564149 = validateParameter(valid_564149, JString, required = false,
                                 default = nil)
  if valid_564149 != nil:
    section.add "$expand", valid_564149
  var valid_564150 = query.getOrDefault("$count")
  valid_564150 = validateParameter(valid_564150, JBool, required = false, default = nil)
  if valid_564150 != nil:
    section.add "$count", valid_564150
  var valid_564151 = query.getOrDefault("$orderby")
  valid_564151 = validateParameter(valid_564151, JString, required = false,
                                 default = nil)
  if valid_564151 != nil:
    section.add "$orderby", valid_564151
  var valid_564152 = query.getOrDefault("$skip")
  valid_564152 = validateParameter(valid_564152, JInt, required = false, default = nil)
  if valid_564152 != nil:
    section.add "$skip", valid_564152
  var valid_564153 = query.getOrDefault("$filter")
  valid_564153 = validateParameter(valid_564153, JString, required = false,
                                 default = nil)
  if valid_564153 != nil:
    section.add "$filter", valid_564153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564154: Call_CatalogListExternalDataSources_564142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of external data sources from the Data Lake Analytics catalog.
  ## 
  let valid = call_564154.validator(path, query, header, formData, body)
  let scheme = call_564154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564154.url(scheme.get, call_564154.host, call_564154.base,
                         call_564154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564154, url, valid)

proc call*(call_564155: Call_CatalogListExternalDataSources_564142;
          apiVersion: string; databaseName: string; Top: int = 0; Select: string = "";
          Expand: string = ""; Count: bool = false; Orderby: string = ""; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## catalogListExternalDataSources
  ## Retrieves the list of external data sources from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_564156 = newJObject()
  var query_564157 = newJObject()
  add(query_564157, "$top", newJInt(Top))
  add(query_564157, "api-version", newJString(apiVersion))
  add(query_564157, "$select", newJString(Select))
  add(query_564157, "$expand", newJString(Expand))
  add(query_564157, "$count", newJBool(Count))
  add(path_564156, "databaseName", newJString(databaseName))
  add(query_564157, "$orderby", newJString(Orderby))
  add(query_564157, "$skip", newJInt(Skip))
  add(query_564157, "$filter", newJString(Filter))
  result = call_564155.call(path_564156, query_564157, nil, nil, nil)

var catalogListExternalDataSources* = Call_CatalogListExternalDataSources_564142(
    name: "catalogListExternalDataSources", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/externaldatasources",
    validator: validate_CatalogListExternalDataSources_564143, base: "",
    url: url_CatalogListExternalDataSources_564144, schemes: {Scheme.Https})
type
  Call_CatalogGetExternalDataSource_564158 = ref object of OpenApiRestCall_563539
proc url_CatalogGetExternalDataSource_564160(protocol: Scheme; host: string;
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

proc validate_CatalogGetExternalDataSource_564159(path: JsonNode; query: JsonNode;
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
  var valid_564161 = path.getOrDefault("externalDataSourceName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "externalDataSourceName", valid_564161
  var valid_564162 = path.getOrDefault("databaseName")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "databaseName", valid_564162
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564163 = query.getOrDefault("api-version")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "api-version", valid_564163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564164: Call_CatalogGetExternalDataSource_564158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified external data source from the Data Lake Analytics catalog.
  ## 
  let valid = call_564164.validator(path, query, header, formData, body)
  let scheme = call_564164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564164.url(scheme.get, call_564164.host, call_564164.base,
                         call_564164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564164, url, valid)

proc call*(call_564165: Call_CatalogGetExternalDataSource_564158;
          apiVersion: string; externalDataSourceName: string; databaseName: string): Recallable =
  ## catalogGetExternalDataSource
  ## Retrieves the specified external data source from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   externalDataSourceName: string (required)
  ##                         : The name of the external data source.
  ##   databaseName: string (required)
  ##               : The name of the database containing the external data source.
  var path_564166 = newJObject()
  var query_564167 = newJObject()
  add(query_564167, "api-version", newJString(apiVersion))
  add(path_564166, "externalDataSourceName", newJString(externalDataSourceName))
  add(path_564166, "databaseName", newJString(databaseName))
  result = call_564165.call(path_564166, query_564167, nil, nil, nil)

var catalogGetExternalDataSource* = Call_CatalogGetExternalDataSource_564158(
    name: "catalogGetExternalDataSource", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/externaldatasources/{externalDataSourceName}",
    validator: validate_CatalogGetExternalDataSource_564159, base: "",
    url: url_CatalogGetExternalDataSource_564160, schemes: {Scheme.Https})
type
  Call_CatalogListSchemas_564168 = ref object of OpenApiRestCall_563539
proc url_CatalogListSchemas_564170(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListSchemas_564169(path: JsonNode; query: JsonNode;
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
  var valid_564171 = path.getOrDefault("databaseName")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "databaseName", valid_564171
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564172 = query.getOrDefault("$top")
  valid_564172 = validateParameter(valid_564172, JInt, required = false, default = nil)
  if valid_564172 != nil:
    section.add "$top", valid_564172
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564173 = query.getOrDefault("api-version")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "api-version", valid_564173
  var valid_564174 = query.getOrDefault("$select")
  valid_564174 = validateParameter(valid_564174, JString, required = false,
                                 default = nil)
  if valid_564174 != nil:
    section.add "$select", valid_564174
  var valid_564175 = query.getOrDefault("$expand")
  valid_564175 = validateParameter(valid_564175, JString, required = false,
                                 default = nil)
  if valid_564175 != nil:
    section.add "$expand", valid_564175
  var valid_564176 = query.getOrDefault("$count")
  valid_564176 = validateParameter(valid_564176, JBool, required = false, default = nil)
  if valid_564176 != nil:
    section.add "$count", valid_564176
  var valid_564177 = query.getOrDefault("$orderby")
  valid_564177 = validateParameter(valid_564177, JString, required = false,
                                 default = nil)
  if valid_564177 != nil:
    section.add "$orderby", valid_564177
  var valid_564178 = query.getOrDefault("$skip")
  valid_564178 = validateParameter(valid_564178, JInt, required = false, default = nil)
  if valid_564178 != nil:
    section.add "$skip", valid_564178
  var valid_564179 = query.getOrDefault("$filter")
  valid_564179 = validateParameter(valid_564179, JString, required = false,
                                 default = nil)
  if valid_564179 != nil:
    section.add "$filter", valid_564179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564180: Call_CatalogListSchemas_564168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of schemas from the Data Lake Analytics catalog.
  ## 
  let valid = call_564180.validator(path, query, header, formData, body)
  let scheme = call_564180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564180.url(scheme.get, call_564180.host, call_564180.base,
                         call_564180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564180, url, valid)

proc call*(call_564181: Call_CatalogListSchemas_564168; apiVersion: string;
          databaseName: string; Top: int = 0; Select: string = ""; Expand: string = "";
          Count: bool = false; Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListSchemas
  ## Retrieves the list of schemas from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_564182 = newJObject()
  var query_564183 = newJObject()
  add(query_564183, "$top", newJInt(Top))
  add(query_564183, "api-version", newJString(apiVersion))
  add(query_564183, "$select", newJString(Select))
  add(query_564183, "$expand", newJString(Expand))
  add(query_564183, "$count", newJBool(Count))
  add(path_564182, "databaseName", newJString(databaseName))
  add(query_564183, "$orderby", newJString(Orderby))
  add(query_564183, "$skip", newJInt(Skip))
  add(query_564183, "$filter", newJString(Filter))
  result = call_564181.call(path_564182, query_564183, nil, nil, nil)

var catalogListSchemas* = Call_CatalogListSchemas_564168(
    name: "catalogListSchemas", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas",
    validator: validate_CatalogListSchemas_564169, base: "",
    url: url_CatalogListSchemas_564170, schemes: {Scheme.Https})
type
  Call_CatalogGetSchema_564184 = ref object of OpenApiRestCall_563539
proc url_CatalogGetSchema_564186(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetSchema_564185(path: JsonNode; query: JsonNode;
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
  var valid_564187 = path.getOrDefault("databaseName")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "databaseName", valid_564187
  var valid_564188 = path.getOrDefault("schemaName")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "schemaName", valid_564188
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564189 = query.getOrDefault("api-version")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "api-version", valid_564189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564190: Call_CatalogGetSchema_564184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified schema from the Data Lake Analytics catalog.
  ## 
  let valid = call_564190.validator(path, query, header, formData, body)
  let scheme = call_564190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564190.url(scheme.get, call_564190.host, call_564190.base,
                         call_564190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564190, url, valid)

proc call*(call_564191: Call_CatalogGetSchema_564184; apiVersion: string;
          databaseName: string; schemaName: string): Recallable =
  ## catalogGetSchema
  ## Retrieves the specified schema from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the schema.
  ##   schemaName: string (required)
  ##             : The name of the schema.
  var path_564192 = newJObject()
  var query_564193 = newJObject()
  add(query_564193, "api-version", newJString(apiVersion))
  add(path_564192, "databaseName", newJString(databaseName))
  add(path_564192, "schemaName", newJString(schemaName))
  result = call_564191.call(path_564192, query_564193, nil, nil, nil)

var catalogGetSchema* = Call_CatalogGetSchema_564184(name: "catalogGetSchema",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}",
    validator: validate_CatalogGetSchema_564185, base: "",
    url: url_CatalogGetSchema_564186, schemes: {Scheme.Https})
type
  Call_CatalogListProcedures_564194 = ref object of OpenApiRestCall_563539
proc url_CatalogListProcedures_564196(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListProcedures_564195(path: JsonNode; query: JsonNode;
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
  var valid_564197 = path.getOrDefault("databaseName")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "databaseName", valid_564197
  var valid_564198 = path.getOrDefault("schemaName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "schemaName", valid_564198
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564199 = query.getOrDefault("$top")
  valid_564199 = validateParameter(valid_564199, JInt, required = false, default = nil)
  if valid_564199 != nil:
    section.add "$top", valid_564199
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564200 = query.getOrDefault("api-version")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "api-version", valid_564200
  var valid_564201 = query.getOrDefault("$select")
  valid_564201 = validateParameter(valid_564201, JString, required = false,
                                 default = nil)
  if valid_564201 != nil:
    section.add "$select", valid_564201
  var valid_564202 = query.getOrDefault("$expand")
  valid_564202 = validateParameter(valid_564202, JString, required = false,
                                 default = nil)
  if valid_564202 != nil:
    section.add "$expand", valid_564202
  var valid_564203 = query.getOrDefault("$count")
  valid_564203 = validateParameter(valid_564203, JBool, required = false, default = nil)
  if valid_564203 != nil:
    section.add "$count", valid_564203
  var valid_564204 = query.getOrDefault("$orderby")
  valid_564204 = validateParameter(valid_564204, JString, required = false,
                                 default = nil)
  if valid_564204 != nil:
    section.add "$orderby", valid_564204
  var valid_564205 = query.getOrDefault("$skip")
  valid_564205 = validateParameter(valid_564205, JInt, required = false, default = nil)
  if valid_564205 != nil:
    section.add "$skip", valid_564205
  var valid_564206 = query.getOrDefault("$filter")
  valid_564206 = validateParameter(valid_564206, JString, required = false,
                                 default = nil)
  if valid_564206 != nil:
    section.add "$filter", valid_564206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564207: Call_CatalogListProcedures_564194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of procedures from the Data Lake Analytics catalog.
  ## 
  let valid = call_564207.validator(path, query, header, formData, body)
  let scheme = call_564207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564207.url(scheme.get, call_564207.host, call_564207.base,
                         call_564207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564207, url, valid)

proc call*(call_564208: Call_CatalogListProcedures_564194; apiVersion: string;
          databaseName: string; schemaName: string; Top: int = 0; Select: string = "";
          Expand: string = ""; Count: bool = false; Orderby: string = ""; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## catalogListProcedures
  ## Retrieves the list of procedures from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_564209 = newJObject()
  var query_564210 = newJObject()
  add(query_564210, "$top", newJInt(Top))
  add(query_564210, "api-version", newJString(apiVersion))
  add(query_564210, "$select", newJString(Select))
  add(query_564210, "$expand", newJString(Expand))
  add(query_564210, "$count", newJBool(Count))
  add(path_564209, "databaseName", newJString(databaseName))
  add(query_564210, "$orderby", newJString(Orderby))
  add(query_564210, "$skip", newJInt(Skip))
  add(query_564210, "$filter", newJString(Filter))
  add(path_564209, "schemaName", newJString(schemaName))
  result = call_564208.call(path_564209, query_564210, nil, nil, nil)

var catalogListProcedures* = Call_CatalogListProcedures_564194(
    name: "catalogListProcedures", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/procedures",
    validator: validate_CatalogListProcedures_564195, base: "",
    url: url_CatalogListProcedures_564196, schemes: {Scheme.Https})
type
  Call_CatalogGetProcedure_564211 = ref object of OpenApiRestCall_563539
proc url_CatalogGetProcedure_564213(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetProcedure_564212(path: JsonNode; query: JsonNode;
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
  var valid_564214 = path.getOrDefault("procedureName")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "procedureName", valid_564214
  var valid_564215 = path.getOrDefault("databaseName")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "databaseName", valid_564215
  var valid_564216 = path.getOrDefault("schemaName")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "schemaName", valid_564216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564217 = query.getOrDefault("api-version")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "api-version", valid_564217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564218: Call_CatalogGetProcedure_564211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified procedure from the Data Lake Analytics catalog.
  ## 
  let valid = call_564218.validator(path, query, header, formData, body)
  let scheme = call_564218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564218.url(scheme.get, call_564218.host, call_564218.base,
                         call_564218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564218, url, valid)

proc call*(call_564219: Call_CatalogGetProcedure_564211; procedureName: string;
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
  var path_564220 = newJObject()
  var query_564221 = newJObject()
  add(path_564220, "procedureName", newJString(procedureName))
  add(query_564221, "api-version", newJString(apiVersion))
  add(path_564220, "databaseName", newJString(databaseName))
  add(path_564220, "schemaName", newJString(schemaName))
  result = call_564219.call(path_564220, query_564221, nil, nil, nil)

var catalogGetProcedure* = Call_CatalogGetProcedure_564211(
    name: "catalogGetProcedure", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/procedures/{procedureName}",
    validator: validate_CatalogGetProcedure_564212, base: "",
    url: url_CatalogGetProcedure_564213, schemes: {Scheme.Https})
type
  Call_CatalogListTables_564222 = ref object of OpenApiRestCall_563539
proc url_CatalogListTables_564224(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListTables_564223(path: JsonNode; query: JsonNode;
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
  var valid_564225 = path.getOrDefault("databaseName")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "databaseName", valid_564225
  var valid_564226 = path.getOrDefault("schemaName")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "schemaName", valid_564226
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564227 = query.getOrDefault("$top")
  valid_564227 = validateParameter(valid_564227, JInt, required = false, default = nil)
  if valid_564227 != nil:
    section.add "$top", valid_564227
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564228 = query.getOrDefault("api-version")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "api-version", valid_564228
  var valid_564229 = query.getOrDefault("$select")
  valid_564229 = validateParameter(valid_564229, JString, required = false,
                                 default = nil)
  if valid_564229 != nil:
    section.add "$select", valid_564229
  var valid_564230 = query.getOrDefault("$expand")
  valid_564230 = validateParameter(valid_564230, JString, required = false,
                                 default = nil)
  if valid_564230 != nil:
    section.add "$expand", valid_564230
  var valid_564231 = query.getOrDefault("$count")
  valid_564231 = validateParameter(valid_564231, JBool, required = false, default = nil)
  if valid_564231 != nil:
    section.add "$count", valid_564231
  var valid_564232 = query.getOrDefault("$orderby")
  valid_564232 = validateParameter(valid_564232, JString, required = false,
                                 default = nil)
  if valid_564232 != nil:
    section.add "$orderby", valid_564232
  var valid_564233 = query.getOrDefault("$skip")
  valid_564233 = validateParameter(valid_564233, JInt, required = false, default = nil)
  if valid_564233 != nil:
    section.add "$skip", valid_564233
  var valid_564234 = query.getOrDefault("$filter")
  valid_564234 = validateParameter(valid_564234, JString, required = false,
                                 default = nil)
  if valid_564234 != nil:
    section.add "$filter", valid_564234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564235: Call_CatalogListTables_564222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of tables from the Data Lake Analytics catalog.
  ## 
  let valid = call_564235.validator(path, query, header, formData, body)
  let scheme = call_564235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564235.url(scheme.get, call_564235.host, call_564235.base,
                         call_564235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564235, url, valid)

proc call*(call_564236: Call_CatalogListTables_564222; apiVersion: string;
          databaseName: string; schemaName: string; Top: int = 0; Select: string = "";
          Expand: string = ""; Count: bool = false; Orderby: string = ""; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## catalogListTables
  ## Retrieves the list of tables from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_564237 = newJObject()
  var query_564238 = newJObject()
  add(query_564238, "$top", newJInt(Top))
  add(query_564238, "api-version", newJString(apiVersion))
  add(query_564238, "$select", newJString(Select))
  add(query_564238, "$expand", newJString(Expand))
  add(query_564238, "$count", newJBool(Count))
  add(path_564237, "databaseName", newJString(databaseName))
  add(query_564238, "$orderby", newJString(Orderby))
  add(query_564238, "$skip", newJInt(Skip))
  add(query_564238, "$filter", newJString(Filter))
  add(path_564237, "schemaName", newJString(schemaName))
  result = call_564236.call(path_564237, query_564238, nil, nil, nil)

var catalogListTables* = Call_CatalogListTables_564222(name: "catalogListTables",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables",
    validator: validate_CatalogListTables_564223, base: "",
    url: url_CatalogListTables_564224, schemes: {Scheme.Https})
type
  Call_CatalogGetTable_564239 = ref object of OpenApiRestCall_563539
proc url_CatalogGetTable_564241(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetTable_564240(path: JsonNode; query: JsonNode;
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
  var valid_564242 = path.getOrDefault("databaseName")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "databaseName", valid_564242
  var valid_564243 = path.getOrDefault("schemaName")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "schemaName", valid_564243
  var valid_564244 = path.getOrDefault("tableName")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "tableName", valid_564244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564245 = query.getOrDefault("api-version")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "api-version", valid_564245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564246: Call_CatalogGetTable_564239; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table from the Data Lake Analytics catalog.
  ## 
  let valid = call_564246.validator(path, query, header, formData, body)
  let scheme = call_564246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564246.url(scheme.get, call_564246.host, call_564246.base,
                         call_564246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564246, url, valid)

proc call*(call_564247: Call_CatalogGetTable_564239; apiVersion: string;
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
  var path_564248 = newJObject()
  var query_564249 = newJObject()
  add(query_564249, "api-version", newJString(apiVersion))
  add(path_564248, "databaseName", newJString(databaseName))
  add(path_564248, "schemaName", newJString(schemaName))
  add(path_564248, "tableName", newJString(tableName))
  result = call_564247.call(path_564248, query_564249, nil, nil, nil)

var catalogGetTable* = Call_CatalogGetTable_564239(name: "catalogGetTable",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}",
    validator: validate_CatalogGetTable_564240, base: "", url: url_CatalogGetTable_564241,
    schemes: {Scheme.Https})
type
  Call_CatalogListTablePartitions_564250 = ref object of OpenApiRestCall_563539
proc url_CatalogListTablePartitions_564252(protocol: Scheme; host: string;
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

proc validate_CatalogListTablePartitions_564251(path: JsonNode; query: JsonNode;
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
  var valid_564253 = path.getOrDefault("databaseName")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "databaseName", valid_564253
  var valid_564254 = path.getOrDefault("schemaName")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "schemaName", valid_564254
  var valid_564255 = path.getOrDefault("tableName")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "tableName", valid_564255
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564256 = query.getOrDefault("$top")
  valid_564256 = validateParameter(valid_564256, JInt, required = false, default = nil)
  if valid_564256 != nil:
    section.add "$top", valid_564256
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564257 = query.getOrDefault("api-version")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "api-version", valid_564257
  var valid_564258 = query.getOrDefault("$select")
  valid_564258 = validateParameter(valid_564258, JString, required = false,
                                 default = nil)
  if valid_564258 != nil:
    section.add "$select", valid_564258
  var valid_564259 = query.getOrDefault("$expand")
  valid_564259 = validateParameter(valid_564259, JString, required = false,
                                 default = nil)
  if valid_564259 != nil:
    section.add "$expand", valid_564259
  var valid_564260 = query.getOrDefault("$count")
  valid_564260 = validateParameter(valid_564260, JBool, required = false, default = nil)
  if valid_564260 != nil:
    section.add "$count", valid_564260
  var valid_564261 = query.getOrDefault("$orderby")
  valid_564261 = validateParameter(valid_564261, JString, required = false,
                                 default = nil)
  if valid_564261 != nil:
    section.add "$orderby", valid_564261
  var valid_564262 = query.getOrDefault("$skip")
  valid_564262 = validateParameter(valid_564262, JInt, required = false, default = nil)
  if valid_564262 != nil:
    section.add "$skip", valid_564262
  var valid_564263 = query.getOrDefault("$filter")
  valid_564263 = validateParameter(valid_564263, JString, required = false,
                                 default = nil)
  if valid_564263 != nil:
    section.add "$filter", valid_564263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564264: Call_CatalogListTablePartitions_564250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table partitions from the Data Lake Analytics catalog.
  ## 
  let valid = call_564264.validator(path, query, header, formData, body)
  let scheme = call_564264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564264.url(scheme.get, call_564264.host, call_564264.base,
                         call_564264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564264, url, valid)

proc call*(call_564265: Call_CatalogListTablePartitions_564250; apiVersion: string;
          databaseName: string; schemaName: string; tableName: string; Top: int = 0;
          Select: string = ""; Expand: string = ""; Count: bool = false;
          Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListTablePartitions
  ## Retrieves the list of table partitions from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_564266 = newJObject()
  var query_564267 = newJObject()
  add(query_564267, "$top", newJInt(Top))
  add(query_564267, "api-version", newJString(apiVersion))
  add(query_564267, "$select", newJString(Select))
  add(query_564267, "$expand", newJString(Expand))
  add(query_564267, "$count", newJBool(Count))
  add(path_564266, "databaseName", newJString(databaseName))
  add(query_564267, "$orderby", newJString(Orderby))
  add(query_564267, "$skip", newJInt(Skip))
  add(query_564267, "$filter", newJString(Filter))
  add(path_564266, "schemaName", newJString(schemaName))
  add(path_564266, "tableName", newJString(tableName))
  result = call_564265.call(path_564266, query_564267, nil, nil, nil)

var catalogListTablePartitions* = Call_CatalogListTablePartitions_564250(
    name: "catalogListTablePartitions", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/partitions",
    validator: validate_CatalogListTablePartitions_564251, base: "",
    url: url_CatalogListTablePartitions_564252, schemes: {Scheme.Https})
type
  Call_CatalogGetTablePartition_564268 = ref object of OpenApiRestCall_563539
proc url_CatalogGetTablePartition_564270(protocol: Scheme; host: string;
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

proc validate_CatalogGetTablePartition_564269(path: JsonNode; query: JsonNode;
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
  var valid_564271 = path.getOrDefault("databaseName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "databaseName", valid_564271
  var valid_564272 = path.getOrDefault("schemaName")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "schemaName", valid_564272
  var valid_564273 = path.getOrDefault("tableName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "tableName", valid_564273
  var valid_564274 = path.getOrDefault("partitionName")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "partitionName", valid_564274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564275 = query.getOrDefault("api-version")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "api-version", valid_564275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564276: Call_CatalogGetTablePartition_564268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table partition from the Data Lake Analytics catalog.
  ## 
  let valid = call_564276.validator(path, query, header, formData, body)
  let scheme = call_564276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564276.url(scheme.get, call_564276.host, call_564276.base,
                         call_564276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564276, url, valid)

proc call*(call_564277: Call_CatalogGetTablePartition_564268; apiVersion: string;
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
  var path_564278 = newJObject()
  var query_564279 = newJObject()
  add(query_564279, "api-version", newJString(apiVersion))
  add(path_564278, "databaseName", newJString(databaseName))
  add(path_564278, "schemaName", newJString(schemaName))
  add(path_564278, "tableName", newJString(tableName))
  add(path_564278, "partitionName", newJString(partitionName))
  result = call_564277.call(path_564278, query_564279, nil, nil, nil)

var catalogGetTablePartition* = Call_CatalogGetTablePartition_564268(
    name: "catalogGetTablePartition", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/partitions/{partitionName}",
    validator: validate_CatalogGetTablePartition_564269, base: "",
    url: url_CatalogGetTablePartition_564270, schemes: {Scheme.Https})
type
  Call_CatalogListTableStatistics_564280 = ref object of OpenApiRestCall_563539
proc url_CatalogListTableStatistics_564282(protocol: Scheme; host: string;
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

proc validate_CatalogListTableStatistics_564281(path: JsonNode; query: JsonNode;
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
  var valid_564283 = path.getOrDefault("databaseName")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "databaseName", valid_564283
  var valid_564284 = path.getOrDefault("schemaName")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "schemaName", valid_564284
  var valid_564285 = path.getOrDefault("tableName")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "tableName", valid_564285
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564286 = query.getOrDefault("$top")
  valid_564286 = validateParameter(valid_564286, JInt, required = false, default = nil)
  if valid_564286 != nil:
    section.add "$top", valid_564286
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564287 = query.getOrDefault("api-version")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "api-version", valid_564287
  var valid_564288 = query.getOrDefault("$select")
  valid_564288 = validateParameter(valid_564288, JString, required = false,
                                 default = nil)
  if valid_564288 != nil:
    section.add "$select", valid_564288
  var valid_564289 = query.getOrDefault("$expand")
  valid_564289 = validateParameter(valid_564289, JString, required = false,
                                 default = nil)
  if valid_564289 != nil:
    section.add "$expand", valid_564289
  var valid_564290 = query.getOrDefault("$count")
  valid_564290 = validateParameter(valid_564290, JBool, required = false, default = nil)
  if valid_564290 != nil:
    section.add "$count", valid_564290
  var valid_564291 = query.getOrDefault("$orderby")
  valid_564291 = validateParameter(valid_564291, JString, required = false,
                                 default = nil)
  if valid_564291 != nil:
    section.add "$orderby", valid_564291
  var valid_564292 = query.getOrDefault("$skip")
  valid_564292 = validateParameter(valid_564292, JInt, required = false, default = nil)
  if valid_564292 != nil:
    section.add "$skip", valid_564292
  var valid_564293 = query.getOrDefault("$filter")
  valid_564293 = validateParameter(valid_564293, JString, required = false,
                                 default = nil)
  if valid_564293 != nil:
    section.add "$filter", valid_564293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564294: Call_CatalogListTableStatistics_564280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table statistics from the Data Lake Analytics catalog.
  ## 
  let valid = call_564294.validator(path, query, header, formData, body)
  let scheme = call_564294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564294.url(scheme.get, call_564294.host, call_564294.base,
                         call_564294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564294, url, valid)

proc call*(call_564295: Call_CatalogListTableStatistics_564280; apiVersion: string;
          databaseName: string; schemaName: string; tableName: string; Top: int = 0;
          Select: string = ""; Expand: string = ""; Count: bool = false;
          Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListTableStatistics
  ## Retrieves the list of table statistics from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_564296 = newJObject()
  var query_564297 = newJObject()
  add(query_564297, "$top", newJInt(Top))
  add(query_564297, "api-version", newJString(apiVersion))
  add(query_564297, "$select", newJString(Select))
  add(query_564297, "$expand", newJString(Expand))
  add(query_564297, "$count", newJBool(Count))
  add(path_564296, "databaseName", newJString(databaseName))
  add(query_564297, "$orderby", newJString(Orderby))
  add(query_564297, "$skip", newJInt(Skip))
  add(query_564297, "$filter", newJString(Filter))
  add(path_564296, "schemaName", newJString(schemaName))
  add(path_564296, "tableName", newJString(tableName))
  result = call_564295.call(path_564296, query_564297, nil, nil, nil)

var catalogListTableStatistics* = Call_CatalogListTableStatistics_564280(
    name: "catalogListTableStatistics", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/statistics",
    validator: validate_CatalogListTableStatistics_564281, base: "",
    url: url_CatalogListTableStatistics_564282, schemes: {Scheme.Https})
type
  Call_CatalogGetTableStatistic_564298 = ref object of OpenApiRestCall_563539
proc url_CatalogGetTableStatistic_564300(protocol: Scheme; host: string;
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

proc validate_CatalogGetTableStatistic_564299(path: JsonNode; query: JsonNode;
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
  var valid_564301 = path.getOrDefault("databaseName")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "databaseName", valid_564301
  var valid_564302 = path.getOrDefault("schemaName")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "schemaName", valid_564302
  var valid_564303 = path.getOrDefault("tableName")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "tableName", valid_564303
  var valid_564304 = path.getOrDefault("statisticsName")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "statisticsName", valid_564304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564305 = query.getOrDefault("api-version")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "api-version", valid_564305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564306: Call_CatalogGetTableStatistic_564298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table statistics from the Data Lake Analytics catalog.
  ## 
  let valid = call_564306.validator(path, query, header, formData, body)
  let scheme = call_564306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564306.url(scheme.get, call_564306.host, call_564306.base,
                         call_564306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564306, url, valid)

proc call*(call_564307: Call_CatalogGetTableStatistic_564298; apiVersion: string;
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
  var path_564308 = newJObject()
  var query_564309 = newJObject()
  add(query_564309, "api-version", newJString(apiVersion))
  add(path_564308, "databaseName", newJString(databaseName))
  add(path_564308, "schemaName", newJString(schemaName))
  add(path_564308, "tableName", newJString(tableName))
  add(path_564308, "statisticsName", newJString(statisticsName))
  result = call_564307.call(path_564308, query_564309, nil, nil, nil)

var catalogGetTableStatistic* = Call_CatalogGetTableStatistic_564298(
    name: "catalogGetTableStatistic", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/statistics/{statisticsName}",
    validator: validate_CatalogGetTableStatistic_564299, base: "",
    url: url_CatalogGetTableStatistic_564300, schemes: {Scheme.Https})
type
  Call_CatalogListTableTypes_564310 = ref object of OpenApiRestCall_563539
proc url_CatalogListTableTypes_564312(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListTableTypes_564311(path: JsonNode; query: JsonNode;
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
  var valid_564313 = path.getOrDefault("databaseName")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "databaseName", valid_564313
  var valid_564314 = path.getOrDefault("schemaName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "schemaName", valid_564314
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564315 = query.getOrDefault("$top")
  valid_564315 = validateParameter(valid_564315, JInt, required = false, default = nil)
  if valid_564315 != nil:
    section.add "$top", valid_564315
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564316 = query.getOrDefault("api-version")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "api-version", valid_564316
  var valid_564317 = query.getOrDefault("$select")
  valid_564317 = validateParameter(valid_564317, JString, required = false,
                                 default = nil)
  if valid_564317 != nil:
    section.add "$select", valid_564317
  var valid_564318 = query.getOrDefault("$expand")
  valid_564318 = validateParameter(valid_564318, JString, required = false,
                                 default = nil)
  if valid_564318 != nil:
    section.add "$expand", valid_564318
  var valid_564319 = query.getOrDefault("$count")
  valid_564319 = validateParameter(valid_564319, JBool, required = false, default = nil)
  if valid_564319 != nil:
    section.add "$count", valid_564319
  var valid_564320 = query.getOrDefault("$orderby")
  valid_564320 = validateParameter(valid_564320, JString, required = false,
                                 default = nil)
  if valid_564320 != nil:
    section.add "$orderby", valid_564320
  var valid_564321 = query.getOrDefault("$skip")
  valid_564321 = validateParameter(valid_564321, JInt, required = false, default = nil)
  if valid_564321 != nil:
    section.add "$skip", valid_564321
  var valid_564322 = query.getOrDefault("$filter")
  valid_564322 = validateParameter(valid_564322, JString, required = false,
                                 default = nil)
  if valid_564322 != nil:
    section.add "$filter", valid_564322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564323: Call_CatalogListTableTypes_564310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table types from the Data Lake Analytics catalog.
  ## 
  let valid = call_564323.validator(path, query, header, formData, body)
  let scheme = call_564323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564323.url(scheme.get, call_564323.host, call_564323.base,
                         call_564323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564323, url, valid)

proc call*(call_564324: Call_CatalogListTableTypes_564310; apiVersion: string;
          databaseName: string; schemaName: string; Top: int = 0; Select: string = "";
          Expand: string = ""; Count: bool = false; Orderby: string = ""; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## catalogListTableTypes
  ## Retrieves the list of table types from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_564325 = newJObject()
  var query_564326 = newJObject()
  add(query_564326, "$top", newJInt(Top))
  add(query_564326, "api-version", newJString(apiVersion))
  add(query_564326, "$select", newJString(Select))
  add(query_564326, "$expand", newJString(Expand))
  add(query_564326, "$count", newJBool(Count))
  add(path_564325, "databaseName", newJString(databaseName))
  add(query_564326, "$orderby", newJString(Orderby))
  add(query_564326, "$skip", newJInt(Skip))
  add(query_564326, "$filter", newJString(Filter))
  add(path_564325, "schemaName", newJString(schemaName))
  result = call_564324.call(path_564325, query_564326, nil, nil, nil)

var catalogListTableTypes* = Call_CatalogListTableTypes_564310(
    name: "catalogListTableTypes", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tabletypes",
    validator: validate_CatalogListTableTypes_564311, base: "",
    url: url_CatalogListTableTypes_564312, schemes: {Scheme.Https})
type
  Call_CatalogGetTableType_564327 = ref object of OpenApiRestCall_563539
proc url_CatalogGetTableType_564329(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetTableType_564328(path: JsonNode; query: JsonNode;
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
  var valid_564330 = path.getOrDefault("tableTypeName")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "tableTypeName", valid_564330
  var valid_564331 = path.getOrDefault("databaseName")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "databaseName", valid_564331
  var valid_564332 = path.getOrDefault("schemaName")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "schemaName", valid_564332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564333 = query.getOrDefault("api-version")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "api-version", valid_564333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564334: Call_CatalogGetTableType_564327; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table type from the Data Lake Analytics catalog.
  ## 
  let valid = call_564334.validator(path, query, header, formData, body)
  let scheme = call_564334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564334.url(scheme.get, call_564334.host, call_564334.base,
                         call_564334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564334, url, valid)

proc call*(call_564335: Call_CatalogGetTableType_564327; apiVersion: string;
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
  var path_564336 = newJObject()
  var query_564337 = newJObject()
  add(query_564337, "api-version", newJString(apiVersion))
  add(path_564336, "tableTypeName", newJString(tableTypeName))
  add(path_564336, "databaseName", newJString(databaseName))
  add(path_564336, "schemaName", newJString(schemaName))
  result = call_564335.call(path_564336, query_564337, nil, nil, nil)

var catalogGetTableType* = Call_CatalogGetTableType_564327(
    name: "catalogGetTableType", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tabletypes/{tableTypeName}",
    validator: validate_CatalogGetTableType_564328, base: "",
    url: url_CatalogGetTableType_564329, schemes: {Scheme.Https})
type
  Call_CatalogListTableValuedFunctions_564338 = ref object of OpenApiRestCall_563539
proc url_CatalogListTableValuedFunctions_564340(protocol: Scheme; host: string;
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

proc validate_CatalogListTableValuedFunctions_564339(path: JsonNode;
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
  var valid_564341 = path.getOrDefault("databaseName")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "databaseName", valid_564341
  var valid_564342 = path.getOrDefault("schemaName")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "schemaName", valid_564342
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564343 = query.getOrDefault("$top")
  valid_564343 = validateParameter(valid_564343, JInt, required = false, default = nil)
  if valid_564343 != nil:
    section.add "$top", valid_564343
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564344 = query.getOrDefault("api-version")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "api-version", valid_564344
  var valid_564345 = query.getOrDefault("$select")
  valid_564345 = validateParameter(valid_564345, JString, required = false,
                                 default = nil)
  if valid_564345 != nil:
    section.add "$select", valid_564345
  var valid_564346 = query.getOrDefault("$expand")
  valid_564346 = validateParameter(valid_564346, JString, required = false,
                                 default = nil)
  if valid_564346 != nil:
    section.add "$expand", valid_564346
  var valid_564347 = query.getOrDefault("$count")
  valid_564347 = validateParameter(valid_564347, JBool, required = false, default = nil)
  if valid_564347 != nil:
    section.add "$count", valid_564347
  var valid_564348 = query.getOrDefault("$orderby")
  valid_564348 = validateParameter(valid_564348, JString, required = false,
                                 default = nil)
  if valid_564348 != nil:
    section.add "$orderby", valid_564348
  var valid_564349 = query.getOrDefault("$skip")
  valid_564349 = validateParameter(valid_564349, JInt, required = false, default = nil)
  if valid_564349 != nil:
    section.add "$skip", valid_564349
  var valid_564350 = query.getOrDefault("$filter")
  valid_564350 = validateParameter(valid_564350, JString, required = false,
                                 default = nil)
  if valid_564350 != nil:
    section.add "$filter", valid_564350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564351: Call_CatalogListTableValuedFunctions_564338;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of table valued functions from the Data Lake Analytics catalog.
  ## 
  let valid = call_564351.validator(path, query, header, formData, body)
  let scheme = call_564351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564351.url(scheme.get, call_564351.host, call_564351.base,
                         call_564351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564351, url, valid)

proc call*(call_564352: Call_CatalogListTableValuedFunctions_564338;
          apiVersion: string; databaseName: string; schemaName: string; Top: int = 0;
          Select: string = ""; Expand: string = ""; Count: bool = false;
          Orderby: string = ""; Skip: int = 0; Filter: string = ""): Recallable =
  ## catalogListTableValuedFunctions
  ## Retrieves the list of table valued functions from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_564353 = newJObject()
  var query_564354 = newJObject()
  add(query_564354, "$top", newJInt(Top))
  add(query_564354, "api-version", newJString(apiVersion))
  add(query_564354, "$select", newJString(Select))
  add(query_564354, "$expand", newJString(Expand))
  add(query_564354, "$count", newJBool(Count))
  add(path_564353, "databaseName", newJString(databaseName))
  add(query_564354, "$orderby", newJString(Orderby))
  add(query_564354, "$skip", newJInt(Skip))
  add(query_564354, "$filter", newJString(Filter))
  add(path_564353, "schemaName", newJString(schemaName))
  result = call_564352.call(path_564353, query_564354, nil, nil, nil)

var catalogListTableValuedFunctions* = Call_CatalogListTableValuedFunctions_564338(
    name: "catalogListTableValuedFunctions", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tablevaluedfunctions",
    validator: validate_CatalogListTableValuedFunctions_564339, base: "",
    url: url_CatalogListTableValuedFunctions_564340, schemes: {Scheme.Https})
type
  Call_CatalogGetTableValuedFunction_564355 = ref object of OpenApiRestCall_563539
proc url_CatalogGetTableValuedFunction_564357(protocol: Scheme; host: string;
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

proc validate_CatalogGetTableValuedFunction_564356(path: JsonNode; query: JsonNode;
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
  var valid_564358 = path.getOrDefault("databaseName")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "databaseName", valid_564358
  var valid_564359 = path.getOrDefault("tableValuedFunctionName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "tableValuedFunctionName", valid_564359
  var valid_564360 = path.getOrDefault("schemaName")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "schemaName", valid_564360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564361 = query.getOrDefault("api-version")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "api-version", valid_564361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564362: Call_CatalogGetTableValuedFunction_564355; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table valued function from the Data Lake Analytics catalog.
  ## 
  let valid = call_564362.validator(path, query, header, formData, body)
  let scheme = call_564362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564362.url(scheme.get, call_564362.host, call_564362.base,
                         call_564362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564362, url, valid)

proc call*(call_564363: Call_CatalogGetTableValuedFunction_564355;
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
  var path_564364 = newJObject()
  var query_564365 = newJObject()
  add(query_564365, "api-version", newJString(apiVersion))
  add(path_564364, "databaseName", newJString(databaseName))
  add(path_564364, "tableValuedFunctionName", newJString(tableValuedFunctionName))
  add(path_564364, "schemaName", newJString(schemaName))
  result = call_564363.call(path_564364, query_564365, nil, nil, nil)

var catalogGetTableValuedFunction* = Call_CatalogGetTableValuedFunction_564355(
    name: "catalogGetTableValuedFunction", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tablevaluedfunctions/{tableValuedFunctionName}",
    validator: validate_CatalogGetTableValuedFunction_564356, base: "",
    url: url_CatalogGetTableValuedFunction_564357, schemes: {Scheme.Https})
type
  Call_CatalogListTypes_564366 = ref object of OpenApiRestCall_563539
proc url_CatalogListTypes_564368(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListTypes_564367(path: JsonNode; query: JsonNode;
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
  var valid_564369 = path.getOrDefault("databaseName")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "databaseName", valid_564369
  var valid_564370 = path.getOrDefault("schemaName")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "schemaName", valid_564370
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564371 = query.getOrDefault("$top")
  valid_564371 = validateParameter(valid_564371, JInt, required = false, default = nil)
  if valid_564371 != nil:
    section.add "$top", valid_564371
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564372 = query.getOrDefault("api-version")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "api-version", valid_564372
  var valid_564373 = query.getOrDefault("$select")
  valid_564373 = validateParameter(valid_564373, JString, required = false,
                                 default = nil)
  if valid_564373 != nil:
    section.add "$select", valid_564373
  var valid_564374 = query.getOrDefault("$expand")
  valid_564374 = validateParameter(valid_564374, JString, required = false,
                                 default = nil)
  if valid_564374 != nil:
    section.add "$expand", valid_564374
  var valid_564375 = query.getOrDefault("$count")
  valid_564375 = validateParameter(valid_564375, JBool, required = false, default = nil)
  if valid_564375 != nil:
    section.add "$count", valid_564375
  var valid_564376 = query.getOrDefault("$orderby")
  valid_564376 = validateParameter(valid_564376, JString, required = false,
                                 default = nil)
  if valid_564376 != nil:
    section.add "$orderby", valid_564376
  var valid_564377 = query.getOrDefault("$skip")
  valid_564377 = validateParameter(valid_564377, JInt, required = false, default = nil)
  if valid_564377 != nil:
    section.add "$skip", valid_564377
  var valid_564378 = query.getOrDefault("$filter")
  valid_564378 = validateParameter(valid_564378, JString, required = false,
                                 default = nil)
  if valid_564378 != nil:
    section.add "$filter", valid_564378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564379: Call_CatalogListTypes_564366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of types within the specified database and schema from the Data Lake Analytics catalog.
  ## 
  let valid = call_564379.validator(path, query, header, formData, body)
  let scheme = call_564379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564379.url(scheme.get, call_564379.host, call_564379.base,
                         call_564379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564379, url, valid)

proc call*(call_564380: Call_CatalogListTypes_564366; apiVersion: string;
          databaseName: string; schemaName: string; Top: int = 0; Select: string = "";
          Expand: string = ""; Count: bool = false; Orderby: string = ""; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## catalogListTypes
  ## Retrieves the list of types within the specified database and schema from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_564381 = newJObject()
  var query_564382 = newJObject()
  add(query_564382, "$top", newJInt(Top))
  add(query_564382, "api-version", newJString(apiVersion))
  add(query_564382, "$select", newJString(Select))
  add(query_564382, "$expand", newJString(Expand))
  add(query_564382, "$count", newJBool(Count))
  add(path_564381, "databaseName", newJString(databaseName))
  add(query_564382, "$orderby", newJString(Orderby))
  add(query_564382, "$skip", newJInt(Skip))
  add(query_564382, "$filter", newJString(Filter))
  add(path_564381, "schemaName", newJString(schemaName))
  result = call_564380.call(path_564381, query_564382, nil, nil, nil)

var catalogListTypes* = Call_CatalogListTypes_564366(name: "catalogListTypes",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/types",
    validator: validate_CatalogListTypes_564367, base: "",
    url: url_CatalogListTypes_564368, schemes: {Scheme.Https})
type
  Call_CatalogListViews_564383 = ref object of OpenApiRestCall_563539
proc url_CatalogListViews_564385(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListViews_564384(path: JsonNode; query: JsonNode;
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
  var valid_564386 = path.getOrDefault("databaseName")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "databaseName", valid_564386
  var valid_564387 = path.getOrDefault("schemaName")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "schemaName", valid_564387
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of items to return. Optional.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   $expand: JString
  ##          : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
  ##   $count: JBool
  ##         : The Boolean value of true or false to request a count of the matching resources included with the resources in the response, e.g. Categories?$count=true. Optional.
  ##   $orderby: JString
  ##           : OrderBy clause. One or more comma-separated expressions with an optional "asc" (the default) or "desc" depending on the order you'd like the values sorted, e.g. Categories?$orderby=CategoryName desc. Optional.
  ##   $skip: JInt
  ##        : The number of items to skip over before returning elements. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  var valid_564388 = query.getOrDefault("$top")
  valid_564388 = validateParameter(valid_564388, JInt, required = false, default = nil)
  if valid_564388 != nil:
    section.add "$top", valid_564388
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564389 = query.getOrDefault("api-version")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "api-version", valid_564389
  var valid_564390 = query.getOrDefault("$select")
  valid_564390 = validateParameter(valid_564390, JString, required = false,
                                 default = nil)
  if valid_564390 != nil:
    section.add "$select", valid_564390
  var valid_564391 = query.getOrDefault("$expand")
  valid_564391 = validateParameter(valid_564391, JString, required = false,
                                 default = nil)
  if valid_564391 != nil:
    section.add "$expand", valid_564391
  var valid_564392 = query.getOrDefault("$count")
  valid_564392 = validateParameter(valid_564392, JBool, required = false, default = nil)
  if valid_564392 != nil:
    section.add "$count", valid_564392
  var valid_564393 = query.getOrDefault("$orderby")
  valid_564393 = validateParameter(valid_564393, JString, required = false,
                                 default = nil)
  if valid_564393 != nil:
    section.add "$orderby", valid_564393
  var valid_564394 = query.getOrDefault("$skip")
  valid_564394 = validateParameter(valid_564394, JInt, required = false, default = nil)
  if valid_564394 != nil:
    section.add "$skip", valid_564394
  var valid_564395 = query.getOrDefault("$filter")
  valid_564395 = validateParameter(valid_564395, JString, required = false,
                                 default = nil)
  if valid_564395 != nil:
    section.add "$filter", valid_564395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564396: Call_CatalogListViews_564383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of views from the Data Lake Analytics catalog.
  ## 
  let valid = call_564396.validator(path, query, header, formData, body)
  let scheme = call_564396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564396.url(scheme.get, call_564396.host, call_564396.base,
                         call_564396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564396, url, valid)

proc call*(call_564397: Call_CatalogListViews_564383; apiVersion: string;
          databaseName: string; schemaName: string; Top: int = 0; Select: string = "";
          Expand: string = ""; Count: bool = false; Orderby: string = ""; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## catalogListViews
  ## Retrieves the list of views from the Data Lake Analytics catalog.
  ##   Top: int
  ##      : The number of items to return. Optional.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : OData Select statement. Limits the properties on each entry to just those requested, e.g. Categories?$select=CategoryName,Description. Optional.
  ##   Expand: string
  ##         : OData expansion. Expand related resources in line with the retrieved resources, e.g. Categories?$expand=Products would expand Product data in line with each Category entry. Optional.
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
  var path_564398 = newJObject()
  var query_564399 = newJObject()
  add(query_564399, "$top", newJInt(Top))
  add(query_564399, "api-version", newJString(apiVersion))
  add(query_564399, "$select", newJString(Select))
  add(query_564399, "$expand", newJString(Expand))
  add(query_564399, "$count", newJBool(Count))
  add(path_564398, "databaseName", newJString(databaseName))
  add(query_564399, "$orderby", newJString(Orderby))
  add(query_564399, "$skip", newJInt(Skip))
  add(query_564399, "$filter", newJString(Filter))
  add(path_564398, "schemaName", newJString(schemaName))
  result = call_564397.call(path_564398, query_564399, nil, nil, nil)

var catalogListViews* = Call_CatalogListViews_564383(name: "catalogListViews",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/views",
    validator: validate_CatalogListViews_564384, base: "",
    url: url_CatalogListViews_564385, schemes: {Scheme.Https})
type
  Call_CatalogGetView_564400 = ref object of OpenApiRestCall_563539
proc url_CatalogGetView_564402(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetView_564401(path: JsonNode; query: JsonNode;
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
  var valid_564403 = path.getOrDefault("databaseName")
  valid_564403 = validateParameter(valid_564403, JString, required = true,
                                 default = nil)
  if valid_564403 != nil:
    section.add "databaseName", valid_564403
  var valid_564404 = path.getOrDefault("viewName")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "viewName", valid_564404
  var valid_564405 = path.getOrDefault("schemaName")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "schemaName", valid_564405
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564406 = query.getOrDefault("api-version")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "api-version", valid_564406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564407: Call_CatalogGetView_564400; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified view from the Data Lake Analytics catalog.
  ## 
  let valid = call_564407.validator(path, query, header, formData, body)
  let scheme = call_564407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564407.url(scheme.get, call_564407.host, call_564407.base,
                         call_564407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564407, url, valid)

proc call*(call_564408: Call_CatalogGetView_564400; apiVersion: string;
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
  var path_564409 = newJObject()
  var query_564410 = newJObject()
  add(query_564410, "api-version", newJString(apiVersion))
  add(path_564409, "databaseName", newJString(databaseName))
  add(path_564409, "viewName", newJString(viewName))
  add(path_564409, "schemaName", newJString(schemaName))
  result = call_564408.call(path_564409, query_564410, nil, nil, nil)

var catalogGetView* = Call_CatalogGetView_564400(name: "catalogGetView",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/views/{viewName}",
    validator: validate_CatalogGetView_564401, base: "", url: url_CatalogGetView_564402,
    schemes: {Scheme.Https})
type
  Call_CatalogDeleteAllSecrets_564411 = ref object of OpenApiRestCall_563539
proc url_CatalogDeleteAllSecrets_564413(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogDeleteAllSecrets_564412(path: JsonNode; query: JsonNode;
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
  var valid_564414 = path.getOrDefault("databaseName")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "databaseName", valid_564414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564415 = query.getOrDefault("api-version")
  valid_564415 = validateParameter(valid_564415, JString, required = true,
                                 default = nil)
  if valid_564415 != nil:
    section.add "api-version", valid_564415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564416: Call_CatalogDeleteAllSecrets_564411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes all secrets in the specified database
  ## 
  let valid = call_564416.validator(path, query, header, formData, body)
  let scheme = call_564416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564416.url(scheme.get, call_564416.host, call_564416.base,
                         call_564416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564416, url, valid)

proc call*(call_564417: Call_CatalogDeleteAllSecrets_564411; apiVersion: string;
          databaseName: string): Recallable =
  ## catalogDeleteAllSecrets
  ## Deletes all secrets in the specified database
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  var path_564418 = newJObject()
  var query_564419 = newJObject()
  add(query_564419, "api-version", newJString(apiVersion))
  add(path_564418, "databaseName", newJString(databaseName))
  result = call_564417.call(path_564418, query_564419, nil, nil, nil)

var catalogDeleteAllSecrets* = Call_CatalogDeleteAllSecrets_564411(
    name: "catalogDeleteAllSecrets", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/secrets",
    validator: validate_CatalogDeleteAllSecrets_564412, base: "",
    url: url_CatalogDeleteAllSecrets_564413, schemes: {Scheme.Https})
type
  Call_CatalogCreateSecret_564430 = ref object of OpenApiRestCall_563539
proc url_CatalogCreateSecret_564432(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogCreateSecret_564431(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates the specified secret for use with external data sources in the specified database.
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
  var valid_564450 = path.getOrDefault("secretName")
  valid_564450 = validateParameter(valid_564450, JString, required = true,
                                 default = nil)
  if valid_564450 != nil:
    section.add "secretName", valid_564450
  var valid_564451 = path.getOrDefault("databaseName")
  valid_564451 = validateParameter(valid_564451, JString, required = true,
                                 default = nil)
  if valid_564451 != nil:
    section.add "databaseName", valid_564451
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564452 = query.getOrDefault("api-version")
  valid_564452 = validateParameter(valid_564452, JString, required = true,
                                 default = nil)
  if valid_564452 != nil:
    section.add "api-version", valid_564452
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

proc call*(call_564454: Call_CatalogCreateSecret_564430; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the specified secret for use with external data sources in the specified database.
  ## 
  let valid = call_564454.validator(path, query, header, formData, body)
  let scheme = call_564454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564454.url(scheme.get, call_564454.host, call_564454.base,
                         call_564454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564454, url, valid)

proc call*(call_564455: Call_CatalogCreateSecret_564430; apiVersion: string;
          secretName: string; databaseName: string; parameters: JsonNode): Recallable =
  ## catalogCreateSecret
  ## Creates the specified secret for use with external data sources in the specified database.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  ##   databaseName: string (required)
  ##               : The name of the database in which to create the secret.
  ##   parameters: JObject (required)
  ##             : The parameters required to create the secret (name and password)
  var path_564456 = newJObject()
  var query_564457 = newJObject()
  var body_564458 = newJObject()
  add(query_564457, "api-version", newJString(apiVersion))
  add(path_564456, "secretName", newJString(secretName))
  add(path_564456, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_564458 = parameters
  result = call_564455.call(path_564456, query_564457, nil, nil, body_564458)

var catalogCreateSecret* = Call_CatalogCreateSecret_564430(
    name: "catalogCreateSecret", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogCreateSecret_564431, base: "",
    url: url_CatalogCreateSecret_564432, schemes: {Scheme.Https})
type
  Call_CatalogGetSecret_564420 = ref object of OpenApiRestCall_563539
proc url_CatalogGetSecret_564422(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetSecret_564421(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the specified secret in the specified database
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
  var valid_564423 = path.getOrDefault("secretName")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = nil)
  if valid_564423 != nil:
    section.add "secretName", valid_564423
  var valid_564424 = path.getOrDefault("databaseName")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "databaseName", valid_564424
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564425 = query.getOrDefault("api-version")
  valid_564425 = validateParameter(valid_564425, JString, required = true,
                                 default = nil)
  if valid_564425 != nil:
    section.add "api-version", valid_564425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564426: Call_CatalogGetSecret_564420; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified secret in the specified database
  ## 
  let valid = call_564426.validator(path, query, header, formData, body)
  let scheme = call_564426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564426.url(scheme.get, call_564426.host, call_564426.base,
                         call_564426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564426, url, valid)

proc call*(call_564427: Call_CatalogGetSecret_564420; apiVersion: string;
          secretName: string; databaseName: string): Recallable =
  ## catalogGetSecret
  ## Gets the specified secret in the specified database
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   secretName: string (required)
  ##             : The name of the secret to get
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  var path_564428 = newJObject()
  var query_564429 = newJObject()
  add(query_564429, "api-version", newJString(apiVersion))
  add(path_564428, "secretName", newJString(secretName))
  add(path_564428, "databaseName", newJString(databaseName))
  result = call_564427.call(path_564428, query_564429, nil, nil, nil)

var catalogGetSecret* = Call_CatalogGetSecret_564420(name: "catalogGetSecret",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogGetSecret_564421, base: "",
    url: url_CatalogGetSecret_564422, schemes: {Scheme.Https})
type
  Call_CatalogUpdateSecret_564469 = ref object of OpenApiRestCall_563539
proc url_CatalogUpdateSecret_564471(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogUpdateSecret_564470(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Modifies the specified secret for use with external data sources in the specified database
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
  var valid_564472 = path.getOrDefault("secretName")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "secretName", valid_564472
  var valid_564473 = path.getOrDefault("databaseName")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "databaseName", valid_564473
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564474 = query.getOrDefault("api-version")
  valid_564474 = validateParameter(valid_564474, JString, required = true,
                                 default = nil)
  if valid_564474 != nil:
    section.add "api-version", valid_564474
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

proc call*(call_564476: Call_CatalogUpdateSecret_564469; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the specified secret for use with external data sources in the specified database
  ## 
  let valid = call_564476.validator(path, query, header, formData, body)
  let scheme = call_564476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564476.url(scheme.get, call_564476.host, call_564476.base,
                         call_564476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564476, url, valid)

proc call*(call_564477: Call_CatalogUpdateSecret_564469; apiVersion: string;
          secretName: string; databaseName: string; parameters: JsonNode): Recallable =
  ## catalogUpdateSecret
  ## Modifies the specified secret for use with external data sources in the specified database
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  ##   parameters: JObject (required)
  ##             : The parameters required to modify the secret (name and password)
  var path_564478 = newJObject()
  var query_564479 = newJObject()
  var body_564480 = newJObject()
  add(query_564479, "api-version", newJString(apiVersion))
  add(path_564478, "secretName", newJString(secretName))
  add(path_564478, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_564480 = parameters
  result = call_564477.call(path_564478, query_564479, nil, nil, body_564480)

var catalogUpdateSecret* = Call_CatalogUpdateSecret_564469(
    name: "catalogUpdateSecret", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogUpdateSecret_564470, base: "",
    url: url_CatalogUpdateSecret_564471, schemes: {Scheme.Https})
type
  Call_CatalogDeleteSecret_564459 = ref object of OpenApiRestCall_563539
proc url_CatalogDeleteSecret_564461(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogDeleteSecret_564460(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the specified secret in the specified database
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
  var valid_564462 = path.getOrDefault("secretName")
  valid_564462 = validateParameter(valid_564462, JString, required = true,
                                 default = nil)
  if valid_564462 != nil:
    section.add "secretName", valid_564462
  var valid_564463 = path.getOrDefault("databaseName")
  valid_564463 = validateParameter(valid_564463, JString, required = true,
                                 default = nil)
  if valid_564463 != nil:
    section.add "databaseName", valid_564463
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564464 = query.getOrDefault("api-version")
  valid_564464 = validateParameter(valid_564464, JString, required = true,
                                 default = nil)
  if valid_564464 != nil:
    section.add "api-version", valid_564464
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564465: Call_CatalogDeleteSecret_564459; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified secret in the specified database
  ## 
  let valid = call_564465.validator(path, query, header, formData, body)
  let scheme = call_564465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564465.url(scheme.get, call_564465.host, call_564465.base,
                         call_564465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564465, url, valid)

proc call*(call_564466: Call_CatalogDeleteSecret_564459; apiVersion: string;
          secretName: string; databaseName: string): Recallable =
  ## catalogDeleteSecret
  ## Deletes the specified secret in the specified database
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   secretName: string (required)
  ##             : The name of the secret to delete
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  var path_564467 = newJObject()
  var query_564468 = newJObject()
  add(query_564468, "api-version", newJString(apiVersion))
  add(path_564467, "secretName", newJString(secretName))
  add(path_564467, "databaseName", newJString(databaseName))
  result = call_564466.call(path_564467, query_564468, nil, nil, nil)

var catalogDeleteSecret* = Call_CatalogDeleteSecret_564459(
    name: "catalogDeleteSecret", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogDeleteSecret_564460, base: "",
    url: url_CatalogDeleteSecret_564461, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
