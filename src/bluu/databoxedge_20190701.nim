
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: DataBoxEdgeManagementClient
## version: 2019-07-01
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
  macServiceName = "databoxedge"
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
  ##   apiVersion: string (required)
  ##             : The API version.
  var query_564045 = newJObject()
  add(query_564045, "api-version", newJString(apiVersion))
  result = call_564044.call(nil, query_564045, nil, nil, nil)

var operationsList* = Call_OperationsList_563787(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataBoxEdge/operations",
    validator: validate_OperationsList_563788, base: "", url: url_OperationsList_563789,
    schemes: {Scheme.Https})
type
  Call_DevicesListBySubscription_564085 = ref object of OpenApiRestCall_563565
proc url_DevicesListBySubscription_564087(protocol: Scheme; host: string;
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

proc validate_DevicesListBySubscription_564086(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the Data Box Edge/Data Box Gateway devices in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564103 = path.getOrDefault("subscriptionId")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "subscriptionId", valid_564103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the resource or Specify $skipToken=<token> to populate the next page in the list.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564104 = query.getOrDefault("api-version")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "api-version", valid_564104
  var valid_564105 = query.getOrDefault("$expand")
  valid_564105 = validateParameter(valid_564105, JString, required = false,
                                 default = nil)
  if valid_564105 != nil:
    section.add "$expand", valid_564105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564106: Call_DevicesListBySubscription_564085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the Data Box Edge/Data Box Gateway devices in a subscription.
  ## 
  let valid = call_564106.validator(path, query, header, formData, body)
  let scheme = call_564106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564106.url(scheme.get, call_564106.host, call_564106.base,
                         call_564106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564106, url, valid)

proc call*(call_564107: Call_DevicesListBySubscription_564085; apiVersion: string;
          subscriptionId: string; Expand: string = ""): Recallable =
  ## devicesListBySubscription
  ## Gets all the Data Box Edge/Data Box Gateway devices in a subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Expand: string
  ##         : Specify $expand=details to populate additional fields related to the resource or Specify $skipToken=<token> to populate the next page in the list.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_564108 = newJObject()
  var query_564109 = newJObject()
  add(query_564109, "api-version", newJString(apiVersion))
  add(query_564109, "$expand", newJString(Expand))
  add(path_564108, "subscriptionId", newJString(subscriptionId))
  result = call_564107.call(path_564108, query_564109, nil, nil, nil)

var devicesListBySubscription* = Call_DevicesListBySubscription_564085(
    name: "devicesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices",
    validator: validate_DevicesListBySubscription_564086, base: "",
    url: url_DevicesListBySubscription_564087, schemes: {Scheme.Https})
type
  Call_DevicesListByResourceGroup_564110 = ref object of OpenApiRestCall_563565
proc url_DevicesListByResourceGroup_564112(protocol: Scheme; host: string;
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

proc validate_DevicesListByResourceGroup_564111(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the Data Box Edge/Data Box Gateway devices in a resource group.
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
  var valid_564113 = path.getOrDefault("subscriptionId")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "subscriptionId", valid_564113
  var valid_564114 = path.getOrDefault("resourceGroupName")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "resourceGroupName", valid_564114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the resource or Specify $skipToken=<token> to populate the next page in the list.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564115 = query.getOrDefault("api-version")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "api-version", valid_564115
  var valid_564116 = query.getOrDefault("$expand")
  valid_564116 = validateParameter(valid_564116, JString, required = false,
                                 default = nil)
  if valid_564116 != nil:
    section.add "$expand", valid_564116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564117: Call_DevicesListByResourceGroup_564110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the Data Box Edge/Data Box Gateway devices in a resource group.
  ## 
  let valid = call_564117.validator(path, query, header, formData, body)
  let scheme = call_564117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564117.url(scheme.get, call_564117.host, call_564117.base,
                         call_564117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564117, url, valid)

proc call*(call_564118: Call_DevicesListByResourceGroup_564110; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; Expand: string = ""): Recallable =
  ## devicesListByResourceGroup
  ## Gets all the Data Box Edge/Data Box Gateway devices in a resource group.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Expand: string
  ##         : Specify $expand=details to populate additional fields related to the resource or Specify $skipToken=<token> to populate the next page in the list.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564119 = newJObject()
  var query_564120 = newJObject()
  add(query_564120, "api-version", newJString(apiVersion))
  add(query_564120, "$expand", newJString(Expand))
  add(path_564119, "subscriptionId", newJString(subscriptionId))
  add(path_564119, "resourceGroupName", newJString(resourceGroupName))
  result = call_564118.call(path_564119, query_564120, nil, nil, nil)

var devicesListByResourceGroup* = Call_DevicesListByResourceGroup_564110(
    name: "devicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices",
    validator: validate_DevicesListByResourceGroup_564111, base: "",
    url: url_DevicesListByResourceGroup_564112, schemes: {Scheme.Https})
type
  Call_DevicesCreateOrUpdate_564132 = ref object of OpenApiRestCall_563565
proc url_DevicesCreateOrUpdate_564134(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesCreateOrUpdate_564133(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a Data Box Edge/Data Box Gateway resource.
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
  var valid_564135 = path.getOrDefault("subscriptionId")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "subscriptionId", valid_564135
  var valid_564136 = path.getOrDefault("deviceName")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "deviceName", valid_564136
  var valid_564137 = path.getOrDefault("resourceGroupName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "resourceGroupName", valid_564137
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564138 = query.getOrDefault("api-version")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "api-version", valid_564138
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

proc call*(call_564140: Call_DevicesCreateOrUpdate_564132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Data Box Edge/Data Box Gateway resource.
  ## 
  let valid = call_564140.validator(path, query, header, formData, body)
  let scheme = call_564140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564140.url(scheme.get, call_564140.host, call_564140.base,
                         call_564140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564140, url, valid)

proc call*(call_564141: Call_DevicesCreateOrUpdate_564132;
          DataBoxEdgeDevice: JsonNode; apiVersion: string; subscriptionId: string;
          deviceName: string; resourceGroupName: string): Recallable =
  ## devicesCreateOrUpdate
  ## Creates or updates a Data Box Edge/Data Box Gateway resource.
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
  var path_564142 = newJObject()
  var query_564143 = newJObject()
  var body_564144 = newJObject()
  if DataBoxEdgeDevice != nil:
    body_564144 = DataBoxEdgeDevice
  add(query_564143, "api-version", newJString(apiVersion))
  add(path_564142, "subscriptionId", newJString(subscriptionId))
  add(path_564142, "deviceName", newJString(deviceName))
  add(path_564142, "resourceGroupName", newJString(resourceGroupName))
  result = call_564141.call(path_564142, query_564143, nil, nil, body_564144)

var devicesCreateOrUpdate* = Call_DevicesCreateOrUpdate_564132(
    name: "devicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}",
    validator: validate_DevicesCreateOrUpdate_564133, base: "",
    url: url_DevicesCreateOrUpdate_564134, schemes: {Scheme.Https})
type
  Call_DevicesGet_564121 = ref object of OpenApiRestCall_563565
proc url_DevicesGet_564123(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DevicesGet_564122(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the Data Box Edge/Data Box Gateway device.
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
  var valid_564124 = path.getOrDefault("subscriptionId")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "subscriptionId", valid_564124
  var valid_564125 = path.getOrDefault("deviceName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "deviceName", valid_564125
  var valid_564126 = path.getOrDefault("resourceGroupName")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "resourceGroupName", valid_564126
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564127 = query.getOrDefault("api-version")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "api-version", valid_564127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564128: Call_DevicesGet_564121; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_564128.validator(path, query, header, formData, body)
  let scheme = call_564128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564128.url(scheme.get, call_564128.host, call_564128.base,
                         call_564128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564128, url, valid)

proc call*(call_564129: Call_DevicesGet_564121; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## devicesGet
  ## Gets the properties of the Data Box Edge/Data Box Gateway device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564130 = newJObject()
  var query_564131 = newJObject()
  add(query_564131, "api-version", newJString(apiVersion))
  add(path_564130, "subscriptionId", newJString(subscriptionId))
  add(path_564130, "deviceName", newJString(deviceName))
  add(path_564130, "resourceGroupName", newJString(resourceGroupName))
  result = call_564129.call(path_564130, query_564131, nil, nil, nil)

var devicesGet* = Call_DevicesGet_564121(name: "devicesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}",
                                      validator: validate_DevicesGet_564122,
                                      base: "", url: url_DevicesGet_564123,
                                      schemes: {Scheme.Https})
type
  Call_DevicesUpdate_564156 = ref object of OpenApiRestCall_563565
proc url_DevicesUpdate_564158(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesUpdate_564157(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies a Data Box Edge/Data Box Gateway resource.
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
  var valid_564159 = path.getOrDefault("subscriptionId")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "subscriptionId", valid_564159
  var valid_564160 = path.getOrDefault("deviceName")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "deviceName", valid_564160
  var valid_564161 = path.getOrDefault("resourceGroupName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "resourceGroupName", valid_564161
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564162 = query.getOrDefault("api-version")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "api-version", valid_564162
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

proc call*(call_564164: Call_DevicesUpdate_564156; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a Data Box Edge/Data Box Gateway resource.
  ## 
  let valid = call_564164.validator(path, query, header, formData, body)
  let scheme = call_564164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564164.url(scheme.get, call_564164.host, call_564164.base,
                         call_564164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564164, url, valid)

proc call*(call_564165: Call_DevicesUpdate_564156; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## devicesUpdate
  ## Modifies a Data Box Edge/Data Box Gateway resource.
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
  var path_564166 = newJObject()
  var query_564167 = newJObject()
  var body_564168 = newJObject()
  add(query_564167, "api-version", newJString(apiVersion))
  add(path_564166, "subscriptionId", newJString(subscriptionId))
  add(path_564166, "deviceName", newJString(deviceName))
  add(path_564166, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564168 = parameters
  result = call_564165.call(path_564166, query_564167, nil, nil, body_564168)

var devicesUpdate* = Call_DevicesUpdate_564156(name: "devicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}",
    validator: validate_DevicesUpdate_564157, base: "", url: url_DevicesUpdate_564158,
    schemes: {Scheme.Https})
type
  Call_DevicesDelete_564145 = ref object of OpenApiRestCall_563565
proc url_DevicesDelete_564147(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesDelete_564146(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the Data Box Edge/Data Box Gateway device.
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
  var valid_564148 = path.getOrDefault("subscriptionId")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "subscriptionId", valid_564148
  var valid_564149 = path.getOrDefault("deviceName")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "deviceName", valid_564149
  var valid_564150 = path.getOrDefault("resourceGroupName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "resourceGroupName", valid_564150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564151 = query.getOrDefault("api-version")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "api-version", valid_564151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564152: Call_DevicesDelete_564145; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_564152.validator(path, query, header, formData, body)
  let scheme = call_564152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564152.url(scheme.get, call_564152.host, call_564152.base,
                         call_564152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564152, url, valid)

proc call*(call_564153: Call_DevicesDelete_564145; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## devicesDelete
  ## Deletes the Data Box Edge/Data Box Gateway device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564154 = newJObject()
  var query_564155 = newJObject()
  add(query_564155, "api-version", newJString(apiVersion))
  add(path_564154, "subscriptionId", newJString(subscriptionId))
  add(path_564154, "deviceName", newJString(deviceName))
  add(path_564154, "resourceGroupName", newJString(resourceGroupName))
  result = call_564153.call(path_564154, query_564155, nil, nil, nil)

var devicesDelete* = Call_DevicesDelete_564145(name: "devicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}",
    validator: validate_DevicesDelete_564146, base: "", url: url_DevicesDelete_564147,
    schemes: {Scheme.Https})
type
  Call_AlertsListByDataBoxEdgeDevice_564169 = ref object of OpenApiRestCall_563565
proc url_AlertsListByDataBoxEdgeDevice_564171(protocol: Scheme; host: string;
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

proc validate_AlertsListByDataBoxEdgeDevice_564170(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the alerts for a Data Box Edge/Data Box Gateway device.
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
  var valid_564172 = path.getOrDefault("subscriptionId")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "subscriptionId", valid_564172
  var valid_564173 = path.getOrDefault("deviceName")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "deviceName", valid_564173
  var valid_564174 = path.getOrDefault("resourceGroupName")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "resourceGroupName", valid_564174
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564175 = query.getOrDefault("api-version")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "api-version", valid_564175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564176: Call_AlertsListByDataBoxEdgeDevice_564169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the alerts for a Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_564176.validator(path, query, header, formData, body)
  let scheme = call_564176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564176.url(scheme.get, call_564176.host, call_564176.base,
                         call_564176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564176, url, valid)

proc call*(call_564177: Call_AlertsListByDataBoxEdgeDevice_564169;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string): Recallable =
  ## alertsListByDataBoxEdgeDevice
  ## Gets all the alerts for a Data Box Edge/Data Box Gateway device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564178 = newJObject()
  var query_564179 = newJObject()
  add(query_564179, "api-version", newJString(apiVersion))
  add(path_564178, "subscriptionId", newJString(subscriptionId))
  add(path_564178, "deviceName", newJString(deviceName))
  add(path_564178, "resourceGroupName", newJString(resourceGroupName))
  result = call_564177.call(path_564178, query_564179, nil, nil, nil)

var alertsListByDataBoxEdgeDevice* = Call_AlertsListByDataBoxEdgeDevice_564169(
    name: "alertsListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/alerts",
    validator: validate_AlertsListByDataBoxEdgeDevice_564170, base: "",
    url: url_AlertsListByDataBoxEdgeDevice_564171, schemes: {Scheme.Https})
type
  Call_AlertsGet_564180 = ref object of OpenApiRestCall_563565
proc url_AlertsGet_564182(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AlertsGet_564181(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564183 = path.getOrDefault("name")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "name", valid_564183
  var valid_564184 = path.getOrDefault("subscriptionId")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "subscriptionId", valid_564184
  var valid_564185 = path.getOrDefault("deviceName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "deviceName", valid_564185
  var valid_564186 = path.getOrDefault("resourceGroupName")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "resourceGroupName", valid_564186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564187 = query.getOrDefault("api-version")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "api-version", valid_564187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564188: Call_AlertsGet_564180; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564188.validator(path, query, header, formData, body)
  let scheme = call_564188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564188.url(scheme.get, call_564188.host, call_564188.base,
                         call_564188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564188, url, valid)

proc call*(call_564189: Call_AlertsGet_564180; apiVersion: string; name: string;
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
  var path_564190 = newJObject()
  var query_564191 = newJObject()
  add(query_564191, "api-version", newJString(apiVersion))
  add(path_564190, "name", newJString(name))
  add(path_564190, "subscriptionId", newJString(subscriptionId))
  add(path_564190, "deviceName", newJString(deviceName))
  add(path_564190, "resourceGroupName", newJString(resourceGroupName))
  result = call_564189.call(path_564190, query_564191, nil, nil, nil)

var alertsGet* = Call_AlertsGet_564180(name: "alertsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/alerts/{name}",
                                    validator: validate_AlertsGet_564181,
                                    base: "", url: url_AlertsGet_564182,
                                    schemes: {Scheme.Https})
type
  Call_BandwidthSchedulesListByDataBoxEdgeDevice_564192 = ref object of OpenApiRestCall_563565
proc url_BandwidthSchedulesListByDataBoxEdgeDevice_564194(protocol: Scheme;
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

proc validate_BandwidthSchedulesListByDataBoxEdgeDevice_564193(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the bandwidth schedules for a Data Box Edge/Data Box Gateway device.
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
  var valid_564195 = path.getOrDefault("subscriptionId")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "subscriptionId", valid_564195
  var valid_564196 = path.getOrDefault("deviceName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "deviceName", valid_564196
  var valid_564197 = path.getOrDefault("resourceGroupName")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "resourceGroupName", valid_564197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564198 = query.getOrDefault("api-version")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "api-version", valid_564198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564199: Call_BandwidthSchedulesListByDataBoxEdgeDevice_564192;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the bandwidth schedules for a Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_564199.validator(path, query, header, formData, body)
  let scheme = call_564199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564199.url(scheme.get, call_564199.host, call_564199.base,
                         call_564199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564199, url, valid)

proc call*(call_564200: Call_BandwidthSchedulesListByDataBoxEdgeDevice_564192;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string): Recallable =
  ## bandwidthSchedulesListByDataBoxEdgeDevice
  ## Gets all the bandwidth schedules for a Data Box Edge/Data Box Gateway device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564201 = newJObject()
  var query_564202 = newJObject()
  add(query_564202, "api-version", newJString(apiVersion))
  add(path_564201, "subscriptionId", newJString(subscriptionId))
  add(path_564201, "deviceName", newJString(deviceName))
  add(path_564201, "resourceGroupName", newJString(resourceGroupName))
  result = call_564200.call(path_564201, query_564202, nil, nil, nil)

var bandwidthSchedulesListByDataBoxEdgeDevice* = Call_BandwidthSchedulesListByDataBoxEdgeDevice_564192(
    name: "bandwidthSchedulesListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/bandwidthSchedules",
    validator: validate_BandwidthSchedulesListByDataBoxEdgeDevice_564193,
    base: "", url: url_BandwidthSchedulesListByDataBoxEdgeDevice_564194,
    schemes: {Scheme.Https})
type
  Call_BandwidthSchedulesCreateOrUpdate_564215 = ref object of OpenApiRestCall_563565
proc url_BandwidthSchedulesCreateOrUpdate_564217(protocol: Scheme; host: string;
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

proc validate_BandwidthSchedulesCreateOrUpdate_564216(path: JsonNode;
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
  var valid_564218 = path.getOrDefault("name")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "name", valid_564218
  var valid_564219 = path.getOrDefault("subscriptionId")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "subscriptionId", valid_564219
  var valid_564220 = path.getOrDefault("deviceName")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "deviceName", valid_564220
  var valid_564221 = path.getOrDefault("resourceGroupName")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "resourceGroupName", valid_564221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564222 = query.getOrDefault("api-version")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "api-version", valid_564222
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

proc call*(call_564224: Call_BandwidthSchedulesCreateOrUpdate_564215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a bandwidth schedule.
  ## 
  let valid = call_564224.validator(path, query, header, formData, body)
  let scheme = call_564224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564224.url(scheme.get, call_564224.host, call_564224.base,
                         call_564224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564224, url, valid)

proc call*(call_564225: Call_BandwidthSchedulesCreateOrUpdate_564215;
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
  var path_564226 = newJObject()
  var query_564227 = newJObject()
  var body_564228 = newJObject()
  add(query_564227, "api-version", newJString(apiVersion))
  add(path_564226, "name", newJString(name))
  add(path_564226, "subscriptionId", newJString(subscriptionId))
  add(path_564226, "deviceName", newJString(deviceName))
  add(path_564226, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564228 = parameters
  result = call_564225.call(path_564226, query_564227, nil, nil, body_564228)

var bandwidthSchedulesCreateOrUpdate* = Call_BandwidthSchedulesCreateOrUpdate_564215(
    name: "bandwidthSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/bandwidthSchedules/{name}",
    validator: validate_BandwidthSchedulesCreateOrUpdate_564216, base: "",
    url: url_BandwidthSchedulesCreateOrUpdate_564217, schemes: {Scheme.Https})
type
  Call_BandwidthSchedulesGet_564203 = ref object of OpenApiRestCall_563565
proc url_BandwidthSchedulesGet_564205(protocol: Scheme; host: string; base: string;
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

proc validate_BandwidthSchedulesGet_564204(path: JsonNode; query: JsonNode;
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
  var valid_564206 = path.getOrDefault("name")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "name", valid_564206
  var valid_564207 = path.getOrDefault("subscriptionId")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "subscriptionId", valid_564207
  var valid_564208 = path.getOrDefault("deviceName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "deviceName", valid_564208
  var valid_564209 = path.getOrDefault("resourceGroupName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "resourceGroupName", valid_564209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_564211: Call_BandwidthSchedulesGet_564203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified bandwidth schedule.
  ## 
  let valid = call_564211.validator(path, query, header, formData, body)
  let scheme = call_564211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564211.url(scheme.get, call_564211.host, call_564211.base,
                         call_564211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564211, url, valid)

proc call*(call_564212: Call_BandwidthSchedulesGet_564203; apiVersion: string;
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
  var path_564213 = newJObject()
  var query_564214 = newJObject()
  add(query_564214, "api-version", newJString(apiVersion))
  add(path_564213, "name", newJString(name))
  add(path_564213, "subscriptionId", newJString(subscriptionId))
  add(path_564213, "deviceName", newJString(deviceName))
  add(path_564213, "resourceGroupName", newJString(resourceGroupName))
  result = call_564212.call(path_564213, query_564214, nil, nil, nil)

var bandwidthSchedulesGet* = Call_BandwidthSchedulesGet_564203(
    name: "bandwidthSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/bandwidthSchedules/{name}",
    validator: validate_BandwidthSchedulesGet_564204, base: "",
    url: url_BandwidthSchedulesGet_564205, schemes: {Scheme.Https})
type
  Call_BandwidthSchedulesDelete_564229 = ref object of OpenApiRestCall_563565
proc url_BandwidthSchedulesDelete_564231(protocol: Scheme; host: string;
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

proc validate_BandwidthSchedulesDelete_564230(path: JsonNode; query: JsonNode;
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
  var valid_564232 = path.getOrDefault("name")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "name", valid_564232
  var valid_564233 = path.getOrDefault("subscriptionId")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "subscriptionId", valid_564233
  var valid_564234 = path.getOrDefault("deviceName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "deviceName", valid_564234
  var valid_564235 = path.getOrDefault("resourceGroupName")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "resourceGroupName", valid_564235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564236 = query.getOrDefault("api-version")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "api-version", valid_564236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564237: Call_BandwidthSchedulesDelete_564229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified bandwidth schedule.
  ## 
  let valid = call_564237.validator(path, query, header, formData, body)
  let scheme = call_564237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564237.url(scheme.get, call_564237.host, call_564237.base,
                         call_564237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564237, url, valid)

proc call*(call_564238: Call_BandwidthSchedulesDelete_564229; apiVersion: string;
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
  var path_564239 = newJObject()
  var query_564240 = newJObject()
  add(query_564240, "api-version", newJString(apiVersion))
  add(path_564239, "name", newJString(name))
  add(path_564239, "subscriptionId", newJString(subscriptionId))
  add(path_564239, "deviceName", newJString(deviceName))
  add(path_564239, "resourceGroupName", newJString(resourceGroupName))
  result = call_564238.call(path_564239, query_564240, nil, nil, nil)

var bandwidthSchedulesDelete* = Call_BandwidthSchedulesDelete_564229(
    name: "bandwidthSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/bandwidthSchedules/{name}",
    validator: validate_BandwidthSchedulesDelete_564230, base: "",
    url: url_BandwidthSchedulesDelete_564231, schemes: {Scheme.Https})
type
  Call_DevicesDownloadUpdates_564241 = ref object of OpenApiRestCall_563565
proc url_DevicesDownloadUpdates_564243(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesDownloadUpdates_564242(path: JsonNode; query: JsonNode;
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
  var valid_564244 = path.getOrDefault("subscriptionId")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "subscriptionId", valid_564244
  var valid_564245 = path.getOrDefault("deviceName")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "deviceName", valid_564245
  var valid_564246 = path.getOrDefault("resourceGroupName")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "resourceGroupName", valid_564246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564248: Call_DevicesDownloadUpdates_564241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564248.validator(path, query, header, formData, body)
  let scheme = call_564248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564248.url(scheme.get, call_564248.host, call_564248.base,
                         call_564248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564248, url, valid)

proc call*(call_564249: Call_DevicesDownloadUpdates_564241; apiVersion: string;
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
  var path_564250 = newJObject()
  var query_564251 = newJObject()
  add(query_564251, "api-version", newJString(apiVersion))
  add(path_564250, "subscriptionId", newJString(subscriptionId))
  add(path_564250, "deviceName", newJString(deviceName))
  add(path_564250, "resourceGroupName", newJString(resourceGroupName))
  result = call_564249.call(path_564250, query_564251, nil, nil, nil)

var devicesDownloadUpdates* = Call_DevicesDownloadUpdates_564241(
    name: "devicesDownloadUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/downloadUpdates",
    validator: validate_DevicesDownloadUpdates_564242, base: "",
    url: url_DevicesDownloadUpdates_564243, schemes: {Scheme.Https})
type
  Call_DevicesGetExtendedInformation_564252 = ref object of OpenApiRestCall_563565
proc url_DevicesGetExtendedInformation_564254(protocol: Scheme; host: string;
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

proc validate_DevicesGetExtendedInformation_564253(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets additional information for the specified Data Box Edge/Data Box Gateway device.
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
  var valid_564255 = path.getOrDefault("subscriptionId")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "subscriptionId", valid_564255
  var valid_564256 = path.getOrDefault("deviceName")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "deviceName", valid_564256
  var valid_564257 = path.getOrDefault("resourceGroupName")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "resourceGroupName", valid_564257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564259: Call_DevicesGetExtendedInformation_564252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets additional information for the specified Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_564259.validator(path, query, header, formData, body)
  let scheme = call_564259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564259.url(scheme.get, call_564259.host, call_564259.base,
                         call_564259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564259, url, valid)

proc call*(call_564260: Call_DevicesGetExtendedInformation_564252;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string): Recallable =
  ## devicesGetExtendedInformation
  ## Gets additional information for the specified Data Box Edge/Data Box Gateway device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564261 = newJObject()
  var query_564262 = newJObject()
  add(query_564262, "api-version", newJString(apiVersion))
  add(path_564261, "subscriptionId", newJString(subscriptionId))
  add(path_564261, "deviceName", newJString(deviceName))
  add(path_564261, "resourceGroupName", newJString(resourceGroupName))
  result = call_564260.call(path_564261, query_564262, nil, nil, nil)

var devicesGetExtendedInformation* = Call_DevicesGetExtendedInformation_564252(
    name: "devicesGetExtendedInformation", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/getExtendedInformation",
    validator: validate_DevicesGetExtendedInformation_564253, base: "",
    url: url_DevicesGetExtendedInformation_564254, schemes: {Scheme.Https})
type
  Call_DevicesInstallUpdates_564263 = ref object of OpenApiRestCall_563565
proc url_DevicesInstallUpdates_564265(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesInstallUpdates_564264(path: JsonNode; query: JsonNode;
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
  var valid_564266 = path.getOrDefault("subscriptionId")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "subscriptionId", valid_564266
  var valid_564267 = path.getOrDefault("deviceName")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "deviceName", valid_564267
  var valid_564268 = path.getOrDefault("resourceGroupName")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "resourceGroupName", valid_564268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564269 = query.getOrDefault("api-version")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "api-version", valid_564269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564270: Call_DevicesInstallUpdates_564263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564270.validator(path, query, header, formData, body)
  let scheme = call_564270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564270.url(scheme.get, call_564270.host, call_564270.base,
                         call_564270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564270, url, valid)

proc call*(call_564271: Call_DevicesInstallUpdates_564263; apiVersion: string;
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
  var path_564272 = newJObject()
  var query_564273 = newJObject()
  add(query_564273, "api-version", newJString(apiVersion))
  add(path_564272, "subscriptionId", newJString(subscriptionId))
  add(path_564272, "deviceName", newJString(deviceName))
  add(path_564272, "resourceGroupName", newJString(resourceGroupName))
  result = call_564271.call(path_564272, query_564273, nil, nil, nil)

var devicesInstallUpdates* = Call_DevicesInstallUpdates_564263(
    name: "devicesInstallUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/installUpdates",
    validator: validate_DevicesInstallUpdates_564264, base: "",
    url: url_DevicesInstallUpdates_564265, schemes: {Scheme.Https})
type
  Call_JobsGet_564274 = ref object of OpenApiRestCall_563565
proc url_JobsGet_564276(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsGet_564275(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564277 = path.getOrDefault("name")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "name", valid_564277
  var valid_564278 = path.getOrDefault("subscriptionId")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "subscriptionId", valid_564278
  var valid_564279 = path.getOrDefault("deviceName")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "deviceName", valid_564279
  var valid_564280 = path.getOrDefault("resourceGroupName")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "resourceGroupName", valid_564280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564281 = query.getOrDefault("api-version")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "api-version", valid_564281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564282: Call_JobsGet_564274; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564282.validator(path, query, header, formData, body)
  let scheme = call_564282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564282.url(scheme.get, call_564282.host, call_564282.base,
                         call_564282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564282, url, valid)

proc call*(call_564283: Call_JobsGet_564274; apiVersion: string; name: string;
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
  var path_564284 = newJObject()
  var query_564285 = newJObject()
  add(query_564285, "api-version", newJString(apiVersion))
  add(path_564284, "name", newJString(name))
  add(path_564284, "subscriptionId", newJString(subscriptionId))
  add(path_564284, "deviceName", newJString(deviceName))
  add(path_564284, "resourceGroupName", newJString(resourceGroupName))
  result = call_564283.call(path_564284, query_564285, nil, nil, nil)

var jobsGet* = Call_JobsGet_564274(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/jobs/{name}",
                                validator: validate_JobsGet_564275, base: "",
                                url: url_JobsGet_564276, schemes: {Scheme.Https})
type
  Call_DevicesGetNetworkSettings_564286 = ref object of OpenApiRestCall_563565
proc url_DevicesGetNetworkSettings_564288(protocol: Scheme; host: string;
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

proc validate_DevicesGetNetworkSettings_564287(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the network settings of the specified Data Box Edge/Data Box Gateway device.
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
  var valid_564289 = path.getOrDefault("subscriptionId")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "subscriptionId", valid_564289
  var valid_564290 = path.getOrDefault("deviceName")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "deviceName", valid_564290
  var valid_564291 = path.getOrDefault("resourceGroupName")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "resourceGroupName", valid_564291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564292 = query.getOrDefault("api-version")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "api-version", valid_564292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564293: Call_DevicesGetNetworkSettings_564286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the network settings of the specified Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_564293.validator(path, query, header, formData, body)
  let scheme = call_564293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564293.url(scheme.get, call_564293.host, call_564293.base,
                         call_564293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564293, url, valid)

proc call*(call_564294: Call_DevicesGetNetworkSettings_564286; apiVersion: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## devicesGetNetworkSettings
  ## Gets the network settings of the specified Data Box Edge/Data Box Gateway device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564295 = newJObject()
  var query_564296 = newJObject()
  add(query_564296, "api-version", newJString(apiVersion))
  add(path_564295, "subscriptionId", newJString(subscriptionId))
  add(path_564295, "deviceName", newJString(deviceName))
  add(path_564295, "resourceGroupName", newJString(resourceGroupName))
  result = call_564294.call(path_564295, query_564296, nil, nil, nil)

var devicesGetNetworkSettings* = Call_DevicesGetNetworkSettings_564286(
    name: "devicesGetNetworkSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/networkSettings/default",
    validator: validate_DevicesGetNetworkSettings_564287, base: "",
    url: url_DevicesGetNetworkSettings_564288, schemes: {Scheme.Https})
type
  Call_NodesListByDataBoxEdgeDevice_564297 = ref object of OpenApiRestCall_563565
proc url_NodesListByDataBoxEdgeDevice_564299(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/nodes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NodesListByDataBoxEdgeDevice_564298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the nodes currently configured under this Data Box Edge device
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

proc call*(call_564304: Call_NodesListByDataBoxEdgeDevice_564297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the nodes currently configured under this Data Box Edge device
  ## 
  let valid = call_564304.validator(path, query, header, formData, body)
  let scheme = call_564304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564304.url(scheme.get, call_564304.host, call_564304.base,
                         call_564304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564304, url, valid)

proc call*(call_564305: Call_NodesListByDataBoxEdgeDevice_564297;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string): Recallable =
  ## nodesListByDataBoxEdgeDevice
  ## Gets all the nodes currently configured under this Data Box Edge device
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564306 = newJObject()
  var query_564307 = newJObject()
  add(query_564307, "api-version", newJString(apiVersion))
  add(path_564306, "subscriptionId", newJString(subscriptionId))
  add(path_564306, "deviceName", newJString(deviceName))
  add(path_564306, "resourceGroupName", newJString(resourceGroupName))
  result = call_564305.call(path_564306, query_564307, nil, nil, nil)

var nodesListByDataBoxEdgeDevice* = Call_NodesListByDataBoxEdgeDevice_564297(
    name: "nodesListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/nodes",
    validator: validate_NodesListByDataBoxEdgeDevice_564298, base: "",
    url: url_NodesListByDataBoxEdgeDevice_564299, schemes: {Scheme.Https})
type
  Call_OperationsStatusGet_564308 = ref object of OpenApiRestCall_563565
proc url_OperationsStatusGet_564310(protocol: Scheme; host: string; base: string;
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

proc validate_OperationsStatusGet_564309(path: JsonNode; query: JsonNode;
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
  var valid_564311 = path.getOrDefault("name")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "name", valid_564311
  var valid_564312 = path.getOrDefault("subscriptionId")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "subscriptionId", valid_564312
  var valid_564313 = path.getOrDefault("deviceName")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "deviceName", valid_564313
  var valid_564314 = path.getOrDefault("resourceGroupName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "resourceGroupName", valid_564314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564315 = query.getOrDefault("api-version")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "api-version", valid_564315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564316: Call_OperationsStatusGet_564308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564316.validator(path, query, header, formData, body)
  let scheme = call_564316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564316.url(scheme.get, call_564316.host, call_564316.base,
                         call_564316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564316, url, valid)

proc call*(call_564317: Call_OperationsStatusGet_564308; apiVersion: string;
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
  var path_564318 = newJObject()
  var query_564319 = newJObject()
  add(query_564319, "api-version", newJString(apiVersion))
  add(path_564318, "name", newJString(name))
  add(path_564318, "subscriptionId", newJString(subscriptionId))
  add(path_564318, "deviceName", newJString(deviceName))
  add(path_564318, "resourceGroupName", newJString(resourceGroupName))
  result = call_564317.call(path_564318, query_564319, nil, nil, nil)

var operationsStatusGet* = Call_OperationsStatusGet_564308(
    name: "operationsStatusGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/operationsStatus/{name}",
    validator: validate_OperationsStatusGet_564309, base: "",
    url: url_OperationsStatusGet_564310, schemes: {Scheme.Https})
type
  Call_OrdersListByDataBoxEdgeDevice_564320 = ref object of OpenApiRestCall_563565
proc url_OrdersListByDataBoxEdgeDevice_564322(protocol: Scheme; host: string;
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

proc validate_OrdersListByDataBoxEdgeDevice_564321(path: JsonNode; query: JsonNode;
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
  var valid_564323 = path.getOrDefault("subscriptionId")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "subscriptionId", valid_564323
  var valid_564324 = path.getOrDefault("deviceName")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "deviceName", valid_564324
  var valid_564325 = path.getOrDefault("resourceGroupName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "resourceGroupName", valid_564325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564326 = query.getOrDefault("api-version")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "api-version", valid_564326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564327: Call_OrdersListByDataBoxEdgeDevice_564320; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564327.validator(path, query, header, formData, body)
  let scheme = call_564327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564327.url(scheme.get, call_564327.host, call_564327.base,
                         call_564327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564327, url, valid)

proc call*(call_564328: Call_OrdersListByDataBoxEdgeDevice_564320;
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
  var path_564329 = newJObject()
  var query_564330 = newJObject()
  add(query_564330, "api-version", newJString(apiVersion))
  add(path_564329, "subscriptionId", newJString(subscriptionId))
  add(path_564329, "deviceName", newJString(deviceName))
  add(path_564329, "resourceGroupName", newJString(resourceGroupName))
  result = call_564328.call(path_564329, query_564330, nil, nil, nil)

var ordersListByDataBoxEdgeDevice* = Call_OrdersListByDataBoxEdgeDevice_564320(
    name: "ordersListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/orders",
    validator: validate_OrdersListByDataBoxEdgeDevice_564321, base: "",
    url: url_OrdersListByDataBoxEdgeDevice_564322, schemes: {Scheme.Https})
type
  Call_OrdersCreateOrUpdate_564342 = ref object of OpenApiRestCall_563565
proc url_OrdersCreateOrUpdate_564344(protocol: Scheme; host: string; base: string;
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

proc validate_OrdersCreateOrUpdate_564343(path: JsonNode; query: JsonNode;
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
  var valid_564345 = path.getOrDefault("subscriptionId")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "subscriptionId", valid_564345
  var valid_564346 = path.getOrDefault("deviceName")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "deviceName", valid_564346
  var valid_564347 = path.getOrDefault("resourceGroupName")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "resourceGroupName", valid_564347
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564348 = query.getOrDefault("api-version")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "api-version", valid_564348
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

proc call*(call_564350: Call_OrdersCreateOrUpdate_564342; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564350.validator(path, query, header, formData, body)
  let scheme = call_564350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564350.url(scheme.get, call_564350.host, call_564350.base,
                         call_564350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564350, url, valid)

proc call*(call_564351: Call_OrdersCreateOrUpdate_564342; apiVersion: string;
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
  var path_564352 = newJObject()
  var query_564353 = newJObject()
  var body_564354 = newJObject()
  add(query_564353, "api-version", newJString(apiVersion))
  if order != nil:
    body_564354 = order
  add(path_564352, "subscriptionId", newJString(subscriptionId))
  add(path_564352, "deviceName", newJString(deviceName))
  add(path_564352, "resourceGroupName", newJString(resourceGroupName))
  result = call_564351.call(path_564352, query_564353, nil, nil, body_564354)

var ordersCreateOrUpdate* = Call_OrdersCreateOrUpdate_564342(
    name: "ordersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/orders/default",
    validator: validate_OrdersCreateOrUpdate_564343, base: "",
    url: url_OrdersCreateOrUpdate_564344, schemes: {Scheme.Https})
type
  Call_OrdersGet_564331 = ref object of OpenApiRestCall_563565
proc url_OrdersGet_564333(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_OrdersGet_564332(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564334 = path.getOrDefault("subscriptionId")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "subscriptionId", valid_564334
  var valid_564335 = path.getOrDefault("deviceName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "deviceName", valid_564335
  var valid_564336 = path.getOrDefault("resourceGroupName")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "resourceGroupName", valid_564336
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564338: Call_OrdersGet_564331; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564338.validator(path, query, header, formData, body)
  let scheme = call_564338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564338.url(scheme.get, call_564338.host, call_564338.base,
                         call_564338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564338, url, valid)

proc call*(call_564339: Call_OrdersGet_564331; apiVersion: string;
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
  var path_564340 = newJObject()
  var query_564341 = newJObject()
  add(query_564341, "api-version", newJString(apiVersion))
  add(path_564340, "subscriptionId", newJString(subscriptionId))
  add(path_564340, "deviceName", newJString(deviceName))
  add(path_564340, "resourceGroupName", newJString(resourceGroupName))
  result = call_564339.call(path_564340, query_564341, nil, nil, nil)

var ordersGet* = Call_OrdersGet_564331(name: "ordersGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/orders/default",
                                    validator: validate_OrdersGet_564332,
                                    base: "", url: url_OrdersGet_564333,
                                    schemes: {Scheme.Https})
type
  Call_OrdersDelete_564355 = ref object of OpenApiRestCall_563565
proc url_OrdersDelete_564357(protocol: Scheme; host: string; base: string;
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

proc validate_OrdersDelete_564356(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564358 = path.getOrDefault("subscriptionId")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "subscriptionId", valid_564358
  var valid_564359 = path.getOrDefault("deviceName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "deviceName", valid_564359
  var valid_564360 = path.getOrDefault("resourceGroupName")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "resourceGroupName", valid_564360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_564362: Call_OrdersDelete_564355; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564362.validator(path, query, header, formData, body)
  let scheme = call_564362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564362.url(scheme.get, call_564362.host, call_564362.base,
                         call_564362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564362, url, valid)

proc call*(call_564363: Call_OrdersDelete_564355; apiVersion: string;
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
  var path_564364 = newJObject()
  var query_564365 = newJObject()
  add(query_564365, "api-version", newJString(apiVersion))
  add(path_564364, "subscriptionId", newJString(subscriptionId))
  add(path_564364, "deviceName", newJString(deviceName))
  add(path_564364, "resourceGroupName", newJString(resourceGroupName))
  result = call_564363.call(path_564364, query_564365, nil, nil, nil)

var ordersDelete* = Call_OrdersDelete_564355(name: "ordersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/orders/default",
    validator: validate_OrdersDelete_564356, base: "", url: url_OrdersDelete_564357,
    schemes: {Scheme.Https})
type
  Call_RolesListByDataBoxEdgeDevice_564366 = ref object of OpenApiRestCall_563565
proc url_RolesListByDataBoxEdgeDevice_564368(protocol: Scheme; host: string;
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

proc validate_RolesListByDataBoxEdgeDevice_564367(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the roles configured in a Data Box Edge/Data Box Gateway device.
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

proc call*(call_564373: Call_RolesListByDataBoxEdgeDevice_564366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the roles configured in a Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_564373.validator(path, query, header, formData, body)
  let scheme = call_564373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564373.url(scheme.get, call_564373.host, call_564373.base,
                         call_564373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564373, url, valid)

proc call*(call_564374: Call_RolesListByDataBoxEdgeDevice_564366;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string): Recallable =
  ## rolesListByDataBoxEdgeDevice
  ## Lists all the roles configured in a Data Box Edge/Data Box Gateway device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564375 = newJObject()
  var query_564376 = newJObject()
  add(query_564376, "api-version", newJString(apiVersion))
  add(path_564375, "subscriptionId", newJString(subscriptionId))
  add(path_564375, "deviceName", newJString(deviceName))
  add(path_564375, "resourceGroupName", newJString(resourceGroupName))
  result = call_564374.call(path_564375, query_564376, nil, nil, nil)

var rolesListByDataBoxEdgeDevice* = Call_RolesListByDataBoxEdgeDevice_564366(
    name: "rolesListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/roles",
    validator: validate_RolesListByDataBoxEdgeDevice_564367, base: "",
    url: url_RolesListByDataBoxEdgeDevice_564368, schemes: {Scheme.Https})
type
  Call_RolesCreateOrUpdate_564389 = ref object of OpenApiRestCall_563565
proc url_RolesCreateOrUpdate_564391(protocol: Scheme; host: string; base: string;
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

proc validate_RolesCreateOrUpdate_564390(path: JsonNode; query: JsonNode;
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
  var valid_564392 = path.getOrDefault("name")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "name", valid_564392
  var valid_564393 = path.getOrDefault("subscriptionId")
  valid_564393 = validateParameter(valid_564393, JString, required = true,
                                 default = nil)
  if valid_564393 != nil:
    section.add "subscriptionId", valid_564393
  var valid_564394 = path.getOrDefault("deviceName")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "deviceName", valid_564394
  var valid_564395 = path.getOrDefault("resourceGroupName")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "resourceGroupName", valid_564395
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564396 = query.getOrDefault("api-version")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "api-version", valid_564396
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

proc call*(call_564398: Call_RolesCreateOrUpdate_564389; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a role.
  ## 
  let valid = call_564398.validator(path, query, header, formData, body)
  let scheme = call_564398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564398.url(scheme.get, call_564398.host, call_564398.base,
                         call_564398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564398, url, valid)

proc call*(call_564399: Call_RolesCreateOrUpdate_564389; apiVersion: string;
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
  var path_564400 = newJObject()
  var query_564401 = newJObject()
  var body_564402 = newJObject()
  add(query_564401, "api-version", newJString(apiVersion))
  if role != nil:
    body_564402 = role
  add(path_564400, "name", newJString(name))
  add(path_564400, "subscriptionId", newJString(subscriptionId))
  add(path_564400, "deviceName", newJString(deviceName))
  add(path_564400, "resourceGroupName", newJString(resourceGroupName))
  result = call_564399.call(path_564400, query_564401, nil, nil, body_564402)

var rolesCreateOrUpdate* = Call_RolesCreateOrUpdate_564389(
    name: "rolesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/roles/{name}",
    validator: validate_RolesCreateOrUpdate_564390, base: "",
    url: url_RolesCreateOrUpdate_564391, schemes: {Scheme.Https})
type
  Call_RolesGet_564377 = ref object of OpenApiRestCall_563565
proc url_RolesGet_564379(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_RolesGet_564378(path: JsonNode; query: JsonNode; header: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_564385: Call_RolesGet_564377; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific role by name.
  ## 
  let valid = call_564385.validator(path, query, header, formData, body)
  let scheme = call_564385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564385.url(scheme.get, call_564385.host, call_564385.base,
                         call_564385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564385, url, valid)

proc call*(call_564386: Call_RolesGet_564377; apiVersion: string; name: string;
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
  var path_564387 = newJObject()
  var query_564388 = newJObject()
  add(query_564388, "api-version", newJString(apiVersion))
  add(path_564387, "name", newJString(name))
  add(path_564387, "subscriptionId", newJString(subscriptionId))
  add(path_564387, "deviceName", newJString(deviceName))
  add(path_564387, "resourceGroupName", newJString(resourceGroupName))
  result = call_564386.call(path_564387, query_564388, nil, nil, nil)

var rolesGet* = Call_RolesGet_564377(name: "rolesGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/roles/{name}",
                                  validator: validate_RolesGet_564378, base: "",
                                  url: url_RolesGet_564379,
                                  schemes: {Scheme.Https})
type
  Call_RolesDelete_564403 = ref object of OpenApiRestCall_563565
proc url_RolesDelete_564405(protocol: Scheme; host: string; base: string;
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

proc validate_RolesDelete_564404(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the role on the device.
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
  var valid_564406 = path.getOrDefault("name")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "name", valid_564406
  var valid_564407 = path.getOrDefault("subscriptionId")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "subscriptionId", valid_564407
  var valid_564408 = path.getOrDefault("deviceName")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = nil)
  if valid_564408 != nil:
    section.add "deviceName", valid_564408
  var valid_564409 = path.getOrDefault("resourceGroupName")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "resourceGroupName", valid_564409
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_564411: Call_RolesDelete_564403; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the role on the device.
  ## 
  let valid = call_564411.validator(path, query, header, formData, body)
  let scheme = call_564411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564411.url(scheme.get, call_564411.host, call_564411.base,
                         call_564411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564411, url, valid)

proc call*(call_564412: Call_RolesDelete_564403; apiVersion: string; name: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## rolesDelete
  ## Deletes the role on the device.
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
  var path_564413 = newJObject()
  var query_564414 = newJObject()
  add(query_564414, "api-version", newJString(apiVersion))
  add(path_564413, "name", newJString(name))
  add(path_564413, "subscriptionId", newJString(subscriptionId))
  add(path_564413, "deviceName", newJString(deviceName))
  add(path_564413, "resourceGroupName", newJString(resourceGroupName))
  result = call_564412.call(path_564413, query_564414, nil, nil, nil)

var rolesDelete* = Call_RolesDelete_564403(name: "rolesDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/roles/{name}",
                                        validator: validate_RolesDelete_564404,
                                        base: "", url: url_RolesDelete_564405,
                                        schemes: {Scheme.Https})
type
  Call_DevicesScanForUpdates_564415 = ref object of OpenApiRestCall_563565
proc url_DevicesScanForUpdates_564417(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesScanForUpdates_564416(path: JsonNode; query: JsonNode;
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564421 = query.getOrDefault("api-version")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "api-version", valid_564421
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564422: Call_DevicesScanForUpdates_564415; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564422.validator(path, query, header, formData, body)
  let scheme = call_564422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564422.url(scheme.get, call_564422.host, call_564422.base,
                         call_564422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564422, url, valid)

proc call*(call_564423: Call_DevicesScanForUpdates_564415; apiVersion: string;
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
  var path_564424 = newJObject()
  var query_564425 = newJObject()
  add(query_564425, "api-version", newJString(apiVersion))
  add(path_564424, "subscriptionId", newJString(subscriptionId))
  add(path_564424, "deviceName", newJString(deviceName))
  add(path_564424, "resourceGroupName", newJString(resourceGroupName))
  result = call_564423.call(path_564424, query_564425, nil, nil, nil)

var devicesScanForUpdates* = Call_DevicesScanForUpdates_564415(
    name: "devicesScanForUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/scanForUpdates",
    validator: validate_DevicesScanForUpdates_564416, base: "",
    url: url_DevicesScanForUpdates_564417, schemes: {Scheme.Https})
type
  Call_DevicesCreateOrUpdateSecuritySettings_564426 = ref object of OpenApiRestCall_563565
proc url_DevicesCreateOrUpdateSecuritySettings_564428(protocol: Scheme;
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

proc validate_DevicesCreateOrUpdateSecuritySettings_564427(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the security settings on a Data Box Edge/Data Box Gateway device.
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
  var valid_564429 = path.getOrDefault("subscriptionId")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "subscriptionId", valid_564429
  var valid_564430 = path.getOrDefault("deviceName")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "deviceName", valid_564430
  var valid_564431 = path.getOrDefault("resourceGroupName")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "resourceGroupName", valid_564431
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564432 = query.getOrDefault("api-version")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "api-version", valid_564432
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

proc call*(call_564434: Call_DevicesCreateOrUpdateSecuritySettings_564426;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the security settings on a Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_564434.validator(path, query, header, formData, body)
  let scheme = call_564434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564434.url(scheme.get, call_564434.host, call_564434.base,
                         call_564434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564434, url, valid)

proc call*(call_564435: Call_DevicesCreateOrUpdateSecuritySettings_564426;
          securitySettings: JsonNode; apiVersion: string; subscriptionId: string;
          deviceName: string; resourceGroupName: string): Recallable =
  ## devicesCreateOrUpdateSecuritySettings
  ## Updates the security settings on a Data Box Edge/Data Box Gateway device.
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
  var path_564436 = newJObject()
  var query_564437 = newJObject()
  var body_564438 = newJObject()
  if securitySettings != nil:
    body_564438 = securitySettings
  add(query_564437, "api-version", newJString(apiVersion))
  add(path_564436, "subscriptionId", newJString(subscriptionId))
  add(path_564436, "deviceName", newJString(deviceName))
  add(path_564436, "resourceGroupName", newJString(resourceGroupName))
  result = call_564435.call(path_564436, query_564437, nil, nil, body_564438)

var devicesCreateOrUpdateSecuritySettings* = Call_DevicesCreateOrUpdateSecuritySettings_564426(
    name: "devicesCreateOrUpdateSecuritySettings", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/securitySettings/default/update",
    validator: validate_DevicesCreateOrUpdateSecuritySettings_564427, base: "",
    url: url_DevicesCreateOrUpdateSecuritySettings_564428, schemes: {Scheme.Https})
type
  Call_SharesListByDataBoxEdgeDevice_564439 = ref object of OpenApiRestCall_563565
proc url_SharesListByDataBoxEdgeDevice_564441(protocol: Scheme; host: string;
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

proc validate_SharesListByDataBoxEdgeDevice_564440(path: JsonNode; query: JsonNode;
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

proc call*(call_564446: Call_SharesListByDataBoxEdgeDevice_564439; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564446.validator(path, query, header, formData, body)
  let scheme = call_564446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564446.url(scheme.get, call_564446.host, call_564446.base,
                         call_564446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564446, url, valid)

proc call*(call_564447: Call_SharesListByDataBoxEdgeDevice_564439;
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
  var path_564448 = newJObject()
  var query_564449 = newJObject()
  add(query_564449, "api-version", newJString(apiVersion))
  add(path_564448, "subscriptionId", newJString(subscriptionId))
  add(path_564448, "deviceName", newJString(deviceName))
  add(path_564448, "resourceGroupName", newJString(resourceGroupName))
  result = call_564447.call(path_564448, query_564449, nil, nil, nil)

var sharesListByDataBoxEdgeDevice* = Call_SharesListByDataBoxEdgeDevice_564439(
    name: "sharesListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares",
    validator: validate_SharesListByDataBoxEdgeDevice_564440, base: "",
    url: url_SharesListByDataBoxEdgeDevice_564441, schemes: {Scheme.Https})
type
  Call_SharesCreateOrUpdate_564462 = ref object of OpenApiRestCall_563565
proc url_SharesCreateOrUpdate_564464(protocol: Scheme; host: string; base: string;
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

proc validate_SharesCreateOrUpdate_564463(path: JsonNode; query: JsonNode;
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
  var valid_564465 = path.getOrDefault("name")
  valid_564465 = validateParameter(valid_564465, JString, required = true,
                                 default = nil)
  if valid_564465 != nil:
    section.add "name", valid_564465
  var valid_564466 = path.getOrDefault("subscriptionId")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "subscriptionId", valid_564466
  var valid_564467 = path.getOrDefault("deviceName")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "deviceName", valid_564467
  var valid_564468 = path.getOrDefault("resourceGroupName")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "resourceGroupName", valid_564468
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564469 = query.getOrDefault("api-version")
  valid_564469 = validateParameter(valid_564469, JString, required = true,
                                 default = nil)
  if valid_564469 != nil:
    section.add "api-version", valid_564469
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

proc call*(call_564471: Call_SharesCreateOrUpdate_564462; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564471.validator(path, query, header, formData, body)
  let scheme = call_564471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564471.url(scheme.get, call_564471.host, call_564471.base,
                         call_564471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564471, url, valid)

proc call*(call_564472: Call_SharesCreateOrUpdate_564462; apiVersion: string;
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
  var path_564473 = newJObject()
  var query_564474 = newJObject()
  var body_564475 = newJObject()
  add(query_564474, "api-version", newJString(apiVersion))
  add(path_564473, "name", newJString(name))
  add(path_564473, "subscriptionId", newJString(subscriptionId))
  if share != nil:
    body_564475 = share
  add(path_564473, "deviceName", newJString(deviceName))
  add(path_564473, "resourceGroupName", newJString(resourceGroupName))
  result = call_564472.call(path_564473, query_564474, nil, nil, body_564475)

var sharesCreateOrUpdate* = Call_SharesCreateOrUpdate_564462(
    name: "sharesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares/{name}",
    validator: validate_SharesCreateOrUpdate_564463, base: "",
    url: url_SharesCreateOrUpdate_564464, schemes: {Scheme.Https})
type
  Call_SharesGet_564450 = ref object of OpenApiRestCall_563565
proc url_SharesGet_564452(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SharesGet_564451(path: JsonNode; query: JsonNode; header: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_564458: Call_SharesGet_564450; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564458.validator(path, query, header, formData, body)
  let scheme = call_564458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564458.url(scheme.get, call_564458.host, call_564458.base,
                         call_564458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564458, url, valid)

proc call*(call_564459: Call_SharesGet_564450; apiVersion: string; name: string;
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
  var path_564460 = newJObject()
  var query_564461 = newJObject()
  add(query_564461, "api-version", newJString(apiVersion))
  add(path_564460, "name", newJString(name))
  add(path_564460, "subscriptionId", newJString(subscriptionId))
  add(path_564460, "deviceName", newJString(deviceName))
  add(path_564460, "resourceGroupName", newJString(resourceGroupName))
  result = call_564459.call(path_564460, query_564461, nil, nil, nil)

var sharesGet* = Call_SharesGet_564450(name: "sharesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares/{name}",
                                    validator: validate_SharesGet_564451,
                                    base: "", url: url_SharesGet_564452,
                                    schemes: {Scheme.Https})
type
  Call_SharesDelete_564476 = ref object of OpenApiRestCall_563565
proc url_SharesDelete_564478(protocol: Scheme; host: string; base: string;
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

proc validate_SharesDelete_564477(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the share on the Data Box Edge/Data Box Gateway device.
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

proc call*(call_564484: Call_SharesDelete_564476; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the share on the Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_564484.validator(path, query, header, formData, body)
  let scheme = call_564484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564484.url(scheme.get, call_564484.host, call_564484.base,
                         call_564484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564484, url, valid)

proc call*(call_564485: Call_SharesDelete_564476; apiVersion: string; name: string;
          subscriptionId: string; deviceName: string; resourceGroupName: string): Recallable =
  ## sharesDelete
  ## Deletes the share on the Data Box Edge/Data Box Gateway device.
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

var sharesDelete* = Call_SharesDelete_564476(name: "sharesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares/{name}",
    validator: validate_SharesDelete_564477, base: "", url: url_SharesDelete_564478,
    schemes: {Scheme.Https})
type
  Call_SharesRefresh_564488 = ref object of OpenApiRestCall_563565
proc url_SharesRefresh_564490(protocol: Scheme; host: string; base: string;
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

proc validate_SharesRefresh_564489(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564491 = path.getOrDefault("name")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "name", valid_564491
  var valid_564492 = path.getOrDefault("subscriptionId")
  valid_564492 = validateParameter(valid_564492, JString, required = true,
                                 default = nil)
  if valid_564492 != nil:
    section.add "subscriptionId", valid_564492
  var valid_564493 = path.getOrDefault("deviceName")
  valid_564493 = validateParameter(valid_564493, JString, required = true,
                                 default = nil)
  if valid_564493 != nil:
    section.add "deviceName", valid_564493
  var valid_564494 = path.getOrDefault("resourceGroupName")
  valid_564494 = validateParameter(valid_564494, JString, required = true,
                                 default = nil)
  if valid_564494 != nil:
    section.add "resourceGroupName", valid_564494
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564495 = query.getOrDefault("api-version")
  valid_564495 = validateParameter(valid_564495, JString, required = true,
                                 default = nil)
  if valid_564495 != nil:
    section.add "api-version", valid_564495
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564496: Call_SharesRefresh_564488; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564496.validator(path, query, header, formData, body)
  let scheme = call_564496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564496.url(scheme.get, call_564496.host, call_564496.base,
                         call_564496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564496, url, valid)

proc call*(call_564497: Call_SharesRefresh_564488; apiVersion: string; name: string;
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
  var path_564498 = newJObject()
  var query_564499 = newJObject()
  add(query_564499, "api-version", newJString(apiVersion))
  add(path_564498, "name", newJString(name))
  add(path_564498, "subscriptionId", newJString(subscriptionId))
  add(path_564498, "deviceName", newJString(deviceName))
  add(path_564498, "resourceGroupName", newJString(resourceGroupName))
  result = call_564497.call(path_564498, query_564499, nil, nil, nil)

var sharesRefresh* = Call_SharesRefresh_564488(name: "sharesRefresh",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares/{name}/refresh",
    validator: validate_SharesRefresh_564489, base: "", url: url_SharesRefresh_564490,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsListByDataBoxEdgeDevice_564500 = ref object of OpenApiRestCall_563565
proc url_StorageAccountCredentialsListByDataBoxEdgeDevice_564502(
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

proc validate_StorageAccountCredentialsListByDataBoxEdgeDevice_564501(
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

proc call*(call_564507: Call_StorageAccountCredentialsListByDataBoxEdgeDevice_564500;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_564507.validator(path, query, header, formData, body)
  let scheme = call_564507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564507.url(scheme.get, call_564507.host, call_564507.base,
                         call_564507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564507, url, valid)

proc call*(call_564508: Call_StorageAccountCredentialsListByDataBoxEdgeDevice_564500;
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
  var path_564509 = newJObject()
  var query_564510 = newJObject()
  add(query_564510, "api-version", newJString(apiVersion))
  add(path_564509, "subscriptionId", newJString(subscriptionId))
  add(path_564509, "deviceName", newJString(deviceName))
  add(path_564509, "resourceGroupName", newJString(resourceGroupName))
  result = call_564508.call(path_564509, query_564510, nil, nil, nil)

var storageAccountCredentialsListByDataBoxEdgeDevice* = Call_StorageAccountCredentialsListByDataBoxEdgeDevice_564500(
    name: "storageAccountCredentialsListByDataBoxEdgeDevice",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/storageAccountCredentials",
    validator: validate_StorageAccountCredentialsListByDataBoxEdgeDevice_564501,
    base: "", url: url_StorageAccountCredentialsListByDataBoxEdgeDevice_564502,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsCreateOrUpdate_564523 = ref object of OpenApiRestCall_563565
proc url_StorageAccountCredentialsCreateOrUpdate_564525(protocol: Scheme;
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

proc validate_StorageAccountCredentialsCreateOrUpdate_564524(path: JsonNode;
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
  var valid_564526 = path.getOrDefault("name")
  valid_564526 = validateParameter(valid_564526, JString, required = true,
                                 default = nil)
  if valid_564526 != nil:
    section.add "name", valid_564526
  var valid_564527 = path.getOrDefault("subscriptionId")
  valid_564527 = validateParameter(valid_564527, JString, required = true,
                                 default = nil)
  if valid_564527 != nil:
    section.add "subscriptionId", valid_564527
  var valid_564528 = path.getOrDefault("deviceName")
  valid_564528 = validateParameter(valid_564528, JString, required = true,
                                 default = nil)
  if valid_564528 != nil:
    section.add "deviceName", valid_564528
  var valid_564529 = path.getOrDefault("resourceGroupName")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "resourceGroupName", valid_564529
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564530 = query.getOrDefault("api-version")
  valid_564530 = validateParameter(valid_564530, JString, required = true,
                                 default = nil)
  if valid_564530 != nil:
    section.add "api-version", valid_564530
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

proc call*(call_564532: Call_StorageAccountCredentialsCreateOrUpdate_564523;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the storage account credential.
  ## 
  let valid = call_564532.validator(path, query, header, formData, body)
  let scheme = call_564532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564532.url(scheme.get, call_564532.host, call_564532.base,
                         call_564532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564532, url, valid)

proc call*(call_564533: Call_StorageAccountCredentialsCreateOrUpdate_564523;
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
  var path_564534 = newJObject()
  var query_564535 = newJObject()
  var body_564536 = newJObject()
  add(query_564535, "api-version", newJString(apiVersion))
  add(path_564534, "name", newJString(name))
  add(path_564534, "subscriptionId", newJString(subscriptionId))
  add(path_564534, "deviceName", newJString(deviceName))
  add(path_564534, "resourceGroupName", newJString(resourceGroupName))
  if storageAccountCredential != nil:
    body_564536 = storageAccountCredential
  result = call_564533.call(path_564534, query_564535, nil, nil, body_564536)

var storageAccountCredentialsCreateOrUpdate* = Call_StorageAccountCredentialsCreateOrUpdate_564523(
    name: "storageAccountCredentialsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/storageAccountCredentials/{name}",
    validator: validate_StorageAccountCredentialsCreateOrUpdate_564524, base: "",
    url: url_StorageAccountCredentialsCreateOrUpdate_564525,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsGet_564511 = ref object of OpenApiRestCall_563565
proc url_StorageAccountCredentialsGet_564513(protocol: Scheme; host: string;
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

proc validate_StorageAccountCredentialsGet_564512(path: JsonNode; query: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_564519: Call_StorageAccountCredentialsGet_564511; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified storage account credential.
  ## 
  let valid = call_564519.validator(path, query, header, formData, body)
  let scheme = call_564519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564519.url(scheme.get, call_564519.host, call_564519.base,
                         call_564519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564519, url, valid)

proc call*(call_564520: Call_StorageAccountCredentialsGet_564511;
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
  var path_564521 = newJObject()
  var query_564522 = newJObject()
  add(query_564522, "api-version", newJString(apiVersion))
  add(path_564521, "name", newJString(name))
  add(path_564521, "subscriptionId", newJString(subscriptionId))
  add(path_564521, "deviceName", newJString(deviceName))
  add(path_564521, "resourceGroupName", newJString(resourceGroupName))
  result = call_564520.call(path_564521, query_564522, nil, nil, nil)

var storageAccountCredentialsGet* = Call_StorageAccountCredentialsGet_564511(
    name: "storageAccountCredentialsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/storageAccountCredentials/{name}",
    validator: validate_StorageAccountCredentialsGet_564512, base: "",
    url: url_StorageAccountCredentialsGet_564513, schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsDelete_564537 = ref object of OpenApiRestCall_563565
proc url_StorageAccountCredentialsDelete_564539(protocol: Scheme; host: string;
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

proc validate_StorageAccountCredentialsDelete_564538(path: JsonNode;
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
  var valid_564540 = path.getOrDefault("name")
  valid_564540 = validateParameter(valid_564540, JString, required = true,
                                 default = nil)
  if valid_564540 != nil:
    section.add "name", valid_564540
  var valid_564541 = path.getOrDefault("subscriptionId")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "subscriptionId", valid_564541
  var valid_564542 = path.getOrDefault("deviceName")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "deviceName", valid_564542
  var valid_564543 = path.getOrDefault("resourceGroupName")
  valid_564543 = validateParameter(valid_564543, JString, required = true,
                                 default = nil)
  if valid_564543 != nil:
    section.add "resourceGroupName", valid_564543
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564544 = query.getOrDefault("api-version")
  valid_564544 = validateParameter(valid_564544, JString, required = true,
                                 default = nil)
  if valid_564544 != nil:
    section.add "api-version", valid_564544
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564545: Call_StorageAccountCredentialsDelete_564537;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the storage account credential.
  ## 
  let valid = call_564545.validator(path, query, header, formData, body)
  let scheme = call_564545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564545.url(scheme.get, call_564545.host, call_564545.base,
                         call_564545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564545, url, valid)

proc call*(call_564546: Call_StorageAccountCredentialsDelete_564537;
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
  var path_564547 = newJObject()
  var query_564548 = newJObject()
  add(query_564548, "api-version", newJString(apiVersion))
  add(path_564547, "name", newJString(name))
  add(path_564547, "subscriptionId", newJString(subscriptionId))
  add(path_564547, "deviceName", newJString(deviceName))
  add(path_564547, "resourceGroupName", newJString(resourceGroupName))
  result = call_564546.call(path_564547, query_564548, nil, nil, nil)

var storageAccountCredentialsDelete* = Call_StorageAccountCredentialsDelete_564537(
    name: "storageAccountCredentialsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/storageAccountCredentials/{name}",
    validator: validate_StorageAccountCredentialsDelete_564538, base: "",
    url: url_StorageAccountCredentialsDelete_564539, schemes: {Scheme.Https})
type
  Call_TriggersListByDataBoxEdgeDevice_564549 = ref object of OpenApiRestCall_563565
proc url_TriggersListByDataBoxEdgeDevice_564551(protocol: Scheme; host: string;
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

proc validate_TriggersListByDataBoxEdgeDevice_564550(path: JsonNode;
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
  var valid_564552 = path.getOrDefault("subscriptionId")
  valid_564552 = validateParameter(valid_564552, JString, required = true,
                                 default = nil)
  if valid_564552 != nil:
    section.add "subscriptionId", valid_564552
  var valid_564553 = path.getOrDefault("deviceName")
  valid_564553 = validateParameter(valid_564553, JString, required = true,
                                 default = nil)
  if valid_564553 != nil:
    section.add "deviceName", valid_564553
  var valid_564554 = path.getOrDefault("resourceGroupName")
  valid_564554 = validateParameter(valid_564554, JString, required = true,
                                 default = nil)
  if valid_564554 != nil:
    section.add "resourceGroupName", valid_564554
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $expand: JString
  ##          : Specify $filter='CustomContextTag eq <tag>' to filter on custom context tag property
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564555 = query.getOrDefault("api-version")
  valid_564555 = validateParameter(valid_564555, JString, required = true,
                                 default = nil)
  if valid_564555 != nil:
    section.add "api-version", valid_564555
  var valid_564556 = query.getOrDefault("$expand")
  valid_564556 = validateParameter(valid_564556, JString, required = false,
                                 default = nil)
  if valid_564556 != nil:
    section.add "$expand", valid_564556
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564557: Call_TriggersListByDataBoxEdgeDevice_564549;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the triggers configured in the device.
  ## 
  let valid = call_564557.validator(path, query, header, formData, body)
  let scheme = call_564557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564557.url(scheme.get, call_564557.host, call_564557.base,
                         call_564557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564557, url, valid)

proc call*(call_564558: Call_TriggersListByDataBoxEdgeDevice_564549;
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
  var path_564559 = newJObject()
  var query_564560 = newJObject()
  add(query_564560, "api-version", newJString(apiVersion))
  add(query_564560, "$expand", newJString(Expand))
  add(path_564559, "subscriptionId", newJString(subscriptionId))
  add(path_564559, "deviceName", newJString(deviceName))
  add(path_564559, "resourceGroupName", newJString(resourceGroupName))
  result = call_564558.call(path_564559, query_564560, nil, nil, nil)

var triggersListByDataBoxEdgeDevice* = Call_TriggersListByDataBoxEdgeDevice_564549(
    name: "triggersListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/triggers",
    validator: validate_TriggersListByDataBoxEdgeDevice_564550, base: "",
    url: url_TriggersListByDataBoxEdgeDevice_564551, schemes: {Scheme.Https})
type
  Call_TriggersCreateOrUpdate_564573 = ref object of OpenApiRestCall_563565
proc url_TriggersCreateOrUpdate_564575(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersCreateOrUpdate_564574(path: JsonNode; query: JsonNode;
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
  var valid_564576 = path.getOrDefault("name")
  valid_564576 = validateParameter(valid_564576, JString, required = true,
                                 default = nil)
  if valid_564576 != nil:
    section.add "name", valid_564576
  var valid_564577 = path.getOrDefault("subscriptionId")
  valid_564577 = validateParameter(valid_564577, JString, required = true,
                                 default = nil)
  if valid_564577 != nil:
    section.add "subscriptionId", valid_564577
  var valid_564578 = path.getOrDefault("deviceName")
  valid_564578 = validateParameter(valid_564578, JString, required = true,
                                 default = nil)
  if valid_564578 != nil:
    section.add "deviceName", valid_564578
  var valid_564579 = path.getOrDefault("resourceGroupName")
  valid_564579 = validateParameter(valid_564579, JString, required = true,
                                 default = nil)
  if valid_564579 != nil:
    section.add "resourceGroupName", valid_564579
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564580 = query.getOrDefault("api-version")
  valid_564580 = validateParameter(valid_564580, JString, required = true,
                                 default = nil)
  if valid_564580 != nil:
    section.add "api-version", valid_564580
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

proc call*(call_564582: Call_TriggersCreateOrUpdate_564573; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a trigger.
  ## 
  let valid = call_564582.validator(path, query, header, formData, body)
  let scheme = call_564582.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564582.url(scheme.get, call_564582.host, call_564582.base,
                         call_564582.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564582, url, valid)

proc call*(call_564583: Call_TriggersCreateOrUpdate_564573; apiVersion: string;
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
  var path_564584 = newJObject()
  var query_564585 = newJObject()
  var body_564586 = newJObject()
  add(query_564585, "api-version", newJString(apiVersion))
  add(path_564584, "name", newJString(name))
  add(path_564584, "subscriptionId", newJString(subscriptionId))
  add(path_564584, "deviceName", newJString(deviceName))
  add(path_564584, "resourceGroupName", newJString(resourceGroupName))
  if trigger != nil:
    body_564586 = trigger
  result = call_564583.call(path_564584, query_564585, nil, nil, body_564586)

var triggersCreateOrUpdate* = Call_TriggersCreateOrUpdate_564573(
    name: "triggersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/triggers/{name}",
    validator: validate_TriggersCreateOrUpdate_564574, base: "",
    url: url_TriggersCreateOrUpdate_564575, schemes: {Scheme.Https})
type
  Call_TriggersGet_564561 = ref object of OpenApiRestCall_563565
proc url_TriggersGet_564563(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersGet_564562(path: JsonNode; query: JsonNode; header: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_564569: Call_TriggersGet_564561; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific trigger by name.
  ## 
  let valid = call_564569.validator(path, query, header, formData, body)
  let scheme = call_564569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564569.url(scheme.get, call_564569.host, call_564569.base,
                         call_564569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564569, url, valid)

proc call*(call_564570: Call_TriggersGet_564561; apiVersion: string; name: string;
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
  var path_564571 = newJObject()
  var query_564572 = newJObject()
  add(query_564572, "api-version", newJString(apiVersion))
  add(path_564571, "name", newJString(name))
  add(path_564571, "subscriptionId", newJString(subscriptionId))
  add(path_564571, "deviceName", newJString(deviceName))
  add(path_564571, "resourceGroupName", newJString(resourceGroupName))
  result = call_564570.call(path_564571, query_564572, nil, nil, nil)

var triggersGet* = Call_TriggersGet_564561(name: "triggersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/triggers/{name}",
                                        validator: validate_TriggersGet_564562,
                                        base: "", url: url_TriggersGet_564563,
                                        schemes: {Scheme.Https})
type
  Call_TriggersDelete_564587 = ref object of OpenApiRestCall_563565
proc url_TriggersDelete_564589(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersDelete_564588(path: JsonNode; query: JsonNode;
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
  var valid_564590 = path.getOrDefault("name")
  valid_564590 = validateParameter(valid_564590, JString, required = true,
                                 default = nil)
  if valid_564590 != nil:
    section.add "name", valid_564590
  var valid_564591 = path.getOrDefault("subscriptionId")
  valid_564591 = validateParameter(valid_564591, JString, required = true,
                                 default = nil)
  if valid_564591 != nil:
    section.add "subscriptionId", valid_564591
  var valid_564592 = path.getOrDefault("deviceName")
  valid_564592 = validateParameter(valid_564592, JString, required = true,
                                 default = nil)
  if valid_564592 != nil:
    section.add "deviceName", valid_564592
  var valid_564593 = path.getOrDefault("resourceGroupName")
  valid_564593 = validateParameter(valid_564593, JString, required = true,
                                 default = nil)
  if valid_564593 != nil:
    section.add "resourceGroupName", valid_564593
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564594 = query.getOrDefault("api-version")
  valid_564594 = validateParameter(valid_564594, JString, required = true,
                                 default = nil)
  if valid_564594 != nil:
    section.add "api-version", valid_564594
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564595: Call_TriggersDelete_564587; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the trigger on the gateway device.
  ## 
  let valid = call_564595.validator(path, query, header, formData, body)
  let scheme = call_564595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564595.url(scheme.get, call_564595.host, call_564595.base,
                         call_564595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564595, url, valid)

proc call*(call_564596: Call_TriggersDelete_564587; apiVersion: string; name: string;
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
  var path_564597 = newJObject()
  var query_564598 = newJObject()
  add(query_564598, "api-version", newJString(apiVersion))
  add(path_564597, "name", newJString(name))
  add(path_564597, "subscriptionId", newJString(subscriptionId))
  add(path_564597, "deviceName", newJString(deviceName))
  add(path_564597, "resourceGroupName", newJString(resourceGroupName))
  result = call_564596.call(path_564597, query_564598, nil, nil, nil)

var triggersDelete* = Call_TriggersDelete_564587(name: "triggersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/triggers/{name}",
    validator: validate_TriggersDelete_564588, base: "", url: url_TriggersDelete_564589,
    schemes: {Scheme.Https})
type
  Call_DevicesGetUpdateSummary_564599 = ref object of OpenApiRestCall_563565
proc url_DevicesGetUpdateSummary_564601(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesGetUpdateSummary_564600(path: JsonNode; query: JsonNode;
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
  var valid_564602 = path.getOrDefault("subscriptionId")
  valid_564602 = validateParameter(valid_564602, JString, required = true,
                                 default = nil)
  if valid_564602 != nil:
    section.add "subscriptionId", valid_564602
  var valid_564603 = path.getOrDefault("deviceName")
  valid_564603 = validateParameter(valid_564603, JString, required = true,
                                 default = nil)
  if valid_564603 != nil:
    section.add "deviceName", valid_564603
  var valid_564604 = path.getOrDefault("resourceGroupName")
  valid_564604 = validateParameter(valid_564604, JString, required = true,
                                 default = nil)
  if valid_564604 != nil:
    section.add "resourceGroupName", valid_564604
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564605 = query.getOrDefault("api-version")
  valid_564605 = validateParameter(valid_564605, JString, required = true,
                                 default = nil)
  if valid_564605 != nil:
    section.add "api-version", valid_564605
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564606: Call_DevicesGetUpdateSummary_564599; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564606.validator(path, query, header, formData, body)
  let scheme = call_564606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564606.url(scheme.get, call_564606.host, call_564606.base,
                         call_564606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564606, url, valid)

proc call*(call_564607: Call_DevicesGetUpdateSummary_564599; apiVersion: string;
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
  var path_564608 = newJObject()
  var query_564609 = newJObject()
  add(query_564609, "api-version", newJString(apiVersion))
  add(path_564608, "subscriptionId", newJString(subscriptionId))
  add(path_564608, "deviceName", newJString(deviceName))
  add(path_564608, "resourceGroupName", newJString(resourceGroupName))
  result = call_564607.call(path_564608, query_564609, nil, nil, nil)

var devicesGetUpdateSummary* = Call_DevicesGetUpdateSummary_564599(
    name: "devicesGetUpdateSummary", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/updateSummary/default",
    validator: validate_DevicesGetUpdateSummary_564600, base: "",
    url: url_DevicesGetUpdateSummary_564601, schemes: {Scheme.Https})
type
  Call_DevicesUploadCertificate_564610 = ref object of OpenApiRestCall_563565
proc url_DevicesUploadCertificate_564612(protocol: Scheme; host: string;
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

proc validate_DevicesUploadCertificate_564611(path: JsonNode; query: JsonNode;
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
  var valid_564613 = path.getOrDefault("subscriptionId")
  valid_564613 = validateParameter(valid_564613, JString, required = true,
                                 default = nil)
  if valid_564613 != nil:
    section.add "subscriptionId", valid_564613
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564616 = query.getOrDefault("api-version")
  valid_564616 = validateParameter(valid_564616, JString, required = true,
                                 default = nil)
  if valid_564616 != nil:
    section.add "api-version", valid_564616
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

proc call*(call_564618: Call_DevicesUploadCertificate_564610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads registration certificate for the device.
  ## 
  let valid = call_564618.validator(path, query, header, formData, body)
  let scheme = call_564618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564618.url(scheme.get, call_564618.host, call_564618.base,
                         call_564618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564618, url, valid)

proc call*(call_564619: Call_DevicesUploadCertificate_564610; apiVersion: string;
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
  var path_564620 = newJObject()
  var query_564621 = newJObject()
  var body_564622 = newJObject()
  add(query_564621, "api-version", newJString(apiVersion))
  add(path_564620, "subscriptionId", newJString(subscriptionId))
  add(path_564620, "deviceName", newJString(deviceName))
  add(path_564620, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564622 = parameters
  result = call_564619.call(path_564620, query_564621, nil, nil, body_564622)

var devicesUploadCertificate* = Call_DevicesUploadCertificate_564610(
    name: "devicesUploadCertificate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/uploadCertificate",
    validator: validate_DevicesUploadCertificate_564611, base: "",
    url: url_DevicesUploadCertificate_564612, schemes: {Scheme.Https})
type
  Call_UsersListByDataBoxEdgeDevice_564623 = ref object of OpenApiRestCall_563565
proc url_UsersListByDataBoxEdgeDevice_564625(protocol: Scheme; host: string;
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

proc validate_UsersListByDataBoxEdgeDevice_564624(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the users registered on a Data Box Edge/Data Box Gateway device.
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

proc call*(call_564630: Call_UsersListByDataBoxEdgeDevice_564623; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the users registered on a Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_564630.validator(path, query, header, formData, body)
  let scheme = call_564630.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564630.url(scheme.get, call_564630.host, call_564630.base,
                         call_564630.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564630, url, valid)

proc call*(call_564631: Call_UsersListByDataBoxEdgeDevice_564623;
          apiVersion: string; subscriptionId: string; deviceName: string;
          resourceGroupName: string): Recallable =
  ## usersListByDataBoxEdgeDevice
  ## Gets all the users registered on a Data Box Edge/Data Box Gateway device.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564632 = newJObject()
  var query_564633 = newJObject()
  add(query_564633, "api-version", newJString(apiVersion))
  add(path_564632, "subscriptionId", newJString(subscriptionId))
  add(path_564632, "deviceName", newJString(deviceName))
  add(path_564632, "resourceGroupName", newJString(resourceGroupName))
  result = call_564631.call(path_564632, query_564633, nil, nil, nil)

var usersListByDataBoxEdgeDevice* = Call_UsersListByDataBoxEdgeDevice_564623(
    name: "usersListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/users",
    validator: validate_UsersListByDataBoxEdgeDevice_564624, base: "",
    url: url_UsersListByDataBoxEdgeDevice_564625, schemes: {Scheme.Https})
type
  Call_UsersCreateOrUpdate_564646 = ref object of OpenApiRestCall_563565
proc url_UsersCreateOrUpdate_564648(protocol: Scheme; host: string; base: string;
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

proc validate_UsersCreateOrUpdate_564647(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a new user or updates an existing user's information on a Data Box Edge/Data Box Gateway device.
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
  var valid_564649 = path.getOrDefault("name")
  valid_564649 = validateParameter(valid_564649, JString, required = true,
                                 default = nil)
  if valid_564649 != nil:
    section.add "name", valid_564649
  var valid_564650 = path.getOrDefault("subscriptionId")
  valid_564650 = validateParameter(valid_564650, JString, required = true,
                                 default = nil)
  if valid_564650 != nil:
    section.add "subscriptionId", valid_564650
  var valid_564651 = path.getOrDefault("deviceName")
  valid_564651 = validateParameter(valid_564651, JString, required = true,
                                 default = nil)
  if valid_564651 != nil:
    section.add "deviceName", valid_564651
  var valid_564652 = path.getOrDefault("resourceGroupName")
  valid_564652 = validateParameter(valid_564652, JString, required = true,
                                 default = nil)
  if valid_564652 != nil:
    section.add "resourceGroupName", valid_564652
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564653 = query.getOrDefault("api-version")
  valid_564653 = validateParameter(valid_564653, JString, required = true,
                                 default = nil)
  if valid_564653 != nil:
    section.add "api-version", valid_564653
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

proc call*(call_564655: Call_UsersCreateOrUpdate_564646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new user or updates an existing user's information on a Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_564655.validator(path, query, header, formData, body)
  let scheme = call_564655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564655.url(scheme.get, call_564655.host, call_564655.base,
                         call_564655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564655, url, valid)

proc call*(call_564656: Call_UsersCreateOrUpdate_564646; apiVersion: string;
          name: string; subscriptionId: string; user: JsonNode; deviceName: string;
          resourceGroupName: string): Recallable =
  ## usersCreateOrUpdate
  ## Creates a new user or updates an existing user's information on a Data Box Edge/Data Box Gateway device.
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
  var path_564657 = newJObject()
  var query_564658 = newJObject()
  var body_564659 = newJObject()
  add(query_564658, "api-version", newJString(apiVersion))
  add(path_564657, "name", newJString(name))
  add(path_564657, "subscriptionId", newJString(subscriptionId))
  if user != nil:
    body_564659 = user
  add(path_564657, "deviceName", newJString(deviceName))
  add(path_564657, "resourceGroupName", newJString(resourceGroupName))
  result = call_564656.call(path_564657, query_564658, nil, nil, body_564659)

var usersCreateOrUpdate* = Call_UsersCreateOrUpdate_564646(
    name: "usersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/users/{name}",
    validator: validate_UsersCreateOrUpdate_564647, base: "",
    url: url_UsersCreateOrUpdate_564648, schemes: {Scheme.Https})
type
  Call_UsersGet_564634 = ref object of OpenApiRestCall_563565
proc url_UsersGet_564636(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsersGet_564635(path: JsonNode; query: JsonNode; header: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_564642: Call_UsersGet_564634; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified user.
  ## 
  let valid = call_564642.validator(path, query, header, formData, body)
  let scheme = call_564642.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564642.url(scheme.get, call_564642.host, call_564642.base,
                         call_564642.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564642, url, valid)

proc call*(call_564643: Call_UsersGet_564634; apiVersion: string; name: string;
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
  var path_564644 = newJObject()
  var query_564645 = newJObject()
  add(query_564645, "api-version", newJString(apiVersion))
  add(path_564644, "name", newJString(name))
  add(path_564644, "subscriptionId", newJString(subscriptionId))
  add(path_564644, "deviceName", newJString(deviceName))
  add(path_564644, "resourceGroupName", newJString(resourceGroupName))
  result = call_564643.call(path_564644, query_564645, nil, nil, nil)

var usersGet* = Call_UsersGet_564634(name: "usersGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/users/{name}",
                                  validator: validate_UsersGet_564635, base: "",
                                  url: url_UsersGet_564636,
                                  schemes: {Scheme.Https})
type
  Call_UsersDelete_564660 = ref object of OpenApiRestCall_563565
proc url_UsersDelete_564662(protocol: Scheme; host: string; base: string;
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

proc validate_UsersDelete_564661(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564663 = path.getOrDefault("name")
  valid_564663 = validateParameter(valid_564663, JString, required = true,
                                 default = nil)
  if valid_564663 != nil:
    section.add "name", valid_564663
  var valid_564664 = path.getOrDefault("subscriptionId")
  valid_564664 = validateParameter(valid_564664, JString, required = true,
                                 default = nil)
  if valid_564664 != nil:
    section.add "subscriptionId", valid_564664
  var valid_564665 = path.getOrDefault("deviceName")
  valid_564665 = validateParameter(valid_564665, JString, required = true,
                                 default = nil)
  if valid_564665 != nil:
    section.add "deviceName", valid_564665
  var valid_564666 = path.getOrDefault("resourceGroupName")
  valid_564666 = validateParameter(valid_564666, JString, required = true,
                                 default = nil)
  if valid_564666 != nil:
    section.add "resourceGroupName", valid_564666
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_564668: Call_UsersDelete_564660; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the user on a databox edge/gateway device.
  ## 
  let valid = call_564668.validator(path, query, header, formData, body)
  let scheme = call_564668.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564668.url(scheme.get, call_564668.host, call_564668.base,
                         call_564668.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564668, url, valid)

proc call*(call_564669: Call_UsersDelete_564660; apiVersion: string; name: string;
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
  var path_564670 = newJObject()
  var query_564671 = newJObject()
  add(query_564671, "api-version", newJString(apiVersion))
  add(path_564670, "name", newJString(name))
  add(path_564670, "subscriptionId", newJString(subscriptionId))
  add(path_564670, "deviceName", newJString(deviceName))
  add(path_564670, "resourceGroupName", newJString(resourceGroupName))
  result = call_564669.call(path_564670, query_564671, nil, nil, nil)

var usersDelete* = Call_UsersDelete_564660(name: "usersDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/users/{name}",
                                        validator: validate_UsersDelete_564661,
                                        base: "", url: url_UsersDelete_564662,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
