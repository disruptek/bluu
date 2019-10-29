
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: StorSimple8000SeriesManagementClient
## version: 2017-06-01
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

  OpenApiRestCall_563565 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563565](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563565): Option[Scheme] {.used.} =
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
  macServiceName = "storsimple8000series-storsimple"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563787 = ref object of OpenApiRestCall_563565
proc url_OperationsList_563789(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563788(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available REST API operations of the Microsoft.StorSimple provider
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563950 = query.getOrDefault("api-version")
  valid_563950 = validateParameter(valid_563950, JString, required = true,
                                 default = nil)
  if valid_563950 != nil:
    section.add "api-version", valid_563950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563973: Call_OperationsList_563787; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available REST API operations of the Microsoft.StorSimple provider
  ## 
  let valid = call_563973.validator(path, query, header, formData, body)
  let scheme = call_563973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563973.url(scheme.get, call_563973.host, call_563973.base,
                         call_563973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563973, url, valid)

proc call*(call_564044: Call_OperationsList_563787; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available REST API operations of the Microsoft.StorSimple provider
  ##   apiVersion: string (required)
  ##             : The api version
  var query_564045 = newJObject()
  add(query_564045, "api-version", newJString(apiVersion))
  result = call_564044.call(nil, query_564045, nil, nil, nil)

var operationsList* = Call_OperationsList_563787(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.StorSimple/operations",
    validator: validate_OperationsList_563788, base: "", url: url_OperationsList_563789,
    schemes: {Scheme.Https})
type
  Call_ManagersList_564085 = ref object of OpenApiRestCall_563565
proc url_ManagersList_564087(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersList_564086(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the managers in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564102 = path.getOrDefault("subscriptionId")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "subscriptionId", valid_564102
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564103 = query.getOrDefault("api-version")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "api-version", valid_564103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564104: Call_ManagersList_564085; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the managers in a subscription.
  ## 
  let valid = call_564104.validator(path, query, header, formData, body)
  let scheme = call_564104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564104.url(scheme.get, call_564104.host, call_564104.base,
                         call_564104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564104, url, valid)

proc call*(call_564105: Call_ManagersList_564085; apiVersion: string;
          subscriptionId: string): Recallable =
  ## managersList
  ## Retrieves all the managers in a subscription.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_564106 = newJObject()
  var query_564107 = newJObject()
  add(query_564107, "api-version", newJString(apiVersion))
  add(path_564106, "subscriptionId", newJString(subscriptionId))
  result = call_564105.call(path_564106, query_564107, nil, nil, nil)

var managersList* = Call_ManagersList_564085(name: "managersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.StorSimple/managers",
    validator: validate_ManagersList_564086, base: "", url: url_ManagersList_564087,
    schemes: {Scheme.Https})
type
  Call_ManagersListByResourceGroup_564108 = ref object of OpenApiRestCall_563565
proc url_ManagersListByResourceGroup_564110(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersListByResourceGroup_564109(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the managers in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564111 = path.getOrDefault("subscriptionId")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "subscriptionId", valid_564111
  var valid_564112 = path.getOrDefault("resourceGroupName")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "resourceGroupName", valid_564112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564113 = query.getOrDefault("api-version")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "api-version", valid_564113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564114: Call_ManagersListByResourceGroup_564108; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the managers in a resource group.
  ## 
  let valid = call_564114.validator(path, query, header, formData, body)
  let scheme = call_564114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564114.url(scheme.get, call_564114.host, call_564114.base,
                         call_564114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564114, url, valid)

proc call*(call_564115: Call_ManagersListByResourceGroup_564108;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## managersListByResourceGroup
  ## Retrieves all the managers in a resource group.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  var path_564116 = newJObject()
  var query_564117 = newJObject()
  add(query_564117, "api-version", newJString(apiVersion))
  add(path_564116, "subscriptionId", newJString(subscriptionId))
  add(path_564116, "resourceGroupName", newJString(resourceGroupName))
  result = call_564115.call(path_564116, query_564117, nil, nil, nil)

var managersListByResourceGroup* = Call_ManagersListByResourceGroup_564108(
    name: "managersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers",
    validator: validate_ManagersListByResourceGroup_564109, base: "",
    url: url_ManagersListByResourceGroup_564110, schemes: {Scheme.Https})
type
  Call_ManagersCreateOrUpdate_564129 = ref object of OpenApiRestCall_563565
proc url_ManagersCreateOrUpdate_564131(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersCreateOrUpdate_564130(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564132 = path.getOrDefault("subscriptionId")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "subscriptionId", valid_564132
  var valid_564133 = path.getOrDefault("resourceGroupName")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "resourceGroupName", valid_564133
  var valid_564134 = path.getOrDefault("managerName")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "managerName", valid_564134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564135 = query.getOrDefault("api-version")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "api-version", valid_564135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The manager.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564137: Call_ManagersCreateOrUpdate_564129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the manager.
  ## 
  let valid = call_564137.validator(path, query, header, formData, body)
  let scheme = call_564137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564137.url(scheme.get, call_564137.host, call_564137.base,
                         call_564137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564137, url, valid)

proc call*(call_564138: Call_ManagersCreateOrUpdate_564129; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string;
          parameters: JsonNode): Recallable =
  ## managersCreateOrUpdate
  ## Creates or updates the manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : The manager.
  var path_564139 = newJObject()
  var query_564140 = newJObject()
  var body_564141 = newJObject()
  add(query_564140, "api-version", newJString(apiVersion))
  add(path_564139, "subscriptionId", newJString(subscriptionId))
  add(path_564139, "resourceGroupName", newJString(resourceGroupName))
  add(path_564139, "managerName", newJString(managerName))
  if parameters != nil:
    body_564141 = parameters
  result = call_564138.call(path_564139, query_564140, nil, nil, body_564141)

var managersCreateOrUpdate* = Call_ManagersCreateOrUpdate_564129(
    name: "managersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}",
    validator: validate_ManagersCreateOrUpdate_564130, base: "",
    url: url_ManagersCreateOrUpdate_564131, schemes: {Scheme.Https})
type
  Call_ManagersGet_564118 = ref object of OpenApiRestCall_563565
proc url_ManagersGet_564120(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersGet_564119(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified manager name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564121 = path.getOrDefault("subscriptionId")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "subscriptionId", valid_564121
  var valid_564122 = path.getOrDefault("resourceGroupName")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "resourceGroupName", valid_564122
  var valid_564123 = path.getOrDefault("managerName")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "managerName", valid_564123
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564124 = query.getOrDefault("api-version")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "api-version", valid_564124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564125: Call_ManagersGet_564118; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified manager name.
  ## 
  let valid = call_564125.validator(path, query, header, formData, body)
  let scheme = call_564125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564125.url(scheme.get, call_564125.host, call_564125.base,
                         call_564125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564125, url, valid)

proc call*(call_564126: Call_ManagersGet_564118; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string): Recallable =
  ## managersGet
  ## Returns the properties of the specified manager name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564127 = newJObject()
  var query_564128 = newJObject()
  add(query_564128, "api-version", newJString(apiVersion))
  add(path_564127, "subscriptionId", newJString(subscriptionId))
  add(path_564127, "resourceGroupName", newJString(resourceGroupName))
  add(path_564127, "managerName", newJString(managerName))
  result = call_564126.call(path_564127, query_564128, nil, nil, nil)

var managersGet* = Call_ManagersGet_564118(name: "managersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}",
                                        validator: validate_ManagersGet_564119,
                                        base: "", url: url_ManagersGet_564120,
                                        schemes: {Scheme.Https})
type
  Call_ManagersUpdate_564153 = ref object of OpenApiRestCall_563565
proc url_ManagersUpdate_564155(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersUpdate_564154(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates the StorSimple Manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564156 = path.getOrDefault("subscriptionId")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "subscriptionId", valid_564156
  var valid_564157 = path.getOrDefault("resourceGroupName")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "resourceGroupName", valid_564157
  var valid_564158 = path.getOrDefault("managerName")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "managerName", valid_564158
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564159 = query.getOrDefault("api-version")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "api-version", valid_564159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The manager update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564161: Call_ManagersUpdate_564153; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the StorSimple Manager.
  ## 
  let valid = call_564161.validator(path, query, header, formData, body)
  let scheme = call_564161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564161.url(scheme.get, call_564161.host, call_564161.base,
                         call_564161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564161, url, valid)

proc call*(call_564162: Call_ManagersUpdate_564153; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string;
          parameters: JsonNode): Recallable =
  ## managersUpdate
  ## Updates the StorSimple Manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : The manager update parameters.
  var path_564163 = newJObject()
  var query_564164 = newJObject()
  var body_564165 = newJObject()
  add(query_564164, "api-version", newJString(apiVersion))
  add(path_564163, "subscriptionId", newJString(subscriptionId))
  add(path_564163, "resourceGroupName", newJString(resourceGroupName))
  add(path_564163, "managerName", newJString(managerName))
  if parameters != nil:
    body_564165 = parameters
  result = call_564162.call(path_564163, query_564164, nil, nil, body_564165)

var managersUpdate* = Call_ManagersUpdate_564153(name: "managersUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}",
    validator: validate_ManagersUpdate_564154, base: "", url: url_ManagersUpdate_564155,
    schemes: {Scheme.Https})
type
  Call_ManagersDelete_564142 = ref object of OpenApiRestCall_563565
proc url_ManagersDelete_564144(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersDelete_564143(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes the manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564145 = path.getOrDefault("subscriptionId")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "subscriptionId", valid_564145
  var valid_564146 = path.getOrDefault("resourceGroupName")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "resourceGroupName", valid_564146
  var valid_564147 = path.getOrDefault("managerName")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "managerName", valid_564147
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564148 = query.getOrDefault("api-version")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "api-version", valid_564148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564149: Call_ManagersDelete_564142; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the manager.
  ## 
  let valid = call_564149.validator(path, query, header, formData, body)
  let scheme = call_564149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564149.url(scheme.get, call_564149.host, call_564149.base,
                         call_564149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564149, url, valid)

proc call*(call_564150: Call_ManagersDelete_564142; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string): Recallable =
  ## managersDelete
  ## Deletes the manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564151 = newJObject()
  var query_564152 = newJObject()
  add(query_564152, "api-version", newJString(apiVersion))
  add(path_564151, "subscriptionId", newJString(subscriptionId))
  add(path_564151, "resourceGroupName", newJString(resourceGroupName))
  add(path_564151, "managerName", newJString(managerName))
  result = call_564150.call(path_564151, query_564152, nil, nil, nil)

var managersDelete* = Call_ManagersDelete_564142(name: "managersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}",
    validator: validate_ManagersDelete_564143, base: "", url: url_ManagersDelete_564144,
    schemes: {Scheme.Https})
type
  Call_AccessControlRecordsListByManager_564166 = ref object of OpenApiRestCall_563565
proc url_AccessControlRecordsListByManager_564168(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/accessControlRecords")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccessControlRecordsListByManager_564167(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the access control records in a manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564169 = path.getOrDefault("subscriptionId")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "subscriptionId", valid_564169
  var valid_564170 = path.getOrDefault("resourceGroupName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "resourceGroupName", valid_564170
  var valid_564171 = path.getOrDefault("managerName")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "managerName", valid_564171
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564172 = query.getOrDefault("api-version")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "api-version", valid_564172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564173: Call_AccessControlRecordsListByManager_564166;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all the access control records in a manager.
  ## 
  let valid = call_564173.validator(path, query, header, formData, body)
  let scheme = call_564173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564173.url(scheme.get, call_564173.host, call_564173.base,
                         call_564173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564173, url, valid)

proc call*(call_564174: Call_AccessControlRecordsListByManager_564166;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## accessControlRecordsListByManager
  ## Retrieves all the access control records in a manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564175 = newJObject()
  var query_564176 = newJObject()
  add(query_564176, "api-version", newJString(apiVersion))
  add(path_564175, "subscriptionId", newJString(subscriptionId))
  add(path_564175, "resourceGroupName", newJString(resourceGroupName))
  add(path_564175, "managerName", newJString(managerName))
  result = call_564174.call(path_564175, query_564176, nil, nil, nil)

var accessControlRecordsListByManager* = Call_AccessControlRecordsListByManager_564166(
    name: "accessControlRecordsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/accessControlRecords",
    validator: validate_AccessControlRecordsListByManager_564167, base: "",
    url: url_AccessControlRecordsListByManager_564168, schemes: {Scheme.Https})
type
  Call_AccessControlRecordsCreateOrUpdate_564189 = ref object of OpenApiRestCall_563565
proc url_AccessControlRecordsCreateOrUpdate_564191(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "accessControlRecordName" in path,
        "`accessControlRecordName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/accessControlRecords/"),
               (kind: VariableSegment, value: "accessControlRecordName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccessControlRecordsCreateOrUpdate_564190(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates an access control record.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   accessControlRecordName: JString (required)
  ##                          : The name of the access control record.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564192 = path.getOrDefault("subscriptionId")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "subscriptionId", valid_564192
  var valid_564193 = path.getOrDefault("accessControlRecordName")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "accessControlRecordName", valid_564193
  var valid_564194 = path.getOrDefault("resourceGroupName")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "resourceGroupName", valid_564194
  var valid_564195 = path.getOrDefault("managerName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "managerName", valid_564195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564196 = query.getOrDefault("api-version")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "api-version", valid_564196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The access control record to be added or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564198: Call_AccessControlRecordsCreateOrUpdate_564189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or Updates an access control record.
  ## 
  let valid = call_564198.validator(path, query, header, formData, body)
  let scheme = call_564198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564198.url(scheme.get, call_564198.host, call_564198.base,
                         call_564198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564198, url, valid)

proc call*(call_564199: Call_AccessControlRecordsCreateOrUpdate_564189;
          apiVersion: string; subscriptionId: string;
          accessControlRecordName: string; resourceGroupName: string;
          managerName: string; parameters: JsonNode): Recallable =
  ## accessControlRecordsCreateOrUpdate
  ## Creates or Updates an access control record.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   accessControlRecordName: string (required)
  ##                          : The name of the access control record.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : The access control record to be added or updated.
  var path_564200 = newJObject()
  var query_564201 = newJObject()
  var body_564202 = newJObject()
  add(query_564201, "api-version", newJString(apiVersion))
  add(path_564200, "subscriptionId", newJString(subscriptionId))
  add(path_564200, "accessControlRecordName", newJString(accessControlRecordName))
  add(path_564200, "resourceGroupName", newJString(resourceGroupName))
  add(path_564200, "managerName", newJString(managerName))
  if parameters != nil:
    body_564202 = parameters
  result = call_564199.call(path_564200, query_564201, nil, nil, body_564202)

var accessControlRecordsCreateOrUpdate* = Call_AccessControlRecordsCreateOrUpdate_564189(
    name: "accessControlRecordsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/accessControlRecords/{accessControlRecordName}",
    validator: validate_AccessControlRecordsCreateOrUpdate_564190, base: "",
    url: url_AccessControlRecordsCreateOrUpdate_564191, schemes: {Scheme.Https})
type
  Call_AccessControlRecordsGet_564177 = ref object of OpenApiRestCall_563565
proc url_AccessControlRecordsGet_564179(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "accessControlRecordName" in path,
        "`accessControlRecordName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/accessControlRecords/"),
               (kind: VariableSegment, value: "accessControlRecordName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccessControlRecordsGet_564178(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified access control record name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   accessControlRecordName: JString (required)
  ##                          : Name of access control record to be fetched.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564180 = path.getOrDefault("subscriptionId")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "subscriptionId", valid_564180
  var valid_564181 = path.getOrDefault("accessControlRecordName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "accessControlRecordName", valid_564181
  var valid_564182 = path.getOrDefault("resourceGroupName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "resourceGroupName", valid_564182
  var valid_564183 = path.getOrDefault("managerName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "managerName", valid_564183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564184 = query.getOrDefault("api-version")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "api-version", valid_564184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564185: Call_AccessControlRecordsGet_564177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified access control record name.
  ## 
  let valid = call_564185.validator(path, query, header, formData, body)
  let scheme = call_564185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564185.url(scheme.get, call_564185.host, call_564185.base,
                         call_564185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564185, url, valid)

proc call*(call_564186: Call_AccessControlRecordsGet_564177; apiVersion: string;
          subscriptionId: string; accessControlRecordName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## accessControlRecordsGet
  ## Returns the properties of the specified access control record name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   accessControlRecordName: string (required)
  ##                          : Name of access control record to be fetched.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564187 = newJObject()
  var query_564188 = newJObject()
  add(query_564188, "api-version", newJString(apiVersion))
  add(path_564187, "subscriptionId", newJString(subscriptionId))
  add(path_564187, "accessControlRecordName", newJString(accessControlRecordName))
  add(path_564187, "resourceGroupName", newJString(resourceGroupName))
  add(path_564187, "managerName", newJString(managerName))
  result = call_564186.call(path_564187, query_564188, nil, nil, nil)

var accessControlRecordsGet* = Call_AccessControlRecordsGet_564177(
    name: "accessControlRecordsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/accessControlRecords/{accessControlRecordName}",
    validator: validate_AccessControlRecordsGet_564178, base: "",
    url: url_AccessControlRecordsGet_564179, schemes: {Scheme.Https})
type
  Call_AccessControlRecordsDelete_564203 = ref object of OpenApiRestCall_563565
proc url_AccessControlRecordsDelete_564205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "accessControlRecordName" in path,
        "`accessControlRecordName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/accessControlRecords/"),
               (kind: VariableSegment, value: "accessControlRecordName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccessControlRecordsDelete_564204(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the access control record.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   accessControlRecordName: JString (required)
  ##                          : The name of the access control record to delete.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564206 = path.getOrDefault("subscriptionId")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "subscriptionId", valid_564206
  var valid_564207 = path.getOrDefault("accessControlRecordName")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "accessControlRecordName", valid_564207
  var valid_564208 = path.getOrDefault("resourceGroupName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "resourceGroupName", valid_564208
  var valid_564209 = path.getOrDefault("managerName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "managerName", valid_564209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564210 = query.getOrDefault("api-version")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "api-version", valid_564210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564211: Call_AccessControlRecordsDelete_564203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the access control record.
  ## 
  let valid = call_564211.validator(path, query, header, formData, body)
  let scheme = call_564211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564211.url(scheme.get, call_564211.host, call_564211.base,
                         call_564211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564211, url, valid)

proc call*(call_564212: Call_AccessControlRecordsDelete_564203; apiVersion: string;
          subscriptionId: string; accessControlRecordName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## accessControlRecordsDelete
  ## Deletes the access control record.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   accessControlRecordName: string (required)
  ##                          : The name of the access control record to delete.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564213 = newJObject()
  var query_564214 = newJObject()
  add(query_564214, "api-version", newJString(apiVersion))
  add(path_564213, "subscriptionId", newJString(subscriptionId))
  add(path_564213, "accessControlRecordName", newJString(accessControlRecordName))
  add(path_564213, "resourceGroupName", newJString(resourceGroupName))
  add(path_564213, "managerName", newJString(managerName))
  result = call_564212.call(path_564213, query_564214, nil, nil, nil)

var accessControlRecordsDelete* = Call_AccessControlRecordsDelete_564203(
    name: "accessControlRecordsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/accessControlRecords/{accessControlRecordName}",
    validator: validate_AccessControlRecordsDelete_564204, base: "",
    url: url_AccessControlRecordsDelete_564205, schemes: {Scheme.Https})
type
  Call_AlertsListByManager_564215 = ref object of OpenApiRestCall_563565
proc url_AlertsListByManager_564217(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsListByManager_564216(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves all the alerts in a manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564219 = path.getOrDefault("subscriptionId")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "subscriptionId", valid_564219
  var valid_564220 = path.getOrDefault("resourceGroupName")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "resourceGroupName", valid_564220
  var valid_564221 = path.getOrDefault("managerName")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "managerName", valid_564221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564222 = query.getOrDefault("api-version")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "api-version", valid_564222
  var valid_564223 = query.getOrDefault("$filter")
  valid_564223 = validateParameter(valid_564223, JString, required = false,
                                 default = nil)
  if valid_564223 != nil:
    section.add "$filter", valid_564223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564224: Call_AlertsListByManager_564215; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the alerts in a manager.
  ## 
  let valid = call_564224.validator(path, query, header, formData, body)
  let scheme = call_564224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564224.url(scheme.get, call_564224.host, call_564224.base,
                         call_564224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564224, url, valid)

proc call*(call_564225: Call_AlertsListByManager_564215; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string;
          Filter: string = ""): Recallable =
  ## alertsListByManager
  ## Retrieves all the alerts in a manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   Filter: string
  ##         : OData Filter options
  var path_564226 = newJObject()
  var query_564227 = newJObject()
  add(query_564227, "api-version", newJString(apiVersion))
  add(path_564226, "subscriptionId", newJString(subscriptionId))
  add(path_564226, "resourceGroupName", newJString(resourceGroupName))
  add(path_564226, "managerName", newJString(managerName))
  add(query_564227, "$filter", newJString(Filter))
  result = call_564225.call(path_564226, query_564227, nil, nil, nil)

var alertsListByManager* = Call_AlertsListByManager_564215(
    name: "alertsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/alerts",
    validator: validate_AlertsListByManager_564216, base: "",
    url: url_AlertsListByManager_564217, schemes: {Scheme.Https})
type
  Call_BandwidthSettingsListByManager_564228 = ref object of OpenApiRestCall_563565
proc url_BandwidthSettingsListByManager_564230(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/bandwidthSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BandwidthSettingsListByManager_564229(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the bandwidth setting in a manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564231 = path.getOrDefault("subscriptionId")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "subscriptionId", valid_564231
  var valid_564232 = path.getOrDefault("resourceGroupName")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "resourceGroupName", valid_564232
  var valid_564233 = path.getOrDefault("managerName")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "managerName", valid_564233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564234 = query.getOrDefault("api-version")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "api-version", valid_564234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564235: Call_BandwidthSettingsListByManager_564228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the bandwidth setting in a manager.
  ## 
  let valid = call_564235.validator(path, query, header, formData, body)
  let scheme = call_564235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564235.url(scheme.get, call_564235.host, call_564235.base,
                         call_564235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564235, url, valid)

proc call*(call_564236: Call_BandwidthSettingsListByManager_564228;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## bandwidthSettingsListByManager
  ## Retrieves all the bandwidth setting in a manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564237 = newJObject()
  var query_564238 = newJObject()
  add(query_564238, "api-version", newJString(apiVersion))
  add(path_564237, "subscriptionId", newJString(subscriptionId))
  add(path_564237, "resourceGroupName", newJString(resourceGroupName))
  add(path_564237, "managerName", newJString(managerName))
  result = call_564236.call(path_564237, query_564238, nil, nil, nil)

var bandwidthSettingsListByManager* = Call_BandwidthSettingsListByManager_564228(
    name: "bandwidthSettingsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/bandwidthSettings",
    validator: validate_BandwidthSettingsListByManager_564229, base: "",
    url: url_BandwidthSettingsListByManager_564230, schemes: {Scheme.Https})
type
  Call_BandwidthSettingsCreateOrUpdate_564251 = ref object of OpenApiRestCall_563565
proc url_BandwidthSettingsCreateOrUpdate_564253(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "bandwidthSettingName" in path,
        "`bandwidthSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/bandwidthSettings/"),
               (kind: VariableSegment, value: "bandwidthSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BandwidthSettingsCreateOrUpdate_564252(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the bandwidth setting
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bandwidthSettingName: JString (required)
  ##                       : The bandwidth setting name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bandwidthSettingName` field"
  var valid_564254 = path.getOrDefault("bandwidthSettingName")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "bandwidthSettingName", valid_564254
  var valid_564255 = path.getOrDefault("subscriptionId")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "subscriptionId", valid_564255
  var valid_564256 = path.getOrDefault("resourceGroupName")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "resourceGroupName", valid_564256
  var valid_564257 = path.getOrDefault("managerName")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "managerName", valid_564257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564258 = query.getOrDefault("api-version")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "api-version", valid_564258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The bandwidth setting to be added or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564260: Call_BandwidthSettingsCreateOrUpdate_564251;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the bandwidth setting
  ## 
  let valid = call_564260.validator(path, query, header, formData, body)
  let scheme = call_564260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564260.url(scheme.get, call_564260.host, call_564260.base,
                         call_564260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564260, url, valid)

proc call*(call_564261: Call_BandwidthSettingsCreateOrUpdate_564251;
          bandwidthSettingName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; managerName: string; parameters: JsonNode): Recallable =
  ## bandwidthSettingsCreateOrUpdate
  ## Creates or updates the bandwidth setting
  ##   bandwidthSettingName: string (required)
  ##                       : The bandwidth setting name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : The bandwidth setting to be added or updated.
  var path_564262 = newJObject()
  var query_564263 = newJObject()
  var body_564264 = newJObject()
  add(path_564262, "bandwidthSettingName", newJString(bandwidthSettingName))
  add(query_564263, "api-version", newJString(apiVersion))
  add(path_564262, "subscriptionId", newJString(subscriptionId))
  add(path_564262, "resourceGroupName", newJString(resourceGroupName))
  add(path_564262, "managerName", newJString(managerName))
  if parameters != nil:
    body_564264 = parameters
  result = call_564261.call(path_564262, query_564263, nil, nil, body_564264)

var bandwidthSettingsCreateOrUpdate* = Call_BandwidthSettingsCreateOrUpdate_564251(
    name: "bandwidthSettingsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/bandwidthSettings/{bandwidthSettingName}",
    validator: validate_BandwidthSettingsCreateOrUpdate_564252, base: "",
    url: url_BandwidthSettingsCreateOrUpdate_564253, schemes: {Scheme.Https})
type
  Call_BandwidthSettingsGet_564239 = ref object of OpenApiRestCall_563565
proc url_BandwidthSettingsGet_564241(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "bandwidthSettingName" in path,
        "`bandwidthSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/bandwidthSettings/"),
               (kind: VariableSegment, value: "bandwidthSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BandwidthSettingsGet_564240(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified bandwidth setting name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bandwidthSettingName: JString (required)
  ##                       : The name of bandwidth setting to be fetched.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bandwidthSettingName` field"
  var valid_564242 = path.getOrDefault("bandwidthSettingName")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "bandwidthSettingName", valid_564242
  var valid_564243 = path.getOrDefault("subscriptionId")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "subscriptionId", valid_564243
  var valid_564244 = path.getOrDefault("resourceGroupName")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "resourceGroupName", valid_564244
  var valid_564245 = path.getOrDefault("managerName")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "managerName", valid_564245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564246 = query.getOrDefault("api-version")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "api-version", valid_564246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564247: Call_BandwidthSettingsGet_564239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified bandwidth setting name.
  ## 
  let valid = call_564247.validator(path, query, header, formData, body)
  let scheme = call_564247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564247.url(scheme.get, call_564247.host, call_564247.base,
                         call_564247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564247, url, valid)

proc call*(call_564248: Call_BandwidthSettingsGet_564239;
          bandwidthSettingName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## bandwidthSettingsGet
  ## Returns the properties of the specified bandwidth setting name.
  ##   bandwidthSettingName: string (required)
  ##                       : The name of bandwidth setting to be fetched.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564249 = newJObject()
  var query_564250 = newJObject()
  add(path_564249, "bandwidthSettingName", newJString(bandwidthSettingName))
  add(query_564250, "api-version", newJString(apiVersion))
  add(path_564249, "subscriptionId", newJString(subscriptionId))
  add(path_564249, "resourceGroupName", newJString(resourceGroupName))
  add(path_564249, "managerName", newJString(managerName))
  result = call_564248.call(path_564249, query_564250, nil, nil, nil)

var bandwidthSettingsGet* = Call_BandwidthSettingsGet_564239(
    name: "bandwidthSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/bandwidthSettings/{bandwidthSettingName}",
    validator: validate_BandwidthSettingsGet_564240, base: "",
    url: url_BandwidthSettingsGet_564241, schemes: {Scheme.Https})
type
  Call_BandwidthSettingsDelete_564265 = ref object of OpenApiRestCall_563565
proc url_BandwidthSettingsDelete_564267(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "bandwidthSettingName" in path,
        "`bandwidthSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/bandwidthSettings/"),
               (kind: VariableSegment, value: "bandwidthSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BandwidthSettingsDelete_564266(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the bandwidth setting
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bandwidthSettingName: JString (required)
  ##                       : The name of the bandwidth setting.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bandwidthSettingName` field"
  var valid_564268 = path.getOrDefault("bandwidthSettingName")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "bandwidthSettingName", valid_564268
  var valid_564269 = path.getOrDefault("subscriptionId")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "subscriptionId", valid_564269
  var valid_564270 = path.getOrDefault("resourceGroupName")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "resourceGroupName", valid_564270
  var valid_564271 = path.getOrDefault("managerName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "managerName", valid_564271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564272 = query.getOrDefault("api-version")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "api-version", valid_564272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564273: Call_BandwidthSettingsDelete_564265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the bandwidth setting
  ## 
  let valid = call_564273.validator(path, query, header, formData, body)
  let scheme = call_564273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564273.url(scheme.get, call_564273.host, call_564273.base,
                         call_564273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564273, url, valid)

proc call*(call_564274: Call_BandwidthSettingsDelete_564265;
          bandwidthSettingName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## bandwidthSettingsDelete
  ## Deletes the bandwidth setting
  ##   bandwidthSettingName: string (required)
  ##                       : The name of the bandwidth setting.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564275 = newJObject()
  var query_564276 = newJObject()
  add(path_564275, "bandwidthSettingName", newJString(bandwidthSettingName))
  add(query_564276, "api-version", newJString(apiVersion))
  add(path_564275, "subscriptionId", newJString(subscriptionId))
  add(path_564275, "resourceGroupName", newJString(resourceGroupName))
  add(path_564275, "managerName", newJString(managerName))
  result = call_564274.call(path_564275, query_564276, nil, nil, nil)

var bandwidthSettingsDelete* = Call_BandwidthSettingsDelete_564265(
    name: "bandwidthSettingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/bandwidthSettings/{bandwidthSettingName}",
    validator: validate_BandwidthSettingsDelete_564266, base: "",
    url: url_BandwidthSettingsDelete_564267, schemes: {Scheme.Https})
type
  Call_AlertsClear_564277 = ref object of OpenApiRestCall_563565
proc url_AlertsClear_564279(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/clearAlerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsClear_564278(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Clear the alerts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564280 = path.getOrDefault("subscriptionId")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "subscriptionId", valid_564280
  var valid_564281 = path.getOrDefault("resourceGroupName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "resourceGroupName", valid_564281
  var valid_564282 = path.getOrDefault("managerName")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "managerName", valid_564282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564283 = query.getOrDefault("api-version")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "api-version", valid_564283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The clear alert request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564285: Call_AlertsClear_564277; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clear the alerts.
  ## 
  let valid = call_564285.validator(path, query, header, formData, body)
  let scheme = call_564285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564285.url(scheme.get, call_564285.host, call_564285.base,
                         call_564285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564285, url, valid)

proc call*(call_564286: Call_AlertsClear_564277; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string;
          parameters: JsonNode): Recallable =
  ## alertsClear
  ## Clear the alerts.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : The clear alert request.
  var path_564287 = newJObject()
  var query_564288 = newJObject()
  var body_564289 = newJObject()
  add(query_564288, "api-version", newJString(apiVersion))
  add(path_564287, "subscriptionId", newJString(subscriptionId))
  add(path_564287, "resourceGroupName", newJString(resourceGroupName))
  add(path_564287, "managerName", newJString(managerName))
  if parameters != nil:
    body_564289 = parameters
  result = call_564286.call(path_564287, query_564288, nil, nil, body_564289)

var alertsClear* = Call_AlertsClear_564277(name: "alertsClear",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/clearAlerts",
                                        validator: validate_AlertsClear_564278,
                                        base: "", url: url_AlertsClear_564279,
                                        schemes: {Scheme.Https})
type
  Call_CloudAppliancesListSupportedConfigurations_564290 = ref object of OpenApiRestCall_563565
proc url_CloudAppliancesListSupportedConfigurations_564292(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/cloudApplianceConfigurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudAppliancesListSupportedConfigurations_564291(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists supported cloud appliance models and supported configurations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564293 = path.getOrDefault("subscriptionId")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "subscriptionId", valid_564293
  var valid_564294 = path.getOrDefault("resourceGroupName")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "resourceGroupName", valid_564294
  var valid_564295 = path.getOrDefault("managerName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "managerName", valid_564295
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564296 = query.getOrDefault("api-version")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "api-version", valid_564296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564297: Call_CloudAppliancesListSupportedConfigurations_564290;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists supported cloud appliance models and supported configurations.
  ## 
  let valid = call_564297.validator(path, query, header, formData, body)
  let scheme = call_564297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564297.url(scheme.get, call_564297.host, call_564297.base,
                         call_564297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564297, url, valid)

proc call*(call_564298: Call_CloudAppliancesListSupportedConfigurations_564290;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## cloudAppliancesListSupportedConfigurations
  ## Lists supported cloud appliance models and supported configurations.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564299 = newJObject()
  var query_564300 = newJObject()
  add(query_564300, "api-version", newJString(apiVersion))
  add(path_564299, "subscriptionId", newJString(subscriptionId))
  add(path_564299, "resourceGroupName", newJString(resourceGroupName))
  add(path_564299, "managerName", newJString(managerName))
  result = call_564298.call(path_564299, query_564300, nil, nil, nil)

var cloudAppliancesListSupportedConfigurations* = Call_CloudAppliancesListSupportedConfigurations_564290(
    name: "cloudAppliancesListSupportedConfigurations", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/cloudApplianceConfigurations",
    validator: validate_CloudAppliancesListSupportedConfigurations_564291,
    base: "", url: url_CloudAppliancesListSupportedConfigurations_564292,
    schemes: {Scheme.Https})
type
  Call_DevicesConfigure_564301 = ref object of OpenApiRestCall_563565
proc url_DevicesConfigure_564303(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/configureDevice")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesConfigure_564302(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Complete minimal setup before using the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564304 = path.getOrDefault("subscriptionId")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "subscriptionId", valid_564304
  var valid_564305 = path.getOrDefault("resourceGroupName")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "resourceGroupName", valid_564305
  var valid_564306 = path.getOrDefault("managerName")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "managerName", valid_564306
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564307 = query.getOrDefault("api-version")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "api-version", valid_564307
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The minimal properties to configure a device.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564309: Call_DevicesConfigure_564301; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Complete minimal setup before using the device.
  ## 
  let valid = call_564309.validator(path, query, header, formData, body)
  let scheme = call_564309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564309.url(scheme.get, call_564309.host, call_564309.base,
                         call_564309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564309, url, valid)

proc call*(call_564310: Call_DevicesConfigure_564301; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string;
          parameters: JsonNode): Recallable =
  ## devicesConfigure
  ## Complete minimal setup before using the device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : The minimal properties to configure a device.
  var path_564311 = newJObject()
  var query_564312 = newJObject()
  var body_564313 = newJObject()
  add(query_564312, "api-version", newJString(apiVersion))
  add(path_564311, "subscriptionId", newJString(subscriptionId))
  add(path_564311, "resourceGroupName", newJString(resourceGroupName))
  add(path_564311, "managerName", newJString(managerName))
  if parameters != nil:
    body_564313 = parameters
  result = call_564310.call(path_564311, query_564312, nil, nil, body_564313)

var devicesConfigure* = Call_DevicesConfigure_564301(name: "devicesConfigure",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/configureDevice",
    validator: validate_DevicesConfigure_564302, base: "",
    url: url_DevicesConfigure_564303, schemes: {Scheme.Https})
type
  Call_DevicesListByManager_564314 = ref object of OpenApiRestCall_563565
proc url_DevicesListByManager_564316(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesListByManager_564315(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of devices for the specified manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564317 = path.getOrDefault("subscriptionId")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = nil)
  if valid_564317 != nil:
    section.add "subscriptionId", valid_564317
  var valid_564318 = path.getOrDefault("resourceGroupName")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "resourceGroupName", valid_564318
  var valid_564319 = path.getOrDefault("managerName")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "managerName", valid_564319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the device or $expand=rolloverdetails to populate additional fields related to the service data encryption key rollover on device
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564320 = query.getOrDefault("api-version")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "api-version", valid_564320
  var valid_564321 = query.getOrDefault("$expand")
  valid_564321 = validateParameter(valid_564321, JString, required = false,
                                 default = nil)
  if valid_564321 != nil:
    section.add "$expand", valid_564321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564322: Call_DevicesListByManager_564314; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of devices for the specified manager.
  ## 
  let valid = call_564322.validator(path, query, header, formData, body)
  let scheme = call_564322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564322.url(scheme.get, call_564322.host, call_564322.base,
                         call_564322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564322, url, valid)

proc call*(call_564323: Call_DevicesListByManager_564314; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string;
          Expand: string = ""): Recallable =
  ## devicesListByManager
  ## Returns the list of devices for the specified manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   Expand: string
  ##         : Specify $expand=details to populate additional fields related to the device or $expand=rolloverdetails to populate additional fields related to the service data encryption key rollover on device
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564324 = newJObject()
  var query_564325 = newJObject()
  add(query_564325, "api-version", newJString(apiVersion))
  add(query_564325, "$expand", newJString(Expand))
  add(path_564324, "subscriptionId", newJString(subscriptionId))
  add(path_564324, "resourceGroupName", newJString(resourceGroupName))
  add(path_564324, "managerName", newJString(managerName))
  result = call_564323.call(path_564324, query_564325, nil, nil, nil)

var devicesListByManager* = Call_DevicesListByManager_564314(
    name: "devicesListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices",
    validator: validate_DevicesListByManager_564315, base: "",
    url: url_DevicesListByManager_564316, schemes: {Scheme.Https})
type
  Call_DevicesGet_564326 = ref object of OpenApiRestCall_563565
proc url_DevicesGet_564328(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesGet_564327(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564329 = path.getOrDefault("subscriptionId")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "subscriptionId", valid_564329
  var valid_564330 = path.getOrDefault("deviceName")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "deviceName", valid_564330
  var valid_564331 = path.getOrDefault("resourceGroupName")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "resourceGroupName", valid_564331
  var valid_564332 = path.getOrDefault("managerName")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "managerName", valid_564332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the device or $expand=rolloverdetails to populate additional fields related to the service data encryption key rollover on device
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564333 = query.getOrDefault("api-version")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "api-version", valid_564333
  var valid_564334 = query.getOrDefault("$expand")
  valid_564334 = validateParameter(valid_564334, JString, required = false,
                                 default = nil)
  if valid_564334 != nil:
    section.add "$expand", valid_564334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564335: Call_DevicesGet_564326; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified device.
  ## 
  let valid = call_564335.validator(path, query, header, formData, body)
  let scheme = call_564335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564335.url(scheme.get, call_564335.host, call_564335.base,
                         call_564335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564335, url, valid)

proc call*(call_564336: Call_DevicesGet_564326; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; Expand: string = ""): Recallable =
  ## devicesGet
  ## Returns the properties of the specified device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   Expand: string
  ##         : Specify $expand=details to populate additional fields related to the device or $expand=rolloverdetails to populate additional fields related to the service data encryption key rollover on device
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564337 = newJObject()
  var query_564338 = newJObject()
  add(query_564338, "api-version", newJString(apiVersion))
  add(query_564338, "$expand", newJString(Expand))
  add(path_564337, "subscriptionId", newJString(subscriptionId))
  add(path_564337, "deviceName", newJString(deviceName))
  add(path_564337, "resourceGroupName", newJString(resourceGroupName))
  add(path_564337, "managerName", newJString(managerName))
  result = call_564336.call(path_564337, query_564338, nil, nil, nil)

var devicesGet* = Call_DevicesGet_564326(name: "devicesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}",
                                      validator: validate_DevicesGet_564327,
                                      base: "", url: url_DevicesGet_564328,
                                      schemes: {Scheme.Https})
type
  Call_DevicesUpdate_564351 = ref object of OpenApiRestCall_563565
proc url_DevicesUpdate_564353(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesUpdate_564352(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Patches the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564354 = path.getOrDefault("subscriptionId")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = nil)
  if valid_564354 != nil:
    section.add "subscriptionId", valid_564354
  var valid_564355 = path.getOrDefault("deviceName")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "deviceName", valid_564355
  var valid_564356 = path.getOrDefault("resourceGroupName")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "resourceGroupName", valid_564356
  var valid_564357 = path.getOrDefault("managerName")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "managerName", valid_564357
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Patch representation of the device.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564360: Call_DevicesUpdate_564351; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches the device.
  ## 
  let valid = call_564360.validator(path, query, header, formData, body)
  let scheme = call_564360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564360.url(scheme.get, call_564360.host, call_564360.base,
                         call_564360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564360, url, valid)

proc call*(call_564361: Call_DevicesUpdate_564351; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; parameters: JsonNode): Recallable =
  ## devicesUpdate
  ## Patches the device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : Patch representation of the device.
  var path_564362 = newJObject()
  var query_564363 = newJObject()
  var body_564364 = newJObject()
  add(query_564363, "api-version", newJString(apiVersion))
  add(path_564362, "subscriptionId", newJString(subscriptionId))
  add(path_564362, "deviceName", newJString(deviceName))
  add(path_564362, "resourceGroupName", newJString(resourceGroupName))
  add(path_564362, "managerName", newJString(managerName))
  if parameters != nil:
    body_564364 = parameters
  result = call_564361.call(path_564362, query_564363, nil, nil, body_564364)

var devicesUpdate* = Call_DevicesUpdate_564351(name: "devicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}",
    validator: validate_DevicesUpdate_564352, base: "", url: url_DevicesUpdate_564353,
    schemes: {Scheme.Https})
type
  Call_DevicesDelete_564339 = ref object of OpenApiRestCall_563565
proc url_DevicesDelete_564341(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesDelete_564340(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564342 = path.getOrDefault("subscriptionId")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "subscriptionId", valid_564342
  var valid_564343 = path.getOrDefault("deviceName")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "deviceName", valid_564343
  var valid_564344 = path.getOrDefault("resourceGroupName")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "resourceGroupName", valid_564344
  var valid_564345 = path.getOrDefault("managerName")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "managerName", valid_564345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564346 = query.getOrDefault("api-version")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "api-version", valid_564346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564347: Call_DevicesDelete_564339; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the device.
  ## 
  let valid = call_564347.validator(path, query, header, formData, body)
  let scheme = call_564347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564347.url(scheme.get, call_564347.host, call_564347.base,
                         call_564347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564347, url, valid)

proc call*(call_564348: Call_DevicesDelete_564339; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## devicesDelete
  ## Deletes the device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564349 = newJObject()
  var query_564350 = newJObject()
  add(query_564350, "api-version", newJString(apiVersion))
  add(path_564349, "subscriptionId", newJString(subscriptionId))
  add(path_564349, "deviceName", newJString(deviceName))
  add(path_564349, "resourceGroupName", newJString(resourceGroupName))
  add(path_564349, "managerName", newJString(managerName))
  result = call_564348.call(path_564349, query_564350, nil, nil, nil)

var devicesDelete* = Call_DevicesDelete_564339(name: "devicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}",
    validator: validate_DevicesDelete_564340, base: "", url: url_DevicesDelete_564341,
    schemes: {Scheme.Https})
type
  Call_DeviceSettingsCreateOrUpdateAlertSettings_564377 = ref object of OpenApiRestCall_563565
proc url_DeviceSettingsCreateOrUpdateAlertSettings_564379(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/alertSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSettingsCreateOrUpdateAlertSettings_564378(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the alert settings of the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564380 = path.getOrDefault("subscriptionId")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "subscriptionId", valid_564380
  var valid_564381 = path.getOrDefault("deviceName")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "deviceName", valid_564381
  var valid_564382 = path.getOrDefault("resourceGroupName")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "resourceGroupName", valid_564382
  var valid_564383 = path.getOrDefault("managerName")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "managerName", valid_564383
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564384 = query.getOrDefault("api-version")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "api-version", valid_564384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The alert settings to be added or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564386: Call_DeviceSettingsCreateOrUpdateAlertSettings_564377;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the alert settings of the specified device.
  ## 
  let valid = call_564386.validator(path, query, header, formData, body)
  let scheme = call_564386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564386.url(scheme.get, call_564386.host, call_564386.base,
                         call_564386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564386, url, valid)

proc call*(call_564387: Call_DeviceSettingsCreateOrUpdateAlertSettings_564377;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string; parameters: JsonNode): Recallable =
  ## deviceSettingsCreateOrUpdateAlertSettings
  ## Creates or updates the alert settings of the specified device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : The alert settings to be added or updated.
  var path_564388 = newJObject()
  var query_564389 = newJObject()
  var body_564390 = newJObject()
  add(query_564389, "api-version", newJString(apiVersion))
  add(path_564388, "subscriptionId", newJString(subscriptionId))
  add(path_564388, "deviceName", newJString(deviceName))
  add(path_564388, "resourceGroupName", newJString(resourceGroupName))
  add(path_564388, "managerName", newJString(managerName))
  if parameters != nil:
    body_564390 = parameters
  result = call_564387.call(path_564388, query_564389, nil, nil, body_564390)

var deviceSettingsCreateOrUpdateAlertSettings* = Call_DeviceSettingsCreateOrUpdateAlertSettings_564377(
    name: "deviceSettingsCreateOrUpdateAlertSettings", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/alertSettings/default",
    validator: validate_DeviceSettingsCreateOrUpdateAlertSettings_564378,
    base: "", url: url_DeviceSettingsCreateOrUpdateAlertSettings_564379,
    schemes: {Scheme.Https})
type
  Call_DeviceSettingsGetAlertSettings_564365 = ref object of OpenApiRestCall_563565
proc url_DeviceSettingsGetAlertSettings_564367(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/alertSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSettingsGetAlertSettings_564366(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the alert settings of the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564368 = path.getOrDefault("subscriptionId")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "subscriptionId", valid_564368
  var valid_564369 = path.getOrDefault("deviceName")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "deviceName", valid_564369
  var valid_564370 = path.getOrDefault("resourceGroupName")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "resourceGroupName", valid_564370
  var valid_564371 = path.getOrDefault("managerName")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "managerName", valid_564371
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564372 = query.getOrDefault("api-version")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "api-version", valid_564372
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564373: Call_DeviceSettingsGetAlertSettings_564365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert settings of the specified device.
  ## 
  let valid = call_564373.validator(path, query, header, formData, body)
  let scheme = call_564373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564373.url(scheme.get, call_564373.host, call_564373.base,
                         call_564373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564373, url, valid)

proc call*(call_564374: Call_DeviceSettingsGetAlertSettings_564365;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## deviceSettingsGetAlertSettings
  ## Gets the alert settings of the specified device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564375 = newJObject()
  var query_564376 = newJObject()
  add(query_564376, "api-version", newJString(apiVersion))
  add(path_564375, "subscriptionId", newJString(subscriptionId))
  add(path_564375, "deviceName", newJString(deviceName))
  add(path_564375, "resourceGroupName", newJString(resourceGroupName))
  add(path_564375, "managerName", newJString(managerName))
  result = call_564374.call(path_564375, query_564376, nil, nil, nil)

var deviceSettingsGetAlertSettings* = Call_DeviceSettingsGetAlertSettings_564365(
    name: "deviceSettingsGetAlertSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/alertSettings/default",
    validator: validate_DeviceSettingsGetAlertSettings_564366, base: "",
    url: url_DeviceSettingsGetAlertSettings_564367, schemes: {Scheme.Https})
type
  Call_DevicesAuthorizeForServiceEncryptionKeyRollover_564391 = ref object of OpenApiRestCall_563565
proc url_DevicesAuthorizeForServiceEncryptionKeyRollover_564393(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"), (kind: ConstantSegment,
        value: "/authorizeForServiceEncryptionKeyRollover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesAuthorizeForServiceEncryptionKeyRollover_564392(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Authorizes the specified device for service data encryption key rollover.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564394 = path.getOrDefault("subscriptionId")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "subscriptionId", valid_564394
  var valid_564395 = path.getOrDefault("deviceName")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "deviceName", valid_564395
  var valid_564396 = path.getOrDefault("resourceGroupName")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "resourceGroupName", valid_564396
  var valid_564397 = path.getOrDefault("managerName")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "managerName", valid_564397
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564398 = query.getOrDefault("api-version")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = nil)
  if valid_564398 != nil:
    section.add "api-version", valid_564398
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564399: Call_DevicesAuthorizeForServiceEncryptionKeyRollover_564391;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorizes the specified device for service data encryption key rollover.
  ## 
  let valid = call_564399.validator(path, query, header, formData, body)
  let scheme = call_564399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564399.url(scheme.get, call_564399.host, call_564399.base,
                         call_564399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564399, url, valid)

proc call*(call_564400: Call_DevicesAuthorizeForServiceEncryptionKeyRollover_564391;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## devicesAuthorizeForServiceEncryptionKeyRollover
  ## Authorizes the specified device for service data encryption key rollover.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564401 = newJObject()
  var query_564402 = newJObject()
  add(query_564402, "api-version", newJString(apiVersion))
  add(path_564401, "subscriptionId", newJString(subscriptionId))
  add(path_564401, "deviceName", newJString(deviceName))
  add(path_564401, "resourceGroupName", newJString(resourceGroupName))
  add(path_564401, "managerName", newJString(managerName))
  result = call_564400.call(path_564401, query_564402, nil, nil, nil)

var devicesAuthorizeForServiceEncryptionKeyRollover* = Call_DevicesAuthorizeForServiceEncryptionKeyRollover_564391(
    name: "devicesAuthorizeForServiceEncryptionKeyRollover",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/authorizeForServiceEncryptionKeyRollover",
    validator: validate_DevicesAuthorizeForServiceEncryptionKeyRollover_564392,
    base: "", url: url_DevicesAuthorizeForServiceEncryptionKeyRollover_564393,
    schemes: {Scheme.Https})
type
  Call_BackupPoliciesListByDevice_564403 = ref object of OpenApiRestCall_563565
proc url_BackupPoliciesListByDevice_564405(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupPoliciesListByDevice_564404(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the backup policies in a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564406 = path.getOrDefault("subscriptionId")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "subscriptionId", valid_564406
  var valid_564407 = path.getOrDefault("deviceName")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "deviceName", valid_564407
  var valid_564408 = path.getOrDefault("resourceGroupName")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = nil)
  if valid_564408 != nil:
    section.add "resourceGroupName", valid_564408
  var valid_564409 = path.getOrDefault("managerName")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "managerName", valid_564409
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564410 = query.getOrDefault("api-version")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "api-version", valid_564410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564411: Call_BackupPoliciesListByDevice_564403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the backup policies in a device.
  ## 
  let valid = call_564411.validator(path, query, header, formData, body)
  let scheme = call_564411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564411.url(scheme.get, call_564411.host, call_564411.base,
                         call_564411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564411, url, valid)

proc call*(call_564412: Call_BackupPoliciesListByDevice_564403; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## backupPoliciesListByDevice
  ## Gets all the backup policies in a device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564413 = newJObject()
  var query_564414 = newJObject()
  add(query_564414, "api-version", newJString(apiVersion))
  add(path_564413, "subscriptionId", newJString(subscriptionId))
  add(path_564413, "deviceName", newJString(deviceName))
  add(path_564413, "resourceGroupName", newJString(resourceGroupName))
  add(path_564413, "managerName", newJString(managerName))
  result = call_564412.call(path_564413, query_564414, nil, nil, nil)

var backupPoliciesListByDevice* = Call_BackupPoliciesListByDevice_564403(
    name: "backupPoliciesListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies",
    validator: validate_BackupPoliciesListByDevice_564404, base: "",
    url: url_BackupPoliciesListByDevice_564405, schemes: {Scheme.Https})
type
  Call_BackupPoliciesCreateOrUpdate_564428 = ref object of OpenApiRestCall_563565
proc url_BackupPoliciesCreateOrUpdate_564430(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupPolicyName" in path,
        "`backupPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "backupPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupPoliciesCreateOrUpdate_564429(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the backup policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   backupPolicyName: JString (required)
  ##                   : The name of the backup policy to be created/updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564431 = path.getOrDefault("subscriptionId")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "subscriptionId", valid_564431
  var valid_564432 = path.getOrDefault("deviceName")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "deviceName", valid_564432
  var valid_564433 = path.getOrDefault("resourceGroupName")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "resourceGroupName", valid_564433
  var valid_564434 = path.getOrDefault("managerName")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "managerName", valid_564434
  var valid_564435 = path.getOrDefault("backupPolicyName")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = nil)
  if valid_564435 != nil:
    section.add "backupPolicyName", valid_564435
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564436 = query.getOrDefault("api-version")
  valid_564436 = validateParameter(valid_564436, JString, required = true,
                                 default = nil)
  if valid_564436 != nil:
    section.add "api-version", valid_564436
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The backup policy.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564438: Call_BackupPoliciesCreateOrUpdate_564428; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the backup policy.
  ## 
  let valid = call_564438.validator(path, query, header, formData, body)
  let scheme = call_564438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564438.url(scheme.get, call_564438.host, call_564438.base,
                         call_564438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564438, url, valid)

proc call*(call_564439: Call_BackupPoliciesCreateOrUpdate_564428;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string; backupPolicyName: string;
          parameters: JsonNode): Recallable =
  ## backupPoliciesCreateOrUpdate
  ## Creates or updates the backup policy.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   backupPolicyName: string (required)
  ##                   : The name of the backup policy to be created/updated.
  ##   parameters: JObject (required)
  ##             : The backup policy.
  var path_564440 = newJObject()
  var query_564441 = newJObject()
  var body_564442 = newJObject()
  add(query_564441, "api-version", newJString(apiVersion))
  add(path_564440, "subscriptionId", newJString(subscriptionId))
  add(path_564440, "deviceName", newJString(deviceName))
  add(path_564440, "resourceGroupName", newJString(resourceGroupName))
  add(path_564440, "managerName", newJString(managerName))
  add(path_564440, "backupPolicyName", newJString(backupPolicyName))
  if parameters != nil:
    body_564442 = parameters
  result = call_564439.call(path_564440, query_564441, nil, nil, body_564442)

var backupPoliciesCreateOrUpdate* = Call_BackupPoliciesCreateOrUpdate_564428(
    name: "backupPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}",
    validator: validate_BackupPoliciesCreateOrUpdate_564429, base: "",
    url: url_BackupPoliciesCreateOrUpdate_564430, schemes: {Scheme.Https})
type
  Call_BackupPoliciesGet_564415 = ref object of OpenApiRestCall_563565
proc url_BackupPoliciesGet_564417(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupPolicyName" in path,
        "`backupPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "backupPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupPoliciesGet_564416(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the properties of the specified backup policy name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   backupPolicyName: JString (required)
  ##                   : The name of backup policy to be fetched.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564418 = path.getOrDefault("subscriptionId")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "subscriptionId", valid_564418
  var valid_564419 = path.getOrDefault("deviceName")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = nil)
  if valid_564419 != nil:
    section.add "deviceName", valid_564419
  var valid_564420 = path.getOrDefault("resourceGroupName")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "resourceGroupName", valid_564420
  var valid_564421 = path.getOrDefault("managerName")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "managerName", valid_564421
  var valid_564422 = path.getOrDefault("backupPolicyName")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "backupPolicyName", valid_564422
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564423 = query.getOrDefault("api-version")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = nil)
  if valid_564423 != nil:
    section.add "api-version", valid_564423
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564424: Call_BackupPoliciesGet_564415; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified backup policy name.
  ## 
  let valid = call_564424.validator(path, query, header, formData, body)
  let scheme = call_564424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564424.url(scheme.get, call_564424.host, call_564424.base,
                         call_564424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564424, url, valid)

proc call*(call_564425: Call_BackupPoliciesGet_564415; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; backupPolicyName: string): Recallable =
  ## backupPoliciesGet
  ## Gets the properties of the specified backup policy name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   backupPolicyName: string (required)
  ##                   : The name of backup policy to be fetched.
  var path_564426 = newJObject()
  var query_564427 = newJObject()
  add(query_564427, "api-version", newJString(apiVersion))
  add(path_564426, "subscriptionId", newJString(subscriptionId))
  add(path_564426, "deviceName", newJString(deviceName))
  add(path_564426, "resourceGroupName", newJString(resourceGroupName))
  add(path_564426, "managerName", newJString(managerName))
  add(path_564426, "backupPolicyName", newJString(backupPolicyName))
  result = call_564425.call(path_564426, query_564427, nil, nil, nil)

var backupPoliciesGet* = Call_BackupPoliciesGet_564415(name: "backupPoliciesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}",
    validator: validate_BackupPoliciesGet_564416, base: "",
    url: url_BackupPoliciesGet_564417, schemes: {Scheme.Https})
type
  Call_BackupPoliciesDelete_564443 = ref object of OpenApiRestCall_563565
proc url_BackupPoliciesDelete_564445(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupPolicyName" in path,
        "`backupPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "backupPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupPoliciesDelete_564444(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the backup policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   backupPolicyName: JString (required)
  ##                   : The name of the backup policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564446 = path.getOrDefault("subscriptionId")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "subscriptionId", valid_564446
  var valid_564447 = path.getOrDefault("deviceName")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "deviceName", valid_564447
  var valid_564448 = path.getOrDefault("resourceGroupName")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "resourceGroupName", valid_564448
  var valid_564449 = path.getOrDefault("managerName")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "managerName", valid_564449
  var valid_564450 = path.getOrDefault("backupPolicyName")
  valid_564450 = validateParameter(valid_564450, JString, required = true,
                                 default = nil)
  if valid_564450 != nil:
    section.add "backupPolicyName", valid_564450
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564451 = query.getOrDefault("api-version")
  valid_564451 = validateParameter(valid_564451, JString, required = true,
                                 default = nil)
  if valid_564451 != nil:
    section.add "api-version", valid_564451
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564452: Call_BackupPoliciesDelete_564443; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the backup policy.
  ## 
  let valid = call_564452.validator(path, query, header, formData, body)
  let scheme = call_564452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564452.url(scheme.get, call_564452.host, call_564452.base,
                         call_564452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564452, url, valid)

proc call*(call_564453: Call_BackupPoliciesDelete_564443; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; backupPolicyName: string): Recallable =
  ## backupPoliciesDelete
  ## Deletes the backup policy.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   backupPolicyName: string (required)
  ##                   : The name of the backup policy.
  var path_564454 = newJObject()
  var query_564455 = newJObject()
  add(query_564455, "api-version", newJString(apiVersion))
  add(path_564454, "subscriptionId", newJString(subscriptionId))
  add(path_564454, "deviceName", newJString(deviceName))
  add(path_564454, "resourceGroupName", newJString(resourceGroupName))
  add(path_564454, "managerName", newJString(managerName))
  add(path_564454, "backupPolicyName", newJString(backupPolicyName))
  result = call_564453.call(path_564454, query_564455, nil, nil, nil)

var backupPoliciesDelete* = Call_BackupPoliciesDelete_564443(
    name: "backupPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}",
    validator: validate_BackupPoliciesDelete_564444, base: "",
    url: url_BackupPoliciesDelete_564445, schemes: {Scheme.Https})
type
  Call_BackupPoliciesBackupNow_564456 = ref object of OpenApiRestCall_563565
proc url_BackupPoliciesBackupNow_564458(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupPolicyName" in path,
        "`backupPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "backupPolicyName"),
               (kind: ConstantSegment, value: "/backup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupPoliciesBackupNow_564457(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Backup the backup policy now.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   backupPolicyName: JString (required)
  ##                   : The backup policy name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564459 = path.getOrDefault("subscriptionId")
  valid_564459 = validateParameter(valid_564459, JString, required = true,
                                 default = nil)
  if valid_564459 != nil:
    section.add "subscriptionId", valid_564459
  var valid_564460 = path.getOrDefault("deviceName")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "deviceName", valid_564460
  var valid_564461 = path.getOrDefault("resourceGroupName")
  valid_564461 = validateParameter(valid_564461, JString, required = true,
                                 default = nil)
  if valid_564461 != nil:
    section.add "resourceGroupName", valid_564461
  var valid_564462 = path.getOrDefault("managerName")
  valid_564462 = validateParameter(valid_564462, JString, required = true,
                                 default = nil)
  if valid_564462 != nil:
    section.add "managerName", valid_564462
  var valid_564463 = path.getOrDefault("backupPolicyName")
  valid_564463 = validateParameter(valid_564463, JString, required = true,
                                 default = nil)
  if valid_564463 != nil:
    section.add "backupPolicyName", valid_564463
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   backupType: JString (required)
  ##             : The backup Type. This can be cloudSnapshot or localSnapshot.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564464 = query.getOrDefault("api-version")
  valid_564464 = validateParameter(valid_564464, JString, required = true,
                                 default = nil)
  if valid_564464 != nil:
    section.add "api-version", valid_564464
  var valid_564465 = query.getOrDefault("backupType")
  valid_564465 = validateParameter(valid_564465, JString, required = true,
                                 default = nil)
  if valid_564465 != nil:
    section.add "backupType", valid_564465
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564466: Call_BackupPoliciesBackupNow_564456; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Backup the backup policy now.
  ## 
  let valid = call_564466.validator(path, query, header, formData, body)
  let scheme = call_564466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564466.url(scheme.get, call_564466.host, call_564466.base,
                         call_564466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564466, url, valid)

proc call*(call_564467: Call_BackupPoliciesBackupNow_564456; apiVersion: string;
          subscriptionId: string; backupType: string; deviceName: string;
          resourceGroupName: string; managerName: string; backupPolicyName: string): Recallable =
  ## backupPoliciesBackupNow
  ## Backup the backup policy now.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   backupType: string (required)
  ##             : The backup Type. This can be cloudSnapshot or localSnapshot.
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   backupPolicyName: string (required)
  ##                   : The backup policy name.
  var path_564468 = newJObject()
  var query_564469 = newJObject()
  add(query_564469, "api-version", newJString(apiVersion))
  add(path_564468, "subscriptionId", newJString(subscriptionId))
  add(query_564469, "backupType", newJString(backupType))
  add(path_564468, "deviceName", newJString(deviceName))
  add(path_564468, "resourceGroupName", newJString(resourceGroupName))
  add(path_564468, "managerName", newJString(managerName))
  add(path_564468, "backupPolicyName", newJString(backupPolicyName))
  result = call_564467.call(path_564468, query_564469, nil, nil, nil)

var backupPoliciesBackupNow* = Call_BackupPoliciesBackupNow_564456(
    name: "backupPoliciesBackupNow", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}/backup",
    validator: validate_BackupPoliciesBackupNow_564457, base: "",
    url: url_BackupPoliciesBackupNow_564458, schemes: {Scheme.Https})
type
  Call_BackupSchedulesListByBackupPolicy_564470 = ref object of OpenApiRestCall_563565
proc url_BackupSchedulesListByBackupPolicy_564472(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupPolicyName" in path,
        "`backupPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "backupPolicyName"),
               (kind: ConstantSegment, value: "/schedules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupSchedulesListByBackupPolicy_564471(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the backup schedules in a backup policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   backupPolicyName: JString (required)
  ##                   : The backup policy name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564473 = path.getOrDefault("subscriptionId")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "subscriptionId", valid_564473
  var valid_564474 = path.getOrDefault("deviceName")
  valid_564474 = validateParameter(valid_564474, JString, required = true,
                                 default = nil)
  if valid_564474 != nil:
    section.add "deviceName", valid_564474
  var valid_564475 = path.getOrDefault("resourceGroupName")
  valid_564475 = validateParameter(valid_564475, JString, required = true,
                                 default = nil)
  if valid_564475 != nil:
    section.add "resourceGroupName", valid_564475
  var valid_564476 = path.getOrDefault("managerName")
  valid_564476 = validateParameter(valid_564476, JString, required = true,
                                 default = nil)
  if valid_564476 != nil:
    section.add "managerName", valid_564476
  var valid_564477 = path.getOrDefault("backupPolicyName")
  valid_564477 = validateParameter(valid_564477, JString, required = true,
                                 default = nil)
  if valid_564477 != nil:
    section.add "backupPolicyName", valid_564477
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564478 = query.getOrDefault("api-version")
  valid_564478 = validateParameter(valid_564478, JString, required = true,
                                 default = nil)
  if valid_564478 != nil:
    section.add "api-version", valid_564478
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564479: Call_BackupSchedulesListByBackupPolicy_564470;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the backup schedules in a backup policy.
  ## 
  let valid = call_564479.validator(path, query, header, formData, body)
  let scheme = call_564479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564479.url(scheme.get, call_564479.host, call_564479.base,
                         call_564479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564479, url, valid)

proc call*(call_564480: Call_BackupSchedulesListByBackupPolicy_564470;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string; backupPolicyName: string): Recallable =
  ## backupSchedulesListByBackupPolicy
  ## Gets all the backup schedules in a backup policy.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   backupPolicyName: string (required)
  ##                   : The backup policy name.
  var path_564481 = newJObject()
  var query_564482 = newJObject()
  add(query_564482, "api-version", newJString(apiVersion))
  add(path_564481, "subscriptionId", newJString(subscriptionId))
  add(path_564481, "deviceName", newJString(deviceName))
  add(path_564481, "resourceGroupName", newJString(resourceGroupName))
  add(path_564481, "managerName", newJString(managerName))
  add(path_564481, "backupPolicyName", newJString(backupPolicyName))
  result = call_564480.call(path_564481, query_564482, nil, nil, nil)

var backupSchedulesListByBackupPolicy* = Call_BackupSchedulesListByBackupPolicy_564470(
    name: "backupSchedulesListByBackupPolicy", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}/schedules",
    validator: validate_BackupSchedulesListByBackupPolicy_564471, base: "",
    url: url_BackupSchedulesListByBackupPolicy_564472, schemes: {Scheme.Https})
type
  Call_BackupSchedulesCreateOrUpdate_564497 = ref object of OpenApiRestCall_563565
proc url_BackupSchedulesCreateOrUpdate_564499(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupPolicyName" in path,
        "`backupPolicyName` is a required path parameter"
  assert "backupScheduleName" in path,
        "`backupScheduleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "backupPolicyName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "backupScheduleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupSchedulesCreateOrUpdate_564498(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the backup schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   backupScheduleName: JString (required)
  ##                     : The backup schedule name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   backupPolicyName: JString (required)
  ##                   : The backup policy name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `backupScheduleName` field"
  var valid_564500 = path.getOrDefault("backupScheduleName")
  valid_564500 = validateParameter(valid_564500, JString, required = true,
                                 default = nil)
  if valid_564500 != nil:
    section.add "backupScheduleName", valid_564500
  var valid_564501 = path.getOrDefault("subscriptionId")
  valid_564501 = validateParameter(valid_564501, JString, required = true,
                                 default = nil)
  if valid_564501 != nil:
    section.add "subscriptionId", valid_564501
  var valid_564502 = path.getOrDefault("deviceName")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "deviceName", valid_564502
  var valid_564503 = path.getOrDefault("resourceGroupName")
  valid_564503 = validateParameter(valid_564503, JString, required = true,
                                 default = nil)
  if valid_564503 != nil:
    section.add "resourceGroupName", valid_564503
  var valid_564504 = path.getOrDefault("managerName")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "managerName", valid_564504
  var valid_564505 = path.getOrDefault("backupPolicyName")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = nil)
  if valid_564505 != nil:
    section.add "backupPolicyName", valid_564505
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564506 = query.getOrDefault("api-version")
  valid_564506 = validateParameter(valid_564506, JString, required = true,
                                 default = nil)
  if valid_564506 != nil:
    section.add "api-version", valid_564506
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The backup schedule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564508: Call_BackupSchedulesCreateOrUpdate_564497; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the backup schedule.
  ## 
  let valid = call_564508.validator(path, query, header, formData, body)
  let scheme = call_564508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564508.url(scheme.get, call_564508.host, call_564508.base,
                         call_564508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564508, url, valid)

proc call*(call_564509: Call_BackupSchedulesCreateOrUpdate_564497;
          backupScheduleName: string; apiVersion: string; subscriptionId: string;
          deviceName: string; resourceGroupName: string; managerName: string;
          backupPolicyName: string; parameters: JsonNode): Recallable =
  ## backupSchedulesCreateOrUpdate
  ## Creates or updates the backup schedule.
  ##   backupScheduleName: string (required)
  ##                     : The backup schedule name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   backupPolicyName: string (required)
  ##                   : The backup policy name.
  ##   parameters: JObject (required)
  ##             : The backup schedule.
  var path_564510 = newJObject()
  var query_564511 = newJObject()
  var body_564512 = newJObject()
  add(path_564510, "backupScheduleName", newJString(backupScheduleName))
  add(query_564511, "api-version", newJString(apiVersion))
  add(path_564510, "subscriptionId", newJString(subscriptionId))
  add(path_564510, "deviceName", newJString(deviceName))
  add(path_564510, "resourceGroupName", newJString(resourceGroupName))
  add(path_564510, "managerName", newJString(managerName))
  add(path_564510, "backupPolicyName", newJString(backupPolicyName))
  if parameters != nil:
    body_564512 = parameters
  result = call_564509.call(path_564510, query_564511, nil, nil, body_564512)

var backupSchedulesCreateOrUpdate* = Call_BackupSchedulesCreateOrUpdate_564497(
    name: "backupSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}/schedules/{backupScheduleName}",
    validator: validate_BackupSchedulesCreateOrUpdate_564498, base: "",
    url: url_BackupSchedulesCreateOrUpdate_564499, schemes: {Scheme.Https})
type
  Call_BackupSchedulesGet_564483 = ref object of OpenApiRestCall_563565
proc url_BackupSchedulesGet_564485(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupPolicyName" in path,
        "`backupPolicyName` is a required path parameter"
  assert "backupScheduleName" in path,
        "`backupScheduleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "backupPolicyName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "backupScheduleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupSchedulesGet_564484(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the properties of the specified backup schedule name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   backupScheduleName: JString (required)
  ##                     : The name of the backup schedule to be fetched
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   backupPolicyName: JString (required)
  ##                   : The backup policy name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `backupScheduleName` field"
  var valid_564486 = path.getOrDefault("backupScheduleName")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "backupScheduleName", valid_564486
  var valid_564487 = path.getOrDefault("subscriptionId")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "subscriptionId", valid_564487
  var valid_564488 = path.getOrDefault("deviceName")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = nil)
  if valid_564488 != nil:
    section.add "deviceName", valid_564488
  var valid_564489 = path.getOrDefault("resourceGroupName")
  valid_564489 = validateParameter(valid_564489, JString, required = true,
                                 default = nil)
  if valid_564489 != nil:
    section.add "resourceGroupName", valid_564489
  var valid_564490 = path.getOrDefault("managerName")
  valid_564490 = validateParameter(valid_564490, JString, required = true,
                                 default = nil)
  if valid_564490 != nil:
    section.add "managerName", valid_564490
  var valid_564491 = path.getOrDefault("backupPolicyName")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "backupPolicyName", valid_564491
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564492 = query.getOrDefault("api-version")
  valid_564492 = validateParameter(valid_564492, JString, required = true,
                                 default = nil)
  if valid_564492 != nil:
    section.add "api-version", valid_564492
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564493: Call_BackupSchedulesGet_564483; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified backup schedule name.
  ## 
  let valid = call_564493.validator(path, query, header, formData, body)
  let scheme = call_564493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564493.url(scheme.get, call_564493.host, call_564493.base,
                         call_564493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564493, url, valid)

proc call*(call_564494: Call_BackupSchedulesGet_564483; backupScheduleName: string;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string; backupPolicyName: string): Recallable =
  ## backupSchedulesGet
  ## Gets the properties of the specified backup schedule name.
  ##   backupScheduleName: string (required)
  ##                     : The name of the backup schedule to be fetched
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   backupPolicyName: string (required)
  ##                   : The backup policy name.
  var path_564495 = newJObject()
  var query_564496 = newJObject()
  add(path_564495, "backupScheduleName", newJString(backupScheduleName))
  add(query_564496, "api-version", newJString(apiVersion))
  add(path_564495, "subscriptionId", newJString(subscriptionId))
  add(path_564495, "deviceName", newJString(deviceName))
  add(path_564495, "resourceGroupName", newJString(resourceGroupName))
  add(path_564495, "managerName", newJString(managerName))
  add(path_564495, "backupPolicyName", newJString(backupPolicyName))
  result = call_564494.call(path_564495, query_564496, nil, nil, nil)

var backupSchedulesGet* = Call_BackupSchedulesGet_564483(
    name: "backupSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}/schedules/{backupScheduleName}",
    validator: validate_BackupSchedulesGet_564484, base: "",
    url: url_BackupSchedulesGet_564485, schemes: {Scheme.Https})
type
  Call_BackupSchedulesDelete_564513 = ref object of OpenApiRestCall_563565
proc url_BackupSchedulesDelete_564515(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupPolicyName" in path,
        "`backupPolicyName` is a required path parameter"
  assert "backupScheduleName" in path,
        "`backupScheduleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "backupPolicyName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "backupScheduleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupSchedulesDelete_564514(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the backup schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   backupScheduleName: JString (required)
  ##                     : The name the backup schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   backupPolicyName: JString (required)
  ##                   : The backup policy name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `backupScheduleName` field"
  var valid_564516 = path.getOrDefault("backupScheduleName")
  valid_564516 = validateParameter(valid_564516, JString, required = true,
                                 default = nil)
  if valid_564516 != nil:
    section.add "backupScheduleName", valid_564516
  var valid_564517 = path.getOrDefault("subscriptionId")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "subscriptionId", valid_564517
  var valid_564518 = path.getOrDefault("deviceName")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "deviceName", valid_564518
  var valid_564519 = path.getOrDefault("resourceGroupName")
  valid_564519 = validateParameter(valid_564519, JString, required = true,
                                 default = nil)
  if valid_564519 != nil:
    section.add "resourceGroupName", valid_564519
  var valid_564520 = path.getOrDefault("managerName")
  valid_564520 = validateParameter(valid_564520, JString, required = true,
                                 default = nil)
  if valid_564520 != nil:
    section.add "managerName", valid_564520
  var valid_564521 = path.getOrDefault("backupPolicyName")
  valid_564521 = validateParameter(valid_564521, JString, required = true,
                                 default = nil)
  if valid_564521 != nil:
    section.add "backupPolicyName", valid_564521
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564522 = query.getOrDefault("api-version")
  valid_564522 = validateParameter(valid_564522, JString, required = true,
                                 default = nil)
  if valid_564522 != nil:
    section.add "api-version", valid_564522
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564523: Call_BackupSchedulesDelete_564513; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the backup schedule.
  ## 
  let valid = call_564523.validator(path, query, header, formData, body)
  let scheme = call_564523.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564523.url(scheme.get, call_564523.host, call_564523.base,
                         call_564523.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564523, url, valid)

proc call*(call_564524: Call_BackupSchedulesDelete_564513;
          backupScheduleName: string; apiVersion: string; subscriptionId: string;
          deviceName: string; resourceGroupName: string; managerName: string;
          backupPolicyName: string): Recallable =
  ## backupSchedulesDelete
  ## Deletes the backup schedule.
  ##   backupScheduleName: string (required)
  ##                     : The name the backup schedule.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   backupPolicyName: string (required)
  ##                   : The backup policy name.
  var path_564525 = newJObject()
  var query_564526 = newJObject()
  add(path_564525, "backupScheduleName", newJString(backupScheduleName))
  add(query_564526, "api-version", newJString(apiVersion))
  add(path_564525, "subscriptionId", newJString(subscriptionId))
  add(path_564525, "deviceName", newJString(deviceName))
  add(path_564525, "resourceGroupName", newJString(resourceGroupName))
  add(path_564525, "managerName", newJString(managerName))
  add(path_564525, "backupPolicyName", newJString(backupPolicyName))
  result = call_564524.call(path_564525, query_564526, nil, nil, nil)

var backupSchedulesDelete* = Call_BackupSchedulesDelete_564513(
    name: "backupSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}/schedules/{backupScheduleName}",
    validator: validate_BackupSchedulesDelete_564514, base: "",
    url: url_BackupSchedulesDelete_564515, schemes: {Scheme.Https})
type
  Call_BackupsListByDevice_564527 = ref object of OpenApiRestCall_563565
proc url_BackupsListByDevice_564529(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupsListByDevice_564528(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves all the backups in a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564530 = path.getOrDefault("subscriptionId")
  valid_564530 = validateParameter(valid_564530, JString, required = true,
                                 default = nil)
  if valid_564530 != nil:
    section.add "subscriptionId", valid_564530
  var valid_564531 = path.getOrDefault("deviceName")
  valid_564531 = validateParameter(valid_564531, JString, required = true,
                                 default = nil)
  if valid_564531 != nil:
    section.add "deviceName", valid_564531
  var valid_564532 = path.getOrDefault("resourceGroupName")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "resourceGroupName", valid_564532
  var valid_564533 = path.getOrDefault("managerName")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = nil)
  if valid_564533 != nil:
    section.add "managerName", valid_564533
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564534 = query.getOrDefault("api-version")
  valid_564534 = validateParameter(valid_564534, JString, required = true,
                                 default = nil)
  if valid_564534 != nil:
    section.add "api-version", valid_564534
  var valid_564535 = query.getOrDefault("$filter")
  valid_564535 = validateParameter(valid_564535, JString, required = false,
                                 default = nil)
  if valid_564535 != nil:
    section.add "$filter", valid_564535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564536: Call_BackupsListByDevice_564527; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the backups in a device.
  ## 
  let valid = call_564536.validator(path, query, header, formData, body)
  let scheme = call_564536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564536.url(scheme.get, call_564536.host, call_564536.base,
                         call_564536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564536, url, valid)

proc call*(call_564537: Call_BackupsListByDevice_564527; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; Filter: string = ""): Recallable =
  ## backupsListByDevice
  ## Retrieves all the backups in a device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   Filter: string
  ##         : OData Filter options
  var path_564538 = newJObject()
  var query_564539 = newJObject()
  add(query_564539, "api-version", newJString(apiVersion))
  add(path_564538, "subscriptionId", newJString(subscriptionId))
  add(path_564538, "deviceName", newJString(deviceName))
  add(path_564538, "resourceGroupName", newJString(resourceGroupName))
  add(path_564538, "managerName", newJString(managerName))
  add(query_564539, "$filter", newJString(Filter))
  result = call_564537.call(path_564538, query_564539, nil, nil, nil)

var backupsListByDevice* = Call_BackupsListByDevice_564527(
    name: "backupsListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups",
    validator: validate_BackupsListByDevice_564528, base: "",
    url: url_BackupsListByDevice_564529, schemes: {Scheme.Https})
type
  Call_BackupsDelete_564540 = ref object of OpenApiRestCall_563565
proc url_BackupsDelete_564542(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupName" in path, "`backupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backups/"),
               (kind: VariableSegment, value: "backupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupsDelete_564541(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the backup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   backupName: JString (required)
  ##             : The backup name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564543 = path.getOrDefault("subscriptionId")
  valid_564543 = validateParameter(valid_564543, JString, required = true,
                                 default = nil)
  if valid_564543 != nil:
    section.add "subscriptionId", valid_564543
  var valid_564544 = path.getOrDefault("deviceName")
  valid_564544 = validateParameter(valid_564544, JString, required = true,
                                 default = nil)
  if valid_564544 != nil:
    section.add "deviceName", valid_564544
  var valid_564545 = path.getOrDefault("resourceGroupName")
  valid_564545 = validateParameter(valid_564545, JString, required = true,
                                 default = nil)
  if valid_564545 != nil:
    section.add "resourceGroupName", valid_564545
  var valid_564546 = path.getOrDefault("managerName")
  valid_564546 = validateParameter(valid_564546, JString, required = true,
                                 default = nil)
  if valid_564546 != nil:
    section.add "managerName", valid_564546
  var valid_564547 = path.getOrDefault("backupName")
  valid_564547 = validateParameter(valid_564547, JString, required = true,
                                 default = nil)
  if valid_564547 != nil:
    section.add "backupName", valid_564547
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564548 = query.getOrDefault("api-version")
  valid_564548 = validateParameter(valid_564548, JString, required = true,
                                 default = nil)
  if valid_564548 != nil:
    section.add "api-version", valid_564548
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564549: Call_BackupsDelete_564540; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the backup.
  ## 
  let valid = call_564549.validator(path, query, header, formData, body)
  let scheme = call_564549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564549.url(scheme.get, call_564549.host, call_564549.base,
                         call_564549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564549, url, valid)

proc call*(call_564550: Call_BackupsDelete_564540; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; backupName: string): Recallable =
  ## backupsDelete
  ## Deletes the backup.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   backupName: string (required)
  ##             : The backup name.
  var path_564551 = newJObject()
  var query_564552 = newJObject()
  add(query_564552, "api-version", newJString(apiVersion))
  add(path_564551, "subscriptionId", newJString(subscriptionId))
  add(path_564551, "deviceName", newJString(deviceName))
  add(path_564551, "resourceGroupName", newJString(resourceGroupName))
  add(path_564551, "managerName", newJString(managerName))
  add(path_564551, "backupName", newJString(backupName))
  result = call_564550.call(path_564551, query_564552, nil, nil, nil)

var backupsDelete* = Call_BackupsDelete_564540(name: "backupsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups/{backupName}",
    validator: validate_BackupsDelete_564541, base: "", url: url_BackupsDelete_564542,
    schemes: {Scheme.Https})
type
  Call_BackupsClone_564553 = ref object of OpenApiRestCall_563565
proc url_BackupsClone_564555(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupName" in path, "`backupName` is a required path parameter"
  assert "backupElementName" in path,
        "`backupElementName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backups/"),
               (kind: VariableSegment, value: "backupName"),
               (kind: ConstantSegment, value: "/elements/"),
               (kind: VariableSegment, value: "backupElementName"),
               (kind: ConstantSegment, value: "/clone")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupsClone_564554(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Clones the backup element as a new volume.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   backupElementName: JString (required)
  ##                    : The backup element name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   backupName: JString (required)
  ##             : The backup name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `backupElementName` field"
  var valid_564556 = path.getOrDefault("backupElementName")
  valid_564556 = validateParameter(valid_564556, JString, required = true,
                                 default = nil)
  if valid_564556 != nil:
    section.add "backupElementName", valid_564556
  var valid_564557 = path.getOrDefault("subscriptionId")
  valid_564557 = validateParameter(valid_564557, JString, required = true,
                                 default = nil)
  if valid_564557 != nil:
    section.add "subscriptionId", valid_564557
  var valid_564558 = path.getOrDefault("deviceName")
  valid_564558 = validateParameter(valid_564558, JString, required = true,
                                 default = nil)
  if valid_564558 != nil:
    section.add "deviceName", valid_564558
  var valid_564559 = path.getOrDefault("resourceGroupName")
  valid_564559 = validateParameter(valid_564559, JString, required = true,
                                 default = nil)
  if valid_564559 != nil:
    section.add "resourceGroupName", valid_564559
  var valid_564560 = path.getOrDefault("managerName")
  valid_564560 = validateParameter(valid_564560, JString, required = true,
                                 default = nil)
  if valid_564560 != nil:
    section.add "managerName", valid_564560
  var valid_564561 = path.getOrDefault("backupName")
  valid_564561 = validateParameter(valid_564561, JString, required = true,
                                 default = nil)
  if valid_564561 != nil:
    section.add "backupName", valid_564561
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564562 = query.getOrDefault("api-version")
  valid_564562 = validateParameter(valid_564562, JString, required = true,
                                 default = nil)
  if valid_564562 != nil:
    section.add "api-version", valid_564562
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The clone request object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564564: Call_BackupsClone_564553; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clones the backup element as a new volume.
  ## 
  let valid = call_564564.validator(path, query, header, formData, body)
  let scheme = call_564564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564564.url(scheme.get, call_564564.host, call_564564.base,
                         call_564564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564564, url, valid)

proc call*(call_564565: Call_BackupsClone_564553; apiVersion: string;
          backupElementName: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string; parameters: JsonNode;
          backupName: string): Recallable =
  ## backupsClone
  ## Clones the backup element as a new volume.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   backupElementName: string (required)
  ##                    : The backup element name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : The clone request object.
  ##   backupName: string (required)
  ##             : The backup name.
  var path_564566 = newJObject()
  var query_564567 = newJObject()
  var body_564568 = newJObject()
  add(query_564567, "api-version", newJString(apiVersion))
  add(path_564566, "backupElementName", newJString(backupElementName))
  add(path_564566, "subscriptionId", newJString(subscriptionId))
  add(path_564566, "deviceName", newJString(deviceName))
  add(path_564566, "resourceGroupName", newJString(resourceGroupName))
  add(path_564566, "managerName", newJString(managerName))
  if parameters != nil:
    body_564568 = parameters
  add(path_564566, "backupName", newJString(backupName))
  result = call_564565.call(path_564566, query_564567, nil, nil, body_564568)

var backupsClone* = Call_BackupsClone_564553(name: "backupsClone",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups/{backupName}/elements/{backupElementName}/clone",
    validator: validate_BackupsClone_564554, base: "", url: url_BackupsClone_564555,
    schemes: {Scheme.Https})
type
  Call_BackupsRestore_564569 = ref object of OpenApiRestCall_563565
proc url_BackupsRestore_564571(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupName" in path, "`backupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backups/"),
               (kind: VariableSegment, value: "backupName"),
               (kind: ConstantSegment, value: "/restore")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupsRestore_564570(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Restores the backup on the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   backupName: JString (required)
  ##             : The backupSet name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564572 = path.getOrDefault("subscriptionId")
  valid_564572 = validateParameter(valid_564572, JString, required = true,
                                 default = nil)
  if valid_564572 != nil:
    section.add "subscriptionId", valid_564572
  var valid_564573 = path.getOrDefault("deviceName")
  valid_564573 = validateParameter(valid_564573, JString, required = true,
                                 default = nil)
  if valid_564573 != nil:
    section.add "deviceName", valid_564573
  var valid_564574 = path.getOrDefault("resourceGroupName")
  valid_564574 = validateParameter(valid_564574, JString, required = true,
                                 default = nil)
  if valid_564574 != nil:
    section.add "resourceGroupName", valid_564574
  var valid_564575 = path.getOrDefault("managerName")
  valid_564575 = validateParameter(valid_564575, JString, required = true,
                                 default = nil)
  if valid_564575 != nil:
    section.add "managerName", valid_564575
  var valid_564576 = path.getOrDefault("backupName")
  valid_564576 = validateParameter(valid_564576, JString, required = true,
                                 default = nil)
  if valid_564576 != nil:
    section.add "backupName", valid_564576
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564577 = query.getOrDefault("api-version")
  valid_564577 = validateParameter(valid_564577, JString, required = true,
                                 default = nil)
  if valid_564577 != nil:
    section.add "api-version", valid_564577
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564578: Call_BackupsRestore_564569; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores the backup on the device.
  ## 
  let valid = call_564578.validator(path, query, header, formData, body)
  let scheme = call_564578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564578.url(scheme.get, call_564578.host, call_564578.base,
                         call_564578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564578, url, valid)

proc call*(call_564579: Call_BackupsRestore_564569; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; backupName: string): Recallable =
  ## backupsRestore
  ## Restores the backup on the device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   backupName: string (required)
  ##             : The backupSet name
  var path_564580 = newJObject()
  var query_564581 = newJObject()
  add(query_564581, "api-version", newJString(apiVersion))
  add(path_564580, "subscriptionId", newJString(subscriptionId))
  add(path_564580, "deviceName", newJString(deviceName))
  add(path_564580, "resourceGroupName", newJString(resourceGroupName))
  add(path_564580, "managerName", newJString(managerName))
  add(path_564580, "backupName", newJString(backupName))
  result = call_564579.call(path_564580, query_564581, nil, nil, nil)

var backupsRestore* = Call_BackupsRestore_564569(name: "backupsRestore",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups/{backupName}/restore",
    validator: validate_BackupsRestore_564570, base: "", url: url_BackupsRestore_564571,
    schemes: {Scheme.Https})
type
  Call_DevicesDeactivate_564582 = ref object of OpenApiRestCall_563565
proc url_DevicesDeactivate_564584(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/deactivate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesDeactivate_564583(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deactivates the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564585 = path.getOrDefault("subscriptionId")
  valid_564585 = validateParameter(valid_564585, JString, required = true,
                                 default = nil)
  if valid_564585 != nil:
    section.add "subscriptionId", valid_564585
  var valid_564586 = path.getOrDefault("deviceName")
  valid_564586 = validateParameter(valid_564586, JString, required = true,
                                 default = nil)
  if valid_564586 != nil:
    section.add "deviceName", valid_564586
  var valid_564587 = path.getOrDefault("resourceGroupName")
  valid_564587 = validateParameter(valid_564587, JString, required = true,
                                 default = nil)
  if valid_564587 != nil:
    section.add "resourceGroupName", valid_564587
  var valid_564588 = path.getOrDefault("managerName")
  valid_564588 = validateParameter(valid_564588, JString, required = true,
                                 default = nil)
  if valid_564588 != nil:
    section.add "managerName", valid_564588
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564589 = query.getOrDefault("api-version")
  valid_564589 = validateParameter(valid_564589, JString, required = true,
                                 default = nil)
  if valid_564589 != nil:
    section.add "api-version", valid_564589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564590: Call_DevicesDeactivate_564582; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deactivates the device.
  ## 
  let valid = call_564590.validator(path, query, header, formData, body)
  let scheme = call_564590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564590.url(scheme.get, call_564590.host, call_564590.base,
                         call_564590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564590, url, valid)

proc call*(call_564591: Call_DevicesDeactivate_564582; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## devicesDeactivate
  ## Deactivates the device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564592 = newJObject()
  var query_564593 = newJObject()
  add(query_564593, "api-version", newJString(apiVersion))
  add(path_564592, "subscriptionId", newJString(subscriptionId))
  add(path_564592, "deviceName", newJString(deviceName))
  add(path_564592, "resourceGroupName", newJString(resourceGroupName))
  add(path_564592, "managerName", newJString(managerName))
  result = call_564591.call(path_564592, query_564593, nil, nil, nil)

var devicesDeactivate* = Call_DevicesDeactivate_564582(name: "devicesDeactivate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/deactivate",
    validator: validate_DevicesDeactivate_564583, base: "",
    url: url_DevicesDeactivate_564584, schemes: {Scheme.Https})
type
  Call_HardwareComponentGroupsListByDevice_564594 = ref object of OpenApiRestCall_563565
proc url_HardwareComponentGroupsListByDevice_564596(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/hardwareComponentGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HardwareComponentGroupsListByDevice_564595(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the hardware component groups at device-level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564597 = path.getOrDefault("subscriptionId")
  valid_564597 = validateParameter(valid_564597, JString, required = true,
                                 default = nil)
  if valid_564597 != nil:
    section.add "subscriptionId", valid_564597
  var valid_564598 = path.getOrDefault("deviceName")
  valid_564598 = validateParameter(valid_564598, JString, required = true,
                                 default = nil)
  if valid_564598 != nil:
    section.add "deviceName", valid_564598
  var valid_564599 = path.getOrDefault("resourceGroupName")
  valid_564599 = validateParameter(valid_564599, JString, required = true,
                                 default = nil)
  if valid_564599 != nil:
    section.add "resourceGroupName", valid_564599
  var valid_564600 = path.getOrDefault("managerName")
  valid_564600 = validateParameter(valid_564600, JString, required = true,
                                 default = nil)
  if valid_564600 != nil:
    section.add "managerName", valid_564600
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
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

proc call*(call_564602: Call_HardwareComponentGroupsListByDevice_564594;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the hardware component groups at device-level.
  ## 
  let valid = call_564602.validator(path, query, header, formData, body)
  let scheme = call_564602.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564602.url(scheme.get, call_564602.host, call_564602.base,
                         call_564602.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564602, url, valid)

proc call*(call_564603: Call_HardwareComponentGroupsListByDevice_564594;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## hardwareComponentGroupsListByDevice
  ## Lists the hardware component groups at device-level.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564604 = newJObject()
  var query_564605 = newJObject()
  add(query_564605, "api-version", newJString(apiVersion))
  add(path_564604, "subscriptionId", newJString(subscriptionId))
  add(path_564604, "deviceName", newJString(deviceName))
  add(path_564604, "resourceGroupName", newJString(resourceGroupName))
  add(path_564604, "managerName", newJString(managerName))
  result = call_564603.call(path_564604, query_564605, nil, nil, nil)

var hardwareComponentGroupsListByDevice* = Call_HardwareComponentGroupsListByDevice_564594(
    name: "hardwareComponentGroupsListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/hardwareComponentGroups",
    validator: validate_HardwareComponentGroupsListByDevice_564595, base: "",
    url: url_HardwareComponentGroupsListByDevice_564596, schemes: {Scheme.Https})
type
  Call_HardwareComponentGroupsChangeControllerPowerState_564606 = ref object of OpenApiRestCall_563565
proc url_HardwareComponentGroupsChangeControllerPowerState_564608(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "hardwareComponentGroupName" in path,
        "`hardwareComponentGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/hardwareComponentGroups/"),
               (kind: VariableSegment, value: "hardwareComponentGroupName"),
               (kind: ConstantSegment, value: "/changeControllerPowerState")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HardwareComponentGroupsChangeControllerPowerState_564607(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Changes the power state of the controller.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hardwareComponentGroupName: JString (required)
  ##                             : The hardware component group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hardwareComponentGroupName` field"
  var valid_564609 = path.getOrDefault("hardwareComponentGroupName")
  valid_564609 = validateParameter(valid_564609, JString, required = true,
                                 default = nil)
  if valid_564609 != nil:
    section.add "hardwareComponentGroupName", valid_564609
  var valid_564610 = path.getOrDefault("subscriptionId")
  valid_564610 = validateParameter(valid_564610, JString, required = true,
                                 default = nil)
  if valid_564610 != nil:
    section.add "subscriptionId", valid_564610
  var valid_564611 = path.getOrDefault("deviceName")
  valid_564611 = validateParameter(valid_564611, JString, required = true,
                                 default = nil)
  if valid_564611 != nil:
    section.add "deviceName", valid_564611
  var valid_564612 = path.getOrDefault("resourceGroupName")
  valid_564612 = validateParameter(valid_564612, JString, required = true,
                                 default = nil)
  if valid_564612 != nil:
    section.add "resourceGroupName", valid_564612
  var valid_564613 = path.getOrDefault("managerName")
  valid_564613 = validateParameter(valid_564613, JString, required = true,
                                 default = nil)
  if valid_564613 != nil:
    section.add "managerName", valid_564613
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564614 = query.getOrDefault("api-version")
  valid_564614 = validateParameter(valid_564614, JString, required = true,
                                 default = nil)
  if valid_564614 != nil:
    section.add "api-version", valid_564614
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The controller power state change request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564616: Call_HardwareComponentGroupsChangeControllerPowerState_564606;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Changes the power state of the controller.
  ## 
  let valid = call_564616.validator(path, query, header, formData, body)
  let scheme = call_564616.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564616.url(scheme.get, call_564616.host, call_564616.base,
                         call_564616.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564616, url, valid)

proc call*(call_564617: Call_HardwareComponentGroupsChangeControllerPowerState_564606;
          apiVersion: string; hardwareComponentGroupName: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; parameters: JsonNode): Recallable =
  ## hardwareComponentGroupsChangeControllerPowerState
  ## Changes the power state of the controller.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   hardwareComponentGroupName: string (required)
  ##                             : The hardware component group name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : The controller power state change request.
  var path_564618 = newJObject()
  var query_564619 = newJObject()
  var body_564620 = newJObject()
  add(query_564619, "api-version", newJString(apiVersion))
  add(path_564618, "hardwareComponentGroupName",
      newJString(hardwareComponentGroupName))
  add(path_564618, "subscriptionId", newJString(subscriptionId))
  add(path_564618, "deviceName", newJString(deviceName))
  add(path_564618, "resourceGroupName", newJString(resourceGroupName))
  add(path_564618, "managerName", newJString(managerName))
  if parameters != nil:
    body_564620 = parameters
  result = call_564617.call(path_564618, query_564619, nil, nil, body_564620)

var hardwareComponentGroupsChangeControllerPowerState* = Call_HardwareComponentGroupsChangeControllerPowerState_564606(
    name: "hardwareComponentGroupsChangeControllerPowerState",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/hardwareComponentGroups/{hardwareComponentGroupName}/changeControllerPowerState",
    validator: validate_HardwareComponentGroupsChangeControllerPowerState_564607,
    base: "", url: url_HardwareComponentGroupsChangeControllerPowerState_564608,
    schemes: {Scheme.Https})
type
  Call_DevicesInstallUpdates_564621 = ref object of OpenApiRestCall_563565
proc url_DevicesInstallUpdates_564623(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/installUpdates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesInstallUpdates_564622(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Downloads and installs the updates on the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564624 = path.getOrDefault("subscriptionId")
  valid_564624 = validateParameter(valid_564624, JString, required = true,
                                 default = nil)
  if valid_564624 != nil:
    section.add "subscriptionId", valid_564624
  var valid_564625 = path.getOrDefault("deviceName")
  valid_564625 = validateParameter(valid_564625, JString, required = true,
                                 default = nil)
  if valid_564625 != nil:
    section.add "deviceName", valid_564625
  var valid_564626 = path.getOrDefault("resourceGroupName")
  valid_564626 = validateParameter(valid_564626, JString, required = true,
                                 default = nil)
  if valid_564626 != nil:
    section.add "resourceGroupName", valid_564626
  var valid_564627 = path.getOrDefault("managerName")
  valid_564627 = validateParameter(valid_564627, JString, required = true,
                                 default = nil)
  if valid_564627 != nil:
    section.add "managerName", valid_564627
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564628 = query.getOrDefault("api-version")
  valid_564628 = validateParameter(valid_564628, JString, required = true,
                                 default = nil)
  if valid_564628 != nil:
    section.add "api-version", valid_564628
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564629: Call_DevicesInstallUpdates_564621; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Downloads and installs the updates on the device.
  ## 
  let valid = call_564629.validator(path, query, header, formData, body)
  let scheme = call_564629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564629.url(scheme.get, call_564629.host, call_564629.base,
                         call_564629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564629, url, valid)

proc call*(call_564630: Call_DevicesInstallUpdates_564621; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## devicesInstallUpdates
  ## Downloads and installs the updates on the device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564631 = newJObject()
  var query_564632 = newJObject()
  add(query_564632, "api-version", newJString(apiVersion))
  add(path_564631, "subscriptionId", newJString(subscriptionId))
  add(path_564631, "deviceName", newJString(deviceName))
  add(path_564631, "resourceGroupName", newJString(resourceGroupName))
  add(path_564631, "managerName", newJString(managerName))
  result = call_564630.call(path_564631, query_564632, nil, nil, nil)

var devicesInstallUpdates* = Call_DevicesInstallUpdates_564621(
    name: "devicesInstallUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/installUpdates",
    validator: validate_DevicesInstallUpdates_564622, base: "",
    url: url_DevicesInstallUpdates_564623, schemes: {Scheme.Https})
type
  Call_JobsListByDevice_564633 = ref object of OpenApiRestCall_563565
proc url_JobsListByDevice_564635(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsListByDevice_564634(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets all the jobs for specified device. With optional OData query parameters, a filtered set of jobs is returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564636 = path.getOrDefault("subscriptionId")
  valid_564636 = validateParameter(valid_564636, JString, required = true,
                                 default = nil)
  if valid_564636 != nil:
    section.add "subscriptionId", valid_564636
  var valid_564637 = path.getOrDefault("deviceName")
  valid_564637 = validateParameter(valid_564637, JString, required = true,
                                 default = nil)
  if valid_564637 != nil:
    section.add "deviceName", valid_564637
  var valid_564638 = path.getOrDefault("resourceGroupName")
  valid_564638 = validateParameter(valid_564638, JString, required = true,
                                 default = nil)
  if valid_564638 != nil:
    section.add "resourceGroupName", valid_564638
  var valid_564639 = path.getOrDefault("managerName")
  valid_564639 = validateParameter(valid_564639, JString, required = true,
                                 default = nil)
  if valid_564639 != nil:
    section.add "managerName", valid_564639
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564640 = query.getOrDefault("api-version")
  valid_564640 = validateParameter(valid_564640, JString, required = true,
                                 default = nil)
  if valid_564640 != nil:
    section.add "api-version", valid_564640
  var valid_564641 = query.getOrDefault("$filter")
  valid_564641 = validateParameter(valid_564641, JString, required = false,
                                 default = nil)
  if valid_564641 != nil:
    section.add "$filter", valid_564641
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564642: Call_JobsListByDevice_564633; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the jobs for specified device. With optional OData query parameters, a filtered set of jobs is returned.
  ## 
  let valid = call_564642.validator(path, query, header, formData, body)
  let scheme = call_564642.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564642.url(scheme.get, call_564642.host, call_564642.base,
                         call_564642.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564642, url, valid)

proc call*(call_564643: Call_JobsListByDevice_564633; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; Filter: string = ""): Recallable =
  ## jobsListByDevice
  ## Gets all the jobs for specified device. With optional OData query parameters, a filtered set of jobs is returned.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   Filter: string
  ##         : OData Filter options
  var path_564644 = newJObject()
  var query_564645 = newJObject()
  add(query_564645, "api-version", newJString(apiVersion))
  add(path_564644, "subscriptionId", newJString(subscriptionId))
  add(path_564644, "deviceName", newJString(deviceName))
  add(path_564644, "resourceGroupName", newJString(resourceGroupName))
  add(path_564644, "managerName", newJString(managerName))
  add(query_564645, "$filter", newJString(Filter))
  result = call_564643.call(path_564644, query_564645, nil, nil, nil)

var jobsListByDevice* = Call_JobsListByDevice_564633(name: "jobsListByDevice",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/jobs",
    validator: validate_JobsListByDevice_564634, base: "",
    url: url_JobsListByDevice_564635, schemes: {Scheme.Https})
type
  Call_JobsGet_564646 = ref object of OpenApiRestCall_563565
proc url_JobsGet_564648(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsGet_564647(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the specified job name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   jobName: JString (required)
  ##          : The job Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564649 = path.getOrDefault("subscriptionId")
  valid_564649 = validateParameter(valid_564649, JString, required = true,
                                 default = nil)
  if valid_564649 != nil:
    section.add "subscriptionId", valid_564649
  var valid_564650 = path.getOrDefault("deviceName")
  valid_564650 = validateParameter(valid_564650, JString, required = true,
                                 default = nil)
  if valid_564650 != nil:
    section.add "deviceName", valid_564650
  var valid_564651 = path.getOrDefault("resourceGroupName")
  valid_564651 = validateParameter(valid_564651, JString, required = true,
                                 default = nil)
  if valid_564651 != nil:
    section.add "resourceGroupName", valid_564651
  var valid_564652 = path.getOrDefault("managerName")
  valid_564652 = validateParameter(valid_564652, JString, required = true,
                                 default = nil)
  if valid_564652 != nil:
    section.add "managerName", valid_564652
  var valid_564653 = path.getOrDefault("jobName")
  valid_564653 = validateParameter(valid_564653, JString, required = true,
                                 default = nil)
  if valid_564653 != nil:
    section.add "jobName", valid_564653
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564654 = query.getOrDefault("api-version")
  valid_564654 = validateParameter(valid_564654, JString, required = true,
                                 default = nil)
  if valid_564654 != nil:
    section.add "api-version", valid_564654
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564655: Call_JobsGet_564646; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the specified job name.
  ## 
  let valid = call_564655.validator(path, query, header, formData, body)
  let scheme = call_564655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564655.url(scheme.get, call_564655.host, call_564655.base,
                         call_564655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564655, url, valid)

proc call*(call_564656: Call_JobsGet_564646; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; jobName: string): Recallable =
  ## jobsGet
  ## Gets the details of the specified job name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   jobName: string (required)
  ##          : The job Name.
  var path_564657 = newJObject()
  var query_564658 = newJObject()
  add(query_564658, "api-version", newJString(apiVersion))
  add(path_564657, "subscriptionId", newJString(subscriptionId))
  add(path_564657, "deviceName", newJString(deviceName))
  add(path_564657, "resourceGroupName", newJString(resourceGroupName))
  add(path_564657, "managerName", newJString(managerName))
  add(path_564657, "jobName", newJString(jobName))
  result = call_564656.call(path_564657, query_564658, nil, nil, nil)

var jobsGet* = Call_JobsGet_564646(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/jobs/{jobName}",
                                validator: validate_JobsGet_564647, base: "",
                                url: url_JobsGet_564648, schemes: {Scheme.Https})
type
  Call_JobsCancel_564659 = ref object of OpenApiRestCall_563565
proc url_JobsCancel_564661(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsCancel_564660(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a job on the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   jobName: JString (required)
  ##          : The jobName.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564662 = path.getOrDefault("subscriptionId")
  valid_564662 = validateParameter(valid_564662, JString, required = true,
                                 default = nil)
  if valid_564662 != nil:
    section.add "subscriptionId", valid_564662
  var valid_564663 = path.getOrDefault("deviceName")
  valid_564663 = validateParameter(valid_564663, JString, required = true,
                                 default = nil)
  if valid_564663 != nil:
    section.add "deviceName", valid_564663
  var valid_564664 = path.getOrDefault("resourceGroupName")
  valid_564664 = validateParameter(valid_564664, JString, required = true,
                                 default = nil)
  if valid_564664 != nil:
    section.add "resourceGroupName", valid_564664
  var valid_564665 = path.getOrDefault("managerName")
  valid_564665 = validateParameter(valid_564665, JString, required = true,
                                 default = nil)
  if valid_564665 != nil:
    section.add "managerName", valid_564665
  var valid_564666 = path.getOrDefault("jobName")
  valid_564666 = validateParameter(valid_564666, JString, required = true,
                                 default = nil)
  if valid_564666 != nil:
    section.add "jobName", valid_564666
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564667 = query.getOrDefault("api-version")
  valid_564667 = validateParameter(valid_564667, JString, required = true,
                                 default = nil)
  if valid_564667 != nil:
    section.add "api-version", valid_564667
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564668: Call_JobsCancel_564659; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a job on the device.
  ## 
  let valid = call_564668.validator(path, query, header, formData, body)
  let scheme = call_564668.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564668.url(scheme.get, call_564668.host, call_564668.base,
                         call_564668.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564668, url, valid)

proc call*(call_564669: Call_JobsCancel_564659; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; jobName: string): Recallable =
  ## jobsCancel
  ## Cancels a job on the device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   jobName: string (required)
  ##          : The jobName.
  var path_564670 = newJObject()
  var query_564671 = newJObject()
  add(query_564671, "api-version", newJString(apiVersion))
  add(path_564670, "subscriptionId", newJString(subscriptionId))
  add(path_564670, "deviceName", newJString(deviceName))
  add(path_564670, "resourceGroupName", newJString(resourceGroupName))
  add(path_564670, "managerName", newJString(managerName))
  add(path_564670, "jobName", newJString(jobName))
  result = call_564669.call(path_564670, query_564671, nil, nil, nil)

var jobsCancel* = Call_JobsCancel_564659(name: "jobsCancel",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/jobs/{jobName}/cancel",
                                      validator: validate_JobsCancel_564660,
                                      base: "", url: url_JobsCancel_564661,
                                      schemes: {Scheme.Https})
type
  Call_DevicesListFailoverSets_564672 = ref object of OpenApiRestCall_563565
proc url_DevicesListFailoverSets_564674(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/listFailoverSets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesListFailoverSets_564673(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all failover sets for a given device and their eligibility for participating in a failover. A failover set refers to a set of volume containers that need to be failed-over as a single unit to maintain data integrity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564675 = path.getOrDefault("subscriptionId")
  valid_564675 = validateParameter(valid_564675, JString, required = true,
                                 default = nil)
  if valid_564675 != nil:
    section.add "subscriptionId", valid_564675
  var valid_564676 = path.getOrDefault("deviceName")
  valid_564676 = validateParameter(valid_564676, JString, required = true,
                                 default = nil)
  if valid_564676 != nil:
    section.add "deviceName", valid_564676
  var valid_564677 = path.getOrDefault("resourceGroupName")
  valid_564677 = validateParameter(valid_564677, JString, required = true,
                                 default = nil)
  if valid_564677 != nil:
    section.add "resourceGroupName", valid_564677
  var valid_564678 = path.getOrDefault("managerName")
  valid_564678 = validateParameter(valid_564678, JString, required = true,
                                 default = nil)
  if valid_564678 != nil:
    section.add "managerName", valid_564678
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564679 = query.getOrDefault("api-version")
  valid_564679 = validateParameter(valid_564679, JString, required = true,
                                 default = nil)
  if valid_564679 != nil:
    section.add "api-version", valid_564679
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564680: Call_DevicesListFailoverSets_564672; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all failover sets for a given device and their eligibility for participating in a failover. A failover set refers to a set of volume containers that need to be failed-over as a single unit to maintain data integrity.
  ## 
  let valid = call_564680.validator(path, query, header, formData, body)
  let scheme = call_564680.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564680.url(scheme.get, call_564680.host, call_564680.base,
                         call_564680.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564680, url, valid)

proc call*(call_564681: Call_DevicesListFailoverSets_564672; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## devicesListFailoverSets
  ## Returns all failover sets for a given device and their eligibility for participating in a failover. A failover set refers to a set of volume containers that need to be failed-over as a single unit to maintain data integrity.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564682 = newJObject()
  var query_564683 = newJObject()
  add(query_564683, "api-version", newJString(apiVersion))
  add(path_564682, "subscriptionId", newJString(subscriptionId))
  add(path_564682, "deviceName", newJString(deviceName))
  add(path_564682, "resourceGroupName", newJString(resourceGroupName))
  add(path_564682, "managerName", newJString(managerName))
  result = call_564681.call(path_564682, query_564683, nil, nil, nil)

var devicesListFailoverSets* = Call_DevicesListFailoverSets_564672(
    name: "devicesListFailoverSets", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/listFailoverSets",
    validator: validate_DevicesListFailoverSets_564673, base: "",
    url: url_DevicesListFailoverSets_564674, schemes: {Scheme.Https})
type
  Call_DevicesListMetrics_564684 = ref object of OpenApiRestCall_563565
proc url_DevicesListMetrics_564686(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesListMetrics_564685(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the metrics for the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564687 = path.getOrDefault("subscriptionId")
  valid_564687 = validateParameter(valid_564687, JString, required = true,
                                 default = nil)
  if valid_564687 != nil:
    section.add "subscriptionId", valid_564687
  var valid_564688 = path.getOrDefault("deviceName")
  valid_564688 = validateParameter(valid_564688, JString, required = true,
                                 default = nil)
  if valid_564688 != nil:
    section.add "deviceName", valid_564688
  var valid_564689 = path.getOrDefault("resourceGroupName")
  valid_564689 = validateParameter(valid_564689, JString, required = true,
                                 default = nil)
  if valid_564689 != nil:
    section.add "resourceGroupName", valid_564689
  var valid_564690 = path.getOrDefault("managerName")
  valid_564690 = validateParameter(valid_564690, JString, required = true,
                                 default = nil)
  if valid_564690 != nil:
    section.add "managerName", valid_564690
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString (required)
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564691 = query.getOrDefault("api-version")
  valid_564691 = validateParameter(valid_564691, JString, required = true,
                                 default = nil)
  if valid_564691 != nil:
    section.add "api-version", valid_564691
  var valid_564692 = query.getOrDefault("$filter")
  valid_564692 = validateParameter(valid_564692, JString, required = true,
                                 default = nil)
  if valid_564692 != nil:
    section.add "$filter", valid_564692
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564693: Call_DevicesListMetrics_564684; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metrics for the specified device.
  ## 
  let valid = call_564693.validator(path, query, header, formData, body)
  let scheme = call_564693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564693.url(scheme.get, call_564693.host, call_564693.base,
                         call_564693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564693, url, valid)

proc call*(call_564694: Call_DevicesListMetrics_564684; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; Filter: string): Recallable =
  ## devicesListMetrics
  ## Gets the metrics for the specified device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   Filter: string (required)
  ##         : OData Filter options
  var path_564695 = newJObject()
  var query_564696 = newJObject()
  add(query_564696, "api-version", newJString(apiVersion))
  add(path_564695, "subscriptionId", newJString(subscriptionId))
  add(path_564695, "deviceName", newJString(deviceName))
  add(path_564695, "resourceGroupName", newJString(resourceGroupName))
  add(path_564695, "managerName", newJString(managerName))
  add(query_564696, "$filter", newJString(Filter))
  result = call_564694.call(path_564695, query_564696, nil, nil, nil)

var devicesListMetrics* = Call_DevicesListMetrics_564684(
    name: "devicesListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/metrics",
    validator: validate_DevicesListMetrics_564685, base: "",
    url: url_DevicesListMetrics_564686, schemes: {Scheme.Https})
type
  Call_DevicesListMetricDefinition_564697 = ref object of OpenApiRestCall_563565
proc url_DevicesListMetricDefinition_564699(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/metricsDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesListMetricDefinition_564698(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the metric definitions for the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564700 = path.getOrDefault("subscriptionId")
  valid_564700 = validateParameter(valid_564700, JString, required = true,
                                 default = nil)
  if valid_564700 != nil:
    section.add "subscriptionId", valid_564700
  var valid_564701 = path.getOrDefault("deviceName")
  valid_564701 = validateParameter(valid_564701, JString, required = true,
                                 default = nil)
  if valid_564701 != nil:
    section.add "deviceName", valid_564701
  var valid_564702 = path.getOrDefault("resourceGroupName")
  valid_564702 = validateParameter(valid_564702, JString, required = true,
                                 default = nil)
  if valid_564702 != nil:
    section.add "resourceGroupName", valid_564702
  var valid_564703 = path.getOrDefault("managerName")
  valid_564703 = validateParameter(valid_564703, JString, required = true,
                                 default = nil)
  if valid_564703 != nil:
    section.add "managerName", valid_564703
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564704 = query.getOrDefault("api-version")
  valid_564704 = validateParameter(valid_564704, JString, required = true,
                                 default = nil)
  if valid_564704 != nil:
    section.add "api-version", valid_564704
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564705: Call_DevicesListMetricDefinition_564697; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metric definitions for the specified device.
  ## 
  let valid = call_564705.validator(path, query, header, formData, body)
  let scheme = call_564705.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564705.url(scheme.get, call_564705.host, call_564705.base,
                         call_564705.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564705, url, valid)

proc call*(call_564706: Call_DevicesListMetricDefinition_564697;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## devicesListMetricDefinition
  ## Gets the metric definitions for the specified device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564707 = newJObject()
  var query_564708 = newJObject()
  add(query_564708, "api-version", newJString(apiVersion))
  add(path_564707, "subscriptionId", newJString(subscriptionId))
  add(path_564707, "deviceName", newJString(deviceName))
  add(path_564707, "resourceGroupName", newJString(resourceGroupName))
  add(path_564707, "managerName", newJString(managerName))
  result = call_564706.call(path_564707, query_564708, nil, nil, nil)

var devicesListMetricDefinition* = Call_DevicesListMetricDefinition_564697(
    name: "devicesListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/metricsDefinitions",
    validator: validate_DevicesListMetricDefinition_564698, base: "",
    url: url_DevicesListMetricDefinition_564699, schemes: {Scheme.Https})
type
  Call_DeviceSettingsGetNetworkSettings_564709 = ref object of OpenApiRestCall_563565
proc url_DeviceSettingsGetNetworkSettings_564711(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/networkSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSettingsGetNetworkSettings_564710(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the network settings of the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564712 = path.getOrDefault("subscriptionId")
  valid_564712 = validateParameter(valid_564712, JString, required = true,
                                 default = nil)
  if valid_564712 != nil:
    section.add "subscriptionId", valid_564712
  var valid_564713 = path.getOrDefault("deviceName")
  valid_564713 = validateParameter(valid_564713, JString, required = true,
                                 default = nil)
  if valid_564713 != nil:
    section.add "deviceName", valid_564713
  var valid_564714 = path.getOrDefault("resourceGroupName")
  valid_564714 = validateParameter(valid_564714, JString, required = true,
                                 default = nil)
  if valid_564714 != nil:
    section.add "resourceGroupName", valid_564714
  var valid_564715 = path.getOrDefault("managerName")
  valid_564715 = validateParameter(valid_564715, JString, required = true,
                                 default = nil)
  if valid_564715 != nil:
    section.add "managerName", valid_564715
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564716 = query.getOrDefault("api-version")
  valid_564716 = validateParameter(valid_564716, JString, required = true,
                                 default = nil)
  if valid_564716 != nil:
    section.add "api-version", valid_564716
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564717: Call_DeviceSettingsGetNetworkSettings_564709;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the network settings of the specified device.
  ## 
  let valid = call_564717.validator(path, query, header, formData, body)
  let scheme = call_564717.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564717.url(scheme.get, call_564717.host, call_564717.base,
                         call_564717.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564717, url, valid)

proc call*(call_564718: Call_DeviceSettingsGetNetworkSettings_564709;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## deviceSettingsGetNetworkSettings
  ## Gets the network settings of the specified device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564719 = newJObject()
  var query_564720 = newJObject()
  add(query_564720, "api-version", newJString(apiVersion))
  add(path_564719, "subscriptionId", newJString(subscriptionId))
  add(path_564719, "deviceName", newJString(deviceName))
  add(path_564719, "resourceGroupName", newJString(resourceGroupName))
  add(path_564719, "managerName", newJString(managerName))
  result = call_564718.call(path_564719, query_564720, nil, nil, nil)

var deviceSettingsGetNetworkSettings* = Call_DeviceSettingsGetNetworkSettings_564709(
    name: "deviceSettingsGetNetworkSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/networkSettings/default",
    validator: validate_DeviceSettingsGetNetworkSettings_564710, base: "",
    url: url_DeviceSettingsGetNetworkSettings_564711, schemes: {Scheme.Https})
type
  Call_DeviceSettingsUpdateNetworkSettings_564721 = ref object of OpenApiRestCall_563565
proc url_DeviceSettingsUpdateNetworkSettings_564723(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/networkSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSettingsUpdateNetworkSettings_564722(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the network settings on the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564724 = path.getOrDefault("subscriptionId")
  valid_564724 = validateParameter(valid_564724, JString, required = true,
                                 default = nil)
  if valid_564724 != nil:
    section.add "subscriptionId", valid_564724
  var valid_564725 = path.getOrDefault("deviceName")
  valid_564725 = validateParameter(valid_564725, JString, required = true,
                                 default = nil)
  if valid_564725 != nil:
    section.add "deviceName", valid_564725
  var valid_564726 = path.getOrDefault("resourceGroupName")
  valid_564726 = validateParameter(valid_564726, JString, required = true,
                                 default = nil)
  if valid_564726 != nil:
    section.add "resourceGroupName", valid_564726
  var valid_564727 = path.getOrDefault("managerName")
  valid_564727 = validateParameter(valid_564727, JString, required = true,
                                 default = nil)
  if valid_564727 != nil:
    section.add "managerName", valid_564727
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564728 = query.getOrDefault("api-version")
  valid_564728 = validateParameter(valid_564728, JString, required = true,
                                 default = nil)
  if valid_564728 != nil:
    section.add "api-version", valid_564728
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The network settings to be updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564730: Call_DeviceSettingsUpdateNetworkSettings_564721;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the network settings on the specified device.
  ## 
  let valid = call_564730.validator(path, query, header, formData, body)
  let scheme = call_564730.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564730.url(scheme.get, call_564730.host, call_564730.base,
                         call_564730.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564730, url, valid)

proc call*(call_564731: Call_DeviceSettingsUpdateNetworkSettings_564721;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string; parameters: JsonNode): Recallable =
  ## deviceSettingsUpdateNetworkSettings
  ## Updates the network settings on the specified device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : The network settings to be updated.
  var path_564732 = newJObject()
  var query_564733 = newJObject()
  var body_564734 = newJObject()
  add(query_564733, "api-version", newJString(apiVersion))
  add(path_564732, "subscriptionId", newJString(subscriptionId))
  add(path_564732, "deviceName", newJString(deviceName))
  add(path_564732, "resourceGroupName", newJString(resourceGroupName))
  add(path_564732, "managerName", newJString(managerName))
  if parameters != nil:
    body_564734 = parameters
  result = call_564731.call(path_564732, query_564733, nil, nil, body_564734)

var deviceSettingsUpdateNetworkSettings* = Call_DeviceSettingsUpdateNetworkSettings_564721(
    name: "deviceSettingsUpdateNetworkSettings", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/networkSettings/default",
    validator: validate_DeviceSettingsUpdateNetworkSettings_564722, base: "",
    url: url_DeviceSettingsUpdateNetworkSettings_564723, schemes: {Scheme.Https})
type
  Call_ManagersGetDevicePublicEncryptionKey_564735 = ref object of OpenApiRestCall_563565
proc url_ManagersGetDevicePublicEncryptionKey_564737(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/publicEncryptionKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersGetDevicePublicEncryptionKey_564736(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the public encryption key of the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564738 = path.getOrDefault("subscriptionId")
  valid_564738 = validateParameter(valid_564738, JString, required = true,
                                 default = nil)
  if valid_564738 != nil:
    section.add "subscriptionId", valid_564738
  var valid_564739 = path.getOrDefault("deviceName")
  valid_564739 = validateParameter(valid_564739, JString, required = true,
                                 default = nil)
  if valid_564739 != nil:
    section.add "deviceName", valid_564739
  var valid_564740 = path.getOrDefault("resourceGroupName")
  valid_564740 = validateParameter(valid_564740, JString, required = true,
                                 default = nil)
  if valid_564740 != nil:
    section.add "resourceGroupName", valid_564740
  var valid_564741 = path.getOrDefault("managerName")
  valid_564741 = validateParameter(valid_564741, JString, required = true,
                                 default = nil)
  if valid_564741 != nil:
    section.add "managerName", valid_564741
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564742 = query.getOrDefault("api-version")
  valid_564742 = validateParameter(valid_564742, JString, required = true,
                                 default = nil)
  if valid_564742 != nil:
    section.add "api-version", valid_564742
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564743: Call_ManagersGetDevicePublicEncryptionKey_564735;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the public encryption key of the device.
  ## 
  let valid = call_564743.validator(path, query, header, formData, body)
  let scheme = call_564743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564743.url(scheme.get, call_564743.host, call_564743.base,
                         call_564743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564743, url, valid)

proc call*(call_564744: Call_ManagersGetDevicePublicEncryptionKey_564735;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## managersGetDevicePublicEncryptionKey
  ## Returns the public encryption key of the device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564745 = newJObject()
  var query_564746 = newJObject()
  add(query_564746, "api-version", newJString(apiVersion))
  add(path_564745, "subscriptionId", newJString(subscriptionId))
  add(path_564745, "deviceName", newJString(deviceName))
  add(path_564745, "resourceGroupName", newJString(resourceGroupName))
  add(path_564745, "managerName", newJString(managerName))
  result = call_564744.call(path_564745, query_564746, nil, nil, nil)

var managersGetDevicePublicEncryptionKey* = Call_ManagersGetDevicePublicEncryptionKey_564735(
    name: "managersGetDevicePublicEncryptionKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/publicEncryptionKey",
    validator: validate_ManagersGetDevicePublicEncryptionKey_564736, base: "",
    url: url_ManagersGetDevicePublicEncryptionKey_564737, schemes: {Scheme.Https})
type
  Call_DevicesScanForUpdates_564747 = ref object of OpenApiRestCall_563565
proc url_DevicesScanForUpdates_564749(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/scanForUpdates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesScanForUpdates_564748(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Scans for updates on the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564750 = path.getOrDefault("subscriptionId")
  valid_564750 = validateParameter(valid_564750, JString, required = true,
                                 default = nil)
  if valid_564750 != nil:
    section.add "subscriptionId", valid_564750
  var valid_564751 = path.getOrDefault("deviceName")
  valid_564751 = validateParameter(valid_564751, JString, required = true,
                                 default = nil)
  if valid_564751 != nil:
    section.add "deviceName", valid_564751
  var valid_564752 = path.getOrDefault("resourceGroupName")
  valid_564752 = validateParameter(valid_564752, JString, required = true,
                                 default = nil)
  if valid_564752 != nil:
    section.add "resourceGroupName", valid_564752
  var valid_564753 = path.getOrDefault("managerName")
  valid_564753 = validateParameter(valid_564753, JString, required = true,
                                 default = nil)
  if valid_564753 != nil:
    section.add "managerName", valid_564753
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564754 = query.getOrDefault("api-version")
  valid_564754 = validateParameter(valid_564754, JString, required = true,
                                 default = nil)
  if valid_564754 != nil:
    section.add "api-version", valid_564754
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564755: Call_DevicesScanForUpdates_564747; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Scans for updates on the device.
  ## 
  let valid = call_564755.validator(path, query, header, formData, body)
  let scheme = call_564755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564755.url(scheme.get, call_564755.host, call_564755.base,
                         call_564755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564755, url, valid)

proc call*(call_564756: Call_DevicesScanForUpdates_564747; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## devicesScanForUpdates
  ## Scans for updates on the device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564757 = newJObject()
  var query_564758 = newJObject()
  add(query_564758, "api-version", newJString(apiVersion))
  add(path_564757, "subscriptionId", newJString(subscriptionId))
  add(path_564757, "deviceName", newJString(deviceName))
  add(path_564757, "resourceGroupName", newJString(resourceGroupName))
  add(path_564757, "managerName", newJString(managerName))
  result = call_564756.call(path_564757, query_564758, nil, nil, nil)

var devicesScanForUpdates* = Call_DevicesScanForUpdates_564747(
    name: "devicesScanForUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/scanForUpdates",
    validator: validate_DevicesScanForUpdates_564748, base: "",
    url: url_DevicesScanForUpdates_564749, schemes: {Scheme.Https})
type
  Call_DeviceSettingsGetSecuritySettings_564759 = ref object of OpenApiRestCall_563565
proc url_DeviceSettingsGetSecuritySettings_564761(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/securitySettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSettingsGetSecuritySettings_564760(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the Security properties of the specified device name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564762 = path.getOrDefault("subscriptionId")
  valid_564762 = validateParameter(valid_564762, JString, required = true,
                                 default = nil)
  if valid_564762 != nil:
    section.add "subscriptionId", valid_564762
  var valid_564763 = path.getOrDefault("deviceName")
  valid_564763 = validateParameter(valid_564763, JString, required = true,
                                 default = nil)
  if valid_564763 != nil:
    section.add "deviceName", valid_564763
  var valid_564764 = path.getOrDefault("resourceGroupName")
  valid_564764 = validateParameter(valid_564764, JString, required = true,
                                 default = nil)
  if valid_564764 != nil:
    section.add "resourceGroupName", valid_564764
  var valid_564765 = path.getOrDefault("managerName")
  valid_564765 = validateParameter(valid_564765, JString, required = true,
                                 default = nil)
  if valid_564765 != nil:
    section.add "managerName", valid_564765
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564766 = query.getOrDefault("api-version")
  valid_564766 = validateParameter(valid_564766, JString, required = true,
                                 default = nil)
  if valid_564766 != nil:
    section.add "api-version", valid_564766
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564767: Call_DeviceSettingsGetSecuritySettings_564759;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the Security properties of the specified device name.
  ## 
  let valid = call_564767.validator(path, query, header, formData, body)
  let scheme = call_564767.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564767.url(scheme.get, call_564767.host, call_564767.base,
                         call_564767.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564767, url, valid)

proc call*(call_564768: Call_DeviceSettingsGetSecuritySettings_564759;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## deviceSettingsGetSecuritySettings
  ## Returns the Security properties of the specified device name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564769 = newJObject()
  var query_564770 = newJObject()
  add(query_564770, "api-version", newJString(apiVersion))
  add(path_564769, "subscriptionId", newJString(subscriptionId))
  add(path_564769, "deviceName", newJString(deviceName))
  add(path_564769, "resourceGroupName", newJString(resourceGroupName))
  add(path_564769, "managerName", newJString(managerName))
  result = call_564768.call(path_564769, query_564770, nil, nil, nil)

var deviceSettingsGetSecuritySettings* = Call_DeviceSettingsGetSecuritySettings_564759(
    name: "deviceSettingsGetSecuritySettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/securitySettings/default",
    validator: validate_DeviceSettingsGetSecuritySettings_564760, base: "",
    url: url_DeviceSettingsGetSecuritySettings_564761, schemes: {Scheme.Https})
type
  Call_DeviceSettingsUpdateSecuritySettings_564771 = ref object of OpenApiRestCall_563565
proc url_DeviceSettingsUpdateSecuritySettings_564773(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/securitySettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSettingsUpdateSecuritySettings_564772(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch Security properties of the specified device name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564774 = path.getOrDefault("subscriptionId")
  valid_564774 = validateParameter(valid_564774, JString, required = true,
                                 default = nil)
  if valid_564774 != nil:
    section.add "subscriptionId", valid_564774
  var valid_564775 = path.getOrDefault("deviceName")
  valid_564775 = validateParameter(valid_564775, JString, required = true,
                                 default = nil)
  if valid_564775 != nil:
    section.add "deviceName", valid_564775
  var valid_564776 = path.getOrDefault("resourceGroupName")
  valid_564776 = validateParameter(valid_564776, JString, required = true,
                                 default = nil)
  if valid_564776 != nil:
    section.add "resourceGroupName", valid_564776
  var valid_564777 = path.getOrDefault("managerName")
  valid_564777 = validateParameter(valid_564777, JString, required = true,
                                 default = nil)
  if valid_564777 != nil:
    section.add "managerName", valid_564777
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564778 = query.getOrDefault("api-version")
  valid_564778 = validateParameter(valid_564778, JString, required = true,
                                 default = nil)
  if valid_564778 != nil:
    section.add "api-version", valid_564778
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The security settings properties to be patched.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564780: Call_DeviceSettingsUpdateSecuritySettings_564771;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Patch Security properties of the specified device name.
  ## 
  let valid = call_564780.validator(path, query, header, formData, body)
  let scheme = call_564780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564780.url(scheme.get, call_564780.host, call_564780.base,
                         call_564780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564780, url, valid)

proc call*(call_564781: Call_DeviceSettingsUpdateSecuritySettings_564771;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string; parameters: JsonNode): Recallable =
  ## deviceSettingsUpdateSecuritySettings
  ## Patch Security properties of the specified device name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : The security settings properties to be patched.
  var path_564782 = newJObject()
  var query_564783 = newJObject()
  var body_564784 = newJObject()
  add(query_564783, "api-version", newJString(apiVersion))
  add(path_564782, "subscriptionId", newJString(subscriptionId))
  add(path_564782, "deviceName", newJString(deviceName))
  add(path_564782, "resourceGroupName", newJString(resourceGroupName))
  add(path_564782, "managerName", newJString(managerName))
  if parameters != nil:
    body_564784 = parameters
  result = call_564781.call(path_564782, query_564783, nil, nil, body_564784)

var deviceSettingsUpdateSecuritySettings* = Call_DeviceSettingsUpdateSecuritySettings_564771(
    name: "deviceSettingsUpdateSecuritySettings", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/securitySettings/default",
    validator: validate_DeviceSettingsUpdateSecuritySettings_564772, base: "",
    url: url_DeviceSettingsUpdateSecuritySettings_564773, schemes: {Scheme.Https})
type
  Call_DeviceSettingsSyncRemotemanagementCertificate_564785 = ref object of OpenApiRestCall_563565
proc url_DeviceSettingsSyncRemotemanagementCertificate_564787(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"), (kind: ConstantSegment,
        value: "/securitySettings/default/syncRemoteManagementCertificate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSettingsSyncRemotemanagementCertificate_564786(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## sync Remote management Certificate between appliance and Service
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564788 = path.getOrDefault("subscriptionId")
  valid_564788 = validateParameter(valid_564788, JString, required = true,
                                 default = nil)
  if valid_564788 != nil:
    section.add "subscriptionId", valid_564788
  var valid_564789 = path.getOrDefault("deviceName")
  valid_564789 = validateParameter(valid_564789, JString, required = true,
                                 default = nil)
  if valid_564789 != nil:
    section.add "deviceName", valid_564789
  var valid_564790 = path.getOrDefault("resourceGroupName")
  valid_564790 = validateParameter(valid_564790, JString, required = true,
                                 default = nil)
  if valid_564790 != nil:
    section.add "resourceGroupName", valid_564790
  var valid_564791 = path.getOrDefault("managerName")
  valid_564791 = validateParameter(valid_564791, JString, required = true,
                                 default = nil)
  if valid_564791 != nil:
    section.add "managerName", valid_564791
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564792 = query.getOrDefault("api-version")
  valid_564792 = validateParameter(valid_564792, JString, required = true,
                                 default = nil)
  if valid_564792 != nil:
    section.add "api-version", valid_564792
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564793: Call_DeviceSettingsSyncRemotemanagementCertificate_564785;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## sync Remote management Certificate between appliance and Service
  ## 
  let valid = call_564793.validator(path, query, header, formData, body)
  let scheme = call_564793.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564793.url(scheme.get, call_564793.host, call_564793.base,
                         call_564793.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564793, url, valid)

proc call*(call_564794: Call_DeviceSettingsSyncRemotemanagementCertificate_564785;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## deviceSettingsSyncRemotemanagementCertificate
  ## sync Remote management Certificate between appliance and Service
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564795 = newJObject()
  var query_564796 = newJObject()
  add(query_564796, "api-version", newJString(apiVersion))
  add(path_564795, "subscriptionId", newJString(subscriptionId))
  add(path_564795, "deviceName", newJString(deviceName))
  add(path_564795, "resourceGroupName", newJString(resourceGroupName))
  add(path_564795, "managerName", newJString(managerName))
  result = call_564794.call(path_564795, query_564796, nil, nil, nil)

var deviceSettingsSyncRemotemanagementCertificate* = Call_DeviceSettingsSyncRemotemanagementCertificate_564785(
    name: "deviceSettingsSyncRemotemanagementCertificate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/securitySettings/default/syncRemoteManagementCertificate",
    validator: validate_DeviceSettingsSyncRemotemanagementCertificate_564786,
    base: "", url: url_DeviceSettingsSyncRemotemanagementCertificate_564787,
    schemes: {Scheme.Https})
type
  Call_AlertsSendTestEmail_564797 = ref object of OpenApiRestCall_563565
proc url_AlertsSendTestEmail_564799(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/sendTestAlertEmail")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsSendTestEmail_564798(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Sends a test alert email.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564800 = path.getOrDefault("subscriptionId")
  valid_564800 = validateParameter(valid_564800, JString, required = true,
                                 default = nil)
  if valid_564800 != nil:
    section.add "subscriptionId", valid_564800
  var valid_564801 = path.getOrDefault("deviceName")
  valid_564801 = validateParameter(valid_564801, JString, required = true,
                                 default = nil)
  if valid_564801 != nil:
    section.add "deviceName", valid_564801
  var valid_564802 = path.getOrDefault("resourceGroupName")
  valid_564802 = validateParameter(valid_564802, JString, required = true,
                                 default = nil)
  if valid_564802 != nil:
    section.add "resourceGroupName", valid_564802
  var valid_564803 = path.getOrDefault("managerName")
  valid_564803 = validateParameter(valid_564803, JString, required = true,
                                 default = nil)
  if valid_564803 != nil:
    section.add "managerName", valid_564803
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564804 = query.getOrDefault("api-version")
  valid_564804 = validateParameter(valid_564804, JString, required = true,
                                 default = nil)
  if valid_564804 != nil:
    section.add "api-version", valid_564804
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The send test alert email request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564806: Call_AlertsSendTestEmail_564797; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a test alert email.
  ## 
  let valid = call_564806.validator(path, query, header, formData, body)
  let scheme = call_564806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564806.url(scheme.get, call_564806.host, call_564806.base,
                         call_564806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564806, url, valid)

proc call*(call_564807: Call_AlertsSendTestEmail_564797; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; parameters: JsonNode): Recallable =
  ## alertsSendTestEmail
  ## Sends a test alert email.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : The send test alert email request.
  var path_564808 = newJObject()
  var query_564809 = newJObject()
  var body_564810 = newJObject()
  add(query_564809, "api-version", newJString(apiVersion))
  add(path_564808, "subscriptionId", newJString(subscriptionId))
  add(path_564808, "deviceName", newJString(deviceName))
  add(path_564808, "resourceGroupName", newJString(resourceGroupName))
  add(path_564808, "managerName", newJString(managerName))
  if parameters != nil:
    body_564810 = parameters
  result = call_564807.call(path_564808, query_564809, nil, nil, body_564810)

var alertsSendTestEmail* = Call_AlertsSendTestEmail_564797(
    name: "alertsSendTestEmail", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/sendTestAlertEmail",
    validator: validate_AlertsSendTestEmail_564798, base: "",
    url: url_AlertsSendTestEmail_564799, schemes: {Scheme.Https})
type
  Call_DeviceSettingsCreateOrUpdateTimeSettings_564823 = ref object of OpenApiRestCall_563565
proc url_DeviceSettingsCreateOrUpdateTimeSettings_564825(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/timeSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSettingsCreateOrUpdateTimeSettings_564824(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the time settings of the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564826 = path.getOrDefault("subscriptionId")
  valid_564826 = validateParameter(valid_564826, JString, required = true,
                                 default = nil)
  if valid_564826 != nil:
    section.add "subscriptionId", valid_564826
  var valid_564827 = path.getOrDefault("deviceName")
  valid_564827 = validateParameter(valid_564827, JString, required = true,
                                 default = nil)
  if valid_564827 != nil:
    section.add "deviceName", valid_564827
  var valid_564828 = path.getOrDefault("resourceGroupName")
  valid_564828 = validateParameter(valid_564828, JString, required = true,
                                 default = nil)
  if valid_564828 != nil:
    section.add "resourceGroupName", valid_564828
  var valid_564829 = path.getOrDefault("managerName")
  valid_564829 = validateParameter(valid_564829, JString, required = true,
                                 default = nil)
  if valid_564829 != nil:
    section.add "managerName", valid_564829
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564830 = query.getOrDefault("api-version")
  valid_564830 = validateParameter(valid_564830, JString, required = true,
                                 default = nil)
  if valid_564830 != nil:
    section.add "api-version", valid_564830
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The time settings to be added or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564832: Call_DeviceSettingsCreateOrUpdateTimeSettings_564823;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the time settings of the specified device.
  ## 
  let valid = call_564832.validator(path, query, header, formData, body)
  let scheme = call_564832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564832.url(scheme.get, call_564832.host, call_564832.base,
                         call_564832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564832, url, valid)

proc call*(call_564833: Call_DeviceSettingsCreateOrUpdateTimeSettings_564823;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string; parameters: JsonNode): Recallable =
  ## deviceSettingsCreateOrUpdateTimeSettings
  ## Creates or updates the time settings of the specified device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : The time settings to be added or updated.
  var path_564834 = newJObject()
  var query_564835 = newJObject()
  var body_564836 = newJObject()
  add(query_564835, "api-version", newJString(apiVersion))
  add(path_564834, "subscriptionId", newJString(subscriptionId))
  add(path_564834, "deviceName", newJString(deviceName))
  add(path_564834, "resourceGroupName", newJString(resourceGroupName))
  add(path_564834, "managerName", newJString(managerName))
  if parameters != nil:
    body_564836 = parameters
  result = call_564833.call(path_564834, query_564835, nil, nil, body_564836)

var deviceSettingsCreateOrUpdateTimeSettings* = Call_DeviceSettingsCreateOrUpdateTimeSettings_564823(
    name: "deviceSettingsCreateOrUpdateTimeSettings", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/timeSettings/default",
    validator: validate_DeviceSettingsCreateOrUpdateTimeSettings_564824, base: "",
    url: url_DeviceSettingsCreateOrUpdateTimeSettings_564825,
    schemes: {Scheme.Https})
type
  Call_DeviceSettingsGetTimeSettings_564811 = ref object of OpenApiRestCall_563565
proc url_DeviceSettingsGetTimeSettings_564813(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/timeSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSettingsGetTimeSettings_564812(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the time settings of the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564814 = path.getOrDefault("subscriptionId")
  valid_564814 = validateParameter(valid_564814, JString, required = true,
                                 default = nil)
  if valid_564814 != nil:
    section.add "subscriptionId", valid_564814
  var valid_564815 = path.getOrDefault("deviceName")
  valid_564815 = validateParameter(valid_564815, JString, required = true,
                                 default = nil)
  if valid_564815 != nil:
    section.add "deviceName", valid_564815
  var valid_564816 = path.getOrDefault("resourceGroupName")
  valid_564816 = validateParameter(valid_564816, JString, required = true,
                                 default = nil)
  if valid_564816 != nil:
    section.add "resourceGroupName", valid_564816
  var valid_564817 = path.getOrDefault("managerName")
  valid_564817 = validateParameter(valid_564817, JString, required = true,
                                 default = nil)
  if valid_564817 != nil:
    section.add "managerName", valid_564817
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564818 = query.getOrDefault("api-version")
  valid_564818 = validateParameter(valid_564818, JString, required = true,
                                 default = nil)
  if valid_564818 != nil:
    section.add "api-version", valid_564818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564819: Call_DeviceSettingsGetTimeSettings_564811; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the time settings of the specified device.
  ## 
  let valid = call_564819.validator(path, query, header, formData, body)
  let scheme = call_564819.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564819.url(scheme.get, call_564819.host, call_564819.base,
                         call_564819.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564819, url, valid)

proc call*(call_564820: Call_DeviceSettingsGetTimeSettings_564811;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## deviceSettingsGetTimeSettings
  ## Gets the time settings of the specified device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564821 = newJObject()
  var query_564822 = newJObject()
  add(query_564822, "api-version", newJString(apiVersion))
  add(path_564821, "subscriptionId", newJString(subscriptionId))
  add(path_564821, "deviceName", newJString(deviceName))
  add(path_564821, "resourceGroupName", newJString(resourceGroupName))
  add(path_564821, "managerName", newJString(managerName))
  result = call_564820.call(path_564821, query_564822, nil, nil, nil)

var deviceSettingsGetTimeSettings* = Call_DeviceSettingsGetTimeSettings_564811(
    name: "deviceSettingsGetTimeSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/timeSettings/default",
    validator: validate_DeviceSettingsGetTimeSettings_564812, base: "",
    url: url_DeviceSettingsGetTimeSettings_564813, schemes: {Scheme.Https})
type
  Call_DevicesGetUpdateSummary_564837 = ref object of OpenApiRestCall_563565
proc url_DevicesGetUpdateSummary_564839(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/updateSummary/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesGetUpdateSummary_564838(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the update summary of the specified device name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564840 = path.getOrDefault("subscriptionId")
  valid_564840 = validateParameter(valid_564840, JString, required = true,
                                 default = nil)
  if valid_564840 != nil:
    section.add "subscriptionId", valid_564840
  var valid_564841 = path.getOrDefault("deviceName")
  valid_564841 = validateParameter(valid_564841, JString, required = true,
                                 default = nil)
  if valid_564841 != nil:
    section.add "deviceName", valid_564841
  var valid_564842 = path.getOrDefault("resourceGroupName")
  valid_564842 = validateParameter(valid_564842, JString, required = true,
                                 default = nil)
  if valid_564842 != nil:
    section.add "resourceGroupName", valid_564842
  var valid_564843 = path.getOrDefault("managerName")
  valid_564843 = validateParameter(valid_564843, JString, required = true,
                                 default = nil)
  if valid_564843 != nil:
    section.add "managerName", valid_564843
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564844 = query.getOrDefault("api-version")
  valid_564844 = validateParameter(valid_564844, JString, required = true,
                                 default = nil)
  if valid_564844 != nil:
    section.add "api-version", valid_564844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564845: Call_DevicesGetUpdateSummary_564837; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the update summary of the specified device name.
  ## 
  let valid = call_564845.validator(path, query, header, formData, body)
  let scheme = call_564845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564845.url(scheme.get, call_564845.host, call_564845.base,
                         call_564845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564845, url, valid)

proc call*(call_564846: Call_DevicesGetUpdateSummary_564837; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## devicesGetUpdateSummary
  ## Returns the update summary of the specified device name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564847 = newJObject()
  var query_564848 = newJObject()
  add(query_564848, "api-version", newJString(apiVersion))
  add(path_564847, "subscriptionId", newJString(subscriptionId))
  add(path_564847, "deviceName", newJString(deviceName))
  add(path_564847, "resourceGroupName", newJString(resourceGroupName))
  add(path_564847, "managerName", newJString(managerName))
  result = call_564846.call(path_564847, query_564848, nil, nil, nil)

var devicesGetUpdateSummary* = Call_DevicesGetUpdateSummary_564837(
    name: "devicesGetUpdateSummary", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/updateSummary/default",
    validator: validate_DevicesGetUpdateSummary_564838, base: "",
    url: url_DevicesGetUpdateSummary_564839, schemes: {Scheme.Https})
type
  Call_VolumeContainersListByDevice_564849 = ref object of OpenApiRestCall_563565
proc url_VolumeContainersListByDevice_564851(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeContainersListByDevice_564850(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the volume containers in a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564852 = path.getOrDefault("subscriptionId")
  valid_564852 = validateParameter(valid_564852, JString, required = true,
                                 default = nil)
  if valid_564852 != nil:
    section.add "subscriptionId", valid_564852
  var valid_564853 = path.getOrDefault("deviceName")
  valid_564853 = validateParameter(valid_564853, JString, required = true,
                                 default = nil)
  if valid_564853 != nil:
    section.add "deviceName", valid_564853
  var valid_564854 = path.getOrDefault("resourceGroupName")
  valid_564854 = validateParameter(valid_564854, JString, required = true,
                                 default = nil)
  if valid_564854 != nil:
    section.add "resourceGroupName", valid_564854
  var valid_564855 = path.getOrDefault("managerName")
  valid_564855 = validateParameter(valid_564855, JString, required = true,
                                 default = nil)
  if valid_564855 != nil:
    section.add "managerName", valid_564855
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564856 = query.getOrDefault("api-version")
  valid_564856 = validateParameter(valid_564856, JString, required = true,
                                 default = nil)
  if valid_564856 != nil:
    section.add "api-version", valid_564856
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564857: Call_VolumeContainersListByDevice_564849; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the volume containers in a device.
  ## 
  let valid = call_564857.validator(path, query, header, formData, body)
  let scheme = call_564857.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564857.url(scheme.get, call_564857.host, call_564857.base,
                         call_564857.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564857, url, valid)

proc call*(call_564858: Call_VolumeContainersListByDevice_564849;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## volumeContainersListByDevice
  ## Gets all the volume containers in a device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564859 = newJObject()
  var query_564860 = newJObject()
  add(query_564860, "api-version", newJString(apiVersion))
  add(path_564859, "subscriptionId", newJString(subscriptionId))
  add(path_564859, "deviceName", newJString(deviceName))
  add(path_564859, "resourceGroupName", newJString(resourceGroupName))
  add(path_564859, "managerName", newJString(managerName))
  result = call_564858.call(path_564859, query_564860, nil, nil, nil)

var volumeContainersListByDevice* = Call_VolumeContainersListByDevice_564849(
    name: "volumeContainersListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers",
    validator: validate_VolumeContainersListByDevice_564850, base: "",
    url: url_VolumeContainersListByDevice_564851, schemes: {Scheme.Https})
type
  Call_VolumeContainersCreateOrUpdate_564874 = ref object of OpenApiRestCall_563565
proc url_VolumeContainersCreateOrUpdate_564876(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeContainersCreateOrUpdate_564875(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the volume container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeContainerName: JString (required)
  ##                      : The name of the volume container.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `volumeContainerName` field"
  var valid_564877 = path.getOrDefault("volumeContainerName")
  valid_564877 = validateParameter(valid_564877, JString, required = true,
                                 default = nil)
  if valid_564877 != nil:
    section.add "volumeContainerName", valid_564877
  var valid_564878 = path.getOrDefault("subscriptionId")
  valid_564878 = validateParameter(valid_564878, JString, required = true,
                                 default = nil)
  if valid_564878 != nil:
    section.add "subscriptionId", valid_564878
  var valid_564879 = path.getOrDefault("deviceName")
  valid_564879 = validateParameter(valid_564879, JString, required = true,
                                 default = nil)
  if valid_564879 != nil:
    section.add "deviceName", valid_564879
  var valid_564880 = path.getOrDefault("resourceGroupName")
  valid_564880 = validateParameter(valid_564880, JString, required = true,
                                 default = nil)
  if valid_564880 != nil:
    section.add "resourceGroupName", valid_564880
  var valid_564881 = path.getOrDefault("managerName")
  valid_564881 = validateParameter(valid_564881, JString, required = true,
                                 default = nil)
  if valid_564881 != nil:
    section.add "managerName", valid_564881
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564882 = query.getOrDefault("api-version")
  valid_564882 = validateParameter(valid_564882, JString, required = true,
                                 default = nil)
  if valid_564882 != nil:
    section.add "api-version", valid_564882
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The volume container to be added or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564884: Call_VolumeContainersCreateOrUpdate_564874; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the volume container.
  ## 
  let valid = call_564884.validator(path, query, header, formData, body)
  let scheme = call_564884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564884.url(scheme.get, call_564884.host, call_564884.base,
                         call_564884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564884, url, valid)

proc call*(call_564885: Call_VolumeContainersCreateOrUpdate_564874;
          apiVersion: string; volumeContainerName: string; subscriptionId: string;
          deviceName: string; resourceGroupName: string; managerName: string;
          parameters: JsonNode): Recallable =
  ## volumeContainersCreateOrUpdate
  ## Creates or updates the volume container.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   volumeContainerName: string (required)
  ##                      : The name of the volume container.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : The volume container to be added or updated.
  var path_564886 = newJObject()
  var query_564887 = newJObject()
  var body_564888 = newJObject()
  add(query_564887, "api-version", newJString(apiVersion))
  add(path_564886, "volumeContainerName", newJString(volumeContainerName))
  add(path_564886, "subscriptionId", newJString(subscriptionId))
  add(path_564886, "deviceName", newJString(deviceName))
  add(path_564886, "resourceGroupName", newJString(resourceGroupName))
  add(path_564886, "managerName", newJString(managerName))
  if parameters != nil:
    body_564888 = parameters
  result = call_564885.call(path_564886, query_564887, nil, nil, body_564888)

var volumeContainersCreateOrUpdate* = Call_VolumeContainersCreateOrUpdate_564874(
    name: "volumeContainersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}",
    validator: validate_VolumeContainersCreateOrUpdate_564875, base: "",
    url: url_VolumeContainersCreateOrUpdate_564876, schemes: {Scheme.Https})
type
  Call_VolumeContainersGet_564861 = ref object of OpenApiRestCall_563565
proc url_VolumeContainersGet_564863(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeContainersGet_564862(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the properties of the specified volume container name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeContainerName: JString (required)
  ##                      : The name of the volume container.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `volumeContainerName` field"
  var valid_564864 = path.getOrDefault("volumeContainerName")
  valid_564864 = validateParameter(valid_564864, JString, required = true,
                                 default = nil)
  if valid_564864 != nil:
    section.add "volumeContainerName", valid_564864
  var valid_564865 = path.getOrDefault("subscriptionId")
  valid_564865 = validateParameter(valid_564865, JString, required = true,
                                 default = nil)
  if valid_564865 != nil:
    section.add "subscriptionId", valid_564865
  var valid_564866 = path.getOrDefault("deviceName")
  valid_564866 = validateParameter(valid_564866, JString, required = true,
                                 default = nil)
  if valid_564866 != nil:
    section.add "deviceName", valid_564866
  var valid_564867 = path.getOrDefault("resourceGroupName")
  valid_564867 = validateParameter(valid_564867, JString, required = true,
                                 default = nil)
  if valid_564867 != nil:
    section.add "resourceGroupName", valid_564867
  var valid_564868 = path.getOrDefault("managerName")
  valid_564868 = validateParameter(valid_564868, JString, required = true,
                                 default = nil)
  if valid_564868 != nil:
    section.add "managerName", valid_564868
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564869 = query.getOrDefault("api-version")
  valid_564869 = validateParameter(valid_564869, JString, required = true,
                                 default = nil)
  if valid_564869 != nil:
    section.add "api-version", valid_564869
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564870: Call_VolumeContainersGet_564861; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified volume container name.
  ## 
  let valid = call_564870.validator(path, query, header, formData, body)
  let scheme = call_564870.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564870.url(scheme.get, call_564870.host, call_564870.base,
                         call_564870.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564870, url, valid)

proc call*(call_564871: Call_VolumeContainersGet_564861; apiVersion: string;
          volumeContainerName: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## volumeContainersGet
  ## Gets the properties of the specified volume container name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   volumeContainerName: string (required)
  ##                      : The name of the volume container.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564872 = newJObject()
  var query_564873 = newJObject()
  add(query_564873, "api-version", newJString(apiVersion))
  add(path_564872, "volumeContainerName", newJString(volumeContainerName))
  add(path_564872, "subscriptionId", newJString(subscriptionId))
  add(path_564872, "deviceName", newJString(deviceName))
  add(path_564872, "resourceGroupName", newJString(resourceGroupName))
  add(path_564872, "managerName", newJString(managerName))
  result = call_564871.call(path_564872, query_564873, nil, nil, nil)

var volumeContainersGet* = Call_VolumeContainersGet_564861(
    name: "volumeContainersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}",
    validator: validate_VolumeContainersGet_564862, base: "",
    url: url_VolumeContainersGet_564863, schemes: {Scheme.Https})
type
  Call_VolumeContainersDelete_564889 = ref object of OpenApiRestCall_563565
proc url_VolumeContainersDelete_564891(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeContainersDelete_564890(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the volume container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeContainerName: JString (required)
  ##                      : The name of the volume container.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `volumeContainerName` field"
  var valid_564892 = path.getOrDefault("volumeContainerName")
  valid_564892 = validateParameter(valid_564892, JString, required = true,
                                 default = nil)
  if valid_564892 != nil:
    section.add "volumeContainerName", valid_564892
  var valid_564893 = path.getOrDefault("subscriptionId")
  valid_564893 = validateParameter(valid_564893, JString, required = true,
                                 default = nil)
  if valid_564893 != nil:
    section.add "subscriptionId", valid_564893
  var valid_564894 = path.getOrDefault("deviceName")
  valid_564894 = validateParameter(valid_564894, JString, required = true,
                                 default = nil)
  if valid_564894 != nil:
    section.add "deviceName", valid_564894
  var valid_564895 = path.getOrDefault("resourceGroupName")
  valid_564895 = validateParameter(valid_564895, JString, required = true,
                                 default = nil)
  if valid_564895 != nil:
    section.add "resourceGroupName", valid_564895
  var valid_564896 = path.getOrDefault("managerName")
  valid_564896 = validateParameter(valid_564896, JString, required = true,
                                 default = nil)
  if valid_564896 != nil:
    section.add "managerName", valid_564896
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564897 = query.getOrDefault("api-version")
  valid_564897 = validateParameter(valid_564897, JString, required = true,
                                 default = nil)
  if valid_564897 != nil:
    section.add "api-version", valid_564897
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564898: Call_VolumeContainersDelete_564889; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the volume container.
  ## 
  let valid = call_564898.validator(path, query, header, formData, body)
  let scheme = call_564898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564898.url(scheme.get, call_564898.host, call_564898.base,
                         call_564898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564898, url, valid)

proc call*(call_564899: Call_VolumeContainersDelete_564889; apiVersion: string;
          volumeContainerName: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## volumeContainersDelete
  ## Deletes the volume container.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   volumeContainerName: string (required)
  ##                      : The name of the volume container.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564900 = newJObject()
  var query_564901 = newJObject()
  add(query_564901, "api-version", newJString(apiVersion))
  add(path_564900, "volumeContainerName", newJString(volumeContainerName))
  add(path_564900, "subscriptionId", newJString(subscriptionId))
  add(path_564900, "deviceName", newJString(deviceName))
  add(path_564900, "resourceGroupName", newJString(resourceGroupName))
  add(path_564900, "managerName", newJString(managerName))
  result = call_564899.call(path_564900, query_564901, nil, nil, nil)

var volumeContainersDelete* = Call_VolumeContainersDelete_564889(
    name: "volumeContainersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}",
    validator: validate_VolumeContainersDelete_564890, base: "",
    url: url_VolumeContainersDelete_564891, schemes: {Scheme.Https})
type
  Call_VolumeContainersListMetrics_564902 = ref object of OpenApiRestCall_563565
proc url_VolumeContainersListMetrics_564904(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeContainersListMetrics_564903(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the metrics for the specified volume container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeContainerName: JString (required)
  ##                      : The volume container name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `volumeContainerName` field"
  var valid_564905 = path.getOrDefault("volumeContainerName")
  valid_564905 = validateParameter(valid_564905, JString, required = true,
                                 default = nil)
  if valid_564905 != nil:
    section.add "volumeContainerName", valid_564905
  var valid_564906 = path.getOrDefault("subscriptionId")
  valid_564906 = validateParameter(valid_564906, JString, required = true,
                                 default = nil)
  if valid_564906 != nil:
    section.add "subscriptionId", valid_564906
  var valid_564907 = path.getOrDefault("deviceName")
  valid_564907 = validateParameter(valid_564907, JString, required = true,
                                 default = nil)
  if valid_564907 != nil:
    section.add "deviceName", valid_564907
  var valid_564908 = path.getOrDefault("resourceGroupName")
  valid_564908 = validateParameter(valid_564908, JString, required = true,
                                 default = nil)
  if valid_564908 != nil:
    section.add "resourceGroupName", valid_564908
  var valid_564909 = path.getOrDefault("managerName")
  valid_564909 = validateParameter(valid_564909, JString, required = true,
                                 default = nil)
  if valid_564909 != nil:
    section.add "managerName", valid_564909
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString (required)
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564910 = query.getOrDefault("api-version")
  valid_564910 = validateParameter(valid_564910, JString, required = true,
                                 default = nil)
  if valid_564910 != nil:
    section.add "api-version", valid_564910
  var valid_564911 = query.getOrDefault("$filter")
  valid_564911 = validateParameter(valid_564911, JString, required = true,
                                 default = nil)
  if valid_564911 != nil:
    section.add "$filter", valid_564911
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564912: Call_VolumeContainersListMetrics_564902; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metrics for the specified volume container.
  ## 
  let valid = call_564912.validator(path, query, header, formData, body)
  let scheme = call_564912.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564912.url(scheme.get, call_564912.host, call_564912.base,
                         call_564912.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564912, url, valid)

proc call*(call_564913: Call_VolumeContainersListMetrics_564902;
          apiVersion: string; volumeContainerName: string; subscriptionId: string;
          deviceName: string; resourceGroupName: string; managerName: string;
          Filter: string): Recallable =
  ## volumeContainersListMetrics
  ## Gets the metrics for the specified volume container.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   volumeContainerName: string (required)
  ##                      : The volume container name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   Filter: string (required)
  ##         : OData Filter options
  var path_564914 = newJObject()
  var query_564915 = newJObject()
  add(query_564915, "api-version", newJString(apiVersion))
  add(path_564914, "volumeContainerName", newJString(volumeContainerName))
  add(path_564914, "subscriptionId", newJString(subscriptionId))
  add(path_564914, "deviceName", newJString(deviceName))
  add(path_564914, "resourceGroupName", newJString(resourceGroupName))
  add(path_564914, "managerName", newJString(managerName))
  add(query_564915, "$filter", newJString(Filter))
  result = call_564913.call(path_564914, query_564915, nil, nil, nil)

var volumeContainersListMetrics* = Call_VolumeContainersListMetrics_564902(
    name: "volumeContainersListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/metrics",
    validator: validate_VolumeContainersListMetrics_564903, base: "",
    url: url_VolumeContainersListMetrics_564904, schemes: {Scheme.Https})
type
  Call_VolumeContainersListMetricDefinition_564916 = ref object of OpenApiRestCall_563565
proc url_VolumeContainersListMetricDefinition_564918(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName"),
               (kind: ConstantSegment, value: "/metricsDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeContainersListMetricDefinition_564917(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the metric definitions for the specified volume container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeContainerName: JString (required)
  ##                      : The volume container name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `volumeContainerName` field"
  var valid_564919 = path.getOrDefault("volumeContainerName")
  valid_564919 = validateParameter(valid_564919, JString, required = true,
                                 default = nil)
  if valid_564919 != nil:
    section.add "volumeContainerName", valid_564919
  var valid_564920 = path.getOrDefault("subscriptionId")
  valid_564920 = validateParameter(valid_564920, JString, required = true,
                                 default = nil)
  if valid_564920 != nil:
    section.add "subscriptionId", valid_564920
  var valid_564921 = path.getOrDefault("deviceName")
  valid_564921 = validateParameter(valid_564921, JString, required = true,
                                 default = nil)
  if valid_564921 != nil:
    section.add "deviceName", valid_564921
  var valid_564922 = path.getOrDefault("resourceGroupName")
  valid_564922 = validateParameter(valid_564922, JString, required = true,
                                 default = nil)
  if valid_564922 != nil:
    section.add "resourceGroupName", valid_564922
  var valid_564923 = path.getOrDefault("managerName")
  valid_564923 = validateParameter(valid_564923, JString, required = true,
                                 default = nil)
  if valid_564923 != nil:
    section.add "managerName", valid_564923
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564924 = query.getOrDefault("api-version")
  valid_564924 = validateParameter(valid_564924, JString, required = true,
                                 default = nil)
  if valid_564924 != nil:
    section.add "api-version", valid_564924
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564925: Call_VolumeContainersListMetricDefinition_564916;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the metric definitions for the specified volume container.
  ## 
  let valid = call_564925.validator(path, query, header, formData, body)
  let scheme = call_564925.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564925.url(scheme.get, call_564925.host, call_564925.base,
                         call_564925.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564925, url, valid)

proc call*(call_564926: Call_VolumeContainersListMetricDefinition_564916;
          apiVersion: string; volumeContainerName: string; subscriptionId: string;
          deviceName: string; resourceGroupName: string; managerName: string): Recallable =
  ## volumeContainersListMetricDefinition
  ## Gets the metric definitions for the specified volume container.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   volumeContainerName: string (required)
  ##                      : The volume container name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564927 = newJObject()
  var query_564928 = newJObject()
  add(query_564928, "api-version", newJString(apiVersion))
  add(path_564927, "volumeContainerName", newJString(volumeContainerName))
  add(path_564927, "subscriptionId", newJString(subscriptionId))
  add(path_564927, "deviceName", newJString(deviceName))
  add(path_564927, "resourceGroupName", newJString(resourceGroupName))
  add(path_564927, "managerName", newJString(managerName))
  result = call_564926.call(path_564927, query_564928, nil, nil, nil)

var volumeContainersListMetricDefinition* = Call_VolumeContainersListMetricDefinition_564916(
    name: "volumeContainersListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/metricsDefinitions",
    validator: validate_VolumeContainersListMetricDefinition_564917, base: "",
    url: url_VolumeContainersListMetricDefinition_564918, schemes: {Scheme.Https})
type
  Call_VolumesListByVolumeContainer_564929 = ref object of OpenApiRestCall_563565
proc url_VolumesListByVolumeContainer_564931(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName"),
               (kind: ConstantSegment, value: "/volumes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesListByVolumeContainer_564930(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the volumes in a volume container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeContainerName: JString (required)
  ##                      : The volume container name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `volumeContainerName` field"
  var valid_564932 = path.getOrDefault("volumeContainerName")
  valid_564932 = validateParameter(valid_564932, JString, required = true,
                                 default = nil)
  if valid_564932 != nil:
    section.add "volumeContainerName", valid_564932
  var valid_564933 = path.getOrDefault("subscriptionId")
  valid_564933 = validateParameter(valid_564933, JString, required = true,
                                 default = nil)
  if valid_564933 != nil:
    section.add "subscriptionId", valid_564933
  var valid_564934 = path.getOrDefault("deviceName")
  valid_564934 = validateParameter(valid_564934, JString, required = true,
                                 default = nil)
  if valid_564934 != nil:
    section.add "deviceName", valid_564934
  var valid_564935 = path.getOrDefault("resourceGroupName")
  valid_564935 = validateParameter(valid_564935, JString, required = true,
                                 default = nil)
  if valid_564935 != nil:
    section.add "resourceGroupName", valid_564935
  var valid_564936 = path.getOrDefault("managerName")
  valid_564936 = validateParameter(valid_564936, JString, required = true,
                                 default = nil)
  if valid_564936 != nil:
    section.add "managerName", valid_564936
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564937 = query.getOrDefault("api-version")
  valid_564937 = validateParameter(valid_564937, JString, required = true,
                                 default = nil)
  if valid_564937 != nil:
    section.add "api-version", valid_564937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564938: Call_VolumesListByVolumeContainer_564929; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the volumes in a volume container.
  ## 
  let valid = call_564938.validator(path, query, header, formData, body)
  let scheme = call_564938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564938.url(scheme.get, call_564938.host, call_564938.base,
                         call_564938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564938, url, valid)

proc call*(call_564939: Call_VolumesListByVolumeContainer_564929;
          apiVersion: string; volumeContainerName: string; subscriptionId: string;
          deviceName: string; resourceGroupName: string; managerName: string): Recallable =
  ## volumesListByVolumeContainer
  ## Retrieves all the volumes in a volume container.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   volumeContainerName: string (required)
  ##                      : The volume container name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564940 = newJObject()
  var query_564941 = newJObject()
  add(query_564941, "api-version", newJString(apiVersion))
  add(path_564940, "volumeContainerName", newJString(volumeContainerName))
  add(path_564940, "subscriptionId", newJString(subscriptionId))
  add(path_564940, "deviceName", newJString(deviceName))
  add(path_564940, "resourceGroupName", newJString(resourceGroupName))
  add(path_564940, "managerName", newJString(managerName))
  result = call_564939.call(path_564940, query_564941, nil, nil, nil)

var volumesListByVolumeContainer* = Call_VolumesListByVolumeContainer_564929(
    name: "volumesListByVolumeContainer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/volumes",
    validator: validate_VolumesListByVolumeContainer_564930, base: "",
    url: url_VolumesListByVolumeContainer_564931, schemes: {Scheme.Https})
type
  Call_VolumesCreateOrUpdate_564956 = ref object of OpenApiRestCall_563565
proc url_VolumesCreateOrUpdate_564958(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesCreateOrUpdate_564957(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the volume.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeContainerName: JString (required)
  ##                      : The volume container name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   volumeName: JString (required)
  ##             : The volume name.
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `volumeContainerName` field"
  var valid_564959 = path.getOrDefault("volumeContainerName")
  valid_564959 = validateParameter(valid_564959, JString, required = true,
                                 default = nil)
  if valid_564959 != nil:
    section.add "volumeContainerName", valid_564959
  var valid_564960 = path.getOrDefault("subscriptionId")
  valid_564960 = validateParameter(valid_564960, JString, required = true,
                                 default = nil)
  if valid_564960 != nil:
    section.add "subscriptionId", valid_564960
  var valid_564961 = path.getOrDefault("volumeName")
  valid_564961 = validateParameter(valid_564961, JString, required = true,
                                 default = nil)
  if valid_564961 != nil:
    section.add "volumeName", valid_564961
  var valid_564962 = path.getOrDefault("deviceName")
  valid_564962 = validateParameter(valid_564962, JString, required = true,
                                 default = nil)
  if valid_564962 != nil:
    section.add "deviceName", valid_564962
  var valid_564963 = path.getOrDefault("resourceGroupName")
  valid_564963 = validateParameter(valid_564963, JString, required = true,
                                 default = nil)
  if valid_564963 != nil:
    section.add "resourceGroupName", valid_564963
  var valid_564964 = path.getOrDefault("managerName")
  valid_564964 = validateParameter(valid_564964, JString, required = true,
                                 default = nil)
  if valid_564964 != nil:
    section.add "managerName", valid_564964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564965 = query.getOrDefault("api-version")
  valid_564965 = validateParameter(valid_564965, JString, required = true,
                                 default = nil)
  if valid_564965 != nil:
    section.add "api-version", valid_564965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Volume to be created or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564967: Call_VolumesCreateOrUpdate_564956; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the volume.
  ## 
  let valid = call_564967.validator(path, query, header, formData, body)
  let scheme = call_564967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564967.url(scheme.get, call_564967.host, call_564967.base,
                         call_564967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564967, url, valid)

proc call*(call_564968: Call_VolumesCreateOrUpdate_564956; apiVersion: string;
          volumeContainerName: string; subscriptionId: string; volumeName: string;
          deviceName: string; resourceGroupName: string; managerName: string;
          parameters: JsonNode): Recallable =
  ## volumesCreateOrUpdate
  ## Creates or updates the volume.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   volumeContainerName: string (required)
  ##                      : The volume container name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   volumeName: string (required)
  ##             : The volume name.
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : Volume to be created or updated.
  var path_564969 = newJObject()
  var query_564970 = newJObject()
  var body_564971 = newJObject()
  add(query_564970, "api-version", newJString(apiVersion))
  add(path_564969, "volumeContainerName", newJString(volumeContainerName))
  add(path_564969, "subscriptionId", newJString(subscriptionId))
  add(path_564969, "volumeName", newJString(volumeName))
  add(path_564969, "deviceName", newJString(deviceName))
  add(path_564969, "resourceGroupName", newJString(resourceGroupName))
  add(path_564969, "managerName", newJString(managerName))
  if parameters != nil:
    body_564971 = parameters
  result = call_564968.call(path_564969, query_564970, nil, nil, body_564971)

var volumesCreateOrUpdate* = Call_VolumesCreateOrUpdate_564956(
    name: "volumesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/volumes/{volumeName}",
    validator: validate_VolumesCreateOrUpdate_564957, base: "",
    url: url_VolumesCreateOrUpdate_564958, schemes: {Scheme.Https})
type
  Call_VolumesGet_564942 = ref object of OpenApiRestCall_563565
proc url_VolumesGet_564944(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesGet_564943(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified volume name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeContainerName: JString (required)
  ##                      : The volume container name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   volumeName: JString (required)
  ##             : The volume name.
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `volumeContainerName` field"
  var valid_564945 = path.getOrDefault("volumeContainerName")
  valid_564945 = validateParameter(valid_564945, JString, required = true,
                                 default = nil)
  if valid_564945 != nil:
    section.add "volumeContainerName", valid_564945
  var valid_564946 = path.getOrDefault("subscriptionId")
  valid_564946 = validateParameter(valid_564946, JString, required = true,
                                 default = nil)
  if valid_564946 != nil:
    section.add "subscriptionId", valid_564946
  var valid_564947 = path.getOrDefault("volumeName")
  valid_564947 = validateParameter(valid_564947, JString, required = true,
                                 default = nil)
  if valid_564947 != nil:
    section.add "volumeName", valid_564947
  var valid_564948 = path.getOrDefault("deviceName")
  valid_564948 = validateParameter(valid_564948, JString, required = true,
                                 default = nil)
  if valid_564948 != nil:
    section.add "deviceName", valid_564948
  var valid_564949 = path.getOrDefault("resourceGroupName")
  valid_564949 = validateParameter(valid_564949, JString, required = true,
                                 default = nil)
  if valid_564949 != nil:
    section.add "resourceGroupName", valid_564949
  var valid_564950 = path.getOrDefault("managerName")
  valid_564950 = validateParameter(valid_564950, JString, required = true,
                                 default = nil)
  if valid_564950 != nil:
    section.add "managerName", valid_564950
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564951 = query.getOrDefault("api-version")
  valid_564951 = validateParameter(valid_564951, JString, required = true,
                                 default = nil)
  if valid_564951 != nil:
    section.add "api-version", valid_564951
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564952: Call_VolumesGet_564942; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified volume name.
  ## 
  let valid = call_564952.validator(path, query, header, formData, body)
  let scheme = call_564952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564952.url(scheme.get, call_564952.host, call_564952.base,
                         call_564952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564952, url, valid)

proc call*(call_564953: Call_VolumesGet_564942; apiVersion: string;
          volumeContainerName: string; subscriptionId: string; volumeName: string;
          deviceName: string; resourceGroupName: string; managerName: string): Recallable =
  ## volumesGet
  ## Returns the properties of the specified volume name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   volumeContainerName: string (required)
  ##                      : The volume container name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   volumeName: string (required)
  ##             : The volume name.
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564954 = newJObject()
  var query_564955 = newJObject()
  add(query_564955, "api-version", newJString(apiVersion))
  add(path_564954, "volumeContainerName", newJString(volumeContainerName))
  add(path_564954, "subscriptionId", newJString(subscriptionId))
  add(path_564954, "volumeName", newJString(volumeName))
  add(path_564954, "deviceName", newJString(deviceName))
  add(path_564954, "resourceGroupName", newJString(resourceGroupName))
  add(path_564954, "managerName", newJString(managerName))
  result = call_564953.call(path_564954, query_564955, nil, nil, nil)

var volumesGet* = Call_VolumesGet_564942(name: "volumesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/volumes/{volumeName}",
                                      validator: validate_VolumesGet_564943,
                                      base: "", url: url_VolumesGet_564944,
                                      schemes: {Scheme.Https})
type
  Call_VolumesDelete_564972 = ref object of OpenApiRestCall_563565
proc url_VolumesDelete_564974(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesDelete_564973(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the volume.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeContainerName: JString (required)
  ##                      : The volume container name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   volumeName: JString (required)
  ##             : The volume name.
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `volumeContainerName` field"
  var valid_564975 = path.getOrDefault("volumeContainerName")
  valid_564975 = validateParameter(valid_564975, JString, required = true,
                                 default = nil)
  if valid_564975 != nil:
    section.add "volumeContainerName", valid_564975
  var valid_564976 = path.getOrDefault("subscriptionId")
  valid_564976 = validateParameter(valid_564976, JString, required = true,
                                 default = nil)
  if valid_564976 != nil:
    section.add "subscriptionId", valid_564976
  var valid_564977 = path.getOrDefault("volumeName")
  valid_564977 = validateParameter(valid_564977, JString, required = true,
                                 default = nil)
  if valid_564977 != nil:
    section.add "volumeName", valid_564977
  var valid_564978 = path.getOrDefault("deviceName")
  valid_564978 = validateParameter(valid_564978, JString, required = true,
                                 default = nil)
  if valid_564978 != nil:
    section.add "deviceName", valid_564978
  var valid_564979 = path.getOrDefault("resourceGroupName")
  valid_564979 = validateParameter(valid_564979, JString, required = true,
                                 default = nil)
  if valid_564979 != nil:
    section.add "resourceGroupName", valid_564979
  var valid_564980 = path.getOrDefault("managerName")
  valid_564980 = validateParameter(valid_564980, JString, required = true,
                                 default = nil)
  if valid_564980 != nil:
    section.add "managerName", valid_564980
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564981 = query.getOrDefault("api-version")
  valid_564981 = validateParameter(valid_564981, JString, required = true,
                                 default = nil)
  if valid_564981 != nil:
    section.add "api-version", valid_564981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564982: Call_VolumesDelete_564972; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the volume.
  ## 
  let valid = call_564982.validator(path, query, header, formData, body)
  let scheme = call_564982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564982.url(scheme.get, call_564982.host, call_564982.base,
                         call_564982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564982, url, valid)

proc call*(call_564983: Call_VolumesDelete_564972; apiVersion: string;
          volumeContainerName: string; subscriptionId: string; volumeName: string;
          deviceName: string; resourceGroupName: string; managerName: string): Recallable =
  ## volumesDelete
  ## Deletes the volume.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   volumeContainerName: string (required)
  ##                      : The volume container name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   volumeName: string (required)
  ##             : The volume name.
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564984 = newJObject()
  var query_564985 = newJObject()
  add(query_564985, "api-version", newJString(apiVersion))
  add(path_564984, "volumeContainerName", newJString(volumeContainerName))
  add(path_564984, "subscriptionId", newJString(subscriptionId))
  add(path_564984, "volumeName", newJString(volumeName))
  add(path_564984, "deviceName", newJString(deviceName))
  add(path_564984, "resourceGroupName", newJString(resourceGroupName))
  add(path_564984, "managerName", newJString(managerName))
  result = call_564983.call(path_564984, query_564985, nil, nil, nil)

var volumesDelete* = Call_VolumesDelete_564972(name: "volumesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/volumes/{volumeName}",
    validator: validate_VolumesDelete_564973, base: "", url: url_VolumesDelete_564974,
    schemes: {Scheme.Https})
type
  Call_VolumesListMetrics_564986 = ref object of OpenApiRestCall_563565
proc url_VolumesListMetrics_564988(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesListMetrics_564987(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the metrics for the specified volume.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeContainerName: JString (required)
  ##                      : The volume container name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   volumeName: JString (required)
  ##             : The volume name.
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `volumeContainerName` field"
  var valid_564989 = path.getOrDefault("volumeContainerName")
  valid_564989 = validateParameter(valid_564989, JString, required = true,
                                 default = nil)
  if valid_564989 != nil:
    section.add "volumeContainerName", valid_564989
  var valid_564990 = path.getOrDefault("subscriptionId")
  valid_564990 = validateParameter(valid_564990, JString, required = true,
                                 default = nil)
  if valid_564990 != nil:
    section.add "subscriptionId", valid_564990
  var valid_564991 = path.getOrDefault("volumeName")
  valid_564991 = validateParameter(valid_564991, JString, required = true,
                                 default = nil)
  if valid_564991 != nil:
    section.add "volumeName", valid_564991
  var valid_564992 = path.getOrDefault("deviceName")
  valid_564992 = validateParameter(valid_564992, JString, required = true,
                                 default = nil)
  if valid_564992 != nil:
    section.add "deviceName", valid_564992
  var valid_564993 = path.getOrDefault("resourceGroupName")
  valid_564993 = validateParameter(valid_564993, JString, required = true,
                                 default = nil)
  if valid_564993 != nil:
    section.add "resourceGroupName", valid_564993
  var valid_564994 = path.getOrDefault("managerName")
  valid_564994 = validateParameter(valid_564994, JString, required = true,
                                 default = nil)
  if valid_564994 != nil:
    section.add "managerName", valid_564994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString (required)
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564995 = query.getOrDefault("api-version")
  valid_564995 = validateParameter(valid_564995, JString, required = true,
                                 default = nil)
  if valid_564995 != nil:
    section.add "api-version", valid_564995
  var valid_564996 = query.getOrDefault("$filter")
  valid_564996 = validateParameter(valid_564996, JString, required = true,
                                 default = nil)
  if valid_564996 != nil:
    section.add "$filter", valid_564996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564997: Call_VolumesListMetrics_564986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metrics for the specified volume.
  ## 
  let valid = call_564997.validator(path, query, header, formData, body)
  let scheme = call_564997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564997.url(scheme.get, call_564997.host, call_564997.base,
                         call_564997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564997, url, valid)

proc call*(call_564998: Call_VolumesListMetrics_564986; apiVersion: string;
          volumeContainerName: string; subscriptionId: string; volumeName: string;
          deviceName: string; resourceGroupName: string; managerName: string;
          Filter: string): Recallable =
  ## volumesListMetrics
  ## Gets the metrics for the specified volume.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   volumeContainerName: string (required)
  ##                      : The volume container name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   volumeName: string (required)
  ##             : The volume name.
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   Filter: string (required)
  ##         : OData Filter options
  var path_564999 = newJObject()
  var query_565000 = newJObject()
  add(query_565000, "api-version", newJString(apiVersion))
  add(path_564999, "volumeContainerName", newJString(volumeContainerName))
  add(path_564999, "subscriptionId", newJString(subscriptionId))
  add(path_564999, "volumeName", newJString(volumeName))
  add(path_564999, "deviceName", newJString(deviceName))
  add(path_564999, "resourceGroupName", newJString(resourceGroupName))
  add(path_564999, "managerName", newJString(managerName))
  add(query_565000, "$filter", newJString(Filter))
  result = call_564998.call(path_564999, query_565000, nil, nil, nil)

var volumesListMetrics* = Call_VolumesListMetrics_564986(
    name: "volumesListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/volumes/{volumeName}/metrics",
    validator: validate_VolumesListMetrics_564987, base: "",
    url: url_VolumesListMetrics_564988, schemes: {Scheme.Https})
type
  Call_VolumesListMetricDefinition_565001 = ref object of OpenApiRestCall_563565
proc url_VolumesListMetricDefinition_565003(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeName"),
               (kind: ConstantSegment, value: "/metricsDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesListMetricDefinition_565002(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the metric definitions for the specified volume.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeContainerName: JString (required)
  ##                      : The volume container name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   volumeName: JString (required)
  ##             : The volume name.
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `volumeContainerName` field"
  var valid_565004 = path.getOrDefault("volumeContainerName")
  valid_565004 = validateParameter(valid_565004, JString, required = true,
                                 default = nil)
  if valid_565004 != nil:
    section.add "volumeContainerName", valid_565004
  var valid_565005 = path.getOrDefault("subscriptionId")
  valid_565005 = validateParameter(valid_565005, JString, required = true,
                                 default = nil)
  if valid_565005 != nil:
    section.add "subscriptionId", valid_565005
  var valid_565006 = path.getOrDefault("volumeName")
  valid_565006 = validateParameter(valid_565006, JString, required = true,
                                 default = nil)
  if valid_565006 != nil:
    section.add "volumeName", valid_565006
  var valid_565007 = path.getOrDefault("deviceName")
  valid_565007 = validateParameter(valid_565007, JString, required = true,
                                 default = nil)
  if valid_565007 != nil:
    section.add "deviceName", valid_565007
  var valid_565008 = path.getOrDefault("resourceGroupName")
  valid_565008 = validateParameter(valid_565008, JString, required = true,
                                 default = nil)
  if valid_565008 != nil:
    section.add "resourceGroupName", valid_565008
  var valid_565009 = path.getOrDefault("managerName")
  valid_565009 = validateParameter(valid_565009, JString, required = true,
                                 default = nil)
  if valid_565009 != nil:
    section.add "managerName", valid_565009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565010 = query.getOrDefault("api-version")
  valid_565010 = validateParameter(valid_565010, JString, required = true,
                                 default = nil)
  if valid_565010 != nil:
    section.add "api-version", valid_565010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565011: Call_VolumesListMetricDefinition_565001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metric definitions for the specified volume.
  ## 
  let valid = call_565011.validator(path, query, header, formData, body)
  let scheme = call_565011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565011.url(scheme.get, call_565011.host, call_565011.base,
                         call_565011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565011, url, valid)

proc call*(call_565012: Call_VolumesListMetricDefinition_565001;
          apiVersion: string; volumeContainerName: string; subscriptionId: string;
          volumeName: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## volumesListMetricDefinition
  ## Gets the metric definitions for the specified volume.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   volumeContainerName: string (required)
  ##                      : The volume container name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   volumeName: string (required)
  ##             : The volume name.
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565013 = newJObject()
  var query_565014 = newJObject()
  add(query_565014, "api-version", newJString(apiVersion))
  add(path_565013, "volumeContainerName", newJString(volumeContainerName))
  add(path_565013, "subscriptionId", newJString(subscriptionId))
  add(path_565013, "volumeName", newJString(volumeName))
  add(path_565013, "deviceName", newJString(deviceName))
  add(path_565013, "resourceGroupName", newJString(resourceGroupName))
  add(path_565013, "managerName", newJString(managerName))
  result = call_565012.call(path_565013, query_565014, nil, nil, nil)

var volumesListMetricDefinition* = Call_VolumesListMetricDefinition_565001(
    name: "volumesListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/volumes/{volumeName}/metricsDefinitions",
    validator: validate_VolumesListMetricDefinition_565002, base: "",
    url: url_VolumesListMetricDefinition_565003, schemes: {Scheme.Https})
type
  Call_VolumesListByDevice_565015 = ref object of OpenApiRestCall_563565
proc url_VolumesListByDevice_565017(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesListByDevice_565016(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves all the volumes in a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565018 = path.getOrDefault("subscriptionId")
  valid_565018 = validateParameter(valid_565018, JString, required = true,
                                 default = nil)
  if valid_565018 != nil:
    section.add "subscriptionId", valid_565018
  var valid_565019 = path.getOrDefault("deviceName")
  valid_565019 = validateParameter(valid_565019, JString, required = true,
                                 default = nil)
  if valid_565019 != nil:
    section.add "deviceName", valid_565019
  var valid_565020 = path.getOrDefault("resourceGroupName")
  valid_565020 = validateParameter(valid_565020, JString, required = true,
                                 default = nil)
  if valid_565020 != nil:
    section.add "resourceGroupName", valid_565020
  var valid_565021 = path.getOrDefault("managerName")
  valid_565021 = validateParameter(valid_565021, JString, required = true,
                                 default = nil)
  if valid_565021 != nil:
    section.add "managerName", valid_565021
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565022 = query.getOrDefault("api-version")
  valid_565022 = validateParameter(valid_565022, JString, required = true,
                                 default = nil)
  if valid_565022 != nil:
    section.add "api-version", valid_565022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565023: Call_VolumesListByDevice_565015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the volumes in a device.
  ## 
  let valid = call_565023.validator(path, query, header, formData, body)
  let scheme = call_565023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565023.url(scheme.get, call_565023.host, call_565023.base,
                         call_565023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565023, url, valid)

proc call*(call_565024: Call_VolumesListByDevice_565015; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## volumesListByDevice
  ## Retrieves all the volumes in a device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565025 = newJObject()
  var query_565026 = newJObject()
  add(query_565026, "api-version", newJString(apiVersion))
  add(path_565025, "subscriptionId", newJString(subscriptionId))
  add(path_565025, "deviceName", newJString(deviceName))
  add(path_565025, "resourceGroupName", newJString(resourceGroupName))
  add(path_565025, "managerName", newJString(managerName))
  result = call_565024.call(path_565025, query_565026, nil, nil, nil)

var volumesListByDevice* = Call_VolumesListByDevice_565015(
    name: "volumesListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumes",
    validator: validate_VolumesListByDevice_565016, base: "",
    url: url_VolumesListByDevice_565017, schemes: {Scheme.Https})
type
  Call_DevicesFailover_565027 = ref object of OpenApiRestCall_563565
proc url_DevicesFailover_565029(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "sourceDeviceName" in path,
        "`sourceDeviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "sourceDeviceName"),
               (kind: ConstantSegment, value: "/failover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesFailover_565028(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Failovers a set of volume containers from a specified source device to a target device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sourceDeviceName: JString (required)
  ##                   : The source device name on which failover is performed.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sourceDeviceName` field"
  var valid_565030 = path.getOrDefault("sourceDeviceName")
  valid_565030 = validateParameter(valid_565030, JString, required = true,
                                 default = nil)
  if valid_565030 != nil:
    section.add "sourceDeviceName", valid_565030
  var valid_565031 = path.getOrDefault("subscriptionId")
  valid_565031 = validateParameter(valid_565031, JString, required = true,
                                 default = nil)
  if valid_565031 != nil:
    section.add "subscriptionId", valid_565031
  var valid_565032 = path.getOrDefault("resourceGroupName")
  valid_565032 = validateParameter(valid_565032, JString, required = true,
                                 default = nil)
  if valid_565032 != nil:
    section.add "resourceGroupName", valid_565032
  var valid_565033 = path.getOrDefault("managerName")
  valid_565033 = validateParameter(valid_565033, JString, required = true,
                                 default = nil)
  if valid_565033 != nil:
    section.add "managerName", valid_565033
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565034 = query.getOrDefault("api-version")
  valid_565034 = validateParameter(valid_565034, JString, required = true,
                                 default = nil)
  if valid_565034 != nil:
    section.add "api-version", valid_565034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : FailoverRequest containing the source device and the list of volume containers to be failed over.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565036: Call_DevicesFailover_565027; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Failovers a set of volume containers from a specified source device to a target device.
  ## 
  let valid = call_565036.validator(path, query, header, formData, body)
  let scheme = call_565036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565036.url(scheme.get, call_565036.host, call_565036.base,
                         call_565036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565036, url, valid)

proc call*(call_565037: Call_DevicesFailover_565027; sourceDeviceName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          managerName: string; parameters: JsonNode): Recallable =
  ## devicesFailover
  ## Failovers a set of volume containers from a specified source device to a target device.
  ##   sourceDeviceName: string (required)
  ##                   : The source device name on which failover is performed.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : FailoverRequest containing the source device and the list of volume containers to be failed over.
  var path_565038 = newJObject()
  var query_565039 = newJObject()
  var body_565040 = newJObject()
  add(path_565038, "sourceDeviceName", newJString(sourceDeviceName))
  add(query_565039, "api-version", newJString(apiVersion))
  add(path_565038, "subscriptionId", newJString(subscriptionId))
  add(path_565038, "resourceGroupName", newJString(resourceGroupName))
  add(path_565038, "managerName", newJString(managerName))
  if parameters != nil:
    body_565040 = parameters
  result = call_565037.call(path_565038, query_565039, nil, nil, body_565040)

var devicesFailover* = Call_DevicesFailover_565027(name: "devicesFailover",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{sourceDeviceName}/failover",
    validator: validate_DevicesFailover_565028, base: "", url: url_DevicesFailover_565029,
    schemes: {Scheme.Https})
type
  Call_DevicesListFailoverTargets_565041 = ref object of OpenApiRestCall_563565
proc url_DevicesListFailoverTargets_565043(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "sourceDeviceName" in path,
        "`sourceDeviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "sourceDeviceName"),
               (kind: ConstantSegment, value: "/listFailoverTargets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesListFailoverTargets_565042(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Given a list of volume containers to be failed over from a source device, this method returns the eligibility result, as a failover target, for all devices under that resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sourceDeviceName: JString (required)
  ##                   : The source device name on which failover is performed.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sourceDeviceName` field"
  var valid_565044 = path.getOrDefault("sourceDeviceName")
  valid_565044 = validateParameter(valid_565044, JString, required = true,
                                 default = nil)
  if valid_565044 != nil:
    section.add "sourceDeviceName", valid_565044
  var valid_565045 = path.getOrDefault("subscriptionId")
  valid_565045 = validateParameter(valid_565045, JString, required = true,
                                 default = nil)
  if valid_565045 != nil:
    section.add "subscriptionId", valid_565045
  var valid_565046 = path.getOrDefault("resourceGroupName")
  valid_565046 = validateParameter(valid_565046, JString, required = true,
                                 default = nil)
  if valid_565046 != nil:
    section.add "resourceGroupName", valid_565046
  var valid_565047 = path.getOrDefault("managerName")
  valid_565047 = validateParameter(valid_565047, JString, required = true,
                                 default = nil)
  if valid_565047 != nil:
    section.add "managerName", valid_565047
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565048 = query.getOrDefault("api-version")
  valid_565048 = validateParameter(valid_565048, JString, required = true,
                                 default = nil)
  if valid_565048 != nil:
    section.add "api-version", valid_565048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : ListFailoverTargetsRequest containing the list of volume containers to be failed over.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565050: Call_DevicesListFailoverTargets_565041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Given a list of volume containers to be failed over from a source device, this method returns the eligibility result, as a failover target, for all devices under that resource.
  ## 
  let valid = call_565050.validator(path, query, header, formData, body)
  let scheme = call_565050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565050.url(scheme.get, call_565050.host, call_565050.base,
                         call_565050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565050, url, valid)

proc call*(call_565051: Call_DevicesListFailoverTargets_565041;
          sourceDeviceName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; managerName: string; parameters: JsonNode): Recallable =
  ## devicesListFailoverTargets
  ## Given a list of volume containers to be failed over from a source device, this method returns the eligibility result, as a failover target, for all devices under that resource.
  ##   sourceDeviceName: string (required)
  ##                   : The source device name on which failover is performed.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : ListFailoverTargetsRequest containing the list of volume containers to be failed over.
  var path_565052 = newJObject()
  var query_565053 = newJObject()
  var body_565054 = newJObject()
  add(path_565052, "sourceDeviceName", newJString(sourceDeviceName))
  add(query_565053, "api-version", newJString(apiVersion))
  add(path_565052, "subscriptionId", newJString(subscriptionId))
  add(path_565052, "resourceGroupName", newJString(resourceGroupName))
  add(path_565052, "managerName", newJString(managerName))
  if parameters != nil:
    body_565054 = parameters
  result = call_565051.call(path_565052, query_565053, nil, nil, body_565054)

var devicesListFailoverTargets* = Call_DevicesListFailoverTargets_565041(
    name: "devicesListFailoverTargets", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{sourceDeviceName}/listFailoverTargets",
    validator: validate_DevicesListFailoverTargets_565042, base: "",
    url: url_DevicesListFailoverTargets_565043, schemes: {Scheme.Https})
type
  Call_ManagersGetEncryptionSettings_565055 = ref object of OpenApiRestCall_563565
proc url_ManagersGetEncryptionSettings_565057(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/encryptionSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersGetEncryptionSettings_565056(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the encryption settings of the manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565058 = path.getOrDefault("subscriptionId")
  valid_565058 = validateParameter(valid_565058, JString, required = true,
                                 default = nil)
  if valid_565058 != nil:
    section.add "subscriptionId", valid_565058
  var valid_565059 = path.getOrDefault("resourceGroupName")
  valid_565059 = validateParameter(valid_565059, JString, required = true,
                                 default = nil)
  if valid_565059 != nil:
    section.add "resourceGroupName", valid_565059
  var valid_565060 = path.getOrDefault("managerName")
  valid_565060 = validateParameter(valid_565060, JString, required = true,
                                 default = nil)
  if valid_565060 != nil:
    section.add "managerName", valid_565060
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565061 = query.getOrDefault("api-version")
  valid_565061 = validateParameter(valid_565061, JString, required = true,
                                 default = nil)
  if valid_565061 != nil:
    section.add "api-version", valid_565061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565062: Call_ManagersGetEncryptionSettings_565055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the encryption settings of the manager.
  ## 
  let valid = call_565062.validator(path, query, header, formData, body)
  let scheme = call_565062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565062.url(scheme.get, call_565062.host, call_565062.base,
                         call_565062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565062, url, valid)

proc call*(call_565063: Call_ManagersGetEncryptionSettings_565055;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## managersGetEncryptionSettings
  ## Returns the encryption settings of the manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565064 = newJObject()
  var query_565065 = newJObject()
  add(query_565065, "api-version", newJString(apiVersion))
  add(path_565064, "subscriptionId", newJString(subscriptionId))
  add(path_565064, "resourceGroupName", newJString(resourceGroupName))
  add(path_565064, "managerName", newJString(managerName))
  result = call_565063.call(path_565064, query_565065, nil, nil, nil)

var managersGetEncryptionSettings* = Call_ManagersGetEncryptionSettings_565055(
    name: "managersGetEncryptionSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/encryptionSettings/default",
    validator: validate_ManagersGetEncryptionSettings_565056, base: "",
    url: url_ManagersGetEncryptionSettings_565057, schemes: {Scheme.Https})
type
  Call_ManagersCreateExtendedInfo_565077 = ref object of OpenApiRestCall_563565
proc url_ManagersCreateExtendedInfo_565079(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"), (
        kind: ConstantSegment, value: "/extendedInformation/vaultExtendedInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersCreateExtendedInfo_565078(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the extended info of the manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565080 = path.getOrDefault("subscriptionId")
  valid_565080 = validateParameter(valid_565080, JString, required = true,
                                 default = nil)
  if valid_565080 != nil:
    section.add "subscriptionId", valid_565080
  var valid_565081 = path.getOrDefault("resourceGroupName")
  valid_565081 = validateParameter(valid_565081, JString, required = true,
                                 default = nil)
  if valid_565081 != nil:
    section.add "resourceGroupName", valid_565081
  var valid_565082 = path.getOrDefault("managerName")
  valid_565082 = validateParameter(valid_565082, JString, required = true,
                                 default = nil)
  if valid_565082 != nil:
    section.add "managerName", valid_565082
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565083 = query.getOrDefault("api-version")
  valid_565083 = validateParameter(valid_565083, JString, required = true,
                                 default = nil)
  if valid_565083 != nil:
    section.add "api-version", valid_565083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The manager extended information.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565085: Call_ManagersCreateExtendedInfo_565077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the extended info of the manager.
  ## 
  let valid = call_565085.validator(path, query, header, formData, body)
  let scheme = call_565085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565085.url(scheme.get, call_565085.host, call_565085.base,
                         call_565085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565085, url, valid)

proc call*(call_565086: Call_ManagersCreateExtendedInfo_565077; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string;
          parameters: JsonNode): Recallable =
  ## managersCreateExtendedInfo
  ## Creates the extended info of the manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : The manager extended information.
  var path_565087 = newJObject()
  var query_565088 = newJObject()
  var body_565089 = newJObject()
  add(query_565088, "api-version", newJString(apiVersion))
  add(path_565087, "subscriptionId", newJString(subscriptionId))
  add(path_565087, "resourceGroupName", newJString(resourceGroupName))
  add(path_565087, "managerName", newJString(managerName))
  if parameters != nil:
    body_565089 = parameters
  result = call_565086.call(path_565087, query_565088, nil, nil, body_565089)

var managersCreateExtendedInfo* = Call_ManagersCreateExtendedInfo_565077(
    name: "managersCreateExtendedInfo", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersCreateExtendedInfo_565078, base: "",
    url: url_ManagersCreateExtendedInfo_565079, schemes: {Scheme.Https})
type
  Call_ManagersGetExtendedInfo_565066 = ref object of OpenApiRestCall_563565
proc url_ManagersGetExtendedInfo_565068(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"), (
        kind: ConstantSegment, value: "/extendedInformation/vaultExtendedInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersGetExtendedInfo_565067(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the extended information of the specified manager name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565069 = path.getOrDefault("subscriptionId")
  valid_565069 = validateParameter(valid_565069, JString, required = true,
                                 default = nil)
  if valid_565069 != nil:
    section.add "subscriptionId", valid_565069
  var valid_565070 = path.getOrDefault("resourceGroupName")
  valid_565070 = validateParameter(valid_565070, JString, required = true,
                                 default = nil)
  if valid_565070 != nil:
    section.add "resourceGroupName", valid_565070
  var valid_565071 = path.getOrDefault("managerName")
  valid_565071 = validateParameter(valid_565071, JString, required = true,
                                 default = nil)
  if valid_565071 != nil:
    section.add "managerName", valid_565071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565072 = query.getOrDefault("api-version")
  valid_565072 = validateParameter(valid_565072, JString, required = true,
                                 default = nil)
  if valid_565072 != nil:
    section.add "api-version", valid_565072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565073: Call_ManagersGetExtendedInfo_565066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the extended information of the specified manager name.
  ## 
  let valid = call_565073.validator(path, query, header, formData, body)
  let scheme = call_565073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565073.url(scheme.get, call_565073.host, call_565073.base,
                         call_565073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565073, url, valid)

proc call*(call_565074: Call_ManagersGetExtendedInfo_565066; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string): Recallable =
  ## managersGetExtendedInfo
  ## Returns the extended information of the specified manager name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565075 = newJObject()
  var query_565076 = newJObject()
  add(query_565076, "api-version", newJString(apiVersion))
  add(path_565075, "subscriptionId", newJString(subscriptionId))
  add(path_565075, "resourceGroupName", newJString(resourceGroupName))
  add(path_565075, "managerName", newJString(managerName))
  result = call_565074.call(path_565075, query_565076, nil, nil, nil)

var managersGetExtendedInfo* = Call_ManagersGetExtendedInfo_565066(
    name: "managersGetExtendedInfo", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersGetExtendedInfo_565067, base: "",
    url: url_ManagersGetExtendedInfo_565068, schemes: {Scheme.Https})
type
  Call_ManagersUpdateExtendedInfo_565101 = ref object of OpenApiRestCall_563565
proc url_ManagersUpdateExtendedInfo_565103(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"), (
        kind: ConstantSegment, value: "/extendedInformation/vaultExtendedInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersUpdateExtendedInfo_565102(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the extended info of the manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565104 = path.getOrDefault("subscriptionId")
  valid_565104 = validateParameter(valid_565104, JString, required = true,
                                 default = nil)
  if valid_565104 != nil:
    section.add "subscriptionId", valid_565104
  var valid_565105 = path.getOrDefault("resourceGroupName")
  valid_565105 = validateParameter(valid_565105, JString, required = true,
                                 default = nil)
  if valid_565105 != nil:
    section.add "resourceGroupName", valid_565105
  var valid_565106 = path.getOrDefault("managerName")
  valid_565106 = validateParameter(valid_565106, JString, required = true,
                                 default = nil)
  if valid_565106 != nil:
    section.add "managerName", valid_565106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565107 = query.getOrDefault("api-version")
  valid_565107 = validateParameter(valid_565107, JString, required = true,
                                 default = nil)
  if valid_565107 != nil:
    section.add "api-version", valid_565107
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : Pass the ETag of ExtendedInfo fetched from GET call
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_565108 = header.getOrDefault("If-Match")
  valid_565108 = validateParameter(valid_565108, JString, required = true,
                                 default = nil)
  if valid_565108 != nil:
    section.add "If-Match", valid_565108
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The manager extended information.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565110: Call_ManagersUpdateExtendedInfo_565101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the extended info of the manager.
  ## 
  let valid = call_565110.validator(path, query, header, formData, body)
  let scheme = call_565110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565110.url(scheme.get, call_565110.host, call_565110.base,
                         call_565110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565110, url, valid)

proc call*(call_565111: Call_ManagersUpdateExtendedInfo_565101; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string;
          parameters: JsonNode): Recallable =
  ## managersUpdateExtendedInfo
  ## Updates the extended info of the manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : The manager extended information.
  var path_565112 = newJObject()
  var query_565113 = newJObject()
  var body_565114 = newJObject()
  add(query_565113, "api-version", newJString(apiVersion))
  add(path_565112, "subscriptionId", newJString(subscriptionId))
  add(path_565112, "resourceGroupName", newJString(resourceGroupName))
  add(path_565112, "managerName", newJString(managerName))
  if parameters != nil:
    body_565114 = parameters
  result = call_565111.call(path_565112, query_565113, nil, nil, body_565114)

var managersUpdateExtendedInfo* = Call_ManagersUpdateExtendedInfo_565101(
    name: "managersUpdateExtendedInfo", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersUpdateExtendedInfo_565102, base: "",
    url: url_ManagersUpdateExtendedInfo_565103, schemes: {Scheme.Https})
type
  Call_ManagersDeleteExtendedInfo_565090 = ref object of OpenApiRestCall_563565
proc url_ManagersDeleteExtendedInfo_565092(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"), (
        kind: ConstantSegment, value: "/extendedInformation/vaultExtendedInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersDeleteExtendedInfo_565091(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the extended info of the manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565093 = path.getOrDefault("subscriptionId")
  valid_565093 = validateParameter(valid_565093, JString, required = true,
                                 default = nil)
  if valid_565093 != nil:
    section.add "subscriptionId", valid_565093
  var valid_565094 = path.getOrDefault("resourceGroupName")
  valid_565094 = validateParameter(valid_565094, JString, required = true,
                                 default = nil)
  if valid_565094 != nil:
    section.add "resourceGroupName", valid_565094
  var valid_565095 = path.getOrDefault("managerName")
  valid_565095 = validateParameter(valid_565095, JString, required = true,
                                 default = nil)
  if valid_565095 != nil:
    section.add "managerName", valid_565095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565096 = query.getOrDefault("api-version")
  valid_565096 = validateParameter(valid_565096, JString, required = true,
                                 default = nil)
  if valid_565096 != nil:
    section.add "api-version", valid_565096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565097: Call_ManagersDeleteExtendedInfo_565090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the extended info of the manager.
  ## 
  let valid = call_565097.validator(path, query, header, formData, body)
  let scheme = call_565097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565097.url(scheme.get, call_565097.host, call_565097.base,
                         call_565097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565097, url, valid)

proc call*(call_565098: Call_ManagersDeleteExtendedInfo_565090; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string): Recallable =
  ## managersDeleteExtendedInfo
  ## Deletes the extended info of the manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565099 = newJObject()
  var query_565100 = newJObject()
  add(query_565100, "api-version", newJString(apiVersion))
  add(path_565099, "subscriptionId", newJString(subscriptionId))
  add(path_565099, "resourceGroupName", newJString(resourceGroupName))
  add(path_565099, "managerName", newJString(managerName))
  result = call_565098.call(path_565099, query_565100, nil, nil, nil)

var managersDeleteExtendedInfo* = Call_ManagersDeleteExtendedInfo_565090(
    name: "managersDeleteExtendedInfo", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersDeleteExtendedInfo_565091, base: "",
    url: url_ManagersDeleteExtendedInfo_565092, schemes: {Scheme.Https})
type
  Call_ManagersListFeatureSupportStatus_565115 = ref object of OpenApiRestCall_563565
proc url_ManagersListFeatureSupportStatus_565117(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/features")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersListFeatureSupportStatus_565116(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the features and their support status
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565118 = path.getOrDefault("subscriptionId")
  valid_565118 = validateParameter(valid_565118, JString, required = true,
                                 default = nil)
  if valid_565118 != nil:
    section.add "subscriptionId", valid_565118
  var valid_565119 = path.getOrDefault("resourceGroupName")
  valid_565119 = validateParameter(valid_565119, JString, required = true,
                                 default = nil)
  if valid_565119 != nil:
    section.add "resourceGroupName", valid_565119
  var valid_565120 = path.getOrDefault("managerName")
  valid_565120 = validateParameter(valid_565120, JString, required = true,
                                 default = nil)
  if valid_565120 != nil:
    section.add "managerName", valid_565120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565121 = query.getOrDefault("api-version")
  valid_565121 = validateParameter(valid_565121, JString, required = true,
                                 default = nil)
  if valid_565121 != nil:
    section.add "api-version", valid_565121
  var valid_565122 = query.getOrDefault("$filter")
  valid_565122 = validateParameter(valid_565122, JString, required = false,
                                 default = nil)
  if valid_565122 != nil:
    section.add "$filter", valid_565122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565123: Call_ManagersListFeatureSupportStatus_565115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the features and their support status
  ## 
  let valid = call_565123.validator(path, query, header, formData, body)
  let scheme = call_565123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565123.url(scheme.get, call_565123.host, call_565123.base,
                         call_565123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565123, url, valid)

proc call*(call_565124: Call_ManagersListFeatureSupportStatus_565115;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          managerName: string; Filter: string = ""): Recallable =
  ## managersListFeatureSupportStatus
  ## Lists the features and their support status
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   Filter: string
  ##         : OData Filter options
  var path_565125 = newJObject()
  var query_565126 = newJObject()
  add(query_565126, "api-version", newJString(apiVersion))
  add(path_565125, "subscriptionId", newJString(subscriptionId))
  add(path_565125, "resourceGroupName", newJString(resourceGroupName))
  add(path_565125, "managerName", newJString(managerName))
  add(query_565126, "$filter", newJString(Filter))
  result = call_565124.call(path_565125, query_565126, nil, nil, nil)

var managersListFeatureSupportStatus* = Call_ManagersListFeatureSupportStatus_565115(
    name: "managersListFeatureSupportStatus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/features",
    validator: validate_ManagersListFeatureSupportStatus_565116, base: "",
    url: url_ManagersListFeatureSupportStatus_565117, schemes: {Scheme.Https})
type
  Call_JobsListByManager_565127 = ref object of OpenApiRestCall_563565
proc url_JobsListByManager_565129(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsListByManager_565128(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets all the jobs for the specified manager. With optional OData query parameters, a filtered set of jobs is returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565130 = path.getOrDefault("subscriptionId")
  valid_565130 = validateParameter(valid_565130, JString, required = true,
                                 default = nil)
  if valid_565130 != nil:
    section.add "subscriptionId", valid_565130
  var valid_565131 = path.getOrDefault("resourceGroupName")
  valid_565131 = validateParameter(valid_565131, JString, required = true,
                                 default = nil)
  if valid_565131 != nil:
    section.add "resourceGroupName", valid_565131
  var valid_565132 = path.getOrDefault("managerName")
  valid_565132 = validateParameter(valid_565132, JString, required = true,
                                 default = nil)
  if valid_565132 != nil:
    section.add "managerName", valid_565132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565133 = query.getOrDefault("api-version")
  valid_565133 = validateParameter(valid_565133, JString, required = true,
                                 default = nil)
  if valid_565133 != nil:
    section.add "api-version", valid_565133
  var valid_565134 = query.getOrDefault("$filter")
  valid_565134 = validateParameter(valid_565134, JString, required = false,
                                 default = nil)
  if valid_565134 != nil:
    section.add "$filter", valid_565134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565135: Call_JobsListByManager_565127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the jobs for the specified manager. With optional OData query parameters, a filtered set of jobs is returned.
  ## 
  let valid = call_565135.validator(path, query, header, formData, body)
  let scheme = call_565135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565135.url(scheme.get, call_565135.host, call_565135.base,
                         call_565135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565135, url, valid)

proc call*(call_565136: Call_JobsListByManager_565127; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string;
          Filter: string = ""): Recallable =
  ## jobsListByManager
  ## Gets all the jobs for the specified manager. With optional OData query parameters, a filtered set of jobs is returned.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   Filter: string
  ##         : OData Filter options
  var path_565137 = newJObject()
  var query_565138 = newJObject()
  add(query_565138, "api-version", newJString(apiVersion))
  add(path_565137, "subscriptionId", newJString(subscriptionId))
  add(path_565137, "resourceGroupName", newJString(resourceGroupName))
  add(path_565137, "managerName", newJString(managerName))
  add(query_565138, "$filter", newJString(Filter))
  result = call_565136.call(path_565137, query_565138, nil, nil, nil)

var jobsListByManager* = Call_JobsListByManager_565127(name: "jobsListByManager",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/jobs",
    validator: validate_JobsListByManager_565128, base: "",
    url: url_JobsListByManager_565129, schemes: {Scheme.Https})
type
  Call_ManagersGetActivationKey_565139 = ref object of OpenApiRestCall_563565
proc url_ManagersGetActivationKey_565141(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/listActivationKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersGetActivationKey_565140(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the activation key of the manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565142 = path.getOrDefault("subscriptionId")
  valid_565142 = validateParameter(valid_565142, JString, required = true,
                                 default = nil)
  if valid_565142 != nil:
    section.add "subscriptionId", valid_565142
  var valid_565143 = path.getOrDefault("resourceGroupName")
  valid_565143 = validateParameter(valid_565143, JString, required = true,
                                 default = nil)
  if valid_565143 != nil:
    section.add "resourceGroupName", valid_565143
  var valid_565144 = path.getOrDefault("managerName")
  valid_565144 = validateParameter(valid_565144, JString, required = true,
                                 default = nil)
  if valid_565144 != nil:
    section.add "managerName", valid_565144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565145 = query.getOrDefault("api-version")
  valid_565145 = validateParameter(valid_565145, JString, required = true,
                                 default = nil)
  if valid_565145 != nil:
    section.add "api-version", valid_565145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565146: Call_ManagersGetActivationKey_565139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the activation key of the manager.
  ## 
  let valid = call_565146.validator(path, query, header, formData, body)
  let scheme = call_565146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565146.url(scheme.get, call_565146.host, call_565146.base,
                         call_565146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565146, url, valid)

proc call*(call_565147: Call_ManagersGetActivationKey_565139; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string): Recallable =
  ## managersGetActivationKey
  ## Returns the activation key of the manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565148 = newJObject()
  var query_565149 = newJObject()
  add(query_565149, "api-version", newJString(apiVersion))
  add(path_565148, "subscriptionId", newJString(subscriptionId))
  add(path_565148, "resourceGroupName", newJString(resourceGroupName))
  add(path_565148, "managerName", newJString(managerName))
  result = call_565147.call(path_565148, query_565149, nil, nil, nil)

var managersGetActivationKey* = Call_ManagersGetActivationKey_565139(
    name: "managersGetActivationKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/listActivationKey",
    validator: validate_ManagersGetActivationKey_565140, base: "",
    url: url_ManagersGetActivationKey_565141, schemes: {Scheme.Https})
type
  Call_ManagersGetPublicEncryptionKey_565150 = ref object of OpenApiRestCall_563565
proc url_ManagersGetPublicEncryptionKey_565152(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/listPublicEncryptionKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersGetPublicEncryptionKey_565151(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the symmetric encrypted public encryption key of the manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565153 = path.getOrDefault("subscriptionId")
  valid_565153 = validateParameter(valid_565153, JString, required = true,
                                 default = nil)
  if valid_565153 != nil:
    section.add "subscriptionId", valid_565153
  var valid_565154 = path.getOrDefault("resourceGroupName")
  valid_565154 = validateParameter(valid_565154, JString, required = true,
                                 default = nil)
  if valid_565154 != nil:
    section.add "resourceGroupName", valid_565154
  var valid_565155 = path.getOrDefault("managerName")
  valid_565155 = validateParameter(valid_565155, JString, required = true,
                                 default = nil)
  if valid_565155 != nil:
    section.add "managerName", valid_565155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565156 = query.getOrDefault("api-version")
  valid_565156 = validateParameter(valid_565156, JString, required = true,
                                 default = nil)
  if valid_565156 != nil:
    section.add "api-version", valid_565156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565157: Call_ManagersGetPublicEncryptionKey_565150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the symmetric encrypted public encryption key of the manager.
  ## 
  let valid = call_565157.validator(path, query, header, formData, body)
  let scheme = call_565157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565157.url(scheme.get, call_565157.host, call_565157.base,
                         call_565157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565157, url, valid)

proc call*(call_565158: Call_ManagersGetPublicEncryptionKey_565150;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## managersGetPublicEncryptionKey
  ## Returns the symmetric encrypted public encryption key of the manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565159 = newJObject()
  var query_565160 = newJObject()
  add(query_565160, "api-version", newJString(apiVersion))
  add(path_565159, "subscriptionId", newJString(subscriptionId))
  add(path_565159, "resourceGroupName", newJString(resourceGroupName))
  add(path_565159, "managerName", newJString(managerName))
  result = call_565158.call(path_565159, query_565160, nil, nil, nil)

var managersGetPublicEncryptionKey* = Call_ManagersGetPublicEncryptionKey_565150(
    name: "managersGetPublicEncryptionKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/listPublicEncryptionKey",
    validator: validate_ManagersGetPublicEncryptionKey_565151, base: "",
    url: url_ManagersGetPublicEncryptionKey_565152, schemes: {Scheme.Https})
type
  Call_ManagersListMetrics_565161 = ref object of OpenApiRestCall_563565
proc url_ManagersListMetrics_565163(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersListMetrics_565162(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the metrics for the specified manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565164 = path.getOrDefault("subscriptionId")
  valid_565164 = validateParameter(valid_565164, JString, required = true,
                                 default = nil)
  if valid_565164 != nil:
    section.add "subscriptionId", valid_565164
  var valid_565165 = path.getOrDefault("resourceGroupName")
  valid_565165 = validateParameter(valid_565165, JString, required = true,
                                 default = nil)
  if valid_565165 != nil:
    section.add "resourceGroupName", valid_565165
  var valid_565166 = path.getOrDefault("managerName")
  valid_565166 = validateParameter(valid_565166, JString, required = true,
                                 default = nil)
  if valid_565166 != nil:
    section.add "managerName", valid_565166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString (required)
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565167 = query.getOrDefault("api-version")
  valid_565167 = validateParameter(valid_565167, JString, required = true,
                                 default = nil)
  if valid_565167 != nil:
    section.add "api-version", valid_565167
  var valid_565168 = query.getOrDefault("$filter")
  valid_565168 = validateParameter(valid_565168, JString, required = true,
                                 default = nil)
  if valid_565168 != nil:
    section.add "$filter", valid_565168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565169: Call_ManagersListMetrics_565161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metrics for the specified manager.
  ## 
  let valid = call_565169.validator(path, query, header, formData, body)
  let scheme = call_565169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565169.url(scheme.get, call_565169.host, call_565169.base,
                         call_565169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565169, url, valid)

proc call*(call_565170: Call_ManagersListMetrics_565161; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string;
          Filter: string): Recallable =
  ## managersListMetrics
  ## Gets the metrics for the specified manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   Filter: string (required)
  ##         : OData Filter options
  var path_565171 = newJObject()
  var query_565172 = newJObject()
  add(query_565172, "api-version", newJString(apiVersion))
  add(path_565171, "subscriptionId", newJString(subscriptionId))
  add(path_565171, "resourceGroupName", newJString(resourceGroupName))
  add(path_565171, "managerName", newJString(managerName))
  add(query_565172, "$filter", newJString(Filter))
  result = call_565170.call(path_565171, query_565172, nil, nil, nil)

var managersListMetrics* = Call_ManagersListMetrics_565161(
    name: "managersListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/metrics",
    validator: validate_ManagersListMetrics_565162, base: "",
    url: url_ManagersListMetrics_565163, schemes: {Scheme.Https})
type
  Call_ManagersListMetricDefinition_565173 = ref object of OpenApiRestCall_563565
proc url_ManagersListMetricDefinition_565175(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/metricsDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersListMetricDefinition_565174(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the metric definitions for the specified manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565176 = path.getOrDefault("subscriptionId")
  valid_565176 = validateParameter(valid_565176, JString, required = true,
                                 default = nil)
  if valid_565176 != nil:
    section.add "subscriptionId", valid_565176
  var valid_565177 = path.getOrDefault("resourceGroupName")
  valid_565177 = validateParameter(valid_565177, JString, required = true,
                                 default = nil)
  if valid_565177 != nil:
    section.add "resourceGroupName", valid_565177
  var valid_565178 = path.getOrDefault("managerName")
  valid_565178 = validateParameter(valid_565178, JString, required = true,
                                 default = nil)
  if valid_565178 != nil:
    section.add "managerName", valid_565178
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565179 = query.getOrDefault("api-version")
  valid_565179 = validateParameter(valid_565179, JString, required = true,
                                 default = nil)
  if valid_565179 != nil:
    section.add "api-version", valid_565179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565180: Call_ManagersListMetricDefinition_565173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metric definitions for the specified manager.
  ## 
  let valid = call_565180.validator(path, query, header, formData, body)
  let scheme = call_565180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565180.url(scheme.get, call_565180.host, call_565180.base,
                         call_565180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565180, url, valid)

proc call*(call_565181: Call_ManagersListMetricDefinition_565173;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## managersListMetricDefinition
  ## Gets the metric definitions for the specified manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565182 = newJObject()
  var query_565183 = newJObject()
  add(query_565183, "api-version", newJString(apiVersion))
  add(path_565182, "subscriptionId", newJString(subscriptionId))
  add(path_565182, "resourceGroupName", newJString(resourceGroupName))
  add(path_565182, "managerName", newJString(managerName))
  result = call_565181.call(path_565182, query_565183, nil, nil, nil)

var managersListMetricDefinition* = Call_ManagersListMetricDefinition_565173(
    name: "managersListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/metricsDefinitions",
    validator: validate_ManagersListMetricDefinition_565174, base: "",
    url: url_ManagersListMetricDefinition_565175, schemes: {Scheme.Https})
type
  Call_CloudAppliancesProvision_565184 = ref object of OpenApiRestCall_563565
proc url_CloudAppliancesProvision_565186(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/provisionCloudAppliance")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudAppliancesProvision_565185(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provisions cloud appliance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565187 = path.getOrDefault("subscriptionId")
  valid_565187 = validateParameter(valid_565187, JString, required = true,
                                 default = nil)
  if valid_565187 != nil:
    section.add "subscriptionId", valid_565187
  var valid_565188 = path.getOrDefault("resourceGroupName")
  valid_565188 = validateParameter(valid_565188, JString, required = true,
                                 default = nil)
  if valid_565188 != nil:
    section.add "resourceGroupName", valid_565188
  var valid_565189 = path.getOrDefault("managerName")
  valid_565189 = validateParameter(valid_565189, JString, required = true,
                                 default = nil)
  if valid_565189 != nil:
    section.add "managerName", valid_565189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565190 = query.getOrDefault("api-version")
  valid_565190 = validateParameter(valid_565190, JString, required = true,
                                 default = nil)
  if valid_565190 != nil:
    section.add "api-version", valid_565190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The cloud appliance
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565192: Call_CloudAppliancesProvision_565184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provisions cloud appliance.
  ## 
  let valid = call_565192.validator(path, query, header, formData, body)
  let scheme = call_565192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565192.url(scheme.get, call_565192.host, call_565192.base,
                         call_565192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565192, url, valid)

proc call*(call_565193: Call_CloudAppliancesProvision_565184; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string;
          parameters: JsonNode): Recallable =
  ## cloudAppliancesProvision
  ## Provisions cloud appliance.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   parameters: JObject (required)
  ##             : The cloud appliance
  var path_565194 = newJObject()
  var query_565195 = newJObject()
  var body_565196 = newJObject()
  add(query_565195, "api-version", newJString(apiVersion))
  add(path_565194, "subscriptionId", newJString(subscriptionId))
  add(path_565194, "resourceGroupName", newJString(resourceGroupName))
  add(path_565194, "managerName", newJString(managerName))
  if parameters != nil:
    body_565196 = parameters
  result = call_565193.call(path_565194, query_565195, nil, nil, body_565196)

var cloudAppliancesProvision* = Call_CloudAppliancesProvision_565184(
    name: "cloudAppliancesProvision", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/provisionCloudAppliance",
    validator: validate_CloudAppliancesProvision_565185, base: "",
    url: url_CloudAppliancesProvision_565186, schemes: {Scheme.Https})
type
  Call_ManagersRegenerateActivationKey_565197 = ref object of OpenApiRestCall_563565
proc url_ManagersRegenerateActivationKey_565199(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/regenerateActivationKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersRegenerateActivationKey_565198(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Re-generates and returns the activation key of the manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565200 = path.getOrDefault("subscriptionId")
  valid_565200 = validateParameter(valid_565200, JString, required = true,
                                 default = nil)
  if valid_565200 != nil:
    section.add "subscriptionId", valid_565200
  var valid_565201 = path.getOrDefault("resourceGroupName")
  valid_565201 = validateParameter(valid_565201, JString, required = true,
                                 default = nil)
  if valid_565201 != nil:
    section.add "resourceGroupName", valid_565201
  var valid_565202 = path.getOrDefault("managerName")
  valid_565202 = validateParameter(valid_565202, JString, required = true,
                                 default = nil)
  if valid_565202 != nil:
    section.add "managerName", valid_565202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565203 = query.getOrDefault("api-version")
  valid_565203 = validateParameter(valid_565203, JString, required = true,
                                 default = nil)
  if valid_565203 != nil:
    section.add "api-version", valid_565203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565204: Call_ManagersRegenerateActivationKey_565197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Re-generates and returns the activation key of the manager.
  ## 
  let valid = call_565204.validator(path, query, header, formData, body)
  let scheme = call_565204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565204.url(scheme.get, call_565204.host, call_565204.base,
                         call_565204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565204, url, valid)

proc call*(call_565205: Call_ManagersRegenerateActivationKey_565197;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## managersRegenerateActivationKey
  ## Re-generates and returns the activation key of the manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565206 = newJObject()
  var query_565207 = newJObject()
  add(query_565207, "api-version", newJString(apiVersion))
  add(path_565206, "subscriptionId", newJString(subscriptionId))
  add(path_565206, "resourceGroupName", newJString(resourceGroupName))
  add(path_565206, "managerName", newJString(managerName))
  result = call_565205.call(path_565206, query_565207, nil, nil, nil)

var managersRegenerateActivationKey* = Call_ManagersRegenerateActivationKey_565197(
    name: "managersRegenerateActivationKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/regenerateActivationKey",
    validator: validate_ManagersRegenerateActivationKey_565198, base: "",
    url: url_ManagersRegenerateActivationKey_565199, schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsListByManager_565208 = ref object of OpenApiRestCall_563565
proc url_StorageAccountCredentialsListByManager_565210(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/storageAccountCredentials")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountCredentialsListByManager_565209(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the storage account credentials in a manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565211 = path.getOrDefault("subscriptionId")
  valid_565211 = validateParameter(valid_565211, JString, required = true,
                                 default = nil)
  if valid_565211 != nil:
    section.add "subscriptionId", valid_565211
  var valid_565212 = path.getOrDefault("resourceGroupName")
  valid_565212 = validateParameter(valid_565212, JString, required = true,
                                 default = nil)
  if valid_565212 != nil:
    section.add "resourceGroupName", valid_565212
  var valid_565213 = path.getOrDefault("managerName")
  valid_565213 = validateParameter(valid_565213, JString, required = true,
                                 default = nil)
  if valid_565213 != nil:
    section.add "managerName", valid_565213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565214 = query.getOrDefault("api-version")
  valid_565214 = validateParameter(valid_565214, JString, required = true,
                                 default = nil)
  if valid_565214 != nil:
    section.add "api-version", valid_565214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565215: Call_StorageAccountCredentialsListByManager_565208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the storage account credentials in a manager.
  ## 
  let valid = call_565215.validator(path, query, header, formData, body)
  let scheme = call_565215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565215.url(scheme.get, call_565215.host, call_565215.base,
                         call_565215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565215, url, valid)

proc call*(call_565216: Call_StorageAccountCredentialsListByManager_565208;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## storageAccountCredentialsListByManager
  ## Gets all the storage account credentials in a manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565217 = newJObject()
  var query_565218 = newJObject()
  add(query_565218, "api-version", newJString(apiVersion))
  add(path_565217, "subscriptionId", newJString(subscriptionId))
  add(path_565217, "resourceGroupName", newJString(resourceGroupName))
  add(path_565217, "managerName", newJString(managerName))
  result = call_565216.call(path_565217, query_565218, nil, nil, nil)

var storageAccountCredentialsListByManager* = Call_StorageAccountCredentialsListByManager_565208(
    name: "storageAccountCredentialsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials",
    validator: validate_StorageAccountCredentialsListByManager_565209, base: "",
    url: url_StorageAccountCredentialsListByManager_565210,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsCreateOrUpdate_565231 = ref object of OpenApiRestCall_563565
proc url_StorageAccountCredentialsCreateOrUpdate_565233(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "storageAccountCredentialName" in path,
        "`storageAccountCredentialName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/storageAccountCredentials/"),
               (kind: VariableSegment, value: "storageAccountCredentialName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountCredentialsCreateOrUpdate_565232(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the storage account credential.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   storageAccountCredentialName: JString (required)
  ##                               : The storage account credential name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565234 = path.getOrDefault("subscriptionId")
  valid_565234 = validateParameter(valid_565234, JString, required = true,
                                 default = nil)
  if valid_565234 != nil:
    section.add "subscriptionId", valid_565234
  var valid_565235 = path.getOrDefault("resourceGroupName")
  valid_565235 = validateParameter(valid_565235, JString, required = true,
                                 default = nil)
  if valid_565235 != nil:
    section.add "resourceGroupName", valid_565235
  var valid_565236 = path.getOrDefault("managerName")
  valid_565236 = validateParameter(valid_565236, JString, required = true,
                                 default = nil)
  if valid_565236 != nil:
    section.add "managerName", valid_565236
  var valid_565237 = path.getOrDefault("storageAccountCredentialName")
  valid_565237 = validateParameter(valid_565237, JString, required = true,
                                 default = nil)
  if valid_565237 != nil:
    section.add "storageAccountCredentialName", valid_565237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565238 = query.getOrDefault("api-version")
  valid_565238 = validateParameter(valid_565238, JString, required = true,
                                 default = nil)
  if valid_565238 != nil:
    section.add "api-version", valid_565238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The storage account credential to be added or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565240: Call_StorageAccountCredentialsCreateOrUpdate_565231;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the storage account credential.
  ## 
  let valid = call_565240.validator(path, query, header, formData, body)
  let scheme = call_565240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565240.url(scheme.get, call_565240.host, call_565240.base,
                         call_565240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565240, url, valid)

proc call*(call_565241: Call_StorageAccountCredentialsCreateOrUpdate_565231;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          managerName: string; storageAccountCredentialName: string;
          parameters: JsonNode): Recallable =
  ## storageAccountCredentialsCreateOrUpdate
  ## Creates or updates the storage account credential.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   storageAccountCredentialName: string (required)
  ##                               : The storage account credential name.
  ##   parameters: JObject (required)
  ##             : The storage account credential to be added or updated.
  var path_565242 = newJObject()
  var query_565243 = newJObject()
  var body_565244 = newJObject()
  add(query_565243, "api-version", newJString(apiVersion))
  add(path_565242, "subscriptionId", newJString(subscriptionId))
  add(path_565242, "resourceGroupName", newJString(resourceGroupName))
  add(path_565242, "managerName", newJString(managerName))
  add(path_565242, "storageAccountCredentialName",
      newJString(storageAccountCredentialName))
  if parameters != nil:
    body_565244 = parameters
  result = call_565241.call(path_565242, query_565243, nil, nil, body_565244)

var storageAccountCredentialsCreateOrUpdate* = Call_StorageAccountCredentialsCreateOrUpdate_565231(
    name: "storageAccountCredentialsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials/{storageAccountCredentialName}",
    validator: validate_StorageAccountCredentialsCreateOrUpdate_565232, base: "",
    url: url_StorageAccountCredentialsCreateOrUpdate_565233,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsGet_565219 = ref object of OpenApiRestCall_563565
proc url_StorageAccountCredentialsGet_565221(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "storageAccountCredentialName" in path,
        "`storageAccountCredentialName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/storageAccountCredentials/"),
               (kind: VariableSegment, value: "storageAccountCredentialName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountCredentialsGet_565220(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified storage account credential name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   storageAccountCredentialName: JString (required)
  ##                               : The name of storage account credential to be fetched.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565222 = path.getOrDefault("subscriptionId")
  valid_565222 = validateParameter(valid_565222, JString, required = true,
                                 default = nil)
  if valid_565222 != nil:
    section.add "subscriptionId", valid_565222
  var valid_565223 = path.getOrDefault("resourceGroupName")
  valid_565223 = validateParameter(valid_565223, JString, required = true,
                                 default = nil)
  if valid_565223 != nil:
    section.add "resourceGroupName", valid_565223
  var valid_565224 = path.getOrDefault("managerName")
  valid_565224 = validateParameter(valid_565224, JString, required = true,
                                 default = nil)
  if valid_565224 != nil:
    section.add "managerName", valid_565224
  var valid_565225 = path.getOrDefault("storageAccountCredentialName")
  valid_565225 = validateParameter(valid_565225, JString, required = true,
                                 default = nil)
  if valid_565225 != nil:
    section.add "storageAccountCredentialName", valid_565225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565226 = query.getOrDefault("api-version")
  valid_565226 = validateParameter(valid_565226, JString, required = true,
                                 default = nil)
  if valid_565226 != nil:
    section.add "api-version", valid_565226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565227: Call_StorageAccountCredentialsGet_565219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified storage account credential name.
  ## 
  let valid = call_565227.validator(path, query, header, formData, body)
  let scheme = call_565227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565227.url(scheme.get, call_565227.host, call_565227.base,
                         call_565227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565227, url, valid)

proc call*(call_565228: Call_StorageAccountCredentialsGet_565219;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          managerName: string; storageAccountCredentialName: string): Recallable =
  ## storageAccountCredentialsGet
  ## Gets the properties of the specified storage account credential name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   storageAccountCredentialName: string (required)
  ##                               : The name of storage account credential to be fetched.
  var path_565229 = newJObject()
  var query_565230 = newJObject()
  add(query_565230, "api-version", newJString(apiVersion))
  add(path_565229, "subscriptionId", newJString(subscriptionId))
  add(path_565229, "resourceGroupName", newJString(resourceGroupName))
  add(path_565229, "managerName", newJString(managerName))
  add(path_565229, "storageAccountCredentialName",
      newJString(storageAccountCredentialName))
  result = call_565228.call(path_565229, query_565230, nil, nil, nil)

var storageAccountCredentialsGet* = Call_StorageAccountCredentialsGet_565219(
    name: "storageAccountCredentialsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials/{storageAccountCredentialName}",
    validator: validate_StorageAccountCredentialsGet_565220, base: "",
    url: url_StorageAccountCredentialsGet_565221, schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsDelete_565245 = ref object of OpenApiRestCall_563565
proc url_StorageAccountCredentialsDelete_565247(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "storageAccountCredentialName" in path,
        "`storageAccountCredentialName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/storageAccountCredentials/"),
               (kind: VariableSegment, value: "storageAccountCredentialName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountCredentialsDelete_565246(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the storage account credential.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   storageAccountCredentialName: JString (required)
  ##                               : The name of the storage account credential.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565248 = path.getOrDefault("subscriptionId")
  valid_565248 = validateParameter(valid_565248, JString, required = true,
                                 default = nil)
  if valid_565248 != nil:
    section.add "subscriptionId", valid_565248
  var valid_565249 = path.getOrDefault("resourceGroupName")
  valid_565249 = validateParameter(valid_565249, JString, required = true,
                                 default = nil)
  if valid_565249 != nil:
    section.add "resourceGroupName", valid_565249
  var valid_565250 = path.getOrDefault("managerName")
  valid_565250 = validateParameter(valid_565250, JString, required = true,
                                 default = nil)
  if valid_565250 != nil:
    section.add "managerName", valid_565250
  var valid_565251 = path.getOrDefault("storageAccountCredentialName")
  valid_565251 = validateParameter(valid_565251, JString, required = true,
                                 default = nil)
  if valid_565251 != nil:
    section.add "storageAccountCredentialName", valid_565251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565252 = query.getOrDefault("api-version")
  valid_565252 = validateParameter(valid_565252, JString, required = true,
                                 default = nil)
  if valid_565252 != nil:
    section.add "api-version", valid_565252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565253: Call_StorageAccountCredentialsDelete_565245;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the storage account credential.
  ## 
  let valid = call_565253.validator(path, query, header, formData, body)
  let scheme = call_565253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565253.url(scheme.get, call_565253.host, call_565253.base,
                         call_565253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565253, url, valid)

proc call*(call_565254: Call_StorageAccountCredentialsDelete_565245;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          managerName: string; storageAccountCredentialName: string): Recallable =
  ## storageAccountCredentialsDelete
  ## Deletes the storage account credential.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   storageAccountCredentialName: string (required)
  ##                               : The name of the storage account credential.
  var path_565255 = newJObject()
  var query_565256 = newJObject()
  add(query_565256, "api-version", newJString(apiVersion))
  add(path_565255, "subscriptionId", newJString(subscriptionId))
  add(path_565255, "resourceGroupName", newJString(resourceGroupName))
  add(path_565255, "managerName", newJString(managerName))
  add(path_565255, "storageAccountCredentialName",
      newJString(storageAccountCredentialName))
  result = call_565254.call(path_565255, query_565256, nil, nil, nil)

var storageAccountCredentialsDelete* = Call_StorageAccountCredentialsDelete_565245(
    name: "storageAccountCredentialsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials/{storageAccountCredentialName}",
    validator: validate_StorageAccountCredentialsDelete_565246, base: "",
    url: url_StorageAccountCredentialsDelete_565247, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
