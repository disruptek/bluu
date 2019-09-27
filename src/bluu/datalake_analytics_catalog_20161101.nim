
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593437): Option[Scheme] {.used.} =
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
  Call_CatalogListAcls_593659 = ref object of OpenApiRestCall_593437
proc url_CatalogListAcls_593661(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CatalogListAcls_593660(path: JsonNode; query: JsonNode;
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
  var valid_593821 = query.getOrDefault("$orderby")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "$orderby", valid_593821
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593822 = query.getOrDefault("api-version")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "api-version", valid_593822
  var valid_593823 = query.getOrDefault("$top")
  valid_593823 = validateParameter(valid_593823, JInt, required = false, default = nil)
  if valid_593823 != nil:
    section.add "$top", valid_593823
  var valid_593824 = query.getOrDefault("$select")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "$select", valid_593824
  var valid_593825 = query.getOrDefault("$skip")
  valid_593825 = validateParameter(valid_593825, JInt, required = false, default = nil)
  if valid_593825 != nil:
    section.add "$skip", valid_593825
  var valid_593826 = query.getOrDefault("$count")
  valid_593826 = validateParameter(valid_593826, JBool, required = false, default = nil)
  if valid_593826 != nil:
    section.add "$count", valid_593826
  var valid_593827 = query.getOrDefault("$filter")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "$filter", valid_593827
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593850: Call_CatalogListAcls_593659; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of access control list (ACL) entries for the Data Lake Analytics catalog.
  ## 
  let valid = call_593850.validator(path, query, header, formData, body)
  let scheme = call_593850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593850.url(scheme.get, call_593850.host, call_593850.base,
                         call_593850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593850, url, valid)

proc call*(call_593921: Call_CatalogListAcls_593659; apiVersion: string;
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
  var query_593922 = newJObject()
  add(query_593922, "$orderby", newJString(Orderby))
  add(query_593922, "api-version", newJString(apiVersion))
  add(query_593922, "$top", newJInt(Top))
  add(query_593922, "$select", newJString(Select))
  add(query_593922, "$skip", newJInt(Skip))
  add(query_593922, "$count", newJBool(Count))
  add(query_593922, "$filter", newJString(Filter))
  result = call_593921.call(nil, query_593922, nil, nil, nil)

var catalogListAcls* = Call_CatalogListAcls_593659(name: "catalogListAcls",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/acl",
    validator: validate_CatalogListAcls_593660, base: "", url: url_CatalogListAcls_593661,
    schemes: {Scheme.Https})
type
  Call_CatalogListDatabases_593962 = ref object of OpenApiRestCall_593437
proc url_CatalogListDatabases_593964(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CatalogListDatabases_593963(path: JsonNode; query: JsonNode;
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
  var valid_593965 = query.getOrDefault("$orderby")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "$orderby", valid_593965
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593966 = query.getOrDefault("api-version")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "api-version", valid_593966
  var valid_593967 = query.getOrDefault("$top")
  valid_593967 = validateParameter(valid_593967, JInt, required = false, default = nil)
  if valid_593967 != nil:
    section.add "$top", valid_593967
  var valid_593968 = query.getOrDefault("$select")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "$select", valid_593968
  var valid_593969 = query.getOrDefault("$skip")
  valid_593969 = validateParameter(valid_593969, JInt, required = false, default = nil)
  if valid_593969 != nil:
    section.add "$skip", valid_593969
  var valid_593970 = query.getOrDefault("$count")
  valid_593970 = validateParameter(valid_593970, JBool, required = false, default = nil)
  if valid_593970 != nil:
    section.add "$count", valid_593970
  var valid_593971 = query.getOrDefault("$filter")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "$filter", valid_593971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593972: Call_CatalogListDatabases_593962; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of databases from the Data Lake Analytics catalog.
  ## 
  let valid = call_593972.validator(path, query, header, formData, body)
  let scheme = call_593972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593972.url(scheme.get, call_593972.host, call_593972.base,
                         call_593972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593972, url, valid)

proc call*(call_593973: Call_CatalogListDatabases_593962; apiVersion: string;
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
  var query_593974 = newJObject()
  add(query_593974, "$orderby", newJString(Orderby))
  add(query_593974, "api-version", newJString(apiVersion))
  add(query_593974, "$top", newJInt(Top))
  add(query_593974, "$select", newJString(Select))
  add(query_593974, "$skip", newJInt(Skip))
  add(query_593974, "$count", newJBool(Count))
  add(query_593974, "$filter", newJString(Filter))
  result = call_593973.call(nil, query_593974, nil, nil, nil)

var catalogListDatabases* = Call_CatalogListDatabases_593962(
    name: "catalogListDatabases", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases", validator: validate_CatalogListDatabases_593963,
    base: "", url: url_CatalogListDatabases_593964, schemes: {Scheme.Https})
type
  Call_CatalogGetDatabase_593975 = ref object of OpenApiRestCall_593437
proc url_CatalogGetDatabase_593977(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetDatabase_593976(path: JsonNode; query: JsonNode;
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
  var valid_593992 = path.getOrDefault("databaseName")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "databaseName", valid_593992
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593993 = query.getOrDefault("api-version")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "api-version", valid_593993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593994: Call_CatalogGetDatabase_593975; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified database from the Data Lake Analytics catalog.
  ## 
  let valid = call_593994.validator(path, query, header, formData, body)
  let scheme = call_593994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593994.url(scheme.get, call_593994.host, call_593994.base,
                         call_593994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593994, url, valid)

proc call*(call_593995: Call_CatalogGetDatabase_593975; apiVersion: string;
          databaseName: string): Recallable =
  ## catalogGetDatabase
  ## Retrieves the specified database from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database.
  var path_593996 = newJObject()
  var query_593997 = newJObject()
  add(query_593997, "api-version", newJString(apiVersion))
  add(path_593996, "databaseName", newJString(databaseName))
  result = call_593995.call(path_593996, query_593997, nil, nil, nil)

var catalogGetDatabase* = Call_CatalogGetDatabase_593975(
    name: "catalogGetDatabase", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}",
    validator: validate_CatalogGetDatabase_593976, base: "",
    url: url_CatalogGetDatabase_593977, schemes: {Scheme.Https})
type
  Call_CatalogListAclsByDatabase_593998 = ref object of OpenApiRestCall_593437
proc url_CatalogListAclsByDatabase_594000(protocol: Scheme; host: string;
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

proc validate_CatalogListAclsByDatabase_593999(path: JsonNode; query: JsonNode;
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
  var valid_594001 = path.getOrDefault("databaseName")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "databaseName", valid_594001
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
  var valid_594002 = query.getOrDefault("$orderby")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "$orderby", valid_594002
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594003 = query.getOrDefault("api-version")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "api-version", valid_594003
  var valid_594004 = query.getOrDefault("$top")
  valid_594004 = validateParameter(valid_594004, JInt, required = false, default = nil)
  if valid_594004 != nil:
    section.add "$top", valid_594004
  var valid_594005 = query.getOrDefault("$select")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "$select", valid_594005
  var valid_594006 = query.getOrDefault("$skip")
  valid_594006 = validateParameter(valid_594006, JInt, required = false, default = nil)
  if valid_594006 != nil:
    section.add "$skip", valid_594006
  var valid_594007 = query.getOrDefault("$count")
  valid_594007 = validateParameter(valid_594007, JBool, required = false, default = nil)
  if valid_594007 != nil:
    section.add "$count", valid_594007
  var valid_594008 = query.getOrDefault("$filter")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "$filter", valid_594008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594009: Call_CatalogListAclsByDatabase_593998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of access control list (ACL) entries for the database from the Data Lake Analytics catalog.
  ## 
  let valid = call_594009.validator(path, query, header, formData, body)
  let scheme = call_594009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594009.url(scheme.get, call_594009.host, call_594009.base,
                         call_594009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594009, url, valid)

proc call*(call_594010: Call_CatalogListAclsByDatabase_593998; apiVersion: string;
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
  var path_594011 = newJObject()
  var query_594012 = newJObject()
  add(query_594012, "$orderby", newJString(Orderby))
  add(query_594012, "api-version", newJString(apiVersion))
  add(query_594012, "$top", newJInt(Top))
  add(query_594012, "$select", newJString(Select))
  add(path_594011, "databaseName", newJString(databaseName))
  add(query_594012, "$skip", newJInt(Skip))
  add(query_594012, "$count", newJBool(Count))
  add(query_594012, "$filter", newJString(Filter))
  result = call_594010.call(path_594011, query_594012, nil, nil, nil)

var catalogListAclsByDatabase* = Call_CatalogListAclsByDatabase_593998(
    name: "catalogListAclsByDatabase", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/acl",
    validator: validate_CatalogListAclsByDatabase_593999, base: "",
    url: url_CatalogListAclsByDatabase_594000, schemes: {Scheme.Https})
type
  Call_CatalogListAssemblies_594013 = ref object of OpenApiRestCall_593437
proc url_CatalogListAssemblies_594015(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListAssemblies_594014(path: JsonNode; query: JsonNode;
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
  var valid_594016 = path.getOrDefault("databaseName")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "databaseName", valid_594016
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
  var valid_594017 = query.getOrDefault("$orderby")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "$orderby", valid_594017
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594018 = query.getOrDefault("api-version")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "api-version", valid_594018
  var valid_594019 = query.getOrDefault("$top")
  valid_594019 = validateParameter(valid_594019, JInt, required = false, default = nil)
  if valid_594019 != nil:
    section.add "$top", valid_594019
  var valid_594020 = query.getOrDefault("$select")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "$select", valid_594020
  var valid_594021 = query.getOrDefault("$skip")
  valid_594021 = validateParameter(valid_594021, JInt, required = false, default = nil)
  if valid_594021 != nil:
    section.add "$skip", valid_594021
  var valid_594022 = query.getOrDefault("$count")
  valid_594022 = validateParameter(valid_594022, JBool, required = false, default = nil)
  if valid_594022 != nil:
    section.add "$count", valid_594022
  var valid_594023 = query.getOrDefault("$filter")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "$filter", valid_594023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594024: Call_CatalogListAssemblies_594013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of assemblies from the Data Lake Analytics catalog.
  ## 
  let valid = call_594024.validator(path, query, header, formData, body)
  let scheme = call_594024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594024.url(scheme.get, call_594024.host, call_594024.base,
                         call_594024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594024, url, valid)

proc call*(call_594025: Call_CatalogListAssemblies_594013; apiVersion: string;
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
  var path_594026 = newJObject()
  var query_594027 = newJObject()
  add(query_594027, "$orderby", newJString(Orderby))
  add(query_594027, "api-version", newJString(apiVersion))
  add(query_594027, "$top", newJInt(Top))
  add(query_594027, "$select", newJString(Select))
  add(path_594026, "databaseName", newJString(databaseName))
  add(query_594027, "$skip", newJInt(Skip))
  add(query_594027, "$count", newJBool(Count))
  add(query_594027, "$filter", newJString(Filter))
  result = call_594025.call(path_594026, query_594027, nil, nil, nil)

var catalogListAssemblies* = Call_CatalogListAssemblies_594013(
    name: "catalogListAssemblies", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/assemblies",
    validator: validate_CatalogListAssemblies_594014, base: "",
    url: url_CatalogListAssemblies_594015, schemes: {Scheme.Https})
type
  Call_CatalogGetAssembly_594028 = ref object of OpenApiRestCall_593437
proc url_CatalogGetAssembly_594030(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetAssembly_594029(path: JsonNode; query: JsonNode;
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
  var valid_594031 = path.getOrDefault("databaseName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "databaseName", valid_594031
  var valid_594032 = path.getOrDefault("assemblyName")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "assemblyName", valid_594032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594033 = query.getOrDefault("api-version")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "api-version", valid_594033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594034: Call_CatalogGetAssembly_594028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified assembly from the Data Lake Analytics catalog.
  ## 
  let valid = call_594034.validator(path, query, header, formData, body)
  let scheme = call_594034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594034.url(scheme.get, call_594034.host, call_594034.base,
                         call_594034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594034, url, valid)

proc call*(call_594035: Call_CatalogGetAssembly_594028; apiVersion: string;
          databaseName: string; assemblyName: string): Recallable =
  ## catalogGetAssembly
  ## Retrieves the specified assembly from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the assembly.
  ##   assemblyName: string (required)
  ##               : The name of the assembly.
  var path_594036 = newJObject()
  var query_594037 = newJObject()
  add(query_594037, "api-version", newJString(apiVersion))
  add(path_594036, "databaseName", newJString(databaseName))
  add(path_594036, "assemblyName", newJString(assemblyName))
  result = call_594035.call(path_594036, query_594037, nil, nil, nil)

var catalogGetAssembly* = Call_CatalogGetAssembly_594028(
    name: "catalogGetAssembly", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/assemblies/{assemblyName}",
    validator: validate_CatalogGetAssembly_594029, base: "",
    url: url_CatalogGetAssembly_594030, schemes: {Scheme.Https})
type
  Call_CatalogListCredentials_594038 = ref object of OpenApiRestCall_593437
proc url_CatalogListCredentials_594040(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListCredentials_594039(path: JsonNode; query: JsonNode;
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
  var valid_594041 = path.getOrDefault("databaseName")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "databaseName", valid_594041
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
  var valid_594042 = query.getOrDefault("$orderby")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "$orderby", valid_594042
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594043 = query.getOrDefault("api-version")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "api-version", valid_594043
  var valid_594044 = query.getOrDefault("$top")
  valid_594044 = validateParameter(valid_594044, JInt, required = false, default = nil)
  if valid_594044 != nil:
    section.add "$top", valid_594044
  var valid_594045 = query.getOrDefault("$select")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "$select", valid_594045
  var valid_594046 = query.getOrDefault("$skip")
  valid_594046 = validateParameter(valid_594046, JInt, required = false, default = nil)
  if valid_594046 != nil:
    section.add "$skip", valid_594046
  var valid_594047 = query.getOrDefault("$count")
  valid_594047 = validateParameter(valid_594047, JBool, required = false, default = nil)
  if valid_594047 != nil:
    section.add "$count", valid_594047
  var valid_594048 = query.getOrDefault("$filter")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "$filter", valid_594048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594049: Call_CatalogListCredentials_594038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of credentials from the Data Lake Analytics catalog.
  ## 
  let valid = call_594049.validator(path, query, header, formData, body)
  let scheme = call_594049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594049.url(scheme.get, call_594049.host, call_594049.base,
                         call_594049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594049, url, valid)

proc call*(call_594050: Call_CatalogListCredentials_594038; apiVersion: string;
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
  var path_594051 = newJObject()
  var query_594052 = newJObject()
  add(query_594052, "$orderby", newJString(Orderby))
  add(query_594052, "api-version", newJString(apiVersion))
  add(query_594052, "$top", newJInt(Top))
  add(query_594052, "$select", newJString(Select))
  add(path_594051, "databaseName", newJString(databaseName))
  add(query_594052, "$skip", newJInt(Skip))
  add(query_594052, "$count", newJBool(Count))
  add(query_594052, "$filter", newJString(Filter))
  result = call_594050.call(path_594051, query_594052, nil, nil, nil)

var catalogListCredentials* = Call_CatalogListCredentials_594038(
    name: "catalogListCredentials", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/credentials",
    validator: validate_CatalogListCredentials_594039, base: "",
    url: url_CatalogListCredentials_594040, schemes: {Scheme.Https})
type
  Call_CatalogCreateCredential_594063 = ref object of OpenApiRestCall_593437
proc url_CatalogCreateCredential_594065(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogCreateCredential_594064(path: JsonNode; query: JsonNode;
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
  var valid_594083 = path.getOrDefault("databaseName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "databaseName", valid_594083
  var valid_594084 = path.getOrDefault("credentialName")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "credentialName", valid_594084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594085 = query.getOrDefault("api-version")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "api-version", valid_594085
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

proc call*(call_594087: Call_CatalogCreateCredential_594063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the specified credential for use with external data sources in the specified database.
  ## 
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_CatalogCreateCredential_594063; apiVersion: string;
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
  var path_594089 = newJObject()
  var query_594090 = newJObject()
  var body_594091 = newJObject()
  add(query_594090, "api-version", newJString(apiVersion))
  add(path_594089, "databaseName", newJString(databaseName))
  add(path_594089, "credentialName", newJString(credentialName))
  if parameters != nil:
    body_594091 = parameters
  result = call_594088.call(path_594089, query_594090, nil, nil, body_594091)

var catalogCreateCredential* = Call_CatalogCreateCredential_594063(
    name: "catalogCreateCredential", meth: HttpMethod.HttpPut, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/credentials/{credentialName}",
    validator: validate_CatalogCreateCredential_594064, base: "",
    url: url_CatalogCreateCredential_594065, schemes: {Scheme.Https})
type
  Call_CatalogDeleteCredential_594092 = ref object of OpenApiRestCall_593437
proc url_CatalogDeleteCredential_594094(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogDeleteCredential_594093(path: JsonNode; query: JsonNode;
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
  var valid_594095 = path.getOrDefault("databaseName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "databaseName", valid_594095
  var valid_594096 = path.getOrDefault("credentialName")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "credentialName", valid_594096
  result.add "path", section
  ## parameters in `query` object:
  ##   cascade: JBool
  ##          : Indicates if the delete should be a cascading delete (which deletes all resources dependent on the credential as well as the credential) or not. If false will fail if there are any resources relying on the credential.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_594110 = query.getOrDefault("cascade")
  valid_594110 = validateParameter(valid_594110, JBool, required = false,
                                 default = newJBool(false))
  if valid_594110 != nil:
    section.add "cascade", valid_594110
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594111 = query.getOrDefault("api-version")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "api-version", valid_594111
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

proc call*(call_594113: Call_CatalogDeleteCredential_594092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified credential in the specified database
  ## 
  let valid = call_594113.validator(path, query, header, formData, body)
  let scheme = call_594113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594113.url(scheme.get, call_594113.host, call_594113.base,
                         call_594113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594113, url, valid)

proc call*(call_594114: Call_CatalogDeleteCredential_594092; apiVersion: string;
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
  var path_594115 = newJObject()
  var query_594116 = newJObject()
  var body_594117 = newJObject()
  add(query_594116, "cascade", newJBool(cascade))
  add(query_594116, "api-version", newJString(apiVersion))
  add(path_594115, "databaseName", newJString(databaseName))
  add(path_594115, "credentialName", newJString(credentialName))
  if parameters != nil:
    body_594117 = parameters
  result = call_594114.call(path_594115, query_594116, nil, nil, body_594117)

var catalogDeleteCredential* = Call_CatalogDeleteCredential_594092(
    name: "catalogDeleteCredential", meth: HttpMethod.HttpPost, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/credentials/{credentialName}",
    validator: validate_CatalogDeleteCredential_594093, base: "",
    url: url_CatalogDeleteCredential_594094, schemes: {Scheme.Https})
type
  Call_CatalogGetCredential_594053 = ref object of OpenApiRestCall_593437
proc url_CatalogGetCredential_594055(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetCredential_594054(path: JsonNode; query: JsonNode;
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
  var valid_594056 = path.getOrDefault("databaseName")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "databaseName", valid_594056
  var valid_594057 = path.getOrDefault("credentialName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "credentialName", valid_594057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594058 = query.getOrDefault("api-version")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "api-version", valid_594058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594059: Call_CatalogGetCredential_594053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified credential from the Data Lake Analytics catalog.
  ## 
  let valid = call_594059.validator(path, query, header, formData, body)
  let scheme = call_594059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594059.url(scheme.get, call_594059.host, call_594059.base,
                         call_594059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594059, url, valid)

proc call*(call_594060: Call_CatalogGetCredential_594053; apiVersion: string;
          databaseName: string; credentialName: string): Recallable =
  ## catalogGetCredential
  ## Retrieves the specified credential from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the schema.
  ##   credentialName: string (required)
  ##                 : The name of the credential.
  var path_594061 = newJObject()
  var query_594062 = newJObject()
  add(query_594062, "api-version", newJString(apiVersion))
  add(path_594061, "databaseName", newJString(databaseName))
  add(path_594061, "credentialName", newJString(credentialName))
  result = call_594060.call(path_594061, query_594062, nil, nil, nil)

var catalogGetCredential* = Call_CatalogGetCredential_594053(
    name: "catalogGetCredential", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/credentials/{credentialName}",
    validator: validate_CatalogGetCredential_594054, base: "",
    url: url_CatalogGetCredential_594055, schemes: {Scheme.Https})
type
  Call_CatalogUpdateCredential_594118 = ref object of OpenApiRestCall_593437
proc url_CatalogUpdateCredential_594120(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogUpdateCredential_594119(path: JsonNode; query: JsonNode;
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
  var valid_594121 = path.getOrDefault("databaseName")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "databaseName", valid_594121
  var valid_594122 = path.getOrDefault("credentialName")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "credentialName", valid_594122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594123 = query.getOrDefault("api-version")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "api-version", valid_594123
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

proc call*(call_594125: Call_CatalogUpdateCredential_594118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the specified credential for use with external data sources in the specified database
  ## 
  let valid = call_594125.validator(path, query, header, formData, body)
  let scheme = call_594125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594125.url(scheme.get, call_594125.host, call_594125.base,
                         call_594125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594125, url, valid)

proc call*(call_594126: Call_CatalogUpdateCredential_594118; apiVersion: string;
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
  var path_594127 = newJObject()
  var query_594128 = newJObject()
  var body_594129 = newJObject()
  add(query_594128, "api-version", newJString(apiVersion))
  add(path_594127, "databaseName", newJString(databaseName))
  add(path_594127, "credentialName", newJString(credentialName))
  if parameters != nil:
    body_594129 = parameters
  result = call_594126.call(path_594127, query_594128, nil, nil, body_594129)

var catalogUpdateCredential* = Call_CatalogUpdateCredential_594118(
    name: "catalogUpdateCredential", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/credentials/{credentialName}",
    validator: validate_CatalogUpdateCredential_594119, base: "",
    url: url_CatalogUpdateCredential_594120, schemes: {Scheme.Https})
type
  Call_CatalogListExternalDataSources_594130 = ref object of OpenApiRestCall_593437
proc url_CatalogListExternalDataSources_594132(protocol: Scheme; host: string;
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

proc validate_CatalogListExternalDataSources_594131(path: JsonNode;
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
  var valid_594133 = path.getOrDefault("databaseName")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "databaseName", valid_594133
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
  var valid_594134 = query.getOrDefault("$orderby")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "$orderby", valid_594134
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594135 = query.getOrDefault("api-version")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "api-version", valid_594135
  var valid_594136 = query.getOrDefault("$top")
  valid_594136 = validateParameter(valid_594136, JInt, required = false, default = nil)
  if valid_594136 != nil:
    section.add "$top", valid_594136
  var valid_594137 = query.getOrDefault("$select")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "$select", valid_594137
  var valid_594138 = query.getOrDefault("$skip")
  valid_594138 = validateParameter(valid_594138, JInt, required = false, default = nil)
  if valid_594138 != nil:
    section.add "$skip", valid_594138
  var valid_594139 = query.getOrDefault("$count")
  valid_594139 = validateParameter(valid_594139, JBool, required = false, default = nil)
  if valid_594139 != nil:
    section.add "$count", valid_594139
  var valid_594140 = query.getOrDefault("$filter")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "$filter", valid_594140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594141: Call_CatalogListExternalDataSources_594130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of external data sources from the Data Lake Analytics catalog.
  ## 
  let valid = call_594141.validator(path, query, header, formData, body)
  let scheme = call_594141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594141.url(scheme.get, call_594141.host, call_594141.base,
                         call_594141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594141, url, valid)

proc call*(call_594142: Call_CatalogListExternalDataSources_594130;
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
  var path_594143 = newJObject()
  var query_594144 = newJObject()
  add(query_594144, "$orderby", newJString(Orderby))
  add(query_594144, "api-version", newJString(apiVersion))
  add(query_594144, "$top", newJInt(Top))
  add(query_594144, "$select", newJString(Select))
  add(path_594143, "databaseName", newJString(databaseName))
  add(query_594144, "$skip", newJInt(Skip))
  add(query_594144, "$count", newJBool(Count))
  add(query_594144, "$filter", newJString(Filter))
  result = call_594142.call(path_594143, query_594144, nil, nil, nil)

var catalogListExternalDataSources* = Call_CatalogListExternalDataSources_594130(
    name: "catalogListExternalDataSources", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/externaldatasources",
    validator: validate_CatalogListExternalDataSources_594131, base: "",
    url: url_CatalogListExternalDataSources_594132, schemes: {Scheme.Https})
type
  Call_CatalogGetExternalDataSource_594145 = ref object of OpenApiRestCall_593437
proc url_CatalogGetExternalDataSource_594147(protocol: Scheme; host: string;
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

proc validate_CatalogGetExternalDataSource_594146(path: JsonNode; query: JsonNode;
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
  var valid_594148 = path.getOrDefault("externalDataSourceName")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "externalDataSourceName", valid_594148
  var valid_594149 = path.getOrDefault("databaseName")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "databaseName", valid_594149
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594150 = query.getOrDefault("api-version")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "api-version", valid_594150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594151: Call_CatalogGetExternalDataSource_594145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified external data source from the Data Lake Analytics catalog.
  ## 
  let valid = call_594151.validator(path, query, header, formData, body)
  let scheme = call_594151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594151.url(scheme.get, call_594151.host, call_594151.base,
                         call_594151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594151, url, valid)

proc call*(call_594152: Call_CatalogGetExternalDataSource_594145;
          externalDataSourceName: string; apiVersion: string; databaseName: string): Recallable =
  ## catalogGetExternalDataSource
  ## Retrieves the specified external data source from the Data Lake Analytics catalog.
  ##   externalDataSourceName: string (required)
  ##                         : The name of the external data source.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the external data source.
  var path_594153 = newJObject()
  var query_594154 = newJObject()
  add(path_594153, "externalDataSourceName", newJString(externalDataSourceName))
  add(query_594154, "api-version", newJString(apiVersion))
  add(path_594153, "databaseName", newJString(databaseName))
  result = call_594152.call(path_594153, query_594154, nil, nil, nil)

var catalogGetExternalDataSource* = Call_CatalogGetExternalDataSource_594145(
    name: "catalogGetExternalDataSource", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/externaldatasources/{externalDataSourceName}",
    validator: validate_CatalogGetExternalDataSource_594146, base: "",
    url: url_CatalogGetExternalDataSource_594147, schemes: {Scheme.Https})
type
  Call_CatalogListSchemas_594155 = ref object of OpenApiRestCall_593437
proc url_CatalogListSchemas_594157(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListSchemas_594156(path: JsonNode; query: JsonNode;
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
  var valid_594158 = path.getOrDefault("databaseName")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "databaseName", valid_594158
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
  var valid_594159 = query.getOrDefault("$orderby")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = nil)
  if valid_594159 != nil:
    section.add "$orderby", valid_594159
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594160 = query.getOrDefault("api-version")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "api-version", valid_594160
  var valid_594161 = query.getOrDefault("$top")
  valid_594161 = validateParameter(valid_594161, JInt, required = false, default = nil)
  if valid_594161 != nil:
    section.add "$top", valid_594161
  var valid_594162 = query.getOrDefault("$select")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "$select", valid_594162
  var valid_594163 = query.getOrDefault("$skip")
  valid_594163 = validateParameter(valid_594163, JInt, required = false, default = nil)
  if valid_594163 != nil:
    section.add "$skip", valid_594163
  var valid_594164 = query.getOrDefault("$count")
  valid_594164 = validateParameter(valid_594164, JBool, required = false, default = nil)
  if valid_594164 != nil:
    section.add "$count", valid_594164
  var valid_594165 = query.getOrDefault("$filter")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "$filter", valid_594165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594166: Call_CatalogListSchemas_594155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of schemas from the Data Lake Analytics catalog.
  ## 
  let valid = call_594166.validator(path, query, header, formData, body)
  let scheme = call_594166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594166.url(scheme.get, call_594166.host, call_594166.base,
                         call_594166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594166, url, valid)

proc call*(call_594167: Call_CatalogListSchemas_594155; apiVersion: string;
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
  var path_594168 = newJObject()
  var query_594169 = newJObject()
  add(query_594169, "$orderby", newJString(Orderby))
  add(query_594169, "api-version", newJString(apiVersion))
  add(query_594169, "$top", newJInt(Top))
  add(query_594169, "$select", newJString(Select))
  add(path_594168, "databaseName", newJString(databaseName))
  add(query_594169, "$skip", newJInt(Skip))
  add(query_594169, "$count", newJBool(Count))
  add(query_594169, "$filter", newJString(Filter))
  result = call_594167.call(path_594168, query_594169, nil, nil, nil)

var catalogListSchemas* = Call_CatalogListSchemas_594155(
    name: "catalogListSchemas", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas",
    validator: validate_CatalogListSchemas_594156, base: "",
    url: url_CatalogListSchemas_594157, schemes: {Scheme.Https})
type
  Call_CatalogGetSchema_594170 = ref object of OpenApiRestCall_593437
proc url_CatalogGetSchema_594172(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetSchema_594171(path: JsonNode; query: JsonNode;
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
  var valid_594173 = path.getOrDefault("schemaName")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "schemaName", valid_594173
  var valid_594174 = path.getOrDefault("databaseName")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "databaseName", valid_594174
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594175 = query.getOrDefault("api-version")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "api-version", valid_594175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594176: Call_CatalogGetSchema_594170; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified schema from the Data Lake Analytics catalog.
  ## 
  let valid = call_594176.validator(path, query, header, formData, body)
  let scheme = call_594176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594176.url(scheme.get, call_594176.host, call_594176.base,
                         call_594176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594176, url, valid)

proc call*(call_594177: Call_CatalogGetSchema_594170; apiVersion: string;
          schemaName: string; databaseName: string): Recallable =
  ## catalogGetSchema
  ## Retrieves the specified schema from the Data Lake Analytics catalog.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   schemaName: string (required)
  ##             : The name of the schema.
  ##   databaseName: string (required)
  ##               : The name of the database containing the schema.
  var path_594178 = newJObject()
  var query_594179 = newJObject()
  add(query_594179, "api-version", newJString(apiVersion))
  add(path_594178, "schemaName", newJString(schemaName))
  add(path_594178, "databaseName", newJString(databaseName))
  result = call_594177.call(path_594178, query_594179, nil, nil, nil)

var catalogGetSchema* = Call_CatalogGetSchema_594170(name: "catalogGetSchema",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}",
    validator: validate_CatalogGetSchema_594171, base: "",
    url: url_CatalogGetSchema_594172, schemes: {Scheme.Https})
type
  Call_CatalogListPackages_594180 = ref object of OpenApiRestCall_593437
proc url_CatalogListPackages_594182(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListPackages_594181(path: JsonNode; query: JsonNode;
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
  var valid_594183 = path.getOrDefault("schemaName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "schemaName", valid_594183
  var valid_594184 = path.getOrDefault("databaseName")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "databaseName", valid_594184
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
  var valid_594185 = query.getOrDefault("$orderby")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "$orderby", valid_594185
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594186 = query.getOrDefault("api-version")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "api-version", valid_594186
  var valid_594187 = query.getOrDefault("$top")
  valid_594187 = validateParameter(valid_594187, JInt, required = false, default = nil)
  if valid_594187 != nil:
    section.add "$top", valid_594187
  var valid_594188 = query.getOrDefault("$select")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "$select", valid_594188
  var valid_594189 = query.getOrDefault("$skip")
  valid_594189 = validateParameter(valid_594189, JInt, required = false, default = nil)
  if valid_594189 != nil:
    section.add "$skip", valid_594189
  var valid_594190 = query.getOrDefault("$count")
  valid_594190 = validateParameter(valid_594190, JBool, required = false, default = nil)
  if valid_594190 != nil:
    section.add "$count", valid_594190
  var valid_594191 = query.getOrDefault("$filter")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "$filter", valid_594191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594192: Call_CatalogListPackages_594180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of packages from the Data Lake Analytics catalog.
  ## 
  let valid = call_594192.validator(path, query, header, formData, body)
  let scheme = call_594192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594192.url(scheme.get, call_594192.host, call_594192.base,
                         call_594192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594192, url, valid)

proc call*(call_594193: Call_CatalogListPackages_594180; apiVersion: string;
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
  var path_594194 = newJObject()
  var query_594195 = newJObject()
  add(query_594195, "$orderby", newJString(Orderby))
  add(query_594195, "api-version", newJString(apiVersion))
  add(query_594195, "$top", newJInt(Top))
  add(path_594194, "schemaName", newJString(schemaName))
  add(query_594195, "$select", newJString(Select))
  add(path_594194, "databaseName", newJString(databaseName))
  add(query_594195, "$skip", newJInt(Skip))
  add(query_594195, "$count", newJBool(Count))
  add(query_594195, "$filter", newJString(Filter))
  result = call_594193.call(path_594194, query_594195, nil, nil, nil)

var catalogListPackages* = Call_CatalogListPackages_594180(
    name: "catalogListPackages", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/packages",
    validator: validate_CatalogListPackages_594181, base: "",
    url: url_CatalogListPackages_594182, schemes: {Scheme.Https})
type
  Call_CatalogGetPackage_594196 = ref object of OpenApiRestCall_593437
proc url_CatalogGetPackage_594198(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetPackage_594197(path: JsonNode; query: JsonNode;
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
  var valid_594199 = path.getOrDefault("packageName")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "packageName", valid_594199
  var valid_594200 = path.getOrDefault("schemaName")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "schemaName", valid_594200
  var valid_594201 = path.getOrDefault("databaseName")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "databaseName", valid_594201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594202 = query.getOrDefault("api-version")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "api-version", valid_594202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594203: Call_CatalogGetPackage_594196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified package from the Data Lake Analytics catalog.
  ## 
  let valid = call_594203.validator(path, query, header, formData, body)
  let scheme = call_594203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594203.url(scheme.get, call_594203.host, call_594203.base,
                         call_594203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594203, url, valid)

proc call*(call_594204: Call_CatalogGetPackage_594196; packageName: string;
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
  var path_594205 = newJObject()
  var query_594206 = newJObject()
  add(path_594205, "packageName", newJString(packageName))
  add(query_594206, "api-version", newJString(apiVersion))
  add(path_594205, "schemaName", newJString(schemaName))
  add(path_594205, "databaseName", newJString(databaseName))
  result = call_594204.call(path_594205, query_594206, nil, nil, nil)

var catalogGetPackage* = Call_CatalogGetPackage_594196(name: "catalogGetPackage",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/packages/{packageName}",
    validator: validate_CatalogGetPackage_594197, base: "",
    url: url_CatalogGetPackage_594198, schemes: {Scheme.Https})
type
  Call_CatalogListProcedures_594207 = ref object of OpenApiRestCall_593437
proc url_CatalogListProcedures_594209(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListProcedures_594208(path: JsonNode; query: JsonNode;
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
  var valid_594210 = path.getOrDefault("schemaName")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "schemaName", valid_594210
  var valid_594211 = path.getOrDefault("databaseName")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "databaseName", valid_594211
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
  var valid_594212 = query.getOrDefault("$orderby")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "$orderby", valid_594212
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594213 = query.getOrDefault("api-version")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "api-version", valid_594213
  var valid_594214 = query.getOrDefault("$top")
  valid_594214 = validateParameter(valid_594214, JInt, required = false, default = nil)
  if valid_594214 != nil:
    section.add "$top", valid_594214
  var valid_594215 = query.getOrDefault("$select")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "$select", valid_594215
  var valid_594216 = query.getOrDefault("$skip")
  valid_594216 = validateParameter(valid_594216, JInt, required = false, default = nil)
  if valid_594216 != nil:
    section.add "$skip", valid_594216
  var valid_594217 = query.getOrDefault("$count")
  valid_594217 = validateParameter(valid_594217, JBool, required = false, default = nil)
  if valid_594217 != nil:
    section.add "$count", valid_594217
  var valid_594218 = query.getOrDefault("$filter")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "$filter", valid_594218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594219: Call_CatalogListProcedures_594207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of procedures from the Data Lake Analytics catalog.
  ## 
  let valid = call_594219.validator(path, query, header, formData, body)
  let scheme = call_594219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594219.url(scheme.get, call_594219.host, call_594219.base,
                         call_594219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594219, url, valid)

proc call*(call_594220: Call_CatalogListProcedures_594207; apiVersion: string;
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
  var path_594221 = newJObject()
  var query_594222 = newJObject()
  add(query_594222, "$orderby", newJString(Orderby))
  add(query_594222, "api-version", newJString(apiVersion))
  add(query_594222, "$top", newJInt(Top))
  add(path_594221, "schemaName", newJString(schemaName))
  add(query_594222, "$select", newJString(Select))
  add(path_594221, "databaseName", newJString(databaseName))
  add(query_594222, "$skip", newJInt(Skip))
  add(query_594222, "$count", newJBool(Count))
  add(query_594222, "$filter", newJString(Filter))
  result = call_594220.call(path_594221, query_594222, nil, nil, nil)

var catalogListProcedures* = Call_CatalogListProcedures_594207(
    name: "catalogListProcedures", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/procedures",
    validator: validate_CatalogListProcedures_594208, base: "",
    url: url_CatalogListProcedures_594209, schemes: {Scheme.Https})
type
  Call_CatalogGetProcedure_594223 = ref object of OpenApiRestCall_593437
proc url_CatalogGetProcedure_594225(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetProcedure_594224(path: JsonNode; query: JsonNode;
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
  var valid_594226 = path.getOrDefault("procedureName")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "procedureName", valid_594226
  var valid_594227 = path.getOrDefault("schemaName")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "schemaName", valid_594227
  var valid_594228 = path.getOrDefault("databaseName")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "databaseName", valid_594228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594229 = query.getOrDefault("api-version")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "api-version", valid_594229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594230: Call_CatalogGetProcedure_594223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified procedure from the Data Lake Analytics catalog.
  ## 
  let valid = call_594230.validator(path, query, header, formData, body)
  let scheme = call_594230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594230.url(scheme.get, call_594230.host, call_594230.base,
                         call_594230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594230, url, valid)

proc call*(call_594231: Call_CatalogGetProcedure_594223; apiVersion: string;
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
  var path_594232 = newJObject()
  var query_594233 = newJObject()
  add(query_594233, "api-version", newJString(apiVersion))
  add(path_594232, "procedureName", newJString(procedureName))
  add(path_594232, "schemaName", newJString(schemaName))
  add(path_594232, "databaseName", newJString(databaseName))
  result = call_594231.call(path_594232, query_594233, nil, nil, nil)

var catalogGetProcedure* = Call_CatalogGetProcedure_594223(
    name: "catalogGetProcedure", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/procedures/{procedureName}",
    validator: validate_CatalogGetProcedure_594224, base: "",
    url: url_CatalogGetProcedure_594225, schemes: {Scheme.Https})
type
  Call_CatalogListTableStatisticsByDatabaseAndSchema_594234 = ref object of OpenApiRestCall_593437
proc url_CatalogListTableStatisticsByDatabaseAndSchema_594236(protocol: Scheme;
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

proc validate_CatalogListTableStatisticsByDatabaseAndSchema_594235(
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
  var valid_594237 = path.getOrDefault("schemaName")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "schemaName", valid_594237
  var valid_594238 = path.getOrDefault("databaseName")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "databaseName", valid_594238
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
  var valid_594239 = query.getOrDefault("$orderby")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = nil)
  if valid_594239 != nil:
    section.add "$orderby", valid_594239
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

proc call*(call_594246: Call_CatalogListTableStatisticsByDatabaseAndSchema_594234;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of all table statistics within the specified schema from the Data Lake Analytics catalog.
  ## 
  let valid = call_594246.validator(path, query, header, formData, body)
  let scheme = call_594246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594246.url(scheme.get, call_594246.host, call_594246.base,
                         call_594246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594246, url, valid)

proc call*(call_594247: Call_CatalogListTableStatisticsByDatabaseAndSchema_594234;
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
  var path_594248 = newJObject()
  var query_594249 = newJObject()
  add(query_594249, "$orderby", newJString(Orderby))
  add(query_594249, "api-version", newJString(apiVersion))
  add(query_594249, "$top", newJInt(Top))
  add(path_594248, "schemaName", newJString(schemaName))
  add(query_594249, "$select", newJString(Select))
  add(path_594248, "databaseName", newJString(databaseName))
  add(query_594249, "$skip", newJInt(Skip))
  add(query_594249, "$count", newJBool(Count))
  add(query_594249, "$filter", newJString(Filter))
  result = call_594247.call(path_594248, query_594249, nil, nil, nil)

var catalogListTableStatisticsByDatabaseAndSchema* = Call_CatalogListTableStatisticsByDatabaseAndSchema_594234(
    name: "catalogListTableStatisticsByDatabaseAndSchema",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/statistics",
    validator: validate_CatalogListTableStatisticsByDatabaseAndSchema_594235,
    base: "", url: url_CatalogListTableStatisticsByDatabaseAndSchema_594236,
    schemes: {Scheme.Https})
type
  Call_CatalogListTables_594250 = ref object of OpenApiRestCall_593437
proc url_CatalogListTables_594252(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListTables_594251(path: JsonNode; query: JsonNode;
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
  var valid_594255 = query.getOrDefault("$orderby")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = nil)
  if valid_594255 != nil:
    section.add "$orderby", valid_594255
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594256 = query.getOrDefault("api-version")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "api-version", valid_594256
  var valid_594257 = query.getOrDefault("$top")
  valid_594257 = validateParameter(valid_594257, JInt, required = false, default = nil)
  if valid_594257 != nil:
    section.add "$top", valid_594257
  var valid_594258 = query.getOrDefault("$select")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = nil)
  if valid_594258 != nil:
    section.add "$select", valid_594258
  var valid_594259 = query.getOrDefault("$skip")
  valid_594259 = validateParameter(valid_594259, JInt, required = false, default = nil)
  if valid_594259 != nil:
    section.add "$skip", valid_594259
  var valid_594260 = query.getOrDefault("$count")
  valid_594260 = validateParameter(valid_594260, JBool, required = false, default = nil)
  if valid_594260 != nil:
    section.add "$count", valid_594260
  var valid_594261 = query.getOrDefault("basic")
  valid_594261 = validateParameter(valid_594261, JBool, required = false,
                                 default = newJBool(false))
  if valid_594261 != nil:
    section.add "basic", valid_594261
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

proc call*(call_594263: Call_CatalogListTables_594250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of tables from the Data Lake Analytics catalog.
  ## 
  let valid = call_594263.validator(path, query, header, formData, body)
  let scheme = call_594263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594263.url(scheme.get, call_594263.host, call_594263.base,
                         call_594263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594263, url, valid)

proc call*(call_594264: Call_CatalogListTables_594250; apiVersion: string;
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
  var path_594265 = newJObject()
  var query_594266 = newJObject()
  add(query_594266, "$orderby", newJString(Orderby))
  add(query_594266, "api-version", newJString(apiVersion))
  add(query_594266, "$top", newJInt(Top))
  add(path_594265, "schemaName", newJString(schemaName))
  add(query_594266, "$select", newJString(Select))
  add(path_594265, "databaseName", newJString(databaseName))
  add(query_594266, "$skip", newJInt(Skip))
  add(query_594266, "$count", newJBool(Count))
  add(query_594266, "basic", newJBool(basic))
  add(query_594266, "$filter", newJString(Filter))
  result = call_594264.call(path_594265, query_594266, nil, nil, nil)

var catalogListTables* = Call_CatalogListTables_594250(name: "catalogListTables",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables",
    validator: validate_CatalogListTables_594251, base: "",
    url: url_CatalogListTables_594252, schemes: {Scheme.Https})
type
  Call_CatalogGetTable_594267 = ref object of OpenApiRestCall_593437
proc url_CatalogGetTable_594269(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetTable_594268(path: JsonNode; query: JsonNode;
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
  var valid_594270 = path.getOrDefault("schemaName")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "schemaName", valid_594270
  var valid_594271 = path.getOrDefault("tableName")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "tableName", valid_594271
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

proc call*(call_594274: Call_CatalogGetTable_594267; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table from the Data Lake Analytics catalog.
  ## 
  let valid = call_594274.validator(path, query, header, formData, body)
  let scheme = call_594274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594274.url(scheme.get, call_594274.host, call_594274.base,
                         call_594274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594274, url, valid)

proc call*(call_594275: Call_CatalogGetTable_594267; apiVersion: string;
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
  var path_594276 = newJObject()
  var query_594277 = newJObject()
  add(query_594277, "api-version", newJString(apiVersion))
  add(path_594276, "schemaName", newJString(schemaName))
  add(path_594276, "tableName", newJString(tableName))
  add(path_594276, "databaseName", newJString(databaseName))
  result = call_594275.call(path_594276, query_594277, nil, nil, nil)

var catalogGetTable* = Call_CatalogGetTable_594267(name: "catalogGetTable",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}",
    validator: validate_CatalogGetTable_594268, base: "", url: url_CatalogGetTable_594269,
    schemes: {Scheme.Https})
type
  Call_CatalogListTablePartitions_594278 = ref object of OpenApiRestCall_593437
proc url_CatalogListTablePartitions_594280(protocol: Scheme; host: string;
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

proc validate_CatalogListTablePartitions_594279(path: JsonNode; query: JsonNode;
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
  var valid_594281 = path.getOrDefault("schemaName")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "schemaName", valid_594281
  var valid_594282 = path.getOrDefault("tableName")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "tableName", valid_594282
  var valid_594283 = path.getOrDefault("databaseName")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "databaseName", valid_594283
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
  var valid_594284 = query.getOrDefault("$orderby")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = nil)
  if valid_594284 != nil:
    section.add "$orderby", valid_594284
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594285 = query.getOrDefault("api-version")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "api-version", valid_594285
  var valid_594286 = query.getOrDefault("$top")
  valid_594286 = validateParameter(valid_594286, JInt, required = false, default = nil)
  if valid_594286 != nil:
    section.add "$top", valid_594286
  var valid_594287 = query.getOrDefault("$select")
  valid_594287 = validateParameter(valid_594287, JString, required = false,
                                 default = nil)
  if valid_594287 != nil:
    section.add "$select", valid_594287
  var valid_594288 = query.getOrDefault("$skip")
  valid_594288 = validateParameter(valid_594288, JInt, required = false, default = nil)
  if valid_594288 != nil:
    section.add "$skip", valid_594288
  var valid_594289 = query.getOrDefault("$count")
  valid_594289 = validateParameter(valid_594289, JBool, required = false, default = nil)
  if valid_594289 != nil:
    section.add "$count", valid_594289
  var valid_594290 = query.getOrDefault("$filter")
  valid_594290 = validateParameter(valid_594290, JString, required = false,
                                 default = nil)
  if valid_594290 != nil:
    section.add "$filter", valid_594290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594291: Call_CatalogListTablePartitions_594278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table partitions from the Data Lake Analytics catalog.
  ## 
  let valid = call_594291.validator(path, query, header, formData, body)
  let scheme = call_594291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594291.url(scheme.get, call_594291.host, call_594291.base,
                         call_594291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594291, url, valid)

proc call*(call_594292: Call_CatalogListTablePartitions_594278; apiVersion: string;
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
  var path_594293 = newJObject()
  var query_594294 = newJObject()
  add(query_594294, "$orderby", newJString(Orderby))
  add(query_594294, "api-version", newJString(apiVersion))
  add(query_594294, "$top", newJInt(Top))
  add(path_594293, "schemaName", newJString(schemaName))
  add(path_594293, "tableName", newJString(tableName))
  add(query_594294, "$select", newJString(Select))
  add(path_594293, "databaseName", newJString(databaseName))
  add(query_594294, "$skip", newJInt(Skip))
  add(query_594294, "$count", newJBool(Count))
  add(query_594294, "$filter", newJString(Filter))
  result = call_594292.call(path_594293, query_594294, nil, nil, nil)

var catalogListTablePartitions* = Call_CatalogListTablePartitions_594278(
    name: "catalogListTablePartitions", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/partitions",
    validator: validate_CatalogListTablePartitions_594279, base: "",
    url: url_CatalogListTablePartitions_594280, schemes: {Scheme.Https})
type
  Call_CatalogGetTablePartition_594295 = ref object of OpenApiRestCall_593437
proc url_CatalogGetTablePartition_594297(protocol: Scheme; host: string;
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

proc validate_CatalogGetTablePartition_594296(path: JsonNode; query: JsonNode;
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
  var valid_594298 = path.getOrDefault("schemaName")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "schemaName", valid_594298
  var valid_594299 = path.getOrDefault("tableName")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "tableName", valid_594299
  var valid_594300 = path.getOrDefault("databaseName")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "databaseName", valid_594300
  var valid_594301 = path.getOrDefault("partitionName")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "partitionName", valid_594301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594302 = query.getOrDefault("api-version")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "api-version", valid_594302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594303: Call_CatalogGetTablePartition_594295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table partition from the Data Lake Analytics catalog.
  ## 
  let valid = call_594303.validator(path, query, header, formData, body)
  let scheme = call_594303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594303.url(scheme.get, call_594303.host, call_594303.base,
                         call_594303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594303, url, valid)

proc call*(call_594304: Call_CatalogGetTablePartition_594295; apiVersion: string;
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
  var path_594305 = newJObject()
  var query_594306 = newJObject()
  add(query_594306, "api-version", newJString(apiVersion))
  add(path_594305, "schemaName", newJString(schemaName))
  add(path_594305, "tableName", newJString(tableName))
  add(path_594305, "databaseName", newJString(databaseName))
  add(path_594305, "partitionName", newJString(partitionName))
  result = call_594304.call(path_594305, query_594306, nil, nil, nil)

var catalogGetTablePartition* = Call_CatalogGetTablePartition_594295(
    name: "catalogGetTablePartition", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/partitions/{partitionName}",
    validator: validate_CatalogGetTablePartition_594296, base: "",
    url: url_CatalogGetTablePartition_594297, schemes: {Scheme.Https})
type
  Call_CatalogPreviewTablePartition_594307 = ref object of OpenApiRestCall_593437
proc url_CatalogPreviewTablePartition_594309(protocol: Scheme; host: string;
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

proc validate_CatalogPreviewTablePartition_594308(path: JsonNode; query: JsonNode;
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
  var valid_594310 = path.getOrDefault("schemaName")
  valid_594310 = validateParameter(valid_594310, JString, required = true,
                                 default = nil)
  if valid_594310 != nil:
    section.add "schemaName", valid_594310
  var valid_594311 = path.getOrDefault("tableName")
  valid_594311 = validateParameter(valid_594311, JString, required = true,
                                 default = nil)
  if valid_594311 != nil:
    section.add "tableName", valid_594311
  var valid_594312 = path.getOrDefault("databaseName")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "databaseName", valid_594312
  var valid_594313 = path.getOrDefault("partitionName")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "partitionName", valid_594313
  result.add "path", section
  ## parameters in `query` object:
  ##   maxRows: JInt
  ##          : The maximum number of preview rows to be retrieved.Rows returned may be less than or equal to this number depending on row sizes and number of rows in the partition.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   maxColumns: JInt
  ##             : The maximum number of columns to be retrieved.
  section = newJObject()
  var valid_594314 = query.getOrDefault("maxRows")
  valid_594314 = validateParameter(valid_594314, JInt, required = false, default = nil)
  if valid_594314 != nil:
    section.add "maxRows", valid_594314
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594315 = query.getOrDefault("api-version")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "api-version", valid_594315
  var valid_594316 = query.getOrDefault("maxColumns")
  valid_594316 = validateParameter(valid_594316, JInt, required = false, default = nil)
  if valid_594316 != nil:
    section.add "maxColumns", valid_594316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594317: Call_CatalogPreviewTablePartition_594307; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a preview set of rows in given partition.
  ## 
  let valid = call_594317.validator(path, query, header, formData, body)
  let scheme = call_594317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594317.url(scheme.get, call_594317.host, call_594317.base,
                         call_594317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594317, url, valid)

proc call*(call_594318: Call_CatalogPreviewTablePartition_594307;
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
  var path_594319 = newJObject()
  var query_594320 = newJObject()
  add(query_594320, "maxRows", newJInt(maxRows))
  add(query_594320, "api-version", newJString(apiVersion))
  add(path_594319, "schemaName", newJString(schemaName))
  add(path_594319, "tableName", newJString(tableName))
  add(path_594319, "databaseName", newJString(databaseName))
  add(query_594320, "maxColumns", newJInt(maxColumns))
  add(path_594319, "partitionName", newJString(partitionName))
  result = call_594318.call(path_594319, query_594320, nil, nil, nil)

var catalogPreviewTablePartition* = Call_CatalogPreviewTablePartition_594307(
    name: "catalogPreviewTablePartition", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/partitions/{partitionName}/previewrows",
    validator: validate_CatalogPreviewTablePartition_594308, base: "",
    url: url_CatalogPreviewTablePartition_594309, schemes: {Scheme.Https})
type
  Call_CatalogPreviewTable_594321 = ref object of OpenApiRestCall_593437
proc url_CatalogPreviewTable_594323(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogPreviewTable_594322(path: JsonNode; query: JsonNode;
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
  var valid_594324 = path.getOrDefault("schemaName")
  valid_594324 = validateParameter(valid_594324, JString, required = true,
                                 default = nil)
  if valid_594324 != nil:
    section.add "schemaName", valid_594324
  var valid_594325 = path.getOrDefault("tableName")
  valid_594325 = validateParameter(valid_594325, JString, required = true,
                                 default = nil)
  if valid_594325 != nil:
    section.add "tableName", valid_594325
  var valid_594326 = path.getOrDefault("databaseName")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "databaseName", valid_594326
  result.add "path", section
  ## parameters in `query` object:
  ##   maxRows: JInt
  ##          : The maximum number of preview rows to be retrieved. Rows returned may be less than or equal to this number depending on row sizes and number of rows in the table.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   maxColumns: JInt
  ##             : The maximum number of columns to be retrieved.
  section = newJObject()
  var valid_594327 = query.getOrDefault("maxRows")
  valid_594327 = validateParameter(valid_594327, JInt, required = false, default = nil)
  if valid_594327 != nil:
    section.add "maxRows", valid_594327
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594328 = query.getOrDefault("api-version")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "api-version", valid_594328
  var valid_594329 = query.getOrDefault("maxColumns")
  valid_594329 = validateParameter(valid_594329, JInt, required = false, default = nil)
  if valid_594329 != nil:
    section.add "maxColumns", valid_594329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594330: Call_CatalogPreviewTable_594321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a preview set of rows in given table.
  ## 
  let valid = call_594330.validator(path, query, header, formData, body)
  let scheme = call_594330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594330.url(scheme.get, call_594330.host, call_594330.base,
                         call_594330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594330, url, valid)

proc call*(call_594331: Call_CatalogPreviewTable_594321; apiVersion: string;
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
  var path_594332 = newJObject()
  var query_594333 = newJObject()
  add(query_594333, "maxRows", newJInt(maxRows))
  add(query_594333, "api-version", newJString(apiVersion))
  add(path_594332, "schemaName", newJString(schemaName))
  add(path_594332, "tableName", newJString(tableName))
  add(path_594332, "databaseName", newJString(databaseName))
  add(query_594333, "maxColumns", newJInt(maxColumns))
  result = call_594331.call(path_594332, query_594333, nil, nil, nil)

var catalogPreviewTable* = Call_CatalogPreviewTable_594321(
    name: "catalogPreviewTable", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/previewrows",
    validator: validate_CatalogPreviewTable_594322, base: "",
    url: url_CatalogPreviewTable_594323, schemes: {Scheme.Https})
type
  Call_CatalogListTableStatistics_594334 = ref object of OpenApiRestCall_593437
proc url_CatalogListTableStatistics_594336(protocol: Scheme; host: string;
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

proc validate_CatalogListTableStatistics_594335(path: JsonNode; query: JsonNode;
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
  var valid_594337 = path.getOrDefault("schemaName")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "schemaName", valid_594337
  var valid_594338 = path.getOrDefault("tableName")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "tableName", valid_594338
  var valid_594339 = path.getOrDefault("databaseName")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "databaseName", valid_594339
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
  var valid_594340 = query.getOrDefault("$orderby")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = nil)
  if valid_594340 != nil:
    section.add "$orderby", valid_594340
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594341 = query.getOrDefault("api-version")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "api-version", valid_594341
  var valid_594342 = query.getOrDefault("$top")
  valid_594342 = validateParameter(valid_594342, JInt, required = false, default = nil)
  if valid_594342 != nil:
    section.add "$top", valid_594342
  var valid_594343 = query.getOrDefault("$select")
  valid_594343 = validateParameter(valid_594343, JString, required = false,
                                 default = nil)
  if valid_594343 != nil:
    section.add "$select", valid_594343
  var valid_594344 = query.getOrDefault("$skip")
  valid_594344 = validateParameter(valid_594344, JInt, required = false, default = nil)
  if valid_594344 != nil:
    section.add "$skip", valid_594344
  var valid_594345 = query.getOrDefault("$count")
  valid_594345 = validateParameter(valid_594345, JBool, required = false, default = nil)
  if valid_594345 != nil:
    section.add "$count", valid_594345
  var valid_594346 = query.getOrDefault("$filter")
  valid_594346 = validateParameter(valid_594346, JString, required = false,
                                 default = nil)
  if valid_594346 != nil:
    section.add "$filter", valid_594346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594347: Call_CatalogListTableStatistics_594334; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table statistics from the Data Lake Analytics catalog.
  ## 
  let valid = call_594347.validator(path, query, header, formData, body)
  let scheme = call_594347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594347.url(scheme.get, call_594347.host, call_594347.base,
                         call_594347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594347, url, valid)

proc call*(call_594348: Call_CatalogListTableStatistics_594334; apiVersion: string;
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
  var path_594349 = newJObject()
  var query_594350 = newJObject()
  add(query_594350, "$orderby", newJString(Orderby))
  add(query_594350, "api-version", newJString(apiVersion))
  add(query_594350, "$top", newJInt(Top))
  add(path_594349, "schemaName", newJString(schemaName))
  add(path_594349, "tableName", newJString(tableName))
  add(query_594350, "$select", newJString(Select))
  add(path_594349, "databaseName", newJString(databaseName))
  add(query_594350, "$skip", newJInt(Skip))
  add(query_594350, "$count", newJBool(Count))
  add(query_594350, "$filter", newJString(Filter))
  result = call_594348.call(path_594349, query_594350, nil, nil, nil)

var catalogListTableStatistics* = Call_CatalogListTableStatistics_594334(
    name: "catalogListTableStatistics", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/statistics",
    validator: validate_CatalogListTableStatistics_594335, base: "",
    url: url_CatalogListTableStatistics_594336, schemes: {Scheme.Https})
type
  Call_CatalogGetTableStatistic_594351 = ref object of OpenApiRestCall_593437
proc url_CatalogGetTableStatistic_594353(protocol: Scheme; host: string;
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

proc validate_CatalogGetTableStatistic_594352(path: JsonNode; query: JsonNode;
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
  var valid_594354 = path.getOrDefault("statisticsName")
  valid_594354 = validateParameter(valid_594354, JString, required = true,
                                 default = nil)
  if valid_594354 != nil:
    section.add "statisticsName", valid_594354
  var valid_594355 = path.getOrDefault("schemaName")
  valid_594355 = validateParameter(valid_594355, JString, required = true,
                                 default = nil)
  if valid_594355 != nil:
    section.add "schemaName", valid_594355
  var valid_594356 = path.getOrDefault("tableName")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "tableName", valid_594356
  var valid_594357 = path.getOrDefault("databaseName")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "databaseName", valid_594357
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594358 = query.getOrDefault("api-version")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "api-version", valid_594358
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594359: Call_CatalogGetTableStatistic_594351; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table statistics from the Data Lake Analytics catalog.
  ## 
  let valid = call_594359.validator(path, query, header, formData, body)
  let scheme = call_594359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594359.url(scheme.get, call_594359.host, call_594359.base,
                         call_594359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594359, url, valid)

proc call*(call_594360: Call_CatalogGetTableStatistic_594351;
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
  var path_594361 = newJObject()
  var query_594362 = newJObject()
  add(path_594361, "statisticsName", newJString(statisticsName))
  add(query_594362, "api-version", newJString(apiVersion))
  add(path_594361, "schemaName", newJString(schemaName))
  add(path_594361, "tableName", newJString(tableName))
  add(path_594361, "databaseName", newJString(databaseName))
  result = call_594360.call(path_594361, query_594362, nil, nil, nil)

var catalogGetTableStatistic* = Call_CatalogGetTableStatistic_594351(
    name: "catalogGetTableStatistic", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/statistics/{statisticsName}",
    validator: validate_CatalogGetTableStatistic_594352, base: "",
    url: url_CatalogGetTableStatistic_594353, schemes: {Scheme.Https})
type
  Call_CatalogListTableFragments_594363 = ref object of OpenApiRestCall_593437
proc url_CatalogListTableFragments_594365(protocol: Scheme; host: string;
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

proc validate_CatalogListTableFragments_594364(path: JsonNode; query: JsonNode;
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
  var valid_594366 = path.getOrDefault("schemaName")
  valid_594366 = validateParameter(valid_594366, JString, required = true,
                                 default = nil)
  if valid_594366 != nil:
    section.add "schemaName", valid_594366
  var valid_594367 = path.getOrDefault("tableName")
  valid_594367 = validateParameter(valid_594367, JString, required = true,
                                 default = nil)
  if valid_594367 != nil:
    section.add "tableName", valid_594367
  var valid_594368 = path.getOrDefault("databaseName")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "databaseName", valid_594368
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
  var valid_594369 = query.getOrDefault("$orderby")
  valid_594369 = validateParameter(valid_594369, JString, required = false,
                                 default = nil)
  if valid_594369 != nil:
    section.add "$orderby", valid_594369
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594370 = query.getOrDefault("api-version")
  valid_594370 = validateParameter(valid_594370, JString, required = true,
                                 default = nil)
  if valid_594370 != nil:
    section.add "api-version", valid_594370
  var valid_594371 = query.getOrDefault("$top")
  valid_594371 = validateParameter(valid_594371, JInt, required = false, default = nil)
  if valid_594371 != nil:
    section.add "$top", valid_594371
  var valid_594372 = query.getOrDefault("$select")
  valid_594372 = validateParameter(valid_594372, JString, required = false,
                                 default = nil)
  if valid_594372 != nil:
    section.add "$select", valid_594372
  var valid_594373 = query.getOrDefault("$skip")
  valid_594373 = validateParameter(valid_594373, JInt, required = false, default = nil)
  if valid_594373 != nil:
    section.add "$skip", valid_594373
  var valid_594374 = query.getOrDefault("$count")
  valid_594374 = validateParameter(valid_594374, JBool, required = false, default = nil)
  if valid_594374 != nil:
    section.add "$count", valid_594374
  var valid_594375 = query.getOrDefault("$filter")
  valid_594375 = validateParameter(valid_594375, JString, required = false,
                                 default = nil)
  if valid_594375 != nil:
    section.add "$filter", valid_594375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594376: Call_CatalogListTableFragments_594363; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table fragments from the Data Lake Analytics catalog.
  ## 
  let valid = call_594376.validator(path, query, header, formData, body)
  let scheme = call_594376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594376.url(scheme.get, call_594376.host, call_594376.base,
                         call_594376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594376, url, valid)

proc call*(call_594377: Call_CatalogListTableFragments_594363; apiVersion: string;
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
  var path_594378 = newJObject()
  var query_594379 = newJObject()
  add(query_594379, "$orderby", newJString(Orderby))
  add(query_594379, "api-version", newJString(apiVersion))
  add(query_594379, "$top", newJInt(Top))
  add(path_594378, "schemaName", newJString(schemaName))
  add(path_594378, "tableName", newJString(tableName))
  add(query_594379, "$select", newJString(Select))
  add(path_594378, "databaseName", newJString(databaseName))
  add(query_594379, "$skip", newJInt(Skip))
  add(query_594379, "$count", newJBool(Count))
  add(query_594379, "$filter", newJString(Filter))
  result = call_594377.call(path_594378, query_594379, nil, nil, nil)

var catalogListTableFragments* = Call_CatalogListTableFragments_594363(
    name: "catalogListTableFragments", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/tablefragments",
    validator: validate_CatalogListTableFragments_594364, base: "",
    url: url_CatalogListTableFragments_594365, schemes: {Scheme.Https})
type
  Call_CatalogListTableTypes_594380 = ref object of OpenApiRestCall_593437
proc url_CatalogListTableTypes_594382(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListTableTypes_594381(path: JsonNode; query: JsonNode;
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
  var valid_594383 = path.getOrDefault("schemaName")
  valid_594383 = validateParameter(valid_594383, JString, required = true,
                                 default = nil)
  if valid_594383 != nil:
    section.add "schemaName", valid_594383
  var valid_594384 = path.getOrDefault("databaseName")
  valid_594384 = validateParameter(valid_594384, JString, required = true,
                                 default = nil)
  if valid_594384 != nil:
    section.add "databaseName", valid_594384
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
  var valid_594385 = query.getOrDefault("$orderby")
  valid_594385 = validateParameter(valid_594385, JString, required = false,
                                 default = nil)
  if valid_594385 != nil:
    section.add "$orderby", valid_594385
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594386 = query.getOrDefault("api-version")
  valid_594386 = validateParameter(valid_594386, JString, required = true,
                                 default = nil)
  if valid_594386 != nil:
    section.add "api-version", valid_594386
  var valid_594387 = query.getOrDefault("$top")
  valid_594387 = validateParameter(valid_594387, JInt, required = false, default = nil)
  if valid_594387 != nil:
    section.add "$top", valid_594387
  var valid_594388 = query.getOrDefault("$select")
  valid_594388 = validateParameter(valid_594388, JString, required = false,
                                 default = nil)
  if valid_594388 != nil:
    section.add "$select", valid_594388
  var valid_594389 = query.getOrDefault("$skip")
  valid_594389 = validateParameter(valid_594389, JInt, required = false, default = nil)
  if valid_594389 != nil:
    section.add "$skip", valid_594389
  var valid_594390 = query.getOrDefault("$count")
  valid_594390 = validateParameter(valid_594390, JBool, required = false, default = nil)
  if valid_594390 != nil:
    section.add "$count", valid_594390
  var valid_594391 = query.getOrDefault("$filter")
  valid_594391 = validateParameter(valid_594391, JString, required = false,
                                 default = nil)
  if valid_594391 != nil:
    section.add "$filter", valid_594391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594392: Call_CatalogListTableTypes_594380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of table types from the Data Lake Analytics catalog.
  ## 
  let valid = call_594392.validator(path, query, header, formData, body)
  let scheme = call_594392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594392.url(scheme.get, call_594392.host, call_594392.base,
                         call_594392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594392, url, valid)

proc call*(call_594393: Call_CatalogListTableTypes_594380; apiVersion: string;
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
  var path_594394 = newJObject()
  var query_594395 = newJObject()
  add(query_594395, "$orderby", newJString(Orderby))
  add(query_594395, "api-version", newJString(apiVersion))
  add(query_594395, "$top", newJInt(Top))
  add(path_594394, "schemaName", newJString(schemaName))
  add(query_594395, "$select", newJString(Select))
  add(path_594394, "databaseName", newJString(databaseName))
  add(query_594395, "$skip", newJInt(Skip))
  add(query_594395, "$count", newJBool(Count))
  add(query_594395, "$filter", newJString(Filter))
  result = call_594393.call(path_594394, query_594395, nil, nil, nil)

var catalogListTableTypes* = Call_CatalogListTableTypes_594380(
    name: "catalogListTableTypes", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tabletypes",
    validator: validate_CatalogListTableTypes_594381, base: "",
    url: url_CatalogListTableTypes_594382, schemes: {Scheme.Https})
type
  Call_CatalogGetTableType_594396 = ref object of OpenApiRestCall_593437
proc url_CatalogGetTableType_594398(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetTableType_594397(path: JsonNode; query: JsonNode;
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
  var valid_594399 = path.getOrDefault("schemaName")
  valid_594399 = validateParameter(valid_594399, JString, required = true,
                                 default = nil)
  if valid_594399 != nil:
    section.add "schemaName", valid_594399
  var valid_594400 = path.getOrDefault("databaseName")
  valid_594400 = validateParameter(valid_594400, JString, required = true,
                                 default = nil)
  if valid_594400 != nil:
    section.add "databaseName", valid_594400
  var valid_594401 = path.getOrDefault("tableTypeName")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = nil)
  if valid_594401 != nil:
    section.add "tableTypeName", valid_594401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594402 = query.getOrDefault("api-version")
  valid_594402 = validateParameter(valid_594402, JString, required = true,
                                 default = nil)
  if valid_594402 != nil:
    section.add "api-version", valid_594402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594403: Call_CatalogGetTableType_594396; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table type from the Data Lake Analytics catalog.
  ## 
  let valid = call_594403.validator(path, query, header, formData, body)
  let scheme = call_594403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594403.url(scheme.get, call_594403.host, call_594403.base,
                         call_594403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594403, url, valid)

proc call*(call_594404: Call_CatalogGetTableType_594396; apiVersion: string;
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
  var path_594405 = newJObject()
  var query_594406 = newJObject()
  add(query_594406, "api-version", newJString(apiVersion))
  add(path_594405, "schemaName", newJString(schemaName))
  add(path_594405, "databaseName", newJString(databaseName))
  add(path_594405, "tableTypeName", newJString(tableTypeName))
  result = call_594404.call(path_594405, query_594406, nil, nil, nil)

var catalogGetTableType* = Call_CatalogGetTableType_594396(
    name: "catalogGetTableType", meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tabletypes/{tableTypeName}",
    validator: validate_CatalogGetTableType_594397, base: "",
    url: url_CatalogGetTableType_594398, schemes: {Scheme.Https})
type
  Call_CatalogListTableValuedFunctions_594407 = ref object of OpenApiRestCall_593437
proc url_CatalogListTableValuedFunctions_594409(protocol: Scheme; host: string;
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

proc validate_CatalogListTableValuedFunctions_594408(path: JsonNode;
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
  var valid_594410 = path.getOrDefault("schemaName")
  valid_594410 = validateParameter(valid_594410, JString, required = true,
                                 default = nil)
  if valid_594410 != nil:
    section.add "schemaName", valid_594410
  var valid_594411 = path.getOrDefault("databaseName")
  valid_594411 = validateParameter(valid_594411, JString, required = true,
                                 default = nil)
  if valid_594411 != nil:
    section.add "databaseName", valid_594411
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
  var valid_594412 = query.getOrDefault("$orderby")
  valid_594412 = validateParameter(valid_594412, JString, required = false,
                                 default = nil)
  if valid_594412 != nil:
    section.add "$orderby", valid_594412
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594413 = query.getOrDefault("api-version")
  valid_594413 = validateParameter(valid_594413, JString, required = true,
                                 default = nil)
  if valid_594413 != nil:
    section.add "api-version", valid_594413
  var valid_594414 = query.getOrDefault("$top")
  valid_594414 = validateParameter(valid_594414, JInt, required = false, default = nil)
  if valid_594414 != nil:
    section.add "$top", valid_594414
  var valid_594415 = query.getOrDefault("$select")
  valid_594415 = validateParameter(valid_594415, JString, required = false,
                                 default = nil)
  if valid_594415 != nil:
    section.add "$select", valid_594415
  var valid_594416 = query.getOrDefault("$skip")
  valid_594416 = validateParameter(valid_594416, JInt, required = false, default = nil)
  if valid_594416 != nil:
    section.add "$skip", valid_594416
  var valid_594417 = query.getOrDefault("$count")
  valid_594417 = validateParameter(valid_594417, JBool, required = false, default = nil)
  if valid_594417 != nil:
    section.add "$count", valid_594417
  var valid_594418 = query.getOrDefault("$filter")
  valid_594418 = validateParameter(valid_594418, JString, required = false,
                                 default = nil)
  if valid_594418 != nil:
    section.add "$filter", valid_594418
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594419: Call_CatalogListTableValuedFunctions_594407;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of table valued functions from the Data Lake Analytics catalog.
  ## 
  let valid = call_594419.validator(path, query, header, formData, body)
  let scheme = call_594419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594419.url(scheme.get, call_594419.host, call_594419.base,
                         call_594419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594419, url, valid)

proc call*(call_594420: Call_CatalogListTableValuedFunctions_594407;
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
  var path_594421 = newJObject()
  var query_594422 = newJObject()
  add(query_594422, "$orderby", newJString(Orderby))
  add(query_594422, "api-version", newJString(apiVersion))
  add(query_594422, "$top", newJInt(Top))
  add(path_594421, "schemaName", newJString(schemaName))
  add(query_594422, "$select", newJString(Select))
  add(path_594421, "databaseName", newJString(databaseName))
  add(query_594422, "$skip", newJInt(Skip))
  add(query_594422, "$count", newJBool(Count))
  add(query_594422, "$filter", newJString(Filter))
  result = call_594420.call(path_594421, query_594422, nil, nil, nil)

var catalogListTableValuedFunctions* = Call_CatalogListTableValuedFunctions_594407(
    name: "catalogListTableValuedFunctions", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tablevaluedfunctions",
    validator: validate_CatalogListTableValuedFunctions_594408, base: "",
    url: url_CatalogListTableValuedFunctions_594409, schemes: {Scheme.Https})
type
  Call_CatalogGetTableValuedFunction_594423 = ref object of OpenApiRestCall_593437
proc url_CatalogGetTableValuedFunction_594425(protocol: Scheme; host: string;
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

proc validate_CatalogGetTableValuedFunction_594424(path: JsonNode; query: JsonNode;
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
  var valid_594426 = path.getOrDefault("tableValuedFunctionName")
  valid_594426 = validateParameter(valid_594426, JString, required = true,
                                 default = nil)
  if valid_594426 != nil:
    section.add "tableValuedFunctionName", valid_594426
  var valid_594427 = path.getOrDefault("schemaName")
  valid_594427 = validateParameter(valid_594427, JString, required = true,
                                 default = nil)
  if valid_594427 != nil:
    section.add "schemaName", valid_594427
  var valid_594428 = path.getOrDefault("databaseName")
  valid_594428 = validateParameter(valid_594428, JString, required = true,
                                 default = nil)
  if valid_594428 != nil:
    section.add "databaseName", valid_594428
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594429 = query.getOrDefault("api-version")
  valid_594429 = validateParameter(valid_594429, JString, required = true,
                                 default = nil)
  if valid_594429 != nil:
    section.add "api-version", valid_594429
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594430: Call_CatalogGetTableValuedFunction_594423; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified table valued function from the Data Lake Analytics catalog.
  ## 
  let valid = call_594430.validator(path, query, header, formData, body)
  let scheme = call_594430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594430.url(scheme.get, call_594430.host, call_594430.base,
                         call_594430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594430, url, valid)

proc call*(call_594431: Call_CatalogGetTableValuedFunction_594423;
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
  var path_594432 = newJObject()
  var query_594433 = newJObject()
  add(query_594433, "api-version", newJString(apiVersion))
  add(path_594432, "tableValuedFunctionName", newJString(tableValuedFunctionName))
  add(path_594432, "schemaName", newJString(schemaName))
  add(path_594432, "databaseName", newJString(databaseName))
  result = call_594431.call(path_594432, query_594433, nil, nil, nil)

var catalogGetTableValuedFunction* = Call_CatalogGetTableValuedFunction_594423(
    name: "catalogGetTableValuedFunction", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/tablevaluedfunctions/{tableValuedFunctionName}",
    validator: validate_CatalogGetTableValuedFunction_594424, base: "",
    url: url_CatalogGetTableValuedFunction_594425, schemes: {Scheme.Https})
type
  Call_CatalogListTypes_594434 = ref object of OpenApiRestCall_593437
proc url_CatalogListTypes_594436(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListTypes_594435(path: JsonNode; query: JsonNode;
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
  var valid_594437 = path.getOrDefault("schemaName")
  valid_594437 = validateParameter(valid_594437, JString, required = true,
                                 default = nil)
  if valid_594437 != nil:
    section.add "schemaName", valid_594437
  var valid_594438 = path.getOrDefault("databaseName")
  valid_594438 = validateParameter(valid_594438, JString, required = true,
                                 default = nil)
  if valid_594438 != nil:
    section.add "databaseName", valid_594438
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
  var valid_594439 = query.getOrDefault("$orderby")
  valid_594439 = validateParameter(valid_594439, JString, required = false,
                                 default = nil)
  if valid_594439 != nil:
    section.add "$orderby", valid_594439
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594440 = query.getOrDefault("api-version")
  valid_594440 = validateParameter(valid_594440, JString, required = true,
                                 default = nil)
  if valid_594440 != nil:
    section.add "api-version", valid_594440
  var valid_594441 = query.getOrDefault("$top")
  valid_594441 = validateParameter(valid_594441, JInt, required = false, default = nil)
  if valid_594441 != nil:
    section.add "$top", valid_594441
  var valid_594442 = query.getOrDefault("$select")
  valid_594442 = validateParameter(valid_594442, JString, required = false,
                                 default = nil)
  if valid_594442 != nil:
    section.add "$select", valid_594442
  var valid_594443 = query.getOrDefault("$skip")
  valid_594443 = validateParameter(valid_594443, JInt, required = false, default = nil)
  if valid_594443 != nil:
    section.add "$skip", valid_594443
  var valid_594444 = query.getOrDefault("$count")
  valid_594444 = validateParameter(valid_594444, JBool, required = false, default = nil)
  if valid_594444 != nil:
    section.add "$count", valid_594444
  var valid_594445 = query.getOrDefault("$filter")
  valid_594445 = validateParameter(valid_594445, JString, required = false,
                                 default = nil)
  if valid_594445 != nil:
    section.add "$filter", valid_594445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594446: Call_CatalogListTypes_594434; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of types within the specified database and schema from the Data Lake Analytics catalog.
  ## 
  let valid = call_594446.validator(path, query, header, formData, body)
  let scheme = call_594446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594446.url(scheme.get, call_594446.host, call_594446.base,
                         call_594446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594446, url, valid)

proc call*(call_594447: Call_CatalogListTypes_594434; apiVersion: string;
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
  var path_594448 = newJObject()
  var query_594449 = newJObject()
  add(query_594449, "$orderby", newJString(Orderby))
  add(query_594449, "api-version", newJString(apiVersion))
  add(query_594449, "$top", newJInt(Top))
  add(path_594448, "schemaName", newJString(schemaName))
  add(query_594449, "$select", newJString(Select))
  add(path_594448, "databaseName", newJString(databaseName))
  add(query_594449, "$skip", newJInt(Skip))
  add(query_594449, "$count", newJBool(Count))
  add(query_594449, "$filter", newJString(Filter))
  result = call_594447.call(path_594448, query_594449, nil, nil, nil)

var catalogListTypes* = Call_CatalogListTypes_594434(name: "catalogListTypes",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/types",
    validator: validate_CatalogListTypes_594435, base: "",
    url: url_CatalogListTypes_594436, schemes: {Scheme.Https})
type
  Call_CatalogListViews_594450 = ref object of OpenApiRestCall_593437
proc url_CatalogListViews_594452(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogListViews_594451(path: JsonNode; query: JsonNode;
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
  var valid_594453 = path.getOrDefault("schemaName")
  valid_594453 = validateParameter(valid_594453, JString, required = true,
                                 default = nil)
  if valid_594453 != nil:
    section.add "schemaName", valid_594453
  var valid_594454 = path.getOrDefault("databaseName")
  valid_594454 = validateParameter(valid_594454, JString, required = true,
                                 default = nil)
  if valid_594454 != nil:
    section.add "databaseName", valid_594454
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
  var valid_594455 = query.getOrDefault("$orderby")
  valid_594455 = validateParameter(valid_594455, JString, required = false,
                                 default = nil)
  if valid_594455 != nil:
    section.add "$orderby", valid_594455
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594456 = query.getOrDefault("api-version")
  valid_594456 = validateParameter(valid_594456, JString, required = true,
                                 default = nil)
  if valid_594456 != nil:
    section.add "api-version", valid_594456
  var valid_594457 = query.getOrDefault("$top")
  valid_594457 = validateParameter(valid_594457, JInt, required = false, default = nil)
  if valid_594457 != nil:
    section.add "$top", valid_594457
  var valid_594458 = query.getOrDefault("$select")
  valid_594458 = validateParameter(valid_594458, JString, required = false,
                                 default = nil)
  if valid_594458 != nil:
    section.add "$select", valid_594458
  var valid_594459 = query.getOrDefault("$skip")
  valid_594459 = validateParameter(valid_594459, JInt, required = false, default = nil)
  if valid_594459 != nil:
    section.add "$skip", valid_594459
  var valid_594460 = query.getOrDefault("$count")
  valid_594460 = validateParameter(valid_594460, JBool, required = false, default = nil)
  if valid_594460 != nil:
    section.add "$count", valid_594460
  var valid_594461 = query.getOrDefault("$filter")
  valid_594461 = validateParameter(valid_594461, JString, required = false,
                                 default = nil)
  if valid_594461 != nil:
    section.add "$filter", valid_594461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594462: Call_CatalogListViews_594450; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of views from the Data Lake Analytics catalog.
  ## 
  let valid = call_594462.validator(path, query, header, formData, body)
  let scheme = call_594462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594462.url(scheme.get, call_594462.host, call_594462.base,
                         call_594462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594462, url, valid)

proc call*(call_594463: Call_CatalogListViews_594450; apiVersion: string;
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
  var path_594464 = newJObject()
  var query_594465 = newJObject()
  add(query_594465, "$orderby", newJString(Orderby))
  add(query_594465, "api-version", newJString(apiVersion))
  add(query_594465, "$top", newJInt(Top))
  add(path_594464, "schemaName", newJString(schemaName))
  add(query_594465, "$select", newJString(Select))
  add(path_594464, "databaseName", newJString(databaseName))
  add(query_594465, "$skip", newJInt(Skip))
  add(query_594465, "$count", newJBool(Count))
  add(query_594465, "$filter", newJString(Filter))
  result = call_594463.call(path_594464, query_594465, nil, nil, nil)

var catalogListViews* = Call_CatalogListViews_594450(name: "catalogListViews",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/views",
    validator: validate_CatalogListViews_594451, base: "",
    url: url_CatalogListViews_594452, schemes: {Scheme.Https})
type
  Call_CatalogGetView_594466 = ref object of OpenApiRestCall_593437
proc url_CatalogGetView_594468(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetView_594467(path: JsonNode; query: JsonNode;
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
  var valid_594469 = path.getOrDefault("viewName")
  valid_594469 = validateParameter(valid_594469, JString, required = true,
                                 default = nil)
  if valid_594469 != nil:
    section.add "viewName", valid_594469
  var valid_594470 = path.getOrDefault("schemaName")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "schemaName", valid_594470
  var valid_594471 = path.getOrDefault("databaseName")
  valid_594471 = validateParameter(valid_594471, JString, required = true,
                                 default = nil)
  if valid_594471 != nil:
    section.add "databaseName", valid_594471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594472 = query.getOrDefault("api-version")
  valid_594472 = validateParameter(valid_594472, JString, required = true,
                                 default = nil)
  if valid_594472 != nil:
    section.add "api-version", valid_594472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594473: Call_CatalogGetView_594466; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified view from the Data Lake Analytics catalog.
  ## 
  let valid = call_594473.validator(path, query, header, formData, body)
  let scheme = call_594473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594473.url(scheme.get, call_594473.host, call_594473.base,
                         call_594473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594473, url, valid)

proc call*(call_594474: Call_CatalogGetView_594466; apiVersion: string;
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
  var path_594475 = newJObject()
  var query_594476 = newJObject()
  add(query_594476, "api-version", newJString(apiVersion))
  add(path_594475, "viewName", newJString(viewName))
  add(path_594475, "schemaName", newJString(schemaName))
  add(path_594475, "databaseName", newJString(databaseName))
  result = call_594474.call(path_594475, query_594476, nil, nil, nil)

var catalogGetView* = Call_CatalogGetView_594466(name: "catalogGetView",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/catalog/usql/databases/{databaseName}/schemas/{schemaName}/views/{viewName}",
    validator: validate_CatalogGetView_594467, base: "", url: url_CatalogGetView_594468,
    schemes: {Scheme.Https})
type
  Call_CatalogDeleteAllSecrets_594477 = ref object of OpenApiRestCall_593437
proc url_CatalogDeleteAllSecrets_594479(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogDeleteAllSecrets_594478(path: JsonNode; query: JsonNode;
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
  var valid_594480 = path.getOrDefault("databaseName")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = nil)
  if valid_594480 != nil:
    section.add "databaseName", valid_594480
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594481 = query.getOrDefault("api-version")
  valid_594481 = validateParameter(valid_594481, JString, required = true,
                                 default = nil)
  if valid_594481 != nil:
    section.add "api-version", valid_594481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594482: Call_CatalogDeleteAllSecrets_594477; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes all secrets in the specified database. This is deprecated and will be removed in the next release. In the future, please only drop individual credentials using DeleteCredential
  ## 
  let valid = call_594482.validator(path, query, header, formData, body)
  let scheme = call_594482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594482.url(scheme.get, call_594482.host, call_594482.base,
                         call_594482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594482, url, valid)

proc call*(call_594483: Call_CatalogDeleteAllSecrets_594477; apiVersion: string;
          databaseName: string): Recallable =
  ## catalogDeleteAllSecrets
  ## Deletes all secrets in the specified database. This is deprecated and will be removed in the next release. In the future, please only drop individual credentials using DeleteCredential
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  var path_594484 = newJObject()
  var query_594485 = newJObject()
  add(query_594485, "api-version", newJString(apiVersion))
  add(path_594484, "databaseName", newJString(databaseName))
  result = call_594483.call(path_594484, query_594485, nil, nil, nil)

var catalogDeleteAllSecrets* = Call_CatalogDeleteAllSecrets_594477(
    name: "catalogDeleteAllSecrets", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/secrets",
    validator: validate_CatalogDeleteAllSecrets_594478, base: "",
    url: url_CatalogDeleteAllSecrets_594479, schemes: {Scheme.Https})
type
  Call_CatalogCreateSecret_594496 = ref object of OpenApiRestCall_593437
proc url_CatalogCreateSecret_594498(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogCreateSecret_594497(path: JsonNode; query: JsonNode;
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
  var valid_594499 = path.getOrDefault("databaseName")
  valid_594499 = validateParameter(valid_594499, JString, required = true,
                                 default = nil)
  if valid_594499 != nil:
    section.add "databaseName", valid_594499
  var valid_594500 = path.getOrDefault("secretName")
  valid_594500 = validateParameter(valid_594500, JString, required = true,
                                 default = nil)
  if valid_594500 != nil:
    section.add "secretName", valid_594500
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594501 = query.getOrDefault("api-version")
  valid_594501 = validateParameter(valid_594501, JString, required = true,
                                 default = nil)
  if valid_594501 != nil:
    section.add "api-version", valid_594501
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

proc call*(call_594503: Call_CatalogCreateSecret_594496; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the specified secret for use with external data sources in the specified database. This is deprecated and will be removed in the next release. Please use CreateCredential instead.
  ## 
  let valid = call_594503.validator(path, query, header, formData, body)
  let scheme = call_594503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594503.url(scheme.get, call_594503.host, call_594503.base,
                         call_594503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594503, url, valid)

proc call*(call_594504: Call_CatalogCreateSecret_594496; apiVersion: string;
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
  var path_594505 = newJObject()
  var query_594506 = newJObject()
  var body_594507 = newJObject()
  add(query_594506, "api-version", newJString(apiVersion))
  add(path_594505, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_594507 = parameters
  add(path_594505, "secretName", newJString(secretName))
  result = call_594504.call(path_594505, query_594506, nil, nil, body_594507)

var catalogCreateSecret* = Call_CatalogCreateSecret_594496(
    name: "catalogCreateSecret", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogCreateSecret_594497, base: "",
    url: url_CatalogCreateSecret_594498, schemes: {Scheme.Https})
type
  Call_CatalogGetSecret_594486 = ref object of OpenApiRestCall_593437
proc url_CatalogGetSecret_594488(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogGetSecret_594487(path: JsonNode; query: JsonNode;
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
  var valid_594489 = path.getOrDefault("databaseName")
  valid_594489 = validateParameter(valid_594489, JString, required = true,
                                 default = nil)
  if valid_594489 != nil:
    section.add "databaseName", valid_594489
  var valid_594490 = path.getOrDefault("secretName")
  valid_594490 = validateParameter(valid_594490, JString, required = true,
                                 default = nil)
  if valid_594490 != nil:
    section.add "secretName", valid_594490
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594491 = query.getOrDefault("api-version")
  valid_594491 = validateParameter(valid_594491, JString, required = true,
                                 default = nil)
  if valid_594491 != nil:
    section.add "api-version", valid_594491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594492: Call_CatalogGetSecret_594486; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified secret in the specified database. This is deprecated and will be removed in the next release. Please use GetCredential instead.
  ## 
  let valid = call_594492.validator(path, query, header, formData, body)
  let scheme = call_594492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594492.url(scheme.get, call_594492.host, call_594492.base,
                         call_594492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594492, url, valid)

proc call*(call_594493: Call_CatalogGetSecret_594486; apiVersion: string;
          databaseName: string; secretName: string): Recallable =
  ## catalogGetSecret
  ## Gets the specified secret in the specified database. This is deprecated and will be removed in the next release. Please use GetCredential instead.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  ##   secretName: string (required)
  ##             : The name of the secret to get
  var path_594494 = newJObject()
  var query_594495 = newJObject()
  add(query_594495, "api-version", newJString(apiVersion))
  add(path_594494, "databaseName", newJString(databaseName))
  add(path_594494, "secretName", newJString(secretName))
  result = call_594493.call(path_594494, query_594495, nil, nil, nil)

var catalogGetSecret* = Call_CatalogGetSecret_594486(name: "catalogGetSecret",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogGetSecret_594487, base: "",
    url: url_CatalogGetSecret_594488, schemes: {Scheme.Https})
type
  Call_CatalogUpdateSecret_594518 = ref object of OpenApiRestCall_593437
proc url_CatalogUpdateSecret_594520(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogUpdateSecret_594519(path: JsonNode; query: JsonNode;
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
  var valid_594521 = path.getOrDefault("databaseName")
  valid_594521 = validateParameter(valid_594521, JString, required = true,
                                 default = nil)
  if valid_594521 != nil:
    section.add "databaseName", valid_594521
  var valid_594522 = path.getOrDefault("secretName")
  valid_594522 = validateParameter(valid_594522, JString, required = true,
                                 default = nil)
  if valid_594522 != nil:
    section.add "secretName", valid_594522
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594523 = query.getOrDefault("api-version")
  valid_594523 = validateParameter(valid_594523, JString, required = true,
                                 default = nil)
  if valid_594523 != nil:
    section.add "api-version", valid_594523
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

proc call*(call_594525: Call_CatalogUpdateSecret_594518; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the specified secret for use with external data sources in the specified database. This is deprecated and will be removed in the next release. Please use UpdateCredential instead.
  ## 
  let valid = call_594525.validator(path, query, header, formData, body)
  let scheme = call_594525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594525.url(scheme.get, call_594525.host, call_594525.base,
                         call_594525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594525, url, valid)

proc call*(call_594526: Call_CatalogUpdateSecret_594518; apiVersion: string;
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
  var path_594527 = newJObject()
  var query_594528 = newJObject()
  var body_594529 = newJObject()
  add(query_594528, "api-version", newJString(apiVersion))
  add(path_594527, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_594529 = parameters
  add(path_594527, "secretName", newJString(secretName))
  result = call_594526.call(path_594527, query_594528, nil, nil, body_594529)

var catalogUpdateSecret* = Call_CatalogUpdateSecret_594518(
    name: "catalogUpdateSecret", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogUpdateSecret_594519, base: "",
    url: url_CatalogUpdateSecret_594520, schemes: {Scheme.Https})
type
  Call_CatalogDeleteSecret_594508 = ref object of OpenApiRestCall_593437
proc url_CatalogDeleteSecret_594510(protocol: Scheme; host: string; base: string;
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

proc validate_CatalogDeleteSecret_594509(path: JsonNode; query: JsonNode;
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
  var valid_594511 = path.getOrDefault("databaseName")
  valid_594511 = validateParameter(valid_594511, JString, required = true,
                                 default = nil)
  if valid_594511 != nil:
    section.add "databaseName", valid_594511
  var valid_594512 = path.getOrDefault("secretName")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "secretName", valid_594512
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594513 = query.getOrDefault("api-version")
  valid_594513 = validateParameter(valid_594513, JString, required = true,
                                 default = nil)
  if valid_594513 != nil:
    section.add "api-version", valid_594513
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594514: Call_CatalogDeleteSecret_594508; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified secret in the specified database. This is deprecated and will be removed in the next release. Please use DeleteCredential instead.
  ## 
  let valid = call_594514.validator(path, query, header, formData, body)
  let scheme = call_594514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594514.url(scheme.get, call_594514.host, call_594514.base,
                         call_594514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594514, url, valid)

proc call*(call_594515: Call_CatalogDeleteSecret_594508; apiVersion: string;
          databaseName: string; secretName: string): Recallable =
  ## catalogDeleteSecret
  ## Deletes the specified secret in the specified database. This is deprecated and will be removed in the next release. Please use DeleteCredential instead.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   databaseName: string (required)
  ##               : The name of the database containing the secret.
  ##   secretName: string (required)
  ##             : The name of the secret to delete
  var path_594516 = newJObject()
  var query_594517 = newJObject()
  add(query_594517, "api-version", newJString(apiVersion))
  add(path_594516, "databaseName", newJString(databaseName))
  add(path_594516, "secretName", newJString(secretName))
  result = call_594515.call(path_594516, query_594517, nil, nil, nil)

var catalogDeleteSecret* = Call_CatalogDeleteSecret_594508(
    name: "catalogDeleteSecret", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/secrets/{secretName}",
    validator: validate_CatalogDeleteSecret_594509, base: "",
    url: url_CatalogDeleteSecret_594510, schemes: {Scheme.Https})
type
  Call_CatalogListTableStatisticsByDatabase_594530 = ref object of OpenApiRestCall_593437
proc url_CatalogListTableStatisticsByDatabase_594532(protocol: Scheme;
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

proc validate_CatalogListTableStatisticsByDatabase_594531(path: JsonNode;
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
  var valid_594533 = path.getOrDefault("databaseName")
  valid_594533 = validateParameter(valid_594533, JString, required = true,
                                 default = nil)
  if valid_594533 != nil:
    section.add "databaseName", valid_594533
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
  var valid_594534 = query.getOrDefault("$orderby")
  valid_594534 = validateParameter(valid_594534, JString, required = false,
                                 default = nil)
  if valid_594534 != nil:
    section.add "$orderby", valid_594534
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594535 = query.getOrDefault("api-version")
  valid_594535 = validateParameter(valid_594535, JString, required = true,
                                 default = nil)
  if valid_594535 != nil:
    section.add "api-version", valid_594535
  var valid_594536 = query.getOrDefault("$top")
  valid_594536 = validateParameter(valid_594536, JInt, required = false, default = nil)
  if valid_594536 != nil:
    section.add "$top", valid_594536
  var valid_594537 = query.getOrDefault("$select")
  valid_594537 = validateParameter(valid_594537, JString, required = false,
                                 default = nil)
  if valid_594537 != nil:
    section.add "$select", valid_594537
  var valid_594538 = query.getOrDefault("$skip")
  valid_594538 = validateParameter(valid_594538, JInt, required = false, default = nil)
  if valid_594538 != nil:
    section.add "$skip", valid_594538
  var valid_594539 = query.getOrDefault("$count")
  valid_594539 = validateParameter(valid_594539, JBool, required = false, default = nil)
  if valid_594539 != nil:
    section.add "$count", valid_594539
  var valid_594540 = query.getOrDefault("$filter")
  valid_594540 = validateParameter(valid_594540, JString, required = false,
                                 default = nil)
  if valid_594540 != nil:
    section.add "$filter", valid_594540
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594541: Call_CatalogListTableStatisticsByDatabase_594530;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of all statistics in a database from the Data Lake Analytics catalog.
  ## 
  let valid = call_594541.validator(path, query, header, formData, body)
  let scheme = call_594541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594541.url(scheme.get, call_594541.host, call_594541.base,
                         call_594541.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594541, url, valid)

proc call*(call_594542: Call_CatalogListTableStatisticsByDatabase_594530;
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
  var path_594543 = newJObject()
  var query_594544 = newJObject()
  add(query_594544, "$orderby", newJString(Orderby))
  add(query_594544, "api-version", newJString(apiVersion))
  add(query_594544, "$top", newJInt(Top))
  add(query_594544, "$select", newJString(Select))
  add(path_594543, "databaseName", newJString(databaseName))
  add(query_594544, "$skip", newJInt(Skip))
  add(query_594544, "$count", newJBool(Count))
  add(query_594544, "$filter", newJString(Filter))
  result = call_594542.call(path_594543, query_594544, nil, nil, nil)

var catalogListTableStatisticsByDatabase* = Call_CatalogListTableStatisticsByDatabase_594530(
    name: "catalogListTableStatisticsByDatabase", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/statistics",
    validator: validate_CatalogListTableStatisticsByDatabase_594531, base: "",
    url: url_CatalogListTableStatisticsByDatabase_594532, schemes: {Scheme.Https})
type
  Call_CatalogListTablesByDatabase_594545 = ref object of OpenApiRestCall_593437
proc url_CatalogListTablesByDatabase_594547(protocol: Scheme; host: string;
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

proc validate_CatalogListTablesByDatabase_594546(path: JsonNode; query: JsonNode;
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
  var valid_594548 = path.getOrDefault("databaseName")
  valid_594548 = validateParameter(valid_594548, JString, required = true,
                                 default = nil)
  if valid_594548 != nil:
    section.add "databaseName", valid_594548
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
  var valid_594549 = query.getOrDefault("$orderby")
  valid_594549 = validateParameter(valid_594549, JString, required = false,
                                 default = nil)
  if valid_594549 != nil:
    section.add "$orderby", valid_594549
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594550 = query.getOrDefault("api-version")
  valid_594550 = validateParameter(valid_594550, JString, required = true,
                                 default = nil)
  if valid_594550 != nil:
    section.add "api-version", valid_594550
  var valid_594551 = query.getOrDefault("$top")
  valid_594551 = validateParameter(valid_594551, JInt, required = false, default = nil)
  if valid_594551 != nil:
    section.add "$top", valid_594551
  var valid_594552 = query.getOrDefault("$select")
  valid_594552 = validateParameter(valid_594552, JString, required = false,
                                 default = nil)
  if valid_594552 != nil:
    section.add "$select", valid_594552
  var valid_594553 = query.getOrDefault("$skip")
  valid_594553 = validateParameter(valid_594553, JInt, required = false, default = nil)
  if valid_594553 != nil:
    section.add "$skip", valid_594553
  var valid_594554 = query.getOrDefault("$count")
  valid_594554 = validateParameter(valid_594554, JBool, required = false, default = nil)
  if valid_594554 != nil:
    section.add "$count", valid_594554
  var valid_594555 = query.getOrDefault("basic")
  valid_594555 = validateParameter(valid_594555, JBool, required = false,
                                 default = newJBool(false))
  if valid_594555 != nil:
    section.add "basic", valid_594555
  var valid_594556 = query.getOrDefault("$filter")
  valid_594556 = validateParameter(valid_594556, JString, required = false,
                                 default = nil)
  if valid_594556 != nil:
    section.add "$filter", valid_594556
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594557: Call_CatalogListTablesByDatabase_594545; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of all tables in a database from the Data Lake Analytics catalog.
  ## 
  let valid = call_594557.validator(path, query, header, formData, body)
  let scheme = call_594557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594557.url(scheme.get, call_594557.host, call_594557.base,
                         call_594557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594557, url, valid)

proc call*(call_594558: Call_CatalogListTablesByDatabase_594545;
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
  var path_594559 = newJObject()
  var query_594560 = newJObject()
  add(query_594560, "$orderby", newJString(Orderby))
  add(query_594560, "api-version", newJString(apiVersion))
  add(query_594560, "$top", newJInt(Top))
  add(query_594560, "$select", newJString(Select))
  add(path_594559, "databaseName", newJString(databaseName))
  add(query_594560, "$skip", newJInt(Skip))
  add(query_594560, "$count", newJBool(Count))
  add(query_594560, "basic", newJBool(basic))
  add(query_594560, "$filter", newJString(Filter))
  result = call_594558.call(path_594559, query_594560, nil, nil, nil)

var catalogListTablesByDatabase* = Call_CatalogListTablesByDatabase_594545(
    name: "catalogListTablesByDatabase", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/tables",
    validator: validate_CatalogListTablesByDatabase_594546, base: "",
    url: url_CatalogListTablesByDatabase_594547, schemes: {Scheme.Https})
type
  Call_CatalogListTableValuedFunctionsByDatabase_594561 = ref object of OpenApiRestCall_593437
proc url_CatalogListTableValuedFunctionsByDatabase_594563(protocol: Scheme;
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

proc validate_CatalogListTableValuedFunctionsByDatabase_594562(path: JsonNode;
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
  var valid_594564 = path.getOrDefault("databaseName")
  valid_594564 = validateParameter(valid_594564, JString, required = true,
                                 default = nil)
  if valid_594564 != nil:
    section.add "databaseName", valid_594564
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
  var valid_594565 = query.getOrDefault("$orderby")
  valid_594565 = validateParameter(valid_594565, JString, required = false,
                                 default = nil)
  if valid_594565 != nil:
    section.add "$orderby", valid_594565
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594566 = query.getOrDefault("api-version")
  valid_594566 = validateParameter(valid_594566, JString, required = true,
                                 default = nil)
  if valid_594566 != nil:
    section.add "api-version", valid_594566
  var valid_594567 = query.getOrDefault("$top")
  valid_594567 = validateParameter(valid_594567, JInt, required = false, default = nil)
  if valid_594567 != nil:
    section.add "$top", valid_594567
  var valid_594568 = query.getOrDefault("$select")
  valid_594568 = validateParameter(valid_594568, JString, required = false,
                                 default = nil)
  if valid_594568 != nil:
    section.add "$select", valid_594568
  var valid_594569 = query.getOrDefault("$skip")
  valid_594569 = validateParameter(valid_594569, JInt, required = false, default = nil)
  if valid_594569 != nil:
    section.add "$skip", valid_594569
  var valid_594570 = query.getOrDefault("$count")
  valid_594570 = validateParameter(valid_594570, JBool, required = false, default = nil)
  if valid_594570 != nil:
    section.add "$count", valid_594570
  var valid_594571 = query.getOrDefault("$filter")
  valid_594571 = validateParameter(valid_594571, JString, required = false,
                                 default = nil)
  if valid_594571 != nil:
    section.add "$filter", valid_594571
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594572: Call_CatalogListTableValuedFunctionsByDatabase_594561;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of all table valued functions in a database from the Data Lake Analytics catalog.
  ## 
  let valid = call_594572.validator(path, query, header, formData, body)
  let scheme = call_594572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594572.url(scheme.get, call_594572.host, call_594572.base,
                         call_594572.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594572, url, valid)

proc call*(call_594573: Call_CatalogListTableValuedFunctionsByDatabase_594561;
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
  var path_594574 = newJObject()
  var query_594575 = newJObject()
  add(query_594575, "$orderby", newJString(Orderby))
  add(query_594575, "api-version", newJString(apiVersion))
  add(query_594575, "$top", newJInt(Top))
  add(query_594575, "$select", newJString(Select))
  add(path_594574, "databaseName", newJString(databaseName))
  add(query_594575, "$skip", newJInt(Skip))
  add(query_594575, "$count", newJBool(Count))
  add(query_594575, "$filter", newJString(Filter))
  result = call_594573.call(path_594574, query_594575, nil, nil, nil)

var catalogListTableValuedFunctionsByDatabase* = Call_CatalogListTableValuedFunctionsByDatabase_594561(
    name: "catalogListTableValuedFunctionsByDatabase", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/catalog/usql/databases/{databaseName}/tablevaluedfunctions",
    validator: validate_CatalogListTableValuedFunctionsByDatabase_594562,
    base: "", url: url_CatalogListTableValuedFunctionsByDatabase_594563,
    schemes: {Scheme.Https})
type
  Call_CatalogListViewsByDatabase_594576 = ref object of OpenApiRestCall_593437
proc url_CatalogListViewsByDatabase_594578(protocol: Scheme; host: string;
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

proc validate_CatalogListViewsByDatabase_594577(path: JsonNode; query: JsonNode;
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
  var valid_594579 = path.getOrDefault("databaseName")
  valid_594579 = validateParameter(valid_594579, JString, required = true,
                                 default = nil)
  if valid_594579 != nil:
    section.add "databaseName", valid_594579
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
  var valid_594580 = query.getOrDefault("$orderby")
  valid_594580 = validateParameter(valid_594580, JString, required = false,
                                 default = nil)
  if valid_594580 != nil:
    section.add "$orderby", valid_594580
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594581 = query.getOrDefault("api-version")
  valid_594581 = validateParameter(valid_594581, JString, required = true,
                                 default = nil)
  if valid_594581 != nil:
    section.add "api-version", valid_594581
  var valid_594582 = query.getOrDefault("$top")
  valid_594582 = validateParameter(valid_594582, JInt, required = false, default = nil)
  if valid_594582 != nil:
    section.add "$top", valid_594582
  var valid_594583 = query.getOrDefault("$select")
  valid_594583 = validateParameter(valid_594583, JString, required = false,
                                 default = nil)
  if valid_594583 != nil:
    section.add "$select", valid_594583
  var valid_594584 = query.getOrDefault("$skip")
  valid_594584 = validateParameter(valid_594584, JInt, required = false, default = nil)
  if valid_594584 != nil:
    section.add "$skip", valid_594584
  var valid_594585 = query.getOrDefault("$count")
  valid_594585 = validateParameter(valid_594585, JBool, required = false, default = nil)
  if valid_594585 != nil:
    section.add "$count", valid_594585
  var valid_594586 = query.getOrDefault("$filter")
  valid_594586 = validateParameter(valid_594586, JString, required = false,
                                 default = nil)
  if valid_594586 != nil:
    section.add "$filter", valid_594586
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594587: Call_CatalogListViewsByDatabase_594576; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of all views in a database from the Data Lake Analytics catalog.
  ## 
  let valid = call_594587.validator(path, query, header, formData, body)
  let scheme = call_594587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594587.url(scheme.get, call_594587.host, call_594587.base,
                         call_594587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594587, url, valid)

proc call*(call_594588: Call_CatalogListViewsByDatabase_594576; apiVersion: string;
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
  var path_594589 = newJObject()
  var query_594590 = newJObject()
  add(query_594590, "$orderby", newJString(Orderby))
  add(query_594590, "api-version", newJString(apiVersion))
  add(query_594590, "$top", newJInt(Top))
  add(query_594590, "$select", newJString(Select))
  add(path_594589, "databaseName", newJString(databaseName))
  add(query_594590, "$skip", newJInt(Skip))
  add(query_594590, "$count", newJBool(Count))
  add(query_594590, "$filter", newJString(Filter))
  result = call_594588.call(path_594589, query_594590, nil, nil, nil)

var catalogListViewsByDatabase* = Call_CatalogListViewsByDatabase_594576(
    name: "catalogListViewsByDatabase", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/catalog/usql/databases/{databaseName}/views",
    validator: validate_CatalogListViewsByDatabase_594577, base: "",
    url: url_CatalogListViewsByDatabase_594578, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
