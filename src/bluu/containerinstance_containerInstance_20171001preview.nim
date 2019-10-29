
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ContainerInstanceManagementClient
## version: 2017-10-01-preview
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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
  macServiceName = "containerinstance-containerInstance"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563778 = ref object of OpenApiRestCall_563556
proc url_OperationsList_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563779(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## List the operations for Azure Container Instance service.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563941 = query.getOrDefault("api-version")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "api-version", valid_563941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563964: Call_OperationsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the operations for Azure Container Instance service.
  ## 
  let valid = call_563964.validator(path, query, header, formData, body)
  let scheme = call_563964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563964.url(scheme.get, call_563964.host, call_563964.base,
                         call_563964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563964, url, valid)

proc call*(call_564035: Call_OperationsList_563778; apiVersion: string): Recallable =
  ## operationsList
  ## List the operations for Azure Container Instance service.
  ##   apiVersion: string (required)
  ##             : Client API version
  var query_564036 = newJObject()
  add(query_564036, "api-version", newJString(apiVersion))
  result = call_564035.call(nil, query_564036, nil, nil, nil)

var operationsList* = Call_OperationsList_563778(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ContainerInstance/operations",
    validator: validate_OperationsList_563779, base: "", url: url_OperationsList_563780,
    schemes: {Scheme.Https})
type
  Call_ContainerGroupsList_564076 = ref object of OpenApiRestCall_563556
proc url_ContainerGroupsList_564078(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerInstance/containerGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerGroupsList_564077(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get a list of container groups in the specified subscription. This operation returns properties of each container group including containers, image registry credentials, restart policy, IP address type, OS type, state, and volumes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564093 = path.getOrDefault("subscriptionId")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "subscriptionId", valid_564093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564094 = query.getOrDefault("api-version")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "api-version", valid_564094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564095: Call_ContainerGroupsList_564076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of container groups in the specified subscription. This operation returns properties of each container group including containers, image registry credentials, restart policy, IP address type, OS type, state, and volumes.
  ## 
  let valid = call_564095.validator(path, query, header, formData, body)
  let scheme = call_564095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564095.url(scheme.get, call_564095.host, call_564095.base,
                         call_564095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564095, url, valid)

proc call*(call_564096: Call_ContainerGroupsList_564076; apiVersion: string;
          subscriptionId: string): Recallable =
  ## containerGroupsList
  ## Get a list of container groups in the specified subscription. This operation returns properties of each container group including containers, image registry credentials, restart policy, IP address type, OS type, state, and volumes.
  ##   apiVersion: string (required)
  ##             : Client API version
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564097 = newJObject()
  var query_564098 = newJObject()
  add(query_564098, "api-version", newJString(apiVersion))
  add(path_564097, "subscriptionId", newJString(subscriptionId))
  result = call_564096.call(path_564097, query_564098, nil, nil, nil)

var containerGroupsList* = Call_ContainerGroupsList_564076(
    name: "containerGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ContainerInstance/containerGroups",
    validator: validate_ContainerGroupsList_564077, base: "",
    url: url_ContainerGroupsList_564078, schemes: {Scheme.Https})
type
  Call_ContainerGroupsListByResourceGroup_564099 = ref object of OpenApiRestCall_563556
proc url_ContainerGroupsListByResourceGroup_564101(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerInstance/containerGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerGroupsListByResourceGroup_564100(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a list of container groups in a specified subscription and resource group. This operation returns properties of each container group including containers, image registry credentials, restart policy, IP address type, OS type, state, and volumes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564102 = path.getOrDefault("subscriptionId")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "subscriptionId", valid_564102
  var valid_564103 = path.getOrDefault("resourceGroupName")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "resourceGroupName", valid_564103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564104 = query.getOrDefault("api-version")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "api-version", valid_564104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564105: Call_ContainerGroupsListByResourceGroup_564099;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a list of container groups in a specified subscription and resource group. This operation returns properties of each container group including containers, image registry credentials, restart policy, IP address type, OS type, state, and volumes.
  ## 
  let valid = call_564105.validator(path, query, header, formData, body)
  let scheme = call_564105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564105.url(scheme.get, call_564105.host, call_564105.base,
                         call_564105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564105, url, valid)

proc call*(call_564106: Call_ContainerGroupsListByResourceGroup_564099;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## containerGroupsListByResourceGroup
  ## Get a list of container groups in a specified subscription and resource group. This operation returns properties of each container group including containers, image registry credentials, restart policy, IP address type, OS type, state, and volumes.
  ##   apiVersion: string (required)
  ##             : Client API version
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564107 = newJObject()
  var query_564108 = newJObject()
  add(query_564108, "api-version", newJString(apiVersion))
  add(path_564107, "subscriptionId", newJString(subscriptionId))
  add(path_564107, "resourceGroupName", newJString(resourceGroupName))
  result = call_564106.call(path_564107, query_564108, nil, nil, nil)

var containerGroupsListByResourceGroup* = Call_ContainerGroupsListByResourceGroup_564099(
    name: "containerGroupsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerInstance/containerGroups",
    validator: validate_ContainerGroupsListByResourceGroup_564100, base: "",
    url: url_ContainerGroupsListByResourceGroup_564101, schemes: {Scheme.Https})
type
  Call_ContainerGroupsCreateOrUpdate_564120 = ref object of OpenApiRestCall_563556
proc url_ContainerGroupsCreateOrUpdate_564122(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "containerGroupName" in path,
        "`containerGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerInstance/containerGroups/"),
               (kind: VariableSegment, value: "containerGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerGroupsCreateOrUpdate_564121(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update container groups with specified configurations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   containerGroupName: JString (required)
  ##                     : The name of the container group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564123 = path.getOrDefault("subscriptionId")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "subscriptionId", valid_564123
  var valid_564124 = path.getOrDefault("resourceGroupName")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "resourceGroupName", valid_564124
  var valid_564125 = path.getOrDefault("containerGroupName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "containerGroupName", valid_564125
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564126 = query.getOrDefault("api-version")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "api-version", valid_564126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   containerGroup: JObject (required)
  ##                 : The properties of the container group to be created or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564128: Call_ContainerGroupsCreateOrUpdate_564120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update container groups with specified configurations.
  ## 
  let valid = call_564128.validator(path, query, header, formData, body)
  let scheme = call_564128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564128.url(scheme.get, call_564128.host, call_564128.base,
                         call_564128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564128, url, valid)

proc call*(call_564129: Call_ContainerGroupsCreateOrUpdate_564120;
          apiVersion: string; subscriptionId: string; containerGroup: JsonNode;
          resourceGroupName: string; containerGroupName: string): Recallable =
  ## containerGroupsCreateOrUpdate
  ## Create or update container groups with specified configurations.
  ##   apiVersion: string (required)
  ##             : Client API version
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   containerGroup: JObject (required)
  ##                 : The properties of the container group to be created or updated.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   containerGroupName: string (required)
  ##                     : The name of the container group.
  var path_564130 = newJObject()
  var query_564131 = newJObject()
  var body_564132 = newJObject()
  add(query_564131, "api-version", newJString(apiVersion))
  add(path_564130, "subscriptionId", newJString(subscriptionId))
  if containerGroup != nil:
    body_564132 = containerGroup
  add(path_564130, "resourceGroupName", newJString(resourceGroupName))
  add(path_564130, "containerGroupName", newJString(containerGroupName))
  result = call_564129.call(path_564130, query_564131, nil, nil, body_564132)

var containerGroupsCreateOrUpdate* = Call_ContainerGroupsCreateOrUpdate_564120(
    name: "containerGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerInstance/containerGroups/{containerGroupName}",
    validator: validate_ContainerGroupsCreateOrUpdate_564121, base: "",
    url: url_ContainerGroupsCreateOrUpdate_564122, schemes: {Scheme.Https})
type
  Call_ContainerGroupsGet_564109 = ref object of OpenApiRestCall_563556
proc url_ContainerGroupsGet_564111(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "containerGroupName" in path,
        "`containerGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerInstance/containerGroups/"),
               (kind: VariableSegment, value: "containerGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerGroupsGet_564110(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the properties of the specified container group in the specified subscription and resource group. The operation returns the properties of each container group including containers, image registry credentials, restart policy, IP address type, OS type, state, and volumes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   containerGroupName: JString (required)
  ##                     : The name of the container group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564112 = path.getOrDefault("subscriptionId")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "subscriptionId", valid_564112
  var valid_564113 = path.getOrDefault("resourceGroupName")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "resourceGroupName", valid_564113
  var valid_564114 = path.getOrDefault("containerGroupName")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "containerGroupName", valid_564114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564115 = query.getOrDefault("api-version")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "api-version", valid_564115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564116: Call_ContainerGroupsGet_564109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified container group in the specified subscription and resource group. The operation returns the properties of each container group including containers, image registry credentials, restart policy, IP address type, OS type, state, and volumes.
  ## 
  let valid = call_564116.validator(path, query, header, formData, body)
  let scheme = call_564116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564116.url(scheme.get, call_564116.host, call_564116.base,
                         call_564116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564116, url, valid)

proc call*(call_564117: Call_ContainerGroupsGet_564109; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          containerGroupName: string): Recallable =
  ## containerGroupsGet
  ## Gets the properties of the specified container group in the specified subscription and resource group. The operation returns the properties of each container group including containers, image registry credentials, restart policy, IP address type, OS type, state, and volumes.
  ##   apiVersion: string (required)
  ##             : Client API version
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   containerGroupName: string (required)
  ##                     : The name of the container group.
  var path_564118 = newJObject()
  var query_564119 = newJObject()
  add(query_564119, "api-version", newJString(apiVersion))
  add(path_564118, "subscriptionId", newJString(subscriptionId))
  add(path_564118, "resourceGroupName", newJString(resourceGroupName))
  add(path_564118, "containerGroupName", newJString(containerGroupName))
  result = call_564117.call(path_564118, query_564119, nil, nil, nil)

var containerGroupsGet* = Call_ContainerGroupsGet_564109(
    name: "containerGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerInstance/containerGroups/{containerGroupName}",
    validator: validate_ContainerGroupsGet_564110, base: "",
    url: url_ContainerGroupsGet_564111, schemes: {Scheme.Https})
type
  Call_ContainerGroupsDelete_564133 = ref object of OpenApiRestCall_563556
proc url_ContainerGroupsDelete_564135(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "containerGroupName" in path,
        "`containerGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerInstance/containerGroups/"),
               (kind: VariableSegment, value: "containerGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerGroupsDelete_564134(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the specified container group in the specified subscription and resource group. The operation does not delete other resources provided by the user, such as volumes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   containerGroupName: JString (required)
  ##                     : The name of the container group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564136 = path.getOrDefault("subscriptionId")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "subscriptionId", valid_564136
  var valid_564137 = path.getOrDefault("resourceGroupName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "resourceGroupName", valid_564137
  var valid_564138 = path.getOrDefault("containerGroupName")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "containerGroupName", valid_564138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564139 = query.getOrDefault("api-version")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "api-version", valid_564139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564140: Call_ContainerGroupsDelete_564133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the specified container group in the specified subscription and resource group. The operation does not delete other resources provided by the user, such as volumes.
  ## 
  let valid = call_564140.validator(path, query, header, formData, body)
  let scheme = call_564140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564140.url(scheme.get, call_564140.host, call_564140.base,
                         call_564140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564140, url, valid)

proc call*(call_564141: Call_ContainerGroupsDelete_564133; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          containerGroupName: string): Recallable =
  ## containerGroupsDelete
  ## Delete the specified container group in the specified subscription and resource group. The operation does not delete other resources provided by the user, such as volumes.
  ##   apiVersion: string (required)
  ##             : Client API version
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   containerGroupName: string (required)
  ##                     : The name of the container group.
  var path_564142 = newJObject()
  var query_564143 = newJObject()
  add(query_564143, "api-version", newJString(apiVersion))
  add(path_564142, "subscriptionId", newJString(subscriptionId))
  add(path_564142, "resourceGroupName", newJString(resourceGroupName))
  add(path_564142, "containerGroupName", newJString(containerGroupName))
  result = call_564141.call(path_564142, query_564143, nil, nil, nil)

var containerGroupsDelete* = Call_ContainerGroupsDelete_564133(
    name: "containerGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerInstance/containerGroups/{containerGroupName}",
    validator: validate_ContainerGroupsDelete_564134, base: "",
    url: url_ContainerGroupsDelete_564135, schemes: {Scheme.Https})
type
  Call_ContainerLogsList_564144 = ref object of OpenApiRestCall_563556
proc url_ContainerLogsList_564146(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "containerGroupName" in path,
        "`containerGroupName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ContainerInstance/containerGroups/"),
               (kind: VariableSegment, value: "containerGroupName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/logs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerLogsList_564145(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get the logs for a specified container instance in a specified resource group and container group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   containerName: JString (required)
  ##                : The name of the container instance.
  ##   containerGroupName: JString (required)
  ##                     : The name of the container group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564147 = path.getOrDefault("subscriptionId")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "subscriptionId", valid_564147
  var valid_564148 = path.getOrDefault("resourceGroupName")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "resourceGroupName", valid_564148
  var valid_564149 = path.getOrDefault("containerName")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "containerName", valid_564149
  var valid_564150 = path.getOrDefault("containerGroupName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "containerGroupName", valid_564150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version
  ##   tail: JInt
  ##       : The number of lines to show from the tail of the container instance log. If not provided, all available logs are shown up to 4mb.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564151 = query.getOrDefault("api-version")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "api-version", valid_564151
  var valid_564152 = query.getOrDefault("tail")
  valid_564152 = validateParameter(valid_564152, JInt, required = false, default = nil)
  if valid_564152 != nil:
    section.add "tail", valid_564152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564153: Call_ContainerLogsList_564144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the logs for a specified container instance in a specified resource group and container group.
  ## 
  let valid = call_564153.validator(path, query, header, formData, body)
  let scheme = call_564153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564153.url(scheme.get, call_564153.host, call_564153.base,
                         call_564153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564153, url, valid)

proc call*(call_564154: Call_ContainerLogsList_564144; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; containerName: string;
          containerGroupName: string; tail: int = 0): Recallable =
  ## containerLogsList
  ## Get the logs for a specified container instance in a specified resource group and container group.
  ##   apiVersion: string (required)
  ##             : Client API version
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   tail: int
  ##       : The number of lines to show from the tail of the container instance log. If not provided, all available logs are shown up to 4mb.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   containerName: string (required)
  ##                : The name of the container instance.
  ##   containerGroupName: string (required)
  ##                     : The name of the container group.
  var path_564155 = newJObject()
  var query_564156 = newJObject()
  add(query_564156, "api-version", newJString(apiVersion))
  add(path_564155, "subscriptionId", newJString(subscriptionId))
  add(query_564156, "tail", newJInt(tail))
  add(path_564155, "resourceGroupName", newJString(resourceGroupName))
  add(path_564155, "containerName", newJString(containerName))
  add(path_564155, "containerGroupName", newJString(containerGroupName))
  result = call_564154.call(path_564155, query_564156, nil, nil, nil)

var containerLogsList* = Call_ContainerLogsList_564144(name: "containerLogsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerInstance/containerGroups/{containerGroupName}/containers/{containerName}/logs",
    validator: validate_ContainerLogsList_564145, base: "",
    url: url_ContainerLogsList_564146, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
