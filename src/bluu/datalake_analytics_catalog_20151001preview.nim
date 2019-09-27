
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  macServiceName = "datalake-analytics-catalog"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CatalogListDatabases_593630 = ref object of OpenApiRestCall_593408
proc url_CatalogListDatabases_593632(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CatalogListDatabases_593631(path: JsonNode; query: JsonNode;
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
  var valid_593792 = query.getOrDefault("$orderby")
  valid_593792 = validateParameter(valid_593792, JString, required = false,
                                 default = nil)
  if valid_593792 != nil:
    section.add "$orderby", valid_593792
  var valid_593793 = query.getOrDefault("$expand")
  valid_593793 = validateParameter(valid_593793, JString, required = false,
                                 default = nil)
  if valid_593793 != nil:
    section.add "$expand", valid_593793
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593794 = query.getOrDefault("api-version")
  valid_593794 = validateParameter(valid_593794, JString, required = true,
                                 default = nil)
  if valid_593794 != nil:
    section.add "api-version", valid_593794
  var valid_593795 = query.getOrDefault("$top")
  valid_593795 = validateParameter(valid_593795, JInt, required = false, default = nil)
  if valid_593795 != nil:
    section.add "$top", valid_593795
  var valid_593796 = query.getOrDefault("$select")
  valid_593796 = validateParameter(valid_593796, JString, required = false,
                                 default = nil)
  if valid_593796 != nil:
    section.add "$select", valid_593796
  var valid_593797 = query.getOrDefault("$skip")
  valid_593797 = validateParameter(valid_593797, JInt, required = false, default = nil)
  if valid_593797 != nil:
    section.add "$skip", valid_593797
  var valid_593798 = query.getOrDefault("$count")
  valid_593798 = validateParameter(valid_593798, JBool, required = false, default = nil)
  if valid_593798 != nil:
    section.add "$count", valid_593798
  var valid_593799 = query.getOrDefault("$filter")
  valid_593799 = validateParameter(valid_593799, JString, required = false,
                                 default = nil)
  if valid_593799 != nil:
    section.add "$filter", valid_593799
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593822: Call_CatalogListDatabases_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of databases from the Data Lake Analytics catalog.
  ## 
  let valid = call_593822.validator(path, query, header, formData, body)
  let scheme = call_593822.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593822.url(scheme.get, call_593822.host, call_593822.base,
                         call_593822.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593822, url, valid)

proc call*(call_593893: Call_CatalogListDatabases_593630; apiVersion: string;
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
  var query_593894 = newJObject()
  add(query_593894, "$orderby", newJString(Orderby))
  add(query_593894, "$expand", newJString(Expand))
  add(query_593894, "api-version", newJString(apiVersion))
  add(query_593894, "$top", newJInt(Top))
  add(query_593894, "$select", newJString(Select))
  add(query_593894, "$skip", newJInt(Skip))
  add(query_593894, "$count", newJBool(Count))
  add(query_593894, "$filter", newJString(Filter))
  result = call_593893.call(nil, query_593894, nil, nil, nil)

var catalogListDatabases* = Call_CatalogListDatabases_593630(
    name: "catalogListDatabases", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases", validator: validate_CatalogListDatabases_593631,
    base: "", url: url_CatalogListDatabases_593632, schemes: {Scheme.Https})
type
  Call_CatalogGetDatabase_593934 = ref object of OpenApiRestCall_593408
proc url_CatalogGetDatabase_593936(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetDatabase_593935(path: JsonNode; query: JsonNode;
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
  var valid_593951 = path.getOrDefault("databaseName")
  valid_593951 = validateParameter(valid_593951, JString, required = true,
                                 default = nil)
  if valid_593951 != nil:
    section.add "databaseName", valid_593951
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593952 = query.getOrDefault("api-version")
  valid_593952 = validateParameter(valid_593952, JString, required = true,
                                 default = nil)
  if valid_593952 != nil:
    section.add "api-version", valid_593952
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593953: Call_CatalogGetDatabase_593934; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified database from the Data Lake Analytics catalog.
  ## 
  let valid = call_593953.validator(path, query, header, formData, body)
  let scheme = call_593953.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593953.url(scheme.get, call_593953.host, call_593953.base,
                         call_593953.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593953, url, valid)

proc call*(call_593954: Call_CatalogGetDatabase_593934; apiVersion: string;
          databaseName: string): Recallable =
  ## catalogGetDatabase
  ## Retrieves the specified database from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database.
  var path_593955 = newJObject()
  var query_593956 = newJObject()
  add(query_593956, "api-version", newJString(apiVersion))
  add(path_593955, "databaseName", newJString(databaseName))
  result = call_593954.call(path_593955, query_593956, nil, nil, nil)

var catalogGetDatabase* = Call_CatalogGetDatabase_593934(
    name: "catalogGetDatabase", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}",
    validator: validate_CatalogGetDatabase_593935, base: "",
    url: url_CatalogGetDatabase_593936, schemes: {Scheme.Https})
type
  Call_CatalogListAssemblies_593957 = ref object of OpenApiRestCall_593408
proc url_CatalogListAssemblies_593959(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListAssemblies_593958(path: JsonNode; query: JsonNode;
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
  var valid_593960 = path.getOrDefault("databaseName")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "databaseName", valid_593960
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
  var valid_593961 = query.getOrDefault("$orderby")
  valid_593961 = validateParameter(valid_593961, JString, required = false,
                                 default = nil)
  if valid_593961 != nil:
    section.add "$orderby", valid_593961
  var valid_593962 = query.getOrDefault("$expand")
  valid_593962 = validateParameter(valid_593962, JString, required = false,
                                 default = nil)
  if valid_593962 != nil:
    section.add "$expand", valid_593962
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593963 = query.getOrDefault("api-version")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "api-version", valid_593963
  var valid_593964 = query.getOrDefault("$top")
  valid_593964 = validateParameter(valid_593964, JInt, required = false, default = nil)
  if valid_593964 != nil:
    section.add "$top", valid_593964
  var valid_593965 = query.getOrDefault("$select")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "$select", valid_593965
  var valid_593966 = query.getOrDefault("$skip")
  valid_593966 = validateParameter(valid_593966, JInt, required = false, default = nil)
  if valid_593966 != nil:
    section.add "$skip", valid_593966
  var valid_593967 = query.getOrDefault("$count")
  valid_593967 = validateParameter(valid_593967, JBool, required = false, default = nil)
  if valid_593967 != nil:
    section.add "$count", valid_593967
  var valid_593968 = query.getOrDefault("$filter")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "$filter", valid_593968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593969: Call_CatalogListAssemblies_593957; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of assemblies from the Data Lake Analytics catalog.
  ## 
  let valid = call_593969.validator(path, query, header, formData, body)
  let scheme = call_593969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593969.url(scheme.get, call_593969.host, call_593969.base,
                         call_593969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593969, url, valid)

proc call*(call_593970: Call_CatalogListAssemblies_593957; apiVersion: string;
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
  var path_593971 = newJObject()
  var query_593972 = newJObject()
  add(query_593972, "$orderby", newJString(Orderby))
  add(query_593972, "$expand", newJString(Expand))
  add(query_593972, "api-version", newJString(apiVersion))
  add(query_593972, "$top", newJInt(Top))
  add(query_593972, "$select", newJString(Select))
  add(path_593971, "databaseName", newJString(databaseName))
  add(query_593972, "$skip", newJInt(Skip))
  add(query_593972, "$count", newJBool(Count))
  add(query_593972, "$filter", newJString(Filter))
  result = call_593970.call(path_593971, query_593972, nil, nil, nil)

var catalogListAssemblies* = Call_CatalogListAssemblies_593957(
    name: "catalogListAssemblies", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/assemblies",
    validator: validate_CatalogListAssemblies_593958, base: "",
    url: url_CatalogListAssemblies_593959, schemes: {Scheme.Https})
type
  Call_CatalogGetAssembly_593973 = ref object of OpenApiRestCall_593408
proc url_CatalogGetAssembly_593975(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetAssembly_593974(path: JsonNode; query: JsonNode;
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
  var valid_593976 = path.getOrDefault("databaseName")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "databaseName", valid_593976
  var valid_593977 = path.getOrDefault("assemblyName")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "assemblyName", valid_593977
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593978 = query.getOrDefault("api-version")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "api-version", valid_593978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593979: Call_CatalogGetAssembly_593973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified assembly from the Data Lake Analytics catalog.
  ## 
  let valid = call_593979.validator(path, query, header, formData, body)
  let scheme = call_593979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593979.url(scheme.get, call_593979.host, call_593979.base,
                         call_593979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593979, url, valid)

proc call*(call_593980: Call_CatalogGetAssembly_593973; apiVersion: string;
          databaseName: string; assemblyName: string): Recallable =
  ## catalogGetAssembly
  ## Retrieves the specified assembly from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the assembly.
  ##   assemblyName: string (required)
  ##               : The name of the assembly.
  var path_593981 = newJObject()
  var query_593982 = newJObject()
  add(query_593982, "api-version", newJString(apiVersion))
  add(path_593981, "databaseName", newJString(databaseName))
  add(path_593981, "assemblyName", newJString(assemblyName))
  result = call_593980.call(path_593981, query_593982, nil, nil, nil)

var catalogGetAssembly* = Call_CatalogGetAssembly_593973(
    name: "catalogGetAssembly", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/assemblies/{assemblyName}",
    validator: validate_CatalogGetAssembly_593974, base: "",
    url: url_CatalogGetAssembly_593975, schemes: {Scheme.Https})
type
  Call_CatalogListCredentials_593983 = ref object of OpenApiRestCall_593408
proc url_CatalogListCredentials_593985(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListCredentials_593984(path: JsonNode; query: JsonNode;
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
  var valid_593986 = path.getOrDefault("databaseName")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "databaseName", valid_593986
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
  var valid_593987 = query.getOrDefault("$orderby")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "$orderby", valid_593987
  var valid_593988 = query.getOrDefault("$expand")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "$expand", valid_593988
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593989 = query.getOrDefault("api-version")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "api-version", valid_593989
  var valid_593990 = query.getOrDefault("$top")
  valid_593990 = validateParameter(valid_593990, JInt, required = false, default = nil)
  if valid_593990 != nil:
    section.add "$top", valid_593990
  var valid_593991 = query.getOrDefault("$select")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "$select", valid_593991
  var valid_593992 = query.getOrDefault("$skip")
  valid_593992 = validateParameter(valid_593992, JInt, required = false, default = nil)
  if valid_593992 != nil:
    section.add "$skip", valid_593992
  var valid_593993 = query.getOrDefault("$count")
  valid_593993 = validateParameter(valid_593993, JBool, required = false, default = nil)
  if valid_593993 != nil:
    section.add "$count", valid_593993
  var valid_593994 = query.getOrDefault("$filter")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "$filter", valid_593994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593995: Call_CatalogListCredentials_593983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of credentials from the Data Lake Analytics catalog.
  ## 
  let valid = call_593995.validator(path, query, header, formData, body)
  let scheme = call_593995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593995.url(scheme.get, call_593995.host, call_593995.base,
                         call_593995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593995, url, valid)

proc call*(call_593996: Call_CatalogListCredentials_593983; apiVersion: string;
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
  var path_593997 = newJObject()
  var query_593998 = newJObject()
  add(query_593998, "$orderby", newJString(Orderby))
  add(query_593998, "$expand", newJString(Expand))
  add(query_593998, "api-version", newJString(apiVersion))
  add(query_593998, "$top", newJInt(Top))
  add(query_593998, "$select", newJString(Select))
  add(path_593997, "databaseName", newJString(databaseName))
  add(query_593998, "$skip", newJInt(Skip))
  add(query_593998, "$count", newJBool(Count))
  add(query_593998, "$filter", newJString(Filter))
  result = call_593996.call(path_593997, query_593998, nil, nil, nil)

var catalogListCredentials* = Call_CatalogListCredentials_593983(
    name: "catalogListCredentials", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/credentials",
    validator: validate_CatalogListCredentials_593984, base: "",
    url: url_CatalogListCredentials_593985, schemes: {Scheme.Https})
type
  Call_CatalogGetCredential_593999 = ref object of OpenApiRestCall_593408
proc url_CatalogGetCredential_594001(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetCredential_594000(path: JsonNode; query: JsonNode;
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
  var valid_594002 = path.getOrDefault("databaseName")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "databaseName", valid_594002
  var valid_594003 = path.getOrDefault("credentialName")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "credentialName", valid_594003
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
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594005: Call_CatalogGetCredential_593999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified credential from the Data Lake Analytics catalog.
  ## 
  let valid = call_594005.validator(path, query, header, formData, body)
  let scheme = call_594005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594005.url(scheme.get, call_594005.host, call_594005.base,
                         call_594005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594005, url, valid)

proc call*(call_594006: Call_CatalogGetCredential_593999; apiVersion: string;
          databaseName: string; credentialName: string): Recallable =
  ## catalogGetCredential
  ## Retrieves the specified credential from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the schema.
  ##   credentialName: string (required)
  ##                 : The name of the credential.
  var path_594007 = newJObject()
  var query_594008 = newJObject()
  add(query_594008, "api-version", newJString(apiVersion))
  add(path_594007, "databaseName", newJString(databaseName))
  add(path_594007, "credentialName", newJString(credentialName))
  result = call_594006.call(path_594007, query_594008, nil, nil, nil)

var catalogGetCredential* = Call_CatalogGetCredential_593999(
    name: "catalogGetCredential", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/credentials/{credentialName}",
    validator: validate_CatalogGetCredential_594000, base: "",
    url: url_CatalogGetCredential_594001, schemes: {Scheme.Https})
type
  Call_CatalogListExternalDataSources_594009 = ref object of OpenApiRestCall_593408
proc url_CatalogListExternalDataSources_594011(protocol: Scheme; host: string;
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

proc validate_CatalogListExternalDataSources_594010(path: JsonNode;
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
  var valid_594012 = path.getOrDefault("databaseName")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "databaseName", valid_594012
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
  var valid_594013 = query.getOrDefault("$orderby")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "$orderby", valid_594013
  var valid_594014 = query.getOrDefault("$expand")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "$expand", valid_594014
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594015 = query.getOrDefault("api-version")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "api-version", valid_594015
  var valid_594016 = query.getOrDefault("$top")
  valid_594016 = validateParameter(valid_594016, JInt, required = false, default = nil)
  if valid_594016 != nil:
    section.add "$top", valid_594016
  var valid_594017 = query.getOrDefault("$select")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "$select", valid_594017
  var valid_594018 = query.getOrDefault("$skip")
  valid_594018 = validateParameter(valid_594018, JInt, required = false, default = nil)
  if valid_594018 != nil:
    section.add "$skip", valid_594018
  var valid_594019 = query.getOrDefault("$count")
  valid_594019 = validateParameter(valid_594019, JBool, required = false, default = nil)
  if valid_594019 != nil:
    section.add "$count", valid_594019
  var valid_594020 = query.getOrDefault("$filter")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "$filter", valid_594020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594021: Call_CatalogListExternalDataSources_594009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of external data sources from the Data Lake Analytics catalog.
  ## 
  let valid = call_594021.validator(path, query, header, formData, body)
  let scheme = call_594021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594021.url(scheme.get, call_594021.host, call_594021.base,
                         call_594021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594021, url, valid)

proc call*(call_594022: Call_CatalogListExternalDataSources_594009;
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
  var path_594023 = newJObject()
  var query_594024 = newJObject()
  add(query_594024, "$orderby", newJString(Orderby))
  add(query_594024, "$expand", newJString(Expand))
  add(query_594024, "api-version", newJString(apiVersion))
  add(query_594024, "$top", newJInt(Top))
  add(query_594024, "$select", newJString(Select))
  add(path_594023, "databaseName", newJString(databaseName))
  add(query_594024, "$skip", newJInt(Skip))
  add(query_594024, "$count", newJBool(Count))
  add(query_594024, "$filter", newJString(Filter))
  result = call_594022.call(path_594023, query_594024, nil, nil, nil)

var catalogListExternalDataSources* = Call_CatalogListExternalDataSources_594009(
    name: "catalogListExternalDataSources", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/externaldatasources",
    validator: validate_CatalogListExternalDataSources_594010, base: "",
    url: url_CatalogListExternalDataSources_594011, schemes: {Scheme.Https})
type
  Call_CatalogGetExternalDataSource_594025 = ref object of OpenApiRestCall_593408
proc url_CatalogGetExternalDataSource_594027(protocol: Scheme; host: string;
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

proc validate_CatalogGetExternalDataSource_594026(path: JsonNode; query: JsonNode;
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
  var valid_594028 = path.getOrDefault("externalDataSourceName")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "externalDataSourceName", valid_594028
  var valid_594029 = path.getOrDefault("databaseName")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "databaseName", valid_594029
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594030 = query.getOrDefault("api-version")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "api-version", valid_594030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594031: Call_CatalogGetExternalDataSource_594025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified external data source from the Data Lake Analytics catalog.
  ## 
  let valid = call_594031.validator(path, query, header, formData, body)
  let scheme = call_594031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594031.url(scheme.get, call_594031.host, call_594031.base,
                         call_594031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594031, url, valid)

proc call*(call_594032: Call_CatalogGetExternalDataSource_594025;
          externalDataSourceName: string; apiVersion: string; databaseName: string): Recallable =
  ## catalogGetExternalDataSource
  ## Retrieves the specified external data source from the Data Lake Analytics catalog.
  ##   externalDataSourceName: string (required)
  ##                         : The name of the external data source.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the external data source.
  var path_594033 = newJObject()
  var query_594034 = newJObject()
  add(path_594033, "externalDataSourceName", newJString(externalDataSourceName))
  add(query_594034, "api-version", newJString(apiVersion))
  add(path_594033, "databaseName", newJString(databaseName))
  result = call_594032.call(path_594033, query_594034, nil, nil, nil)

var catalogGetExternalDataSource* = Call_CatalogGetExternalDataSource_594025(
    name: "catalogGetExternalDataSource", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/externaldatasources/{externalDataSourceName}",
    validator: validate_CatalogGetExternalDataSource_594026, base: "",
    url: url_CatalogGetExternalDataSource_594027, schemes: {Scheme.Https})
type
  Call_CatalogListSchemas_594035 = ref object of OpenApiRestCall_593408
proc url_CatalogListSchemas_594037(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListSchemas_594036(path: JsonNode; query: JsonNode;
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
  var valid_594038 = path.getOrDefault("databaseName")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "databaseName", valid_594038
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
  var valid_594039 = query.getOrDefault("$orderby")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "$orderby", valid_594039
  var valid_594040 = query.getOrDefault("$expand")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "$expand", valid_594040
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594041 = query.getOrDefault("api-version")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "api-version", valid_594041
  var valid_594042 = query.getOrDefault("$top")
  valid_594042 = validateParameter(valid_594042, JInt, required = false, default = nil)
  if valid_594042 != nil:
    section.add "$top", valid_594042
  var valid_594043 = query.getOrDefault("$select")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "$select", valid_594043
  var valid_594044 = query.getOrDefault("$skip")
  valid_594044 = validateParameter(valid_594044, JInt, required = false, default = nil)
  if valid_594044 != nil:
    section.add "$skip", valid_594044
  var valid_594045 = query.getOrDefault("$count")
  valid_594045 = validateParameter(valid_594045, JBool, required = false, default = nil)
  if valid_594045 != nil:
    section.add "$count", valid_594045
  var valid_594046 = query.getOrDefault("$filter")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "$filter", valid_594046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594047: Call_CatalogListSchemas_594035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of schemas from the Data Lake Analytics catalog.
  ## 
  let valid = call_594047.validator(path, query, header, formData, body)
  let scheme = call_594047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594047.url(scheme.get, call_594047.host, call_594047.base,
                         call_594047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594047, url, valid)

proc call*(call_594048: Call_CatalogListSchemas_594035; apiVersion: string;
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
  var path_594049 = newJObject()
  var query_594050 = newJObject()
  add(query_594050, "$orderby", newJString(Orderby))
  add(query_594050, "$expand", newJString(Expand))
  add(query_594050, "api-version", newJString(apiVersion))
  add(query_594050, "$top", newJInt(Top))
  add(query_594050, "$select", newJString(Select))
  add(path_594049, "databaseName", newJString(databaseName))
  add(query_594050, "$skip", newJInt(Skip))
  add(query_594050, "$count", newJBool(Count))
  add(query_594050, "$filter", newJString(Filter))
  result = call_594048.call(path_594049, query_594050, nil, nil, nil)

var catalogListSchemas* = Call_CatalogListSchemas_594035(
    name: "catalogListSchemas", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas",
    validator: validate_CatalogListSchemas_594036, base: "",
    url: url_CatalogListSchemas_594037, schemes: {Scheme.Https})
type
  Call_CatalogGetSchema_594051 = ref object of OpenApiRestCall_593408
proc url_CatalogGetSchema_594053(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetSchema_594052(path: JsonNode; query: JsonNode;
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
  var valid_594054 = path.getOrDefault("schemaName")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "schemaName", valid_594054
  var valid_594055 = path.getOrDefault("databaseName")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "databaseName", valid_594055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594056 = query.getOrDefault("api-version")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "api-version", valid_594056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594057: Call_CatalogGetSchema_594051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified schema from the Data Lake Analytics catalog.
  ## 
  let valid = call_594057.validator(path, query, header, formData, body)
  let scheme = call_594057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594057.url(scheme.get, call_594057.host, call_594057.base,
                         call_594057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594057, url, valid)

proc call*(call_594058: Call_CatalogGetSchema_594051; apiVersion: string;
          schemaName: string; databaseName: string): Recallable =
  ## catalogGetSchema
  ## Retrieves the specified schema from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   schemaName: string (required)
  ##             : The name of the schema.
  ##   databaseName: string (required)
  ##               : The name of the database containing the schema.
  var path_594059 = newJObject()
  var query_594060 = newJObject()
  add(query_594060, "api-version", newJString(apiVersion))
  add(path_594059, "schemaName", newJString(schemaName))
  add(path_594059, "databaseName", newJString(databaseName))
  result = call_594058.call(path_594059, query_594060, nil, nil, nil)

var catalogGetSchema* = Call_CatalogGetSchema_594051(name: "catalogGetSchema",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}",
    validator: validate_CatalogGetSchema_594052, base: "",
    url: url_CatalogGetSchema_594053, schemes: {Scheme.Https})
type
  Call_CatalogListProcedures_594061 = ref object of OpenApiRestCall_593408
proc url_CatalogListProcedures_594063(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListProcedures_594062(path: JsonNode; query: JsonNode;
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
  var valid_594064 = path.getOrDefault("schemaName")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "schemaName", valid_594064
  var valid_594065 = path.getOrDefault("databaseName")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "databaseName", valid_594065
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
  var valid_594066 = query.getOrDefault("$orderby")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "$orderby", valid_594066
  var valid_594067 = query.getOrDefault("$expand")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "$expand", valid_594067
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594068 = query.getOrDefault("api-version")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "api-version", valid_594068
  var valid_594069 = query.getOrDefault("$top")
  valid_594069 = validateParameter(valid_594069, JInt, required = false, default = nil)
  if valid_594069 != nil:
    section.add "$top", valid_594069
  var valid_594070 = query.getOrDefault("$select")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "$select", valid_594070
  var valid_594071 = query.getOrDefault("$skip")
  valid_594071 = validateParameter(valid_594071, JInt, required = false, default = nil)
  if valid_594071 != nil:
    section.add "$skip", valid_594071
  var valid_594072 = query.getOrDefault("$count")
  valid_594072 = validateParameter(valid_594072, JBool, required = false, default = nil)
  if valid_594072 != nil:
    section.add "$count", valid_594072
  var valid_594073 = query.getOrDefault("$filter")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "$filter", valid_594073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594074: Call_CatalogListProcedures_594061; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of procedures from the Data Lake Analytics catalog.
  ## 
  let valid = call_594074.validator(path, query, header, formData, body)
  let scheme = call_594074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594074.url(scheme.get, call_594074.host, call_594074.base,
                         call_594074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594074, url, valid)

proc call*(call_594075: Call_CatalogListProcedures_594061; apiVersion: string;
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
  var path_594076 = newJObject()
  var query_594077 = newJObject()
  add(query_594077, "$orderby", newJString(Orderby))
  add(query_594077, "$expand", newJString(Expand))
  add(query_594077, "api-version", newJString(apiVersion))
  add(query_594077, "$top", newJInt(Top))
  add(path_594076, "schemaName", newJString(schemaName))
  add(query_594077, "$select", newJString(Select))
  add(path_594076, "databaseName", newJString(databaseName))
  add(query_594077, "$skip", newJInt(Skip))
  add(query_594077, "$count", newJBool(Count))
  add(query_594077, "$filter", newJString(Filter))
  result = call_594075.call(path_594076, query_594077, nil, nil, nil)

var catalogListProcedures* = Call_CatalogListProcedures_594061(
    name: "catalogListProcedures", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/procedures",
    validator: validate_CatalogListProcedures_594062, base: "",
    url: url_CatalogListProcedures_594063, schemes: {Scheme.Https})
type
  Call_CatalogGetProcedure_594078 = ref object of OpenApiRestCall_593408
proc url_CatalogGetProcedure_594080(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetProcedure_594079(path: JsonNode; query: JsonNode;
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
  var valid_594081 = path.getOrDefault("procedureName")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "procedureName", valid_594081
  var valid_594082 = path.getOrDefault("schemaName")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "schemaName", valid_594082
  var valid_594083 = path.getOrDefault("databaseName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "databaseName", valid_594083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594084 = query.getOrDefault("api-version")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "api-version", valid_594084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594085: Call_CatalogGetProcedure_594078; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified procedure from the Data Lake Analytics catalog.
  ## 
  let valid = call_594085.validator(path, query, header, formData, body)
  let scheme = call_594085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594085.url(scheme.get, call_594085.host, call_594085.base,
                         call_594085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594085, url, valid)

proc call*(call_594086: Call_CatalogGetProcedure_594078; apiVersion: string;
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
  var path_594087 = newJObject()
  var query_594088 = newJObject()
  add(query_594088, "api-version", newJString(apiVersion))
  add(path_594087, "procedureName", newJString(procedureName))
  add(path_594087, "schemaName", newJString(schemaName))
  add(path_594087, "databaseName", newJString(databaseName))
  result = call_594086.call(path_594087, query_594088, nil, nil, nil)

var catalogGetProcedure* = Call_CatalogGetProcedure_594078(
    name: "catalogGetProcedure", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/procedures/{procedureName}",
    validator: validate_CatalogGetProcedure_594079, base: "",
    url: url_CatalogGetProcedure_594080, schemes: {Scheme.Https})
type
  Call_CatalogListTables_594089 = ref object of OpenApiRestCall_593408
proc url_CatalogListTables_594091(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListTables_594090(path: JsonNode; query: JsonNode;
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
  var valid_594092 = path.getOrDefault("schemaName")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "schemaName", valid_594092
  var valid_594093 = path.getOrDefault("databaseName")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "databaseName", valid_594093
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
  var valid_594094 = query.getOrDefault("$orderby")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "$orderby", valid_594094
  var valid_594095 = query.getOrDefault("$expand")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "$expand", valid_594095
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594096 = query.getOrDefault("api-version")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "api-version", valid_594096
  var valid_594097 = query.getOrDefault("$top")
  valid_594097 = validateParameter(valid_594097, JInt, required = false, default = nil)
  if valid_594097 != nil:
    section.add "$top", valid_594097
  var valid_594098 = query.getOrDefault("$select")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "$select", valid_594098
  var valid_594099 = query.getOrDefault("$skip")
  valid_594099 = validateParameter(valid_594099, JInt, required = false, default = nil)
  if valid_594099 != nil:
    section.add "$skip", valid_594099
  var valid_594100 = query.getOrDefault("$count")
  valid_594100 = validateParameter(valid_594100, JBool, required = false, default = nil)
  if valid_594100 != nil:
    section.add "$count", valid_594100
  var valid_594101 = query.getOrDefault("$filter")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "$filter", valid_594101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594102: Call_CatalogListTables_594089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of tables from the Data Lake Analytics catalog.
  ## 
  let valid = call_594102.validator(path, query, header, formData, body)
  let scheme = call_594102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594102.url(scheme.get, call_594102.host, call_594102.base,
                         call_594102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594102, url, valid)

proc call*(call_594103: Call_CatalogListTables_594089; apiVersion: string;
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
  var path_594104 = newJObject()
  var query_594105 = newJObject()
  add(query_594105, "$orderby", newJString(Orderby))
  add(query_594105, "$expand", newJString(Expand))
  add(query_594105, "api-version", newJString(apiVersion))
  add(query_594105, "$top", newJInt(Top))
  add(path_594104, "schemaName", newJString(schemaName))
  add(query_594105, "$select", newJString(Select))
  add(path_594104, "databaseName", newJString(databaseName))
  add(query_594105, "$skip", newJInt(Skip))
  add(query_594105, "$count", newJBool(Count))
  add(query_594105, "$filter", newJString(Filter))
  result = call_594103.call(path_594104, query_594105, nil, nil, nil)

var catalogListTables* = Call_CatalogListTables_594089(name: "catalogListTables",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables",
    validator: validate_CatalogListTables_594090, base: "",
    url: url_CatalogListTables_594091, schemes: {Scheme.Https})
type
  Call_CatalogGetTable_594106 = ref object of OpenApiRestCall_593408
proc url_CatalogGetTable_594108(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetTable_594107(path: JsonNode; query: JsonNode;
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
  var valid_594109 = path.getOrDefault("schemaName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "schemaName", valid_594109
  var valid_594110 = path.getOrDefault("tableName")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "tableName", valid_594110
  var valid_594111 = path.getOrDefault("databaseName")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "databaseName", valid_594111
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594112 = query.getOrDefault("api-version")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "api-version", valid_594112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594113: Call_CatalogGetTable_594106; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table from the Data Lake Analytics catalog.
  ## 
  let valid = call_594113.validator(path, query, header, formData, body)
  let scheme = call_594113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594113.url(scheme.get, call_594113.host, call_594113.base,
                         call_594113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594113, url, valid)

proc call*(call_594114: Call_CatalogGetTable_594106; apiVersion: string;
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
  var path_594115 = newJObject()
  var query_594116 = newJObject()
  add(query_594116, "api-version", newJString(apiVersion))
  add(path_594115, "schemaName", newJString(schemaName))
  add(path_594115, "tableName", newJString(tableName))
  add(path_594115, "databaseName", newJString(databaseName))
  result = call_594114.call(path_594115, query_594116, nil, nil, nil)

var catalogGetTable* = Call_CatalogGetTable_594106(name: "catalogGetTable",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}",
    validator: validate_CatalogGetTable_594107, base: "", url: url_CatalogGetTable_594108,
    schemes: {Scheme.Https})
type
  Call_CatalogListTablePartitions_594117 = ref object of OpenApiRestCall_593408
proc url_CatalogListTablePartitions_594119(protocol: Scheme; host: string;
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

proc validate_CatalogListTablePartitions_594118(path: JsonNode; query: JsonNode;
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
  var valid_594120 = path.getOrDefault("schemaName")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "schemaName", valid_594120
  var valid_594121 = path.getOrDefault("tableName")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "tableName", valid_594121
  var valid_594122 = path.getOrDefault("databaseName")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "databaseName", valid_594122
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
  var valid_594123 = query.getOrDefault("$orderby")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "$orderby", valid_594123
  var valid_594124 = query.getOrDefault("$expand")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "$expand", valid_594124
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594125 = query.getOrDefault("api-version")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "api-version", valid_594125
  var valid_594126 = query.getOrDefault("$top")
  valid_594126 = validateParameter(valid_594126, JInt, required = false, default = nil)
  if valid_594126 != nil:
    section.add "$top", valid_594126
  var valid_594127 = query.getOrDefault("$select")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "$select", valid_594127
  var valid_594128 = query.getOrDefault("$skip")
  valid_594128 = validateParameter(valid_594128, JInt, required = false, default = nil)
  if valid_594128 != nil:
    section.add "$skip", valid_594128
  var valid_594129 = query.getOrDefault("$count")
  valid_594129 = validateParameter(valid_594129, JBool, required = false, default = nil)
  if valid_594129 != nil:
    section.add "$count", valid_594129
  var valid_594130 = query.getOrDefault("$filter")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "$filter", valid_594130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594131: Call_CatalogListTablePartitions_594117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table partitions from the Data Lake Analytics catalog.
  ## 
  let valid = call_594131.validator(path, query, header, formData, body)
  let scheme = call_594131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594131.url(scheme.get, call_594131.host, call_594131.base,
                         call_594131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594131, url, valid)

proc call*(call_594132: Call_CatalogListTablePartitions_594117; apiVersion: string;
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
  var path_594133 = newJObject()
  var query_594134 = newJObject()
  add(query_594134, "$orderby", newJString(Orderby))
  add(query_594134, "$expand", newJString(Expand))
  add(query_594134, "api-version", newJString(apiVersion))
  add(query_594134, "$top", newJInt(Top))
  add(path_594133, "schemaName", newJString(schemaName))
  add(path_594133, "tableName", newJString(tableName))
  add(query_594134, "$select", newJString(Select))
  add(path_594133, "databaseName", newJString(databaseName))
  add(query_594134, "$skip", newJInt(Skip))
  add(query_594134, "$count", newJBool(Count))
  add(query_594134, "$filter", newJString(Filter))
  result = call_594132.call(path_594133, query_594134, nil, nil, nil)

var catalogListTablePartitions* = Call_CatalogListTablePartitions_594117(
    name: "catalogListTablePartitions", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/partitions",
    validator: validate_CatalogListTablePartitions_594118, base: "",
    url: url_CatalogListTablePartitions_594119, schemes: {Scheme.Https})
type
  Call_CatalogGetTablePartition_594135 = ref object of OpenApiRestCall_593408
proc url_CatalogGetTablePartition_594137(protocol: Scheme; host: string;
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

proc validate_CatalogGetTablePartition_594136(path: JsonNode; query: JsonNode;
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
  var valid_594138 = path.getOrDefault("schemaName")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "schemaName", valid_594138
  var valid_594139 = path.getOrDefault("tableName")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "tableName", valid_594139
  var valid_594140 = path.getOrDefault("databaseName")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "databaseName", valid_594140
  var valid_594141 = path.getOrDefault("partitionName")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "partitionName", valid_594141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594142 = query.getOrDefault("api-version")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "api-version", valid_594142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594143: Call_CatalogGetTablePartition_594135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table partition from the Data Lake Analytics catalog.
  ## 
  let valid = call_594143.validator(path, query, header, formData, body)
  let scheme = call_594143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594143.url(scheme.get, call_594143.host, call_594143.base,
                         call_594143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594143, url, valid)

proc call*(call_594144: Call_CatalogGetTablePartition_594135; apiVersion: string;
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
  var path_594145 = newJObject()
  var query_594146 = newJObject()
  add(query_594146, "api-version", newJString(apiVersion))
  add(path_594145, "schemaName", newJString(schemaName))
  add(path_594145, "tableName", newJString(tableName))
  add(path_594145, "databaseName", newJString(databaseName))
  add(path_594145, "partitionName", newJString(partitionName))
  result = call_594144.call(path_594145, query_594146, nil, nil, nil)

var catalogGetTablePartition* = Call_CatalogGetTablePartition_594135(
    name: "catalogGetTablePartition", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/partitions/{partitionName}",
    validator: validate_CatalogGetTablePartition_594136, base: "",
    url: url_CatalogGetTablePartition_594137, schemes: {Scheme.Https})
type
  Call_CatalogListTableStatistics_594147 = ref object of OpenApiRestCall_593408
proc url_CatalogListTableStatistics_594149(protocol: Scheme; host: string;
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

proc validate_CatalogListTableStatistics_594148(path: JsonNode; query: JsonNode;
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
  var valid_594150 = path.getOrDefault("schemaName")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "schemaName", valid_594150
  var valid_594151 = path.getOrDefault("tableName")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "tableName", valid_594151
  var valid_594152 = path.getOrDefault("databaseName")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "databaseName", valid_594152
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
  var valid_594153 = query.getOrDefault("$orderby")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "$orderby", valid_594153
  var valid_594154 = query.getOrDefault("$expand")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "$expand", valid_594154
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594155 = query.getOrDefault("api-version")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "api-version", valid_594155
  var valid_594156 = query.getOrDefault("$top")
  valid_594156 = validateParameter(valid_594156, JInt, required = false, default = nil)
  if valid_594156 != nil:
    section.add "$top", valid_594156
  var valid_594157 = query.getOrDefault("$select")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "$select", valid_594157
  var valid_594158 = query.getOrDefault("$skip")
  valid_594158 = validateParameter(valid_594158, JInt, required = false, default = nil)
  if valid_594158 != nil:
    section.add "$skip", valid_594158
  var valid_594159 = query.getOrDefault("$count")
  valid_594159 = validateParameter(valid_594159, JBool, required = false, default = nil)
  if valid_594159 != nil:
    section.add "$count", valid_594159
  var valid_594160 = query.getOrDefault("$filter")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "$filter", valid_594160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594161: Call_CatalogListTableStatistics_594147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table statistics from the Data Lake Analytics catalog.
  ## 
  let valid = call_594161.validator(path, query, header, formData, body)
  let scheme = call_594161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594161.url(scheme.get, call_594161.host, call_594161.base,
                         call_594161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594161, url, valid)

proc call*(call_594162: Call_CatalogListTableStatistics_594147; apiVersion: string;
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
  var path_594163 = newJObject()
  var query_594164 = newJObject()
  add(query_594164, "$orderby", newJString(Orderby))
  add(query_594164, "$expand", newJString(Expand))
  add(query_594164, "api-version", newJString(apiVersion))
  add(query_594164, "$top", newJInt(Top))
  add(path_594163, "schemaName", newJString(schemaName))
  add(path_594163, "tableName", newJString(tableName))
  add(query_594164, "$select", newJString(Select))
  add(path_594163, "databaseName", newJString(databaseName))
  add(query_594164, "$skip", newJInt(Skip))
  add(query_594164, "$count", newJBool(Count))
  add(query_594164, "$filter", newJString(Filter))
  result = call_594162.call(path_594163, query_594164, nil, nil, nil)

var catalogListTableStatistics* = Call_CatalogListTableStatistics_594147(
    name: "catalogListTableStatistics", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/statistics",
    validator: validate_CatalogListTableStatistics_594148, base: "",
    url: url_CatalogListTableStatistics_594149, schemes: {Scheme.Https})
type
  Call_CatalogGetTableStatistic_594165 = ref object of OpenApiRestCall_593408
proc url_CatalogGetTableStatistic_594167(protocol: Scheme; host: string;
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

proc validate_CatalogGetTableStatistic_594166(path: JsonNode; query: JsonNode;
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
  var valid_594168 = path.getOrDefault("statisticsName")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "statisticsName", valid_594168
  var valid_594169 = path.getOrDefault("schemaName")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "schemaName", valid_594169
  var valid_594170 = path.getOrDefault("tableName")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "tableName", valid_594170
  var valid_594171 = path.getOrDefault("databaseName")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "databaseName", valid_594171
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594172 = query.getOrDefault("api-version")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "api-version", valid_594172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594173: Call_CatalogGetTableStatistic_594165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table statistics from the Data Lake Analytics catalog.
  ## 
  let valid = call_594173.validator(path, query, header, formData, body)
  let scheme = call_594173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594173.url(scheme.get, call_594173.host, call_594173.base,
                         call_594173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594173, url, valid)

proc call*(call_594174: Call_CatalogGetTableStatistic_594165;
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
  var path_594175 = newJObject()
  var query_594176 = newJObject()
  add(path_594175, "statisticsName", newJString(statisticsName))
  add(query_594176, "api-version", newJString(apiVersion))
  add(path_594175, "schemaName", newJString(schemaName))
  add(path_594175, "tableName", newJString(tableName))
  add(path_594175, "databaseName", newJString(databaseName))
  result = call_594174.call(path_594175, query_594176, nil, nil, nil)

var catalogGetTableStatistic* = Call_CatalogGetTableStatistic_594165(
    name: "catalogGetTableStatistic", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/statistics/{statisticsName}",
    validator: validate_CatalogGetTableStatistic_594166, base: "",
    url: url_CatalogGetTableStatistic_594167, schemes: {Scheme.Https})
type
  Call_CatalogListTableTypes_594177 = ref object of OpenApiRestCall_593408
proc url_CatalogListTableTypes_594179(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListTableTypes_594178(path: JsonNode; query: JsonNode;
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
  var valid_594180 = path.getOrDefault("schemaName")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "schemaName", valid_594180
  var valid_594181 = path.getOrDefault("databaseName")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "databaseName", valid_594181
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
  var valid_594182 = query.getOrDefault("$orderby")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = nil)
  if valid_594182 != nil:
    section.add "$orderby", valid_594182
  var valid_594183 = query.getOrDefault("$expand")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "$expand", valid_594183
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594184 = query.getOrDefault("api-version")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "api-version", valid_594184
  var valid_594185 = query.getOrDefault("$top")
  valid_594185 = validateParameter(valid_594185, JInt, required = false, default = nil)
  if valid_594185 != nil:
    section.add "$top", valid_594185
  var valid_594186 = query.getOrDefault("$select")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "$select", valid_594186
  var valid_594187 = query.getOrDefault("$skip")
  valid_594187 = validateParameter(valid_594187, JInt, required = false, default = nil)
  if valid_594187 != nil:
    section.add "$skip", valid_594187
  var valid_594188 = query.getOrDefault("$count")
  valid_594188 = validateParameter(valid_594188, JBool, required = false, default = nil)
  if valid_594188 != nil:
    section.add "$count", valid_594188
  var valid_594189 = query.getOrDefault("$filter")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "$filter", valid_594189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594190: Call_CatalogListTableTypes_594177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table types from the Data Lake Analytics catalog.
  ## 
  let valid = call_594190.validator(path, query, header, formData, body)
  let scheme = call_594190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594190.url(scheme.get, call_594190.host, call_594190.base,
                         call_594190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594190, url, valid)

proc call*(call_594191: Call_CatalogListTableTypes_594177; apiVersion: string;
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
  var path_594192 = newJObject()
  var query_594193 = newJObject()
  add(query_594193, "$orderby", newJString(Orderby))
  add(query_594193, "$expand", newJString(Expand))
  add(query_594193, "api-version", newJString(apiVersion))
  add(query_594193, "$top", newJInt(Top))
  add(path_594192, "schemaName", newJString(schemaName))
  add(query_594193, "$select", newJString(Select))
  add(path_594192, "databaseName", newJString(databaseName))
  add(query_594193, "$skip", newJInt(Skip))
  add(query_594193, "$count", newJBool(Count))
  add(query_594193, "$filter", newJString(Filter))
  result = call_594191.call(path_594192, query_594193, nil, nil, nil)

var catalogListTableTypes* = Call_CatalogListTableTypes_594177(
    name: "catalogListTableTypes", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tabletypes",
    validator: validate_CatalogListTableTypes_594178, base: "",
    url: url_CatalogListTableTypes_594179, schemes: {Scheme.Https})
type
  Call_CatalogGetTableType_594194 = ref object of OpenApiRestCall_593408
proc url_CatalogGetTableType_594196(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetTableType_594195(path: JsonNode; query: JsonNode;
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
  var valid_594197 = path.getOrDefault("schemaName")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "schemaName", valid_594197
  var valid_594198 = path.getOrDefault("databaseName")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "databaseName", valid_594198
  var valid_594199 = path.getOrDefault("tableTypeName")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "tableTypeName", valid_594199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594200 = query.getOrDefault("api-version")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "api-version", valid_594200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594201: Call_CatalogGetTableType_594194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table type from the Data Lake Analytics catalog.
  ## 
  let valid = call_594201.validator(path, query, header, formData, body)
  let scheme = call_594201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594201.url(scheme.get, call_594201.host, call_594201.base,
                         call_594201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594201, url, valid)

proc call*(call_594202: Call_CatalogGetTableType_594194; apiVersion: string;
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
  var path_594203 = newJObject()
  var query_594204 = newJObject()
  add(query_594204, "api-version", newJString(apiVersion))
  add(path_594203, "schemaName", newJString(schemaName))
  add(path_594203, "databaseName", newJString(databaseName))
  add(path_594203, "tableTypeName", newJString(tableTypeName))
  result = call_594202.call(path_594203, query_594204, nil, nil, nil)

var catalogGetTableType* = Call_CatalogGetTableType_594194(
    name: "catalogGetTableType", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tabletypes/{tableTypeName}",
    validator: validate_CatalogGetTableType_594195, base: "",
    url: url_CatalogGetTableType_594196, schemes: {Scheme.Https})
type
  Call_CatalogListTableValuedFunctions_594205 = ref object of OpenApiRestCall_593408
proc url_CatalogListTableValuedFunctions_594207(protocol: Scheme; host: string;
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

proc validate_CatalogListTableValuedFunctions_594206(path: JsonNode;
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
  var valid_594208 = path.getOrDefault("schemaName")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "schemaName", valid_594208
  var valid_594209 = path.getOrDefault("databaseName")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "databaseName", valid_594209
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
  var valid_594210 = query.getOrDefault("$orderby")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "$orderby", valid_594210
  var valid_594211 = query.getOrDefault("$expand")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "$expand", valid_594211
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594212 = query.getOrDefault("api-version")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "api-version", valid_594212
  var valid_594213 = query.getOrDefault("$top")
  valid_594213 = validateParameter(valid_594213, JInt, required = false, default = nil)
  if valid_594213 != nil:
    section.add "$top", valid_594213
  var valid_594214 = query.getOrDefault("$select")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "$select", valid_594214
  var valid_594215 = query.getOrDefault("$skip")
  valid_594215 = validateParameter(valid_594215, JInt, required = false, default = nil)
  if valid_594215 != nil:
    section.add "$skip", valid_594215
  var valid_594216 = query.getOrDefault("$count")
  valid_594216 = validateParameter(valid_594216, JBool, required = false, default = nil)
  if valid_594216 != nil:
    section.add "$count", valid_594216
  var valid_594217 = query.getOrDefault("$filter")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = nil)
  if valid_594217 != nil:
    section.add "$filter", valid_594217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594218: Call_CatalogListTableValuedFunctions_594205;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of table valued functions from the Data Lake Analytics catalog.
  ## 
  let valid = call_594218.validator(path, query, header, formData, body)
  let scheme = call_594218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594218.url(scheme.get, call_594218.host, call_594218.base,
                         call_594218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594218, url, valid)

proc call*(call_594219: Call_CatalogListTableValuedFunctions_594205;
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
  var path_594220 = newJObject()
  var query_594221 = newJObject()
  add(query_594221, "$orderby", newJString(Orderby))
  add(query_594221, "$expand", newJString(Expand))
  add(query_594221, "api-version", newJString(apiVersion))
  add(query_594221, "$top", newJInt(Top))
  add(path_594220, "schemaName", newJString(schemaName))
  add(query_594221, "$select", newJString(Select))
  add(path_594220, "databaseName", newJString(databaseName))
  add(query_594221, "$skip", newJInt(Skip))
  add(query_594221, "$count", newJBool(Count))
  add(query_594221, "$filter", newJString(Filter))
  result = call_594219.call(path_594220, query_594221, nil, nil, nil)

var catalogListTableValuedFunctions* = Call_CatalogListTableValuedFunctions_594205(
    name: "catalogListTableValuedFunctions", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tablevaluedfunctions",
    validator: validate_CatalogListTableValuedFunctions_594206, base: "",
    url: url_CatalogListTableValuedFunctions_594207, schemes: {Scheme.Https})
type
  Call_CatalogGetTableValuedFunction_594222 = ref object of OpenApiRestCall_593408
proc url_CatalogGetTableValuedFunction_594224(protocol: Scheme; host: string;
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

proc validate_CatalogGetTableValuedFunction_594223(path: JsonNode; query: JsonNode;
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
  var valid_594225 = path.getOrDefault("tableValuedFunctionName")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "tableValuedFunctionName", valid_594225
  var valid_594226 = path.getOrDefault("schemaName")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "schemaName", valid_594226
  var valid_594227 = path.getOrDefault("databaseName")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "databaseName", valid_594227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594228 = query.getOrDefault("api-version")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "api-version", valid_594228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594229: Call_CatalogGetTableValuedFunction_594222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table valued function from the Data Lake Analytics catalog.
  ## 
  let valid = call_594229.validator(path, query, header, formData, body)
  let scheme = call_594229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594229.url(scheme.get, call_594229.host, call_594229.base,
                         call_594229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594229, url, valid)

proc call*(call_594230: Call_CatalogGetTableValuedFunction_594222;
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
  var path_594231 = newJObject()
  var query_594232 = newJObject()
  add(query_594232, "api-version", newJString(apiVersion))
  add(path_594231, "tableValuedFunctionName", newJString(tableValuedFunctionName))
  add(path_594231, "schemaName", newJString(schemaName))
  add(path_594231, "databaseName", newJString(databaseName))
  result = call_594230.call(path_594231, query_594232, nil, nil, nil)

var catalogGetTableValuedFunction* = Call_CatalogGetTableValuedFunction_594222(
    name: "catalogGetTableValuedFunction", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tablevaluedfunctions/{tableValuedFunctionName}",
    validator: validate_CatalogGetTableValuedFunction_594223, base: "",
    url: url_CatalogGetTableValuedFunction_594224, schemes: {Scheme.Https})
type
  Call_CatalogListTypes_594233 = ref object of OpenApiRestCall_593408
proc url_CatalogListTypes_594235(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListTypes_594234(path: JsonNode; query: JsonNode;
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
  var valid_594236 = path.getOrDefault("schemaName")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "schemaName", valid_594236
  var valid_594237 = path.getOrDefault("databaseName")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "databaseName", valid_594237
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
  var valid_594238 = query.getOrDefault("$orderby")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = nil)
  if valid_594238 != nil:
    section.add "$orderby", valid_594238
  var valid_594239 = query.getOrDefault("$expand")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = nil)
  if valid_594239 != nil:
    section.add "$expand", valid_594239
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594240 = query.getOrDefault("api-version")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "api-version", valid_594240
  var valid_594241 = query.getOrDefault("$top")
  valid_594241 = validateParameter(valid_594241, JInt, required = false, default = nil)
  if valid_594241 != nil:
    section.add "$top", valid_594241
  var valid_594242 = query.getOrDefault("$select")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = nil)
  if valid_594242 != nil:
    section.add "$select", valid_594242
  var valid_594243 = query.getOrDefault("$skip")
  valid_594243 = validateParameter(valid_594243, JInt, required = false, default = nil)
  if valid_594243 != nil:
    section.add "$skip", valid_594243
  var valid_594244 = query.getOrDefault("$count")
  valid_594244 = validateParameter(valid_594244, JBool, required = false, default = nil)
  if valid_594244 != nil:
    section.add "$count", valid_594244
  var valid_594245 = query.getOrDefault("$filter")
  valid_594245 = validateParameter(valid_594245, JString, required = false,
                                 default = nil)
  if valid_594245 != nil:
    section.add "$filter", valid_594245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594246: Call_CatalogListTypes_594233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of types within the specified database and schema from the Data Lake Analytics catalog.
  ## 
  let valid = call_594246.validator(path, query, header, formData, body)
  let scheme = call_594246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594246.url(scheme.get, call_594246.host, call_594246.base,
                         call_594246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594246, url, valid)

proc call*(call_594247: Call_CatalogListTypes_594233; apiVersion: string;
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
  var path_594248 = newJObject()
  var query_594249 = newJObject()
  add(query_594249, "$orderby", newJString(Orderby))
  add(query_594249, "$expand", newJString(Expand))
  add(query_594249, "api-version", newJString(apiVersion))
  add(query_594249, "$top", newJInt(Top))
  add(path_594248, "schemaName", newJString(schemaName))
  add(query_594249, "$select", newJString(Select))
  add(path_594248, "databaseName", newJString(databaseName))
  add(query_594249, "$skip", newJInt(Skip))
  add(query_594249, "$count", newJBool(Count))
  add(query_594249, "$filter", newJString(Filter))
  result = call_594247.call(path_594248, query_594249, nil, nil, nil)

var catalogListTypes* = Call_CatalogListTypes_594233(name: "catalogListTypes",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/types",
    validator: validate_CatalogListTypes_594234, base: "",
    url: url_CatalogListTypes_594235, schemes: {Scheme.Https})
type
  Call_CatalogListViews_594250 = ref object of OpenApiRestCall_593408
proc url_CatalogListViews_594252(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListViews_594251(path: JsonNode; query: JsonNode;
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
  var valid_594253 = path.getOrDefault("schemaName")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "schemaName", valid_594253
  var valid_594254 = path.getOrDefault("databaseName")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "databaseName", valid_594254
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
  var valid_594255 = query.getOrDefault("$orderby")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = nil)
  if valid_594255 != nil:
    section.add "$orderby", valid_594255
  var valid_594256 = query.getOrDefault("$expand")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "$expand", valid_594256
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594257 = query.getOrDefault("api-version")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "api-version", valid_594257
  var valid_594258 = query.getOrDefault("$top")
  valid_594258 = validateParameter(valid_594258, JInt, required = false, default = nil)
  if valid_594258 != nil:
    section.add "$top", valid_594258
  var valid_594259 = query.getOrDefault("$select")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "$select", valid_594259
  var valid_594260 = query.getOrDefault("$skip")
  valid_594260 = validateParameter(valid_594260, JInt, required = false, default = nil)
  if valid_594260 != nil:
    section.add "$skip", valid_594260
  var valid_594261 = query.getOrDefault("$count")
  valid_594261 = validateParameter(valid_594261, JBool, required = false, default = nil)
  if valid_594261 != nil:
    section.add "$count", valid_594261
  var valid_594262 = query.getOrDefault("$filter")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = nil)
  if valid_594262 != nil:
    section.add "$filter", valid_594262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594263: Call_CatalogListViews_594250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of views from the Data Lake Analytics catalog.
  ## 
  let valid = call_594263.validator(path, query, header, formData, body)
  let scheme = call_594263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594263.url(scheme.get, call_594263.host, call_594263.base,
                         call_594263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594263, url, valid)

proc call*(call_594264: Call_CatalogListViews_594250; apiVersion: string;
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
  var path_594265 = newJObject()
  var query_594266 = newJObject()
  add(query_594266, "$orderby", newJString(Orderby))
  add(query_594266, "$expand", newJString(Expand))
  add(query_594266, "api-version", newJString(apiVersion))
  add(query_594266, "$top", newJInt(Top))
  add(path_594265, "schemaName", newJString(schemaName))
  add(query_594266, "$select", newJString(Select))
  add(path_594265, "databaseName", newJString(databaseName))
  add(query_594266, "$skip", newJInt(Skip))
  add(query_594266, "$count", newJBool(Count))
  add(query_594266, "$filter", newJString(Filter))
  result = call_594264.call(path_594265, query_594266, nil, nil, nil)

var catalogListViews* = Call_CatalogListViews_594250(name: "catalogListViews",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/views",
    validator: validate_CatalogListViews_594251, base: "",
    url: url_CatalogListViews_594252, schemes: {Scheme.Https})
type
  Call_CatalogGetView_594267 = ref object of OpenApiRestCall_593408
proc url_CatalogGetView_594269(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetView_594268(path: JsonNode; query: JsonNode;
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
  var valid_594270 = path.getOrDefault("viewName")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "viewName", valid_594270
  var valid_594271 = path.getOrDefault("schemaName")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "schemaName", valid_594271
  var valid_594272 = path.getOrDefault("databaseName")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "databaseName", valid_594272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594273 = query.getOrDefault("api-version")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "api-version", valid_594273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594274: Call_CatalogGetView_594267; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified view from the Data Lake Analytics catalog.
  ## 
  let valid = call_594274.validator(path, query, header, formData, body)
  let scheme = call_594274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594274.url(scheme.get, call_594274.host, call_594274.base,
                         call_594274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594274, url, valid)

proc call*(call_594275: Call_CatalogGetView_594267; apiVersion: string;
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
  var path_594276 = newJObject()
  var query_594277 = newJObject()
  add(query_594277, "api-version", newJString(apiVersion))
  add(path_594276, "viewName", newJString(viewName))
  add(path_594276, "schemaName", newJString(schemaName))
  add(path_594276, "databaseName", newJString(databaseName))
  result = call_594275.call(path_594276, query_594277, nil, nil, nil)

var catalogGetView* = Call_CatalogGetView_594267(name: "catalogGetView",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/views/{viewName}",
    validator: validate_CatalogGetView_594268, base: "", url: url_CatalogGetView_594269,
    schemes: {Scheme.Https})
type
  Call_CatalogDeleteAllSecrets_594278 = ref object of OpenApiRestCall_593408
proc url_CatalogDeleteAllSecrets_594280(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogDeleteAllSecrets_594279(path: JsonNode; query: JsonNode;
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
  var valid_594281 = path.getOrDefault("databaseName")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "databaseName", valid_594281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594282 = query.getOrDefault("api-version")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "api-version", valid_594282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594283: Call_CatalogDeleteAllSecrets_594278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes all secrets in the specified database
  ## 
  let valid = call_594283.validator(path, query, header, formData, body)
  let scheme = call_594283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594283.url(scheme.get, call_594283.host, call_594283.base,
                         call_594283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594283, url, valid)

proc call*(call_594284: Call_CatalogDeleteAllSecrets_594278; apiVersion: string;
          databaseName: string): Recallable =
  ## catalogDeleteAllSecrets
  ## Deletes all secrets in the specified database
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  var path_594285 = newJObject()
  var query_594286 = newJObject()
  add(query_594286, "api-version", newJString(apiVersion))
  add(path_594285, "databaseName", newJString(databaseName))
  result = call_594284.call(path_594285, query_594286, nil, nil, nil)

var catalogDeleteAllSecrets* = Call_CatalogDeleteAllSecrets_594278(
    name: "catalogDeleteAllSecrets", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/secrets",
    validator: validate_CatalogDeleteAllSecrets_594279, base: "",
    url: url_CatalogDeleteAllSecrets_594280, schemes: {Scheme.Https})
type
  Call_CatalogCreateSecret_594297 = ref object of OpenApiRestCall_593408
proc url_CatalogCreateSecret_594299(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogCreateSecret_594298(path: JsonNode; query: JsonNode;
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
  var valid_594317 = path.getOrDefault("databaseName")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "databaseName", valid_594317
  var valid_594318 = path.getOrDefault("secretName")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "secretName", valid_594318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594319 = query.getOrDefault("api-version")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = nil)
  if valid_594319 != nil:
    section.add "api-version", valid_594319
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

proc call*(call_594321: Call_CatalogCreateSecret_594297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the specified secret for use with external data sources in the specified database.
  ## 
  let valid = call_594321.validator(path, query, header, formData, body)
  let scheme = call_594321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594321.url(scheme.get, call_594321.host, call_594321.base,
                         call_594321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594321, url, valid)

proc call*(call_594322: Call_CatalogCreateSecret_594297; apiVersion: string;
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
  var path_594323 = newJObject()
  var query_594324 = newJObject()
  var body_594325 = newJObject()
  add(query_594324, "api-version", newJString(apiVersion))
  add(path_594323, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_594325 = parameters
  add(path_594323, "secretName", newJString(secretName))
  result = call_594322.call(path_594323, query_594324, nil, nil, body_594325)

var catalogCreateSecret* = Call_CatalogCreateSecret_594297(
    name: "catalogCreateSecret", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogCreateSecret_594298, base: "",
    url: url_CatalogCreateSecret_594299, schemes: {Scheme.Https})
type
  Call_CatalogGetSecret_594287 = ref object of OpenApiRestCall_593408
proc url_CatalogGetSecret_594289(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetSecret_594288(path: JsonNode; query: JsonNode;
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
  var valid_594290 = path.getOrDefault("databaseName")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "databaseName", valid_594290
  var valid_594291 = path.getOrDefault("secretName")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "secretName", valid_594291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594292 = query.getOrDefault("api-version")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "api-version", valid_594292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594293: Call_CatalogGetSecret_594287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified secret in the specified database
  ## 
  let valid = call_594293.validator(path, query, header, formData, body)
  let scheme = call_594293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594293.url(scheme.get, call_594293.host, call_594293.base,
                         call_594293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594293, url, valid)

proc call*(call_594294: Call_CatalogGetSecret_594287; apiVersion: string;
          databaseName: string; secretName: string): Recallable =
  ## catalogGetSecret
  ## Gets the specified secret in the specified database
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  ##   secretName: string (required)
  ##             : The name of the secret to get
  var path_594295 = newJObject()
  var query_594296 = newJObject()
  add(query_594296, "api-version", newJString(apiVersion))
  add(path_594295, "databaseName", newJString(databaseName))
  add(path_594295, "secretName", newJString(secretName))
  result = call_594294.call(path_594295, query_594296, nil, nil, nil)

var catalogGetSecret* = Call_CatalogGetSecret_594287(name: "catalogGetSecret",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogGetSecret_594288, base: "",
    url: url_CatalogGetSecret_594289, schemes: {Scheme.Https})
type
  Call_CatalogUpdateSecret_594336 = ref object of OpenApiRestCall_593408
proc url_CatalogUpdateSecret_594338(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogUpdateSecret_594337(path: JsonNode; query: JsonNode;
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
  var valid_594339 = path.getOrDefault("databaseName")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "databaseName", valid_594339
  var valid_594340 = path.getOrDefault("secretName")
  valid_594340 = validateParameter(valid_594340, JString, required = true,
                                 default = nil)
  if valid_594340 != nil:
    section.add "secretName", valid_594340
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594341 = query.getOrDefault("api-version")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "api-version", valid_594341
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

proc call*(call_594343: Call_CatalogUpdateSecret_594336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the specified secret for use with external data sources in the specified database
  ## 
  let valid = call_594343.validator(path, query, header, formData, body)
  let scheme = call_594343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594343.url(scheme.get, call_594343.host, call_594343.base,
                         call_594343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594343, url, valid)

proc call*(call_594344: Call_CatalogUpdateSecret_594336; apiVersion: string;
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
  var path_594345 = newJObject()
  var query_594346 = newJObject()
  var body_594347 = newJObject()
  add(query_594346, "api-version", newJString(apiVersion))
  add(path_594345, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_594347 = parameters
  add(path_594345, "secretName", newJString(secretName))
  result = call_594344.call(path_594345, query_594346, nil, nil, body_594347)

var catalogUpdateSecret* = Call_CatalogUpdateSecret_594336(
    name: "catalogUpdateSecret", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogUpdateSecret_594337, base: "",
    url: url_CatalogUpdateSecret_594338, schemes: {Scheme.Https})
type
  Call_CatalogDeleteSecret_594326 = ref object of OpenApiRestCall_593408
proc url_CatalogDeleteSecret_594328(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogDeleteSecret_594327(path: JsonNode; query: JsonNode;
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
  var valid_594329 = path.getOrDefault("databaseName")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "databaseName", valid_594329
  var valid_594330 = path.getOrDefault("secretName")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "secretName", valid_594330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594331 = query.getOrDefault("api-version")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "api-version", valid_594331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594332: Call_CatalogDeleteSecret_594326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified secret in the specified database
  ## 
  let valid = call_594332.validator(path, query, header, formData, body)
  let scheme = call_594332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594332.url(scheme.get, call_594332.host, call_594332.base,
                         call_594332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594332, url, valid)

proc call*(call_594333: Call_CatalogDeleteSecret_594326; apiVersion: string;
          databaseName: string; secretName: string): Recallable =
  ## catalogDeleteSecret
  ## Deletes the specified secret in the specified database
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  ##   secretName: string (required)
  ##             : The name of the secret to delete
  var path_594334 = newJObject()
  var query_594335 = newJObject()
  add(query_594335, "api-version", newJString(apiVersion))
  add(path_594334, "databaseName", newJString(databaseName))
  add(path_594334, "secretName", newJString(secretName))
  result = call_594333.call(path_594334, query_594335, nil, nil, nil)

var catalogDeleteSecret* = Call_CatalogDeleteSecret_594326(
    name: "catalogDeleteSecret", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogDeleteSecret_594327, base: "",
    url: url_CatalogDeleteSecret_594328, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
