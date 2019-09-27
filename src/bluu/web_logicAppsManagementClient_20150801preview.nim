
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: LogicAppsManagementClient
## version: 2015-08-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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
  macServiceName = "web-logicAppsManagementClient"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ManagedApisList_593630 = ref object of OpenApiRestCall_593408
proc url_ManagedApisList_593632(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/managedApis")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedApisList_593631(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a list of managed APIs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  ##   location: JString (required)
  ##           : The location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593805 = path.getOrDefault("subscriptionId")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "subscriptionId", valid_593805
  var valid_593806 = path.getOrDefault("location")
  valid_593806 = validateParameter(valid_593806, JString, required = true,
                                 default = nil)
  if valid_593806 != nil:
    section.add "location", valid_593806
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593807 = query.getOrDefault("api-version")
  valid_593807 = validateParameter(valid_593807, JString, required = true,
                                 default = nil)
  if valid_593807 != nil:
    section.add "api-version", valid_593807
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593830: Call_ManagedApisList_593630; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of managed APIs.
  ## 
  let valid = call_593830.validator(path, query, header, formData, body)
  let scheme = call_593830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593830.url(scheme.get, call_593830.host, call_593830.base,
                         call_593830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593830, url, valid)

proc call*(call_593901: Call_ManagedApisList_593630; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## managedApisList
  ## Gets a list of managed APIs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   location: string (required)
  ##           : The location.
  var path_593902 = newJObject()
  var query_593904 = newJObject()
  add(query_593904, "api-version", newJString(apiVersion))
  add(path_593902, "subscriptionId", newJString(subscriptionId))
  add(path_593902, "location", newJString(location))
  result = call_593901.call(path_593902, query_593904, nil, nil, nil)

var managedApisList* = Call_ManagedApisList_593630(name: "managedApisList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/locations/{location}/managedApis",
    validator: validate_ManagedApisList_593631, base: "", url: url_ManagedApisList_593632,
    schemes: {Scheme.Https})
type
  Call_ManagedApisGet_593943 = ref object of OpenApiRestCall_593408
proc url_ManagedApisGet_593945(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "apiName" in path, "`apiName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/managedApis/"),
               (kind: VariableSegment, value: "apiName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedApisGet_593944(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a managed API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiName: JString (required)
  ##          : The managed API name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  ##   location: JString (required)
  ##           : The location.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiName` field"
  var valid_593946 = path.getOrDefault("apiName")
  valid_593946 = validateParameter(valid_593946, JString, required = true,
                                 default = nil)
  if valid_593946 != nil:
    section.add "apiName", valid_593946
  var valid_593947 = path.getOrDefault("subscriptionId")
  valid_593947 = validateParameter(valid_593947, JString, required = true,
                                 default = nil)
  if valid_593947 != nil:
    section.add "subscriptionId", valid_593947
  var valid_593948 = path.getOrDefault("location")
  valid_593948 = validateParameter(valid_593948, JString, required = true,
                                 default = nil)
  if valid_593948 != nil:
    section.add "location", valid_593948
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   export: JBool
  ##         : flag showing whether to export API definition in format specified by Accept header.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593949 = query.getOrDefault("api-version")
  valid_593949 = validateParameter(valid_593949, JString, required = true,
                                 default = nil)
  if valid_593949 != nil:
    section.add "api-version", valid_593949
  var valid_593950 = query.getOrDefault("export")
  valid_593950 = validateParameter(valid_593950, JBool, required = false, default = nil)
  if valid_593950 != nil:
    section.add "export", valid_593950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593951: Call_ManagedApisGet_593943; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a managed API.
  ## 
  let valid = call_593951.validator(path, query, header, formData, body)
  let scheme = call_593951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593951.url(scheme.get, call_593951.host, call_593951.base,
                         call_593951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593951, url, valid)

proc call*(call_593952: Call_ManagedApisGet_593943; apiVersion: string;
          apiName: string; subscriptionId: string; location: string;
          `export`: bool = false): Recallable =
  ## managedApisGet
  ## Gets a managed API.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   apiName: string (required)
  ##          : The managed API name.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   location: string (required)
  ##           : The location.
  ##   export: bool
  ##         : flag showing whether to export API definition in format specified by Accept header.
  var path_593953 = newJObject()
  var query_593954 = newJObject()
  add(query_593954, "api-version", newJString(apiVersion))
  add(path_593953, "apiName", newJString(apiName))
  add(path_593953, "subscriptionId", newJString(subscriptionId))
  add(path_593953, "location", newJString(location))
  add(query_593954, "export", newJBool(`export`))
  result = call_593952.call(path_593953, query_593954, nil, nil, nil)

var managedApisGet* = Call_ManagedApisGet_593943(name: "managedApisGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/locations/{location}/managedApis/{apiName}",
    validator: validate_ManagedApisGet_593944, base: "", url: url_ManagedApisGet_593945,
    schemes: {Scheme.Https})
type
  Call_ConnectionsList_593955 = ref object of OpenApiRestCall_593408
proc url_ConnectionsList_593957(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/connections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionsList_593956(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a list of connections.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593959 = path.getOrDefault("resourceGroupName")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = nil)
  if valid_593959 != nil:
    section.add "resourceGroupName", valid_593959
  var valid_593960 = path.getOrDefault("subscriptionId")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "subscriptionId", valid_593960
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593961 = query.getOrDefault("api-version")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "api-version", valid_593961
  var valid_593962 = query.getOrDefault("$top")
  valid_593962 = validateParameter(valid_593962, JInt, required = false, default = nil)
  if valid_593962 != nil:
    section.add "$top", valid_593962
  var valid_593963 = query.getOrDefault("$filter")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = nil)
  if valid_593963 != nil:
    section.add "$filter", valid_593963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593964: Call_ConnectionsList_593955; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of connections.
  ## 
  let valid = call_593964.validator(path, query, header, formData, body)
  let scheme = call_593964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593964.url(scheme.get, call_593964.host, call_593964.base,
                         call_593964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593964, url, valid)

proc call*(call_593965: Call_ConnectionsList_593955; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## connectionsList
  ## Gets a list of connections.
  ##   resourceGroupName: string (required)
  ##                    : Resource Group Name
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_593966 = newJObject()
  var query_593967 = newJObject()
  add(path_593966, "resourceGroupName", newJString(resourceGroupName))
  add(query_593967, "api-version", newJString(apiVersion))
  add(path_593966, "subscriptionId", newJString(subscriptionId))
  add(query_593967, "$top", newJInt(Top))
  add(query_593967, "$filter", newJString(Filter))
  result = call_593965.call(path_593966, query_593967, nil, nil, nil)

var connectionsList* = Call_ConnectionsList_593955(name: "connectionsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/connections",
    validator: validate_ConnectionsList_593956, base: "", url: url_ConnectionsList_593957,
    schemes: {Scheme.Https})
type
  Call_ConnectionsCreateOrUpdate_593979 = ref object of OpenApiRestCall_593408
proc url_ConnectionsCreateOrUpdate_593981(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/connections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionsCreateOrUpdate_593980(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  ##   connectionName: JString (required)
  ##                 : The connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593982 = path.getOrDefault("resourceGroupName")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "resourceGroupName", valid_593982
  var valid_593983 = path.getOrDefault("subscriptionId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "subscriptionId", valid_593983
  var valid_593984 = path.getOrDefault("connectionName")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "connectionName", valid_593984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593985 = query.getOrDefault("api-version")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "api-version", valid_593985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   connection: JObject (required)
  ##             : The connection.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593987: Call_ConnectionsCreateOrUpdate_593979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a connection.
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_ConnectionsCreateOrUpdate_593979;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          connection: JsonNode; connectionName: string): Recallable =
  ## connectionsCreateOrUpdate
  ## Creates or updates a connection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   connection: JObject (required)
  ##             : The connection.
  ##   connectionName: string (required)
  ##                 : The connection name.
  var path_593989 = newJObject()
  var query_593990 = newJObject()
  var body_593991 = newJObject()
  add(path_593989, "resourceGroupName", newJString(resourceGroupName))
  add(query_593990, "api-version", newJString(apiVersion))
  add(path_593989, "subscriptionId", newJString(subscriptionId))
  if connection != nil:
    body_593991 = connection
  add(path_593989, "connectionName", newJString(connectionName))
  result = call_593988.call(path_593989, query_593990, nil, nil, body_593991)

var connectionsCreateOrUpdate* = Call_ConnectionsCreateOrUpdate_593979(
    name: "connectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/connections/{connectionName}",
    validator: validate_ConnectionsCreateOrUpdate_593980, base: "",
    url: url_ConnectionsCreateOrUpdate_593981, schemes: {Scheme.Https})
type
  Call_ConnectionsGet_593968 = ref object of OpenApiRestCall_593408
proc url_ConnectionsGet_593970(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/connections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionsGet_593969(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  ##   connectionName: JString (required)
  ##                 : The connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593971 = path.getOrDefault("resourceGroupName")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "resourceGroupName", valid_593971
  var valid_593972 = path.getOrDefault("subscriptionId")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "subscriptionId", valid_593972
  var valid_593973 = path.getOrDefault("connectionName")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "connectionName", valid_593973
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593974 = query.getOrDefault("api-version")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "api-version", valid_593974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593975: Call_ConnectionsGet_593968; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a connection.
  ## 
  let valid = call_593975.validator(path, query, header, formData, body)
  let scheme = call_593975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593975.url(scheme.get, call_593975.host, call_593975.base,
                         call_593975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593975, url, valid)

proc call*(call_593976: Call_ConnectionsGet_593968; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; connectionName: string): Recallable =
  ## connectionsGet
  ## Gets a connection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   connectionName: string (required)
  ##                 : The connection name.
  var path_593977 = newJObject()
  var query_593978 = newJObject()
  add(path_593977, "resourceGroupName", newJString(resourceGroupName))
  add(query_593978, "api-version", newJString(apiVersion))
  add(path_593977, "subscriptionId", newJString(subscriptionId))
  add(path_593977, "connectionName", newJString(connectionName))
  result = call_593976.call(path_593977, query_593978, nil, nil, nil)

var connectionsGet* = Call_ConnectionsGet_593968(name: "connectionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/connections/{connectionName}",
    validator: validate_ConnectionsGet_593969, base: "", url: url_ConnectionsGet_593970,
    schemes: {Scheme.Https})
type
  Call_ConnectionsDelete_593992 = ref object of OpenApiRestCall_593408
proc url_ConnectionsDelete_593994(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/connections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionsDelete_593993(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes a connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  ##   connectionName: JString (required)
  ##                 : The connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593995 = path.getOrDefault("resourceGroupName")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "resourceGroupName", valid_593995
  var valid_593996 = path.getOrDefault("subscriptionId")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "subscriptionId", valid_593996
  var valid_593997 = path.getOrDefault("connectionName")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "connectionName", valid_593997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593998 = query.getOrDefault("api-version")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "api-version", valid_593998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593999: Call_ConnectionsDelete_593992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a connection.
  ## 
  let valid = call_593999.validator(path, query, header, formData, body)
  let scheme = call_593999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593999.url(scheme.get, call_593999.host, call_593999.base,
                         call_593999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593999, url, valid)

proc call*(call_594000: Call_ConnectionsDelete_593992; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; connectionName: string): Recallable =
  ## connectionsDelete
  ## Deletes a connection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   connectionName: string (required)
  ##                 : The connection name.
  var path_594001 = newJObject()
  var query_594002 = newJObject()
  add(path_594001, "resourceGroupName", newJString(resourceGroupName))
  add(query_594002, "api-version", newJString(apiVersion))
  add(path_594001, "subscriptionId", newJString(subscriptionId))
  add(path_594001, "connectionName", newJString(connectionName))
  result = call_594000.call(path_594001, query_594002, nil, nil, nil)

var connectionsDelete* = Call_ConnectionsDelete_593992(name: "connectionsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/connections/{connectionName}",
    validator: validate_ConnectionsDelete_593993, base: "",
    url: url_ConnectionsDelete_593994, schemes: {Scheme.Https})
type
  Call_ConnectionsConfirmConsentCode_594003 = ref object of OpenApiRestCall_593408
proc url_ConnectionsConfirmConsentCode_594005(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/connections/"),
               (kind: VariableSegment, value: "connectionName"),
               (kind: ConstantSegment, value: "/confirmConsentCode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionsConfirmConsentCode_594004(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Confirms consent code of a connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  ##   connectionName: JString (required)
  ##                 : The connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594006 = path.getOrDefault("resourceGroupName")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "resourceGroupName", valid_594006
  var valid_594007 = path.getOrDefault("subscriptionId")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "subscriptionId", valid_594007
  var valid_594008 = path.getOrDefault("connectionName")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "connectionName", valid_594008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594009 = query.getOrDefault("api-version")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "api-version", valid_594009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   content: JObject (required)
  ##          : The content.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594011: Call_ConnectionsConfirmConsentCode_594003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Confirms consent code of a connection.
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_ConnectionsConfirmConsentCode_594003;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          content: JsonNode; connectionName: string): Recallable =
  ## connectionsConfirmConsentCode
  ## Confirms consent code of a connection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   content: JObject (required)
  ##          : The content.
  ##   connectionName: string (required)
  ##                 : The connection name.
  var path_594013 = newJObject()
  var query_594014 = newJObject()
  var body_594015 = newJObject()
  add(path_594013, "resourceGroupName", newJString(resourceGroupName))
  add(query_594014, "api-version", newJString(apiVersion))
  add(path_594013, "subscriptionId", newJString(subscriptionId))
  if content != nil:
    body_594015 = content
  add(path_594013, "connectionName", newJString(connectionName))
  result = call_594012.call(path_594013, query_594014, nil, nil, body_594015)

var connectionsConfirmConsentCode* = Call_ConnectionsConfirmConsentCode_594003(
    name: "connectionsConfirmConsentCode", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/connections/{connectionName}/confirmConsentCode",
    validator: validate_ConnectionsConfirmConsentCode_594004, base: "",
    url: url_ConnectionsConfirmConsentCode_594005, schemes: {Scheme.Https})
type
  Call_ConnectionsListConnectionKeys_594016 = ref object of OpenApiRestCall_593408
proc url_ConnectionsListConnectionKeys_594018(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/connections/"),
               (kind: VariableSegment, value: "connectionName"),
               (kind: ConstantSegment, value: "/listConnectionKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionsListConnectionKeys_594017(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists connection keys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  ##   connectionName: JString (required)
  ##                 : The connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594019 = path.getOrDefault("resourceGroupName")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "resourceGroupName", valid_594019
  var valid_594020 = path.getOrDefault("subscriptionId")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "subscriptionId", valid_594020
  var valid_594021 = path.getOrDefault("connectionName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "connectionName", valid_594021
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594022 = query.getOrDefault("api-version")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "api-version", valid_594022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   content: JObject (required)
  ##          : The content.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594024: Call_ConnectionsListConnectionKeys_594016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists connection keys.
  ## 
  let valid = call_594024.validator(path, query, header, formData, body)
  let scheme = call_594024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594024.url(scheme.get, call_594024.host, call_594024.base,
                         call_594024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594024, url, valid)

proc call*(call_594025: Call_ConnectionsListConnectionKeys_594016;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          content: JsonNode; connectionName: string): Recallable =
  ## connectionsListConnectionKeys
  ## Lists connection keys.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   content: JObject (required)
  ##          : The content.
  ##   connectionName: string (required)
  ##                 : The connection name.
  var path_594026 = newJObject()
  var query_594027 = newJObject()
  var body_594028 = newJObject()
  add(path_594026, "resourceGroupName", newJString(resourceGroupName))
  add(query_594027, "api-version", newJString(apiVersion))
  add(path_594026, "subscriptionId", newJString(subscriptionId))
  if content != nil:
    body_594028 = content
  add(path_594026, "connectionName", newJString(connectionName))
  result = call_594025.call(path_594026, query_594027, nil, nil, body_594028)

var connectionsListConnectionKeys* = Call_ConnectionsListConnectionKeys_594016(
    name: "connectionsListConnectionKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/connections/{connectionName}/listConnectionKeys",
    validator: validate_ConnectionsListConnectionKeys_594017, base: "",
    url: url_ConnectionsListConnectionKeys_594018, schemes: {Scheme.Https})
type
  Call_ConnectionsListConsentLinks_594029 = ref object of OpenApiRestCall_593408
proc url_ConnectionsListConsentLinks_594031(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/connections/"),
               (kind: VariableSegment, value: "connectionName"),
               (kind: ConstantSegment, value: "/listConsentLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionsListConsentLinks_594030(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists consent links of a connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  ##   connectionName: JString (required)
  ##                 : The connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594032 = path.getOrDefault("resourceGroupName")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "resourceGroupName", valid_594032
  var valid_594033 = path.getOrDefault("subscriptionId")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "subscriptionId", valid_594033
  var valid_594034 = path.getOrDefault("connectionName")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "connectionName", valid_594034
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594035 = query.getOrDefault("api-version")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "api-version", valid_594035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   content: JObject (required)
  ##          : The content.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594037: Call_ConnectionsListConsentLinks_594029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists consent links of a connection.
  ## 
  let valid = call_594037.validator(path, query, header, formData, body)
  let scheme = call_594037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594037.url(scheme.get, call_594037.host, call_594037.base,
                         call_594037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594037, url, valid)

proc call*(call_594038: Call_ConnectionsListConsentLinks_594029;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          content: JsonNode; connectionName: string): Recallable =
  ## connectionsListConsentLinks
  ## Lists consent links of a connection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   content: JObject (required)
  ##          : The content.
  ##   connectionName: string (required)
  ##                 : The connection name.
  var path_594039 = newJObject()
  var query_594040 = newJObject()
  var body_594041 = newJObject()
  add(path_594039, "resourceGroupName", newJString(resourceGroupName))
  add(query_594040, "api-version", newJString(apiVersion))
  add(path_594039, "subscriptionId", newJString(subscriptionId))
  if content != nil:
    body_594041 = content
  add(path_594039, "connectionName", newJString(connectionName))
  result = call_594038.call(path_594039, query_594040, nil, nil, body_594041)

var connectionsListConsentLinks* = Call_ConnectionsListConsentLinks_594029(
    name: "connectionsListConsentLinks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/connections/{connectionName}/listConsentLinks",
    validator: validate_ConnectionsListConsentLinks_594030, base: "",
    url: url_ConnectionsListConsentLinks_594031, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
