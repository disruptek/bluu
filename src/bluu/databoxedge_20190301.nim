
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: DataBoxEdgeManagementClient
## version: 2019-03-01
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
  macServiceName = "databoxedge"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563786 = ref object of OpenApiRestCall_563564
proc url_OperationsList_563788(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563787(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563949 = query.getOrDefault("api-version")
  valid_563949 = validateParameter(valid_563949, JString, required = true,
                                 default = nil)
  if valid_563949 != nil:
    section.add "api-version", valid_563949
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563972: Call_OperationsList_563786; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_563972.validator(path, query, header, formData, body)
  let scheme = call_563972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563972.url(scheme.get, call_563972.host, call_563972.base,
                         call_563972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563972, url, valid)

proc call*(call_564043: Call_OperationsList_563786; apiVersion: string): Recallable =
  ## operationsList
  ##   apiVersion: string (required)
  ##             : The API version.
  var query_564044 = newJObject()
  add(query_564044, "api-version", newJString(apiVersion))
  result = call_564043.call(nil, query_564044, nil, nil, nil)

var operationsList* = Call_OperationsList_563786(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataBoxEdge/operations",
    validator: validate_OperationsList_563787, base: "", url: url_OperationsList_563788,
    schemes: {Scheme.Https})
type
  Call_DevicesListBySubscription_564084 = ref object of OpenApiRestCall_563564
proc url_DevicesListBySubscription_564086(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesListBySubscription_564085(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the data box edge/gateway devices in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
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
  ##              : The API version.
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the resource or Specify $skipToken=<token> to populate the next page in the list.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564103 = query.getOrDefault("api-version")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "api-version", valid_564103
  var valid_564104 = query.getOrDefault("$expand")
  valid_564104 = validateParameter(valid_564104, JString, required = false,
                                 default = nil)
  if valid_564104 != nil:
    section.add "$expand", valid_564104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564105: Call_DevicesListBySubscription_564084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the data box edge/gateway devices in a subscription.
  ## 
  let valid = call_564105.validator(path, query, header, formData, body)
  let scheme = call_564105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564105.url(scheme.get, call_564105.host, call_564105.base,
                         call_564105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564105, url, valid)

proc call*(call_564106: Call_DevicesListBySubscription_564084; apiVersion: string;
          subscriptionId: string; Expand: string = ""): Recallable =
  ## devicesListBySubscription
  ## Gets all the data box edge/gateway devices in a subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Expand: string
  ##         : Specify $expand=details to populate additional fields related to the resource or Specify $skipToken=<token> to populate the next page in the list.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_564107 = newJObject()
  var query_564108 = newJObject()
  add(query_564108, "api-version", newJString(apiVersion))
  add(query_564108, "$expand", newJString(Expand))
  add(path_564107, "subscriptionId", newJString(subscriptionId))
  result = call_564106.call(path_564107, query_564108, nil, nil, nil)

var devicesListBySubscription* = Call_DevicesListBySubscription_564084(
    name: "devicesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices",
    validator: validate_DevicesListBySubscription_564085, base: "",
    url: url_DevicesListBySubscription_564086, schemes: {Scheme.Https})
type
  Call_DevicesListByResourceGroup_564109 = ref object of OpenApiRestCall_563564
proc url_DevicesListByResourceGroup_564111(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesListByResourceGroup_564110(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the data box edge/gateway devices in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the resource or Specify $skipToken=<token> to populate the next page in the list.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564114 = query.getOrDefault("api-version")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "api-version", valid_564114
  var valid_564115 = query.getOrDefault("$expand")
  valid_564115 = validateParameter(valid_564115, JString, required = false,
                                 default = nil)
  if valid_564115 != nil:
    section.add "$expand", valid_564115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564116: Call_DevicesListByResourceGroup_564109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the data box edge/gateway devices in a resource group.
  ## 
  let valid = call_564116.validator(path, query, header, formData, body)
  let scheme = call_564116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564116.url(scheme.get, call_564116.host, call_564116.base,
                         call_564116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564116, url, valid)

proc call*(call_564117: Call_DevicesListByResourceGroup_564109; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; Expand: string = ""): Recallable =
  ## devicesListByResourceGroup
  ## Gets all the data box edge/gateway devices in a resource group.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Expand: string
  ##         : Specify $expand=details to populate additional fields related to the resource or Specify $skipToken=<token> to populate the next page in the list.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564118 = newJObject()
  var query_564119 = newJObject()
  add(query_564119, "api-version", newJString(apiVersion))
  add(query_564119, "$expand", newJString(Expand))
  add(path_564118, "subscriptionId", newJString(subscriptionId))
  add(path_564118, "resourceGroupName", newJString(resourceGroupName))
  result = call_564117.call(path_564118, query_564119, nil, nil, nil)

var devicesListByResourceGroup* = Call_DevicesListByResourceGroup_564109(
    name: "devicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices",
    validator: validate_DevicesListByResourceGroup_564110, base: "",
    url: url_DevicesListByResourceGroup_564111, schemes: {Scheme.Https})
type
  Call_DevicesCreateOrUpdate_564131 = ref object of OpenApiRestCall_563564
proc url_DevicesCreateOrUpdate_564133(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesCreateOrUpdate_564132(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a Data Box Edge/Gateway resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564134 = path.getOrDefault("subscriptionId")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "subscriptionId", valid_564134
  var valid_564135 = path.getOrDefault("deviceName")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "deviceName", valid_564135
  var valid_564136 = path.getOrDefault("resourceGroupName")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "resourceGroupName", valid_564136
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  ## parameters in `body` object:
  ##   DataBoxEdgeDevice: JObject (required)
  ##                    : The resource object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564139: Call_DevicesCreateOrUpdate_564131; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Data Box Edge/Gateway resource.
  ## 
  let valid = call_564139.validator(path, query, header, formData, body)
  let scheme = call_564139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564139.url(scheme.get, call_564139.host, call_564139.base,
                         call_564139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564139, url, valid)

proc call*(call_564140: Call_DevicesCreateOrUpdate_564131;
          DataBoxEdgeDevice: JsonNode; apiVersion: string; subscriptionId: string;
          deviceName: string; resourceGroupName: string): Recallable =
  ## devicesCreateOrUpdate
  ## Creates or updates a Data Box Edge/Gateway resource.
  ##   DataBoxEdgeDevice: JObject (required)
  ##                    : The resource object.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564141 = newJObject()
  var query_564142 = newJObject()
  var body_564143 = newJObject()
  if DataBoxEdgeDevice != nil:
    body_564143 = DataBoxEdgeDevice
  add(query_564142, "api-version", newJString(apiVersion))
  add(path_564141, "subscriptionId", newJString(subscriptionId))
  add(path_564141, "deviceName", newJString(deviceName))
  add(path_564141, "resourceGroupName", newJString(resourceGroupName))
  result = call_564140.call(path_564141, query_564142, nil, nil, body_564143)

var devicesCreateOrUpdate* = Call_DevicesCreateOrUpdate_564131(
    name: "devicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}",
    validator: validate_DevicesCreateOrUpdate_564132, base: "",
    url: url_DevicesCreateOrUpdate_564133, schemes: {Scheme.Https})
type
  Call_DevicesGet_564120 = ref object of OpenApiRestCall_563564
proc url_DevicesGet_564122(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesGet_564121(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564123 = path.getOrDefault("subscriptionId")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "subscriptionId", valid_564123
  var valid_564124 = path.getOrDefault("deviceName")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "deviceName", valid_564124
  var valid_564125 = path.getOrDefault("resourceGroupName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "resourceGroupName", valid_564125
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564127: Call_DevicesGet_564120; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the data box edge/gateway device.
  ## 
  let valid = call_564127.validator(path, query, header, formData, body)
  let scheme = call_564127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564127.url(scheme.get, call_564127.host, call_564127.base,
                         call_564127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564127, url, valid)

proc call*(call_564128: Call_DevicesGet_564120; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## devicesGet
  ## Gets the properties of the data box edge/gateway device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564129 = newJObject()
  var query_564130 = newJObject()
  add(query_564130, "api-version", newJString(apiVersion))
  add(path_564129, "subscriptionId", newJString(subscriptionId))
  add(path_564129, "deviceName", newJString(deviceName))
  add(path_564129, "resourceGroupName", newJString(resourceGroupName))
  result = call_564128.call(path_564129, query_564130, nil, nil, nil)

var devicesGet* = Call_DevicesGet_564120(name: "devicesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}",
                                      validator: validate_DevicesGet_564121,
                                      base: "", url: url_DevicesGet_564122,
                                      schemes: {Scheme.Https})
type
  Call_DevicesUpdate_564155 = ref object of OpenApiRestCall_563564
proc url_DevicesUpdate_564157(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesUpdate_564156(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies a Data Box Edge/Gateway resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564158 = path.getOrDefault("subscriptionId")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "subscriptionId", valid_564158
  var valid_564159 = path.getOrDefault("deviceName")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "deviceName", valid_564159
  var valid_564160 = path.getOrDefault("resourceGroupName")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "resourceGroupName", valid_564160
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564161 = query.getOrDefault("api-version")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "api-version", valid_564161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The resource parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564163: Call_DevicesUpdate_564155; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a Data Box Edge/Gateway resource.
  ## 
  let valid = call_564163.validator(path, query, header, formData, body)
  let scheme = call_564163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564163.url(scheme.get, call_564163.host, call_564163.base,
                         call_564163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564163, url, valid)

proc call*(call_564164: Call_DevicesUpdate_564155; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## devicesUpdate
  ## Modifies a Data Box Edge/Gateway resource.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   parameters: JObject (required)
  ##             : The resource parameters.
  var path_564165 = newJObject()
  var query_564166 = newJObject()
  var body_564167 = newJObject()
  add(query_564166, "api-version", newJString(apiVersion))
  add(path_564165, "subscriptionId", newJString(subscriptionId))
  add(path_564165, "deviceName", newJString(deviceName))
  add(path_564165, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564167 = parameters
  result = call_564164.call(path_564165, query_564166, nil, nil, body_564167)

var devicesUpdate* = Call_DevicesUpdate_564155(name: "devicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}",
    validator: validate_DevicesUpdate_564156, base: "", url: url_DevicesUpdate_564157,
    schemes: {Scheme.Https})
type
  Call_DevicesDelete_564144 = ref object of OpenApiRestCall_563564
proc url_DevicesDelete_564146(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesDelete_564145(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564147 = path.getOrDefault("subscriptionId")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "subscriptionId", valid_564147
  var valid_564148 = path.getOrDefault("deviceName")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "deviceName", valid_564148
  var valid_564149 = path.getOrDefault("resourceGroupName")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "resourceGroupName", valid_564149
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564150 = query.getOrDefault("api-version")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "api-version", valid_564150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564151: Call_DevicesDelete_564144; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the data box edge/gateway device.
  ## 
  let valid = call_564151.validator(path, query, header, formData, body)
  let scheme = call_564151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564151.url(scheme.get, call_564151.host, call_564151.base,
                         call_564151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564151, url, valid)

proc call*(call_564152: Call_DevicesDelete_564144; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## devicesDelete
  ## Deletes the data box edge/gateway device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564153 = newJObject()
  var query_564154 = newJObject()
  add(query_564154, "api-version", newJString(apiVersion))
  add(path_564153, "subscriptionId", newJString(subscriptionId))
  add(path_564153, "deviceName", newJString(deviceName))
  add(path_564153, "resourceGroupName", newJString(resourceGroupName))
  result = call_564152.call(path_564153, query_564154, nil, nil, nil)

var devicesDelete* = Call_DevicesDelete_564144(name: "devicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}",
    validator: validate_DevicesDelete_564145, base: "", url: url_DevicesDelete_564146,
    schemes: {Scheme.Https})
type
  Call_AlertsListByDataBoxEdgeDevice_564168 = ref object of OpenApiRestCall_563564
proc url_AlertsListByDataBoxEdgeDevice_564170(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsListByDataBoxEdgeDevice_564169(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the alerts for a data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564171 = path.getOrDefault("subscriptionId")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "subscriptionId", valid_564171
  var valid_564172 = path.getOrDefault("deviceName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "deviceName", valid_564172
  var valid_564173 = path.getOrDefault("resourceGroupName")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "resourceGroupName", valid_564173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564174 = query.getOrDefault("api-version")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "api-version", valid_564174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564175: Call_AlertsListByDataBoxEdgeDevice_564168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the alerts for a data box edge/gateway device.
  ## 
  let valid = call_564175.validator(path, query, header, formData, body)
  let scheme = call_564175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564175.url(scheme.get, call_564175.host, call_564175.base,
                         call_564175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564175, url, valid)

proc call*(call_564176: Call_AlertsListByDataBoxEdgeDevice_564168;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string): Recallable =
  ## alertsListByDataBoxEdgeDevice
  ## Gets all the alerts for a data box edge/gateway device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564177 = newJObject()
  var query_564178 = newJObject()
  add(query_564178, "api-version", newJString(apiVersion))
  add(path_564177, "subscriptionId", newJString(subscriptionId))
  add(path_564177, "deviceName", newJString(deviceName))
  add(path_564177, "resourceGroupName", newJString(resourceGroupName))
  result = call_564176.call(path_564177, query_564178, nil, nil, nil)

var alertsListByDataBoxEdgeDevice* = Call_AlertsListByDataBoxEdgeDevice_564168(
    name: "alertsListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/alerts",
    validator: validate_AlertsListByDataBoxEdgeDevice_564169, base: "",
    url: url_AlertsListByDataBoxEdgeDevice_564170, schemes: {Scheme.Https})
type
  Call_AlertsGet_564179 = ref object of OpenApiRestCall_563564
proc url_AlertsGet_564181(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/alerts/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsGet_564180(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The alert name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564182 = path.getOrDefault("name")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "name", valid_564182
  var valid_564183 = path.getOrDefault("subscriptionId")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "subscriptionId", valid_564183
  var valid_564184 = path.getOrDefault("deviceName")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "deviceName", valid_564184
  var valid_564185 = path.getOrDefault("resourceGroupName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "resourceGroupName", valid_564185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564186 = query.getOrDefault("api-version")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "api-version", valid_564186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564187: Call_AlertsGet_564179; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564187.validator(path, query, header, formData, body)
  let scheme = call_564187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564187.url(scheme.get, call_564187.host, call_564187.base,
                         call_564187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564187, url, valid)

proc call*(call_564188: Call_AlertsGet_564179; apiVersion: string; name: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## alertsGet
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The alert name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564189 = newJObject()
  var query_564190 = newJObject()
  add(query_564190, "api-version", newJString(apiVersion))
  add(path_564189, "name", newJString(name))
  add(path_564189, "subscriptionId", newJString(subscriptionId))
  add(path_564189, "deviceName", newJString(deviceName))
  add(path_564189, "resourceGroupName", newJString(resourceGroupName))
  result = call_564188.call(path_564189, query_564190, nil, nil, nil)

var alertsGet* = Call_AlertsGet_564179(name: "alertsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/alerts/{name}",
                                    validator: validate_AlertsGet_564180,
                                    base: "", url: url_AlertsGet_564181,
                                    schemes: {Scheme.Https})
type
  Call_BandwidthSchedulesListByDataBoxEdgeDevice_564191 = ref object of OpenApiRestCall_563564
proc url_BandwidthSchedulesListByDataBoxEdgeDevice_564193(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/bandwidthSchedules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BandwidthSchedulesListByDataBoxEdgeDevice_564192(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the bandwidth schedules for a data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564194 = path.getOrDefault("subscriptionId")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "subscriptionId", valid_564194
  var valid_564195 = path.getOrDefault("deviceName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "deviceName", valid_564195
  var valid_564196 = path.getOrDefault("resourceGroupName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "resourceGroupName", valid_564196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564197 = query.getOrDefault("api-version")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "api-version", valid_564197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564198: Call_BandwidthSchedulesListByDataBoxEdgeDevice_564191;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the bandwidth schedules for a data box edge/gateway device.
  ## 
  let valid = call_564198.validator(path, query, header, formData, body)
  let scheme = call_564198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564198.url(scheme.get, call_564198.host, call_564198.base,
                         call_564198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564198, url, valid)

proc call*(call_564199: Call_BandwidthSchedulesListByDataBoxEdgeDevice_564191;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string): Recallable =
  ## bandwidthSchedulesListByDataBoxEdgeDevice
  ## Gets all the bandwidth schedules for a data box edge/gateway device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564200 = newJObject()
  var query_564201 = newJObject()
  add(query_564201, "api-version", newJString(apiVersion))
  add(path_564200, "subscriptionId", newJString(subscriptionId))
  add(path_564200, "deviceName", newJString(deviceName))
  add(path_564200, "resourceGroupName", newJString(resourceGroupName))
  result = call_564199.call(path_564200, query_564201, nil, nil, nil)

var bandwidthSchedulesListByDataBoxEdgeDevice* = Call_BandwidthSchedulesListByDataBoxEdgeDevice_564191(
    name: "bandwidthSchedulesListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/bandwidthSchedules",
    validator: validate_BandwidthSchedulesListByDataBoxEdgeDevice_564192,
    base: "", url: url_BandwidthSchedulesListByDataBoxEdgeDevice_564193,
    schemes: {Scheme.Https})
type
  Call_BandwidthSchedulesCreateOrUpdate_564214 = ref object of OpenApiRestCall_563564
proc url_BandwidthSchedulesCreateOrUpdate_564216(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/bandwidthSchedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BandwidthSchedulesCreateOrUpdate_564215(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a bandwidth schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The bandwidth schedule name which needs to be added/updated.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564217 = path.getOrDefault("name")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "name", valid_564217
  var valid_564218 = path.getOrDefault("subscriptionId")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "subscriptionId", valid_564218
  var valid_564219 = path.getOrDefault("deviceName")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "deviceName", valid_564219
  var valid_564220 = path.getOrDefault("resourceGroupName")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "resourceGroupName", valid_564220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564221 = query.getOrDefault("api-version")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "api-version", valid_564221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The bandwidth schedule to be added or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564223: Call_BandwidthSchedulesCreateOrUpdate_564214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a bandwidth schedule.
  ## 
  let valid = call_564223.validator(path, query, header, formData, body)
  let scheme = call_564223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564223.url(scheme.get, call_564223.host, call_564223.base,
                         call_564223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564223, url, valid)

proc call*(call_564224: Call_BandwidthSchedulesCreateOrUpdate_564214;
          apiVersion: string; name: string; subscriptionId: string;
          deviceName: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## bandwidthSchedulesCreateOrUpdate
  ## Creates or updates a bandwidth schedule.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The bandwidth schedule name which needs to be added/updated.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   parameters: JObject (required)
  ##             : The bandwidth schedule to be added or updated.
  var path_564225 = newJObject()
  var query_564226 = newJObject()
  var body_564227 = newJObject()
  add(query_564226, "api-version", newJString(apiVersion))
  add(path_564225, "name", newJString(name))
  add(path_564225, "subscriptionId", newJString(subscriptionId))
  add(path_564225, "deviceName", newJString(deviceName))
  add(path_564225, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564227 = parameters
  result = call_564224.call(path_564225, query_564226, nil, nil, body_564227)

var bandwidthSchedulesCreateOrUpdate* = Call_BandwidthSchedulesCreateOrUpdate_564214(
    name: "bandwidthSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/bandwidthSchedules/{name}",
    validator: validate_BandwidthSchedulesCreateOrUpdate_564215, base: "",
    url: url_BandwidthSchedulesCreateOrUpdate_564216, schemes: {Scheme.Https})
type
  Call_BandwidthSchedulesGet_564202 = ref object of OpenApiRestCall_563564
proc url_BandwidthSchedulesGet_564204(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/bandwidthSchedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BandwidthSchedulesGet_564203(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified bandwidth schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The bandwidth schedule name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564205 = path.getOrDefault("name")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "name", valid_564205
  var valid_564206 = path.getOrDefault("subscriptionId")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "subscriptionId", valid_564206
  var valid_564207 = path.getOrDefault("deviceName")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "deviceName", valid_564207
  var valid_564208 = path.getOrDefault("resourceGroupName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "resourceGroupName", valid_564208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564209 = query.getOrDefault("api-version")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "api-version", valid_564209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564210: Call_BandwidthSchedulesGet_564202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified bandwidth schedule.
  ## 
  let valid = call_564210.validator(path, query, header, formData, body)
  let scheme = call_564210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564210.url(scheme.get, call_564210.host, call_564210.base,
                         call_564210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564210, url, valid)

proc call*(call_564211: Call_BandwidthSchedulesGet_564202; apiVersion: string;
          name: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string): Recallable =
  ## bandwidthSchedulesGet
  ## Gets the properties of the specified bandwidth schedule.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The bandwidth schedule name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564212 = newJObject()
  var query_564213 = newJObject()
  add(query_564213, "api-version", newJString(apiVersion))
  add(path_564212, "name", newJString(name))
  add(path_564212, "subscriptionId", newJString(subscriptionId))
  add(path_564212, "deviceName", newJString(deviceName))
  add(path_564212, "resourceGroupName", newJString(resourceGroupName))
  result = call_564211.call(path_564212, query_564213, nil, nil, nil)

var bandwidthSchedulesGet* = Call_BandwidthSchedulesGet_564202(
    name: "bandwidthSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/bandwidthSchedules/{name}",
    validator: validate_BandwidthSchedulesGet_564203, base: "",
    url: url_BandwidthSchedulesGet_564204, schemes: {Scheme.Https})
type
  Call_BandwidthSchedulesDelete_564228 = ref object of OpenApiRestCall_563564
proc url_BandwidthSchedulesDelete_564230(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/bandwidthSchedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BandwidthSchedulesDelete_564229(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified bandwidth schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The bandwidth schedule name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564231 = path.getOrDefault("name")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "name", valid_564231
  var valid_564232 = path.getOrDefault("subscriptionId")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "subscriptionId", valid_564232
  var valid_564233 = path.getOrDefault("deviceName")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "deviceName", valid_564233
  var valid_564234 = path.getOrDefault("resourceGroupName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "resourceGroupName", valid_564234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564235 = query.getOrDefault("api-version")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "api-version", valid_564235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564236: Call_BandwidthSchedulesDelete_564228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified bandwidth schedule.
  ## 
  let valid = call_564236.validator(path, query, header, formData, body)
  let scheme = call_564236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564236.url(scheme.get, call_564236.host, call_564236.base,
                         call_564236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564236, url, valid)

proc call*(call_564237: Call_BandwidthSchedulesDelete_564228; apiVersion: string;
          name: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string): Recallable =
  ## bandwidthSchedulesDelete
  ## Deletes the specified bandwidth schedule.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The bandwidth schedule name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564238 = newJObject()
  var query_564239 = newJObject()
  add(query_564239, "api-version", newJString(apiVersion))
  add(path_564238, "name", newJString(name))
  add(path_564238, "subscriptionId", newJString(subscriptionId))
  add(path_564238, "deviceName", newJString(deviceName))
  add(path_564238, "resourceGroupName", newJString(resourceGroupName))
  result = call_564237.call(path_564238, query_564239, nil, nil, nil)

var bandwidthSchedulesDelete* = Call_BandwidthSchedulesDelete_564228(
    name: "bandwidthSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/bandwidthSchedules/{name}",
    validator: validate_BandwidthSchedulesDelete_564229, base: "",
    url: url_BandwidthSchedulesDelete_564230, schemes: {Scheme.Https})
type
  Call_DevicesDownloadUpdates_564240 = ref object of OpenApiRestCall_563564
proc url_DevicesDownloadUpdates_564242(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/downloadUpdates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesDownloadUpdates_564241(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564243 = path.getOrDefault("subscriptionId")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "subscriptionId", valid_564243
  var valid_564244 = path.getOrDefault("deviceName")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "deviceName", valid_564244
  var valid_564245 = path.getOrDefault("resourceGroupName")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "resourceGroupName", valid_564245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_564247: Call_DevicesDownloadUpdates_564240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564247.validator(path, query, header, formData, body)
  let scheme = call_564247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564247.url(scheme.get, call_564247.host, call_564247.base,
                         call_564247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564247, url, valid)

proc call*(call_564248: Call_DevicesDownloadUpdates_564240; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## devicesDownloadUpdates
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564249 = newJObject()
  var query_564250 = newJObject()
  add(query_564250, "api-version", newJString(apiVersion))
  add(path_564249, "subscriptionId", newJString(subscriptionId))
  add(path_564249, "deviceName", newJString(deviceName))
  add(path_564249, "resourceGroupName", newJString(resourceGroupName))
  result = call_564248.call(path_564249, query_564250, nil, nil, nil)

var devicesDownloadUpdates* = Call_DevicesDownloadUpdates_564240(
    name: "devicesDownloadUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/downloadUpdates",
    validator: validate_DevicesDownloadUpdates_564241, base: "",
    url: url_DevicesDownloadUpdates_564242, schemes: {Scheme.Https})
type
  Call_DevicesGetExtendedInformation_564251 = ref object of OpenApiRestCall_563564
proc url_DevicesGetExtendedInformation_564253(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/getExtendedInformation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesGetExtendedInformation_564252(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets additional information for the specified data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564254 = path.getOrDefault("subscriptionId")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "subscriptionId", valid_564254
  var valid_564255 = path.getOrDefault("deviceName")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "deviceName", valid_564255
  var valid_564256 = path.getOrDefault("resourceGroupName")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "resourceGroupName", valid_564256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564257 = query.getOrDefault("api-version")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "api-version", valid_564257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564258: Call_DevicesGetExtendedInformation_564251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets additional information for the specified data box edge/gateway device.
  ## 
  let valid = call_564258.validator(path, query, header, formData, body)
  let scheme = call_564258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564258.url(scheme.get, call_564258.host, call_564258.base,
                         call_564258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564258, url, valid)

proc call*(call_564259: Call_DevicesGetExtendedInformation_564251;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string): Recallable =
  ## devicesGetExtendedInformation
  ## Gets additional information for the specified data box edge/gateway device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564260 = newJObject()
  var query_564261 = newJObject()
  add(query_564261, "api-version", newJString(apiVersion))
  add(path_564260, "subscriptionId", newJString(subscriptionId))
  add(path_564260, "deviceName", newJString(deviceName))
  add(path_564260, "resourceGroupName", newJString(resourceGroupName))
  result = call_564259.call(path_564260, query_564261, nil, nil, nil)

var devicesGetExtendedInformation* = Call_DevicesGetExtendedInformation_564251(
    name: "devicesGetExtendedInformation", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/getExtendedInformation",
    validator: validate_DevicesGetExtendedInformation_564252, base: "",
    url: url_DevicesGetExtendedInformation_564253, schemes: {Scheme.Https})
type
  Call_DevicesInstallUpdates_564262 = ref object of OpenApiRestCall_563564
proc url_DevicesInstallUpdates_564264(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/installUpdates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesInstallUpdates_564263(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564265 = path.getOrDefault("subscriptionId")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "subscriptionId", valid_564265
  var valid_564266 = path.getOrDefault("deviceName")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "deviceName", valid_564266
  var valid_564267 = path.getOrDefault("resourceGroupName")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "resourceGroupName", valid_564267
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564268 = query.getOrDefault("api-version")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "api-version", valid_564268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564269: Call_DevicesInstallUpdates_564262; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564269.validator(path, query, header, formData, body)
  let scheme = call_564269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564269.url(scheme.get, call_564269.host, call_564269.base,
                         call_564269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564269, url, valid)

proc call*(call_564270: Call_DevicesInstallUpdates_564262; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## devicesInstallUpdates
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564271 = newJObject()
  var query_564272 = newJObject()
  add(query_564272, "api-version", newJString(apiVersion))
  add(path_564271, "subscriptionId", newJString(subscriptionId))
  add(path_564271, "deviceName", newJString(deviceName))
  add(path_564271, "resourceGroupName", newJString(resourceGroupName))
  result = call_564270.call(path_564271, query_564272, nil, nil, nil)

var devicesInstallUpdates* = Call_DevicesInstallUpdates_564262(
    name: "devicesInstallUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/installUpdates",
    validator: validate_DevicesInstallUpdates_564263, base: "",
    url: url_DevicesInstallUpdates_564264, schemes: {Scheme.Https})
type
  Call_JobsGet_564273 = ref object of OpenApiRestCall_563564
proc url_JobsGet_564275(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsGet_564274(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The job name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564276 = path.getOrDefault("name")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "name", valid_564276
  var valid_564277 = path.getOrDefault("subscriptionId")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "subscriptionId", valid_564277
  var valid_564278 = path.getOrDefault("deviceName")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "deviceName", valid_564278
  var valid_564279 = path.getOrDefault("resourceGroupName")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "resourceGroupName", valid_564279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564280 = query.getOrDefault("api-version")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "api-version", valid_564280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564281: Call_JobsGet_564273; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564281.validator(path, query, header, formData, body)
  let scheme = call_564281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564281.url(scheme.get, call_564281.host, call_564281.base,
                         call_564281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564281, url, valid)

proc call*(call_564282: Call_JobsGet_564273; apiVersion: string; name: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## jobsGet
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The job name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564283 = newJObject()
  var query_564284 = newJObject()
  add(query_564284, "api-version", newJString(apiVersion))
  add(path_564283, "name", newJString(name))
  add(path_564283, "subscriptionId", newJString(subscriptionId))
  add(path_564283, "deviceName", newJString(deviceName))
  add(path_564283, "resourceGroupName", newJString(resourceGroupName))
  result = call_564282.call(path_564283, query_564284, nil, nil, nil)

var jobsGet* = Call_JobsGet_564273(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/jobs/{name}",
                                validator: validate_JobsGet_564274, base: "",
                                url: url_JobsGet_564275, schemes: {Scheme.Https})
type
  Call_DevicesGetNetworkSettings_564285 = ref object of OpenApiRestCall_563564
proc url_DevicesGetNetworkSettings_564287(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/networkSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesGetNetworkSettings_564286(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the network settings of the specified data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564288 = path.getOrDefault("subscriptionId")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "subscriptionId", valid_564288
  var valid_564289 = path.getOrDefault("deviceName")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "deviceName", valid_564289
  var valid_564290 = path.getOrDefault("resourceGroupName")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "resourceGroupName", valid_564290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564291 = query.getOrDefault("api-version")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "api-version", valid_564291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564292: Call_DevicesGetNetworkSettings_564285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the network settings of the specified data box edge/gateway device.
  ## 
  let valid = call_564292.validator(path, query, header, formData, body)
  let scheme = call_564292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564292.url(scheme.get, call_564292.host, call_564292.base,
                         call_564292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564292, url, valid)

proc call*(call_564293: Call_DevicesGetNetworkSettings_564285; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## devicesGetNetworkSettings
  ## Gets the network settings of the specified data box edge/gateway device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564294 = newJObject()
  var query_564295 = newJObject()
  add(query_564295, "api-version", newJString(apiVersion))
  add(path_564294, "subscriptionId", newJString(subscriptionId))
  add(path_564294, "deviceName", newJString(deviceName))
  add(path_564294, "resourceGroupName", newJString(resourceGroupName))
  result = call_564293.call(path_564294, query_564295, nil, nil, nil)

var devicesGetNetworkSettings* = Call_DevicesGetNetworkSettings_564285(
    name: "devicesGetNetworkSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/networkSettings/default",
    validator: validate_DevicesGetNetworkSettings_564286, base: "",
    url: url_DevicesGetNetworkSettings_564287, schemes: {Scheme.Https})
type
  Call_OperationsStatusGet_564296 = ref object of OpenApiRestCall_563564
proc url_OperationsStatusGet_564298(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/operationsStatus/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationsStatusGet_564297(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The job name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564299 = path.getOrDefault("name")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "name", valid_564299
  var valid_564300 = path.getOrDefault("subscriptionId")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "subscriptionId", valid_564300
  var valid_564301 = path.getOrDefault("deviceName")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "deviceName", valid_564301
  var valid_564302 = path.getOrDefault("resourceGroupName")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "resourceGroupName", valid_564302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564303 = query.getOrDefault("api-version")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "api-version", valid_564303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564304: Call_OperationsStatusGet_564296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564304.validator(path, query, header, formData, body)
  let scheme = call_564304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564304.url(scheme.get, call_564304.host, call_564304.base,
                         call_564304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564304, url, valid)

proc call*(call_564305: Call_OperationsStatusGet_564296; apiVersion: string;
          name: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string): Recallable =
  ## operationsStatusGet
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The job name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564306 = newJObject()
  var query_564307 = newJObject()
  add(query_564307, "api-version", newJString(apiVersion))
  add(path_564306, "name", newJString(name))
  add(path_564306, "subscriptionId", newJString(subscriptionId))
  add(path_564306, "deviceName", newJString(deviceName))
  add(path_564306, "resourceGroupName", newJString(resourceGroupName))
  result = call_564305.call(path_564306, query_564307, nil, nil, nil)

var operationsStatusGet* = Call_OperationsStatusGet_564296(
    name: "operationsStatusGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/operationsStatus/{name}",
    validator: validate_OperationsStatusGet_564297, base: "",
    url: url_OperationsStatusGet_564298, schemes: {Scheme.Https})
type
  Call_OrdersListByDataBoxEdgeDevice_564308 = ref object of OpenApiRestCall_563564
proc url_OrdersListByDataBoxEdgeDevice_564310(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/orders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OrdersListByDataBoxEdgeDevice_564309(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564311 = path.getOrDefault("subscriptionId")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "subscriptionId", valid_564311
  var valid_564312 = path.getOrDefault("deviceName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "deviceName", valid_564312
  var valid_564313 = path.getOrDefault("resourceGroupName")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "resourceGroupName", valid_564313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564314 = query.getOrDefault("api-version")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "api-version", valid_564314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564315: Call_OrdersListByDataBoxEdgeDevice_564308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564315.validator(path, query, header, formData, body)
  let scheme = call_564315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564315.url(scheme.get, call_564315.host, call_564315.base,
                         call_564315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564315, url, valid)

proc call*(call_564316: Call_OrdersListByDataBoxEdgeDevice_564308;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string): Recallable =
  ## ordersListByDataBoxEdgeDevice
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564317 = newJObject()
  var query_564318 = newJObject()
  add(query_564318, "api-version", newJString(apiVersion))
  add(path_564317, "subscriptionId", newJString(subscriptionId))
  add(path_564317, "deviceName", newJString(deviceName))
  add(path_564317, "resourceGroupName", newJString(resourceGroupName))
  result = call_564316.call(path_564317, query_564318, nil, nil, nil)

var ordersListByDataBoxEdgeDevice* = Call_OrdersListByDataBoxEdgeDevice_564308(
    name: "ordersListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/orders",
    validator: validate_OrdersListByDataBoxEdgeDevice_564309, base: "",
    url: url_OrdersListByDataBoxEdgeDevice_564310, schemes: {Scheme.Https})
type
  Call_OrdersCreateOrUpdate_564330 = ref object of OpenApiRestCall_563564
proc url_OrdersCreateOrUpdate_564332(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/orders/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OrdersCreateOrUpdate_564331(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564336 = query.getOrDefault("api-version")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "api-version", valid_564336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   order: JObject (required)
  ##        : The order to be created or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564338: Call_OrdersCreateOrUpdate_564330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564338.validator(path, query, header, formData, body)
  let scheme = call_564338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564338.url(scheme.get, call_564338.host, call_564338.base,
                         call_564338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564338, url, valid)

proc call*(call_564339: Call_OrdersCreateOrUpdate_564330; apiVersion: string;
          order: JsonNode; subscriptionId: string; deviceName: string;
          resourceGroupName: string): Recallable =
  ## ordersCreateOrUpdate
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   order: JObject (required)
  ##        : The order to be created or updated.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564340 = newJObject()
  var query_564341 = newJObject()
  var body_564342 = newJObject()
  add(query_564341, "api-version", newJString(apiVersion))
  if order != nil:
    body_564342 = order
  add(path_564340, "subscriptionId", newJString(subscriptionId))
  add(path_564340, "deviceName", newJString(deviceName))
  add(path_564340, "resourceGroupName", newJString(resourceGroupName))
  result = call_564339.call(path_564340, query_564341, nil, nil, body_564342)

var ordersCreateOrUpdate* = Call_OrdersCreateOrUpdate_564330(
    name: "ordersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/orders/default",
    validator: validate_OrdersCreateOrUpdate_564331, base: "",
    url: url_OrdersCreateOrUpdate_564332, schemes: {Scheme.Https})
type
  Call_OrdersGet_564319 = ref object of OpenApiRestCall_563564
proc url_OrdersGet_564321(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/orders/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OrdersGet_564320(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564322 = path.getOrDefault("subscriptionId")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "subscriptionId", valid_564322
  var valid_564323 = path.getOrDefault("deviceName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "deviceName", valid_564323
  var valid_564324 = path.getOrDefault("resourceGroupName")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "resourceGroupName", valid_564324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_564326: Call_OrdersGet_564319; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564326.validator(path, query, header, formData, body)
  let scheme = call_564326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564326.url(scheme.get, call_564326.host, call_564326.base,
                         call_564326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564326, url, valid)

proc call*(call_564327: Call_OrdersGet_564319; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## ordersGet
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564328 = newJObject()
  var query_564329 = newJObject()
  add(query_564329, "api-version", newJString(apiVersion))
  add(path_564328, "subscriptionId", newJString(subscriptionId))
  add(path_564328, "deviceName", newJString(deviceName))
  add(path_564328, "resourceGroupName", newJString(resourceGroupName))
  result = call_564327.call(path_564328, query_564329, nil, nil, nil)

var ordersGet* = Call_OrdersGet_564319(name: "ordersGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/orders/default",
                                    validator: validate_OrdersGet_564320,
                                    base: "", url: url_OrdersGet_564321,
                                    schemes: {Scheme.Https})
type
  Call_OrdersDelete_564343 = ref object of OpenApiRestCall_563564
proc url_OrdersDelete_564345(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/orders/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OrdersDelete_564344(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564346 = path.getOrDefault("subscriptionId")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "subscriptionId", valid_564346
  var valid_564347 = path.getOrDefault("deviceName")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "deviceName", valid_564347
  var valid_564348 = path.getOrDefault("resourceGroupName")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "resourceGroupName", valid_564348
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564349 = query.getOrDefault("api-version")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "api-version", valid_564349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564350: Call_OrdersDelete_564343; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564350.validator(path, query, header, formData, body)
  let scheme = call_564350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564350.url(scheme.get, call_564350.host, call_564350.base,
                         call_564350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564350, url, valid)

proc call*(call_564351: Call_OrdersDelete_564343; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## ordersDelete
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564352 = newJObject()
  var query_564353 = newJObject()
  add(query_564353, "api-version", newJString(apiVersion))
  add(path_564352, "subscriptionId", newJString(subscriptionId))
  add(path_564352, "deviceName", newJString(deviceName))
  add(path_564352, "resourceGroupName", newJString(resourceGroupName))
  result = call_564351.call(path_564352, query_564353, nil, nil, nil)

var ordersDelete* = Call_OrdersDelete_564343(name: "ordersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/orders/default",
    validator: validate_OrdersDelete_564344, base: "", url: url_OrdersDelete_564345,
    schemes: {Scheme.Https})
type
  Call_RolesListByDataBoxEdgeDevice_564354 = ref object of OpenApiRestCall_563564
proc url_RolesListByDataBoxEdgeDevice_564356(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RolesListByDataBoxEdgeDevice_564355(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the roles configured in a data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564357 = path.getOrDefault("subscriptionId")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "subscriptionId", valid_564357
  var valid_564358 = path.getOrDefault("deviceName")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "deviceName", valid_564358
  var valid_564359 = path.getOrDefault("resourceGroupName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "resourceGroupName", valid_564359
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564360 = query.getOrDefault("api-version")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "api-version", valid_564360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564361: Call_RolesListByDataBoxEdgeDevice_564354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the roles configured in a data box edge/gateway device.
  ## 
  let valid = call_564361.validator(path, query, header, formData, body)
  let scheme = call_564361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564361.url(scheme.get, call_564361.host, call_564361.base,
                         call_564361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564361, url, valid)

proc call*(call_564362: Call_RolesListByDataBoxEdgeDevice_564354;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string): Recallable =
  ## rolesListByDataBoxEdgeDevice
  ## Lists all the roles configured in a data box edge/gateway device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564363 = newJObject()
  var query_564364 = newJObject()
  add(query_564364, "api-version", newJString(apiVersion))
  add(path_564363, "subscriptionId", newJString(subscriptionId))
  add(path_564363, "deviceName", newJString(deviceName))
  add(path_564363, "resourceGroupName", newJString(resourceGroupName))
  result = call_564362.call(path_564363, query_564364, nil, nil, nil)

var rolesListByDataBoxEdgeDevice* = Call_RolesListByDataBoxEdgeDevice_564354(
    name: "rolesListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/roles",
    validator: validate_RolesListByDataBoxEdgeDevice_564355, base: "",
    url: url_RolesListByDataBoxEdgeDevice_564356, schemes: {Scheme.Https})
type
  Call_RolesCreateOrUpdate_564377 = ref object of OpenApiRestCall_563564
proc url_RolesCreateOrUpdate_564379(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RolesCreateOrUpdate_564378(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create or update a role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The role name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564380 = path.getOrDefault("name")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "name", valid_564380
  var valid_564381 = path.getOrDefault("subscriptionId")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "subscriptionId", valid_564381
  var valid_564382 = path.getOrDefault("deviceName")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "deviceName", valid_564382
  var valid_564383 = path.getOrDefault("resourceGroupName")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "resourceGroupName", valid_564383
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  ##   role: JObject (required)
  ##       : The role properties.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564386: Call_RolesCreateOrUpdate_564377; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a role.
  ## 
  let valid = call_564386.validator(path, query, header, formData, body)
  let scheme = call_564386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564386.url(scheme.get, call_564386.host, call_564386.base,
                         call_564386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564386, url, valid)

proc call*(call_564387: Call_RolesCreateOrUpdate_564377; apiVersion: string;
          role: JsonNode; name: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string): Recallable =
  ## rolesCreateOrUpdate
  ## Create or update a role.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   role: JObject (required)
  ##       : The role properties.
  ##   name: string (required)
  ##       : The role name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564388 = newJObject()
  var query_564389 = newJObject()
  var body_564390 = newJObject()
  add(query_564389, "api-version", newJString(apiVersion))
  if role != nil:
    body_564390 = role
  add(path_564388, "name", newJString(name))
  add(path_564388, "subscriptionId", newJString(subscriptionId))
  add(path_564388, "deviceName", newJString(deviceName))
  add(path_564388, "resourceGroupName", newJString(resourceGroupName))
  result = call_564387.call(path_564388, query_564389, nil, nil, body_564390)

var rolesCreateOrUpdate* = Call_RolesCreateOrUpdate_564377(
    name: "rolesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/roles/{name}",
    validator: validate_RolesCreateOrUpdate_564378, base: "",
    url: url_RolesCreateOrUpdate_564379, schemes: {Scheme.Https})
type
  Call_RolesGet_564365 = ref object of OpenApiRestCall_563564
proc url_RolesGet_564367(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RolesGet_564366(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a specific role by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The role name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564368 = path.getOrDefault("name")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "name", valid_564368
  var valid_564369 = path.getOrDefault("subscriptionId")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "subscriptionId", valid_564369
  var valid_564370 = path.getOrDefault("deviceName")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "deviceName", valid_564370
  var valid_564371 = path.getOrDefault("resourceGroupName")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "resourceGroupName", valid_564371
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_564373: Call_RolesGet_564365; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific role by name.
  ## 
  let valid = call_564373.validator(path, query, header, formData, body)
  let scheme = call_564373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564373.url(scheme.get, call_564373.host, call_564373.base,
                         call_564373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564373, url, valid)

proc call*(call_564374: Call_RolesGet_564365; apiVersion: string; name: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## rolesGet
  ## Gets a specific role by name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The role name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564375 = newJObject()
  var query_564376 = newJObject()
  add(query_564376, "api-version", newJString(apiVersion))
  add(path_564375, "name", newJString(name))
  add(path_564375, "subscriptionId", newJString(subscriptionId))
  add(path_564375, "deviceName", newJString(deviceName))
  add(path_564375, "resourceGroupName", newJString(resourceGroupName))
  result = call_564374.call(path_564375, query_564376, nil, nil, nil)

var rolesGet* = Call_RolesGet_564365(name: "rolesGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/roles/{name}",
                                  validator: validate_RolesGet_564366, base: "",
                                  url: url_RolesGet_564367,
                                  schemes: {Scheme.Https})
type
  Call_RolesDelete_564391 = ref object of OpenApiRestCall_563564
proc url_RolesDelete_564393(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RolesDelete_564392(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the role on the data box edge device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The role name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564394 = path.getOrDefault("name")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "name", valid_564394
  var valid_564395 = path.getOrDefault("subscriptionId")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "subscriptionId", valid_564395
  var valid_564396 = path.getOrDefault("deviceName")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "deviceName", valid_564396
  var valid_564397 = path.getOrDefault("resourceGroupName")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "resourceGroupName", valid_564397
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_564399: Call_RolesDelete_564391; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the role on the data box edge device.
  ## 
  let valid = call_564399.validator(path, query, header, formData, body)
  let scheme = call_564399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564399.url(scheme.get, call_564399.host, call_564399.base,
                         call_564399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564399, url, valid)

proc call*(call_564400: Call_RolesDelete_564391; apiVersion: string; name: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## rolesDelete
  ## Deletes the role on the data box edge device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The role name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564401 = newJObject()
  var query_564402 = newJObject()
  add(query_564402, "api-version", newJString(apiVersion))
  add(path_564401, "name", newJString(name))
  add(path_564401, "subscriptionId", newJString(subscriptionId))
  add(path_564401, "deviceName", newJString(deviceName))
  add(path_564401, "resourceGroupName", newJString(resourceGroupName))
  result = call_564400.call(path_564401, query_564402, nil, nil, nil)

var rolesDelete* = Call_RolesDelete_564391(name: "rolesDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/roles/{name}",
                                        validator: validate_RolesDelete_564392,
                                        base: "", url: url_RolesDelete_564393,
                                        schemes: {Scheme.Https})
type
  Call_DevicesScanForUpdates_564403 = ref object of OpenApiRestCall_563564
proc url_DevicesScanForUpdates_564405(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/scanForUpdates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesScanForUpdates_564404(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564409 = query.getOrDefault("api-version")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "api-version", valid_564409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564410: Call_DevicesScanForUpdates_564403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564410.validator(path, query, header, formData, body)
  let scheme = call_564410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564410.url(scheme.get, call_564410.host, call_564410.base,
                         call_564410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564410, url, valid)

proc call*(call_564411: Call_DevicesScanForUpdates_564403; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## devicesScanForUpdates
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564412 = newJObject()
  var query_564413 = newJObject()
  add(query_564413, "api-version", newJString(apiVersion))
  add(path_564412, "subscriptionId", newJString(subscriptionId))
  add(path_564412, "deviceName", newJString(deviceName))
  add(path_564412, "resourceGroupName", newJString(resourceGroupName))
  result = call_564411.call(path_564412, query_564413, nil, nil, nil)

var devicesScanForUpdates* = Call_DevicesScanForUpdates_564403(
    name: "devicesScanForUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/scanForUpdates",
    validator: validate_DevicesScanForUpdates_564404, base: "",
    url: url_DevicesScanForUpdates_564405, schemes: {Scheme.Https})
type
  Call_DevicesCreateOrUpdateSecuritySettings_564414 = ref object of OpenApiRestCall_563564
proc url_DevicesCreateOrUpdateSecuritySettings_564416(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"), (kind: ConstantSegment,
        value: "/securitySettings/default/update")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesCreateOrUpdateSecuritySettings_564415(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the security settings on a data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564417 = path.getOrDefault("subscriptionId")
  valid_564417 = validateParameter(valid_564417, JString, required = true,
                                 default = nil)
  if valid_564417 != nil:
    section.add "subscriptionId", valid_564417
  var valid_564418 = path.getOrDefault("deviceName")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "deviceName", valid_564418
  var valid_564419 = path.getOrDefault("resourceGroupName")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = nil)
  if valid_564419 != nil:
    section.add "resourceGroupName", valid_564419
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564420 = query.getOrDefault("api-version")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "api-version", valid_564420
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

proc call*(call_564422: Call_DevicesCreateOrUpdateSecuritySettings_564414;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the security settings on a data box edge/gateway device.
  ## 
  let valid = call_564422.validator(path, query, header, formData, body)
  let scheme = call_564422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564422.url(scheme.get, call_564422.host, call_564422.base,
                         call_564422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564422, url, valid)

proc call*(call_564423: Call_DevicesCreateOrUpdateSecuritySettings_564414;
          securitySettings: JsonNode; apiVersion: string; subscriptionId: string;
          deviceName: string; resourceGroupName: string): Recallable =
  ## devicesCreateOrUpdateSecuritySettings
  ## Updates the security settings on a data box edge/gateway device.
  ##   securitySettings: JObject (required)
  ##                   : The security settings.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564424 = newJObject()
  var query_564425 = newJObject()
  var body_564426 = newJObject()
  if securitySettings != nil:
    body_564426 = securitySettings
  add(query_564425, "api-version", newJString(apiVersion))
  add(path_564424, "subscriptionId", newJString(subscriptionId))
  add(path_564424, "deviceName", newJString(deviceName))
  add(path_564424, "resourceGroupName", newJString(resourceGroupName))
  result = call_564423.call(path_564424, query_564425, nil, nil, body_564426)

var devicesCreateOrUpdateSecuritySettings* = Call_DevicesCreateOrUpdateSecuritySettings_564414(
    name: "devicesCreateOrUpdateSecuritySettings", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/securitySettings/default/update",
    validator: validate_DevicesCreateOrUpdateSecuritySettings_564415, base: "",
    url: url_DevicesCreateOrUpdateSecuritySettings_564416, schemes: {Scheme.Https})
type
  Call_SharesListByDataBoxEdgeDevice_564427 = ref object of OpenApiRestCall_563564
proc url_SharesListByDataBoxEdgeDevice_564429(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/shares")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SharesListByDataBoxEdgeDevice_564428(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564430 = path.getOrDefault("subscriptionId")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "subscriptionId", valid_564430
  var valid_564431 = path.getOrDefault("deviceName")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "deviceName", valid_564431
  var valid_564432 = path.getOrDefault("resourceGroupName")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "resourceGroupName", valid_564432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564434: Call_SharesListByDataBoxEdgeDevice_564427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564434.validator(path, query, header, formData, body)
  let scheme = call_564434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564434.url(scheme.get, call_564434.host, call_564434.base,
                         call_564434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564434, url, valid)

proc call*(call_564435: Call_SharesListByDataBoxEdgeDevice_564427;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string): Recallable =
  ## sharesListByDataBoxEdgeDevice
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564436 = newJObject()
  var query_564437 = newJObject()
  add(query_564437, "api-version", newJString(apiVersion))
  add(path_564436, "subscriptionId", newJString(subscriptionId))
  add(path_564436, "deviceName", newJString(deviceName))
  add(path_564436, "resourceGroupName", newJString(resourceGroupName))
  result = call_564435.call(path_564436, query_564437, nil, nil, nil)

var sharesListByDataBoxEdgeDevice* = Call_SharesListByDataBoxEdgeDevice_564427(
    name: "sharesListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares",
    validator: validate_SharesListByDataBoxEdgeDevice_564428, base: "",
    url: url_SharesListByDataBoxEdgeDevice_564429, schemes: {Scheme.Https})
type
  Call_SharesCreateOrUpdate_564450 = ref object of OpenApiRestCall_563564
proc url_SharesCreateOrUpdate_564452(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SharesCreateOrUpdate_564451(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The share name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564453 = path.getOrDefault("name")
  valid_564453 = validateParameter(valid_564453, JString, required = true,
                                 default = nil)
  if valid_564453 != nil:
    section.add "name", valid_564453
  var valid_564454 = path.getOrDefault("subscriptionId")
  valid_564454 = validateParameter(valid_564454, JString, required = true,
                                 default = nil)
  if valid_564454 != nil:
    section.add "subscriptionId", valid_564454
  var valid_564455 = path.getOrDefault("deviceName")
  valid_564455 = validateParameter(valid_564455, JString, required = true,
                                 default = nil)
  if valid_564455 != nil:
    section.add "deviceName", valid_564455
  var valid_564456 = path.getOrDefault("resourceGroupName")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "resourceGroupName", valid_564456
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564457 = query.getOrDefault("api-version")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "api-version", valid_564457
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   share: JObject (required)
  ##        : The share properties.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564459: Call_SharesCreateOrUpdate_564450; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564459.validator(path, query, header, formData, body)
  let scheme = call_564459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564459.url(scheme.get, call_564459.host, call_564459.base,
                         call_564459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564459, url, valid)

proc call*(call_564460: Call_SharesCreateOrUpdate_564450; apiVersion: string;
          name: string; subscriptionId: string; share: JsonNode; deviceName: string;
          resourceGroupName: string): Recallable =
  ## sharesCreateOrUpdate
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The share name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   share: JObject (required)
  ##        : The share properties.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564461 = newJObject()
  var query_564462 = newJObject()
  var body_564463 = newJObject()
  add(query_564462, "api-version", newJString(apiVersion))
  add(path_564461, "name", newJString(name))
  add(path_564461, "subscriptionId", newJString(subscriptionId))
  if share != nil:
    body_564463 = share
  add(path_564461, "deviceName", newJString(deviceName))
  add(path_564461, "resourceGroupName", newJString(resourceGroupName))
  result = call_564460.call(path_564461, query_564462, nil, nil, body_564463)

var sharesCreateOrUpdate* = Call_SharesCreateOrUpdate_564450(
    name: "sharesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares/{name}",
    validator: validate_SharesCreateOrUpdate_564451, base: "",
    url: url_SharesCreateOrUpdate_564452, schemes: {Scheme.Https})
type
  Call_SharesGet_564438 = ref object of OpenApiRestCall_563564
proc url_SharesGet_564440(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SharesGet_564439(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The share name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564441 = path.getOrDefault("name")
  valid_564441 = validateParameter(valid_564441, JString, required = true,
                                 default = nil)
  if valid_564441 != nil:
    section.add "name", valid_564441
  var valid_564442 = path.getOrDefault("subscriptionId")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "subscriptionId", valid_564442
  var valid_564443 = path.getOrDefault("deviceName")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "deviceName", valid_564443
  var valid_564444 = path.getOrDefault("resourceGroupName")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "resourceGroupName", valid_564444
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564445 = query.getOrDefault("api-version")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "api-version", valid_564445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564446: Call_SharesGet_564438; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564446.validator(path, query, header, formData, body)
  let scheme = call_564446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564446.url(scheme.get, call_564446.host, call_564446.base,
                         call_564446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564446, url, valid)

proc call*(call_564447: Call_SharesGet_564438; apiVersion: string; name: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## sharesGet
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The share name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564448 = newJObject()
  var query_564449 = newJObject()
  add(query_564449, "api-version", newJString(apiVersion))
  add(path_564448, "name", newJString(name))
  add(path_564448, "subscriptionId", newJString(subscriptionId))
  add(path_564448, "deviceName", newJString(deviceName))
  add(path_564448, "resourceGroupName", newJString(resourceGroupName))
  result = call_564447.call(path_564448, query_564449, nil, nil, nil)

var sharesGet* = Call_SharesGet_564438(name: "sharesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares/{name}",
                                    validator: validate_SharesGet_564439,
                                    base: "", url: url_SharesGet_564440,
                                    schemes: {Scheme.Https})
type
  Call_SharesDelete_564464 = ref object of OpenApiRestCall_563564
proc url_SharesDelete_564466(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SharesDelete_564465(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the share on the data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The share name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564467 = path.getOrDefault("name")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "name", valid_564467
  var valid_564468 = path.getOrDefault("subscriptionId")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "subscriptionId", valid_564468
  var valid_564469 = path.getOrDefault("deviceName")
  valid_564469 = validateParameter(valid_564469, JString, required = true,
                                 default = nil)
  if valid_564469 != nil:
    section.add "deviceName", valid_564469
  var valid_564470 = path.getOrDefault("resourceGroupName")
  valid_564470 = validateParameter(valid_564470, JString, required = true,
                                 default = nil)
  if valid_564470 != nil:
    section.add "resourceGroupName", valid_564470
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564471 = query.getOrDefault("api-version")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "api-version", valid_564471
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564472: Call_SharesDelete_564464; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the share on the data box edge/gateway device.
  ## 
  let valid = call_564472.validator(path, query, header, formData, body)
  let scheme = call_564472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564472.url(scheme.get, call_564472.host, call_564472.base,
                         call_564472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564472, url, valid)

proc call*(call_564473: Call_SharesDelete_564464; apiVersion: string; name: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## sharesDelete
  ## Deletes the share on the data box edge/gateway device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The share name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564474 = newJObject()
  var query_564475 = newJObject()
  add(query_564475, "api-version", newJString(apiVersion))
  add(path_564474, "name", newJString(name))
  add(path_564474, "subscriptionId", newJString(subscriptionId))
  add(path_564474, "deviceName", newJString(deviceName))
  add(path_564474, "resourceGroupName", newJString(resourceGroupName))
  result = call_564473.call(path_564474, query_564475, nil, nil, nil)

var sharesDelete* = Call_SharesDelete_564464(name: "sharesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares/{name}",
    validator: validate_SharesDelete_564465, base: "", url: url_SharesDelete_564466,
    schemes: {Scheme.Https})
type
  Call_SharesRefresh_564476 = ref object of OpenApiRestCall_563564
proc url_SharesRefresh_564478(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/refresh")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SharesRefresh_564477(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The share name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564479 = path.getOrDefault("name")
  valid_564479 = validateParameter(valid_564479, JString, required = true,
                                 default = nil)
  if valid_564479 != nil:
    section.add "name", valid_564479
  var valid_564480 = path.getOrDefault("subscriptionId")
  valid_564480 = validateParameter(valid_564480, JString, required = true,
                                 default = nil)
  if valid_564480 != nil:
    section.add "subscriptionId", valid_564480
  var valid_564481 = path.getOrDefault("deviceName")
  valid_564481 = validateParameter(valid_564481, JString, required = true,
                                 default = nil)
  if valid_564481 != nil:
    section.add "deviceName", valid_564481
  var valid_564482 = path.getOrDefault("resourceGroupName")
  valid_564482 = validateParameter(valid_564482, JString, required = true,
                                 default = nil)
  if valid_564482 != nil:
    section.add "resourceGroupName", valid_564482
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564483 = query.getOrDefault("api-version")
  valid_564483 = validateParameter(valid_564483, JString, required = true,
                                 default = nil)
  if valid_564483 != nil:
    section.add "api-version", valid_564483
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564484: Call_SharesRefresh_564476; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564484.validator(path, query, header, formData, body)
  let scheme = call_564484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564484.url(scheme.get, call_564484.host, call_564484.base,
                         call_564484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564484, url, valid)

proc call*(call_564485: Call_SharesRefresh_564476; apiVersion: string; name: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## sharesRefresh
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The share name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564486 = newJObject()
  var query_564487 = newJObject()
  add(query_564487, "api-version", newJString(apiVersion))
  add(path_564486, "name", newJString(name))
  add(path_564486, "subscriptionId", newJString(subscriptionId))
  add(path_564486, "deviceName", newJString(deviceName))
  add(path_564486, "resourceGroupName", newJString(resourceGroupName))
  result = call_564485.call(path_564486, query_564487, nil, nil, nil)

var sharesRefresh* = Call_SharesRefresh_564476(name: "sharesRefresh",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares/{name}/refresh",
    validator: validate_SharesRefresh_564477, base: "", url: url_SharesRefresh_564478,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsListByDataBoxEdgeDevice_564488 = ref object of OpenApiRestCall_563564
proc url_StorageAccountCredentialsListByDataBoxEdgeDevice_564490(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/storageAccountCredentials")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountCredentialsListByDataBoxEdgeDevice_564489(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564491 = path.getOrDefault("subscriptionId")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "subscriptionId", valid_564491
  var valid_564492 = path.getOrDefault("deviceName")
  valid_564492 = validateParameter(valid_564492, JString, required = true,
                                 default = nil)
  if valid_564492 != nil:
    section.add "deviceName", valid_564492
  var valid_564493 = path.getOrDefault("resourceGroupName")
  valid_564493 = validateParameter(valid_564493, JString, required = true,
                                 default = nil)
  if valid_564493 != nil:
    section.add "resourceGroupName", valid_564493
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564494 = query.getOrDefault("api-version")
  valid_564494 = validateParameter(valid_564494, JString, required = true,
                                 default = nil)
  if valid_564494 != nil:
    section.add "api-version", valid_564494
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564495: Call_StorageAccountCredentialsListByDataBoxEdgeDevice_564488;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_564495.validator(path, query, header, formData, body)
  let scheme = call_564495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564495.url(scheme.get, call_564495.host, call_564495.base,
                         call_564495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564495, url, valid)

proc call*(call_564496: Call_StorageAccountCredentialsListByDataBoxEdgeDevice_564488;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string): Recallable =
  ## storageAccountCredentialsListByDataBoxEdgeDevice
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564497 = newJObject()
  var query_564498 = newJObject()
  add(query_564498, "api-version", newJString(apiVersion))
  add(path_564497, "subscriptionId", newJString(subscriptionId))
  add(path_564497, "deviceName", newJString(deviceName))
  add(path_564497, "resourceGroupName", newJString(resourceGroupName))
  result = call_564496.call(path_564497, query_564498, nil, nil, nil)

var storageAccountCredentialsListByDataBoxEdgeDevice* = Call_StorageAccountCredentialsListByDataBoxEdgeDevice_564488(
    name: "storageAccountCredentialsListByDataBoxEdgeDevice",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/storageAccountCredentials",
    validator: validate_StorageAccountCredentialsListByDataBoxEdgeDevice_564489,
    base: "", url: url_StorageAccountCredentialsListByDataBoxEdgeDevice_564490,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsCreateOrUpdate_564511 = ref object of OpenApiRestCall_563564
proc url_StorageAccountCredentialsCreateOrUpdate_564513(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/storageAccountCredentials/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountCredentialsCreateOrUpdate_564512(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the storage account credential.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The storage account credential name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564514 = path.getOrDefault("name")
  valid_564514 = validateParameter(valid_564514, JString, required = true,
                                 default = nil)
  if valid_564514 != nil:
    section.add "name", valid_564514
  var valid_564515 = path.getOrDefault("subscriptionId")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = nil)
  if valid_564515 != nil:
    section.add "subscriptionId", valid_564515
  var valid_564516 = path.getOrDefault("deviceName")
  valid_564516 = validateParameter(valid_564516, JString, required = true,
                                 default = nil)
  if valid_564516 != nil:
    section.add "deviceName", valid_564516
  var valid_564517 = path.getOrDefault("resourceGroupName")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "resourceGroupName", valid_564517
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564518 = query.getOrDefault("api-version")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "api-version", valid_564518
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   storageAccountCredential: JObject (required)
  ##                           : The storage account credential.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564520: Call_StorageAccountCredentialsCreateOrUpdate_564511;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the storage account credential.
  ## 
  let valid = call_564520.validator(path, query, header, formData, body)
  let scheme = call_564520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564520.url(scheme.get, call_564520.host, call_564520.base,
                         call_564520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564520, url, valid)

proc call*(call_564521: Call_StorageAccountCredentialsCreateOrUpdate_564511;
          apiVersion: string; name: string; subscriptionId: string;
          deviceName: string; resourceGroupName: string;
          storageAccountCredential: JsonNode): Recallable =
  ## storageAccountCredentialsCreateOrUpdate
  ## Creates or updates the storage account credential.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The storage account credential name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   storageAccountCredential: JObject (required)
  ##                           : The storage account credential.
  var path_564522 = newJObject()
  var query_564523 = newJObject()
  var body_564524 = newJObject()
  add(query_564523, "api-version", newJString(apiVersion))
  add(path_564522, "name", newJString(name))
  add(path_564522, "subscriptionId", newJString(subscriptionId))
  add(path_564522, "deviceName", newJString(deviceName))
  add(path_564522, "resourceGroupName", newJString(resourceGroupName))
  if storageAccountCredential != nil:
    body_564524 = storageAccountCredential
  result = call_564521.call(path_564522, query_564523, nil, nil, body_564524)

var storageAccountCredentialsCreateOrUpdate* = Call_StorageAccountCredentialsCreateOrUpdate_564511(
    name: "storageAccountCredentialsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/storageAccountCredentials/{name}",
    validator: validate_StorageAccountCredentialsCreateOrUpdate_564512, base: "",
    url: url_StorageAccountCredentialsCreateOrUpdate_564513,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsGet_564499 = ref object of OpenApiRestCall_563564
proc url_StorageAccountCredentialsGet_564501(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/storageAccountCredentials/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountCredentialsGet_564500(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified storage account credential.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The storage account credential name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564502 = path.getOrDefault("name")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "name", valid_564502
  var valid_564503 = path.getOrDefault("subscriptionId")
  valid_564503 = validateParameter(valid_564503, JString, required = true,
                                 default = nil)
  if valid_564503 != nil:
    section.add "subscriptionId", valid_564503
  var valid_564504 = path.getOrDefault("deviceName")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "deviceName", valid_564504
  var valid_564505 = path.getOrDefault("resourceGroupName")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = nil)
  if valid_564505 != nil:
    section.add "resourceGroupName", valid_564505
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564507: Call_StorageAccountCredentialsGet_564499; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified storage account credential.
  ## 
  let valid = call_564507.validator(path, query, header, formData, body)
  let scheme = call_564507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564507.url(scheme.get, call_564507.host, call_564507.base,
                         call_564507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564507, url, valid)

proc call*(call_564508: Call_StorageAccountCredentialsGet_564499;
          apiVersion: string; name: string; subscriptionId: string;
          deviceName: string; resourceGroupName: string): Recallable =
  ## storageAccountCredentialsGet
  ## Gets the properties of the specified storage account credential.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The storage account credential name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564509 = newJObject()
  var query_564510 = newJObject()
  add(query_564510, "api-version", newJString(apiVersion))
  add(path_564509, "name", newJString(name))
  add(path_564509, "subscriptionId", newJString(subscriptionId))
  add(path_564509, "deviceName", newJString(deviceName))
  add(path_564509, "resourceGroupName", newJString(resourceGroupName))
  result = call_564508.call(path_564509, query_564510, nil, nil, nil)

var storageAccountCredentialsGet* = Call_StorageAccountCredentialsGet_564499(
    name: "storageAccountCredentialsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/storageAccountCredentials/{name}",
    validator: validate_StorageAccountCredentialsGet_564500, base: "",
    url: url_StorageAccountCredentialsGet_564501, schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsDelete_564525 = ref object of OpenApiRestCall_563564
proc url_StorageAccountCredentialsDelete_564527(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/storageAccountCredentials/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountCredentialsDelete_564526(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the storage account credential.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The storage account credential name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564528 = path.getOrDefault("name")
  valid_564528 = validateParameter(valid_564528, JString, required = true,
                                 default = nil)
  if valid_564528 != nil:
    section.add "name", valid_564528
  var valid_564529 = path.getOrDefault("subscriptionId")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "subscriptionId", valid_564529
  var valid_564530 = path.getOrDefault("deviceName")
  valid_564530 = validateParameter(valid_564530, JString, required = true,
                                 default = nil)
  if valid_564530 != nil:
    section.add "deviceName", valid_564530
  var valid_564531 = path.getOrDefault("resourceGroupName")
  valid_564531 = validateParameter(valid_564531, JString, required = true,
                                 default = nil)
  if valid_564531 != nil:
    section.add "resourceGroupName", valid_564531
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564532 = query.getOrDefault("api-version")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "api-version", valid_564532
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564533: Call_StorageAccountCredentialsDelete_564525;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the storage account credential.
  ## 
  let valid = call_564533.validator(path, query, header, formData, body)
  let scheme = call_564533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564533.url(scheme.get, call_564533.host, call_564533.base,
                         call_564533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564533, url, valid)

proc call*(call_564534: Call_StorageAccountCredentialsDelete_564525;
          apiVersion: string; name: string; subscriptionId: string;
          deviceName: string; resourceGroupName: string): Recallable =
  ## storageAccountCredentialsDelete
  ## Deletes the storage account credential.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The storage account credential name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564535 = newJObject()
  var query_564536 = newJObject()
  add(query_564536, "api-version", newJString(apiVersion))
  add(path_564535, "name", newJString(name))
  add(path_564535, "subscriptionId", newJString(subscriptionId))
  add(path_564535, "deviceName", newJString(deviceName))
  add(path_564535, "resourceGroupName", newJString(resourceGroupName))
  result = call_564534.call(path_564535, query_564536, nil, nil, nil)

var storageAccountCredentialsDelete* = Call_StorageAccountCredentialsDelete_564525(
    name: "storageAccountCredentialsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/storageAccountCredentials/{name}",
    validator: validate_StorageAccountCredentialsDelete_564526, base: "",
    url: url_StorageAccountCredentialsDelete_564527, schemes: {Scheme.Https})
type
  Call_TriggersListByDataBoxEdgeDevice_564537 = ref object of OpenApiRestCall_563564
proc url_TriggersListByDataBoxEdgeDevice_564539(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/triggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersListByDataBoxEdgeDevice_564538(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the triggers configured in the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564540 = path.getOrDefault("subscriptionId")
  valid_564540 = validateParameter(valid_564540, JString, required = true,
                                 default = nil)
  if valid_564540 != nil:
    section.add "subscriptionId", valid_564540
  var valid_564541 = path.getOrDefault("deviceName")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "deviceName", valid_564541
  var valid_564542 = path.getOrDefault("resourceGroupName")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "resourceGroupName", valid_564542
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $expand: JString
  ##          : Specify $filter='CustomContextTag eq <tag>' to filter on custom context tag property
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564543 = query.getOrDefault("api-version")
  valid_564543 = validateParameter(valid_564543, JString, required = true,
                                 default = nil)
  if valid_564543 != nil:
    section.add "api-version", valid_564543
  var valid_564544 = query.getOrDefault("$expand")
  valid_564544 = validateParameter(valid_564544, JString, required = false,
                                 default = nil)
  if valid_564544 != nil:
    section.add "$expand", valid_564544
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564545: Call_TriggersListByDataBoxEdgeDevice_564537;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the triggers configured in the device.
  ## 
  let valid = call_564545.validator(path, query, header, formData, body)
  let scheme = call_564545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564545.url(scheme.get, call_564545.host, call_564545.base,
                         call_564545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564545, url, valid)

proc call*(call_564546: Call_TriggersListByDataBoxEdgeDevice_564537;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; Expand: string = ""): Recallable =
  ## triggersListByDataBoxEdgeDevice
  ## Lists all the triggers configured in the device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Expand: string
  ##         : Specify $filter='CustomContextTag eq <tag>' to filter on custom context tag property
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564547 = newJObject()
  var query_564548 = newJObject()
  add(query_564548, "api-version", newJString(apiVersion))
  add(query_564548, "$expand", newJString(Expand))
  add(path_564547, "subscriptionId", newJString(subscriptionId))
  add(path_564547, "deviceName", newJString(deviceName))
  add(path_564547, "resourceGroupName", newJString(resourceGroupName))
  result = call_564546.call(path_564547, query_564548, nil, nil, nil)

var triggersListByDataBoxEdgeDevice* = Call_TriggersListByDataBoxEdgeDevice_564537(
    name: "triggersListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/triggers",
    validator: validate_TriggersListByDataBoxEdgeDevice_564538, base: "",
    url: url_TriggersListByDataBoxEdgeDevice_564539, schemes: {Scheme.Https})
type
  Call_TriggersCreateOrUpdate_564561 = ref object of OpenApiRestCall_563564
proc url_TriggersCreateOrUpdate_564563(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersCreateOrUpdate_564562(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The trigger name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : Creates or updates a trigger
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564564 = path.getOrDefault("name")
  valid_564564 = validateParameter(valid_564564, JString, required = true,
                                 default = nil)
  if valid_564564 != nil:
    section.add "name", valid_564564
  var valid_564565 = path.getOrDefault("subscriptionId")
  valid_564565 = validateParameter(valid_564565, JString, required = true,
                                 default = nil)
  if valid_564565 != nil:
    section.add "subscriptionId", valid_564565
  var valid_564566 = path.getOrDefault("deviceName")
  valid_564566 = validateParameter(valid_564566, JString, required = true,
                                 default = nil)
  if valid_564566 != nil:
    section.add "deviceName", valid_564566
  var valid_564567 = path.getOrDefault("resourceGroupName")
  valid_564567 = validateParameter(valid_564567, JString, required = true,
                                 default = nil)
  if valid_564567 != nil:
    section.add "resourceGroupName", valid_564567
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564568 = query.getOrDefault("api-version")
  valid_564568 = validateParameter(valid_564568, JString, required = true,
                                 default = nil)
  if valid_564568 != nil:
    section.add "api-version", valid_564568
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   trigger: JObject (required)
  ##          : The trigger.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564570: Call_TriggersCreateOrUpdate_564561; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a trigger.
  ## 
  let valid = call_564570.validator(path, query, header, formData, body)
  let scheme = call_564570.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564570.url(scheme.get, call_564570.host, call_564570.base,
                         call_564570.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564570, url, valid)

proc call*(call_564571: Call_TriggersCreateOrUpdate_564561; apiVersion: string;
          name: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string; trigger: JsonNode): Recallable =
  ## triggersCreateOrUpdate
  ## Creates or updates a trigger.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The trigger name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : Creates or updates a trigger
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   trigger: JObject (required)
  ##          : The trigger.
  var path_564572 = newJObject()
  var query_564573 = newJObject()
  var body_564574 = newJObject()
  add(query_564573, "api-version", newJString(apiVersion))
  add(path_564572, "name", newJString(name))
  add(path_564572, "subscriptionId", newJString(subscriptionId))
  add(path_564572, "deviceName", newJString(deviceName))
  add(path_564572, "resourceGroupName", newJString(resourceGroupName))
  if trigger != nil:
    body_564574 = trigger
  result = call_564571.call(path_564572, query_564573, nil, nil, body_564574)

var triggersCreateOrUpdate* = Call_TriggersCreateOrUpdate_564561(
    name: "triggersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/triggers/{name}",
    validator: validate_TriggersCreateOrUpdate_564562, base: "",
    url: url_TriggersCreateOrUpdate_564563, schemes: {Scheme.Https})
type
  Call_TriggersGet_564549 = ref object of OpenApiRestCall_563564
proc url_TriggersGet_564551(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersGet_564550(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific trigger by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The trigger name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564552 = path.getOrDefault("name")
  valid_564552 = validateParameter(valid_564552, JString, required = true,
                                 default = nil)
  if valid_564552 != nil:
    section.add "name", valid_564552
  var valid_564553 = path.getOrDefault("subscriptionId")
  valid_564553 = validateParameter(valid_564553, JString, required = true,
                                 default = nil)
  if valid_564553 != nil:
    section.add "subscriptionId", valid_564553
  var valid_564554 = path.getOrDefault("deviceName")
  valid_564554 = validateParameter(valid_564554, JString, required = true,
                                 default = nil)
  if valid_564554 != nil:
    section.add "deviceName", valid_564554
  var valid_564555 = path.getOrDefault("resourceGroupName")
  valid_564555 = validateParameter(valid_564555, JString, required = true,
                                 default = nil)
  if valid_564555 != nil:
    section.add "resourceGroupName", valid_564555
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564556 = query.getOrDefault("api-version")
  valid_564556 = validateParameter(valid_564556, JString, required = true,
                                 default = nil)
  if valid_564556 != nil:
    section.add "api-version", valid_564556
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564557: Call_TriggersGet_564549; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific trigger by name.
  ## 
  let valid = call_564557.validator(path, query, header, formData, body)
  let scheme = call_564557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564557.url(scheme.get, call_564557.host, call_564557.base,
                         call_564557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564557, url, valid)

proc call*(call_564558: Call_TriggersGet_564549; apiVersion: string; name: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## triggersGet
  ## Get a specific trigger by name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The trigger name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564559 = newJObject()
  var query_564560 = newJObject()
  add(query_564560, "api-version", newJString(apiVersion))
  add(path_564559, "name", newJString(name))
  add(path_564559, "subscriptionId", newJString(subscriptionId))
  add(path_564559, "deviceName", newJString(deviceName))
  add(path_564559, "resourceGroupName", newJString(resourceGroupName))
  result = call_564558.call(path_564559, query_564560, nil, nil, nil)

var triggersGet* = Call_TriggersGet_564549(name: "triggersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/triggers/{name}",
                                        validator: validate_TriggersGet_564550,
                                        base: "", url: url_TriggersGet_564551,
                                        schemes: {Scheme.Https})
type
  Call_TriggersDelete_564575 = ref object of OpenApiRestCall_563564
proc url_TriggersDelete_564577(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersDelete_564576(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes the trigger on the gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The trigger name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564578 = path.getOrDefault("name")
  valid_564578 = validateParameter(valid_564578, JString, required = true,
                                 default = nil)
  if valid_564578 != nil:
    section.add "name", valid_564578
  var valid_564579 = path.getOrDefault("subscriptionId")
  valid_564579 = validateParameter(valid_564579, JString, required = true,
                                 default = nil)
  if valid_564579 != nil:
    section.add "subscriptionId", valid_564579
  var valid_564580 = path.getOrDefault("deviceName")
  valid_564580 = validateParameter(valid_564580, JString, required = true,
                                 default = nil)
  if valid_564580 != nil:
    section.add "deviceName", valid_564580
  var valid_564581 = path.getOrDefault("resourceGroupName")
  valid_564581 = validateParameter(valid_564581, JString, required = true,
                                 default = nil)
  if valid_564581 != nil:
    section.add "resourceGroupName", valid_564581
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564582 = query.getOrDefault("api-version")
  valid_564582 = validateParameter(valid_564582, JString, required = true,
                                 default = nil)
  if valid_564582 != nil:
    section.add "api-version", valid_564582
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564583: Call_TriggersDelete_564575; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the trigger on the gateway device.
  ## 
  let valid = call_564583.validator(path, query, header, formData, body)
  let scheme = call_564583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564583.url(scheme.get, call_564583.host, call_564583.base,
                         call_564583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564583, url, valid)

proc call*(call_564584: Call_TriggersDelete_564575; apiVersion: string; name: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## triggersDelete
  ## Deletes the trigger on the gateway device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The trigger name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564585 = newJObject()
  var query_564586 = newJObject()
  add(query_564586, "api-version", newJString(apiVersion))
  add(path_564585, "name", newJString(name))
  add(path_564585, "subscriptionId", newJString(subscriptionId))
  add(path_564585, "deviceName", newJString(deviceName))
  add(path_564585, "resourceGroupName", newJString(resourceGroupName))
  result = call_564584.call(path_564585, query_564586, nil, nil, nil)

var triggersDelete* = Call_TriggersDelete_564575(name: "triggersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/triggers/{name}",
    validator: validate_TriggersDelete_564576, base: "", url: url_TriggersDelete_564577,
    schemes: {Scheme.Https})
type
  Call_DevicesGetUpdateSummary_564587 = ref object of OpenApiRestCall_563564
proc url_DevicesGetUpdateSummary_564589(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/updateSummary/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesGetUpdateSummary_564588(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564590 = path.getOrDefault("subscriptionId")
  valid_564590 = validateParameter(valid_564590, JString, required = true,
                                 default = nil)
  if valid_564590 != nil:
    section.add "subscriptionId", valid_564590
  var valid_564591 = path.getOrDefault("deviceName")
  valid_564591 = validateParameter(valid_564591, JString, required = true,
                                 default = nil)
  if valid_564591 != nil:
    section.add "deviceName", valid_564591
  var valid_564592 = path.getOrDefault("resourceGroupName")
  valid_564592 = validateParameter(valid_564592, JString, required = true,
                                 default = nil)
  if valid_564592 != nil:
    section.add "resourceGroupName", valid_564592
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564593 = query.getOrDefault("api-version")
  valid_564593 = validateParameter(valid_564593, JString, required = true,
                                 default = nil)
  if valid_564593 != nil:
    section.add "api-version", valid_564593
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564594: Call_DevicesGetUpdateSummary_564587; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564594.validator(path, query, header, formData, body)
  let scheme = call_564594.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564594.url(scheme.get, call_564594.host, call_564594.base,
                         call_564594.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564594, url, valid)

proc call*(call_564595: Call_DevicesGetUpdateSummary_564587; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## devicesGetUpdateSummary
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564596 = newJObject()
  var query_564597 = newJObject()
  add(query_564597, "api-version", newJString(apiVersion))
  add(path_564596, "subscriptionId", newJString(subscriptionId))
  add(path_564596, "deviceName", newJString(deviceName))
  add(path_564596, "resourceGroupName", newJString(resourceGroupName))
  result = call_564595.call(path_564596, query_564597, nil, nil, nil)

var devicesGetUpdateSummary* = Call_DevicesGetUpdateSummary_564587(
    name: "devicesGetUpdateSummary", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/updateSummary/default",
    validator: validate_DevicesGetUpdateSummary_564588, base: "",
    url: url_DevicesGetUpdateSummary_564589, schemes: {Scheme.Https})
type
  Call_DevicesUploadCertificate_564598 = ref object of OpenApiRestCall_563564
proc url_DevicesUploadCertificate_564600(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/uploadCertificate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesUploadCertificate_564599(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads registration certificate for the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564601 = path.getOrDefault("subscriptionId")
  valid_564601 = validateParameter(valid_564601, JString, required = true,
                                 default = nil)
  if valid_564601 != nil:
    section.add "subscriptionId", valid_564601
  var valid_564602 = path.getOrDefault("deviceName")
  valid_564602 = validateParameter(valid_564602, JString, required = true,
                                 default = nil)
  if valid_564602 != nil:
    section.add "deviceName", valid_564602
  var valid_564603 = path.getOrDefault("resourceGroupName")
  valid_564603 = validateParameter(valid_564603, JString, required = true,
                                 default = nil)
  if valid_564603 != nil:
    section.add "resourceGroupName", valid_564603
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The upload certificate request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564606: Call_DevicesUploadCertificate_564598; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads registration certificate for the device.
  ## 
  let valid = call_564606.validator(path, query, header, formData, body)
  let scheme = call_564606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564606.url(scheme.get, call_564606.host, call_564606.base,
                         call_564606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564606, url, valid)

proc call*(call_564607: Call_DevicesUploadCertificate_564598; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## devicesUploadCertificate
  ## Uploads registration certificate for the device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   parameters: JObject (required)
  ##             : The upload certificate request.
  var path_564608 = newJObject()
  var query_564609 = newJObject()
  var body_564610 = newJObject()
  add(query_564609, "api-version", newJString(apiVersion))
  add(path_564608, "subscriptionId", newJString(subscriptionId))
  add(path_564608, "deviceName", newJString(deviceName))
  add(path_564608, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564610 = parameters
  result = call_564607.call(path_564608, query_564609, nil, nil, body_564610)

var devicesUploadCertificate* = Call_DevicesUploadCertificate_564598(
    name: "devicesUploadCertificate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/uploadCertificate",
    validator: validate_DevicesUploadCertificate_564599, base: "",
    url: url_DevicesUploadCertificate_564600, schemes: {Scheme.Https})
type
  Call_UsersListByDataBoxEdgeDevice_564611 = ref object of OpenApiRestCall_563564
proc url_UsersListByDataBoxEdgeDevice_564613(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersListByDataBoxEdgeDevice_564612(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the users registered on a data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564614 = path.getOrDefault("subscriptionId")
  valid_564614 = validateParameter(valid_564614, JString, required = true,
                                 default = nil)
  if valid_564614 != nil:
    section.add "subscriptionId", valid_564614
  var valid_564615 = path.getOrDefault("deviceName")
  valid_564615 = validateParameter(valid_564615, JString, required = true,
                                 default = nil)
  if valid_564615 != nil:
    section.add "deviceName", valid_564615
  var valid_564616 = path.getOrDefault("resourceGroupName")
  valid_564616 = validateParameter(valid_564616, JString, required = true,
                                 default = nil)
  if valid_564616 != nil:
    section.add "resourceGroupName", valid_564616
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_564618: Call_UsersListByDataBoxEdgeDevice_564611; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the users registered on a data box edge/gateway device.
  ## 
  let valid = call_564618.validator(path, query, header, formData, body)
  let scheme = call_564618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564618.url(scheme.get, call_564618.host, call_564618.base,
                         call_564618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564618, url, valid)

proc call*(call_564619: Call_UsersListByDataBoxEdgeDevice_564611;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string): Recallable =
  ## usersListByDataBoxEdgeDevice
  ## Gets all the users registered on a data box edge/gateway device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564620 = newJObject()
  var query_564621 = newJObject()
  add(query_564621, "api-version", newJString(apiVersion))
  add(path_564620, "subscriptionId", newJString(subscriptionId))
  add(path_564620, "deviceName", newJString(deviceName))
  add(path_564620, "resourceGroupName", newJString(resourceGroupName))
  result = call_564619.call(path_564620, query_564621, nil, nil, nil)

var usersListByDataBoxEdgeDevice* = Call_UsersListByDataBoxEdgeDevice_564611(
    name: "usersListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/users",
    validator: validate_UsersListByDataBoxEdgeDevice_564612, base: "",
    url: url_UsersListByDataBoxEdgeDevice_564613, schemes: {Scheme.Https})
type
  Call_UsersCreateOrUpdate_564634 = ref object of OpenApiRestCall_563564
proc url_UsersCreateOrUpdate_564636(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersCreateOrUpdate_564635(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a new user or updates an existing user's information on a data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The user name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564637 = path.getOrDefault("name")
  valid_564637 = validateParameter(valid_564637, JString, required = true,
                                 default = nil)
  if valid_564637 != nil:
    section.add "name", valid_564637
  var valid_564638 = path.getOrDefault("subscriptionId")
  valid_564638 = validateParameter(valid_564638, JString, required = true,
                                 default = nil)
  if valid_564638 != nil:
    section.add "subscriptionId", valid_564638
  var valid_564639 = path.getOrDefault("deviceName")
  valid_564639 = validateParameter(valid_564639, JString, required = true,
                                 default = nil)
  if valid_564639 != nil:
    section.add "deviceName", valid_564639
  var valid_564640 = path.getOrDefault("resourceGroupName")
  valid_564640 = validateParameter(valid_564640, JString, required = true,
                                 default = nil)
  if valid_564640 != nil:
    section.add "resourceGroupName", valid_564640
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564641 = query.getOrDefault("api-version")
  valid_564641 = validateParameter(valid_564641, JString, required = true,
                                 default = nil)
  if valid_564641 != nil:
    section.add "api-version", valid_564641
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   user: JObject (required)
  ##       : The user details.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564643: Call_UsersCreateOrUpdate_564634; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new user or updates an existing user's information on a data box edge/gateway device.
  ## 
  let valid = call_564643.validator(path, query, header, formData, body)
  let scheme = call_564643.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564643.url(scheme.get, call_564643.host, call_564643.base,
                         call_564643.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564643, url, valid)

proc call*(call_564644: Call_UsersCreateOrUpdate_564634; apiVersion: string;
          name: string; subscriptionId: string; user: JsonNode; deviceName: string;
          resourceGroupName: string): Recallable =
  ## usersCreateOrUpdate
  ## Creates a new user or updates an existing user's information on a data box edge/gateway device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The user name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   user: JObject (required)
  ##       : The user details.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564645 = newJObject()
  var query_564646 = newJObject()
  var body_564647 = newJObject()
  add(query_564646, "api-version", newJString(apiVersion))
  add(path_564645, "name", newJString(name))
  add(path_564645, "subscriptionId", newJString(subscriptionId))
  if user != nil:
    body_564647 = user
  add(path_564645, "deviceName", newJString(deviceName))
  add(path_564645, "resourceGroupName", newJString(resourceGroupName))
  result = call_564644.call(path_564645, query_564646, nil, nil, body_564647)

var usersCreateOrUpdate* = Call_UsersCreateOrUpdate_564634(
    name: "usersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/users/{name}",
    validator: validate_UsersCreateOrUpdate_564635, base: "",
    url: url_UsersCreateOrUpdate_564636, schemes: {Scheme.Https})
type
  Call_UsersGet_564622 = ref object of OpenApiRestCall_563564
proc url_UsersGet_564624(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersGet_564623(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The user name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564625 = path.getOrDefault("name")
  valid_564625 = validateParameter(valid_564625, JString, required = true,
                                 default = nil)
  if valid_564625 != nil:
    section.add "name", valid_564625
  var valid_564626 = path.getOrDefault("subscriptionId")
  valid_564626 = validateParameter(valid_564626, JString, required = true,
                                 default = nil)
  if valid_564626 != nil:
    section.add "subscriptionId", valid_564626
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564629 = query.getOrDefault("api-version")
  valid_564629 = validateParameter(valid_564629, JString, required = true,
                                 default = nil)
  if valid_564629 != nil:
    section.add "api-version", valid_564629
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564630: Call_UsersGet_564622; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified user.
  ## 
  let valid = call_564630.validator(path, query, header, formData, body)
  let scheme = call_564630.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564630.url(scheme.get, call_564630.host, call_564630.base,
                         call_564630.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564630, url, valid)

proc call*(call_564631: Call_UsersGet_564622; apiVersion: string; name: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## usersGet
  ## Gets the properties of the specified user.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The user name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564632 = newJObject()
  var query_564633 = newJObject()
  add(query_564633, "api-version", newJString(apiVersion))
  add(path_564632, "name", newJString(name))
  add(path_564632, "subscriptionId", newJString(subscriptionId))
  add(path_564632, "deviceName", newJString(deviceName))
  add(path_564632, "resourceGroupName", newJString(resourceGroupName))
  result = call_564631.call(path_564632, query_564633, nil, nil, nil)

var usersGet* = Call_UsersGet_564622(name: "usersGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/users/{name}",
                                  validator: validate_UsersGet_564623, base: "",
                                  url: url_UsersGet_564624,
                                  schemes: {Scheme.Https})
type
  Call_UsersDelete_564648 = ref object of OpenApiRestCall_563564
proc url_UsersDelete_564650(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersDelete_564649(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the user on a databox edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The user name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564651 = path.getOrDefault("name")
  valid_564651 = validateParameter(valid_564651, JString, required = true,
                                 default = nil)
  if valid_564651 != nil:
    section.add "name", valid_564651
  var valid_564652 = path.getOrDefault("subscriptionId")
  valid_564652 = validateParameter(valid_564652, JString, required = true,
                                 default = nil)
  if valid_564652 != nil:
    section.add "subscriptionId", valid_564652
  var valid_564653 = path.getOrDefault("deviceName")
  valid_564653 = validateParameter(valid_564653, JString, required = true,
                                 default = nil)
  if valid_564653 != nil:
    section.add "deviceName", valid_564653
  var valid_564654 = path.getOrDefault("resourceGroupName")
  valid_564654 = validateParameter(valid_564654, JString, required = true,
                                 default = nil)
  if valid_564654 != nil:
    section.add "resourceGroupName", valid_564654
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564655 = query.getOrDefault("api-version")
  valid_564655 = validateParameter(valid_564655, JString, required = true,
                                 default = nil)
  if valid_564655 != nil:
    section.add "api-version", valid_564655
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564656: Call_UsersDelete_564648; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the user on a databox edge/gateway device.
  ## 
  let valid = call_564656.validator(path, query, header, formData, body)
  let scheme = call_564656.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564656.url(scheme.get, call_564656.host, call_564656.base,
                         call_564656.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564656, url, valid)

proc call*(call_564657: Call_UsersDelete_564648; apiVersion: string; name: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## usersDelete
  ## Deletes the user on a databox edge/gateway device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The user name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564658 = newJObject()
  var query_564659 = newJObject()
  add(query_564659, "api-version", newJString(apiVersion))
  add(path_564658, "name", newJString(name))
  add(path_564658, "subscriptionId", newJString(subscriptionId))
  add(path_564658, "deviceName", newJString(deviceName))
  add(path_564658, "resourceGroupName", newJString(resourceGroupName))
  result = call_564657.call(path_564658, query_564659, nil, nil, nil)

var usersDelete* = Call_UsersDelete_564648(name: "usersDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/users/{name}",
                                        validator: validate_UsersDelete_564649,
                                        base: "", url: url_UsersDelete_564650,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
