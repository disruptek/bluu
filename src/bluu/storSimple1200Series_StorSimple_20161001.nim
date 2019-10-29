
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: StorSimpleManagementClient
## version: 2016-10-01
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
  macServiceName = "storSimple1200Series-StorSimple"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AvailableProviderOperationsList_563787 = ref object of OpenApiRestCall_563565
proc url_AvailableProviderOperationsList_563789(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AvailableProviderOperationsList_563788(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of AvailableProviderOperations
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

proc call*(call_563973: Call_AvailableProviderOperationsList_563787;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List of AvailableProviderOperations
  ## 
  let valid = call_563973.validator(path, query, header, formData, body)
  let scheme = call_563973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563973.url(scheme.get, call_563973.host, call_563973.base,
                         call_563973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563973, url, valid)

proc call*(call_564044: Call_AvailableProviderOperationsList_563787;
          apiVersion: string): Recallable =
  ## availableProviderOperationsList
  ## List of AvailableProviderOperations
  ##   apiVersion: string (required)
  ##             : The api version
  var query_564045 = newJObject()
  add(query_564045, "api-version", newJString(apiVersion))
  result = call_564044.call(nil, query_564045, nil, nil, nil)

var availableProviderOperationsList* = Call_AvailableProviderOperationsList_563787(
    name: "availableProviderOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.StorSimple/operations",
    validator: validate_AvailableProviderOperationsList_563788, base: "",
    url: url_AvailableProviderOperationsList_563789, schemes: {Scheme.Https})
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
  ##   Manager: JObject (required)
  ##          : The manager.
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
          Manager: JsonNode): Recallable =
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
  ##   Manager: JObject (required)
  ##          : The manager.
  var path_564139 = newJObject()
  var query_564140 = newJObject()
  var body_564141 = newJObject()
  add(query_564140, "api-version", newJString(apiVersion))
  add(path_564139, "subscriptionId", newJString(subscriptionId))
  add(path_564139, "resourceGroupName", newJString(resourceGroupName))
  add(path_564139, "managerName", newJString(managerName))
  if Manager != nil:
    body_564141 = Manager
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
  ##   accessControlRecord: JObject (required)
  ##                      : The access control record to be added or updated.
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
          apiVersion: string; accessControlRecord: JsonNode; subscriptionId: string;
          accessControlRecordName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## accessControlRecordsCreateOrUpdate
  ## Creates or Updates an access control record.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   accessControlRecord: JObject (required)
  ##                      : The access control record to be added or updated.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   accessControlRecordName: string (required)
  ##                          : The name of the access control record.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564200 = newJObject()
  var query_564201 = newJObject()
  var body_564202 = newJObject()
  add(query_564201, "api-version", newJString(apiVersion))
  if accessControlRecord != nil:
    body_564202 = accessControlRecord
  add(path_564200, "subscriptionId", newJString(subscriptionId))
  add(path_564200, "accessControlRecordName", newJString(accessControlRecordName))
  add(path_564200, "resourceGroupName", newJString(resourceGroupName))
  add(path_564200, "managerName", newJString(managerName))
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
  Call_BackupsListByManager_564228 = ref object of OpenApiRestCall_563565
proc url_BackupsListByManager_564230(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/backups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupsListByManager_564229(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the backups in a manager.
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
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564234 = query.getOrDefault("api-version")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "api-version", valid_564234
  var valid_564235 = query.getOrDefault("$filter")
  valid_564235 = validateParameter(valid_564235, JString, required = false,
                                 default = nil)
  if valid_564235 != nil:
    section.add "$filter", valid_564235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564236: Call_BackupsListByManager_564228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the backups in a manager.
  ## 
  let valid = call_564236.validator(path, query, header, formData, body)
  let scheme = call_564236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564236.url(scheme.get, call_564236.host, call_564236.base,
                         call_564236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564236, url, valid)

proc call*(call_564237: Call_BackupsListByManager_564228; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string;
          Filter: string = ""): Recallable =
  ## backupsListByManager
  ## Retrieves all the backups in a manager.
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
  var path_564238 = newJObject()
  var query_564239 = newJObject()
  add(query_564239, "api-version", newJString(apiVersion))
  add(path_564238, "subscriptionId", newJString(subscriptionId))
  add(path_564238, "resourceGroupName", newJString(resourceGroupName))
  add(path_564238, "managerName", newJString(managerName))
  add(query_564239, "$filter", newJString(Filter))
  result = call_564237.call(path_564238, query_564239, nil, nil, nil)

var backupsListByManager* = Call_BackupsListByManager_564228(
    name: "backupsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/backups",
    validator: validate_BackupsListByManager_564229, base: "",
    url: url_BackupsListByManager_564230, schemes: {Scheme.Https})
type
  Call_ManagersUploadRegistrationCertificate_564240 = ref object of OpenApiRestCall_563565
proc url_ManagersUploadRegistrationCertificate_564242(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersUploadRegistrationCertificate_564241(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Upload Vault Cred Certificate.
  ## Returns UploadCertificateResponse
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
  ##   certificateName: JString (required)
  ##                  : Certificate Name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
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
  var valid_564246 = path.getOrDefault("certificateName")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "certificateName", valid_564246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564247 = query.getOrDefault("api-version")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "api-version", valid_564247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   uploadCertificateRequestrequest: JObject (required)
  ##                                  : UploadCertificateRequest Request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564249: Call_ManagersUploadRegistrationCertificate_564240;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upload Vault Cred Certificate.
  ## Returns UploadCertificateResponse
  ## 
  let valid = call_564249.validator(path, query, header, formData, body)
  let scheme = call_564249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564249.url(scheme.get, call_564249.host, call_564249.base,
                         call_564249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564249, url, valid)

proc call*(call_564250: Call_ManagersUploadRegistrationCertificate_564240;
          apiVersion: string; subscriptionId: string;
          uploadCertificateRequestrequest: JsonNode; resourceGroupName: string;
          managerName: string; certificateName: string): Recallable =
  ## managersUploadRegistrationCertificate
  ## Upload Vault Cred Certificate.
  ## Returns UploadCertificateResponse
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   uploadCertificateRequestrequest: JObject (required)
  ##                                  : UploadCertificateRequest Request
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   certificateName: string (required)
  ##                  : Certificate Name
  var path_564251 = newJObject()
  var query_564252 = newJObject()
  var body_564253 = newJObject()
  add(query_564252, "api-version", newJString(apiVersion))
  add(path_564251, "subscriptionId", newJString(subscriptionId))
  if uploadCertificateRequestrequest != nil:
    body_564253 = uploadCertificateRequestrequest
  add(path_564251, "resourceGroupName", newJString(resourceGroupName))
  add(path_564251, "managerName", newJString(managerName))
  add(path_564251, "certificateName", newJString(certificateName))
  result = call_564250.call(path_564251, query_564252, nil, nil, body_564253)

var managersUploadRegistrationCertificate* = Call_ManagersUploadRegistrationCertificate_564240(
    name: "managersUploadRegistrationCertificate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/certificates/{certificateName}",
    validator: validate_ManagersUploadRegistrationCertificate_564241, base: "",
    url: url_ManagersUploadRegistrationCertificate_564242, schemes: {Scheme.Https})
type
  Call_AlertsClear_564254 = ref object of OpenApiRestCall_563565
proc url_AlertsClear_564256(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsClear_564255(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564257 = path.getOrDefault("subscriptionId")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "subscriptionId", valid_564257
  var valid_564258 = path.getOrDefault("resourceGroupName")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "resourceGroupName", valid_564258
  var valid_564259 = path.getOrDefault("managerName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "managerName", valid_564259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564260 = query.getOrDefault("api-version")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "api-version", valid_564260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   request: JObject (required)
  ##          : The clear alert request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564262: Call_AlertsClear_564254; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clear the alerts.
  ## 
  let valid = call_564262.validator(path, query, header, formData, body)
  let scheme = call_564262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564262.url(scheme.get, call_564262.host, call_564262.base,
                         call_564262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564262, url, valid)

proc call*(call_564263: Call_AlertsClear_564254; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string;
          request: JsonNode): Recallable =
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
  ##   request: JObject (required)
  ##          : The clear alert request.
  var path_564264 = newJObject()
  var query_564265 = newJObject()
  var body_564266 = newJObject()
  add(query_564265, "api-version", newJString(apiVersion))
  add(path_564264, "subscriptionId", newJString(subscriptionId))
  add(path_564264, "resourceGroupName", newJString(resourceGroupName))
  add(path_564264, "managerName", newJString(managerName))
  if request != nil:
    body_564266 = request
  result = call_564263.call(path_564264, query_564265, nil, nil, body_564266)

var alertsClear* = Call_AlertsClear_564254(name: "alertsClear",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/clearAlerts",
                                        validator: validate_AlertsClear_564255,
                                        base: "", url: url_AlertsClear_564256,
                                        schemes: {Scheme.Https})
type
  Call_DevicesListByManager_564267 = ref object of OpenApiRestCall_563565
proc url_DevicesListByManager_564269(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesListByManager_564268(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the devices in a manager.
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
  var valid_564270 = path.getOrDefault("subscriptionId")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "subscriptionId", valid_564270
  var valid_564271 = path.getOrDefault("resourceGroupName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "resourceGroupName", valid_564271
  var valid_564272 = path.getOrDefault("managerName")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "managerName", valid_564272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the device.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564273 = query.getOrDefault("api-version")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "api-version", valid_564273
  var valid_564274 = query.getOrDefault("$expand")
  valid_564274 = validateParameter(valid_564274, JString, required = false,
                                 default = nil)
  if valid_564274 != nil:
    section.add "$expand", valid_564274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564275: Call_DevicesListByManager_564267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the devices in a manager.
  ## 
  let valid = call_564275.validator(path, query, header, formData, body)
  let scheme = call_564275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564275.url(scheme.get, call_564275.host, call_564275.base,
                         call_564275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564275, url, valid)

proc call*(call_564276: Call_DevicesListByManager_564267; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string;
          Expand: string = ""): Recallable =
  ## devicesListByManager
  ## Retrieves all the devices in a manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   Expand: string
  ##         : Specify $expand=details to populate additional fields related to the device.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564277 = newJObject()
  var query_564278 = newJObject()
  add(query_564278, "api-version", newJString(apiVersion))
  add(query_564278, "$expand", newJString(Expand))
  add(path_564277, "subscriptionId", newJString(subscriptionId))
  add(path_564277, "resourceGroupName", newJString(resourceGroupName))
  add(path_564277, "managerName", newJString(managerName))
  result = call_564276.call(path_564277, query_564278, nil, nil, nil)

var devicesListByManager* = Call_DevicesListByManager_564267(
    name: "devicesListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices",
    validator: validate_DevicesListByManager_564268, base: "",
    url: url_DevicesListByManager_564269, schemes: {Scheme.Https})
type
  Call_DevicesGet_564279 = ref object of OpenApiRestCall_563565
proc url_DevicesGet_564281(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DevicesGet_564280(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified device name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564282 = path.getOrDefault("subscriptionId")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "subscriptionId", valid_564282
  var valid_564283 = path.getOrDefault("deviceName")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "deviceName", valid_564283
  var valid_564284 = path.getOrDefault("resourceGroupName")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "resourceGroupName", valid_564284
  var valid_564285 = path.getOrDefault("managerName")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "managerName", valid_564285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the device.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564286 = query.getOrDefault("api-version")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "api-version", valid_564286
  var valid_564287 = query.getOrDefault("$expand")
  valid_564287 = validateParameter(valid_564287, JString, required = false,
                                 default = nil)
  if valid_564287 != nil:
    section.add "$expand", valid_564287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564288: Call_DevicesGet_564279; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified device name.
  ## 
  let valid = call_564288.validator(path, query, header, formData, body)
  let scheme = call_564288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564288.url(scheme.get, call_564288.host, call_564288.base,
                         call_564288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564288, url, valid)

proc call*(call_564289: Call_DevicesGet_564279; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; Expand: string = ""): Recallable =
  ## devicesGet
  ## Returns the properties of the specified device name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   Expand: string
  ##         : Specify $expand=details to populate additional fields related to the device.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564290 = newJObject()
  var query_564291 = newJObject()
  add(query_564291, "api-version", newJString(apiVersion))
  add(query_564291, "$expand", newJString(Expand))
  add(path_564290, "subscriptionId", newJString(subscriptionId))
  add(path_564290, "deviceName", newJString(deviceName))
  add(path_564290, "resourceGroupName", newJString(resourceGroupName))
  add(path_564290, "managerName", newJString(managerName))
  result = call_564289.call(path_564290, query_564291, nil, nil, nil)

var devicesGet* = Call_DevicesGet_564279(name: "devicesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}",
                                      validator: validate_DevicesGet_564280,
                                      base: "", url: url_DevicesGet_564281,
                                      schemes: {Scheme.Https})
type
  Call_DevicesPatch_564304 = ref object of OpenApiRestCall_563565
proc url_DevicesPatch_564306(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesPatch_564305(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Patches the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device Name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564307 = path.getOrDefault("subscriptionId")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "subscriptionId", valid_564307
  var valid_564308 = path.getOrDefault("deviceName")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "deviceName", valid_564308
  var valid_564309 = path.getOrDefault("resourceGroupName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "resourceGroupName", valid_564309
  var valid_564310 = path.getOrDefault("managerName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "managerName", valid_564310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564311 = query.getOrDefault("api-version")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "api-version", valid_564311
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   devicePatch: JObject (required)
  ##              : Patch representation of the device.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564313: Call_DevicesPatch_564304; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches the device.
  ## 
  let valid = call_564313.validator(path, query, header, formData, body)
  let scheme = call_564313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564313.url(scheme.get, call_564313.host, call_564313.base,
                         call_564313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564313, url, valid)

proc call*(call_564314: Call_DevicesPatch_564304; apiVersion: string;
          devicePatch: JsonNode; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## devicesPatch
  ## Patches the device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   devicePatch: JObject (required)
  ##              : Patch representation of the device.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device Name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564315 = newJObject()
  var query_564316 = newJObject()
  var body_564317 = newJObject()
  add(query_564316, "api-version", newJString(apiVersion))
  if devicePatch != nil:
    body_564317 = devicePatch
  add(path_564315, "subscriptionId", newJString(subscriptionId))
  add(path_564315, "deviceName", newJString(deviceName))
  add(path_564315, "resourceGroupName", newJString(resourceGroupName))
  add(path_564315, "managerName", newJString(managerName))
  result = call_564314.call(path_564315, query_564316, nil, nil, body_564317)

var devicesPatch* = Call_DevicesPatch_564304(name: "devicesPatch",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}",
    validator: validate_DevicesPatch_564305, base: "", url: url_DevicesPatch_564306,
    schemes: {Scheme.Https})
type
  Call_DevicesDelete_564292 = ref object of OpenApiRestCall_563565
proc url_DevicesDelete_564294(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesDelete_564293(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564295 = path.getOrDefault("subscriptionId")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "subscriptionId", valid_564295
  var valid_564296 = path.getOrDefault("deviceName")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "deviceName", valid_564296
  var valid_564297 = path.getOrDefault("resourceGroupName")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "resourceGroupName", valid_564297
  var valid_564298 = path.getOrDefault("managerName")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "managerName", valid_564298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564299 = query.getOrDefault("api-version")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "api-version", valid_564299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564300: Call_DevicesDelete_564292; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the device.
  ## 
  let valid = call_564300.validator(path, query, header, formData, body)
  let scheme = call_564300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564300.url(scheme.get, call_564300.host, call_564300.base,
                         call_564300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564300, url, valid)

proc call*(call_564301: Call_DevicesDelete_564292; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## devicesDelete
  ## Deletes the device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564302 = newJObject()
  var query_564303 = newJObject()
  add(query_564303, "api-version", newJString(apiVersion))
  add(path_564302, "subscriptionId", newJString(subscriptionId))
  add(path_564302, "deviceName", newJString(deviceName))
  add(path_564302, "resourceGroupName", newJString(resourceGroupName))
  add(path_564302, "managerName", newJString(managerName))
  result = call_564301.call(path_564302, query_564303, nil, nil, nil)

var devicesDelete* = Call_DevicesDelete_564292(name: "devicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}",
    validator: validate_DevicesDelete_564293, base: "", url: url_DevicesDelete_564294,
    schemes: {Scheme.Https})
type
  Call_DevicesCreateOrUpdateAlertSettings_564330 = ref object of OpenApiRestCall_563565
proc url_DevicesCreateOrUpdateAlertSettings_564332(protocol: Scheme; host: string;
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

proc validate_DevicesCreateOrUpdateAlertSettings_564331(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the alert settings
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564333 = path.getOrDefault("subscriptionId")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "subscriptionId", valid_564333
  var valid_564334 = path.getOrDefault("deviceName")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "deviceName", valid_564334
  var valid_564335 = path.getOrDefault("resourceGroupName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "resourceGroupName", valid_564335
  var valid_564336 = path.getOrDefault("managerName")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "managerName", valid_564336
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564337 = query.getOrDefault("api-version")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "api-version", valid_564337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   alertSettings: JObject (required)
  ##                : The alert settings.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564339: Call_DevicesCreateOrUpdateAlertSettings_564330;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the alert settings
  ## 
  let valid = call_564339.validator(path, query, header, formData, body)
  let scheme = call_564339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564339.url(scheme.get, call_564339.host, call_564339.base,
                         call_564339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564339, url, valid)

proc call*(call_564340: Call_DevicesCreateOrUpdateAlertSettings_564330;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string; alertSettings: JsonNode): Recallable =
  ## devicesCreateOrUpdateAlertSettings
  ## Creates or updates the alert settings
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   alertSettings: JObject (required)
  ##                : The alert settings.
  var path_564341 = newJObject()
  var query_564342 = newJObject()
  var body_564343 = newJObject()
  add(query_564342, "api-version", newJString(apiVersion))
  add(path_564341, "subscriptionId", newJString(subscriptionId))
  add(path_564341, "deviceName", newJString(deviceName))
  add(path_564341, "resourceGroupName", newJString(resourceGroupName))
  add(path_564341, "managerName", newJString(managerName))
  if alertSettings != nil:
    body_564343 = alertSettings
  result = call_564340.call(path_564341, query_564342, nil, nil, body_564343)

var devicesCreateOrUpdateAlertSettings* = Call_DevicesCreateOrUpdateAlertSettings_564330(
    name: "devicesCreateOrUpdateAlertSettings", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/alertSettings/default",
    validator: validate_DevicesCreateOrUpdateAlertSettings_564331, base: "",
    url: url_DevicesCreateOrUpdateAlertSettings_564332, schemes: {Scheme.Https})
type
  Call_DevicesGetAlertSettings_564318 = ref object of OpenApiRestCall_563565
proc url_DevicesGetAlertSettings_564320(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/alertSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesGetAlertSettings_564319(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the alert settings of the specified device name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564321 = path.getOrDefault("subscriptionId")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "subscriptionId", valid_564321
  var valid_564322 = path.getOrDefault("deviceName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "deviceName", valid_564322
  var valid_564323 = path.getOrDefault("resourceGroupName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "resourceGroupName", valid_564323
  var valid_564324 = path.getOrDefault("managerName")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "managerName", valid_564324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564325 = query.getOrDefault("api-version")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "api-version", valid_564325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564326: Call_DevicesGetAlertSettings_564318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the alert settings of the specified device name.
  ## 
  let valid = call_564326.validator(path, query, header, formData, body)
  let scheme = call_564326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564326.url(scheme.get, call_564326.host, call_564326.base,
                         call_564326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564326, url, valid)

proc call*(call_564327: Call_DevicesGetAlertSettings_564318; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## devicesGetAlertSettings
  ## Returns the alert settings of the specified device name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564328 = newJObject()
  var query_564329 = newJObject()
  add(query_564329, "api-version", newJString(apiVersion))
  add(path_564328, "subscriptionId", newJString(subscriptionId))
  add(path_564328, "deviceName", newJString(deviceName))
  add(path_564328, "resourceGroupName", newJString(resourceGroupName))
  add(path_564328, "managerName", newJString(managerName))
  result = call_564327.call(path_564328, query_564329, nil, nil, nil)

var devicesGetAlertSettings* = Call_DevicesGetAlertSettings_564318(
    name: "devicesGetAlertSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/alertSettings/default",
    validator: validate_DevicesGetAlertSettings_564319, base: "",
    url: url_DevicesGetAlertSettings_564320, schemes: {Scheme.Https})
type
  Call_BackupScheduleGroupsListByDevice_564344 = ref object of OpenApiRestCall_563565
proc url_BackupScheduleGroupsListByDevice_564346(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/backupScheduleGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupScheduleGroupsListByDevice_564345(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the backup schedule groups in a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The name of the device.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564347 = path.getOrDefault("subscriptionId")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "subscriptionId", valid_564347
  var valid_564348 = path.getOrDefault("deviceName")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "deviceName", valid_564348
  var valid_564349 = path.getOrDefault("resourceGroupName")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "resourceGroupName", valid_564349
  var valid_564350 = path.getOrDefault("managerName")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "managerName", valid_564350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564351 = query.getOrDefault("api-version")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "api-version", valid_564351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564352: Call_BackupScheduleGroupsListByDevice_564344;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all the backup schedule groups in a device.
  ## 
  let valid = call_564352.validator(path, query, header, formData, body)
  let scheme = call_564352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564352.url(scheme.get, call_564352.host, call_564352.base,
                         call_564352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564352, url, valid)

proc call*(call_564353: Call_BackupScheduleGroupsListByDevice_564344;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## backupScheduleGroupsListByDevice
  ## Retrieves all the backup schedule groups in a device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The name of the device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564354 = newJObject()
  var query_564355 = newJObject()
  add(query_564355, "api-version", newJString(apiVersion))
  add(path_564354, "subscriptionId", newJString(subscriptionId))
  add(path_564354, "deviceName", newJString(deviceName))
  add(path_564354, "resourceGroupName", newJString(resourceGroupName))
  add(path_564354, "managerName", newJString(managerName))
  result = call_564353.call(path_564354, query_564355, nil, nil, nil)

var backupScheduleGroupsListByDevice* = Call_BackupScheduleGroupsListByDevice_564344(
    name: "backupScheduleGroupsListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupScheduleGroups",
    validator: validate_BackupScheduleGroupsListByDevice_564345, base: "",
    url: url_BackupScheduleGroupsListByDevice_564346, schemes: {Scheme.Https})
type
  Call_BackupScheduleGroupsCreateOrUpdate_564369 = ref object of OpenApiRestCall_563565
proc url_BackupScheduleGroupsCreateOrUpdate_564371(protocol: Scheme; host: string;
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
  assert "scheduleGroupName" in path,
        "`scheduleGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupScheduleGroups/"),
               (kind: VariableSegment, value: "scheduleGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupScheduleGroupsCreateOrUpdate_564370(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates the backup schedule Group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The name of the device.
  ##   scheduleGroupName: JString (required)
  ##                    : The name of the schedule group.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564372 = path.getOrDefault("subscriptionId")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "subscriptionId", valid_564372
  var valid_564373 = path.getOrDefault("deviceName")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "deviceName", valid_564373
  var valid_564374 = path.getOrDefault("scheduleGroupName")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "scheduleGroupName", valid_564374
  var valid_564375 = path.getOrDefault("resourceGroupName")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "resourceGroupName", valid_564375
  var valid_564376 = path.getOrDefault("managerName")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "managerName", valid_564376
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564377 = query.getOrDefault("api-version")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "api-version", valid_564377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   scheduleGroup: JObject (required)
  ##                : The schedule group to be created
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564379: Call_BackupScheduleGroupsCreateOrUpdate_564369;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or Updates the backup schedule Group.
  ## 
  let valid = call_564379.validator(path, query, header, formData, body)
  let scheme = call_564379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564379.url(scheme.get, call_564379.host, call_564379.base,
                         call_564379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564379, url, valid)

proc call*(call_564380: Call_BackupScheduleGroupsCreateOrUpdate_564369;
          scheduleGroup: JsonNode; apiVersion: string; subscriptionId: string;
          deviceName: string; scheduleGroupName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## backupScheduleGroupsCreateOrUpdate
  ## Creates or Updates the backup schedule Group.
  ##   scheduleGroup: JObject (required)
  ##                : The schedule group to be created
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The name of the device.
  ##   scheduleGroupName: string (required)
  ##                    : The name of the schedule group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564381 = newJObject()
  var query_564382 = newJObject()
  var body_564383 = newJObject()
  if scheduleGroup != nil:
    body_564383 = scheduleGroup
  add(query_564382, "api-version", newJString(apiVersion))
  add(path_564381, "subscriptionId", newJString(subscriptionId))
  add(path_564381, "deviceName", newJString(deviceName))
  add(path_564381, "scheduleGroupName", newJString(scheduleGroupName))
  add(path_564381, "resourceGroupName", newJString(resourceGroupName))
  add(path_564381, "managerName", newJString(managerName))
  result = call_564380.call(path_564381, query_564382, nil, nil, body_564383)

var backupScheduleGroupsCreateOrUpdate* = Call_BackupScheduleGroupsCreateOrUpdate_564369(
    name: "backupScheduleGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupScheduleGroups/{scheduleGroupName}",
    validator: validate_BackupScheduleGroupsCreateOrUpdate_564370, base: "",
    url: url_BackupScheduleGroupsCreateOrUpdate_564371, schemes: {Scheme.Https})
type
  Call_BackupScheduleGroupsGet_564356 = ref object of OpenApiRestCall_563565
proc url_BackupScheduleGroupsGet_564358(protocol: Scheme; host: string; base: string;
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
  assert "scheduleGroupName" in path,
        "`scheduleGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupScheduleGroups/"),
               (kind: VariableSegment, value: "scheduleGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupScheduleGroupsGet_564357(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified backup schedule group name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The name of the device.
  ##   scheduleGroupName: JString (required)
  ##                    : The name of the schedule group.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564359 = path.getOrDefault("subscriptionId")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "subscriptionId", valid_564359
  var valid_564360 = path.getOrDefault("deviceName")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "deviceName", valid_564360
  var valid_564361 = path.getOrDefault("scheduleGroupName")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "scheduleGroupName", valid_564361
  var valid_564362 = path.getOrDefault("resourceGroupName")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "resourceGroupName", valid_564362
  var valid_564363 = path.getOrDefault("managerName")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "managerName", valid_564363
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564364 = query.getOrDefault("api-version")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "api-version", valid_564364
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564365: Call_BackupScheduleGroupsGet_564356; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified backup schedule group name.
  ## 
  let valid = call_564365.validator(path, query, header, formData, body)
  let scheme = call_564365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564365.url(scheme.get, call_564365.host, call_564365.base,
                         call_564365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564365, url, valid)

proc call*(call_564366: Call_BackupScheduleGroupsGet_564356; apiVersion: string;
          subscriptionId: string; deviceName: string; scheduleGroupName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## backupScheduleGroupsGet
  ## Returns the properties of the specified backup schedule group name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The name of the device.
  ##   scheduleGroupName: string (required)
  ##                    : The name of the schedule group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564367 = newJObject()
  var query_564368 = newJObject()
  add(query_564368, "api-version", newJString(apiVersion))
  add(path_564367, "subscriptionId", newJString(subscriptionId))
  add(path_564367, "deviceName", newJString(deviceName))
  add(path_564367, "scheduleGroupName", newJString(scheduleGroupName))
  add(path_564367, "resourceGroupName", newJString(resourceGroupName))
  add(path_564367, "managerName", newJString(managerName))
  result = call_564366.call(path_564367, query_564368, nil, nil, nil)

var backupScheduleGroupsGet* = Call_BackupScheduleGroupsGet_564356(
    name: "backupScheduleGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupScheduleGroups/{scheduleGroupName}",
    validator: validate_BackupScheduleGroupsGet_564357, base: "",
    url: url_BackupScheduleGroupsGet_564358, schemes: {Scheme.Https})
type
  Call_BackupScheduleGroupsDelete_564384 = ref object of OpenApiRestCall_563565
proc url_BackupScheduleGroupsDelete_564386(protocol: Scheme; host: string;
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
  assert "scheduleGroupName" in path,
        "`scheduleGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupScheduleGroups/"),
               (kind: VariableSegment, value: "scheduleGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupScheduleGroupsDelete_564385(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the backup schedule group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The name of the device.
  ##   scheduleGroupName: JString (required)
  ##                    : The name of the schedule group.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564387 = path.getOrDefault("subscriptionId")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "subscriptionId", valid_564387
  var valid_564388 = path.getOrDefault("deviceName")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "deviceName", valid_564388
  var valid_564389 = path.getOrDefault("scheduleGroupName")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "scheduleGroupName", valid_564389
  var valid_564390 = path.getOrDefault("resourceGroupName")
  valid_564390 = validateParameter(valid_564390, JString, required = true,
                                 default = nil)
  if valid_564390 != nil:
    section.add "resourceGroupName", valid_564390
  var valid_564391 = path.getOrDefault("managerName")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "managerName", valid_564391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564392 = query.getOrDefault("api-version")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "api-version", valid_564392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564393: Call_BackupScheduleGroupsDelete_564384; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the backup schedule group.
  ## 
  let valid = call_564393.validator(path, query, header, formData, body)
  let scheme = call_564393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564393.url(scheme.get, call_564393.host, call_564393.base,
                         call_564393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564393, url, valid)

proc call*(call_564394: Call_BackupScheduleGroupsDelete_564384; apiVersion: string;
          subscriptionId: string; deviceName: string; scheduleGroupName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## backupScheduleGroupsDelete
  ## Deletes the backup schedule group.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The name of the device.
  ##   scheduleGroupName: string (required)
  ##                    : The name of the schedule group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564395 = newJObject()
  var query_564396 = newJObject()
  add(query_564396, "api-version", newJString(apiVersion))
  add(path_564395, "subscriptionId", newJString(subscriptionId))
  add(path_564395, "deviceName", newJString(deviceName))
  add(path_564395, "scheduleGroupName", newJString(scheduleGroupName))
  add(path_564395, "resourceGroupName", newJString(resourceGroupName))
  add(path_564395, "managerName", newJString(managerName))
  result = call_564394.call(path_564395, query_564396, nil, nil, nil)

var backupScheduleGroupsDelete* = Call_BackupScheduleGroupsDelete_564384(
    name: "backupScheduleGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupScheduleGroups/{scheduleGroupName}",
    validator: validate_BackupScheduleGroupsDelete_564385, base: "",
    url: url_BackupScheduleGroupsDelete_564386, schemes: {Scheme.Https})
type
  Call_BackupsListByDevice_564397 = ref object of OpenApiRestCall_563565
proc url_BackupsListByDevice_564399(protocol: Scheme; host: string; base: string;
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

proc validate_BackupsListByDevice_564398(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves all the backups in a device. Can be used to get the backups for failover also.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564400 = path.getOrDefault("subscriptionId")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "subscriptionId", valid_564400
  var valid_564401 = path.getOrDefault("deviceName")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "deviceName", valid_564401
  var valid_564402 = path.getOrDefault("resourceGroupName")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "resourceGroupName", valid_564402
  var valid_564403 = path.getOrDefault("managerName")
  valid_564403 = validateParameter(valid_564403, JString, required = true,
                                 default = nil)
  if valid_564403 != nil:
    section.add "managerName", valid_564403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  ##   forFailover: JBool
  ##              : Set to true if you need backups which can be used for failover.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564404 = query.getOrDefault("api-version")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "api-version", valid_564404
  var valid_564405 = query.getOrDefault("$filter")
  valid_564405 = validateParameter(valid_564405, JString, required = false,
                                 default = nil)
  if valid_564405 != nil:
    section.add "$filter", valid_564405
  var valid_564406 = query.getOrDefault("forFailover")
  valid_564406 = validateParameter(valid_564406, JBool, required = false, default = nil)
  if valid_564406 != nil:
    section.add "forFailover", valid_564406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564407: Call_BackupsListByDevice_564397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the backups in a device. Can be used to get the backups for failover also.
  ## 
  let valid = call_564407.validator(path, query, header, formData, body)
  let scheme = call_564407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564407.url(scheme.get, call_564407.host, call_564407.base,
                         call_564407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564407, url, valid)

proc call*(call_564408: Call_BackupsListByDevice_564397; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; Filter: string = ""; forFailover: bool = false): Recallable =
  ## backupsListByDevice
  ## Retrieves all the backups in a device. Can be used to get the backups for failover also.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   Filter: string
  ##         : OData Filter options
  ##   forFailover: bool
  ##              : Set to true if you need backups which can be used for failover.
  var path_564409 = newJObject()
  var query_564410 = newJObject()
  add(query_564410, "api-version", newJString(apiVersion))
  add(path_564409, "subscriptionId", newJString(subscriptionId))
  add(path_564409, "deviceName", newJString(deviceName))
  add(path_564409, "resourceGroupName", newJString(resourceGroupName))
  add(path_564409, "managerName", newJString(managerName))
  add(query_564410, "$filter", newJString(Filter))
  add(query_564410, "forFailover", newJBool(forFailover))
  result = call_564408.call(path_564409, query_564410, nil, nil, nil)

var backupsListByDevice* = Call_BackupsListByDevice_564397(
    name: "backupsListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups",
    validator: validate_BackupsListByDevice_564398, base: "",
    url: url_BackupsListByDevice_564399, schemes: {Scheme.Https})
type
  Call_BackupsDelete_564411 = ref object of OpenApiRestCall_563565
proc url_BackupsDelete_564413(protocol: Scheme; host: string; base: string;
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

proc validate_BackupsDelete_564412(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the backup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   backupName: JString (required)
  ##             : The backup name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564414 = path.getOrDefault("subscriptionId")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "subscriptionId", valid_564414
  var valid_564415 = path.getOrDefault("deviceName")
  valid_564415 = validateParameter(valid_564415, JString, required = true,
                                 default = nil)
  if valid_564415 != nil:
    section.add "deviceName", valid_564415
  var valid_564416 = path.getOrDefault("resourceGroupName")
  valid_564416 = validateParameter(valid_564416, JString, required = true,
                                 default = nil)
  if valid_564416 != nil:
    section.add "resourceGroupName", valid_564416
  var valid_564417 = path.getOrDefault("managerName")
  valid_564417 = validateParameter(valid_564417, JString, required = true,
                                 default = nil)
  if valid_564417 != nil:
    section.add "managerName", valid_564417
  var valid_564418 = path.getOrDefault("backupName")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "backupName", valid_564418
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564419 = query.getOrDefault("api-version")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = nil)
  if valid_564419 != nil:
    section.add "api-version", valid_564419
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564420: Call_BackupsDelete_564411; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the backup.
  ## 
  let valid = call_564420.validator(path, query, header, formData, body)
  let scheme = call_564420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564420.url(scheme.get, call_564420.host, call_564420.base,
                         call_564420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564420, url, valid)

proc call*(call_564421: Call_BackupsDelete_564411; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; backupName: string): Recallable =
  ## backupsDelete
  ## Deletes the backup.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   backupName: string (required)
  ##             : The backup name.
  var path_564422 = newJObject()
  var query_564423 = newJObject()
  add(query_564423, "api-version", newJString(apiVersion))
  add(path_564422, "subscriptionId", newJString(subscriptionId))
  add(path_564422, "deviceName", newJString(deviceName))
  add(path_564422, "resourceGroupName", newJString(resourceGroupName))
  add(path_564422, "managerName", newJString(managerName))
  add(path_564422, "backupName", newJString(backupName))
  result = call_564421.call(path_564422, query_564423, nil, nil, nil)

var backupsDelete* = Call_BackupsDelete_564411(name: "backupsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups/{backupName}",
    validator: validate_BackupsDelete_564412, base: "", url: url_BackupsDelete_564413,
    schemes: {Scheme.Https})
type
  Call_BackupsClone_564424 = ref object of OpenApiRestCall_563565
proc url_BackupsClone_564426(protocol: Scheme; host: string; base: string;
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
  assert "elementName" in path, "`elementName` is a required path parameter"
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
               (kind: VariableSegment, value: "elementName"),
               (kind: ConstantSegment, value: "/clone")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupsClone_564425(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Clones the given backup element to a new disk or share with given details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   elementName: JString (required)
  ##              : The backup element name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   backupName: JString (required)
  ##             : The backup name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564427 = path.getOrDefault("subscriptionId")
  valid_564427 = validateParameter(valid_564427, JString, required = true,
                                 default = nil)
  if valid_564427 != nil:
    section.add "subscriptionId", valid_564427
  var valid_564428 = path.getOrDefault("elementName")
  valid_564428 = validateParameter(valid_564428, JString, required = true,
                                 default = nil)
  if valid_564428 != nil:
    section.add "elementName", valid_564428
  var valid_564429 = path.getOrDefault("deviceName")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "deviceName", valid_564429
  var valid_564430 = path.getOrDefault("resourceGroupName")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "resourceGroupName", valid_564430
  var valid_564431 = path.getOrDefault("managerName")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "managerName", valid_564431
  var valid_564432 = path.getOrDefault("backupName")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "backupName", valid_564432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564433 = query.getOrDefault("api-version")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "api-version", valid_564433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   cloneRequest: JObject (required)
  ##               : The clone request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564435: Call_BackupsClone_564424; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clones the given backup element to a new disk or share with given details.
  ## 
  let valid = call_564435.validator(path, query, header, formData, body)
  let scheme = call_564435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564435.url(scheme.get, call_564435.host, call_564435.base,
                         call_564435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564435, url, valid)

proc call*(call_564436: Call_BackupsClone_564424; apiVersion: string;
          subscriptionId: string; elementName: string; deviceName: string;
          resourceGroupName: string; cloneRequest: JsonNode; managerName: string;
          backupName: string): Recallable =
  ## backupsClone
  ## Clones the given backup element to a new disk or share with given details.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   elementName: string (required)
  ##              : The backup element name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   cloneRequest: JObject (required)
  ##               : The clone request.
  ##   managerName: string (required)
  ##              : The manager name
  ##   backupName: string (required)
  ##             : The backup name.
  var path_564437 = newJObject()
  var query_564438 = newJObject()
  var body_564439 = newJObject()
  add(query_564438, "api-version", newJString(apiVersion))
  add(path_564437, "subscriptionId", newJString(subscriptionId))
  add(path_564437, "elementName", newJString(elementName))
  add(path_564437, "deviceName", newJString(deviceName))
  add(path_564437, "resourceGroupName", newJString(resourceGroupName))
  if cloneRequest != nil:
    body_564439 = cloneRequest
  add(path_564437, "managerName", newJString(managerName))
  add(path_564437, "backupName", newJString(backupName))
  result = call_564436.call(path_564437, query_564438, nil, nil, body_564439)

var backupsClone* = Call_BackupsClone_564424(name: "backupsClone",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups/{backupName}/elements/{elementName}/clone",
    validator: validate_BackupsClone_564425, base: "", url: url_BackupsClone_564426,
    schemes: {Scheme.Https})
type
  Call_ChapSettingsListByDevice_564440 = ref object of OpenApiRestCall_563565
proc url_ChapSettingsListByDevice_564442(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/chapSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChapSettingsListByDevice_564441(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the chap settings in a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The name of the device.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564443 = path.getOrDefault("subscriptionId")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "subscriptionId", valid_564443
  var valid_564444 = path.getOrDefault("deviceName")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "deviceName", valid_564444
  var valid_564445 = path.getOrDefault("resourceGroupName")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "resourceGroupName", valid_564445
  var valid_564446 = path.getOrDefault("managerName")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "managerName", valid_564446
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564447 = query.getOrDefault("api-version")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "api-version", valid_564447
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564448: Call_ChapSettingsListByDevice_564440; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the chap settings in a device.
  ## 
  let valid = call_564448.validator(path, query, header, formData, body)
  let scheme = call_564448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564448.url(scheme.get, call_564448.host, call_564448.base,
                         call_564448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564448, url, valid)

proc call*(call_564449: Call_ChapSettingsListByDevice_564440; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## chapSettingsListByDevice
  ## Retrieves all the chap settings in a device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The name of the device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564450 = newJObject()
  var query_564451 = newJObject()
  add(query_564451, "api-version", newJString(apiVersion))
  add(path_564450, "subscriptionId", newJString(subscriptionId))
  add(path_564450, "deviceName", newJString(deviceName))
  add(path_564450, "resourceGroupName", newJString(resourceGroupName))
  add(path_564450, "managerName", newJString(managerName))
  result = call_564449.call(path_564450, query_564451, nil, nil, nil)

var chapSettingsListByDevice* = Call_ChapSettingsListByDevice_564440(
    name: "chapSettingsListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/chapSettings",
    validator: validate_ChapSettingsListByDevice_564441, base: "",
    url: url_ChapSettingsListByDevice_564442, schemes: {Scheme.Https})
type
  Call_ChapSettingsCreateOrUpdate_564465 = ref object of OpenApiRestCall_563565
proc url_ChapSettingsCreateOrUpdate_564467(protocol: Scheme; host: string;
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
  assert "chapUserName" in path, "`chapUserName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/chapSettings/"),
               (kind: VariableSegment, value: "chapUserName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChapSettingsCreateOrUpdate_564466(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the chap setting.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   chapUserName: JString (required)
  ##               : The chap user name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564468 = path.getOrDefault("subscriptionId")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "subscriptionId", valid_564468
  var valid_564469 = path.getOrDefault("chapUserName")
  valid_564469 = validateParameter(valid_564469, JString, required = true,
                                 default = nil)
  if valid_564469 != nil:
    section.add "chapUserName", valid_564469
  var valid_564470 = path.getOrDefault("deviceName")
  valid_564470 = validateParameter(valid_564470, JString, required = true,
                                 default = nil)
  if valid_564470 != nil:
    section.add "deviceName", valid_564470
  var valid_564471 = path.getOrDefault("resourceGroupName")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "resourceGroupName", valid_564471
  var valid_564472 = path.getOrDefault("managerName")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "managerName", valid_564472
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564473 = query.getOrDefault("api-version")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "api-version", valid_564473
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   chapSetting: JObject (required)
  ##              : The chap setting to be added or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564475: Call_ChapSettingsCreateOrUpdate_564465; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the chap setting.
  ## 
  let valid = call_564475.validator(path, query, header, formData, body)
  let scheme = call_564475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564475.url(scheme.get, call_564475.host, call_564475.base,
                         call_564475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564475, url, valid)

proc call*(call_564476: Call_ChapSettingsCreateOrUpdate_564465;
          chapSetting: JsonNode; apiVersion: string; subscriptionId: string;
          chapUserName: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## chapSettingsCreateOrUpdate
  ## Creates or updates the chap setting.
  ##   chapSetting: JObject (required)
  ##              : The chap setting to be added or updated.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   chapUserName: string (required)
  ##               : The chap user name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564477 = newJObject()
  var query_564478 = newJObject()
  var body_564479 = newJObject()
  if chapSetting != nil:
    body_564479 = chapSetting
  add(query_564478, "api-version", newJString(apiVersion))
  add(path_564477, "subscriptionId", newJString(subscriptionId))
  add(path_564477, "chapUserName", newJString(chapUserName))
  add(path_564477, "deviceName", newJString(deviceName))
  add(path_564477, "resourceGroupName", newJString(resourceGroupName))
  add(path_564477, "managerName", newJString(managerName))
  result = call_564476.call(path_564477, query_564478, nil, nil, body_564479)

var chapSettingsCreateOrUpdate* = Call_ChapSettingsCreateOrUpdate_564465(
    name: "chapSettingsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/chapSettings/{chapUserName}",
    validator: validate_ChapSettingsCreateOrUpdate_564466, base: "",
    url: url_ChapSettingsCreateOrUpdate_564467, schemes: {Scheme.Https})
type
  Call_ChapSettingsGet_564452 = ref object of OpenApiRestCall_563565
proc url_ChapSettingsGet_564454(protocol: Scheme; host: string; base: string;
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
  assert "chapUserName" in path, "`chapUserName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/chapSettings/"),
               (kind: VariableSegment, value: "chapUserName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChapSettingsGet_564453(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Returns the properties of the specified chap setting name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   chapUserName: JString (required)
  ##               : The user name of chap to be fetched.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564455 = path.getOrDefault("subscriptionId")
  valid_564455 = validateParameter(valid_564455, JString, required = true,
                                 default = nil)
  if valid_564455 != nil:
    section.add "subscriptionId", valid_564455
  var valid_564456 = path.getOrDefault("chapUserName")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "chapUserName", valid_564456
  var valid_564457 = path.getOrDefault("deviceName")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "deviceName", valid_564457
  var valid_564458 = path.getOrDefault("resourceGroupName")
  valid_564458 = validateParameter(valid_564458, JString, required = true,
                                 default = nil)
  if valid_564458 != nil:
    section.add "resourceGroupName", valid_564458
  var valid_564459 = path.getOrDefault("managerName")
  valid_564459 = validateParameter(valid_564459, JString, required = true,
                                 default = nil)
  if valid_564459 != nil:
    section.add "managerName", valid_564459
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564460 = query.getOrDefault("api-version")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "api-version", valid_564460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564461: Call_ChapSettingsGet_564452; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified chap setting name.
  ## 
  let valid = call_564461.validator(path, query, header, formData, body)
  let scheme = call_564461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564461.url(scheme.get, call_564461.host, call_564461.base,
                         call_564461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564461, url, valid)

proc call*(call_564462: Call_ChapSettingsGet_564452; apiVersion: string;
          subscriptionId: string; chapUserName: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## chapSettingsGet
  ## Returns the properties of the specified chap setting name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   chapUserName: string (required)
  ##               : The user name of chap to be fetched.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564463 = newJObject()
  var query_564464 = newJObject()
  add(query_564464, "api-version", newJString(apiVersion))
  add(path_564463, "subscriptionId", newJString(subscriptionId))
  add(path_564463, "chapUserName", newJString(chapUserName))
  add(path_564463, "deviceName", newJString(deviceName))
  add(path_564463, "resourceGroupName", newJString(resourceGroupName))
  add(path_564463, "managerName", newJString(managerName))
  result = call_564462.call(path_564463, query_564464, nil, nil, nil)

var chapSettingsGet* = Call_ChapSettingsGet_564452(name: "chapSettingsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/chapSettings/{chapUserName}",
    validator: validate_ChapSettingsGet_564453, base: "", url: url_ChapSettingsGet_564454,
    schemes: {Scheme.Https})
type
  Call_ChapSettingsDelete_564480 = ref object of OpenApiRestCall_563565
proc url_ChapSettingsDelete_564482(protocol: Scheme; host: string; base: string;
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
  assert "chapUserName" in path, "`chapUserName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/chapSettings/"),
               (kind: VariableSegment, value: "chapUserName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChapSettingsDelete_564481(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the chap setting.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   chapUserName: JString (required)
  ##               : The chap user name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564483 = path.getOrDefault("subscriptionId")
  valid_564483 = validateParameter(valid_564483, JString, required = true,
                                 default = nil)
  if valid_564483 != nil:
    section.add "subscriptionId", valid_564483
  var valid_564484 = path.getOrDefault("chapUserName")
  valid_564484 = validateParameter(valid_564484, JString, required = true,
                                 default = nil)
  if valid_564484 != nil:
    section.add "chapUserName", valid_564484
  var valid_564485 = path.getOrDefault("deviceName")
  valid_564485 = validateParameter(valid_564485, JString, required = true,
                                 default = nil)
  if valid_564485 != nil:
    section.add "deviceName", valid_564485
  var valid_564486 = path.getOrDefault("resourceGroupName")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "resourceGroupName", valid_564486
  var valid_564487 = path.getOrDefault("managerName")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "managerName", valid_564487
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564488 = query.getOrDefault("api-version")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = nil)
  if valid_564488 != nil:
    section.add "api-version", valid_564488
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564489: Call_ChapSettingsDelete_564480; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the chap setting.
  ## 
  let valid = call_564489.validator(path, query, header, formData, body)
  let scheme = call_564489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564489.url(scheme.get, call_564489.host, call_564489.base,
                         call_564489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564489, url, valid)

proc call*(call_564490: Call_ChapSettingsDelete_564480; apiVersion: string;
          subscriptionId: string; chapUserName: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## chapSettingsDelete
  ## Deletes the chap setting.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   chapUserName: string (required)
  ##               : The chap user name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564491 = newJObject()
  var query_564492 = newJObject()
  add(query_564492, "api-version", newJString(apiVersion))
  add(path_564491, "subscriptionId", newJString(subscriptionId))
  add(path_564491, "chapUserName", newJString(chapUserName))
  add(path_564491, "deviceName", newJString(deviceName))
  add(path_564491, "resourceGroupName", newJString(resourceGroupName))
  add(path_564491, "managerName", newJString(managerName))
  result = call_564490.call(path_564491, query_564492, nil, nil, nil)

var chapSettingsDelete* = Call_ChapSettingsDelete_564480(
    name: "chapSettingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/chapSettings/{chapUserName}",
    validator: validate_ChapSettingsDelete_564481, base: "",
    url: url_ChapSettingsDelete_564482, schemes: {Scheme.Https})
type
  Call_DevicesDeactivate_564493 = ref object of OpenApiRestCall_563565
proc url_DevicesDeactivate_564495(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesDeactivate_564494(path: JsonNode; query: JsonNode;
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
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564496 = path.getOrDefault("subscriptionId")
  valid_564496 = validateParameter(valid_564496, JString, required = true,
                                 default = nil)
  if valid_564496 != nil:
    section.add "subscriptionId", valid_564496
  var valid_564497 = path.getOrDefault("deviceName")
  valid_564497 = validateParameter(valid_564497, JString, required = true,
                                 default = nil)
  if valid_564497 != nil:
    section.add "deviceName", valid_564497
  var valid_564498 = path.getOrDefault("resourceGroupName")
  valid_564498 = validateParameter(valid_564498, JString, required = true,
                                 default = nil)
  if valid_564498 != nil:
    section.add "resourceGroupName", valid_564498
  var valid_564499 = path.getOrDefault("managerName")
  valid_564499 = validateParameter(valid_564499, JString, required = true,
                                 default = nil)
  if valid_564499 != nil:
    section.add "managerName", valid_564499
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564500 = query.getOrDefault("api-version")
  valid_564500 = validateParameter(valid_564500, JString, required = true,
                                 default = nil)
  if valid_564500 != nil:
    section.add "api-version", valid_564500
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564501: Call_DevicesDeactivate_564493; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deactivates the device.
  ## 
  let valid = call_564501.validator(path, query, header, formData, body)
  let scheme = call_564501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564501.url(scheme.get, call_564501.host, call_564501.base,
                         call_564501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564501, url, valid)

proc call*(call_564502: Call_DevicesDeactivate_564493; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## devicesDeactivate
  ## Deactivates the device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564503 = newJObject()
  var query_564504 = newJObject()
  add(query_564504, "api-version", newJString(apiVersion))
  add(path_564503, "subscriptionId", newJString(subscriptionId))
  add(path_564503, "deviceName", newJString(deviceName))
  add(path_564503, "resourceGroupName", newJString(resourceGroupName))
  add(path_564503, "managerName", newJString(managerName))
  result = call_564502.call(path_564503, query_564504, nil, nil, nil)

var devicesDeactivate* = Call_DevicesDeactivate_564493(name: "devicesDeactivate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/deactivate",
    validator: validate_DevicesDeactivate_564494, base: "",
    url: url_DevicesDeactivate_564495, schemes: {Scheme.Https})
type
  Call_IscsiDisksListByDevice_564505 = ref object of OpenApiRestCall_563565
proc url_IscsiDisksListByDevice_564507(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/disks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiDisksListByDevice_564506(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the iSCSI disks in a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564508 = path.getOrDefault("subscriptionId")
  valid_564508 = validateParameter(valid_564508, JString, required = true,
                                 default = nil)
  if valid_564508 != nil:
    section.add "subscriptionId", valid_564508
  var valid_564509 = path.getOrDefault("deviceName")
  valid_564509 = validateParameter(valid_564509, JString, required = true,
                                 default = nil)
  if valid_564509 != nil:
    section.add "deviceName", valid_564509
  var valid_564510 = path.getOrDefault("resourceGroupName")
  valid_564510 = validateParameter(valid_564510, JString, required = true,
                                 default = nil)
  if valid_564510 != nil:
    section.add "resourceGroupName", valid_564510
  var valid_564511 = path.getOrDefault("managerName")
  valid_564511 = validateParameter(valid_564511, JString, required = true,
                                 default = nil)
  if valid_564511 != nil:
    section.add "managerName", valid_564511
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564512 = query.getOrDefault("api-version")
  valid_564512 = validateParameter(valid_564512, JString, required = true,
                                 default = nil)
  if valid_564512 != nil:
    section.add "api-version", valid_564512
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564513: Call_IscsiDisksListByDevice_564505; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the iSCSI disks in a device.
  ## 
  let valid = call_564513.validator(path, query, header, formData, body)
  let scheme = call_564513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564513.url(scheme.get, call_564513.host, call_564513.base,
                         call_564513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564513, url, valid)

proc call*(call_564514: Call_IscsiDisksListByDevice_564505; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## iscsiDisksListByDevice
  ## Retrieves all the iSCSI disks in a device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564515 = newJObject()
  var query_564516 = newJObject()
  add(query_564516, "api-version", newJString(apiVersion))
  add(path_564515, "subscriptionId", newJString(subscriptionId))
  add(path_564515, "deviceName", newJString(deviceName))
  add(path_564515, "resourceGroupName", newJString(resourceGroupName))
  add(path_564515, "managerName", newJString(managerName))
  result = call_564514.call(path_564515, query_564516, nil, nil, nil)

var iscsiDisksListByDevice* = Call_IscsiDisksListByDevice_564505(
    name: "iscsiDisksListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/disks",
    validator: validate_IscsiDisksListByDevice_564506, base: "",
    url: url_IscsiDisksListByDevice_564507, schemes: {Scheme.Https})
type
  Call_DevicesDownloadUpdates_564517 = ref object of OpenApiRestCall_563565
proc url_DevicesDownloadUpdates_564519(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/download")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesDownloadUpdates_564518(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Downloads updates on the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564520 = path.getOrDefault("subscriptionId")
  valid_564520 = validateParameter(valid_564520, JString, required = true,
                                 default = nil)
  if valid_564520 != nil:
    section.add "subscriptionId", valid_564520
  var valid_564521 = path.getOrDefault("deviceName")
  valid_564521 = validateParameter(valid_564521, JString, required = true,
                                 default = nil)
  if valid_564521 != nil:
    section.add "deviceName", valid_564521
  var valid_564522 = path.getOrDefault("resourceGroupName")
  valid_564522 = validateParameter(valid_564522, JString, required = true,
                                 default = nil)
  if valid_564522 != nil:
    section.add "resourceGroupName", valid_564522
  var valid_564523 = path.getOrDefault("managerName")
  valid_564523 = validateParameter(valid_564523, JString, required = true,
                                 default = nil)
  if valid_564523 != nil:
    section.add "managerName", valid_564523
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564524 = query.getOrDefault("api-version")
  valid_564524 = validateParameter(valid_564524, JString, required = true,
                                 default = nil)
  if valid_564524 != nil:
    section.add "api-version", valid_564524
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564525: Call_DevicesDownloadUpdates_564517; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Downloads updates on the device.
  ## 
  let valid = call_564525.validator(path, query, header, formData, body)
  let scheme = call_564525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564525.url(scheme.get, call_564525.host, call_564525.base,
                         call_564525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564525, url, valid)

proc call*(call_564526: Call_DevicesDownloadUpdates_564517; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## devicesDownloadUpdates
  ## Downloads updates on the device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564527 = newJObject()
  var query_564528 = newJObject()
  add(query_564528, "api-version", newJString(apiVersion))
  add(path_564527, "subscriptionId", newJString(subscriptionId))
  add(path_564527, "deviceName", newJString(deviceName))
  add(path_564527, "resourceGroupName", newJString(resourceGroupName))
  add(path_564527, "managerName", newJString(managerName))
  result = call_564526.call(path_564527, query_564528, nil, nil, nil)

var devicesDownloadUpdates* = Call_DevicesDownloadUpdates_564517(
    name: "devicesDownloadUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/download",
    validator: validate_DevicesDownloadUpdates_564518, base: "",
    url: url_DevicesDownloadUpdates_564519, schemes: {Scheme.Https})
type
  Call_DevicesFailover_564529 = ref object of OpenApiRestCall_563565
proc url_DevicesFailover_564531(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/failover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesFailover_564530(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Fails over the device to another device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564532 = path.getOrDefault("subscriptionId")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "subscriptionId", valid_564532
  var valid_564533 = path.getOrDefault("deviceName")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = nil)
  if valid_564533 != nil:
    section.add "deviceName", valid_564533
  var valid_564534 = path.getOrDefault("resourceGroupName")
  valid_564534 = validateParameter(valid_564534, JString, required = true,
                                 default = nil)
  if valid_564534 != nil:
    section.add "resourceGroupName", valid_564534
  var valid_564535 = path.getOrDefault("managerName")
  valid_564535 = validateParameter(valid_564535, JString, required = true,
                                 default = nil)
  if valid_564535 != nil:
    section.add "managerName", valid_564535
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564536 = query.getOrDefault("api-version")
  valid_564536 = validateParameter(valid_564536, JString, required = true,
                                 default = nil)
  if valid_564536 != nil:
    section.add "api-version", valid_564536
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   failoverRequest: JObject (required)
  ##                  : The failover request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564538: Call_DevicesFailover_564529; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fails over the device to another device.
  ## 
  let valid = call_564538.validator(path, query, header, formData, body)
  let scheme = call_564538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564538.url(scheme.get, call_564538.host, call_564538.base,
                         call_564538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564538, url, valid)

proc call*(call_564539: Call_DevicesFailover_564529; apiVersion: string;
          failoverRequest: JsonNode; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## devicesFailover
  ## Fails over the device to another device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   failoverRequest: JObject (required)
  ##                  : The failover request.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564540 = newJObject()
  var query_564541 = newJObject()
  var body_564542 = newJObject()
  add(query_564541, "api-version", newJString(apiVersion))
  if failoverRequest != nil:
    body_564542 = failoverRequest
  add(path_564540, "subscriptionId", newJString(subscriptionId))
  add(path_564540, "deviceName", newJString(deviceName))
  add(path_564540, "resourceGroupName", newJString(resourceGroupName))
  add(path_564540, "managerName", newJString(managerName))
  result = call_564539.call(path_564540, query_564541, nil, nil, body_564542)

var devicesFailover* = Call_DevicesFailover_564529(name: "devicesFailover",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/failover",
    validator: validate_DevicesFailover_564530, base: "", url: url_DevicesFailover_564531,
    schemes: {Scheme.Https})
type
  Call_DevicesListFailoverTarget_564543 = ref object of OpenApiRestCall_563565
proc url_DevicesListFailoverTarget_564545(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/failoverTargets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesListFailoverTarget_564544(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the devices which can be used as failover targets for the given device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564546 = path.getOrDefault("subscriptionId")
  valid_564546 = validateParameter(valid_564546, JString, required = true,
                                 default = nil)
  if valid_564546 != nil:
    section.add "subscriptionId", valid_564546
  var valid_564547 = path.getOrDefault("deviceName")
  valid_564547 = validateParameter(valid_564547, JString, required = true,
                                 default = nil)
  if valid_564547 != nil:
    section.add "deviceName", valid_564547
  var valid_564548 = path.getOrDefault("resourceGroupName")
  valid_564548 = validateParameter(valid_564548, JString, required = true,
                                 default = nil)
  if valid_564548 != nil:
    section.add "resourceGroupName", valid_564548
  var valid_564549 = path.getOrDefault("managerName")
  valid_564549 = validateParameter(valid_564549, JString, required = true,
                                 default = nil)
  if valid_564549 != nil:
    section.add "managerName", valid_564549
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the device.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564550 = query.getOrDefault("api-version")
  valid_564550 = validateParameter(valid_564550, JString, required = true,
                                 default = nil)
  if valid_564550 != nil:
    section.add "api-version", valid_564550
  var valid_564551 = query.getOrDefault("$expand")
  valid_564551 = validateParameter(valid_564551, JString, required = false,
                                 default = nil)
  if valid_564551 != nil:
    section.add "$expand", valid_564551
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564552: Call_DevicesListFailoverTarget_564543; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the devices which can be used as failover targets for the given device.
  ## 
  let valid = call_564552.validator(path, query, header, formData, body)
  let scheme = call_564552.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564552.url(scheme.get, call_564552.host, call_564552.base,
                         call_564552.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564552, url, valid)

proc call*(call_564553: Call_DevicesListFailoverTarget_564543; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; Expand: string = ""): Recallable =
  ## devicesListFailoverTarget
  ## Retrieves all the devices which can be used as failover targets for the given device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   Expand: string
  ##         : Specify $expand=details to populate additional fields related to the device.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564554 = newJObject()
  var query_564555 = newJObject()
  add(query_564555, "api-version", newJString(apiVersion))
  add(query_564555, "$expand", newJString(Expand))
  add(path_564554, "subscriptionId", newJString(subscriptionId))
  add(path_564554, "deviceName", newJString(deviceName))
  add(path_564554, "resourceGroupName", newJString(resourceGroupName))
  add(path_564554, "managerName", newJString(managerName))
  result = call_564553.call(path_564554, query_564555, nil, nil, nil)

var devicesListFailoverTarget* = Call_DevicesListFailoverTarget_564543(
    name: "devicesListFailoverTarget", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/failoverTargets",
    validator: validate_DevicesListFailoverTarget_564544, base: "",
    url: url_DevicesListFailoverTarget_564545, schemes: {Scheme.Https})
type
  Call_FileServersListByDevice_564556 = ref object of OpenApiRestCall_563565
proc url_FileServersListByDevice_564558(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/fileservers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersListByDevice_564557(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the file servers in a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564559 = path.getOrDefault("subscriptionId")
  valid_564559 = validateParameter(valid_564559, JString, required = true,
                                 default = nil)
  if valid_564559 != nil:
    section.add "subscriptionId", valid_564559
  var valid_564560 = path.getOrDefault("deviceName")
  valid_564560 = validateParameter(valid_564560, JString, required = true,
                                 default = nil)
  if valid_564560 != nil:
    section.add "deviceName", valid_564560
  var valid_564561 = path.getOrDefault("resourceGroupName")
  valid_564561 = validateParameter(valid_564561, JString, required = true,
                                 default = nil)
  if valid_564561 != nil:
    section.add "resourceGroupName", valid_564561
  var valid_564562 = path.getOrDefault("managerName")
  valid_564562 = validateParameter(valid_564562, JString, required = true,
                                 default = nil)
  if valid_564562 != nil:
    section.add "managerName", valid_564562
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564563 = query.getOrDefault("api-version")
  valid_564563 = validateParameter(valid_564563, JString, required = true,
                                 default = nil)
  if valid_564563 != nil:
    section.add "api-version", valid_564563
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564564: Call_FileServersListByDevice_564556; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the file servers in a device.
  ## 
  let valid = call_564564.validator(path, query, header, formData, body)
  let scheme = call_564564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564564.url(scheme.get, call_564564.host, call_564564.base,
                         call_564564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564564, url, valid)

proc call*(call_564565: Call_FileServersListByDevice_564556; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## fileServersListByDevice
  ## Retrieves all the file servers in a device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564566 = newJObject()
  var query_564567 = newJObject()
  add(query_564567, "api-version", newJString(apiVersion))
  add(path_564566, "subscriptionId", newJString(subscriptionId))
  add(path_564566, "deviceName", newJString(deviceName))
  add(path_564566, "resourceGroupName", newJString(resourceGroupName))
  add(path_564566, "managerName", newJString(managerName))
  result = call_564565.call(path_564566, query_564567, nil, nil, nil)

var fileServersListByDevice* = Call_FileServersListByDevice_564556(
    name: "fileServersListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers",
    validator: validate_FileServersListByDevice_564557, base: "",
    url: url_FileServersListByDevice_564558, schemes: {Scheme.Https})
type
  Call_FileServersCreateOrUpdate_564581 = ref object of OpenApiRestCall_563565
proc url_FileServersCreateOrUpdate_564583(protocol: Scheme; host: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersCreateOrUpdate_564582(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the file server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   fileServerName: JString (required)
  ##                 : The file server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564584 = path.getOrDefault("subscriptionId")
  valid_564584 = validateParameter(valid_564584, JString, required = true,
                                 default = nil)
  if valid_564584 != nil:
    section.add "subscriptionId", valid_564584
  var valid_564585 = path.getOrDefault("fileServerName")
  valid_564585 = validateParameter(valid_564585, JString, required = true,
                                 default = nil)
  if valid_564585 != nil:
    section.add "fileServerName", valid_564585
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
  ## parameters in `body` object:
  ##   fileServer: JObject (required)
  ##             : The file server.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564591: Call_FileServersCreateOrUpdate_564581; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the file server.
  ## 
  let valid = call_564591.validator(path, query, header, formData, body)
  let scheme = call_564591.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564591.url(scheme.get, call_564591.host, call_564591.base,
                         call_564591.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564591, url, valid)

proc call*(call_564592: Call_FileServersCreateOrUpdate_564581; apiVersion: string;
          fileServer: JsonNode; subscriptionId: string; fileServerName: string;
          deviceName: string; resourceGroupName: string; managerName: string): Recallable =
  ## fileServersCreateOrUpdate
  ## Creates or updates the file server.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   fileServer: JObject (required)
  ##             : The file server.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   fileServerName: string (required)
  ##                 : The file server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564593 = newJObject()
  var query_564594 = newJObject()
  var body_564595 = newJObject()
  add(query_564594, "api-version", newJString(apiVersion))
  if fileServer != nil:
    body_564595 = fileServer
  add(path_564593, "subscriptionId", newJString(subscriptionId))
  add(path_564593, "fileServerName", newJString(fileServerName))
  add(path_564593, "deviceName", newJString(deviceName))
  add(path_564593, "resourceGroupName", newJString(resourceGroupName))
  add(path_564593, "managerName", newJString(managerName))
  result = call_564592.call(path_564593, query_564594, nil, nil, body_564595)

var fileServersCreateOrUpdate* = Call_FileServersCreateOrUpdate_564581(
    name: "fileServersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}",
    validator: validate_FileServersCreateOrUpdate_564582, base: "",
    url: url_FileServersCreateOrUpdate_564583, schemes: {Scheme.Https})
type
  Call_FileServersGet_564568 = ref object of OpenApiRestCall_563565
proc url_FileServersGet_564570(protocol: Scheme; host: string; base: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersGet_564569(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns the properties of the specified file server name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   fileServerName: JString (required)
  ##                 : The file server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564571 = path.getOrDefault("subscriptionId")
  valid_564571 = validateParameter(valid_564571, JString, required = true,
                                 default = nil)
  if valid_564571 != nil:
    section.add "subscriptionId", valid_564571
  var valid_564572 = path.getOrDefault("fileServerName")
  valid_564572 = validateParameter(valid_564572, JString, required = true,
                                 default = nil)
  if valid_564572 != nil:
    section.add "fileServerName", valid_564572
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564576 = query.getOrDefault("api-version")
  valid_564576 = validateParameter(valid_564576, JString, required = true,
                                 default = nil)
  if valid_564576 != nil:
    section.add "api-version", valid_564576
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564577: Call_FileServersGet_564568; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified file server name.
  ## 
  let valid = call_564577.validator(path, query, header, formData, body)
  let scheme = call_564577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564577.url(scheme.get, call_564577.host, call_564577.base,
                         call_564577.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564577, url, valid)

proc call*(call_564578: Call_FileServersGet_564568; apiVersion: string;
          subscriptionId: string; fileServerName: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## fileServersGet
  ## Returns the properties of the specified file server name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   fileServerName: string (required)
  ##                 : The file server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564579 = newJObject()
  var query_564580 = newJObject()
  add(query_564580, "api-version", newJString(apiVersion))
  add(path_564579, "subscriptionId", newJString(subscriptionId))
  add(path_564579, "fileServerName", newJString(fileServerName))
  add(path_564579, "deviceName", newJString(deviceName))
  add(path_564579, "resourceGroupName", newJString(resourceGroupName))
  add(path_564579, "managerName", newJString(managerName))
  result = call_564578.call(path_564579, query_564580, nil, nil, nil)

var fileServersGet* = Call_FileServersGet_564568(name: "fileServersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}",
    validator: validate_FileServersGet_564569, base: "", url: url_FileServersGet_564570,
    schemes: {Scheme.Https})
type
  Call_FileServersDelete_564596 = ref object of OpenApiRestCall_563565
proc url_FileServersDelete_564598(protocol: Scheme; host: string; base: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersDelete_564597(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes the file server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   fileServerName: JString (required)
  ##                 : The file server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564599 = path.getOrDefault("subscriptionId")
  valid_564599 = validateParameter(valid_564599, JString, required = true,
                                 default = nil)
  if valid_564599 != nil:
    section.add "subscriptionId", valid_564599
  var valid_564600 = path.getOrDefault("fileServerName")
  valid_564600 = validateParameter(valid_564600, JString, required = true,
                                 default = nil)
  if valid_564600 != nil:
    section.add "fileServerName", valid_564600
  var valid_564601 = path.getOrDefault("deviceName")
  valid_564601 = validateParameter(valid_564601, JString, required = true,
                                 default = nil)
  if valid_564601 != nil:
    section.add "deviceName", valid_564601
  var valid_564602 = path.getOrDefault("resourceGroupName")
  valid_564602 = validateParameter(valid_564602, JString, required = true,
                                 default = nil)
  if valid_564602 != nil:
    section.add "resourceGroupName", valid_564602
  var valid_564603 = path.getOrDefault("managerName")
  valid_564603 = validateParameter(valid_564603, JString, required = true,
                                 default = nil)
  if valid_564603 != nil:
    section.add "managerName", valid_564603
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564604 = query.getOrDefault("api-version")
  valid_564604 = validateParameter(valid_564604, JString, required = true,
                                 default = nil)
  if valid_564604 != nil:
    section.add "api-version", valid_564604
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564605: Call_FileServersDelete_564596; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the file server.
  ## 
  let valid = call_564605.validator(path, query, header, formData, body)
  let scheme = call_564605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564605.url(scheme.get, call_564605.host, call_564605.base,
                         call_564605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564605, url, valid)

proc call*(call_564606: Call_FileServersDelete_564596; apiVersion: string;
          subscriptionId: string; fileServerName: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## fileServersDelete
  ## Deletes the file server.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   fileServerName: string (required)
  ##                 : The file server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564607 = newJObject()
  var query_564608 = newJObject()
  add(query_564608, "api-version", newJString(apiVersion))
  add(path_564607, "subscriptionId", newJString(subscriptionId))
  add(path_564607, "fileServerName", newJString(fileServerName))
  add(path_564607, "deviceName", newJString(deviceName))
  add(path_564607, "resourceGroupName", newJString(resourceGroupName))
  add(path_564607, "managerName", newJString(managerName))
  result = call_564606.call(path_564607, query_564608, nil, nil, nil)

var fileServersDelete* = Call_FileServersDelete_564596(name: "fileServersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}",
    validator: validate_FileServersDelete_564597, base: "",
    url: url_FileServersDelete_564598, schemes: {Scheme.Https})
type
  Call_FileServersBackupNow_564609 = ref object of OpenApiRestCall_563565
proc url_FileServersBackupNow_564611(protocol: Scheme; host: string; base: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName"),
               (kind: ConstantSegment, value: "/backup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersBackupNow_564610(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Backup the file server now.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   fileServerName: JString (required)
  ##                 : The file server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564612 = path.getOrDefault("subscriptionId")
  valid_564612 = validateParameter(valid_564612, JString, required = true,
                                 default = nil)
  if valid_564612 != nil:
    section.add "subscriptionId", valid_564612
  var valid_564613 = path.getOrDefault("fileServerName")
  valid_564613 = validateParameter(valid_564613, JString, required = true,
                                 default = nil)
  if valid_564613 != nil:
    section.add "fileServerName", valid_564613
  var valid_564614 = path.getOrDefault("deviceName")
  valid_564614 = validateParameter(valid_564614, JString, required = true,
                                 default = nil)
  if valid_564614 != nil:
    section.add "deviceName", valid_564614
  var valid_564615 = path.getOrDefault("resourceGroupName")
  valid_564615 = validateParameter(valid_564615, JString, required = true,
                                 default = nil)
  if valid_564615 != nil:
    section.add "resourceGroupName", valid_564615
  var valid_564616 = path.getOrDefault("managerName")
  valid_564616 = validateParameter(valid_564616, JString, required = true,
                                 default = nil)
  if valid_564616 != nil:
    section.add "managerName", valid_564616
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564617 = query.getOrDefault("api-version")
  valid_564617 = validateParameter(valid_564617, JString, required = true,
                                 default = nil)
  if valid_564617 != nil:
    section.add "api-version", valid_564617
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564618: Call_FileServersBackupNow_564609; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Backup the file server now.
  ## 
  let valid = call_564618.validator(path, query, header, formData, body)
  let scheme = call_564618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564618.url(scheme.get, call_564618.host, call_564618.base,
                         call_564618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564618, url, valid)

proc call*(call_564619: Call_FileServersBackupNow_564609; apiVersion: string;
          subscriptionId: string; fileServerName: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## fileServersBackupNow
  ## Backup the file server now.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   fileServerName: string (required)
  ##                 : The file server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564620 = newJObject()
  var query_564621 = newJObject()
  add(query_564621, "api-version", newJString(apiVersion))
  add(path_564620, "subscriptionId", newJString(subscriptionId))
  add(path_564620, "fileServerName", newJString(fileServerName))
  add(path_564620, "deviceName", newJString(deviceName))
  add(path_564620, "resourceGroupName", newJString(resourceGroupName))
  add(path_564620, "managerName", newJString(managerName))
  result = call_564619.call(path_564620, query_564621, nil, nil, nil)

var fileServersBackupNow* = Call_FileServersBackupNow_564609(
    name: "fileServersBackupNow", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/backup",
    validator: validate_FileServersBackupNow_564610, base: "",
    url: url_FileServersBackupNow_564611, schemes: {Scheme.Https})
type
  Call_FileServersListMetrics_564622 = ref object of OpenApiRestCall_563565
proc url_FileServersListMetrics_564624(protocol: Scheme; host: string; base: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersListMetrics_564623(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the file server metrics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   fileServerName: JString (required)
  ##                 : The name of the file server name.
  ##   deviceName: JString (required)
  ##             : The name of the device.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564625 = path.getOrDefault("subscriptionId")
  valid_564625 = validateParameter(valid_564625, JString, required = true,
                                 default = nil)
  if valid_564625 != nil:
    section.add "subscriptionId", valid_564625
  var valid_564626 = path.getOrDefault("fileServerName")
  valid_564626 = validateParameter(valid_564626, JString, required = true,
                                 default = nil)
  if valid_564626 != nil:
    section.add "fileServerName", valid_564626
  var valid_564627 = path.getOrDefault("deviceName")
  valid_564627 = validateParameter(valid_564627, JString, required = true,
                                 default = nil)
  if valid_564627 != nil:
    section.add "deviceName", valid_564627
  var valid_564628 = path.getOrDefault("resourceGroupName")
  valid_564628 = validateParameter(valid_564628, JString, required = true,
                                 default = nil)
  if valid_564628 != nil:
    section.add "resourceGroupName", valid_564628
  var valid_564629 = path.getOrDefault("managerName")
  valid_564629 = validateParameter(valid_564629, JString, required = true,
                                 default = nil)
  if valid_564629 != nil:
    section.add "managerName", valid_564629
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564630 = query.getOrDefault("api-version")
  valid_564630 = validateParameter(valid_564630, JString, required = true,
                                 default = nil)
  if valid_564630 != nil:
    section.add "api-version", valid_564630
  var valid_564631 = query.getOrDefault("$filter")
  valid_564631 = validateParameter(valid_564631, JString, required = false,
                                 default = nil)
  if valid_564631 != nil:
    section.add "$filter", valid_564631
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564632: Call_FileServersListMetrics_564622; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the file server metrics.
  ## 
  let valid = call_564632.validator(path, query, header, formData, body)
  let scheme = call_564632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564632.url(scheme.get, call_564632.host, call_564632.base,
                         call_564632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564632, url, valid)

proc call*(call_564633: Call_FileServersListMetrics_564622; apiVersion: string;
          subscriptionId: string; fileServerName: string; deviceName: string;
          resourceGroupName: string; managerName: string; Filter: string = ""): Recallable =
  ## fileServersListMetrics
  ## Gets the file server metrics.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   fileServerName: string (required)
  ##                 : The name of the file server name.
  ##   deviceName: string (required)
  ##             : The name of the device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   Filter: string
  ##         : OData Filter options
  var path_564634 = newJObject()
  var query_564635 = newJObject()
  add(query_564635, "api-version", newJString(apiVersion))
  add(path_564634, "subscriptionId", newJString(subscriptionId))
  add(path_564634, "fileServerName", newJString(fileServerName))
  add(path_564634, "deviceName", newJString(deviceName))
  add(path_564634, "resourceGroupName", newJString(resourceGroupName))
  add(path_564634, "managerName", newJString(managerName))
  add(query_564635, "$filter", newJString(Filter))
  result = call_564633.call(path_564634, query_564635, nil, nil, nil)

var fileServersListMetrics* = Call_FileServersListMetrics_564622(
    name: "fileServersListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/metrics",
    validator: validate_FileServersListMetrics_564623, base: "",
    url: url_FileServersListMetrics_564624, schemes: {Scheme.Https})
type
  Call_FileServersListMetricDefinition_564636 = ref object of OpenApiRestCall_563565
proc url_FileServersListMetricDefinition_564638(protocol: Scheme; host: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName"),
               (kind: ConstantSegment, value: "/metricsDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersListMetricDefinition_564637(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves metric definitions of all metrics aggregated at the file server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   fileServerName: JString (required)
  ##                 : The name of the file server.
  ##   deviceName: JString (required)
  ##             : The name of the device.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564639 = path.getOrDefault("subscriptionId")
  valid_564639 = validateParameter(valid_564639, JString, required = true,
                                 default = nil)
  if valid_564639 != nil:
    section.add "subscriptionId", valid_564639
  var valid_564640 = path.getOrDefault("fileServerName")
  valid_564640 = validateParameter(valid_564640, JString, required = true,
                                 default = nil)
  if valid_564640 != nil:
    section.add "fileServerName", valid_564640
  var valid_564641 = path.getOrDefault("deviceName")
  valid_564641 = validateParameter(valid_564641, JString, required = true,
                                 default = nil)
  if valid_564641 != nil:
    section.add "deviceName", valid_564641
  var valid_564642 = path.getOrDefault("resourceGroupName")
  valid_564642 = validateParameter(valid_564642, JString, required = true,
                                 default = nil)
  if valid_564642 != nil:
    section.add "resourceGroupName", valid_564642
  var valid_564643 = path.getOrDefault("managerName")
  valid_564643 = validateParameter(valid_564643, JString, required = true,
                                 default = nil)
  if valid_564643 != nil:
    section.add "managerName", valid_564643
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564644 = query.getOrDefault("api-version")
  valid_564644 = validateParameter(valid_564644, JString, required = true,
                                 default = nil)
  if valid_564644 != nil:
    section.add "api-version", valid_564644
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564645: Call_FileServersListMetricDefinition_564636;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves metric definitions of all metrics aggregated at the file server.
  ## 
  let valid = call_564645.validator(path, query, header, formData, body)
  let scheme = call_564645.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564645.url(scheme.get, call_564645.host, call_564645.base,
                         call_564645.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564645, url, valid)

proc call*(call_564646: Call_FileServersListMetricDefinition_564636;
          apiVersion: string; subscriptionId: string; fileServerName: string;
          deviceName: string; resourceGroupName: string; managerName: string): Recallable =
  ## fileServersListMetricDefinition
  ## Retrieves metric definitions of all metrics aggregated at the file server.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   fileServerName: string (required)
  ##                 : The name of the file server.
  ##   deviceName: string (required)
  ##             : The name of the device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564647 = newJObject()
  var query_564648 = newJObject()
  add(query_564648, "api-version", newJString(apiVersion))
  add(path_564647, "subscriptionId", newJString(subscriptionId))
  add(path_564647, "fileServerName", newJString(fileServerName))
  add(path_564647, "deviceName", newJString(deviceName))
  add(path_564647, "resourceGroupName", newJString(resourceGroupName))
  add(path_564647, "managerName", newJString(managerName))
  result = call_564646.call(path_564647, query_564648, nil, nil, nil)

var fileServersListMetricDefinition* = Call_FileServersListMetricDefinition_564636(
    name: "fileServersListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/metricsDefinitions",
    validator: validate_FileServersListMetricDefinition_564637, base: "",
    url: url_FileServersListMetricDefinition_564638, schemes: {Scheme.Https})
type
  Call_FileSharesListByFileServer_564649 = ref object of OpenApiRestCall_563565
proc url_FileSharesListByFileServer_564651(protocol: Scheme; host: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName"),
               (kind: ConstantSegment, value: "/shares")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSharesListByFileServer_564650(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the file shares in a file server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   fileServerName: JString (required)
  ##                 : The file server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564652 = path.getOrDefault("subscriptionId")
  valid_564652 = validateParameter(valid_564652, JString, required = true,
                                 default = nil)
  if valid_564652 != nil:
    section.add "subscriptionId", valid_564652
  var valid_564653 = path.getOrDefault("fileServerName")
  valid_564653 = validateParameter(valid_564653, JString, required = true,
                                 default = nil)
  if valid_564653 != nil:
    section.add "fileServerName", valid_564653
  var valid_564654 = path.getOrDefault("deviceName")
  valid_564654 = validateParameter(valid_564654, JString, required = true,
                                 default = nil)
  if valid_564654 != nil:
    section.add "deviceName", valid_564654
  var valid_564655 = path.getOrDefault("resourceGroupName")
  valid_564655 = validateParameter(valid_564655, JString, required = true,
                                 default = nil)
  if valid_564655 != nil:
    section.add "resourceGroupName", valid_564655
  var valid_564656 = path.getOrDefault("managerName")
  valid_564656 = validateParameter(valid_564656, JString, required = true,
                                 default = nil)
  if valid_564656 != nil:
    section.add "managerName", valid_564656
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564657 = query.getOrDefault("api-version")
  valid_564657 = validateParameter(valid_564657, JString, required = true,
                                 default = nil)
  if valid_564657 != nil:
    section.add "api-version", valid_564657
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564658: Call_FileSharesListByFileServer_564649; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the file shares in a file server.
  ## 
  let valid = call_564658.validator(path, query, header, formData, body)
  let scheme = call_564658.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564658.url(scheme.get, call_564658.host, call_564658.base,
                         call_564658.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564658, url, valid)

proc call*(call_564659: Call_FileSharesListByFileServer_564649; apiVersion: string;
          subscriptionId: string; fileServerName: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## fileSharesListByFileServer
  ## Retrieves all the file shares in a file server.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   fileServerName: string (required)
  ##                 : The file server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564660 = newJObject()
  var query_564661 = newJObject()
  add(query_564661, "api-version", newJString(apiVersion))
  add(path_564660, "subscriptionId", newJString(subscriptionId))
  add(path_564660, "fileServerName", newJString(fileServerName))
  add(path_564660, "deviceName", newJString(deviceName))
  add(path_564660, "resourceGroupName", newJString(resourceGroupName))
  add(path_564660, "managerName", newJString(managerName))
  result = call_564659.call(path_564660, query_564661, nil, nil, nil)

var fileSharesListByFileServer* = Call_FileSharesListByFileServer_564649(
    name: "fileSharesListByFileServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/shares",
    validator: validate_FileSharesListByFileServer_564650, base: "",
    url: url_FileSharesListByFileServer_564651, schemes: {Scheme.Https})
type
  Call_FileSharesCreateOrUpdate_564676 = ref object of OpenApiRestCall_563565
proc url_FileSharesCreateOrUpdate_564678(protocol: Scheme; host: string;
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
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSharesCreateOrUpdate_564677(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the file share.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   shareName: JString (required)
  ##            : The file share name.
  ##   fileServerName: JString (required)
  ##                 : The file server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564679 = path.getOrDefault("subscriptionId")
  valid_564679 = validateParameter(valid_564679, JString, required = true,
                                 default = nil)
  if valid_564679 != nil:
    section.add "subscriptionId", valid_564679
  var valid_564680 = path.getOrDefault("shareName")
  valid_564680 = validateParameter(valid_564680, JString, required = true,
                                 default = nil)
  if valid_564680 != nil:
    section.add "shareName", valid_564680
  var valid_564681 = path.getOrDefault("fileServerName")
  valid_564681 = validateParameter(valid_564681, JString, required = true,
                                 default = nil)
  if valid_564681 != nil:
    section.add "fileServerName", valid_564681
  var valid_564682 = path.getOrDefault("deviceName")
  valid_564682 = validateParameter(valid_564682, JString, required = true,
                                 default = nil)
  if valid_564682 != nil:
    section.add "deviceName", valid_564682
  var valid_564683 = path.getOrDefault("resourceGroupName")
  valid_564683 = validateParameter(valid_564683, JString, required = true,
                                 default = nil)
  if valid_564683 != nil:
    section.add "resourceGroupName", valid_564683
  var valid_564684 = path.getOrDefault("managerName")
  valid_564684 = validateParameter(valid_564684, JString, required = true,
                                 default = nil)
  if valid_564684 != nil:
    section.add "managerName", valid_564684
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564685 = query.getOrDefault("api-version")
  valid_564685 = validateParameter(valid_564685, JString, required = true,
                                 default = nil)
  if valid_564685 != nil:
    section.add "api-version", valid_564685
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   fileShare: JObject (required)
  ##            : The file share.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564687: Call_FileSharesCreateOrUpdate_564676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the file share.
  ## 
  let valid = call_564687.validator(path, query, header, formData, body)
  let scheme = call_564687.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564687.url(scheme.get, call_564687.host, call_564687.base,
                         call_564687.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564687, url, valid)

proc call*(call_564688: Call_FileSharesCreateOrUpdate_564676; apiVersion: string;
          fileShare: JsonNode; subscriptionId: string; shareName: string;
          fileServerName: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## fileSharesCreateOrUpdate
  ## Creates or updates the file share.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   fileShare: JObject (required)
  ##            : The file share.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   shareName: string (required)
  ##            : The file share name.
  ##   fileServerName: string (required)
  ##                 : The file server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564689 = newJObject()
  var query_564690 = newJObject()
  var body_564691 = newJObject()
  add(query_564690, "api-version", newJString(apiVersion))
  if fileShare != nil:
    body_564691 = fileShare
  add(path_564689, "subscriptionId", newJString(subscriptionId))
  add(path_564689, "shareName", newJString(shareName))
  add(path_564689, "fileServerName", newJString(fileServerName))
  add(path_564689, "deviceName", newJString(deviceName))
  add(path_564689, "resourceGroupName", newJString(resourceGroupName))
  add(path_564689, "managerName", newJString(managerName))
  result = call_564688.call(path_564689, query_564690, nil, nil, body_564691)

var fileSharesCreateOrUpdate* = Call_FileSharesCreateOrUpdate_564676(
    name: "fileSharesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/shares/{shareName}",
    validator: validate_FileSharesCreateOrUpdate_564677, base: "",
    url: url_FileSharesCreateOrUpdate_564678, schemes: {Scheme.Https})
type
  Call_FileSharesGet_564662 = ref object of OpenApiRestCall_563565
proc url_FileSharesGet_564664(protocol: Scheme; host: string; base: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSharesGet_564663(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified file share name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   shareName: JString (required)
  ##            : The file share name.
  ##   fileServerName: JString (required)
  ##                 : The file server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564665 = path.getOrDefault("subscriptionId")
  valid_564665 = validateParameter(valid_564665, JString, required = true,
                                 default = nil)
  if valid_564665 != nil:
    section.add "subscriptionId", valid_564665
  var valid_564666 = path.getOrDefault("shareName")
  valid_564666 = validateParameter(valid_564666, JString, required = true,
                                 default = nil)
  if valid_564666 != nil:
    section.add "shareName", valid_564666
  var valid_564667 = path.getOrDefault("fileServerName")
  valid_564667 = validateParameter(valid_564667, JString, required = true,
                                 default = nil)
  if valid_564667 != nil:
    section.add "fileServerName", valid_564667
  var valid_564668 = path.getOrDefault("deviceName")
  valid_564668 = validateParameter(valid_564668, JString, required = true,
                                 default = nil)
  if valid_564668 != nil:
    section.add "deviceName", valid_564668
  var valid_564669 = path.getOrDefault("resourceGroupName")
  valid_564669 = validateParameter(valid_564669, JString, required = true,
                                 default = nil)
  if valid_564669 != nil:
    section.add "resourceGroupName", valid_564669
  var valid_564670 = path.getOrDefault("managerName")
  valid_564670 = validateParameter(valid_564670, JString, required = true,
                                 default = nil)
  if valid_564670 != nil:
    section.add "managerName", valid_564670
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564671 = query.getOrDefault("api-version")
  valid_564671 = validateParameter(valid_564671, JString, required = true,
                                 default = nil)
  if valid_564671 != nil:
    section.add "api-version", valid_564671
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564672: Call_FileSharesGet_564662; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified file share name.
  ## 
  let valid = call_564672.validator(path, query, header, formData, body)
  let scheme = call_564672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564672.url(scheme.get, call_564672.host, call_564672.base,
                         call_564672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564672, url, valid)

proc call*(call_564673: Call_FileSharesGet_564662; apiVersion: string;
          subscriptionId: string; shareName: string; fileServerName: string;
          deviceName: string; resourceGroupName: string; managerName: string): Recallable =
  ## fileSharesGet
  ## Returns the properties of the specified file share name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   shareName: string (required)
  ##            : The file share name.
  ##   fileServerName: string (required)
  ##                 : The file server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564674 = newJObject()
  var query_564675 = newJObject()
  add(query_564675, "api-version", newJString(apiVersion))
  add(path_564674, "subscriptionId", newJString(subscriptionId))
  add(path_564674, "shareName", newJString(shareName))
  add(path_564674, "fileServerName", newJString(fileServerName))
  add(path_564674, "deviceName", newJString(deviceName))
  add(path_564674, "resourceGroupName", newJString(resourceGroupName))
  add(path_564674, "managerName", newJString(managerName))
  result = call_564673.call(path_564674, query_564675, nil, nil, nil)

var fileSharesGet* = Call_FileSharesGet_564662(name: "fileSharesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/shares/{shareName}",
    validator: validate_FileSharesGet_564663, base: "", url: url_FileSharesGet_564664,
    schemes: {Scheme.Https})
type
  Call_FileSharesDelete_564692 = ref object of OpenApiRestCall_563565
proc url_FileSharesDelete_564694(protocol: Scheme; host: string; base: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSharesDelete_564693(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes the file share.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   shareName: JString (required)
  ##            : The file share Name
  ##   fileServerName: JString (required)
  ##                 : The file server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564695 = path.getOrDefault("subscriptionId")
  valid_564695 = validateParameter(valid_564695, JString, required = true,
                                 default = nil)
  if valid_564695 != nil:
    section.add "subscriptionId", valid_564695
  var valid_564696 = path.getOrDefault("shareName")
  valid_564696 = validateParameter(valid_564696, JString, required = true,
                                 default = nil)
  if valid_564696 != nil:
    section.add "shareName", valid_564696
  var valid_564697 = path.getOrDefault("fileServerName")
  valid_564697 = validateParameter(valid_564697, JString, required = true,
                                 default = nil)
  if valid_564697 != nil:
    section.add "fileServerName", valid_564697
  var valid_564698 = path.getOrDefault("deviceName")
  valid_564698 = validateParameter(valid_564698, JString, required = true,
                                 default = nil)
  if valid_564698 != nil:
    section.add "deviceName", valid_564698
  var valid_564699 = path.getOrDefault("resourceGroupName")
  valid_564699 = validateParameter(valid_564699, JString, required = true,
                                 default = nil)
  if valid_564699 != nil:
    section.add "resourceGroupName", valid_564699
  var valid_564700 = path.getOrDefault("managerName")
  valid_564700 = validateParameter(valid_564700, JString, required = true,
                                 default = nil)
  if valid_564700 != nil:
    section.add "managerName", valid_564700
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564701 = query.getOrDefault("api-version")
  valid_564701 = validateParameter(valid_564701, JString, required = true,
                                 default = nil)
  if valid_564701 != nil:
    section.add "api-version", valid_564701
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564702: Call_FileSharesDelete_564692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the file share.
  ## 
  let valid = call_564702.validator(path, query, header, formData, body)
  let scheme = call_564702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564702.url(scheme.get, call_564702.host, call_564702.base,
                         call_564702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564702, url, valid)

proc call*(call_564703: Call_FileSharesDelete_564692; apiVersion: string;
          subscriptionId: string; shareName: string; fileServerName: string;
          deviceName: string; resourceGroupName: string; managerName: string): Recallable =
  ## fileSharesDelete
  ## Deletes the file share.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   shareName: string (required)
  ##            : The file share Name
  ##   fileServerName: string (required)
  ##                 : The file server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564704 = newJObject()
  var query_564705 = newJObject()
  add(query_564705, "api-version", newJString(apiVersion))
  add(path_564704, "subscriptionId", newJString(subscriptionId))
  add(path_564704, "shareName", newJString(shareName))
  add(path_564704, "fileServerName", newJString(fileServerName))
  add(path_564704, "deviceName", newJString(deviceName))
  add(path_564704, "resourceGroupName", newJString(resourceGroupName))
  add(path_564704, "managerName", newJString(managerName))
  result = call_564703.call(path_564704, query_564705, nil, nil, nil)

var fileSharesDelete* = Call_FileSharesDelete_564692(name: "fileSharesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/shares/{shareName}",
    validator: validate_FileSharesDelete_564693, base: "",
    url: url_FileSharesDelete_564694, schemes: {Scheme.Https})
type
  Call_FileSharesListMetrics_564706 = ref object of OpenApiRestCall_563565
proc url_FileSharesListMetrics_564708(protocol: Scheme; host: string; base: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSharesListMetrics_564707(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the file share metrics
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   shareName: JString (required)
  ##            : The file share name.
  ##   fileServerName: JString (required)
  ##                 : The file server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564709 = path.getOrDefault("subscriptionId")
  valid_564709 = validateParameter(valid_564709, JString, required = true,
                                 default = nil)
  if valid_564709 != nil:
    section.add "subscriptionId", valid_564709
  var valid_564710 = path.getOrDefault("shareName")
  valid_564710 = validateParameter(valid_564710, JString, required = true,
                                 default = nil)
  if valid_564710 != nil:
    section.add "shareName", valid_564710
  var valid_564711 = path.getOrDefault("fileServerName")
  valid_564711 = validateParameter(valid_564711, JString, required = true,
                                 default = nil)
  if valid_564711 != nil:
    section.add "fileServerName", valid_564711
  var valid_564712 = path.getOrDefault("deviceName")
  valid_564712 = validateParameter(valid_564712, JString, required = true,
                                 default = nil)
  if valid_564712 != nil:
    section.add "deviceName", valid_564712
  var valid_564713 = path.getOrDefault("resourceGroupName")
  valid_564713 = validateParameter(valid_564713, JString, required = true,
                                 default = nil)
  if valid_564713 != nil:
    section.add "resourceGroupName", valid_564713
  var valid_564714 = path.getOrDefault("managerName")
  valid_564714 = validateParameter(valid_564714, JString, required = true,
                                 default = nil)
  if valid_564714 != nil:
    section.add "managerName", valid_564714
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564715 = query.getOrDefault("api-version")
  valid_564715 = validateParameter(valid_564715, JString, required = true,
                                 default = nil)
  if valid_564715 != nil:
    section.add "api-version", valid_564715
  var valid_564716 = query.getOrDefault("$filter")
  valid_564716 = validateParameter(valid_564716, JString, required = false,
                                 default = nil)
  if valid_564716 != nil:
    section.add "$filter", valid_564716
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564717: Call_FileSharesListMetrics_564706; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the file share metrics
  ## 
  let valid = call_564717.validator(path, query, header, formData, body)
  let scheme = call_564717.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564717.url(scheme.get, call_564717.host, call_564717.base,
                         call_564717.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564717, url, valid)

proc call*(call_564718: Call_FileSharesListMetrics_564706; apiVersion: string;
          subscriptionId: string; shareName: string; fileServerName: string;
          deviceName: string; resourceGroupName: string; managerName: string;
          Filter: string = ""): Recallable =
  ## fileSharesListMetrics
  ## Gets the file share metrics
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   shareName: string (required)
  ##            : The file share name.
  ##   fileServerName: string (required)
  ##                 : The file server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   Filter: string
  ##         : OData Filter options
  var path_564719 = newJObject()
  var query_564720 = newJObject()
  add(query_564720, "api-version", newJString(apiVersion))
  add(path_564719, "subscriptionId", newJString(subscriptionId))
  add(path_564719, "shareName", newJString(shareName))
  add(path_564719, "fileServerName", newJString(fileServerName))
  add(path_564719, "deviceName", newJString(deviceName))
  add(path_564719, "resourceGroupName", newJString(resourceGroupName))
  add(path_564719, "managerName", newJString(managerName))
  add(query_564720, "$filter", newJString(Filter))
  result = call_564718.call(path_564719, query_564720, nil, nil, nil)

var fileSharesListMetrics* = Call_FileSharesListMetrics_564706(
    name: "fileSharesListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/shares/{shareName}/metrics",
    validator: validate_FileSharesListMetrics_564707, base: "",
    url: url_FileSharesListMetrics_564708, schemes: {Scheme.Https})
type
  Call_FileSharesListMetricDefinition_564721 = ref object of OpenApiRestCall_563565
proc url_FileSharesListMetricDefinition_564723(protocol: Scheme; host: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/metricsDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSharesListMetricDefinition_564722(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves metric definitions of all metrics aggregated at the file share.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   shareName: JString (required)
  ##            : The file share name.
  ##   fileServerName: JString (required)
  ##                 : The file server name.
  ##   deviceName: JString (required)
  ##             : The device name.
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
  var valid_564725 = path.getOrDefault("shareName")
  valid_564725 = validateParameter(valid_564725, JString, required = true,
                                 default = nil)
  if valid_564725 != nil:
    section.add "shareName", valid_564725
  var valid_564726 = path.getOrDefault("fileServerName")
  valid_564726 = validateParameter(valid_564726, JString, required = true,
                                 default = nil)
  if valid_564726 != nil:
    section.add "fileServerName", valid_564726
  var valid_564727 = path.getOrDefault("deviceName")
  valid_564727 = validateParameter(valid_564727, JString, required = true,
                                 default = nil)
  if valid_564727 != nil:
    section.add "deviceName", valid_564727
  var valid_564728 = path.getOrDefault("resourceGroupName")
  valid_564728 = validateParameter(valid_564728, JString, required = true,
                                 default = nil)
  if valid_564728 != nil:
    section.add "resourceGroupName", valid_564728
  var valid_564729 = path.getOrDefault("managerName")
  valid_564729 = validateParameter(valid_564729, JString, required = true,
                                 default = nil)
  if valid_564729 != nil:
    section.add "managerName", valid_564729
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564730 = query.getOrDefault("api-version")
  valid_564730 = validateParameter(valid_564730, JString, required = true,
                                 default = nil)
  if valid_564730 != nil:
    section.add "api-version", valid_564730
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564731: Call_FileSharesListMetricDefinition_564721; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metric definitions of all metrics aggregated at the file share.
  ## 
  let valid = call_564731.validator(path, query, header, formData, body)
  let scheme = call_564731.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564731.url(scheme.get, call_564731.host, call_564731.base,
                         call_564731.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564731, url, valid)

proc call*(call_564732: Call_FileSharesListMetricDefinition_564721;
          apiVersion: string; subscriptionId: string; shareName: string;
          fileServerName: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## fileSharesListMetricDefinition
  ## Retrieves metric definitions of all metrics aggregated at the file share.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   shareName: string (required)
  ##            : The file share name.
  ##   fileServerName: string (required)
  ##                 : The file server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564733 = newJObject()
  var query_564734 = newJObject()
  add(query_564734, "api-version", newJString(apiVersion))
  add(path_564733, "subscriptionId", newJString(subscriptionId))
  add(path_564733, "shareName", newJString(shareName))
  add(path_564733, "fileServerName", newJString(fileServerName))
  add(path_564733, "deviceName", newJString(deviceName))
  add(path_564733, "resourceGroupName", newJString(resourceGroupName))
  add(path_564733, "managerName", newJString(managerName))
  result = call_564732.call(path_564733, query_564734, nil, nil, nil)

var fileSharesListMetricDefinition* = Call_FileSharesListMetricDefinition_564721(
    name: "fileSharesListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/shares/{shareName}/metricsDefinitions",
    validator: validate_FileSharesListMetricDefinition_564722, base: "",
    url: url_FileSharesListMetricDefinition_564723, schemes: {Scheme.Https})
type
  Call_DevicesInstallUpdates_564735 = ref object of OpenApiRestCall_563565
proc url_DevicesInstallUpdates_564737(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/install")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesInstallUpdates_564736(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Installs the updates on the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
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

proc call*(call_564743: Call_DevicesInstallUpdates_564735; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Installs the updates on the device.
  ## 
  let valid = call_564743.validator(path, query, header, formData, body)
  let scheme = call_564743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564743.url(scheme.get, call_564743.host, call_564743.base,
                         call_564743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564743, url, valid)

proc call*(call_564744: Call_DevicesInstallUpdates_564735; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## devicesInstallUpdates
  ## Installs the updates on the device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
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

var devicesInstallUpdates* = Call_DevicesInstallUpdates_564735(
    name: "devicesInstallUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/install",
    validator: validate_DevicesInstallUpdates_564736, base: "",
    url: url_DevicesInstallUpdates_564737, schemes: {Scheme.Https})
type
  Call_IscsiServersListByDevice_564747 = ref object of OpenApiRestCall_563565
proc url_IscsiServersListByDevice_564749(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/iscsiservers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiServersListByDevice_564748(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the iSCSI in a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
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

proc call*(call_564755: Call_IscsiServersListByDevice_564747; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the iSCSI in a device.
  ## 
  let valid = call_564755.validator(path, query, header, formData, body)
  let scheme = call_564755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564755.url(scheme.get, call_564755.host, call_564755.base,
                         call_564755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564755, url, valid)

proc call*(call_564756: Call_IscsiServersListByDevice_564747; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## iscsiServersListByDevice
  ## Retrieves all the iSCSI in a device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
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

var iscsiServersListByDevice* = Call_IscsiServersListByDevice_564747(
    name: "iscsiServersListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers",
    validator: validate_IscsiServersListByDevice_564748, base: "",
    url: url_IscsiServersListByDevice_564749, schemes: {Scheme.Https})
type
  Call_IscsiServersCreateOrUpdate_564772 = ref object of OpenApiRestCall_563565
proc url_IscsiServersCreateOrUpdate_564774(protocol: Scheme; host: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiServersCreateOrUpdate_564773(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the iSCSI server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564775 = path.getOrDefault("subscriptionId")
  valid_564775 = validateParameter(valid_564775, JString, required = true,
                                 default = nil)
  if valid_564775 != nil:
    section.add "subscriptionId", valid_564775
  var valid_564776 = path.getOrDefault("iscsiServerName")
  valid_564776 = validateParameter(valid_564776, JString, required = true,
                                 default = nil)
  if valid_564776 != nil:
    section.add "iscsiServerName", valid_564776
  var valid_564777 = path.getOrDefault("deviceName")
  valid_564777 = validateParameter(valid_564777, JString, required = true,
                                 default = nil)
  if valid_564777 != nil:
    section.add "deviceName", valid_564777
  var valid_564778 = path.getOrDefault("resourceGroupName")
  valid_564778 = validateParameter(valid_564778, JString, required = true,
                                 default = nil)
  if valid_564778 != nil:
    section.add "resourceGroupName", valid_564778
  var valid_564779 = path.getOrDefault("managerName")
  valid_564779 = validateParameter(valid_564779, JString, required = true,
                                 default = nil)
  if valid_564779 != nil:
    section.add "managerName", valid_564779
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564780 = query.getOrDefault("api-version")
  valid_564780 = validateParameter(valid_564780, JString, required = true,
                                 default = nil)
  if valid_564780 != nil:
    section.add "api-version", valid_564780
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   iscsiServer: JObject (required)
  ##              : The iSCSI server.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564782: Call_IscsiServersCreateOrUpdate_564772; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the iSCSI server.
  ## 
  let valid = call_564782.validator(path, query, header, formData, body)
  let scheme = call_564782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564782.url(scheme.get, call_564782.host, call_564782.base,
                         call_564782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564782, url, valid)

proc call*(call_564783: Call_IscsiServersCreateOrUpdate_564772; apiVersion: string;
          iscsiServer: JsonNode; subscriptionId: string; iscsiServerName: string;
          deviceName: string; resourceGroupName: string; managerName: string): Recallable =
  ## iscsiServersCreateOrUpdate
  ## Creates or updates the iSCSI server.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   iscsiServer: JObject (required)
  ##              : The iSCSI server.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564784 = newJObject()
  var query_564785 = newJObject()
  var body_564786 = newJObject()
  add(query_564785, "api-version", newJString(apiVersion))
  if iscsiServer != nil:
    body_564786 = iscsiServer
  add(path_564784, "subscriptionId", newJString(subscriptionId))
  add(path_564784, "iscsiServerName", newJString(iscsiServerName))
  add(path_564784, "deviceName", newJString(deviceName))
  add(path_564784, "resourceGroupName", newJString(resourceGroupName))
  add(path_564784, "managerName", newJString(managerName))
  result = call_564783.call(path_564784, query_564785, nil, nil, body_564786)

var iscsiServersCreateOrUpdate* = Call_IscsiServersCreateOrUpdate_564772(
    name: "iscsiServersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}",
    validator: validate_IscsiServersCreateOrUpdate_564773, base: "",
    url: url_IscsiServersCreateOrUpdate_564774, schemes: {Scheme.Https})
type
  Call_IscsiServersGet_564759 = ref object of OpenApiRestCall_563565
proc url_IscsiServersGet_564761(protocol: Scheme; host: string; base: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiServersGet_564760(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Returns the properties of the specified iSCSI server name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   deviceName: JString (required)
  ##             : The device name.
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
  var valid_564763 = path.getOrDefault("iscsiServerName")
  valid_564763 = validateParameter(valid_564763, JString, required = true,
                                 default = nil)
  if valid_564763 != nil:
    section.add "iscsiServerName", valid_564763
  var valid_564764 = path.getOrDefault("deviceName")
  valid_564764 = validateParameter(valid_564764, JString, required = true,
                                 default = nil)
  if valid_564764 != nil:
    section.add "deviceName", valid_564764
  var valid_564765 = path.getOrDefault("resourceGroupName")
  valid_564765 = validateParameter(valid_564765, JString, required = true,
                                 default = nil)
  if valid_564765 != nil:
    section.add "resourceGroupName", valid_564765
  var valid_564766 = path.getOrDefault("managerName")
  valid_564766 = validateParameter(valid_564766, JString, required = true,
                                 default = nil)
  if valid_564766 != nil:
    section.add "managerName", valid_564766
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564767 = query.getOrDefault("api-version")
  valid_564767 = validateParameter(valid_564767, JString, required = true,
                                 default = nil)
  if valid_564767 != nil:
    section.add "api-version", valid_564767
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564768: Call_IscsiServersGet_564759; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified iSCSI server name.
  ## 
  let valid = call_564768.validator(path, query, header, formData, body)
  let scheme = call_564768.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564768.url(scheme.get, call_564768.host, call_564768.base,
                         call_564768.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564768, url, valid)

proc call*(call_564769: Call_IscsiServersGet_564759; apiVersion: string;
          subscriptionId: string; iscsiServerName: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## iscsiServersGet
  ## Returns the properties of the specified iSCSI server name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564770 = newJObject()
  var query_564771 = newJObject()
  add(query_564771, "api-version", newJString(apiVersion))
  add(path_564770, "subscriptionId", newJString(subscriptionId))
  add(path_564770, "iscsiServerName", newJString(iscsiServerName))
  add(path_564770, "deviceName", newJString(deviceName))
  add(path_564770, "resourceGroupName", newJString(resourceGroupName))
  add(path_564770, "managerName", newJString(managerName))
  result = call_564769.call(path_564770, query_564771, nil, nil, nil)

var iscsiServersGet* = Call_IscsiServersGet_564759(name: "iscsiServersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}",
    validator: validate_IscsiServersGet_564760, base: "", url: url_IscsiServersGet_564761,
    schemes: {Scheme.Https})
type
  Call_IscsiServersDelete_564787 = ref object of OpenApiRestCall_563565
proc url_IscsiServersDelete_564789(protocol: Scheme; host: string; base: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiServersDelete_564788(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the iSCSI server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564790 = path.getOrDefault("subscriptionId")
  valid_564790 = validateParameter(valid_564790, JString, required = true,
                                 default = nil)
  if valid_564790 != nil:
    section.add "subscriptionId", valid_564790
  var valid_564791 = path.getOrDefault("iscsiServerName")
  valid_564791 = validateParameter(valid_564791, JString, required = true,
                                 default = nil)
  if valid_564791 != nil:
    section.add "iscsiServerName", valid_564791
  var valid_564792 = path.getOrDefault("deviceName")
  valid_564792 = validateParameter(valid_564792, JString, required = true,
                                 default = nil)
  if valid_564792 != nil:
    section.add "deviceName", valid_564792
  var valid_564793 = path.getOrDefault("resourceGroupName")
  valid_564793 = validateParameter(valid_564793, JString, required = true,
                                 default = nil)
  if valid_564793 != nil:
    section.add "resourceGroupName", valid_564793
  var valid_564794 = path.getOrDefault("managerName")
  valid_564794 = validateParameter(valid_564794, JString, required = true,
                                 default = nil)
  if valid_564794 != nil:
    section.add "managerName", valid_564794
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564795 = query.getOrDefault("api-version")
  valid_564795 = validateParameter(valid_564795, JString, required = true,
                                 default = nil)
  if valid_564795 != nil:
    section.add "api-version", valid_564795
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564796: Call_IscsiServersDelete_564787; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the iSCSI server.
  ## 
  let valid = call_564796.validator(path, query, header, formData, body)
  let scheme = call_564796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564796.url(scheme.get, call_564796.host, call_564796.base,
                         call_564796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564796, url, valid)

proc call*(call_564797: Call_IscsiServersDelete_564787; apiVersion: string;
          subscriptionId: string; iscsiServerName: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## iscsiServersDelete
  ## Deletes the iSCSI server.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564798 = newJObject()
  var query_564799 = newJObject()
  add(query_564799, "api-version", newJString(apiVersion))
  add(path_564798, "subscriptionId", newJString(subscriptionId))
  add(path_564798, "iscsiServerName", newJString(iscsiServerName))
  add(path_564798, "deviceName", newJString(deviceName))
  add(path_564798, "resourceGroupName", newJString(resourceGroupName))
  add(path_564798, "managerName", newJString(managerName))
  result = call_564797.call(path_564798, query_564799, nil, nil, nil)

var iscsiServersDelete* = Call_IscsiServersDelete_564787(
    name: "iscsiServersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}",
    validator: validate_IscsiServersDelete_564788, base: "",
    url: url_IscsiServersDelete_564789, schemes: {Scheme.Https})
type
  Call_IscsiServersBackupNow_564800 = ref object of OpenApiRestCall_563565
proc url_IscsiServersBackupNow_564802(protocol: Scheme; host: string; base: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName"),
               (kind: ConstantSegment, value: "/backup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiServersBackupNow_564801(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Backup the iSCSI server now.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564803 = path.getOrDefault("subscriptionId")
  valid_564803 = validateParameter(valid_564803, JString, required = true,
                                 default = nil)
  if valid_564803 != nil:
    section.add "subscriptionId", valid_564803
  var valid_564804 = path.getOrDefault("iscsiServerName")
  valid_564804 = validateParameter(valid_564804, JString, required = true,
                                 default = nil)
  if valid_564804 != nil:
    section.add "iscsiServerName", valid_564804
  var valid_564805 = path.getOrDefault("deviceName")
  valid_564805 = validateParameter(valid_564805, JString, required = true,
                                 default = nil)
  if valid_564805 != nil:
    section.add "deviceName", valid_564805
  var valid_564806 = path.getOrDefault("resourceGroupName")
  valid_564806 = validateParameter(valid_564806, JString, required = true,
                                 default = nil)
  if valid_564806 != nil:
    section.add "resourceGroupName", valid_564806
  var valid_564807 = path.getOrDefault("managerName")
  valid_564807 = validateParameter(valid_564807, JString, required = true,
                                 default = nil)
  if valid_564807 != nil:
    section.add "managerName", valid_564807
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564808 = query.getOrDefault("api-version")
  valid_564808 = validateParameter(valid_564808, JString, required = true,
                                 default = nil)
  if valid_564808 != nil:
    section.add "api-version", valid_564808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564809: Call_IscsiServersBackupNow_564800; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Backup the iSCSI server now.
  ## 
  let valid = call_564809.validator(path, query, header, formData, body)
  let scheme = call_564809.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564809.url(scheme.get, call_564809.host, call_564809.base,
                         call_564809.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564809, url, valid)

proc call*(call_564810: Call_IscsiServersBackupNow_564800; apiVersion: string;
          subscriptionId: string; iscsiServerName: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## iscsiServersBackupNow
  ## Backup the iSCSI server now.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564811 = newJObject()
  var query_564812 = newJObject()
  add(query_564812, "api-version", newJString(apiVersion))
  add(path_564811, "subscriptionId", newJString(subscriptionId))
  add(path_564811, "iscsiServerName", newJString(iscsiServerName))
  add(path_564811, "deviceName", newJString(deviceName))
  add(path_564811, "resourceGroupName", newJString(resourceGroupName))
  add(path_564811, "managerName", newJString(managerName))
  result = call_564810.call(path_564811, query_564812, nil, nil, nil)

var iscsiServersBackupNow* = Call_IscsiServersBackupNow_564800(
    name: "iscsiServersBackupNow", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/backup",
    validator: validate_IscsiServersBackupNow_564801, base: "",
    url: url_IscsiServersBackupNow_564802, schemes: {Scheme.Https})
type
  Call_IscsiDisksListByIscsiServer_564813 = ref object of OpenApiRestCall_563565
proc url_IscsiDisksListByIscsiServer_564815(protocol: Scheme; host: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName"),
               (kind: ConstantSegment, value: "/disks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiDisksListByIscsiServer_564814(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the disks in a iSCSI server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564816 = path.getOrDefault("subscriptionId")
  valid_564816 = validateParameter(valid_564816, JString, required = true,
                                 default = nil)
  if valid_564816 != nil:
    section.add "subscriptionId", valid_564816
  var valid_564817 = path.getOrDefault("iscsiServerName")
  valid_564817 = validateParameter(valid_564817, JString, required = true,
                                 default = nil)
  if valid_564817 != nil:
    section.add "iscsiServerName", valid_564817
  var valid_564818 = path.getOrDefault("deviceName")
  valid_564818 = validateParameter(valid_564818, JString, required = true,
                                 default = nil)
  if valid_564818 != nil:
    section.add "deviceName", valid_564818
  var valid_564819 = path.getOrDefault("resourceGroupName")
  valid_564819 = validateParameter(valid_564819, JString, required = true,
                                 default = nil)
  if valid_564819 != nil:
    section.add "resourceGroupName", valid_564819
  var valid_564820 = path.getOrDefault("managerName")
  valid_564820 = validateParameter(valid_564820, JString, required = true,
                                 default = nil)
  if valid_564820 != nil:
    section.add "managerName", valid_564820
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564821 = query.getOrDefault("api-version")
  valid_564821 = validateParameter(valid_564821, JString, required = true,
                                 default = nil)
  if valid_564821 != nil:
    section.add "api-version", valid_564821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564822: Call_IscsiDisksListByIscsiServer_564813; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the disks in a iSCSI server.
  ## 
  let valid = call_564822.validator(path, query, header, formData, body)
  let scheme = call_564822.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564822.url(scheme.get, call_564822.host, call_564822.base,
                         call_564822.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564822, url, valid)

proc call*(call_564823: Call_IscsiDisksListByIscsiServer_564813;
          apiVersion: string; subscriptionId: string; iscsiServerName: string;
          deviceName: string; resourceGroupName: string; managerName: string): Recallable =
  ## iscsiDisksListByIscsiServer
  ## Retrieves all the disks in a iSCSI server.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564824 = newJObject()
  var query_564825 = newJObject()
  add(query_564825, "api-version", newJString(apiVersion))
  add(path_564824, "subscriptionId", newJString(subscriptionId))
  add(path_564824, "iscsiServerName", newJString(iscsiServerName))
  add(path_564824, "deviceName", newJString(deviceName))
  add(path_564824, "resourceGroupName", newJString(resourceGroupName))
  add(path_564824, "managerName", newJString(managerName))
  result = call_564823.call(path_564824, query_564825, nil, nil, nil)

var iscsiDisksListByIscsiServer* = Call_IscsiDisksListByIscsiServer_564813(
    name: "iscsiDisksListByIscsiServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/disks",
    validator: validate_IscsiDisksListByIscsiServer_564814, base: "",
    url: url_IscsiDisksListByIscsiServer_564815, schemes: {Scheme.Https})
type
  Call_IscsiDisksCreateOrUpdate_564840 = ref object of OpenApiRestCall_563565
proc url_IscsiDisksCreateOrUpdate_564842(protocol: Scheme; host: string;
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
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  assert "diskName" in path, "`diskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "diskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiDisksCreateOrUpdate_564841(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the iSCSI disk.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   diskName: JString (required)
  ##           : The disk name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `diskName` field"
  var valid_564843 = path.getOrDefault("diskName")
  valid_564843 = validateParameter(valid_564843, JString, required = true,
                                 default = nil)
  if valid_564843 != nil:
    section.add "diskName", valid_564843
  var valid_564844 = path.getOrDefault("subscriptionId")
  valid_564844 = validateParameter(valid_564844, JString, required = true,
                                 default = nil)
  if valid_564844 != nil:
    section.add "subscriptionId", valid_564844
  var valid_564845 = path.getOrDefault("iscsiServerName")
  valid_564845 = validateParameter(valid_564845, JString, required = true,
                                 default = nil)
  if valid_564845 != nil:
    section.add "iscsiServerName", valid_564845
  var valid_564846 = path.getOrDefault("deviceName")
  valid_564846 = validateParameter(valid_564846, JString, required = true,
                                 default = nil)
  if valid_564846 != nil:
    section.add "deviceName", valid_564846
  var valid_564847 = path.getOrDefault("resourceGroupName")
  valid_564847 = validateParameter(valid_564847, JString, required = true,
                                 default = nil)
  if valid_564847 != nil:
    section.add "resourceGroupName", valid_564847
  var valid_564848 = path.getOrDefault("managerName")
  valid_564848 = validateParameter(valid_564848, JString, required = true,
                                 default = nil)
  if valid_564848 != nil:
    section.add "managerName", valid_564848
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564849 = query.getOrDefault("api-version")
  valid_564849 = validateParameter(valid_564849, JString, required = true,
                                 default = nil)
  if valid_564849 != nil:
    section.add "api-version", valid_564849
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   iscsiDisk: JObject (required)
  ##            : The iSCSI disk.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564851: Call_IscsiDisksCreateOrUpdate_564840; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the iSCSI disk.
  ## 
  let valid = call_564851.validator(path, query, header, formData, body)
  let scheme = call_564851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564851.url(scheme.get, call_564851.host, call_564851.base,
                         call_564851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564851, url, valid)

proc call*(call_564852: Call_IscsiDisksCreateOrUpdate_564840; diskName: string;
          apiVersion: string; subscriptionId: string; iscsiServerName: string;
          deviceName: string; resourceGroupName: string; managerName: string;
          iscsiDisk: JsonNode): Recallable =
  ## iscsiDisksCreateOrUpdate
  ## Creates or updates the iSCSI disk.
  ##   diskName: string (required)
  ##           : The disk name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   iscsiDisk: JObject (required)
  ##            : The iSCSI disk.
  var path_564853 = newJObject()
  var query_564854 = newJObject()
  var body_564855 = newJObject()
  add(path_564853, "diskName", newJString(diskName))
  add(query_564854, "api-version", newJString(apiVersion))
  add(path_564853, "subscriptionId", newJString(subscriptionId))
  add(path_564853, "iscsiServerName", newJString(iscsiServerName))
  add(path_564853, "deviceName", newJString(deviceName))
  add(path_564853, "resourceGroupName", newJString(resourceGroupName))
  add(path_564853, "managerName", newJString(managerName))
  if iscsiDisk != nil:
    body_564855 = iscsiDisk
  result = call_564852.call(path_564853, query_564854, nil, nil, body_564855)

var iscsiDisksCreateOrUpdate* = Call_IscsiDisksCreateOrUpdate_564840(
    name: "iscsiDisksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/disks/{diskName}",
    validator: validate_IscsiDisksCreateOrUpdate_564841, base: "",
    url: url_IscsiDisksCreateOrUpdate_564842, schemes: {Scheme.Https})
type
  Call_IscsiDisksGet_564826 = ref object of OpenApiRestCall_563565
proc url_IscsiDisksGet_564828(protocol: Scheme; host: string; base: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  assert "diskName" in path, "`diskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "diskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiDisksGet_564827(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified iSCSI disk name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   diskName: JString (required)
  ##           : The disk name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `diskName` field"
  var valid_564829 = path.getOrDefault("diskName")
  valid_564829 = validateParameter(valid_564829, JString, required = true,
                                 default = nil)
  if valid_564829 != nil:
    section.add "diskName", valid_564829
  var valid_564830 = path.getOrDefault("subscriptionId")
  valid_564830 = validateParameter(valid_564830, JString, required = true,
                                 default = nil)
  if valid_564830 != nil:
    section.add "subscriptionId", valid_564830
  var valid_564831 = path.getOrDefault("iscsiServerName")
  valid_564831 = validateParameter(valid_564831, JString, required = true,
                                 default = nil)
  if valid_564831 != nil:
    section.add "iscsiServerName", valid_564831
  var valid_564832 = path.getOrDefault("deviceName")
  valid_564832 = validateParameter(valid_564832, JString, required = true,
                                 default = nil)
  if valid_564832 != nil:
    section.add "deviceName", valid_564832
  var valid_564833 = path.getOrDefault("resourceGroupName")
  valid_564833 = validateParameter(valid_564833, JString, required = true,
                                 default = nil)
  if valid_564833 != nil:
    section.add "resourceGroupName", valid_564833
  var valid_564834 = path.getOrDefault("managerName")
  valid_564834 = validateParameter(valid_564834, JString, required = true,
                                 default = nil)
  if valid_564834 != nil:
    section.add "managerName", valid_564834
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564835 = query.getOrDefault("api-version")
  valid_564835 = validateParameter(valid_564835, JString, required = true,
                                 default = nil)
  if valid_564835 != nil:
    section.add "api-version", valid_564835
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564836: Call_IscsiDisksGet_564826; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified iSCSI disk name.
  ## 
  let valid = call_564836.validator(path, query, header, formData, body)
  let scheme = call_564836.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564836.url(scheme.get, call_564836.host, call_564836.base,
                         call_564836.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564836, url, valid)

proc call*(call_564837: Call_IscsiDisksGet_564826; diskName: string;
          apiVersion: string; subscriptionId: string; iscsiServerName: string;
          deviceName: string; resourceGroupName: string; managerName: string): Recallable =
  ## iscsiDisksGet
  ## Returns the properties of the specified iSCSI disk name.
  ##   diskName: string (required)
  ##           : The disk name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564838 = newJObject()
  var query_564839 = newJObject()
  add(path_564838, "diskName", newJString(diskName))
  add(query_564839, "api-version", newJString(apiVersion))
  add(path_564838, "subscriptionId", newJString(subscriptionId))
  add(path_564838, "iscsiServerName", newJString(iscsiServerName))
  add(path_564838, "deviceName", newJString(deviceName))
  add(path_564838, "resourceGroupName", newJString(resourceGroupName))
  add(path_564838, "managerName", newJString(managerName))
  result = call_564837.call(path_564838, query_564839, nil, nil, nil)

var iscsiDisksGet* = Call_IscsiDisksGet_564826(name: "iscsiDisksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/disks/{diskName}",
    validator: validate_IscsiDisksGet_564827, base: "", url: url_IscsiDisksGet_564828,
    schemes: {Scheme.Https})
type
  Call_IscsiDisksDelete_564856 = ref object of OpenApiRestCall_563565
proc url_IscsiDisksDelete_564858(protocol: Scheme; host: string; base: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  assert "diskName" in path, "`diskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "diskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiDisksDelete_564857(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes the iSCSI disk.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   diskName: JString (required)
  ##           : The disk name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `diskName` field"
  var valid_564859 = path.getOrDefault("diskName")
  valid_564859 = validateParameter(valid_564859, JString, required = true,
                                 default = nil)
  if valid_564859 != nil:
    section.add "diskName", valid_564859
  var valid_564860 = path.getOrDefault("subscriptionId")
  valid_564860 = validateParameter(valid_564860, JString, required = true,
                                 default = nil)
  if valid_564860 != nil:
    section.add "subscriptionId", valid_564860
  var valid_564861 = path.getOrDefault("iscsiServerName")
  valid_564861 = validateParameter(valid_564861, JString, required = true,
                                 default = nil)
  if valid_564861 != nil:
    section.add "iscsiServerName", valid_564861
  var valid_564862 = path.getOrDefault("deviceName")
  valid_564862 = validateParameter(valid_564862, JString, required = true,
                                 default = nil)
  if valid_564862 != nil:
    section.add "deviceName", valid_564862
  var valid_564863 = path.getOrDefault("resourceGroupName")
  valid_564863 = validateParameter(valid_564863, JString, required = true,
                                 default = nil)
  if valid_564863 != nil:
    section.add "resourceGroupName", valid_564863
  var valid_564864 = path.getOrDefault("managerName")
  valid_564864 = validateParameter(valid_564864, JString, required = true,
                                 default = nil)
  if valid_564864 != nil:
    section.add "managerName", valid_564864
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564865 = query.getOrDefault("api-version")
  valid_564865 = validateParameter(valid_564865, JString, required = true,
                                 default = nil)
  if valid_564865 != nil:
    section.add "api-version", valid_564865
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564866: Call_IscsiDisksDelete_564856; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the iSCSI disk.
  ## 
  let valid = call_564866.validator(path, query, header, formData, body)
  let scheme = call_564866.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564866.url(scheme.get, call_564866.host, call_564866.base,
                         call_564866.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564866, url, valid)

proc call*(call_564867: Call_IscsiDisksDelete_564856; diskName: string;
          apiVersion: string; subscriptionId: string; iscsiServerName: string;
          deviceName: string; resourceGroupName: string; managerName: string): Recallable =
  ## iscsiDisksDelete
  ## Deletes the iSCSI disk.
  ##   diskName: string (required)
  ##           : The disk name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564868 = newJObject()
  var query_564869 = newJObject()
  add(path_564868, "diskName", newJString(diskName))
  add(query_564869, "api-version", newJString(apiVersion))
  add(path_564868, "subscriptionId", newJString(subscriptionId))
  add(path_564868, "iscsiServerName", newJString(iscsiServerName))
  add(path_564868, "deviceName", newJString(deviceName))
  add(path_564868, "resourceGroupName", newJString(resourceGroupName))
  add(path_564868, "managerName", newJString(managerName))
  result = call_564867.call(path_564868, query_564869, nil, nil, nil)

var iscsiDisksDelete* = Call_IscsiDisksDelete_564856(name: "iscsiDisksDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/disks/{diskName}",
    validator: validate_IscsiDisksDelete_564857, base: "",
    url: url_IscsiDisksDelete_564858, schemes: {Scheme.Https})
type
  Call_IscsiDisksListMetrics_564870 = ref object of OpenApiRestCall_563565
proc url_IscsiDisksListMetrics_564872(protocol: Scheme; host: string; base: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  assert "diskName" in path, "`diskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "diskName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiDisksListMetrics_564871(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the iSCSI disk metrics
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   diskName: JString (required)
  ##           : The iSCSI disk name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `diskName` field"
  var valid_564873 = path.getOrDefault("diskName")
  valid_564873 = validateParameter(valid_564873, JString, required = true,
                                 default = nil)
  if valid_564873 != nil:
    section.add "diskName", valid_564873
  var valid_564874 = path.getOrDefault("subscriptionId")
  valid_564874 = validateParameter(valid_564874, JString, required = true,
                                 default = nil)
  if valid_564874 != nil:
    section.add "subscriptionId", valid_564874
  var valid_564875 = path.getOrDefault("iscsiServerName")
  valid_564875 = validateParameter(valid_564875, JString, required = true,
                                 default = nil)
  if valid_564875 != nil:
    section.add "iscsiServerName", valid_564875
  var valid_564876 = path.getOrDefault("deviceName")
  valid_564876 = validateParameter(valid_564876, JString, required = true,
                                 default = nil)
  if valid_564876 != nil:
    section.add "deviceName", valid_564876
  var valid_564877 = path.getOrDefault("resourceGroupName")
  valid_564877 = validateParameter(valid_564877, JString, required = true,
                                 default = nil)
  if valid_564877 != nil:
    section.add "resourceGroupName", valid_564877
  var valid_564878 = path.getOrDefault("managerName")
  valid_564878 = validateParameter(valid_564878, JString, required = true,
                                 default = nil)
  if valid_564878 != nil:
    section.add "managerName", valid_564878
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564879 = query.getOrDefault("api-version")
  valid_564879 = validateParameter(valid_564879, JString, required = true,
                                 default = nil)
  if valid_564879 != nil:
    section.add "api-version", valid_564879
  var valid_564880 = query.getOrDefault("$filter")
  valid_564880 = validateParameter(valid_564880, JString, required = false,
                                 default = nil)
  if valid_564880 != nil:
    section.add "$filter", valid_564880
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564881: Call_IscsiDisksListMetrics_564870; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the iSCSI disk metrics
  ## 
  let valid = call_564881.validator(path, query, header, formData, body)
  let scheme = call_564881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564881.url(scheme.get, call_564881.host, call_564881.base,
                         call_564881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564881, url, valid)

proc call*(call_564882: Call_IscsiDisksListMetrics_564870; diskName: string;
          apiVersion: string; subscriptionId: string; iscsiServerName: string;
          deviceName: string; resourceGroupName: string; managerName: string;
          Filter: string = ""): Recallable =
  ## iscsiDisksListMetrics
  ## Gets the iSCSI disk metrics
  ##   diskName: string (required)
  ##           : The iSCSI disk name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   Filter: string
  ##         : OData Filter options
  var path_564883 = newJObject()
  var query_564884 = newJObject()
  add(path_564883, "diskName", newJString(diskName))
  add(query_564884, "api-version", newJString(apiVersion))
  add(path_564883, "subscriptionId", newJString(subscriptionId))
  add(path_564883, "iscsiServerName", newJString(iscsiServerName))
  add(path_564883, "deviceName", newJString(deviceName))
  add(path_564883, "resourceGroupName", newJString(resourceGroupName))
  add(path_564883, "managerName", newJString(managerName))
  add(query_564884, "$filter", newJString(Filter))
  result = call_564882.call(path_564883, query_564884, nil, nil, nil)

var iscsiDisksListMetrics* = Call_IscsiDisksListMetrics_564870(
    name: "iscsiDisksListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/disks/{diskName}/metrics",
    validator: validate_IscsiDisksListMetrics_564871, base: "",
    url: url_IscsiDisksListMetrics_564872, schemes: {Scheme.Https})
type
  Call_IscsiDisksListMetricDefinition_564885 = ref object of OpenApiRestCall_563565
proc url_IscsiDisksListMetricDefinition_564887(protocol: Scheme; host: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  assert "diskName" in path, "`diskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "diskName"),
               (kind: ConstantSegment, value: "/metricsDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiDisksListMetricDefinition_564886(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves metric definitions for all metric aggregated at the iSCSI disk.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   diskName: JString (required)
  ##           : The iSCSI disk name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `diskName` field"
  var valid_564888 = path.getOrDefault("diskName")
  valid_564888 = validateParameter(valid_564888, JString, required = true,
                                 default = nil)
  if valid_564888 != nil:
    section.add "diskName", valid_564888
  var valid_564889 = path.getOrDefault("subscriptionId")
  valid_564889 = validateParameter(valid_564889, JString, required = true,
                                 default = nil)
  if valid_564889 != nil:
    section.add "subscriptionId", valid_564889
  var valid_564890 = path.getOrDefault("iscsiServerName")
  valid_564890 = validateParameter(valid_564890, JString, required = true,
                                 default = nil)
  if valid_564890 != nil:
    section.add "iscsiServerName", valid_564890
  var valid_564891 = path.getOrDefault("deviceName")
  valid_564891 = validateParameter(valid_564891, JString, required = true,
                                 default = nil)
  if valid_564891 != nil:
    section.add "deviceName", valid_564891
  var valid_564892 = path.getOrDefault("resourceGroupName")
  valid_564892 = validateParameter(valid_564892, JString, required = true,
                                 default = nil)
  if valid_564892 != nil:
    section.add "resourceGroupName", valid_564892
  var valid_564893 = path.getOrDefault("managerName")
  valid_564893 = validateParameter(valid_564893, JString, required = true,
                                 default = nil)
  if valid_564893 != nil:
    section.add "managerName", valid_564893
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564894 = query.getOrDefault("api-version")
  valid_564894 = validateParameter(valid_564894, JString, required = true,
                                 default = nil)
  if valid_564894 != nil:
    section.add "api-version", valid_564894
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564895: Call_IscsiDisksListMetricDefinition_564885; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metric definitions for all metric aggregated at the iSCSI disk.
  ## 
  let valid = call_564895.validator(path, query, header, formData, body)
  let scheme = call_564895.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564895.url(scheme.get, call_564895.host, call_564895.base,
                         call_564895.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564895, url, valid)

proc call*(call_564896: Call_IscsiDisksListMetricDefinition_564885;
          diskName: string; apiVersion: string; subscriptionId: string;
          iscsiServerName: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## iscsiDisksListMetricDefinition
  ## Retrieves metric definitions for all metric aggregated at the iSCSI disk.
  ##   diskName: string (required)
  ##           : The iSCSI disk name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564897 = newJObject()
  var query_564898 = newJObject()
  add(path_564897, "diskName", newJString(diskName))
  add(query_564898, "api-version", newJString(apiVersion))
  add(path_564897, "subscriptionId", newJString(subscriptionId))
  add(path_564897, "iscsiServerName", newJString(iscsiServerName))
  add(path_564897, "deviceName", newJString(deviceName))
  add(path_564897, "resourceGroupName", newJString(resourceGroupName))
  add(path_564897, "managerName", newJString(managerName))
  result = call_564896.call(path_564897, query_564898, nil, nil, nil)

var iscsiDisksListMetricDefinition* = Call_IscsiDisksListMetricDefinition_564885(
    name: "iscsiDisksListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/disks/{diskName}/metricsDefinitions",
    validator: validate_IscsiDisksListMetricDefinition_564886, base: "",
    url: url_IscsiDisksListMetricDefinition_564887, schemes: {Scheme.Https})
type
  Call_IscsiServersListMetrics_564899 = ref object of OpenApiRestCall_563565
proc url_IscsiServersListMetrics_564901(protocol: Scheme; host: string; base: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiServersListMetrics_564900(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the iSCSI server metrics
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564902 = path.getOrDefault("subscriptionId")
  valid_564902 = validateParameter(valid_564902, JString, required = true,
                                 default = nil)
  if valid_564902 != nil:
    section.add "subscriptionId", valid_564902
  var valid_564903 = path.getOrDefault("iscsiServerName")
  valid_564903 = validateParameter(valid_564903, JString, required = true,
                                 default = nil)
  if valid_564903 != nil:
    section.add "iscsiServerName", valid_564903
  var valid_564904 = path.getOrDefault("deviceName")
  valid_564904 = validateParameter(valid_564904, JString, required = true,
                                 default = nil)
  if valid_564904 != nil:
    section.add "deviceName", valid_564904
  var valid_564905 = path.getOrDefault("resourceGroupName")
  valid_564905 = validateParameter(valid_564905, JString, required = true,
                                 default = nil)
  if valid_564905 != nil:
    section.add "resourceGroupName", valid_564905
  var valid_564906 = path.getOrDefault("managerName")
  valid_564906 = validateParameter(valid_564906, JString, required = true,
                                 default = nil)
  if valid_564906 != nil:
    section.add "managerName", valid_564906
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564907 = query.getOrDefault("api-version")
  valid_564907 = validateParameter(valid_564907, JString, required = true,
                                 default = nil)
  if valid_564907 != nil:
    section.add "api-version", valid_564907
  var valid_564908 = query.getOrDefault("$filter")
  valid_564908 = validateParameter(valid_564908, JString, required = false,
                                 default = nil)
  if valid_564908 != nil:
    section.add "$filter", valid_564908
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564909: Call_IscsiServersListMetrics_564899; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the iSCSI server metrics
  ## 
  let valid = call_564909.validator(path, query, header, formData, body)
  let scheme = call_564909.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564909.url(scheme.get, call_564909.host, call_564909.base,
                         call_564909.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564909, url, valid)

proc call*(call_564910: Call_IscsiServersListMetrics_564899; apiVersion: string;
          subscriptionId: string; iscsiServerName: string; deviceName: string;
          resourceGroupName: string; managerName: string; Filter: string = ""): Recallable =
  ## iscsiServersListMetrics
  ## Gets the iSCSI server metrics
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   Filter: string
  ##         : OData Filter options
  var path_564911 = newJObject()
  var query_564912 = newJObject()
  add(query_564912, "api-version", newJString(apiVersion))
  add(path_564911, "subscriptionId", newJString(subscriptionId))
  add(path_564911, "iscsiServerName", newJString(iscsiServerName))
  add(path_564911, "deviceName", newJString(deviceName))
  add(path_564911, "resourceGroupName", newJString(resourceGroupName))
  add(path_564911, "managerName", newJString(managerName))
  add(query_564912, "$filter", newJString(Filter))
  result = call_564910.call(path_564911, query_564912, nil, nil, nil)

var iscsiServersListMetrics* = Call_IscsiServersListMetrics_564899(
    name: "iscsiServersListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/metrics",
    validator: validate_IscsiServersListMetrics_564900, base: "",
    url: url_IscsiServersListMetrics_564901, schemes: {Scheme.Https})
type
  Call_IscsiServersListMetricDefinition_564913 = ref object of OpenApiRestCall_563565
proc url_IscsiServersListMetricDefinition_564915(protocol: Scheme; host: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName"),
               (kind: ConstantSegment, value: "/metricsDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiServersListMetricDefinition_564914(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves metric definitions for all metrics aggregated at iSCSI server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564916 = path.getOrDefault("subscriptionId")
  valid_564916 = validateParameter(valid_564916, JString, required = true,
                                 default = nil)
  if valid_564916 != nil:
    section.add "subscriptionId", valid_564916
  var valid_564917 = path.getOrDefault("iscsiServerName")
  valid_564917 = validateParameter(valid_564917, JString, required = true,
                                 default = nil)
  if valid_564917 != nil:
    section.add "iscsiServerName", valid_564917
  var valid_564918 = path.getOrDefault("deviceName")
  valid_564918 = validateParameter(valid_564918, JString, required = true,
                                 default = nil)
  if valid_564918 != nil:
    section.add "deviceName", valid_564918
  var valid_564919 = path.getOrDefault("resourceGroupName")
  valid_564919 = validateParameter(valid_564919, JString, required = true,
                                 default = nil)
  if valid_564919 != nil:
    section.add "resourceGroupName", valid_564919
  var valid_564920 = path.getOrDefault("managerName")
  valid_564920 = validateParameter(valid_564920, JString, required = true,
                                 default = nil)
  if valid_564920 != nil:
    section.add "managerName", valid_564920
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564921 = query.getOrDefault("api-version")
  valid_564921 = validateParameter(valid_564921, JString, required = true,
                                 default = nil)
  if valid_564921 != nil:
    section.add "api-version", valid_564921
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564922: Call_IscsiServersListMetricDefinition_564913;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves metric definitions for all metrics aggregated at iSCSI server.
  ## 
  let valid = call_564922.validator(path, query, header, formData, body)
  let scheme = call_564922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564922.url(scheme.get, call_564922.host, call_564922.base,
                         call_564922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564922, url, valid)

proc call*(call_564923: Call_IscsiServersListMetricDefinition_564913;
          apiVersion: string; subscriptionId: string; iscsiServerName: string;
          deviceName: string; resourceGroupName: string; managerName: string): Recallable =
  ## iscsiServersListMetricDefinition
  ## Retrieves metric definitions for all metrics aggregated at iSCSI server.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564924 = newJObject()
  var query_564925 = newJObject()
  add(query_564925, "api-version", newJString(apiVersion))
  add(path_564924, "subscriptionId", newJString(subscriptionId))
  add(path_564924, "iscsiServerName", newJString(iscsiServerName))
  add(path_564924, "deviceName", newJString(deviceName))
  add(path_564924, "resourceGroupName", newJString(resourceGroupName))
  add(path_564924, "managerName", newJString(managerName))
  result = call_564923.call(path_564924, query_564925, nil, nil, nil)

var iscsiServersListMetricDefinition* = Call_IscsiServersListMetricDefinition_564913(
    name: "iscsiServersListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/metricsDefinitions",
    validator: validate_IscsiServersListMetricDefinition_564914, base: "",
    url: url_IscsiServersListMetricDefinition_564915, schemes: {Scheme.Https})
type
  Call_JobsListByDevice_564926 = ref object of OpenApiRestCall_563565
proc url_JobsListByDevice_564928(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByDevice_564927(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves all the jobs in a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564929 = path.getOrDefault("subscriptionId")
  valid_564929 = validateParameter(valid_564929, JString, required = true,
                                 default = nil)
  if valid_564929 != nil:
    section.add "subscriptionId", valid_564929
  var valid_564930 = path.getOrDefault("deviceName")
  valid_564930 = validateParameter(valid_564930, JString, required = true,
                                 default = nil)
  if valid_564930 != nil:
    section.add "deviceName", valid_564930
  var valid_564931 = path.getOrDefault("resourceGroupName")
  valid_564931 = validateParameter(valid_564931, JString, required = true,
                                 default = nil)
  if valid_564931 != nil:
    section.add "resourceGroupName", valid_564931
  var valid_564932 = path.getOrDefault("managerName")
  valid_564932 = validateParameter(valid_564932, JString, required = true,
                                 default = nil)
  if valid_564932 != nil:
    section.add "managerName", valid_564932
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564933 = query.getOrDefault("api-version")
  valid_564933 = validateParameter(valid_564933, JString, required = true,
                                 default = nil)
  if valid_564933 != nil:
    section.add "api-version", valid_564933
  var valid_564934 = query.getOrDefault("$filter")
  valid_564934 = validateParameter(valid_564934, JString, required = false,
                                 default = nil)
  if valid_564934 != nil:
    section.add "$filter", valid_564934
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564935: Call_JobsListByDevice_564926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the jobs in a device.
  ## 
  let valid = call_564935.validator(path, query, header, formData, body)
  let scheme = call_564935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564935.url(scheme.get, call_564935.host, call_564935.base,
                         call_564935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564935, url, valid)

proc call*(call_564936: Call_JobsListByDevice_564926; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; Filter: string = ""): Recallable =
  ## jobsListByDevice
  ## Retrieves all the jobs in a device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   Filter: string
  ##         : OData Filter options
  var path_564937 = newJObject()
  var query_564938 = newJObject()
  add(query_564938, "api-version", newJString(apiVersion))
  add(path_564937, "subscriptionId", newJString(subscriptionId))
  add(path_564937, "deviceName", newJString(deviceName))
  add(path_564937, "resourceGroupName", newJString(resourceGroupName))
  add(path_564937, "managerName", newJString(managerName))
  add(query_564938, "$filter", newJString(Filter))
  result = call_564936.call(path_564937, query_564938, nil, nil, nil)

var jobsListByDevice* = Call_JobsListByDevice_564926(name: "jobsListByDevice",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/jobs",
    validator: validate_JobsListByDevice_564927, base: "",
    url: url_JobsListByDevice_564928, schemes: {Scheme.Https})
type
  Call_JobsGet_564939 = ref object of OpenApiRestCall_563565
proc url_JobsGet_564941(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsGet_564940(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified job name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   jobName: JString (required)
  ##          : The job name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564942 = path.getOrDefault("subscriptionId")
  valid_564942 = validateParameter(valid_564942, JString, required = true,
                                 default = nil)
  if valid_564942 != nil:
    section.add "subscriptionId", valid_564942
  var valid_564943 = path.getOrDefault("deviceName")
  valid_564943 = validateParameter(valid_564943, JString, required = true,
                                 default = nil)
  if valid_564943 != nil:
    section.add "deviceName", valid_564943
  var valid_564944 = path.getOrDefault("resourceGroupName")
  valid_564944 = validateParameter(valid_564944, JString, required = true,
                                 default = nil)
  if valid_564944 != nil:
    section.add "resourceGroupName", valid_564944
  var valid_564945 = path.getOrDefault("managerName")
  valid_564945 = validateParameter(valid_564945, JString, required = true,
                                 default = nil)
  if valid_564945 != nil:
    section.add "managerName", valid_564945
  var valid_564946 = path.getOrDefault("jobName")
  valid_564946 = validateParameter(valid_564946, JString, required = true,
                                 default = nil)
  if valid_564946 != nil:
    section.add "jobName", valid_564946
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564947 = query.getOrDefault("api-version")
  valid_564947 = validateParameter(valid_564947, JString, required = true,
                                 default = nil)
  if valid_564947 != nil:
    section.add "api-version", valid_564947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564948: Call_JobsGet_564939; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified job name.
  ## 
  let valid = call_564948.validator(path, query, header, formData, body)
  let scheme = call_564948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564948.url(scheme.get, call_564948.host, call_564948.base,
                         call_564948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564948, url, valid)

proc call*(call_564949: Call_JobsGet_564939; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; jobName: string): Recallable =
  ## jobsGet
  ## Returns the properties of the specified job name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   jobName: string (required)
  ##          : The job name.
  var path_564950 = newJObject()
  var query_564951 = newJObject()
  add(query_564951, "api-version", newJString(apiVersion))
  add(path_564950, "subscriptionId", newJString(subscriptionId))
  add(path_564950, "deviceName", newJString(deviceName))
  add(path_564950, "resourceGroupName", newJString(resourceGroupName))
  add(path_564950, "managerName", newJString(managerName))
  add(path_564950, "jobName", newJString(jobName))
  result = call_564949.call(path_564950, query_564951, nil, nil, nil)

var jobsGet* = Call_JobsGet_564939(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/jobs/{jobName}",
                                validator: validate_JobsGet_564940, base: "",
                                url: url_JobsGet_564941, schemes: {Scheme.Https})
type
  Call_DevicesListMetrics_564952 = ref object of OpenApiRestCall_563565
proc url_DevicesListMetrics_564954(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesListMetrics_564953(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves the device metrics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The name of the appliance.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564955 = path.getOrDefault("subscriptionId")
  valid_564955 = validateParameter(valid_564955, JString, required = true,
                                 default = nil)
  if valid_564955 != nil:
    section.add "subscriptionId", valid_564955
  var valid_564956 = path.getOrDefault("deviceName")
  valid_564956 = validateParameter(valid_564956, JString, required = true,
                                 default = nil)
  if valid_564956 != nil:
    section.add "deviceName", valid_564956
  var valid_564957 = path.getOrDefault("resourceGroupName")
  valid_564957 = validateParameter(valid_564957, JString, required = true,
                                 default = nil)
  if valid_564957 != nil:
    section.add "resourceGroupName", valid_564957
  var valid_564958 = path.getOrDefault("managerName")
  valid_564958 = validateParameter(valid_564958, JString, required = true,
                                 default = nil)
  if valid_564958 != nil:
    section.add "managerName", valid_564958
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564959 = query.getOrDefault("api-version")
  valid_564959 = validateParameter(valid_564959, JString, required = true,
                                 default = nil)
  if valid_564959 != nil:
    section.add "api-version", valid_564959
  var valid_564960 = query.getOrDefault("$filter")
  valid_564960 = validateParameter(valid_564960, JString, required = false,
                                 default = nil)
  if valid_564960 != nil:
    section.add "$filter", valid_564960
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564961: Call_DevicesListMetrics_564952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the device metrics.
  ## 
  let valid = call_564961.validator(path, query, header, formData, body)
  let scheme = call_564961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564961.url(scheme.get, call_564961.host, call_564961.base,
                         call_564961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564961, url, valid)

proc call*(call_564962: Call_DevicesListMetrics_564952; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; Filter: string = ""): Recallable =
  ## devicesListMetrics
  ## Retrieves the device metrics.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The name of the appliance.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   Filter: string
  ##         : OData Filter options
  var path_564963 = newJObject()
  var query_564964 = newJObject()
  add(query_564964, "api-version", newJString(apiVersion))
  add(path_564963, "subscriptionId", newJString(subscriptionId))
  add(path_564963, "deviceName", newJString(deviceName))
  add(path_564963, "resourceGroupName", newJString(resourceGroupName))
  add(path_564963, "managerName", newJString(managerName))
  add(query_564964, "$filter", newJString(Filter))
  result = call_564962.call(path_564963, query_564964, nil, nil, nil)

var devicesListMetrics* = Call_DevicesListMetrics_564952(
    name: "devicesListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/metrics",
    validator: validate_DevicesListMetrics_564953, base: "",
    url: url_DevicesListMetrics_564954, schemes: {Scheme.Https})
type
  Call_DevicesListMetricDefinition_564965 = ref object of OpenApiRestCall_563565
proc url_DevicesListMetricDefinition_564967(protocol: Scheme; host: string;
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

proc validate_DevicesListMetricDefinition_564966(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves metric definition of all metrics aggregated at device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The name of the appliance.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564968 = path.getOrDefault("subscriptionId")
  valid_564968 = validateParameter(valid_564968, JString, required = true,
                                 default = nil)
  if valid_564968 != nil:
    section.add "subscriptionId", valid_564968
  var valid_564969 = path.getOrDefault("deviceName")
  valid_564969 = validateParameter(valid_564969, JString, required = true,
                                 default = nil)
  if valid_564969 != nil:
    section.add "deviceName", valid_564969
  var valid_564970 = path.getOrDefault("resourceGroupName")
  valid_564970 = validateParameter(valid_564970, JString, required = true,
                                 default = nil)
  if valid_564970 != nil:
    section.add "resourceGroupName", valid_564970
  var valid_564971 = path.getOrDefault("managerName")
  valid_564971 = validateParameter(valid_564971, JString, required = true,
                                 default = nil)
  if valid_564971 != nil:
    section.add "managerName", valid_564971
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564972 = query.getOrDefault("api-version")
  valid_564972 = validateParameter(valid_564972, JString, required = true,
                                 default = nil)
  if valid_564972 != nil:
    section.add "api-version", valid_564972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564973: Call_DevicesListMetricDefinition_564965; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metric definition of all metrics aggregated at device.
  ## 
  let valid = call_564973.validator(path, query, header, formData, body)
  let scheme = call_564973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564973.url(scheme.get, call_564973.host, call_564973.base,
                         call_564973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564973, url, valid)

proc call*(call_564974: Call_DevicesListMetricDefinition_564965;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## devicesListMetricDefinition
  ## Retrieves metric definition of all metrics aggregated at device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The name of the appliance.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564975 = newJObject()
  var query_564976 = newJObject()
  add(query_564976, "api-version", newJString(apiVersion))
  add(path_564975, "subscriptionId", newJString(subscriptionId))
  add(path_564975, "deviceName", newJString(deviceName))
  add(path_564975, "resourceGroupName", newJString(resourceGroupName))
  add(path_564975, "managerName", newJString(managerName))
  result = call_564974.call(path_564975, query_564976, nil, nil, nil)

var devicesListMetricDefinition* = Call_DevicesListMetricDefinition_564965(
    name: "devicesListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/metricsDefinitions",
    validator: validate_DevicesListMetricDefinition_564966, base: "",
    url: url_DevicesListMetricDefinition_564967, schemes: {Scheme.Https})
type
  Call_DevicesGetNetworkSettings_564977 = ref object of OpenApiRestCall_563565
proc url_DevicesGetNetworkSettings_564979(protocol: Scheme; host: string;
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

proc validate_DevicesGetNetworkSettings_564978(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the network settings of the specified device name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564980 = path.getOrDefault("subscriptionId")
  valid_564980 = validateParameter(valid_564980, JString, required = true,
                                 default = nil)
  if valid_564980 != nil:
    section.add "subscriptionId", valid_564980
  var valid_564981 = path.getOrDefault("deviceName")
  valid_564981 = validateParameter(valid_564981, JString, required = true,
                                 default = nil)
  if valid_564981 != nil:
    section.add "deviceName", valid_564981
  var valid_564982 = path.getOrDefault("resourceGroupName")
  valid_564982 = validateParameter(valid_564982, JString, required = true,
                                 default = nil)
  if valid_564982 != nil:
    section.add "resourceGroupName", valid_564982
  var valid_564983 = path.getOrDefault("managerName")
  valid_564983 = validateParameter(valid_564983, JString, required = true,
                                 default = nil)
  if valid_564983 != nil:
    section.add "managerName", valid_564983
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564984 = query.getOrDefault("api-version")
  valid_564984 = validateParameter(valid_564984, JString, required = true,
                                 default = nil)
  if valid_564984 != nil:
    section.add "api-version", valid_564984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564985: Call_DevicesGetNetworkSettings_564977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the network settings of the specified device name.
  ## 
  let valid = call_564985.validator(path, query, header, formData, body)
  let scheme = call_564985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564985.url(scheme.get, call_564985.host, call_564985.base,
                         call_564985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564985, url, valid)

proc call*(call_564986: Call_DevicesGetNetworkSettings_564977; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## devicesGetNetworkSettings
  ## Returns the network settings of the specified device name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564987 = newJObject()
  var query_564988 = newJObject()
  add(query_564988, "api-version", newJString(apiVersion))
  add(path_564987, "subscriptionId", newJString(subscriptionId))
  add(path_564987, "deviceName", newJString(deviceName))
  add(path_564987, "resourceGroupName", newJString(resourceGroupName))
  add(path_564987, "managerName", newJString(managerName))
  result = call_564986.call(path_564987, query_564988, nil, nil, nil)

var devicesGetNetworkSettings* = Call_DevicesGetNetworkSettings_564977(
    name: "devicesGetNetworkSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/networkSettings/default",
    validator: validate_DevicesGetNetworkSettings_564978, base: "",
    url: url_DevicesGetNetworkSettings_564979, schemes: {Scheme.Https})
type
  Call_DevicesScanForUpdates_564989 = ref object of OpenApiRestCall_563565
proc url_DevicesScanForUpdates_564991(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesScanForUpdates_564990(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Scans for updates on the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564992 = path.getOrDefault("subscriptionId")
  valid_564992 = validateParameter(valid_564992, JString, required = true,
                                 default = nil)
  if valid_564992 != nil:
    section.add "subscriptionId", valid_564992
  var valid_564993 = path.getOrDefault("deviceName")
  valid_564993 = validateParameter(valid_564993, JString, required = true,
                                 default = nil)
  if valid_564993 != nil:
    section.add "deviceName", valid_564993
  var valid_564994 = path.getOrDefault("resourceGroupName")
  valid_564994 = validateParameter(valid_564994, JString, required = true,
                                 default = nil)
  if valid_564994 != nil:
    section.add "resourceGroupName", valid_564994
  var valid_564995 = path.getOrDefault("managerName")
  valid_564995 = validateParameter(valid_564995, JString, required = true,
                                 default = nil)
  if valid_564995 != nil:
    section.add "managerName", valid_564995
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564996 = query.getOrDefault("api-version")
  valid_564996 = validateParameter(valid_564996, JString, required = true,
                                 default = nil)
  if valid_564996 != nil:
    section.add "api-version", valid_564996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564997: Call_DevicesScanForUpdates_564989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Scans for updates on the device.
  ## 
  let valid = call_564997.validator(path, query, header, formData, body)
  let scheme = call_564997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564997.url(scheme.get, call_564997.host, call_564997.base,
                         call_564997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564997, url, valid)

proc call*(call_564998: Call_DevicesScanForUpdates_564989; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## devicesScanForUpdates
  ## Scans for updates on the device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_564999 = newJObject()
  var query_565000 = newJObject()
  add(query_565000, "api-version", newJString(apiVersion))
  add(path_564999, "subscriptionId", newJString(subscriptionId))
  add(path_564999, "deviceName", newJString(deviceName))
  add(path_564999, "resourceGroupName", newJString(resourceGroupName))
  add(path_564999, "managerName", newJString(managerName))
  result = call_564998.call(path_564999, query_565000, nil, nil, nil)

var devicesScanForUpdates* = Call_DevicesScanForUpdates_564989(
    name: "devicesScanForUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/scanForUpdates",
    validator: validate_DevicesScanForUpdates_564990, base: "",
    url: url_DevicesScanForUpdates_564991, schemes: {Scheme.Https})
type
  Call_DevicesCreateOrUpdateSecuritySettings_565001 = ref object of OpenApiRestCall_563565
proc url_DevicesCreateOrUpdateSecuritySettings_565003(protocol: Scheme;
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
        value: "/securitySettings/default/update")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesCreateOrUpdateSecuritySettings_565002(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the security settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565004 = path.getOrDefault("subscriptionId")
  valid_565004 = validateParameter(valid_565004, JString, required = true,
                                 default = nil)
  if valid_565004 != nil:
    section.add "subscriptionId", valid_565004
  var valid_565005 = path.getOrDefault("deviceName")
  valid_565005 = validateParameter(valid_565005, JString, required = true,
                                 default = nil)
  if valid_565005 != nil:
    section.add "deviceName", valid_565005
  var valid_565006 = path.getOrDefault("resourceGroupName")
  valid_565006 = validateParameter(valid_565006, JString, required = true,
                                 default = nil)
  if valid_565006 != nil:
    section.add "resourceGroupName", valid_565006
  var valid_565007 = path.getOrDefault("managerName")
  valid_565007 = validateParameter(valid_565007, JString, required = true,
                                 default = nil)
  if valid_565007 != nil:
    section.add "managerName", valid_565007
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565008 = query.getOrDefault("api-version")
  valid_565008 = validateParameter(valid_565008, JString, required = true,
                                 default = nil)
  if valid_565008 != nil:
    section.add "api-version", valid_565008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   securitySettings: JObject (required)
  ##                   : The security settings.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565010: Call_DevicesCreateOrUpdateSecuritySettings_565001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the security settings.
  ## 
  let valid = call_565010.validator(path, query, header, formData, body)
  let scheme = call_565010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565010.url(scheme.get, call_565010.host, call_565010.base,
                         call_565010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565010, url, valid)

proc call*(call_565011: Call_DevicesCreateOrUpdateSecuritySettings_565001;
          securitySettings: JsonNode; apiVersion: string; subscriptionId: string;
          deviceName: string; resourceGroupName: string; managerName: string): Recallable =
  ## devicesCreateOrUpdateSecuritySettings
  ## Creates or updates the security settings.
  ##   securitySettings: JObject (required)
  ##                   : The security settings.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565012 = newJObject()
  var query_565013 = newJObject()
  var body_565014 = newJObject()
  if securitySettings != nil:
    body_565014 = securitySettings
  add(query_565013, "api-version", newJString(apiVersion))
  add(path_565012, "subscriptionId", newJString(subscriptionId))
  add(path_565012, "deviceName", newJString(deviceName))
  add(path_565012, "resourceGroupName", newJString(resourceGroupName))
  add(path_565012, "managerName", newJString(managerName))
  result = call_565011.call(path_565012, query_565013, nil, nil, body_565014)

var devicesCreateOrUpdateSecuritySettings* = Call_DevicesCreateOrUpdateSecuritySettings_565001(
    name: "devicesCreateOrUpdateSecuritySettings", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/securitySettings/default/update",
    validator: validate_DevicesCreateOrUpdateSecuritySettings_565002, base: "",
    url: url_DevicesCreateOrUpdateSecuritySettings_565003, schemes: {Scheme.Https})
type
  Call_AlertsSendTestEmail_565015 = ref object of OpenApiRestCall_563565
proc url_AlertsSendTestEmail_565017(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsSendTestEmail_565016(path: JsonNode; query: JsonNode;
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
  ##             : The device name.
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
  ## parameters in `body` object:
  ##   request: JObject (required)
  ##          : The send test alert email request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565024: Call_AlertsSendTestEmail_565015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a test alert email.
  ## 
  let valid = call_565024.validator(path, query, header, formData, body)
  let scheme = call_565024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565024.url(scheme.get, call_565024.host, call_565024.base,
                         call_565024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565024, url, valid)

proc call*(call_565025: Call_AlertsSendTestEmail_565015; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string; request: JsonNode): Recallable =
  ## alertsSendTestEmail
  ## Sends a test alert email.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   request: JObject (required)
  ##          : The send test alert email request.
  var path_565026 = newJObject()
  var query_565027 = newJObject()
  var body_565028 = newJObject()
  add(query_565027, "api-version", newJString(apiVersion))
  add(path_565026, "subscriptionId", newJString(subscriptionId))
  add(path_565026, "deviceName", newJString(deviceName))
  add(path_565026, "resourceGroupName", newJString(resourceGroupName))
  add(path_565026, "managerName", newJString(managerName))
  if request != nil:
    body_565028 = request
  result = call_565025.call(path_565026, query_565027, nil, nil, body_565028)

var alertsSendTestEmail* = Call_AlertsSendTestEmail_565015(
    name: "alertsSendTestEmail", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/sendTestAlertEmail",
    validator: validate_AlertsSendTestEmail_565016, base: "",
    url: url_AlertsSendTestEmail_565017, schemes: {Scheme.Https})
type
  Call_FileSharesListByDevice_565029 = ref object of OpenApiRestCall_563565
proc url_FileSharesListByDevice_565031(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/shares")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSharesListByDevice_565030(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the file shares in a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565032 = path.getOrDefault("subscriptionId")
  valid_565032 = validateParameter(valid_565032, JString, required = true,
                                 default = nil)
  if valid_565032 != nil:
    section.add "subscriptionId", valid_565032
  var valid_565033 = path.getOrDefault("deviceName")
  valid_565033 = validateParameter(valid_565033, JString, required = true,
                                 default = nil)
  if valid_565033 != nil:
    section.add "deviceName", valid_565033
  var valid_565034 = path.getOrDefault("resourceGroupName")
  valid_565034 = validateParameter(valid_565034, JString, required = true,
                                 default = nil)
  if valid_565034 != nil:
    section.add "resourceGroupName", valid_565034
  var valid_565035 = path.getOrDefault("managerName")
  valid_565035 = validateParameter(valid_565035, JString, required = true,
                                 default = nil)
  if valid_565035 != nil:
    section.add "managerName", valid_565035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565036 = query.getOrDefault("api-version")
  valid_565036 = validateParameter(valid_565036, JString, required = true,
                                 default = nil)
  if valid_565036 != nil:
    section.add "api-version", valid_565036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565037: Call_FileSharesListByDevice_565029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the file shares in a device.
  ## 
  let valid = call_565037.validator(path, query, header, formData, body)
  let scheme = call_565037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565037.url(scheme.get, call_565037.host, call_565037.base,
                         call_565037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565037, url, valid)

proc call*(call_565038: Call_FileSharesListByDevice_565029; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## fileSharesListByDevice
  ## Retrieves all the file shares in a device.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565039 = newJObject()
  var query_565040 = newJObject()
  add(query_565040, "api-version", newJString(apiVersion))
  add(path_565039, "subscriptionId", newJString(subscriptionId))
  add(path_565039, "deviceName", newJString(deviceName))
  add(path_565039, "resourceGroupName", newJString(resourceGroupName))
  add(path_565039, "managerName", newJString(managerName))
  result = call_565038.call(path_565039, query_565040, nil, nil, nil)

var fileSharesListByDevice* = Call_FileSharesListByDevice_565029(
    name: "fileSharesListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/shares",
    validator: validate_FileSharesListByDevice_565030, base: "",
    url: url_FileSharesListByDevice_565031, schemes: {Scheme.Https})
type
  Call_DevicesGetTimeSettings_565041 = ref object of OpenApiRestCall_563565
proc url_DevicesGetTimeSettings_565043(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/timeSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesGetTimeSettings_565042(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the time settings of the specified device name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565044 = path.getOrDefault("subscriptionId")
  valid_565044 = validateParameter(valid_565044, JString, required = true,
                                 default = nil)
  if valid_565044 != nil:
    section.add "subscriptionId", valid_565044
  var valid_565045 = path.getOrDefault("deviceName")
  valid_565045 = validateParameter(valid_565045, JString, required = true,
                                 default = nil)
  if valid_565045 != nil:
    section.add "deviceName", valid_565045
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
  if body != nil:
    result.add "body", body

proc call*(call_565049: Call_DevicesGetTimeSettings_565041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the time settings of the specified device name.
  ## 
  let valid = call_565049.validator(path, query, header, formData, body)
  let scheme = call_565049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565049.url(scheme.get, call_565049.host, call_565049.base,
                         call_565049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565049, url, valid)

proc call*(call_565050: Call_DevicesGetTimeSettings_565041; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## devicesGetTimeSettings
  ## Returns the time settings of the specified device name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565051 = newJObject()
  var query_565052 = newJObject()
  add(query_565052, "api-version", newJString(apiVersion))
  add(path_565051, "subscriptionId", newJString(subscriptionId))
  add(path_565051, "deviceName", newJString(deviceName))
  add(path_565051, "resourceGroupName", newJString(resourceGroupName))
  add(path_565051, "managerName", newJString(managerName))
  result = call_565050.call(path_565051, query_565052, nil, nil, nil)

var devicesGetTimeSettings* = Call_DevicesGetTimeSettings_565041(
    name: "devicesGetTimeSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/timeSettings/default",
    validator: validate_DevicesGetTimeSettings_565042, base: "",
    url: url_DevicesGetTimeSettings_565043, schemes: {Scheme.Https})
type
  Call_DevicesGetUpdateSummary_565053 = ref object of OpenApiRestCall_563565
proc url_DevicesGetUpdateSummary_565055(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesGetUpdateSummary_565054(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the update summary of the specified device name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565056 = path.getOrDefault("subscriptionId")
  valid_565056 = validateParameter(valid_565056, JString, required = true,
                                 default = nil)
  if valid_565056 != nil:
    section.add "subscriptionId", valid_565056
  var valid_565057 = path.getOrDefault("deviceName")
  valid_565057 = validateParameter(valid_565057, JString, required = true,
                                 default = nil)
  if valid_565057 != nil:
    section.add "deviceName", valid_565057
  var valid_565058 = path.getOrDefault("resourceGroupName")
  valid_565058 = validateParameter(valid_565058, JString, required = true,
                                 default = nil)
  if valid_565058 != nil:
    section.add "resourceGroupName", valid_565058
  var valid_565059 = path.getOrDefault("managerName")
  valid_565059 = validateParameter(valid_565059, JString, required = true,
                                 default = nil)
  if valid_565059 != nil:
    section.add "managerName", valid_565059
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565060 = query.getOrDefault("api-version")
  valid_565060 = validateParameter(valid_565060, JString, required = true,
                                 default = nil)
  if valid_565060 != nil:
    section.add "api-version", valid_565060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565061: Call_DevicesGetUpdateSummary_565053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the update summary of the specified device name.
  ## 
  let valid = call_565061.validator(path, query, header, formData, body)
  let scheme = call_565061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565061.url(scheme.get, call_565061.host, call_565061.base,
                         call_565061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565061, url, valid)

proc call*(call_565062: Call_DevicesGetUpdateSummary_565053; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## devicesGetUpdateSummary
  ## Returns the update summary of the specified device name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565063 = newJObject()
  var query_565064 = newJObject()
  add(query_565064, "api-version", newJString(apiVersion))
  add(path_565063, "subscriptionId", newJString(subscriptionId))
  add(path_565063, "deviceName", newJString(deviceName))
  add(path_565063, "resourceGroupName", newJString(resourceGroupName))
  add(path_565063, "managerName", newJString(managerName))
  result = call_565062.call(path_565063, query_565064, nil, nil, nil)

var devicesGetUpdateSummary* = Call_DevicesGetUpdateSummary_565053(
    name: "devicesGetUpdateSummary", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/updateSummary/default",
    validator: validate_DevicesGetUpdateSummary_565054, base: "",
    url: url_DevicesGetUpdateSummary_565055, schemes: {Scheme.Https})
type
  Call_ManagersGetEncryptionSettings_565065 = ref object of OpenApiRestCall_563565
proc url_ManagersGetEncryptionSettings_565067(protocol: Scheme; host: string;
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

proc validate_ManagersGetEncryptionSettings_565066(path: JsonNode; query: JsonNode;
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
  var valid_565068 = path.getOrDefault("subscriptionId")
  valid_565068 = validateParameter(valid_565068, JString, required = true,
                                 default = nil)
  if valid_565068 != nil:
    section.add "subscriptionId", valid_565068
  var valid_565069 = path.getOrDefault("resourceGroupName")
  valid_565069 = validateParameter(valid_565069, JString, required = true,
                                 default = nil)
  if valid_565069 != nil:
    section.add "resourceGroupName", valid_565069
  var valid_565070 = path.getOrDefault("managerName")
  valid_565070 = validateParameter(valid_565070, JString, required = true,
                                 default = nil)
  if valid_565070 != nil:
    section.add "managerName", valid_565070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565071 = query.getOrDefault("api-version")
  valid_565071 = validateParameter(valid_565071, JString, required = true,
                                 default = nil)
  if valid_565071 != nil:
    section.add "api-version", valid_565071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565072: Call_ManagersGetEncryptionSettings_565065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the encryption settings of the manager.
  ## 
  let valid = call_565072.validator(path, query, header, formData, body)
  let scheme = call_565072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565072.url(scheme.get, call_565072.host, call_565072.base,
                         call_565072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565072, url, valid)

proc call*(call_565073: Call_ManagersGetEncryptionSettings_565065;
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
  var path_565074 = newJObject()
  var query_565075 = newJObject()
  add(query_565075, "api-version", newJString(apiVersion))
  add(path_565074, "subscriptionId", newJString(subscriptionId))
  add(path_565074, "resourceGroupName", newJString(resourceGroupName))
  add(path_565074, "managerName", newJString(managerName))
  result = call_565073.call(path_565074, query_565075, nil, nil, nil)

var managersGetEncryptionSettings* = Call_ManagersGetEncryptionSettings_565065(
    name: "managersGetEncryptionSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/encryptionSettings/default",
    validator: validate_ManagersGetEncryptionSettings_565066, base: "",
    url: url_ManagersGetEncryptionSettings_565067, schemes: {Scheme.Https})
type
  Call_ManagersCreateExtendedInfo_565087 = ref object of OpenApiRestCall_563565
proc url_ManagersCreateExtendedInfo_565089(protocol: Scheme; host: string;
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

proc validate_ManagersCreateExtendedInfo_565088(path: JsonNode; query: JsonNode;
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
  var valid_565090 = path.getOrDefault("subscriptionId")
  valid_565090 = validateParameter(valid_565090, JString, required = true,
                                 default = nil)
  if valid_565090 != nil:
    section.add "subscriptionId", valid_565090
  var valid_565091 = path.getOrDefault("resourceGroupName")
  valid_565091 = validateParameter(valid_565091, JString, required = true,
                                 default = nil)
  if valid_565091 != nil:
    section.add "resourceGroupName", valid_565091
  var valid_565092 = path.getOrDefault("managerName")
  valid_565092 = validateParameter(valid_565092, JString, required = true,
                                 default = nil)
  if valid_565092 != nil:
    section.add "managerName", valid_565092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565093 = query.getOrDefault("api-version")
  valid_565093 = validateParameter(valid_565093, JString, required = true,
                                 default = nil)
  if valid_565093 != nil:
    section.add "api-version", valid_565093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ManagerExtendedInfo: JObject (required)
  ##                      : The manager extended information.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565095: Call_ManagersCreateExtendedInfo_565087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the extended info of the manager.
  ## 
  let valid = call_565095.validator(path, query, header, formData, body)
  let scheme = call_565095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565095.url(scheme.get, call_565095.host, call_565095.base,
                         call_565095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565095, url, valid)

proc call*(call_565096: Call_ManagersCreateExtendedInfo_565087; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string;
          ManagerExtendedInfo: JsonNode): Recallable =
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
  ##   ManagerExtendedInfo: JObject (required)
  ##                      : The manager extended information.
  var path_565097 = newJObject()
  var query_565098 = newJObject()
  var body_565099 = newJObject()
  add(query_565098, "api-version", newJString(apiVersion))
  add(path_565097, "subscriptionId", newJString(subscriptionId))
  add(path_565097, "resourceGroupName", newJString(resourceGroupName))
  add(path_565097, "managerName", newJString(managerName))
  if ManagerExtendedInfo != nil:
    body_565099 = ManagerExtendedInfo
  result = call_565096.call(path_565097, query_565098, nil, nil, body_565099)

var managersCreateExtendedInfo* = Call_ManagersCreateExtendedInfo_565087(
    name: "managersCreateExtendedInfo", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersCreateExtendedInfo_565088, base: "",
    url: url_ManagersCreateExtendedInfo_565089, schemes: {Scheme.Https})
type
  Call_ManagersGetExtendedInfo_565076 = ref object of OpenApiRestCall_563565
proc url_ManagersGetExtendedInfo_565078(protocol: Scheme; host: string; base: string;
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

proc validate_ManagersGetExtendedInfo_565077(path: JsonNode; query: JsonNode;
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
  var valid_565079 = path.getOrDefault("subscriptionId")
  valid_565079 = validateParameter(valid_565079, JString, required = true,
                                 default = nil)
  if valid_565079 != nil:
    section.add "subscriptionId", valid_565079
  var valid_565080 = path.getOrDefault("resourceGroupName")
  valid_565080 = validateParameter(valid_565080, JString, required = true,
                                 default = nil)
  if valid_565080 != nil:
    section.add "resourceGroupName", valid_565080
  var valid_565081 = path.getOrDefault("managerName")
  valid_565081 = validateParameter(valid_565081, JString, required = true,
                                 default = nil)
  if valid_565081 != nil:
    section.add "managerName", valid_565081
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565082 = query.getOrDefault("api-version")
  valid_565082 = validateParameter(valid_565082, JString, required = true,
                                 default = nil)
  if valid_565082 != nil:
    section.add "api-version", valid_565082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565083: Call_ManagersGetExtendedInfo_565076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the extended information of the specified manager name.
  ## 
  let valid = call_565083.validator(path, query, header, formData, body)
  let scheme = call_565083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565083.url(scheme.get, call_565083.host, call_565083.base,
                         call_565083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565083, url, valid)

proc call*(call_565084: Call_ManagersGetExtendedInfo_565076; apiVersion: string;
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
  var path_565085 = newJObject()
  var query_565086 = newJObject()
  add(query_565086, "api-version", newJString(apiVersion))
  add(path_565085, "subscriptionId", newJString(subscriptionId))
  add(path_565085, "resourceGroupName", newJString(resourceGroupName))
  add(path_565085, "managerName", newJString(managerName))
  result = call_565084.call(path_565085, query_565086, nil, nil, nil)

var managersGetExtendedInfo* = Call_ManagersGetExtendedInfo_565076(
    name: "managersGetExtendedInfo", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersGetExtendedInfo_565077, base: "",
    url: url_ManagersGetExtendedInfo_565078, schemes: {Scheme.Https})
type
  Call_ManagersUpdateExtendedInfo_565111 = ref object of OpenApiRestCall_563565
proc url_ManagersUpdateExtendedInfo_565113(protocol: Scheme; host: string;
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

proc validate_ManagersUpdateExtendedInfo_565112(path: JsonNode; query: JsonNode;
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
  var valid_565114 = path.getOrDefault("subscriptionId")
  valid_565114 = validateParameter(valid_565114, JString, required = true,
                                 default = nil)
  if valid_565114 != nil:
    section.add "subscriptionId", valid_565114
  var valid_565115 = path.getOrDefault("resourceGroupName")
  valid_565115 = validateParameter(valid_565115, JString, required = true,
                                 default = nil)
  if valid_565115 != nil:
    section.add "resourceGroupName", valid_565115
  var valid_565116 = path.getOrDefault("managerName")
  valid_565116 = validateParameter(valid_565116, JString, required = true,
                                 default = nil)
  if valid_565116 != nil:
    section.add "managerName", valid_565116
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565117 = query.getOrDefault("api-version")
  valid_565117 = validateParameter(valid_565117, JString, required = true,
                                 default = nil)
  if valid_565117 != nil:
    section.add "api-version", valid_565117
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : Pass the ETag of ExtendedInfo fetched from GET call
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_565118 = header.getOrDefault("If-Match")
  valid_565118 = validateParameter(valid_565118, JString, required = true,
                                 default = nil)
  if valid_565118 != nil:
    section.add "If-Match", valid_565118
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ManagerExtendedInfo: JObject (required)
  ##                      : The manager extended information.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565120: Call_ManagersUpdateExtendedInfo_565111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the extended info of the manager.
  ## 
  let valid = call_565120.validator(path, query, header, formData, body)
  let scheme = call_565120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565120.url(scheme.get, call_565120.host, call_565120.base,
                         call_565120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565120, url, valid)

proc call*(call_565121: Call_ManagersUpdateExtendedInfo_565111; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string;
          ManagerExtendedInfo: JsonNode): Recallable =
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
  ##   ManagerExtendedInfo: JObject (required)
  ##                      : The manager extended information.
  var path_565122 = newJObject()
  var query_565123 = newJObject()
  var body_565124 = newJObject()
  add(query_565123, "api-version", newJString(apiVersion))
  add(path_565122, "subscriptionId", newJString(subscriptionId))
  add(path_565122, "resourceGroupName", newJString(resourceGroupName))
  add(path_565122, "managerName", newJString(managerName))
  if ManagerExtendedInfo != nil:
    body_565124 = ManagerExtendedInfo
  result = call_565121.call(path_565122, query_565123, nil, nil, body_565124)

var managersUpdateExtendedInfo* = Call_ManagersUpdateExtendedInfo_565111(
    name: "managersUpdateExtendedInfo", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersUpdateExtendedInfo_565112, base: "",
    url: url_ManagersUpdateExtendedInfo_565113, schemes: {Scheme.Https})
type
  Call_ManagersDeleteExtendedInfo_565100 = ref object of OpenApiRestCall_563565
proc url_ManagersDeleteExtendedInfo_565102(protocol: Scheme; host: string;
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

proc validate_ManagersDeleteExtendedInfo_565101(path: JsonNode; query: JsonNode;
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
  var valid_565103 = path.getOrDefault("subscriptionId")
  valid_565103 = validateParameter(valid_565103, JString, required = true,
                                 default = nil)
  if valid_565103 != nil:
    section.add "subscriptionId", valid_565103
  var valid_565104 = path.getOrDefault("resourceGroupName")
  valid_565104 = validateParameter(valid_565104, JString, required = true,
                                 default = nil)
  if valid_565104 != nil:
    section.add "resourceGroupName", valid_565104
  var valid_565105 = path.getOrDefault("managerName")
  valid_565105 = validateParameter(valid_565105, JString, required = true,
                                 default = nil)
  if valid_565105 != nil:
    section.add "managerName", valid_565105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565106 = query.getOrDefault("api-version")
  valid_565106 = validateParameter(valid_565106, JString, required = true,
                                 default = nil)
  if valid_565106 != nil:
    section.add "api-version", valid_565106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565107: Call_ManagersDeleteExtendedInfo_565100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the extended info of the manager.
  ## 
  let valid = call_565107.validator(path, query, header, formData, body)
  let scheme = call_565107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565107.url(scheme.get, call_565107.host, call_565107.base,
                         call_565107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565107, url, valid)

proc call*(call_565108: Call_ManagersDeleteExtendedInfo_565100; apiVersion: string;
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
  var path_565109 = newJObject()
  var query_565110 = newJObject()
  add(query_565110, "api-version", newJString(apiVersion))
  add(path_565109, "subscriptionId", newJString(subscriptionId))
  add(path_565109, "resourceGroupName", newJString(resourceGroupName))
  add(path_565109, "managerName", newJString(managerName))
  result = call_565108.call(path_565109, query_565110, nil, nil, nil)

var managersDeleteExtendedInfo* = Call_ManagersDeleteExtendedInfo_565100(
    name: "managersDeleteExtendedInfo", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersDeleteExtendedInfo_565101, base: "",
    url: url_ManagersDeleteExtendedInfo_565102, schemes: {Scheme.Https})
type
  Call_FileServersListByManager_565125 = ref object of OpenApiRestCall_563565
proc url_FileServersListByManager_565127(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/fileservers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersListByManager_565126(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the file servers in a manager.
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
  var valid_565128 = path.getOrDefault("subscriptionId")
  valid_565128 = validateParameter(valid_565128, JString, required = true,
                                 default = nil)
  if valid_565128 != nil:
    section.add "subscriptionId", valid_565128
  var valid_565129 = path.getOrDefault("resourceGroupName")
  valid_565129 = validateParameter(valid_565129, JString, required = true,
                                 default = nil)
  if valid_565129 != nil:
    section.add "resourceGroupName", valid_565129
  var valid_565130 = path.getOrDefault("managerName")
  valid_565130 = validateParameter(valid_565130, JString, required = true,
                                 default = nil)
  if valid_565130 != nil:
    section.add "managerName", valid_565130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565131 = query.getOrDefault("api-version")
  valid_565131 = validateParameter(valid_565131, JString, required = true,
                                 default = nil)
  if valid_565131 != nil:
    section.add "api-version", valid_565131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565132: Call_FileServersListByManager_565125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the file servers in a manager.
  ## 
  let valid = call_565132.validator(path, query, header, formData, body)
  let scheme = call_565132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565132.url(scheme.get, call_565132.host, call_565132.base,
                         call_565132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565132, url, valid)

proc call*(call_565133: Call_FileServersListByManager_565125; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string): Recallable =
  ## fileServersListByManager
  ## Retrieves all the file servers in a manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565134 = newJObject()
  var query_565135 = newJObject()
  add(query_565135, "api-version", newJString(apiVersion))
  add(path_565134, "subscriptionId", newJString(subscriptionId))
  add(path_565134, "resourceGroupName", newJString(resourceGroupName))
  add(path_565134, "managerName", newJString(managerName))
  result = call_565133.call(path_565134, query_565135, nil, nil, nil)

var fileServersListByManager* = Call_FileServersListByManager_565125(
    name: "fileServersListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/fileservers",
    validator: validate_FileServersListByManager_565126, base: "",
    url: url_FileServersListByManager_565127, schemes: {Scheme.Https})
type
  Call_ManagersGetEncryptionKey_565136 = ref object of OpenApiRestCall_563565
proc url_ManagersGetEncryptionKey_565138(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/getEncryptionKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersGetEncryptionKey_565137(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the symmetric encryption key of the manager.
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
  var valid_565139 = path.getOrDefault("subscriptionId")
  valid_565139 = validateParameter(valid_565139, JString, required = true,
                                 default = nil)
  if valid_565139 != nil:
    section.add "subscriptionId", valid_565139
  var valid_565140 = path.getOrDefault("resourceGroupName")
  valid_565140 = validateParameter(valid_565140, JString, required = true,
                                 default = nil)
  if valid_565140 != nil:
    section.add "resourceGroupName", valid_565140
  var valid_565141 = path.getOrDefault("managerName")
  valid_565141 = validateParameter(valid_565141, JString, required = true,
                                 default = nil)
  if valid_565141 != nil:
    section.add "managerName", valid_565141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565142 = query.getOrDefault("api-version")
  valid_565142 = validateParameter(valid_565142, JString, required = true,
                                 default = nil)
  if valid_565142 != nil:
    section.add "api-version", valid_565142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565143: Call_ManagersGetEncryptionKey_565136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the symmetric encryption key of the manager.
  ## 
  let valid = call_565143.validator(path, query, header, formData, body)
  let scheme = call_565143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565143.url(scheme.get, call_565143.host, call_565143.base,
                         call_565143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565143, url, valid)

proc call*(call_565144: Call_ManagersGetEncryptionKey_565136; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string): Recallable =
  ## managersGetEncryptionKey
  ## Returns the symmetric encryption key of the manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565145 = newJObject()
  var query_565146 = newJObject()
  add(query_565146, "api-version", newJString(apiVersion))
  add(path_565145, "subscriptionId", newJString(subscriptionId))
  add(path_565145, "resourceGroupName", newJString(resourceGroupName))
  add(path_565145, "managerName", newJString(managerName))
  result = call_565144.call(path_565145, query_565146, nil, nil, nil)

var managersGetEncryptionKey* = Call_ManagersGetEncryptionKey_565136(
    name: "managersGetEncryptionKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/getEncryptionKey",
    validator: validate_ManagersGetEncryptionKey_565137, base: "",
    url: url_ManagersGetEncryptionKey_565138, schemes: {Scheme.Https})
type
  Call_IscsiServersListByManager_565147 = ref object of OpenApiRestCall_563565
proc url_IscsiServersListByManager_565149(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/iscsiservers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiServersListByManager_565148(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the iSCSI servers in a manager.
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
  var valid_565150 = path.getOrDefault("subscriptionId")
  valid_565150 = validateParameter(valid_565150, JString, required = true,
                                 default = nil)
  if valid_565150 != nil:
    section.add "subscriptionId", valid_565150
  var valid_565151 = path.getOrDefault("resourceGroupName")
  valid_565151 = validateParameter(valid_565151, JString, required = true,
                                 default = nil)
  if valid_565151 != nil:
    section.add "resourceGroupName", valid_565151
  var valid_565152 = path.getOrDefault("managerName")
  valid_565152 = validateParameter(valid_565152, JString, required = true,
                                 default = nil)
  if valid_565152 != nil:
    section.add "managerName", valid_565152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565153 = query.getOrDefault("api-version")
  valid_565153 = validateParameter(valid_565153, JString, required = true,
                                 default = nil)
  if valid_565153 != nil:
    section.add "api-version", valid_565153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565154: Call_IscsiServersListByManager_565147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the iSCSI servers in a manager.
  ## 
  let valid = call_565154.validator(path, query, header, formData, body)
  let scheme = call_565154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565154.url(scheme.get, call_565154.host, call_565154.base,
                         call_565154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565154, url, valid)

proc call*(call_565155: Call_IscsiServersListByManager_565147; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string): Recallable =
  ## iscsiServersListByManager
  ## Retrieves all the iSCSI servers in a manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565156 = newJObject()
  var query_565157 = newJObject()
  add(query_565157, "api-version", newJString(apiVersion))
  add(path_565156, "subscriptionId", newJString(subscriptionId))
  add(path_565156, "resourceGroupName", newJString(resourceGroupName))
  add(path_565156, "managerName", newJString(managerName))
  result = call_565155.call(path_565156, query_565157, nil, nil, nil)

var iscsiServersListByManager* = Call_IscsiServersListByManager_565147(
    name: "iscsiServersListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/iscsiservers",
    validator: validate_IscsiServersListByManager_565148, base: "",
    url: url_IscsiServersListByManager_565149, schemes: {Scheme.Https})
type
  Call_JobsListByManager_565158 = ref object of OpenApiRestCall_563565
proc url_JobsListByManager_565160(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByManager_565159(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves all the jobs in a manager.
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
  var valid_565161 = path.getOrDefault("subscriptionId")
  valid_565161 = validateParameter(valid_565161, JString, required = true,
                                 default = nil)
  if valid_565161 != nil:
    section.add "subscriptionId", valid_565161
  var valid_565162 = path.getOrDefault("resourceGroupName")
  valid_565162 = validateParameter(valid_565162, JString, required = true,
                                 default = nil)
  if valid_565162 != nil:
    section.add "resourceGroupName", valid_565162
  var valid_565163 = path.getOrDefault("managerName")
  valid_565163 = validateParameter(valid_565163, JString, required = true,
                                 default = nil)
  if valid_565163 != nil:
    section.add "managerName", valid_565163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565164 = query.getOrDefault("api-version")
  valid_565164 = validateParameter(valid_565164, JString, required = true,
                                 default = nil)
  if valid_565164 != nil:
    section.add "api-version", valid_565164
  var valid_565165 = query.getOrDefault("$filter")
  valid_565165 = validateParameter(valid_565165, JString, required = false,
                                 default = nil)
  if valid_565165 != nil:
    section.add "$filter", valid_565165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565166: Call_JobsListByManager_565158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the jobs in a manager.
  ## 
  let valid = call_565166.validator(path, query, header, formData, body)
  let scheme = call_565166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565166.url(scheme.get, call_565166.host, call_565166.base,
                         call_565166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565166, url, valid)

proc call*(call_565167: Call_JobsListByManager_565158; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string;
          Filter: string = ""): Recallable =
  ## jobsListByManager
  ## Retrieves all the jobs in a manager.
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
  var path_565168 = newJObject()
  var query_565169 = newJObject()
  add(query_565169, "api-version", newJString(apiVersion))
  add(path_565168, "subscriptionId", newJString(subscriptionId))
  add(path_565168, "resourceGroupName", newJString(resourceGroupName))
  add(path_565168, "managerName", newJString(managerName))
  add(query_565169, "$filter", newJString(Filter))
  result = call_565167.call(path_565168, query_565169, nil, nil, nil)

var jobsListByManager* = Call_JobsListByManager_565158(name: "jobsListByManager",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/jobs",
    validator: validate_JobsListByManager_565159, base: "",
    url: url_JobsListByManager_565160, schemes: {Scheme.Https})
type
  Call_ManagersListMetrics_565170 = ref object of OpenApiRestCall_563565
proc url_ManagersListMetrics_565172(protocol: Scheme; host: string; base: string;
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

proc validate_ManagersListMetrics_565171(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the  manager metrics
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
  var valid_565173 = path.getOrDefault("subscriptionId")
  valid_565173 = validateParameter(valid_565173, JString, required = true,
                                 default = nil)
  if valid_565173 != nil:
    section.add "subscriptionId", valid_565173
  var valid_565174 = path.getOrDefault("resourceGroupName")
  valid_565174 = validateParameter(valid_565174, JString, required = true,
                                 default = nil)
  if valid_565174 != nil:
    section.add "resourceGroupName", valid_565174
  var valid_565175 = path.getOrDefault("managerName")
  valid_565175 = validateParameter(valid_565175, JString, required = true,
                                 default = nil)
  if valid_565175 != nil:
    section.add "managerName", valid_565175
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565176 = query.getOrDefault("api-version")
  valid_565176 = validateParameter(valid_565176, JString, required = true,
                                 default = nil)
  if valid_565176 != nil:
    section.add "api-version", valid_565176
  var valid_565177 = query.getOrDefault("$filter")
  valid_565177 = validateParameter(valid_565177, JString, required = false,
                                 default = nil)
  if valid_565177 != nil:
    section.add "$filter", valid_565177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565178: Call_ManagersListMetrics_565170; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the  manager metrics
  ## 
  let valid = call_565178.validator(path, query, header, formData, body)
  let scheme = call_565178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565178.url(scheme.get, call_565178.host, call_565178.base,
                         call_565178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565178, url, valid)

proc call*(call_565179: Call_ManagersListMetrics_565170; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string;
          Filter: string = ""): Recallable =
  ## managersListMetrics
  ## Gets the  manager metrics
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
  var path_565180 = newJObject()
  var query_565181 = newJObject()
  add(query_565181, "api-version", newJString(apiVersion))
  add(path_565180, "subscriptionId", newJString(subscriptionId))
  add(path_565180, "resourceGroupName", newJString(resourceGroupName))
  add(path_565180, "managerName", newJString(managerName))
  add(query_565181, "$filter", newJString(Filter))
  result = call_565179.call(path_565180, query_565181, nil, nil, nil)

var managersListMetrics* = Call_ManagersListMetrics_565170(
    name: "managersListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/metrics",
    validator: validate_ManagersListMetrics_565171, base: "",
    url: url_ManagersListMetrics_565172, schemes: {Scheme.Https})
type
  Call_ManagersListMetricDefinition_565182 = ref object of OpenApiRestCall_563565
proc url_ManagersListMetricDefinition_565184(protocol: Scheme; host: string;
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

proc validate_ManagersListMetricDefinition_565183(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves metric definition of all metrics aggregated at manager.
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
  var valid_565185 = path.getOrDefault("subscriptionId")
  valid_565185 = validateParameter(valid_565185, JString, required = true,
                                 default = nil)
  if valid_565185 != nil:
    section.add "subscriptionId", valid_565185
  var valid_565186 = path.getOrDefault("resourceGroupName")
  valid_565186 = validateParameter(valid_565186, JString, required = true,
                                 default = nil)
  if valid_565186 != nil:
    section.add "resourceGroupName", valid_565186
  var valid_565187 = path.getOrDefault("managerName")
  valid_565187 = validateParameter(valid_565187, JString, required = true,
                                 default = nil)
  if valid_565187 != nil:
    section.add "managerName", valid_565187
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565188 = query.getOrDefault("api-version")
  valid_565188 = validateParameter(valid_565188, JString, required = true,
                                 default = nil)
  if valid_565188 != nil:
    section.add "api-version", valid_565188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565189: Call_ManagersListMetricDefinition_565182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metric definition of all metrics aggregated at manager.
  ## 
  let valid = call_565189.validator(path, query, header, formData, body)
  let scheme = call_565189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565189.url(scheme.get, call_565189.host, call_565189.base,
                         call_565189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565189, url, valid)

proc call*(call_565190: Call_ManagersListMetricDefinition_565182;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## managersListMetricDefinition
  ## Retrieves metric definition of all metrics aggregated at manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565191 = newJObject()
  var query_565192 = newJObject()
  add(query_565192, "api-version", newJString(apiVersion))
  add(path_565191, "subscriptionId", newJString(subscriptionId))
  add(path_565191, "resourceGroupName", newJString(resourceGroupName))
  add(path_565191, "managerName", newJString(managerName))
  result = call_565190.call(path_565191, query_565192, nil, nil, nil)

var managersListMetricDefinition* = Call_ManagersListMetricDefinition_565182(
    name: "managersListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/metricsDefinitions",
    validator: validate_ManagersListMetricDefinition_565183, base: "",
    url: url_ManagersListMetricDefinition_565184, schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsListByManager_565193 = ref object of OpenApiRestCall_563565
proc url_StorageAccountCredentialsListByManager_565195(protocol: Scheme;
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

proc validate_StorageAccountCredentialsListByManager_565194(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the storage account credentials in a manager.
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
  var valid_565196 = path.getOrDefault("subscriptionId")
  valid_565196 = validateParameter(valid_565196, JString, required = true,
                                 default = nil)
  if valid_565196 != nil:
    section.add "subscriptionId", valid_565196
  var valid_565197 = path.getOrDefault("resourceGroupName")
  valid_565197 = validateParameter(valid_565197, JString, required = true,
                                 default = nil)
  if valid_565197 != nil:
    section.add "resourceGroupName", valid_565197
  var valid_565198 = path.getOrDefault("managerName")
  valid_565198 = validateParameter(valid_565198, JString, required = true,
                                 default = nil)
  if valid_565198 != nil:
    section.add "managerName", valid_565198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565199 = query.getOrDefault("api-version")
  valid_565199 = validateParameter(valid_565199, JString, required = true,
                                 default = nil)
  if valid_565199 != nil:
    section.add "api-version", valid_565199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565200: Call_StorageAccountCredentialsListByManager_565193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all the storage account credentials in a manager.
  ## 
  let valid = call_565200.validator(path, query, header, formData, body)
  let scheme = call_565200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565200.url(scheme.get, call_565200.host, call_565200.base,
                         call_565200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565200, url, valid)

proc call*(call_565201: Call_StorageAccountCredentialsListByManager_565193;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## storageAccountCredentialsListByManager
  ## Retrieves all the storage account credentials in a manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565202 = newJObject()
  var query_565203 = newJObject()
  add(query_565203, "api-version", newJString(apiVersion))
  add(path_565202, "subscriptionId", newJString(subscriptionId))
  add(path_565202, "resourceGroupName", newJString(resourceGroupName))
  add(path_565202, "managerName", newJString(managerName))
  result = call_565201.call(path_565202, query_565203, nil, nil, nil)

var storageAccountCredentialsListByManager* = Call_StorageAccountCredentialsListByManager_565193(
    name: "storageAccountCredentialsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials",
    validator: validate_StorageAccountCredentialsListByManager_565194, base: "",
    url: url_StorageAccountCredentialsListByManager_565195,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsCreateOrUpdate_565216 = ref object of OpenApiRestCall_563565
proc url_StorageAccountCredentialsCreateOrUpdate_565218(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "credentialName" in path, "`credentialName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/storageAccountCredentials/"),
               (kind: VariableSegment, value: "credentialName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountCredentialsCreateOrUpdate_565217(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the storage account credential
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   credentialName: JString (required)
  ##                 : The credential name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565219 = path.getOrDefault("subscriptionId")
  valid_565219 = validateParameter(valid_565219, JString, required = true,
                                 default = nil)
  if valid_565219 != nil:
    section.add "subscriptionId", valid_565219
  var valid_565220 = path.getOrDefault("credentialName")
  valid_565220 = validateParameter(valid_565220, JString, required = true,
                                 default = nil)
  if valid_565220 != nil:
    section.add "credentialName", valid_565220
  var valid_565221 = path.getOrDefault("resourceGroupName")
  valid_565221 = validateParameter(valid_565221, JString, required = true,
                                 default = nil)
  if valid_565221 != nil:
    section.add "resourceGroupName", valid_565221
  var valid_565222 = path.getOrDefault("managerName")
  valid_565222 = validateParameter(valid_565222, JString, required = true,
                                 default = nil)
  if valid_565222 != nil:
    section.add "managerName", valid_565222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565223 = query.getOrDefault("api-version")
  valid_565223 = validateParameter(valid_565223, JString, required = true,
                                 default = nil)
  if valid_565223 != nil:
    section.add "api-version", valid_565223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   storageAccount: JObject (required)
  ##                 : The storage account credential to be added or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565225: Call_StorageAccountCredentialsCreateOrUpdate_565216;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the storage account credential
  ## 
  let valid = call_565225.validator(path, query, header, formData, body)
  let scheme = call_565225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565225.url(scheme.get, call_565225.host, call_565225.base,
                         call_565225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565225, url, valid)

proc call*(call_565226: Call_StorageAccountCredentialsCreateOrUpdate_565216;
          apiVersion: string; subscriptionId: string; credentialName: string;
          resourceGroupName: string; managerName: string; storageAccount: JsonNode): Recallable =
  ## storageAccountCredentialsCreateOrUpdate
  ## Creates or updates the storage account credential
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   credentialName: string (required)
  ##                 : The credential name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   storageAccount: JObject (required)
  ##                 : The storage account credential to be added or updated.
  var path_565227 = newJObject()
  var query_565228 = newJObject()
  var body_565229 = newJObject()
  add(query_565228, "api-version", newJString(apiVersion))
  add(path_565227, "subscriptionId", newJString(subscriptionId))
  add(path_565227, "credentialName", newJString(credentialName))
  add(path_565227, "resourceGroupName", newJString(resourceGroupName))
  add(path_565227, "managerName", newJString(managerName))
  if storageAccount != nil:
    body_565229 = storageAccount
  result = call_565226.call(path_565227, query_565228, nil, nil, body_565229)

var storageAccountCredentialsCreateOrUpdate* = Call_StorageAccountCredentialsCreateOrUpdate_565216(
    name: "storageAccountCredentialsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials/{credentialName}",
    validator: validate_StorageAccountCredentialsCreateOrUpdate_565217, base: "",
    url: url_StorageAccountCredentialsCreateOrUpdate_565218,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsGet_565204 = ref object of OpenApiRestCall_563565
proc url_StorageAccountCredentialsGet_565206(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "credentialName" in path, "`credentialName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/storageAccountCredentials/"),
               (kind: VariableSegment, value: "credentialName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountCredentialsGet_565205(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified storage account credential name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   credentialName: JString (required)
  ##                 : The name of storage account credential to be fetched.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565207 = path.getOrDefault("subscriptionId")
  valid_565207 = validateParameter(valid_565207, JString, required = true,
                                 default = nil)
  if valid_565207 != nil:
    section.add "subscriptionId", valid_565207
  var valid_565208 = path.getOrDefault("credentialName")
  valid_565208 = validateParameter(valid_565208, JString, required = true,
                                 default = nil)
  if valid_565208 != nil:
    section.add "credentialName", valid_565208
  var valid_565209 = path.getOrDefault("resourceGroupName")
  valid_565209 = validateParameter(valid_565209, JString, required = true,
                                 default = nil)
  if valid_565209 != nil:
    section.add "resourceGroupName", valid_565209
  var valid_565210 = path.getOrDefault("managerName")
  valid_565210 = validateParameter(valid_565210, JString, required = true,
                                 default = nil)
  if valid_565210 != nil:
    section.add "managerName", valid_565210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565211 = query.getOrDefault("api-version")
  valid_565211 = validateParameter(valid_565211, JString, required = true,
                                 default = nil)
  if valid_565211 != nil:
    section.add "api-version", valid_565211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565212: Call_StorageAccountCredentialsGet_565204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified storage account credential name.
  ## 
  let valid = call_565212.validator(path, query, header, formData, body)
  let scheme = call_565212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565212.url(scheme.get, call_565212.host, call_565212.base,
                         call_565212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565212, url, valid)

proc call*(call_565213: Call_StorageAccountCredentialsGet_565204;
          apiVersion: string; subscriptionId: string; credentialName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## storageAccountCredentialsGet
  ## Returns the properties of the specified storage account credential name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   credentialName: string (required)
  ##                 : The name of storage account credential to be fetched.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565214 = newJObject()
  var query_565215 = newJObject()
  add(query_565215, "api-version", newJString(apiVersion))
  add(path_565214, "subscriptionId", newJString(subscriptionId))
  add(path_565214, "credentialName", newJString(credentialName))
  add(path_565214, "resourceGroupName", newJString(resourceGroupName))
  add(path_565214, "managerName", newJString(managerName))
  result = call_565213.call(path_565214, query_565215, nil, nil, nil)

var storageAccountCredentialsGet* = Call_StorageAccountCredentialsGet_565204(
    name: "storageAccountCredentialsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials/{credentialName}",
    validator: validate_StorageAccountCredentialsGet_565205, base: "",
    url: url_StorageAccountCredentialsGet_565206, schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsDelete_565230 = ref object of OpenApiRestCall_563565
proc url_StorageAccountCredentialsDelete_565232(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "credentialName" in path, "`credentialName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/storageAccountCredentials/"),
               (kind: VariableSegment, value: "credentialName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountCredentialsDelete_565231(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the storage account credential
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   credentialName: JString (required)
  ##                 : The name of the storage account credential.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565233 = path.getOrDefault("subscriptionId")
  valid_565233 = validateParameter(valid_565233, JString, required = true,
                                 default = nil)
  if valid_565233 != nil:
    section.add "subscriptionId", valid_565233
  var valid_565234 = path.getOrDefault("credentialName")
  valid_565234 = validateParameter(valid_565234, JString, required = true,
                                 default = nil)
  if valid_565234 != nil:
    section.add "credentialName", valid_565234
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565237 = query.getOrDefault("api-version")
  valid_565237 = validateParameter(valid_565237, JString, required = true,
                                 default = nil)
  if valid_565237 != nil:
    section.add "api-version", valid_565237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565238: Call_StorageAccountCredentialsDelete_565230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the storage account credential
  ## 
  let valid = call_565238.validator(path, query, header, formData, body)
  let scheme = call_565238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565238.url(scheme.get, call_565238.host, call_565238.base,
                         call_565238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565238, url, valid)

proc call*(call_565239: Call_StorageAccountCredentialsDelete_565230;
          apiVersion: string; subscriptionId: string; credentialName: string;
          resourceGroupName: string; managerName: string): Recallable =
  ## storageAccountCredentialsDelete
  ## Deletes the storage account credential
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   credentialName: string (required)
  ##                 : The name of the storage account credential.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565240 = newJObject()
  var query_565241 = newJObject()
  add(query_565241, "api-version", newJString(apiVersion))
  add(path_565240, "subscriptionId", newJString(subscriptionId))
  add(path_565240, "credentialName", newJString(credentialName))
  add(path_565240, "resourceGroupName", newJString(resourceGroupName))
  add(path_565240, "managerName", newJString(managerName))
  result = call_565239.call(path_565240, query_565241, nil, nil, nil)

var storageAccountCredentialsDelete* = Call_StorageAccountCredentialsDelete_565230(
    name: "storageAccountCredentialsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials/{credentialName}",
    validator: validate_StorageAccountCredentialsDelete_565231, base: "",
    url: url_StorageAccountCredentialsDelete_565232, schemes: {Scheme.Https})
type
  Call_StorageDomainsListByManager_565242 = ref object of OpenApiRestCall_563565
proc url_StorageDomainsListByManager_565244(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/storageDomains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDomainsListByManager_565243(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the storage domains in a manager.
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
  var valid_565245 = path.getOrDefault("subscriptionId")
  valid_565245 = validateParameter(valid_565245, JString, required = true,
                                 default = nil)
  if valid_565245 != nil:
    section.add "subscriptionId", valid_565245
  var valid_565246 = path.getOrDefault("resourceGroupName")
  valid_565246 = validateParameter(valid_565246, JString, required = true,
                                 default = nil)
  if valid_565246 != nil:
    section.add "resourceGroupName", valid_565246
  var valid_565247 = path.getOrDefault("managerName")
  valid_565247 = validateParameter(valid_565247, JString, required = true,
                                 default = nil)
  if valid_565247 != nil:
    section.add "managerName", valid_565247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565248 = query.getOrDefault("api-version")
  valid_565248 = validateParameter(valid_565248, JString, required = true,
                                 default = nil)
  if valid_565248 != nil:
    section.add "api-version", valid_565248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565249: Call_StorageDomainsListByManager_565242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the storage domains in a manager.
  ## 
  let valid = call_565249.validator(path, query, header, formData, body)
  let scheme = call_565249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565249.url(scheme.get, call_565249.host, call_565249.base,
                         call_565249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565249, url, valid)

proc call*(call_565250: Call_StorageDomainsListByManager_565242;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          managerName: string): Recallable =
  ## storageDomainsListByManager
  ## Retrieves all the storage domains in a manager.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  var path_565251 = newJObject()
  var query_565252 = newJObject()
  add(query_565252, "api-version", newJString(apiVersion))
  add(path_565251, "subscriptionId", newJString(subscriptionId))
  add(path_565251, "resourceGroupName", newJString(resourceGroupName))
  add(path_565251, "managerName", newJString(managerName))
  result = call_565250.call(path_565251, query_565252, nil, nil, nil)

var storageDomainsListByManager* = Call_StorageDomainsListByManager_565242(
    name: "storageDomainsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageDomains",
    validator: validate_StorageDomainsListByManager_565243, base: "",
    url: url_StorageDomainsListByManager_565244, schemes: {Scheme.Https})
type
  Call_StorageDomainsCreateOrUpdate_565265 = ref object of OpenApiRestCall_563565
proc url_StorageDomainsCreateOrUpdate_565267(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "storageDomainName" in path,
        "`storageDomainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/storageDomains/"),
               (kind: VariableSegment, value: "storageDomainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDomainsCreateOrUpdate_565266(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the storage domain.
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
  ##   storageDomainName: JString (required)
  ##                    : The storage domain name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565268 = path.getOrDefault("subscriptionId")
  valid_565268 = validateParameter(valid_565268, JString, required = true,
                                 default = nil)
  if valid_565268 != nil:
    section.add "subscriptionId", valid_565268
  var valid_565269 = path.getOrDefault("resourceGroupName")
  valid_565269 = validateParameter(valid_565269, JString, required = true,
                                 default = nil)
  if valid_565269 != nil:
    section.add "resourceGroupName", valid_565269
  var valid_565270 = path.getOrDefault("managerName")
  valid_565270 = validateParameter(valid_565270, JString, required = true,
                                 default = nil)
  if valid_565270 != nil:
    section.add "managerName", valid_565270
  var valid_565271 = path.getOrDefault("storageDomainName")
  valid_565271 = validateParameter(valid_565271, JString, required = true,
                                 default = nil)
  if valid_565271 != nil:
    section.add "storageDomainName", valid_565271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565272 = query.getOrDefault("api-version")
  valid_565272 = validateParameter(valid_565272, JString, required = true,
                                 default = nil)
  if valid_565272 != nil:
    section.add "api-version", valid_565272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   storageDomain: JObject (required)
  ##                : The storageDomain.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565274: Call_StorageDomainsCreateOrUpdate_565265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the storage domain.
  ## 
  let valid = call_565274.validator(path, query, header, formData, body)
  let scheme = call_565274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565274.url(scheme.get, call_565274.host, call_565274.base,
                         call_565274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565274, url, valid)

proc call*(call_565275: Call_StorageDomainsCreateOrUpdate_565265;
          apiVersion: string; subscriptionId: string; storageDomain: JsonNode;
          resourceGroupName: string; managerName: string; storageDomainName: string): Recallable =
  ## storageDomainsCreateOrUpdate
  ## Creates or updates the storage domain.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   storageDomain: JObject (required)
  ##                : The storageDomain.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   storageDomainName: string (required)
  ##                    : The storage domain name.
  var path_565276 = newJObject()
  var query_565277 = newJObject()
  var body_565278 = newJObject()
  add(query_565277, "api-version", newJString(apiVersion))
  add(path_565276, "subscriptionId", newJString(subscriptionId))
  if storageDomain != nil:
    body_565278 = storageDomain
  add(path_565276, "resourceGroupName", newJString(resourceGroupName))
  add(path_565276, "managerName", newJString(managerName))
  add(path_565276, "storageDomainName", newJString(storageDomainName))
  result = call_565275.call(path_565276, query_565277, nil, nil, body_565278)

var storageDomainsCreateOrUpdate* = Call_StorageDomainsCreateOrUpdate_565265(
    name: "storageDomainsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageDomains/{storageDomainName}",
    validator: validate_StorageDomainsCreateOrUpdate_565266, base: "",
    url: url_StorageDomainsCreateOrUpdate_565267, schemes: {Scheme.Https})
type
  Call_StorageDomainsGet_565253 = ref object of OpenApiRestCall_563565
proc url_StorageDomainsGet_565255(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "storageDomainName" in path,
        "`storageDomainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/storageDomains/"),
               (kind: VariableSegment, value: "storageDomainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDomainsGet_565254(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns the properties of the specified storage domain name.
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
  ##   storageDomainName: JString (required)
  ##                    : The storage domain name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565256 = path.getOrDefault("subscriptionId")
  valid_565256 = validateParameter(valid_565256, JString, required = true,
                                 default = nil)
  if valid_565256 != nil:
    section.add "subscriptionId", valid_565256
  var valid_565257 = path.getOrDefault("resourceGroupName")
  valid_565257 = validateParameter(valid_565257, JString, required = true,
                                 default = nil)
  if valid_565257 != nil:
    section.add "resourceGroupName", valid_565257
  var valid_565258 = path.getOrDefault("managerName")
  valid_565258 = validateParameter(valid_565258, JString, required = true,
                                 default = nil)
  if valid_565258 != nil:
    section.add "managerName", valid_565258
  var valid_565259 = path.getOrDefault("storageDomainName")
  valid_565259 = validateParameter(valid_565259, JString, required = true,
                                 default = nil)
  if valid_565259 != nil:
    section.add "storageDomainName", valid_565259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565260 = query.getOrDefault("api-version")
  valid_565260 = validateParameter(valid_565260, JString, required = true,
                                 default = nil)
  if valid_565260 != nil:
    section.add "api-version", valid_565260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565261: Call_StorageDomainsGet_565253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified storage domain name.
  ## 
  let valid = call_565261.validator(path, query, header, formData, body)
  let scheme = call_565261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565261.url(scheme.get, call_565261.host, call_565261.base,
                         call_565261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565261, url, valid)

proc call*(call_565262: Call_StorageDomainsGet_565253; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string;
          storageDomainName: string): Recallable =
  ## storageDomainsGet
  ## Returns the properties of the specified storage domain name.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   storageDomainName: string (required)
  ##                    : The storage domain name.
  var path_565263 = newJObject()
  var query_565264 = newJObject()
  add(query_565264, "api-version", newJString(apiVersion))
  add(path_565263, "subscriptionId", newJString(subscriptionId))
  add(path_565263, "resourceGroupName", newJString(resourceGroupName))
  add(path_565263, "managerName", newJString(managerName))
  add(path_565263, "storageDomainName", newJString(storageDomainName))
  result = call_565262.call(path_565263, query_565264, nil, nil, nil)

var storageDomainsGet* = Call_StorageDomainsGet_565253(name: "storageDomainsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageDomains/{storageDomainName}",
    validator: validate_StorageDomainsGet_565254, base: "",
    url: url_StorageDomainsGet_565255, schemes: {Scheme.Https})
type
  Call_StorageDomainsDelete_565279 = ref object of OpenApiRestCall_563565
proc url_StorageDomainsDelete_565281(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "storageDomainName" in path,
        "`storageDomainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/storageDomains/"),
               (kind: VariableSegment, value: "storageDomainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDomainsDelete_565280(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the storage domain.
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
  ##   storageDomainName: JString (required)
  ##                    : The storage domain name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565282 = path.getOrDefault("subscriptionId")
  valid_565282 = validateParameter(valid_565282, JString, required = true,
                                 default = nil)
  if valid_565282 != nil:
    section.add "subscriptionId", valid_565282
  var valid_565283 = path.getOrDefault("resourceGroupName")
  valid_565283 = validateParameter(valid_565283, JString, required = true,
                                 default = nil)
  if valid_565283 != nil:
    section.add "resourceGroupName", valid_565283
  var valid_565284 = path.getOrDefault("managerName")
  valid_565284 = validateParameter(valid_565284, JString, required = true,
                                 default = nil)
  if valid_565284 != nil:
    section.add "managerName", valid_565284
  var valid_565285 = path.getOrDefault("storageDomainName")
  valid_565285 = validateParameter(valid_565285, JString, required = true,
                                 default = nil)
  if valid_565285 != nil:
    section.add "storageDomainName", valid_565285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565286 = query.getOrDefault("api-version")
  valid_565286 = validateParameter(valid_565286, JString, required = true,
                                 default = nil)
  if valid_565286 != nil:
    section.add "api-version", valid_565286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565287: Call_StorageDomainsDelete_565279; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the storage domain.
  ## 
  let valid = call_565287.validator(path, query, header, formData, body)
  let scheme = call_565287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565287.url(scheme.get, call_565287.host, call_565287.base,
                         call_565287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565287, url, valid)

proc call*(call_565288: Call_StorageDomainsDelete_565279; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; managerName: string;
          storageDomainName: string): Recallable =
  ## storageDomainsDelete
  ## Deletes the storage domain.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   managerName: string (required)
  ##              : The manager name
  ##   storageDomainName: string (required)
  ##                    : The storage domain name.
  var path_565289 = newJObject()
  var query_565290 = newJObject()
  add(query_565290, "api-version", newJString(apiVersion))
  add(path_565289, "subscriptionId", newJString(subscriptionId))
  add(path_565289, "resourceGroupName", newJString(resourceGroupName))
  add(path_565289, "managerName", newJString(managerName))
  add(path_565289, "storageDomainName", newJString(storageDomainName))
  result = call_565288.call(path_565289, query_565290, nil, nil, nil)

var storageDomainsDelete* = Call_StorageDomainsDelete_565279(
    name: "storageDomainsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageDomains/{storageDomainName}",
    validator: validate_StorageDomainsDelete_565280, base: "",
    url: url_StorageDomainsDelete_565281, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
