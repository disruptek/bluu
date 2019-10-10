
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

  OpenApiRestCall_573666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573666): Option[Scheme] {.used.} =
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
  macServiceName = "databoxedge"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_573888 = ref object of OpenApiRestCall_573666
proc url_OperationsList_573890(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_573889(path: JsonNode; query: JsonNode;
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
  var valid_574049 = query.getOrDefault("api-version")
  valid_574049 = validateParameter(valid_574049, JString, required = true,
                                 default = nil)
  if valid_574049 != nil:
    section.add "api-version", valid_574049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574072: Call_OperationsList_573888; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574072.validator(path, query, header, formData, body)
  let scheme = call_574072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574072.url(scheme.get, call_574072.host, call_574072.base,
                         call_574072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574072, url, valid)

proc call*(call_574143: Call_OperationsList_573888; apiVersion: string): Recallable =
  ## operationsList
  ##   apiVersion: string (required)
  ##             : The API version.
  var query_574144 = newJObject()
  add(query_574144, "api-version", newJString(apiVersion))
  result = call_574143.call(nil, query_574144, nil, nil, nil)

var operationsList* = Call_OperationsList_573888(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataBoxEdge/operations",
    validator: validate_OperationsList_573889, base: "", url: url_OperationsList_573890,
    schemes: {Scheme.Https})
type
  Call_DevicesListBySubscription_574184 = ref object of OpenApiRestCall_573666
proc url_DevicesListBySubscription_574186(protocol: Scheme; host: string;
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

proc validate_DevicesListBySubscription_574185(path: JsonNode; query: JsonNode;
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
  var valid_574202 = path.getOrDefault("subscriptionId")
  valid_574202 = validateParameter(valid_574202, JString, required = true,
                                 default = nil)
  if valid_574202 != nil:
    section.add "subscriptionId", valid_574202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the resource or Specify $skipToken=<token> to populate the next page in the list.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574203 = query.getOrDefault("api-version")
  valid_574203 = validateParameter(valid_574203, JString, required = true,
                                 default = nil)
  if valid_574203 != nil:
    section.add "api-version", valid_574203
  var valid_574204 = query.getOrDefault("$expand")
  valid_574204 = validateParameter(valid_574204, JString, required = false,
                                 default = nil)
  if valid_574204 != nil:
    section.add "$expand", valid_574204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574205: Call_DevicesListBySubscription_574184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the data box edge/gateway devices in a subscription.
  ## 
  let valid = call_574205.validator(path, query, header, formData, body)
  let scheme = call_574205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574205.url(scheme.get, call_574205.host, call_574205.base,
                         call_574205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574205, url, valid)

proc call*(call_574206: Call_DevicesListBySubscription_574184; apiVersion: string;
          subscriptionId: string; Expand: string = ""): Recallable =
  ## devicesListBySubscription
  ## Gets all the data box edge/gateway devices in a subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Expand: string
  ##         : Specify $expand=details to populate additional fields related to the resource or Specify $skipToken=<token> to populate the next page in the list.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_574207 = newJObject()
  var query_574208 = newJObject()
  add(query_574208, "api-version", newJString(apiVersion))
  add(query_574208, "$expand", newJString(Expand))
  add(path_574207, "subscriptionId", newJString(subscriptionId))
  result = call_574206.call(path_574207, query_574208, nil, nil, nil)

var devicesListBySubscription* = Call_DevicesListBySubscription_574184(
    name: "devicesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices",
    validator: validate_DevicesListBySubscription_574185, base: "",
    url: url_DevicesListBySubscription_574186, schemes: {Scheme.Https})
type
  Call_DevicesListByResourceGroup_574209 = ref object of OpenApiRestCall_573666
proc url_DevicesListByResourceGroup_574211(protocol: Scheme; host: string;
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

proc validate_DevicesListByResourceGroup_574210(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the data box edge/gateway devices in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574212 = path.getOrDefault("resourceGroupName")
  valid_574212 = validateParameter(valid_574212, JString, required = true,
                                 default = nil)
  if valid_574212 != nil:
    section.add "resourceGroupName", valid_574212
  var valid_574213 = path.getOrDefault("subscriptionId")
  valid_574213 = validateParameter(valid_574213, JString, required = true,
                                 default = nil)
  if valid_574213 != nil:
    section.add "subscriptionId", valid_574213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the resource or Specify $skipToken=<token> to populate the next page in the list.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574214 = query.getOrDefault("api-version")
  valid_574214 = validateParameter(valid_574214, JString, required = true,
                                 default = nil)
  if valid_574214 != nil:
    section.add "api-version", valid_574214
  var valid_574215 = query.getOrDefault("$expand")
  valid_574215 = validateParameter(valid_574215, JString, required = false,
                                 default = nil)
  if valid_574215 != nil:
    section.add "$expand", valid_574215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574216: Call_DevicesListByResourceGroup_574209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the data box edge/gateway devices in a resource group.
  ## 
  let valid = call_574216.validator(path, query, header, formData, body)
  let scheme = call_574216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574216.url(scheme.get, call_574216.host, call_574216.base,
                         call_574216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574216, url, valid)

proc call*(call_574217: Call_DevicesListByResourceGroup_574209;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Expand: string = ""): Recallable =
  ## devicesListByResourceGroup
  ## Gets all the data box edge/gateway devices in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Expand: string
  ##         : Specify $expand=details to populate additional fields related to the resource or Specify $skipToken=<token> to populate the next page in the list.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_574218 = newJObject()
  var query_574219 = newJObject()
  add(path_574218, "resourceGroupName", newJString(resourceGroupName))
  add(query_574219, "api-version", newJString(apiVersion))
  add(query_574219, "$expand", newJString(Expand))
  add(path_574218, "subscriptionId", newJString(subscriptionId))
  result = call_574217.call(path_574218, query_574219, nil, nil, nil)

var devicesListByResourceGroup* = Call_DevicesListByResourceGroup_574209(
    name: "devicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices",
    validator: validate_DevicesListByResourceGroup_574210, base: "",
    url: url_DevicesListByResourceGroup_574211, schemes: {Scheme.Https})
type
  Call_DevicesCreateOrUpdate_574231 = ref object of OpenApiRestCall_573666
proc url_DevicesCreateOrUpdate_574233(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesCreateOrUpdate_574232(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a Data Box Edge/Gateway resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574234 = path.getOrDefault("resourceGroupName")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "resourceGroupName", valid_574234
  var valid_574235 = path.getOrDefault("subscriptionId")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "subscriptionId", valid_574235
  var valid_574236 = path.getOrDefault("deviceName")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = nil)
  if valid_574236 != nil:
    section.add "deviceName", valid_574236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574237 = query.getOrDefault("api-version")
  valid_574237 = validateParameter(valid_574237, JString, required = true,
                                 default = nil)
  if valid_574237 != nil:
    section.add "api-version", valid_574237
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

proc call*(call_574239: Call_DevicesCreateOrUpdate_574231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Data Box Edge/Gateway resource.
  ## 
  let valid = call_574239.validator(path, query, header, formData, body)
  let scheme = call_574239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574239.url(scheme.get, call_574239.host, call_574239.base,
                         call_574239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574239, url, valid)

proc call*(call_574240: Call_DevicesCreateOrUpdate_574231;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          DataBoxEdgeDevice: JsonNode; deviceName: string): Recallable =
  ## devicesCreateOrUpdate
  ## Creates or updates a Data Box Edge/Gateway resource.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   DataBoxEdgeDevice: JObject (required)
  ##                    : The resource object.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574241 = newJObject()
  var query_574242 = newJObject()
  var body_574243 = newJObject()
  add(path_574241, "resourceGroupName", newJString(resourceGroupName))
  add(query_574242, "api-version", newJString(apiVersion))
  add(path_574241, "subscriptionId", newJString(subscriptionId))
  if DataBoxEdgeDevice != nil:
    body_574243 = DataBoxEdgeDevice
  add(path_574241, "deviceName", newJString(deviceName))
  result = call_574240.call(path_574241, query_574242, nil, nil, body_574243)

var devicesCreateOrUpdate* = Call_DevicesCreateOrUpdate_574231(
    name: "devicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}",
    validator: validate_DevicesCreateOrUpdate_574232, base: "",
    url: url_DevicesCreateOrUpdate_574233, schemes: {Scheme.Https})
type
  Call_DevicesGet_574220 = ref object of OpenApiRestCall_573666
proc url_DevicesGet_574222(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DevicesGet_574221(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574223 = path.getOrDefault("resourceGroupName")
  valid_574223 = validateParameter(valid_574223, JString, required = true,
                                 default = nil)
  if valid_574223 != nil:
    section.add "resourceGroupName", valid_574223
  var valid_574224 = path.getOrDefault("subscriptionId")
  valid_574224 = validateParameter(valid_574224, JString, required = true,
                                 default = nil)
  if valid_574224 != nil:
    section.add "subscriptionId", valid_574224
  var valid_574225 = path.getOrDefault("deviceName")
  valid_574225 = validateParameter(valid_574225, JString, required = true,
                                 default = nil)
  if valid_574225 != nil:
    section.add "deviceName", valid_574225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574226 = query.getOrDefault("api-version")
  valid_574226 = validateParameter(valid_574226, JString, required = true,
                                 default = nil)
  if valid_574226 != nil:
    section.add "api-version", valid_574226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574227: Call_DevicesGet_574220; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the data box edge/gateway device.
  ## 
  let valid = call_574227.validator(path, query, header, formData, body)
  let scheme = call_574227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574227.url(scheme.get, call_574227.host, call_574227.base,
                         call_574227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574227, url, valid)

proc call*(call_574228: Call_DevicesGet_574220; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; deviceName: string): Recallable =
  ## devicesGet
  ## Gets the properties of the data box edge/gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574229 = newJObject()
  var query_574230 = newJObject()
  add(path_574229, "resourceGroupName", newJString(resourceGroupName))
  add(query_574230, "api-version", newJString(apiVersion))
  add(path_574229, "subscriptionId", newJString(subscriptionId))
  add(path_574229, "deviceName", newJString(deviceName))
  result = call_574228.call(path_574229, query_574230, nil, nil, nil)

var devicesGet* = Call_DevicesGet_574220(name: "devicesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}",
                                      validator: validate_DevicesGet_574221,
                                      base: "", url: url_DevicesGet_574222,
                                      schemes: {Scheme.Https})
type
  Call_DevicesUpdate_574255 = ref object of OpenApiRestCall_573666
proc url_DevicesUpdate_574257(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesUpdate_574256(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies a Data Box Edge/Gateway resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574258 = path.getOrDefault("resourceGroupName")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "resourceGroupName", valid_574258
  var valid_574259 = path.getOrDefault("subscriptionId")
  valid_574259 = validateParameter(valid_574259, JString, required = true,
                                 default = nil)
  if valid_574259 != nil:
    section.add "subscriptionId", valid_574259
  var valid_574260 = path.getOrDefault("deviceName")
  valid_574260 = validateParameter(valid_574260, JString, required = true,
                                 default = nil)
  if valid_574260 != nil:
    section.add "deviceName", valid_574260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574261 = query.getOrDefault("api-version")
  valid_574261 = validateParameter(valid_574261, JString, required = true,
                                 default = nil)
  if valid_574261 != nil:
    section.add "api-version", valid_574261
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

proc call*(call_574263: Call_DevicesUpdate_574255; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a Data Box Edge/Gateway resource.
  ## 
  let valid = call_574263.validator(path, query, header, formData, body)
  let scheme = call_574263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574263.url(scheme.get, call_574263.host, call_574263.base,
                         call_574263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574263, url, valid)

proc call*(call_574264: Call_DevicesUpdate_574255; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          deviceName: string): Recallable =
  ## devicesUpdate
  ## Modifies a Data Box Edge/Gateway resource.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   parameters: JObject (required)
  ##             : The resource parameters.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574265 = newJObject()
  var query_574266 = newJObject()
  var body_574267 = newJObject()
  add(path_574265, "resourceGroupName", newJString(resourceGroupName))
  add(query_574266, "api-version", newJString(apiVersion))
  add(path_574265, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574267 = parameters
  add(path_574265, "deviceName", newJString(deviceName))
  result = call_574264.call(path_574265, query_574266, nil, nil, body_574267)

var devicesUpdate* = Call_DevicesUpdate_574255(name: "devicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}",
    validator: validate_DevicesUpdate_574256, base: "", url: url_DevicesUpdate_574257,
    schemes: {Scheme.Https})
type
  Call_DevicesDelete_574244 = ref object of OpenApiRestCall_573666
proc url_DevicesDelete_574246(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesDelete_574245(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574247 = path.getOrDefault("resourceGroupName")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "resourceGroupName", valid_574247
  var valid_574248 = path.getOrDefault("subscriptionId")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "subscriptionId", valid_574248
  var valid_574249 = path.getOrDefault("deviceName")
  valid_574249 = validateParameter(valid_574249, JString, required = true,
                                 default = nil)
  if valid_574249 != nil:
    section.add "deviceName", valid_574249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574250 = query.getOrDefault("api-version")
  valid_574250 = validateParameter(valid_574250, JString, required = true,
                                 default = nil)
  if valid_574250 != nil:
    section.add "api-version", valid_574250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574251: Call_DevicesDelete_574244; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the data box edge/gateway device.
  ## 
  let valid = call_574251.validator(path, query, header, formData, body)
  let scheme = call_574251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574251.url(scheme.get, call_574251.host, call_574251.base,
                         call_574251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574251, url, valid)

proc call*(call_574252: Call_DevicesDelete_574244; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; deviceName: string): Recallable =
  ## devicesDelete
  ## Deletes the data box edge/gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574253 = newJObject()
  var query_574254 = newJObject()
  add(path_574253, "resourceGroupName", newJString(resourceGroupName))
  add(query_574254, "api-version", newJString(apiVersion))
  add(path_574253, "subscriptionId", newJString(subscriptionId))
  add(path_574253, "deviceName", newJString(deviceName))
  result = call_574252.call(path_574253, query_574254, nil, nil, nil)

var devicesDelete* = Call_DevicesDelete_574244(name: "devicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}",
    validator: validate_DevicesDelete_574245, base: "", url: url_DevicesDelete_574246,
    schemes: {Scheme.Https})
type
  Call_AlertsListByDataBoxEdgeDevice_574268 = ref object of OpenApiRestCall_573666
proc url_AlertsListByDataBoxEdgeDevice_574270(protocol: Scheme; host: string;
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

proc validate_AlertsListByDataBoxEdgeDevice_574269(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the alerts for a data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574271 = path.getOrDefault("resourceGroupName")
  valid_574271 = validateParameter(valid_574271, JString, required = true,
                                 default = nil)
  if valid_574271 != nil:
    section.add "resourceGroupName", valid_574271
  var valid_574272 = path.getOrDefault("subscriptionId")
  valid_574272 = validateParameter(valid_574272, JString, required = true,
                                 default = nil)
  if valid_574272 != nil:
    section.add "subscriptionId", valid_574272
  var valid_574273 = path.getOrDefault("deviceName")
  valid_574273 = validateParameter(valid_574273, JString, required = true,
                                 default = nil)
  if valid_574273 != nil:
    section.add "deviceName", valid_574273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574274 = query.getOrDefault("api-version")
  valid_574274 = validateParameter(valid_574274, JString, required = true,
                                 default = nil)
  if valid_574274 != nil:
    section.add "api-version", valid_574274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574275: Call_AlertsListByDataBoxEdgeDevice_574268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the alerts for a data box edge/gateway device.
  ## 
  let valid = call_574275.validator(path, query, header, formData, body)
  let scheme = call_574275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574275.url(scheme.get, call_574275.host, call_574275.base,
                         call_574275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574275, url, valid)

proc call*(call_574276: Call_AlertsListByDataBoxEdgeDevice_574268;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## alertsListByDataBoxEdgeDevice
  ## Gets all the alerts for a data box edge/gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574277 = newJObject()
  var query_574278 = newJObject()
  add(path_574277, "resourceGroupName", newJString(resourceGroupName))
  add(query_574278, "api-version", newJString(apiVersion))
  add(path_574277, "subscriptionId", newJString(subscriptionId))
  add(path_574277, "deviceName", newJString(deviceName))
  result = call_574276.call(path_574277, query_574278, nil, nil, nil)

var alertsListByDataBoxEdgeDevice* = Call_AlertsListByDataBoxEdgeDevice_574268(
    name: "alertsListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/alerts",
    validator: validate_AlertsListByDataBoxEdgeDevice_574269, base: "",
    url: url_AlertsListByDataBoxEdgeDevice_574270, schemes: {Scheme.Https})
type
  Call_AlertsGet_574279 = ref object of OpenApiRestCall_573666
proc url_AlertsGet_574281(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AlertsGet_574280(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The alert name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574282 = path.getOrDefault("resourceGroupName")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "resourceGroupName", valid_574282
  var valid_574283 = path.getOrDefault("name")
  valid_574283 = validateParameter(valid_574283, JString, required = true,
                                 default = nil)
  if valid_574283 != nil:
    section.add "name", valid_574283
  var valid_574284 = path.getOrDefault("subscriptionId")
  valid_574284 = validateParameter(valid_574284, JString, required = true,
                                 default = nil)
  if valid_574284 != nil:
    section.add "subscriptionId", valid_574284
  var valid_574285 = path.getOrDefault("deviceName")
  valid_574285 = validateParameter(valid_574285, JString, required = true,
                                 default = nil)
  if valid_574285 != nil:
    section.add "deviceName", valid_574285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574286 = query.getOrDefault("api-version")
  valid_574286 = validateParameter(valid_574286, JString, required = true,
                                 default = nil)
  if valid_574286 != nil:
    section.add "api-version", valid_574286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574287: Call_AlertsGet_574279; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574287.validator(path, query, header, formData, body)
  let scheme = call_574287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574287.url(scheme.get, call_574287.host, call_574287.base,
                         call_574287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574287, url, valid)

proc call*(call_574288: Call_AlertsGet_574279; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string; deviceName: string): Recallable =
  ## alertsGet
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The alert name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574289 = newJObject()
  var query_574290 = newJObject()
  add(path_574289, "resourceGroupName", newJString(resourceGroupName))
  add(query_574290, "api-version", newJString(apiVersion))
  add(path_574289, "name", newJString(name))
  add(path_574289, "subscriptionId", newJString(subscriptionId))
  add(path_574289, "deviceName", newJString(deviceName))
  result = call_574288.call(path_574289, query_574290, nil, nil, nil)

var alertsGet* = Call_AlertsGet_574279(name: "alertsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/alerts/{name}",
                                    validator: validate_AlertsGet_574280,
                                    base: "", url: url_AlertsGet_574281,
                                    schemes: {Scheme.Https})
type
  Call_BandwidthSchedulesListByDataBoxEdgeDevice_574291 = ref object of OpenApiRestCall_573666
proc url_BandwidthSchedulesListByDataBoxEdgeDevice_574293(protocol: Scheme;
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

proc validate_BandwidthSchedulesListByDataBoxEdgeDevice_574292(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the bandwidth schedules for a data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574294 = path.getOrDefault("resourceGroupName")
  valid_574294 = validateParameter(valid_574294, JString, required = true,
                                 default = nil)
  if valid_574294 != nil:
    section.add "resourceGroupName", valid_574294
  var valid_574295 = path.getOrDefault("subscriptionId")
  valid_574295 = validateParameter(valid_574295, JString, required = true,
                                 default = nil)
  if valid_574295 != nil:
    section.add "subscriptionId", valid_574295
  var valid_574296 = path.getOrDefault("deviceName")
  valid_574296 = validateParameter(valid_574296, JString, required = true,
                                 default = nil)
  if valid_574296 != nil:
    section.add "deviceName", valid_574296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574297 = query.getOrDefault("api-version")
  valid_574297 = validateParameter(valid_574297, JString, required = true,
                                 default = nil)
  if valid_574297 != nil:
    section.add "api-version", valid_574297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574298: Call_BandwidthSchedulesListByDataBoxEdgeDevice_574291;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the bandwidth schedules for a data box edge/gateway device.
  ## 
  let valid = call_574298.validator(path, query, header, formData, body)
  let scheme = call_574298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574298.url(scheme.get, call_574298.host, call_574298.base,
                         call_574298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574298, url, valid)

proc call*(call_574299: Call_BandwidthSchedulesListByDataBoxEdgeDevice_574291;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## bandwidthSchedulesListByDataBoxEdgeDevice
  ## Gets all the bandwidth schedules for a data box edge/gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574300 = newJObject()
  var query_574301 = newJObject()
  add(path_574300, "resourceGroupName", newJString(resourceGroupName))
  add(query_574301, "api-version", newJString(apiVersion))
  add(path_574300, "subscriptionId", newJString(subscriptionId))
  add(path_574300, "deviceName", newJString(deviceName))
  result = call_574299.call(path_574300, query_574301, nil, nil, nil)

var bandwidthSchedulesListByDataBoxEdgeDevice* = Call_BandwidthSchedulesListByDataBoxEdgeDevice_574291(
    name: "bandwidthSchedulesListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/bandwidthSchedules",
    validator: validate_BandwidthSchedulesListByDataBoxEdgeDevice_574292,
    base: "", url: url_BandwidthSchedulesListByDataBoxEdgeDevice_574293,
    schemes: {Scheme.Https})
type
  Call_BandwidthSchedulesCreateOrUpdate_574314 = ref object of OpenApiRestCall_573666
proc url_BandwidthSchedulesCreateOrUpdate_574316(protocol: Scheme; host: string;
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

proc validate_BandwidthSchedulesCreateOrUpdate_574315(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a bandwidth schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The bandwidth schedule name which needs to be added/updated.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574317 = path.getOrDefault("resourceGroupName")
  valid_574317 = validateParameter(valid_574317, JString, required = true,
                                 default = nil)
  if valid_574317 != nil:
    section.add "resourceGroupName", valid_574317
  var valid_574318 = path.getOrDefault("name")
  valid_574318 = validateParameter(valid_574318, JString, required = true,
                                 default = nil)
  if valid_574318 != nil:
    section.add "name", valid_574318
  var valid_574319 = path.getOrDefault("subscriptionId")
  valid_574319 = validateParameter(valid_574319, JString, required = true,
                                 default = nil)
  if valid_574319 != nil:
    section.add "subscriptionId", valid_574319
  var valid_574320 = path.getOrDefault("deviceName")
  valid_574320 = validateParameter(valid_574320, JString, required = true,
                                 default = nil)
  if valid_574320 != nil:
    section.add "deviceName", valid_574320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574321 = query.getOrDefault("api-version")
  valid_574321 = validateParameter(valid_574321, JString, required = true,
                                 default = nil)
  if valid_574321 != nil:
    section.add "api-version", valid_574321
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

proc call*(call_574323: Call_BandwidthSchedulesCreateOrUpdate_574314;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a bandwidth schedule.
  ## 
  let valid = call_574323.validator(path, query, header, formData, body)
  let scheme = call_574323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574323.url(scheme.get, call_574323.host, call_574323.base,
                         call_574323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574323, url, valid)

proc call*(call_574324: Call_BandwidthSchedulesCreateOrUpdate_574314;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; parameters: JsonNode; deviceName: string): Recallable =
  ## bandwidthSchedulesCreateOrUpdate
  ## Creates or updates a bandwidth schedule.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The bandwidth schedule name which needs to be added/updated.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   parameters: JObject (required)
  ##             : The bandwidth schedule to be added or updated.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574325 = newJObject()
  var query_574326 = newJObject()
  var body_574327 = newJObject()
  add(path_574325, "resourceGroupName", newJString(resourceGroupName))
  add(query_574326, "api-version", newJString(apiVersion))
  add(path_574325, "name", newJString(name))
  add(path_574325, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574327 = parameters
  add(path_574325, "deviceName", newJString(deviceName))
  result = call_574324.call(path_574325, query_574326, nil, nil, body_574327)

var bandwidthSchedulesCreateOrUpdate* = Call_BandwidthSchedulesCreateOrUpdate_574314(
    name: "bandwidthSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/bandwidthSchedules/{name}",
    validator: validate_BandwidthSchedulesCreateOrUpdate_574315, base: "",
    url: url_BandwidthSchedulesCreateOrUpdate_574316, schemes: {Scheme.Https})
type
  Call_BandwidthSchedulesGet_574302 = ref object of OpenApiRestCall_573666
proc url_BandwidthSchedulesGet_574304(protocol: Scheme; host: string; base: string;
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

proc validate_BandwidthSchedulesGet_574303(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified bandwidth schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The bandwidth schedule name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574305 = path.getOrDefault("resourceGroupName")
  valid_574305 = validateParameter(valid_574305, JString, required = true,
                                 default = nil)
  if valid_574305 != nil:
    section.add "resourceGroupName", valid_574305
  var valid_574306 = path.getOrDefault("name")
  valid_574306 = validateParameter(valid_574306, JString, required = true,
                                 default = nil)
  if valid_574306 != nil:
    section.add "name", valid_574306
  var valid_574307 = path.getOrDefault("subscriptionId")
  valid_574307 = validateParameter(valid_574307, JString, required = true,
                                 default = nil)
  if valid_574307 != nil:
    section.add "subscriptionId", valid_574307
  var valid_574308 = path.getOrDefault("deviceName")
  valid_574308 = validateParameter(valid_574308, JString, required = true,
                                 default = nil)
  if valid_574308 != nil:
    section.add "deviceName", valid_574308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574309 = query.getOrDefault("api-version")
  valid_574309 = validateParameter(valid_574309, JString, required = true,
                                 default = nil)
  if valid_574309 != nil:
    section.add "api-version", valid_574309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574310: Call_BandwidthSchedulesGet_574302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified bandwidth schedule.
  ## 
  let valid = call_574310.validator(path, query, header, formData, body)
  let scheme = call_574310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574310.url(scheme.get, call_574310.host, call_574310.base,
                         call_574310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574310, url, valid)

proc call*(call_574311: Call_BandwidthSchedulesGet_574302;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## bandwidthSchedulesGet
  ## Gets the properties of the specified bandwidth schedule.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The bandwidth schedule name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574312 = newJObject()
  var query_574313 = newJObject()
  add(path_574312, "resourceGroupName", newJString(resourceGroupName))
  add(query_574313, "api-version", newJString(apiVersion))
  add(path_574312, "name", newJString(name))
  add(path_574312, "subscriptionId", newJString(subscriptionId))
  add(path_574312, "deviceName", newJString(deviceName))
  result = call_574311.call(path_574312, query_574313, nil, nil, nil)

var bandwidthSchedulesGet* = Call_BandwidthSchedulesGet_574302(
    name: "bandwidthSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/bandwidthSchedules/{name}",
    validator: validate_BandwidthSchedulesGet_574303, base: "",
    url: url_BandwidthSchedulesGet_574304, schemes: {Scheme.Https})
type
  Call_BandwidthSchedulesDelete_574328 = ref object of OpenApiRestCall_573666
proc url_BandwidthSchedulesDelete_574330(protocol: Scheme; host: string;
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

proc validate_BandwidthSchedulesDelete_574329(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified bandwidth schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The bandwidth schedule name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574331 = path.getOrDefault("resourceGroupName")
  valid_574331 = validateParameter(valid_574331, JString, required = true,
                                 default = nil)
  if valid_574331 != nil:
    section.add "resourceGroupName", valid_574331
  var valid_574332 = path.getOrDefault("name")
  valid_574332 = validateParameter(valid_574332, JString, required = true,
                                 default = nil)
  if valid_574332 != nil:
    section.add "name", valid_574332
  var valid_574333 = path.getOrDefault("subscriptionId")
  valid_574333 = validateParameter(valid_574333, JString, required = true,
                                 default = nil)
  if valid_574333 != nil:
    section.add "subscriptionId", valid_574333
  var valid_574334 = path.getOrDefault("deviceName")
  valid_574334 = validateParameter(valid_574334, JString, required = true,
                                 default = nil)
  if valid_574334 != nil:
    section.add "deviceName", valid_574334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574335 = query.getOrDefault("api-version")
  valid_574335 = validateParameter(valid_574335, JString, required = true,
                                 default = nil)
  if valid_574335 != nil:
    section.add "api-version", valid_574335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574336: Call_BandwidthSchedulesDelete_574328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified bandwidth schedule.
  ## 
  let valid = call_574336.validator(path, query, header, formData, body)
  let scheme = call_574336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574336.url(scheme.get, call_574336.host, call_574336.base,
                         call_574336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574336, url, valid)

proc call*(call_574337: Call_BandwidthSchedulesDelete_574328;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## bandwidthSchedulesDelete
  ## Deletes the specified bandwidth schedule.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The bandwidth schedule name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574338 = newJObject()
  var query_574339 = newJObject()
  add(path_574338, "resourceGroupName", newJString(resourceGroupName))
  add(query_574339, "api-version", newJString(apiVersion))
  add(path_574338, "name", newJString(name))
  add(path_574338, "subscriptionId", newJString(subscriptionId))
  add(path_574338, "deviceName", newJString(deviceName))
  result = call_574337.call(path_574338, query_574339, nil, nil, nil)

var bandwidthSchedulesDelete* = Call_BandwidthSchedulesDelete_574328(
    name: "bandwidthSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/bandwidthSchedules/{name}",
    validator: validate_BandwidthSchedulesDelete_574329, base: "",
    url: url_BandwidthSchedulesDelete_574330, schemes: {Scheme.Https})
type
  Call_DevicesDownloadUpdates_574340 = ref object of OpenApiRestCall_573666
proc url_DevicesDownloadUpdates_574342(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesDownloadUpdates_574341(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574343 = path.getOrDefault("resourceGroupName")
  valid_574343 = validateParameter(valid_574343, JString, required = true,
                                 default = nil)
  if valid_574343 != nil:
    section.add "resourceGroupName", valid_574343
  var valid_574344 = path.getOrDefault("subscriptionId")
  valid_574344 = validateParameter(valid_574344, JString, required = true,
                                 default = nil)
  if valid_574344 != nil:
    section.add "subscriptionId", valid_574344
  var valid_574345 = path.getOrDefault("deviceName")
  valid_574345 = validateParameter(valid_574345, JString, required = true,
                                 default = nil)
  if valid_574345 != nil:
    section.add "deviceName", valid_574345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574346 = query.getOrDefault("api-version")
  valid_574346 = validateParameter(valid_574346, JString, required = true,
                                 default = nil)
  if valid_574346 != nil:
    section.add "api-version", valid_574346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574347: Call_DevicesDownloadUpdates_574340; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574347.validator(path, query, header, formData, body)
  let scheme = call_574347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574347.url(scheme.get, call_574347.host, call_574347.base,
                         call_574347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574347, url, valid)

proc call*(call_574348: Call_DevicesDownloadUpdates_574340;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## devicesDownloadUpdates
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574349 = newJObject()
  var query_574350 = newJObject()
  add(path_574349, "resourceGroupName", newJString(resourceGroupName))
  add(query_574350, "api-version", newJString(apiVersion))
  add(path_574349, "subscriptionId", newJString(subscriptionId))
  add(path_574349, "deviceName", newJString(deviceName))
  result = call_574348.call(path_574349, query_574350, nil, nil, nil)

var devicesDownloadUpdates* = Call_DevicesDownloadUpdates_574340(
    name: "devicesDownloadUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/downloadUpdates",
    validator: validate_DevicesDownloadUpdates_574341, base: "",
    url: url_DevicesDownloadUpdates_574342, schemes: {Scheme.Https})
type
  Call_DevicesGetExtendedInformation_574351 = ref object of OpenApiRestCall_573666
proc url_DevicesGetExtendedInformation_574353(protocol: Scheme; host: string;
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

proc validate_DevicesGetExtendedInformation_574352(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets additional information for the specified data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574354 = path.getOrDefault("resourceGroupName")
  valid_574354 = validateParameter(valid_574354, JString, required = true,
                                 default = nil)
  if valid_574354 != nil:
    section.add "resourceGroupName", valid_574354
  var valid_574355 = path.getOrDefault("subscriptionId")
  valid_574355 = validateParameter(valid_574355, JString, required = true,
                                 default = nil)
  if valid_574355 != nil:
    section.add "subscriptionId", valid_574355
  var valid_574356 = path.getOrDefault("deviceName")
  valid_574356 = validateParameter(valid_574356, JString, required = true,
                                 default = nil)
  if valid_574356 != nil:
    section.add "deviceName", valid_574356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574357 = query.getOrDefault("api-version")
  valid_574357 = validateParameter(valid_574357, JString, required = true,
                                 default = nil)
  if valid_574357 != nil:
    section.add "api-version", valid_574357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574358: Call_DevicesGetExtendedInformation_574351; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets additional information for the specified data box edge/gateway device.
  ## 
  let valid = call_574358.validator(path, query, header, formData, body)
  let scheme = call_574358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574358.url(scheme.get, call_574358.host, call_574358.base,
                         call_574358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574358, url, valid)

proc call*(call_574359: Call_DevicesGetExtendedInformation_574351;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## devicesGetExtendedInformation
  ## Gets additional information for the specified data box edge/gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574360 = newJObject()
  var query_574361 = newJObject()
  add(path_574360, "resourceGroupName", newJString(resourceGroupName))
  add(query_574361, "api-version", newJString(apiVersion))
  add(path_574360, "subscriptionId", newJString(subscriptionId))
  add(path_574360, "deviceName", newJString(deviceName))
  result = call_574359.call(path_574360, query_574361, nil, nil, nil)

var devicesGetExtendedInformation* = Call_DevicesGetExtendedInformation_574351(
    name: "devicesGetExtendedInformation", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/getExtendedInformation",
    validator: validate_DevicesGetExtendedInformation_574352, base: "",
    url: url_DevicesGetExtendedInformation_574353, schemes: {Scheme.Https})
type
  Call_DevicesInstallUpdates_574362 = ref object of OpenApiRestCall_573666
proc url_DevicesInstallUpdates_574364(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesInstallUpdates_574363(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574365 = path.getOrDefault("resourceGroupName")
  valid_574365 = validateParameter(valid_574365, JString, required = true,
                                 default = nil)
  if valid_574365 != nil:
    section.add "resourceGroupName", valid_574365
  var valid_574366 = path.getOrDefault("subscriptionId")
  valid_574366 = validateParameter(valid_574366, JString, required = true,
                                 default = nil)
  if valid_574366 != nil:
    section.add "subscriptionId", valid_574366
  var valid_574367 = path.getOrDefault("deviceName")
  valid_574367 = validateParameter(valid_574367, JString, required = true,
                                 default = nil)
  if valid_574367 != nil:
    section.add "deviceName", valid_574367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574368 = query.getOrDefault("api-version")
  valid_574368 = validateParameter(valid_574368, JString, required = true,
                                 default = nil)
  if valid_574368 != nil:
    section.add "api-version", valid_574368
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574369: Call_DevicesInstallUpdates_574362; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574369.validator(path, query, header, formData, body)
  let scheme = call_574369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574369.url(scheme.get, call_574369.host, call_574369.base,
                         call_574369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574369, url, valid)

proc call*(call_574370: Call_DevicesInstallUpdates_574362;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## devicesInstallUpdates
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574371 = newJObject()
  var query_574372 = newJObject()
  add(path_574371, "resourceGroupName", newJString(resourceGroupName))
  add(query_574372, "api-version", newJString(apiVersion))
  add(path_574371, "subscriptionId", newJString(subscriptionId))
  add(path_574371, "deviceName", newJString(deviceName))
  result = call_574370.call(path_574371, query_574372, nil, nil, nil)

var devicesInstallUpdates* = Call_DevicesInstallUpdates_574362(
    name: "devicesInstallUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/installUpdates",
    validator: validate_DevicesInstallUpdates_574363, base: "",
    url: url_DevicesInstallUpdates_574364, schemes: {Scheme.Https})
type
  Call_JobsGet_574373 = ref object of OpenApiRestCall_573666
proc url_JobsGet_574375(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsGet_574374(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The job name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574376 = path.getOrDefault("resourceGroupName")
  valid_574376 = validateParameter(valid_574376, JString, required = true,
                                 default = nil)
  if valid_574376 != nil:
    section.add "resourceGroupName", valid_574376
  var valid_574377 = path.getOrDefault("name")
  valid_574377 = validateParameter(valid_574377, JString, required = true,
                                 default = nil)
  if valid_574377 != nil:
    section.add "name", valid_574377
  var valid_574378 = path.getOrDefault("subscriptionId")
  valid_574378 = validateParameter(valid_574378, JString, required = true,
                                 default = nil)
  if valid_574378 != nil:
    section.add "subscriptionId", valid_574378
  var valid_574379 = path.getOrDefault("deviceName")
  valid_574379 = validateParameter(valid_574379, JString, required = true,
                                 default = nil)
  if valid_574379 != nil:
    section.add "deviceName", valid_574379
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574380 = query.getOrDefault("api-version")
  valid_574380 = validateParameter(valid_574380, JString, required = true,
                                 default = nil)
  if valid_574380 != nil:
    section.add "api-version", valid_574380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574381: Call_JobsGet_574373; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574381.validator(path, query, header, formData, body)
  let scheme = call_574381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574381.url(scheme.get, call_574381.host, call_574381.base,
                         call_574381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574381, url, valid)

proc call*(call_574382: Call_JobsGet_574373; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string; deviceName: string): Recallable =
  ## jobsGet
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The job name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574383 = newJObject()
  var query_574384 = newJObject()
  add(path_574383, "resourceGroupName", newJString(resourceGroupName))
  add(query_574384, "api-version", newJString(apiVersion))
  add(path_574383, "name", newJString(name))
  add(path_574383, "subscriptionId", newJString(subscriptionId))
  add(path_574383, "deviceName", newJString(deviceName))
  result = call_574382.call(path_574383, query_574384, nil, nil, nil)

var jobsGet* = Call_JobsGet_574373(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/jobs/{name}",
                                validator: validate_JobsGet_574374, base: "",
                                url: url_JobsGet_574375, schemes: {Scheme.Https})
type
  Call_DevicesGetNetworkSettings_574385 = ref object of OpenApiRestCall_573666
proc url_DevicesGetNetworkSettings_574387(protocol: Scheme; host: string;
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

proc validate_DevicesGetNetworkSettings_574386(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the network settings of the specified data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574388 = path.getOrDefault("resourceGroupName")
  valid_574388 = validateParameter(valid_574388, JString, required = true,
                                 default = nil)
  if valid_574388 != nil:
    section.add "resourceGroupName", valid_574388
  var valid_574389 = path.getOrDefault("subscriptionId")
  valid_574389 = validateParameter(valid_574389, JString, required = true,
                                 default = nil)
  if valid_574389 != nil:
    section.add "subscriptionId", valid_574389
  var valid_574390 = path.getOrDefault("deviceName")
  valid_574390 = validateParameter(valid_574390, JString, required = true,
                                 default = nil)
  if valid_574390 != nil:
    section.add "deviceName", valid_574390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574391 = query.getOrDefault("api-version")
  valid_574391 = validateParameter(valid_574391, JString, required = true,
                                 default = nil)
  if valid_574391 != nil:
    section.add "api-version", valid_574391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574392: Call_DevicesGetNetworkSettings_574385; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the network settings of the specified data box edge/gateway device.
  ## 
  let valid = call_574392.validator(path, query, header, formData, body)
  let scheme = call_574392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574392.url(scheme.get, call_574392.host, call_574392.base,
                         call_574392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574392, url, valid)

proc call*(call_574393: Call_DevicesGetNetworkSettings_574385;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## devicesGetNetworkSettings
  ## Gets the network settings of the specified data box edge/gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574394 = newJObject()
  var query_574395 = newJObject()
  add(path_574394, "resourceGroupName", newJString(resourceGroupName))
  add(query_574395, "api-version", newJString(apiVersion))
  add(path_574394, "subscriptionId", newJString(subscriptionId))
  add(path_574394, "deviceName", newJString(deviceName))
  result = call_574393.call(path_574394, query_574395, nil, nil, nil)

var devicesGetNetworkSettings* = Call_DevicesGetNetworkSettings_574385(
    name: "devicesGetNetworkSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/networkSettings/default",
    validator: validate_DevicesGetNetworkSettings_574386, base: "",
    url: url_DevicesGetNetworkSettings_574387, schemes: {Scheme.Https})
type
  Call_OperationsStatusGet_574396 = ref object of OpenApiRestCall_573666
proc url_OperationsStatusGet_574398(protocol: Scheme; host: string; base: string;
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

proc validate_OperationsStatusGet_574397(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The job name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574399 = path.getOrDefault("resourceGroupName")
  valid_574399 = validateParameter(valid_574399, JString, required = true,
                                 default = nil)
  if valid_574399 != nil:
    section.add "resourceGroupName", valid_574399
  var valid_574400 = path.getOrDefault("name")
  valid_574400 = validateParameter(valid_574400, JString, required = true,
                                 default = nil)
  if valid_574400 != nil:
    section.add "name", valid_574400
  var valid_574401 = path.getOrDefault("subscriptionId")
  valid_574401 = validateParameter(valid_574401, JString, required = true,
                                 default = nil)
  if valid_574401 != nil:
    section.add "subscriptionId", valid_574401
  var valid_574402 = path.getOrDefault("deviceName")
  valid_574402 = validateParameter(valid_574402, JString, required = true,
                                 default = nil)
  if valid_574402 != nil:
    section.add "deviceName", valid_574402
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574403 = query.getOrDefault("api-version")
  valid_574403 = validateParameter(valid_574403, JString, required = true,
                                 default = nil)
  if valid_574403 != nil:
    section.add "api-version", valid_574403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574404: Call_OperationsStatusGet_574396; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574404.validator(path, query, header, formData, body)
  let scheme = call_574404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574404.url(scheme.get, call_574404.host, call_574404.base,
                         call_574404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574404, url, valid)

proc call*(call_574405: Call_OperationsStatusGet_574396; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string; deviceName: string): Recallable =
  ## operationsStatusGet
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The job name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574406 = newJObject()
  var query_574407 = newJObject()
  add(path_574406, "resourceGroupName", newJString(resourceGroupName))
  add(query_574407, "api-version", newJString(apiVersion))
  add(path_574406, "name", newJString(name))
  add(path_574406, "subscriptionId", newJString(subscriptionId))
  add(path_574406, "deviceName", newJString(deviceName))
  result = call_574405.call(path_574406, query_574407, nil, nil, nil)

var operationsStatusGet* = Call_OperationsStatusGet_574396(
    name: "operationsStatusGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/operationsStatus/{name}",
    validator: validate_OperationsStatusGet_574397, base: "",
    url: url_OperationsStatusGet_574398, schemes: {Scheme.Https})
type
  Call_OrdersListByDataBoxEdgeDevice_574408 = ref object of OpenApiRestCall_573666
proc url_OrdersListByDataBoxEdgeDevice_574410(protocol: Scheme; host: string;
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

proc validate_OrdersListByDataBoxEdgeDevice_574409(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574411 = path.getOrDefault("resourceGroupName")
  valid_574411 = validateParameter(valid_574411, JString, required = true,
                                 default = nil)
  if valid_574411 != nil:
    section.add "resourceGroupName", valid_574411
  var valid_574412 = path.getOrDefault("subscriptionId")
  valid_574412 = validateParameter(valid_574412, JString, required = true,
                                 default = nil)
  if valid_574412 != nil:
    section.add "subscriptionId", valid_574412
  var valid_574413 = path.getOrDefault("deviceName")
  valid_574413 = validateParameter(valid_574413, JString, required = true,
                                 default = nil)
  if valid_574413 != nil:
    section.add "deviceName", valid_574413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574414 = query.getOrDefault("api-version")
  valid_574414 = validateParameter(valid_574414, JString, required = true,
                                 default = nil)
  if valid_574414 != nil:
    section.add "api-version", valid_574414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574415: Call_OrdersListByDataBoxEdgeDevice_574408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574415.validator(path, query, header, formData, body)
  let scheme = call_574415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574415.url(scheme.get, call_574415.host, call_574415.base,
                         call_574415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574415, url, valid)

proc call*(call_574416: Call_OrdersListByDataBoxEdgeDevice_574408;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## ordersListByDataBoxEdgeDevice
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574417 = newJObject()
  var query_574418 = newJObject()
  add(path_574417, "resourceGroupName", newJString(resourceGroupName))
  add(query_574418, "api-version", newJString(apiVersion))
  add(path_574417, "subscriptionId", newJString(subscriptionId))
  add(path_574417, "deviceName", newJString(deviceName))
  result = call_574416.call(path_574417, query_574418, nil, nil, nil)

var ordersListByDataBoxEdgeDevice* = Call_OrdersListByDataBoxEdgeDevice_574408(
    name: "ordersListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/orders",
    validator: validate_OrdersListByDataBoxEdgeDevice_574409, base: "",
    url: url_OrdersListByDataBoxEdgeDevice_574410, schemes: {Scheme.Https})
type
  Call_OrdersCreateOrUpdate_574430 = ref object of OpenApiRestCall_573666
proc url_OrdersCreateOrUpdate_574432(protocol: Scheme; host: string; base: string;
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

proc validate_OrdersCreateOrUpdate_574431(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574433 = path.getOrDefault("resourceGroupName")
  valid_574433 = validateParameter(valid_574433, JString, required = true,
                                 default = nil)
  if valid_574433 != nil:
    section.add "resourceGroupName", valid_574433
  var valid_574434 = path.getOrDefault("subscriptionId")
  valid_574434 = validateParameter(valid_574434, JString, required = true,
                                 default = nil)
  if valid_574434 != nil:
    section.add "subscriptionId", valid_574434
  var valid_574435 = path.getOrDefault("deviceName")
  valid_574435 = validateParameter(valid_574435, JString, required = true,
                                 default = nil)
  if valid_574435 != nil:
    section.add "deviceName", valid_574435
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574436 = query.getOrDefault("api-version")
  valid_574436 = validateParameter(valid_574436, JString, required = true,
                                 default = nil)
  if valid_574436 != nil:
    section.add "api-version", valid_574436
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

proc call*(call_574438: Call_OrdersCreateOrUpdate_574430; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574438.validator(path, query, header, formData, body)
  let scheme = call_574438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574438.url(scheme.get, call_574438.host, call_574438.base,
                         call_574438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574438, url, valid)

proc call*(call_574439: Call_OrdersCreateOrUpdate_574430;
          resourceGroupName: string; apiVersion: string; order: JsonNode;
          subscriptionId: string; deviceName: string): Recallable =
  ## ordersCreateOrUpdate
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   order: JObject (required)
  ##        : The order to be created or updated.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574440 = newJObject()
  var query_574441 = newJObject()
  var body_574442 = newJObject()
  add(path_574440, "resourceGroupName", newJString(resourceGroupName))
  add(query_574441, "api-version", newJString(apiVersion))
  if order != nil:
    body_574442 = order
  add(path_574440, "subscriptionId", newJString(subscriptionId))
  add(path_574440, "deviceName", newJString(deviceName))
  result = call_574439.call(path_574440, query_574441, nil, nil, body_574442)

var ordersCreateOrUpdate* = Call_OrdersCreateOrUpdate_574430(
    name: "ordersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/orders/default",
    validator: validate_OrdersCreateOrUpdate_574431, base: "",
    url: url_OrdersCreateOrUpdate_574432, schemes: {Scheme.Https})
type
  Call_OrdersGet_574419 = ref object of OpenApiRestCall_573666
proc url_OrdersGet_574421(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_OrdersGet_574420(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574422 = path.getOrDefault("resourceGroupName")
  valid_574422 = validateParameter(valid_574422, JString, required = true,
                                 default = nil)
  if valid_574422 != nil:
    section.add "resourceGroupName", valid_574422
  var valid_574423 = path.getOrDefault("subscriptionId")
  valid_574423 = validateParameter(valid_574423, JString, required = true,
                                 default = nil)
  if valid_574423 != nil:
    section.add "subscriptionId", valid_574423
  var valid_574424 = path.getOrDefault("deviceName")
  valid_574424 = validateParameter(valid_574424, JString, required = true,
                                 default = nil)
  if valid_574424 != nil:
    section.add "deviceName", valid_574424
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574425 = query.getOrDefault("api-version")
  valid_574425 = validateParameter(valid_574425, JString, required = true,
                                 default = nil)
  if valid_574425 != nil:
    section.add "api-version", valid_574425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574426: Call_OrdersGet_574419; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574426.validator(path, query, header, formData, body)
  let scheme = call_574426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574426.url(scheme.get, call_574426.host, call_574426.base,
                         call_574426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574426, url, valid)

proc call*(call_574427: Call_OrdersGet_574419; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; deviceName: string): Recallable =
  ## ordersGet
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574428 = newJObject()
  var query_574429 = newJObject()
  add(path_574428, "resourceGroupName", newJString(resourceGroupName))
  add(query_574429, "api-version", newJString(apiVersion))
  add(path_574428, "subscriptionId", newJString(subscriptionId))
  add(path_574428, "deviceName", newJString(deviceName))
  result = call_574427.call(path_574428, query_574429, nil, nil, nil)

var ordersGet* = Call_OrdersGet_574419(name: "ordersGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/orders/default",
                                    validator: validate_OrdersGet_574420,
                                    base: "", url: url_OrdersGet_574421,
                                    schemes: {Scheme.Https})
type
  Call_OrdersDelete_574443 = ref object of OpenApiRestCall_573666
proc url_OrdersDelete_574445(protocol: Scheme; host: string; base: string;
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

proc validate_OrdersDelete_574444(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574446 = path.getOrDefault("resourceGroupName")
  valid_574446 = validateParameter(valid_574446, JString, required = true,
                                 default = nil)
  if valid_574446 != nil:
    section.add "resourceGroupName", valid_574446
  var valid_574447 = path.getOrDefault("subscriptionId")
  valid_574447 = validateParameter(valid_574447, JString, required = true,
                                 default = nil)
  if valid_574447 != nil:
    section.add "subscriptionId", valid_574447
  var valid_574448 = path.getOrDefault("deviceName")
  valid_574448 = validateParameter(valid_574448, JString, required = true,
                                 default = nil)
  if valid_574448 != nil:
    section.add "deviceName", valid_574448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574449 = query.getOrDefault("api-version")
  valid_574449 = validateParameter(valid_574449, JString, required = true,
                                 default = nil)
  if valid_574449 != nil:
    section.add "api-version", valid_574449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574450: Call_OrdersDelete_574443; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574450.validator(path, query, header, formData, body)
  let scheme = call_574450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574450.url(scheme.get, call_574450.host, call_574450.base,
                         call_574450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574450, url, valid)

proc call*(call_574451: Call_OrdersDelete_574443; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; deviceName: string): Recallable =
  ## ordersDelete
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574452 = newJObject()
  var query_574453 = newJObject()
  add(path_574452, "resourceGroupName", newJString(resourceGroupName))
  add(query_574453, "api-version", newJString(apiVersion))
  add(path_574452, "subscriptionId", newJString(subscriptionId))
  add(path_574452, "deviceName", newJString(deviceName))
  result = call_574451.call(path_574452, query_574453, nil, nil, nil)

var ordersDelete* = Call_OrdersDelete_574443(name: "ordersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/orders/default",
    validator: validate_OrdersDelete_574444, base: "", url: url_OrdersDelete_574445,
    schemes: {Scheme.Https})
type
  Call_RolesListByDataBoxEdgeDevice_574454 = ref object of OpenApiRestCall_573666
proc url_RolesListByDataBoxEdgeDevice_574456(protocol: Scheme; host: string;
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

proc validate_RolesListByDataBoxEdgeDevice_574455(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the roles configured in a data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574457 = path.getOrDefault("resourceGroupName")
  valid_574457 = validateParameter(valid_574457, JString, required = true,
                                 default = nil)
  if valid_574457 != nil:
    section.add "resourceGroupName", valid_574457
  var valid_574458 = path.getOrDefault("subscriptionId")
  valid_574458 = validateParameter(valid_574458, JString, required = true,
                                 default = nil)
  if valid_574458 != nil:
    section.add "subscriptionId", valid_574458
  var valid_574459 = path.getOrDefault("deviceName")
  valid_574459 = validateParameter(valid_574459, JString, required = true,
                                 default = nil)
  if valid_574459 != nil:
    section.add "deviceName", valid_574459
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574460 = query.getOrDefault("api-version")
  valid_574460 = validateParameter(valid_574460, JString, required = true,
                                 default = nil)
  if valid_574460 != nil:
    section.add "api-version", valid_574460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574461: Call_RolesListByDataBoxEdgeDevice_574454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the roles configured in a data box edge/gateway device.
  ## 
  let valid = call_574461.validator(path, query, header, formData, body)
  let scheme = call_574461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574461.url(scheme.get, call_574461.host, call_574461.base,
                         call_574461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574461, url, valid)

proc call*(call_574462: Call_RolesListByDataBoxEdgeDevice_574454;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## rolesListByDataBoxEdgeDevice
  ## Lists all the roles configured in a data box edge/gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574463 = newJObject()
  var query_574464 = newJObject()
  add(path_574463, "resourceGroupName", newJString(resourceGroupName))
  add(query_574464, "api-version", newJString(apiVersion))
  add(path_574463, "subscriptionId", newJString(subscriptionId))
  add(path_574463, "deviceName", newJString(deviceName))
  result = call_574462.call(path_574463, query_574464, nil, nil, nil)

var rolesListByDataBoxEdgeDevice* = Call_RolesListByDataBoxEdgeDevice_574454(
    name: "rolesListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/roles",
    validator: validate_RolesListByDataBoxEdgeDevice_574455, base: "",
    url: url_RolesListByDataBoxEdgeDevice_574456, schemes: {Scheme.Https})
type
  Call_RolesCreateOrUpdate_574477 = ref object of OpenApiRestCall_573666
proc url_RolesCreateOrUpdate_574479(protocol: Scheme; host: string; base: string;
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

proc validate_RolesCreateOrUpdate_574478(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create or update a role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The role name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574480 = path.getOrDefault("resourceGroupName")
  valid_574480 = validateParameter(valid_574480, JString, required = true,
                                 default = nil)
  if valid_574480 != nil:
    section.add "resourceGroupName", valid_574480
  var valid_574481 = path.getOrDefault("name")
  valid_574481 = validateParameter(valid_574481, JString, required = true,
                                 default = nil)
  if valid_574481 != nil:
    section.add "name", valid_574481
  var valid_574482 = path.getOrDefault("subscriptionId")
  valid_574482 = validateParameter(valid_574482, JString, required = true,
                                 default = nil)
  if valid_574482 != nil:
    section.add "subscriptionId", valid_574482
  var valid_574483 = path.getOrDefault("deviceName")
  valid_574483 = validateParameter(valid_574483, JString, required = true,
                                 default = nil)
  if valid_574483 != nil:
    section.add "deviceName", valid_574483
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574484 = query.getOrDefault("api-version")
  valid_574484 = validateParameter(valid_574484, JString, required = true,
                                 default = nil)
  if valid_574484 != nil:
    section.add "api-version", valid_574484
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

proc call*(call_574486: Call_RolesCreateOrUpdate_574477; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a role.
  ## 
  let valid = call_574486.validator(path, query, header, formData, body)
  let scheme = call_574486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574486.url(scheme.get, call_574486.host, call_574486.base,
                         call_574486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574486, url, valid)

proc call*(call_574487: Call_RolesCreateOrUpdate_574477; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string; role: JsonNode;
          deviceName: string): Recallable =
  ## rolesCreateOrUpdate
  ## Create or update a role.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The role name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   role: JObject (required)
  ##       : The role properties.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574488 = newJObject()
  var query_574489 = newJObject()
  var body_574490 = newJObject()
  add(path_574488, "resourceGroupName", newJString(resourceGroupName))
  add(query_574489, "api-version", newJString(apiVersion))
  add(path_574488, "name", newJString(name))
  add(path_574488, "subscriptionId", newJString(subscriptionId))
  if role != nil:
    body_574490 = role
  add(path_574488, "deviceName", newJString(deviceName))
  result = call_574487.call(path_574488, query_574489, nil, nil, body_574490)

var rolesCreateOrUpdate* = Call_RolesCreateOrUpdate_574477(
    name: "rolesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/roles/{name}",
    validator: validate_RolesCreateOrUpdate_574478, base: "",
    url: url_RolesCreateOrUpdate_574479, schemes: {Scheme.Https})
type
  Call_RolesGet_574465 = ref object of OpenApiRestCall_573666
proc url_RolesGet_574467(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_RolesGet_574466(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a specific role by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The role name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574468 = path.getOrDefault("resourceGroupName")
  valid_574468 = validateParameter(valid_574468, JString, required = true,
                                 default = nil)
  if valid_574468 != nil:
    section.add "resourceGroupName", valid_574468
  var valid_574469 = path.getOrDefault("name")
  valid_574469 = validateParameter(valid_574469, JString, required = true,
                                 default = nil)
  if valid_574469 != nil:
    section.add "name", valid_574469
  var valid_574470 = path.getOrDefault("subscriptionId")
  valid_574470 = validateParameter(valid_574470, JString, required = true,
                                 default = nil)
  if valid_574470 != nil:
    section.add "subscriptionId", valid_574470
  var valid_574471 = path.getOrDefault("deviceName")
  valid_574471 = validateParameter(valid_574471, JString, required = true,
                                 default = nil)
  if valid_574471 != nil:
    section.add "deviceName", valid_574471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574472 = query.getOrDefault("api-version")
  valid_574472 = validateParameter(valid_574472, JString, required = true,
                                 default = nil)
  if valid_574472 != nil:
    section.add "api-version", valid_574472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574473: Call_RolesGet_574465; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific role by name.
  ## 
  let valid = call_574473.validator(path, query, header, formData, body)
  let scheme = call_574473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574473.url(scheme.get, call_574473.host, call_574473.base,
                         call_574473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574473, url, valid)

proc call*(call_574474: Call_RolesGet_574465; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string; deviceName: string): Recallable =
  ## rolesGet
  ## Gets a specific role by name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The role name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574475 = newJObject()
  var query_574476 = newJObject()
  add(path_574475, "resourceGroupName", newJString(resourceGroupName))
  add(query_574476, "api-version", newJString(apiVersion))
  add(path_574475, "name", newJString(name))
  add(path_574475, "subscriptionId", newJString(subscriptionId))
  add(path_574475, "deviceName", newJString(deviceName))
  result = call_574474.call(path_574475, query_574476, nil, nil, nil)

var rolesGet* = Call_RolesGet_574465(name: "rolesGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/roles/{name}",
                                  validator: validate_RolesGet_574466, base: "",
                                  url: url_RolesGet_574467,
                                  schemes: {Scheme.Https})
type
  Call_RolesDelete_574491 = ref object of OpenApiRestCall_573666
proc url_RolesDelete_574493(protocol: Scheme; host: string; base: string;
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

proc validate_RolesDelete_574492(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the role on the data box edge device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The role name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574494 = path.getOrDefault("resourceGroupName")
  valid_574494 = validateParameter(valid_574494, JString, required = true,
                                 default = nil)
  if valid_574494 != nil:
    section.add "resourceGroupName", valid_574494
  var valid_574495 = path.getOrDefault("name")
  valid_574495 = validateParameter(valid_574495, JString, required = true,
                                 default = nil)
  if valid_574495 != nil:
    section.add "name", valid_574495
  var valid_574496 = path.getOrDefault("subscriptionId")
  valid_574496 = validateParameter(valid_574496, JString, required = true,
                                 default = nil)
  if valid_574496 != nil:
    section.add "subscriptionId", valid_574496
  var valid_574497 = path.getOrDefault("deviceName")
  valid_574497 = validateParameter(valid_574497, JString, required = true,
                                 default = nil)
  if valid_574497 != nil:
    section.add "deviceName", valid_574497
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574498 = query.getOrDefault("api-version")
  valid_574498 = validateParameter(valid_574498, JString, required = true,
                                 default = nil)
  if valid_574498 != nil:
    section.add "api-version", valid_574498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574499: Call_RolesDelete_574491; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the role on the data box edge device.
  ## 
  let valid = call_574499.validator(path, query, header, formData, body)
  let scheme = call_574499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574499.url(scheme.get, call_574499.host, call_574499.base,
                         call_574499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574499, url, valid)

proc call*(call_574500: Call_RolesDelete_574491; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string; deviceName: string): Recallable =
  ## rolesDelete
  ## Deletes the role on the data box edge device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The role name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574501 = newJObject()
  var query_574502 = newJObject()
  add(path_574501, "resourceGroupName", newJString(resourceGroupName))
  add(query_574502, "api-version", newJString(apiVersion))
  add(path_574501, "name", newJString(name))
  add(path_574501, "subscriptionId", newJString(subscriptionId))
  add(path_574501, "deviceName", newJString(deviceName))
  result = call_574500.call(path_574501, query_574502, nil, nil, nil)

var rolesDelete* = Call_RolesDelete_574491(name: "rolesDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/roles/{name}",
                                        validator: validate_RolesDelete_574492,
                                        base: "", url: url_RolesDelete_574493,
                                        schemes: {Scheme.Https})
type
  Call_DevicesScanForUpdates_574503 = ref object of OpenApiRestCall_573666
proc url_DevicesScanForUpdates_574505(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesScanForUpdates_574504(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574506 = path.getOrDefault("resourceGroupName")
  valid_574506 = validateParameter(valid_574506, JString, required = true,
                                 default = nil)
  if valid_574506 != nil:
    section.add "resourceGroupName", valid_574506
  var valid_574507 = path.getOrDefault("subscriptionId")
  valid_574507 = validateParameter(valid_574507, JString, required = true,
                                 default = nil)
  if valid_574507 != nil:
    section.add "subscriptionId", valid_574507
  var valid_574508 = path.getOrDefault("deviceName")
  valid_574508 = validateParameter(valid_574508, JString, required = true,
                                 default = nil)
  if valid_574508 != nil:
    section.add "deviceName", valid_574508
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574509 = query.getOrDefault("api-version")
  valid_574509 = validateParameter(valid_574509, JString, required = true,
                                 default = nil)
  if valid_574509 != nil:
    section.add "api-version", valid_574509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574510: Call_DevicesScanForUpdates_574503; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574510.validator(path, query, header, formData, body)
  let scheme = call_574510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574510.url(scheme.get, call_574510.host, call_574510.base,
                         call_574510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574510, url, valid)

proc call*(call_574511: Call_DevicesScanForUpdates_574503;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## devicesScanForUpdates
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574512 = newJObject()
  var query_574513 = newJObject()
  add(path_574512, "resourceGroupName", newJString(resourceGroupName))
  add(query_574513, "api-version", newJString(apiVersion))
  add(path_574512, "subscriptionId", newJString(subscriptionId))
  add(path_574512, "deviceName", newJString(deviceName))
  result = call_574511.call(path_574512, query_574513, nil, nil, nil)

var devicesScanForUpdates* = Call_DevicesScanForUpdates_574503(
    name: "devicesScanForUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/scanForUpdates",
    validator: validate_DevicesScanForUpdates_574504, base: "",
    url: url_DevicesScanForUpdates_574505, schemes: {Scheme.Https})
type
  Call_DevicesCreateOrUpdateSecuritySettings_574514 = ref object of OpenApiRestCall_573666
proc url_DevicesCreateOrUpdateSecuritySettings_574516(protocol: Scheme;
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

proc validate_DevicesCreateOrUpdateSecuritySettings_574515(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the security settings on a data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574517 = path.getOrDefault("resourceGroupName")
  valid_574517 = validateParameter(valid_574517, JString, required = true,
                                 default = nil)
  if valid_574517 != nil:
    section.add "resourceGroupName", valid_574517
  var valid_574518 = path.getOrDefault("subscriptionId")
  valid_574518 = validateParameter(valid_574518, JString, required = true,
                                 default = nil)
  if valid_574518 != nil:
    section.add "subscriptionId", valid_574518
  var valid_574519 = path.getOrDefault("deviceName")
  valid_574519 = validateParameter(valid_574519, JString, required = true,
                                 default = nil)
  if valid_574519 != nil:
    section.add "deviceName", valid_574519
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574520 = query.getOrDefault("api-version")
  valid_574520 = validateParameter(valid_574520, JString, required = true,
                                 default = nil)
  if valid_574520 != nil:
    section.add "api-version", valid_574520
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

proc call*(call_574522: Call_DevicesCreateOrUpdateSecuritySettings_574514;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the security settings on a data box edge/gateway device.
  ## 
  let valid = call_574522.validator(path, query, header, formData, body)
  let scheme = call_574522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574522.url(scheme.get, call_574522.host, call_574522.base,
                         call_574522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574522, url, valid)

proc call*(call_574523: Call_DevicesCreateOrUpdateSecuritySettings_574514;
          resourceGroupName: string; apiVersion: string; securitySettings: JsonNode;
          subscriptionId: string; deviceName: string): Recallable =
  ## devicesCreateOrUpdateSecuritySettings
  ## Updates the security settings on a data box edge/gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   securitySettings: JObject (required)
  ##                   : The security settings.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574524 = newJObject()
  var query_574525 = newJObject()
  var body_574526 = newJObject()
  add(path_574524, "resourceGroupName", newJString(resourceGroupName))
  add(query_574525, "api-version", newJString(apiVersion))
  if securitySettings != nil:
    body_574526 = securitySettings
  add(path_574524, "subscriptionId", newJString(subscriptionId))
  add(path_574524, "deviceName", newJString(deviceName))
  result = call_574523.call(path_574524, query_574525, nil, nil, body_574526)

var devicesCreateOrUpdateSecuritySettings* = Call_DevicesCreateOrUpdateSecuritySettings_574514(
    name: "devicesCreateOrUpdateSecuritySettings", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/securitySettings/default/update",
    validator: validate_DevicesCreateOrUpdateSecuritySettings_574515, base: "",
    url: url_DevicesCreateOrUpdateSecuritySettings_574516, schemes: {Scheme.Https})
type
  Call_SharesListByDataBoxEdgeDevice_574527 = ref object of OpenApiRestCall_573666
proc url_SharesListByDataBoxEdgeDevice_574529(protocol: Scheme; host: string;
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

proc validate_SharesListByDataBoxEdgeDevice_574528(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574530 = path.getOrDefault("resourceGroupName")
  valid_574530 = validateParameter(valid_574530, JString, required = true,
                                 default = nil)
  if valid_574530 != nil:
    section.add "resourceGroupName", valid_574530
  var valid_574531 = path.getOrDefault("subscriptionId")
  valid_574531 = validateParameter(valid_574531, JString, required = true,
                                 default = nil)
  if valid_574531 != nil:
    section.add "subscriptionId", valid_574531
  var valid_574532 = path.getOrDefault("deviceName")
  valid_574532 = validateParameter(valid_574532, JString, required = true,
                                 default = nil)
  if valid_574532 != nil:
    section.add "deviceName", valid_574532
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574533 = query.getOrDefault("api-version")
  valid_574533 = validateParameter(valid_574533, JString, required = true,
                                 default = nil)
  if valid_574533 != nil:
    section.add "api-version", valid_574533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574534: Call_SharesListByDataBoxEdgeDevice_574527; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574534.validator(path, query, header, formData, body)
  let scheme = call_574534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574534.url(scheme.get, call_574534.host, call_574534.base,
                         call_574534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574534, url, valid)

proc call*(call_574535: Call_SharesListByDataBoxEdgeDevice_574527;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## sharesListByDataBoxEdgeDevice
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574536 = newJObject()
  var query_574537 = newJObject()
  add(path_574536, "resourceGroupName", newJString(resourceGroupName))
  add(query_574537, "api-version", newJString(apiVersion))
  add(path_574536, "subscriptionId", newJString(subscriptionId))
  add(path_574536, "deviceName", newJString(deviceName))
  result = call_574535.call(path_574536, query_574537, nil, nil, nil)

var sharesListByDataBoxEdgeDevice* = Call_SharesListByDataBoxEdgeDevice_574527(
    name: "sharesListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares",
    validator: validate_SharesListByDataBoxEdgeDevice_574528, base: "",
    url: url_SharesListByDataBoxEdgeDevice_574529, schemes: {Scheme.Https})
type
  Call_SharesCreateOrUpdate_574550 = ref object of OpenApiRestCall_573666
proc url_SharesCreateOrUpdate_574552(protocol: Scheme; host: string; base: string;
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

proc validate_SharesCreateOrUpdate_574551(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The share name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574553 = path.getOrDefault("resourceGroupName")
  valid_574553 = validateParameter(valid_574553, JString, required = true,
                                 default = nil)
  if valid_574553 != nil:
    section.add "resourceGroupName", valid_574553
  var valid_574554 = path.getOrDefault("name")
  valid_574554 = validateParameter(valid_574554, JString, required = true,
                                 default = nil)
  if valid_574554 != nil:
    section.add "name", valid_574554
  var valid_574555 = path.getOrDefault("subscriptionId")
  valid_574555 = validateParameter(valid_574555, JString, required = true,
                                 default = nil)
  if valid_574555 != nil:
    section.add "subscriptionId", valid_574555
  var valid_574556 = path.getOrDefault("deviceName")
  valid_574556 = validateParameter(valid_574556, JString, required = true,
                                 default = nil)
  if valid_574556 != nil:
    section.add "deviceName", valid_574556
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574557 = query.getOrDefault("api-version")
  valid_574557 = validateParameter(valid_574557, JString, required = true,
                                 default = nil)
  if valid_574557 != nil:
    section.add "api-version", valid_574557
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

proc call*(call_574559: Call_SharesCreateOrUpdate_574550; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574559.validator(path, query, header, formData, body)
  let scheme = call_574559.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574559.url(scheme.get, call_574559.host, call_574559.base,
                         call_574559.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574559, url, valid)

proc call*(call_574560: Call_SharesCreateOrUpdate_574550;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; share: JsonNode; deviceName: string): Recallable =
  ## sharesCreateOrUpdate
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
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
  var path_574561 = newJObject()
  var query_574562 = newJObject()
  var body_574563 = newJObject()
  add(path_574561, "resourceGroupName", newJString(resourceGroupName))
  add(query_574562, "api-version", newJString(apiVersion))
  add(path_574561, "name", newJString(name))
  add(path_574561, "subscriptionId", newJString(subscriptionId))
  if share != nil:
    body_574563 = share
  add(path_574561, "deviceName", newJString(deviceName))
  result = call_574560.call(path_574561, query_574562, nil, nil, body_574563)

var sharesCreateOrUpdate* = Call_SharesCreateOrUpdate_574550(
    name: "sharesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares/{name}",
    validator: validate_SharesCreateOrUpdate_574551, base: "",
    url: url_SharesCreateOrUpdate_574552, schemes: {Scheme.Https})
type
  Call_SharesGet_574538 = ref object of OpenApiRestCall_573666
proc url_SharesGet_574540(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SharesGet_574539(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The share name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574541 = path.getOrDefault("resourceGroupName")
  valid_574541 = validateParameter(valid_574541, JString, required = true,
                                 default = nil)
  if valid_574541 != nil:
    section.add "resourceGroupName", valid_574541
  var valid_574542 = path.getOrDefault("name")
  valid_574542 = validateParameter(valid_574542, JString, required = true,
                                 default = nil)
  if valid_574542 != nil:
    section.add "name", valid_574542
  var valid_574543 = path.getOrDefault("subscriptionId")
  valid_574543 = validateParameter(valid_574543, JString, required = true,
                                 default = nil)
  if valid_574543 != nil:
    section.add "subscriptionId", valid_574543
  var valid_574544 = path.getOrDefault("deviceName")
  valid_574544 = validateParameter(valid_574544, JString, required = true,
                                 default = nil)
  if valid_574544 != nil:
    section.add "deviceName", valid_574544
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574545 = query.getOrDefault("api-version")
  valid_574545 = validateParameter(valid_574545, JString, required = true,
                                 default = nil)
  if valid_574545 != nil:
    section.add "api-version", valid_574545
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574546: Call_SharesGet_574538; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574546.validator(path, query, header, formData, body)
  let scheme = call_574546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574546.url(scheme.get, call_574546.host, call_574546.base,
                         call_574546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574546, url, valid)

proc call*(call_574547: Call_SharesGet_574538; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string; deviceName: string): Recallable =
  ## sharesGet
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The share name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574548 = newJObject()
  var query_574549 = newJObject()
  add(path_574548, "resourceGroupName", newJString(resourceGroupName))
  add(query_574549, "api-version", newJString(apiVersion))
  add(path_574548, "name", newJString(name))
  add(path_574548, "subscriptionId", newJString(subscriptionId))
  add(path_574548, "deviceName", newJString(deviceName))
  result = call_574547.call(path_574548, query_574549, nil, nil, nil)

var sharesGet* = Call_SharesGet_574538(name: "sharesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares/{name}",
                                    validator: validate_SharesGet_574539,
                                    base: "", url: url_SharesGet_574540,
                                    schemes: {Scheme.Https})
type
  Call_SharesDelete_574564 = ref object of OpenApiRestCall_573666
proc url_SharesDelete_574566(protocol: Scheme; host: string; base: string;
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

proc validate_SharesDelete_574565(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the share on the data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The share name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574567 = path.getOrDefault("resourceGroupName")
  valid_574567 = validateParameter(valid_574567, JString, required = true,
                                 default = nil)
  if valid_574567 != nil:
    section.add "resourceGroupName", valid_574567
  var valid_574568 = path.getOrDefault("name")
  valid_574568 = validateParameter(valid_574568, JString, required = true,
                                 default = nil)
  if valid_574568 != nil:
    section.add "name", valid_574568
  var valid_574569 = path.getOrDefault("subscriptionId")
  valid_574569 = validateParameter(valid_574569, JString, required = true,
                                 default = nil)
  if valid_574569 != nil:
    section.add "subscriptionId", valid_574569
  var valid_574570 = path.getOrDefault("deviceName")
  valid_574570 = validateParameter(valid_574570, JString, required = true,
                                 default = nil)
  if valid_574570 != nil:
    section.add "deviceName", valid_574570
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574571 = query.getOrDefault("api-version")
  valid_574571 = validateParameter(valid_574571, JString, required = true,
                                 default = nil)
  if valid_574571 != nil:
    section.add "api-version", valid_574571
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574572: Call_SharesDelete_574564; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the share on the data box edge/gateway device.
  ## 
  let valid = call_574572.validator(path, query, header, formData, body)
  let scheme = call_574572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574572.url(scheme.get, call_574572.host, call_574572.base,
                         call_574572.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574572, url, valid)

proc call*(call_574573: Call_SharesDelete_574564; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string; deviceName: string): Recallable =
  ## sharesDelete
  ## Deletes the share on the data box edge/gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The share name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574574 = newJObject()
  var query_574575 = newJObject()
  add(path_574574, "resourceGroupName", newJString(resourceGroupName))
  add(query_574575, "api-version", newJString(apiVersion))
  add(path_574574, "name", newJString(name))
  add(path_574574, "subscriptionId", newJString(subscriptionId))
  add(path_574574, "deviceName", newJString(deviceName))
  result = call_574573.call(path_574574, query_574575, nil, nil, nil)

var sharesDelete* = Call_SharesDelete_574564(name: "sharesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares/{name}",
    validator: validate_SharesDelete_574565, base: "", url: url_SharesDelete_574566,
    schemes: {Scheme.Https})
type
  Call_SharesRefresh_574576 = ref object of OpenApiRestCall_573666
proc url_SharesRefresh_574578(protocol: Scheme; host: string; base: string;
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

proc validate_SharesRefresh_574577(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The share name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574579 = path.getOrDefault("resourceGroupName")
  valid_574579 = validateParameter(valid_574579, JString, required = true,
                                 default = nil)
  if valid_574579 != nil:
    section.add "resourceGroupName", valid_574579
  var valid_574580 = path.getOrDefault("name")
  valid_574580 = validateParameter(valid_574580, JString, required = true,
                                 default = nil)
  if valid_574580 != nil:
    section.add "name", valid_574580
  var valid_574581 = path.getOrDefault("subscriptionId")
  valid_574581 = validateParameter(valid_574581, JString, required = true,
                                 default = nil)
  if valid_574581 != nil:
    section.add "subscriptionId", valid_574581
  var valid_574582 = path.getOrDefault("deviceName")
  valid_574582 = validateParameter(valid_574582, JString, required = true,
                                 default = nil)
  if valid_574582 != nil:
    section.add "deviceName", valid_574582
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574583 = query.getOrDefault("api-version")
  valid_574583 = validateParameter(valid_574583, JString, required = true,
                                 default = nil)
  if valid_574583 != nil:
    section.add "api-version", valid_574583
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574584: Call_SharesRefresh_574576; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574584.validator(path, query, header, formData, body)
  let scheme = call_574584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574584.url(scheme.get, call_574584.host, call_574584.base,
                         call_574584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574584, url, valid)

proc call*(call_574585: Call_SharesRefresh_574576; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string; deviceName: string): Recallable =
  ## sharesRefresh
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The share name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574586 = newJObject()
  var query_574587 = newJObject()
  add(path_574586, "resourceGroupName", newJString(resourceGroupName))
  add(query_574587, "api-version", newJString(apiVersion))
  add(path_574586, "name", newJString(name))
  add(path_574586, "subscriptionId", newJString(subscriptionId))
  add(path_574586, "deviceName", newJString(deviceName))
  result = call_574585.call(path_574586, query_574587, nil, nil, nil)

var sharesRefresh* = Call_SharesRefresh_574576(name: "sharesRefresh",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares/{name}/refresh",
    validator: validate_SharesRefresh_574577, base: "", url: url_SharesRefresh_574578,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsListByDataBoxEdgeDevice_574588 = ref object of OpenApiRestCall_573666
proc url_StorageAccountCredentialsListByDataBoxEdgeDevice_574590(
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

proc validate_StorageAccountCredentialsListByDataBoxEdgeDevice_574589(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574591 = path.getOrDefault("resourceGroupName")
  valid_574591 = validateParameter(valid_574591, JString, required = true,
                                 default = nil)
  if valid_574591 != nil:
    section.add "resourceGroupName", valid_574591
  var valid_574592 = path.getOrDefault("subscriptionId")
  valid_574592 = validateParameter(valid_574592, JString, required = true,
                                 default = nil)
  if valid_574592 != nil:
    section.add "subscriptionId", valid_574592
  var valid_574593 = path.getOrDefault("deviceName")
  valid_574593 = validateParameter(valid_574593, JString, required = true,
                                 default = nil)
  if valid_574593 != nil:
    section.add "deviceName", valid_574593
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574594 = query.getOrDefault("api-version")
  valid_574594 = validateParameter(valid_574594, JString, required = true,
                                 default = nil)
  if valid_574594 != nil:
    section.add "api-version", valid_574594
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574595: Call_StorageAccountCredentialsListByDataBoxEdgeDevice_574588;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_574595.validator(path, query, header, formData, body)
  let scheme = call_574595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574595.url(scheme.get, call_574595.host, call_574595.base,
                         call_574595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574595, url, valid)

proc call*(call_574596: Call_StorageAccountCredentialsListByDataBoxEdgeDevice_574588;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## storageAccountCredentialsListByDataBoxEdgeDevice
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574597 = newJObject()
  var query_574598 = newJObject()
  add(path_574597, "resourceGroupName", newJString(resourceGroupName))
  add(query_574598, "api-version", newJString(apiVersion))
  add(path_574597, "subscriptionId", newJString(subscriptionId))
  add(path_574597, "deviceName", newJString(deviceName))
  result = call_574596.call(path_574597, query_574598, nil, nil, nil)

var storageAccountCredentialsListByDataBoxEdgeDevice* = Call_StorageAccountCredentialsListByDataBoxEdgeDevice_574588(
    name: "storageAccountCredentialsListByDataBoxEdgeDevice",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/storageAccountCredentials",
    validator: validate_StorageAccountCredentialsListByDataBoxEdgeDevice_574589,
    base: "", url: url_StorageAccountCredentialsListByDataBoxEdgeDevice_574590,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsCreateOrUpdate_574611 = ref object of OpenApiRestCall_573666
proc url_StorageAccountCredentialsCreateOrUpdate_574613(protocol: Scheme;
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

proc validate_StorageAccountCredentialsCreateOrUpdate_574612(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the storage account credential.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The storage account credential name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574614 = path.getOrDefault("resourceGroupName")
  valid_574614 = validateParameter(valid_574614, JString, required = true,
                                 default = nil)
  if valid_574614 != nil:
    section.add "resourceGroupName", valid_574614
  var valid_574615 = path.getOrDefault("name")
  valid_574615 = validateParameter(valid_574615, JString, required = true,
                                 default = nil)
  if valid_574615 != nil:
    section.add "name", valid_574615
  var valid_574616 = path.getOrDefault("subscriptionId")
  valid_574616 = validateParameter(valid_574616, JString, required = true,
                                 default = nil)
  if valid_574616 != nil:
    section.add "subscriptionId", valid_574616
  var valid_574617 = path.getOrDefault("deviceName")
  valid_574617 = validateParameter(valid_574617, JString, required = true,
                                 default = nil)
  if valid_574617 != nil:
    section.add "deviceName", valid_574617
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574618 = query.getOrDefault("api-version")
  valid_574618 = validateParameter(valid_574618, JString, required = true,
                                 default = nil)
  if valid_574618 != nil:
    section.add "api-version", valid_574618
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

proc call*(call_574620: Call_StorageAccountCredentialsCreateOrUpdate_574611;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the storage account credential.
  ## 
  let valid = call_574620.validator(path, query, header, formData, body)
  let scheme = call_574620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574620.url(scheme.get, call_574620.host, call_574620.base,
                         call_574620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574620, url, valid)

proc call*(call_574621: Call_StorageAccountCredentialsCreateOrUpdate_574611;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; storageAccountCredential: JsonNode;
          deviceName: string): Recallable =
  ## storageAccountCredentialsCreateOrUpdate
  ## Creates or updates the storage account credential.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The storage account credential name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   storageAccountCredential: JObject (required)
  ##                           : The storage account credential.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574622 = newJObject()
  var query_574623 = newJObject()
  var body_574624 = newJObject()
  add(path_574622, "resourceGroupName", newJString(resourceGroupName))
  add(query_574623, "api-version", newJString(apiVersion))
  add(path_574622, "name", newJString(name))
  add(path_574622, "subscriptionId", newJString(subscriptionId))
  if storageAccountCredential != nil:
    body_574624 = storageAccountCredential
  add(path_574622, "deviceName", newJString(deviceName))
  result = call_574621.call(path_574622, query_574623, nil, nil, body_574624)

var storageAccountCredentialsCreateOrUpdate* = Call_StorageAccountCredentialsCreateOrUpdate_574611(
    name: "storageAccountCredentialsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/storageAccountCredentials/{name}",
    validator: validate_StorageAccountCredentialsCreateOrUpdate_574612, base: "",
    url: url_StorageAccountCredentialsCreateOrUpdate_574613,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsGet_574599 = ref object of OpenApiRestCall_573666
proc url_StorageAccountCredentialsGet_574601(protocol: Scheme; host: string;
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

proc validate_StorageAccountCredentialsGet_574600(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified storage account credential.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The storage account credential name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574602 = path.getOrDefault("resourceGroupName")
  valid_574602 = validateParameter(valid_574602, JString, required = true,
                                 default = nil)
  if valid_574602 != nil:
    section.add "resourceGroupName", valid_574602
  var valid_574603 = path.getOrDefault("name")
  valid_574603 = validateParameter(valid_574603, JString, required = true,
                                 default = nil)
  if valid_574603 != nil:
    section.add "name", valid_574603
  var valid_574604 = path.getOrDefault("subscriptionId")
  valid_574604 = validateParameter(valid_574604, JString, required = true,
                                 default = nil)
  if valid_574604 != nil:
    section.add "subscriptionId", valid_574604
  var valid_574605 = path.getOrDefault("deviceName")
  valid_574605 = validateParameter(valid_574605, JString, required = true,
                                 default = nil)
  if valid_574605 != nil:
    section.add "deviceName", valid_574605
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574606 = query.getOrDefault("api-version")
  valid_574606 = validateParameter(valid_574606, JString, required = true,
                                 default = nil)
  if valid_574606 != nil:
    section.add "api-version", valid_574606
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574607: Call_StorageAccountCredentialsGet_574599; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified storage account credential.
  ## 
  let valid = call_574607.validator(path, query, header, formData, body)
  let scheme = call_574607.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574607.url(scheme.get, call_574607.host, call_574607.base,
                         call_574607.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574607, url, valid)

proc call*(call_574608: Call_StorageAccountCredentialsGet_574599;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## storageAccountCredentialsGet
  ## Gets the properties of the specified storage account credential.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The storage account credential name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574609 = newJObject()
  var query_574610 = newJObject()
  add(path_574609, "resourceGroupName", newJString(resourceGroupName))
  add(query_574610, "api-version", newJString(apiVersion))
  add(path_574609, "name", newJString(name))
  add(path_574609, "subscriptionId", newJString(subscriptionId))
  add(path_574609, "deviceName", newJString(deviceName))
  result = call_574608.call(path_574609, query_574610, nil, nil, nil)

var storageAccountCredentialsGet* = Call_StorageAccountCredentialsGet_574599(
    name: "storageAccountCredentialsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/storageAccountCredentials/{name}",
    validator: validate_StorageAccountCredentialsGet_574600, base: "",
    url: url_StorageAccountCredentialsGet_574601, schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsDelete_574625 = ref object of OpenApiRestCall_573666
proc url_StorageAccountCredentialsDelete_574627(protocol: Scheme; host: string;
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

proc validate_StorageAccountCredentialsDelete_574626(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the storage account credential.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The storage account credential name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574628 = path.getOrDefault("resourceGroupName")
  valid_574628 = validateParameter(valid_574628, JString, required = true,
                                 default = nil)
  if valid_574628 != nil:
    section.add "resourceGroupName", valid_574628
  var valid_574629 = path.getOrDefault("name")
  valid_574629 = validateParameter(valid_574629, JString, required = true,
                                 default = nil)
  if valid_574629 != nil:
    section.add "name", valid_574629
  var valid_574630 = path.getOrDefault("subscriptionId")
  valid_574630 = validateParameter(valid_574630, JString, required = true,
                                 default = nil)
  if valid_574630 != nil:
    section.add "subscriptionId", valid_574630
  var valid_574631 = path.getOrDefault("deviceName")
  valid_574631 = validateParameter(valid_574631, JString, required = true,
                                 default = nil)
  if valid_574631 != nil:
    section.add "deviceName", valid_574631
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574632 = query.getOrDefault("api-version")
  valid_574632 = validateParameter(valid_574632, JString, required = true,
                                 default = nil)
  if valid_574632 != nil:
    section.add "api-version", valid_574632
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574633: Call_StorageAccountCredentialsDelete_574625;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the storage account credential.
  ## 
  let valid = call_574633.validator(path, query, header, formData, body)
  let scheme = call_574633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574633.url(scheme.get, call_574633.host, call_574633.base,
                         call_574633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574633, url, valid)

proc call*(call_574634: Call_StorageAccountCredentialsDelete_574625;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## storageAccountCredentialsDelete
  ## Deletes the storage account credential.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The storage account credential name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574635 = newJObject()
  var query_574636 = newJObject()
  add(path_574635, "resourceGroupName", newJString(resourceGroupName))
  add(query_574636, "api-version", newJString(apiVersion))
  add(path_574635, "name", newJString(name))
  add(path_574635, "subscriptionId", newJString(subscriptionId))
  add(path_574635, "deviceName", newJString(deviceName))
  result = call_574634.call(path_574635, query_574636, nil, nil, nil)

var storageAccountCredentialsDelete* = Call_StorageAccountCredentialsDelete_574625(
    name: "storageAccountCredentialsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/storageAccountCredentials/{name}",
    validator: validate_StorageAccountCredentialsDelete_574626, base: "",
    url: url_StorageAccountCredentialsDelete_574627, schemes: {Scheme.Https})
type
  Call_TriggersListByDataBoxEdgeDevice_574637 = ref object of OpenApiRestCall_573666
proc url_TriggersListByDataBoxEdgeDevice_574639(protocol: Scheme; host: string;
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

proc validate_TriggersListByDataBoxEdgeDevice_574638(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the triggers configured in the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574640 = path.getOrDefault("resourceGroupName")
  valid_574640 = validateParameter(valid_574640, JString, required = true,
                                 default = nil)
  if valid_574640 != nil:
    section.add "resourceGroupName", valid_574640
  var valid_574641 = path.getOrDefault("subscriptionId")
  valid_574641 = validateParameter(valid_574641, JString, required = true,
                                 default = nil)
  if valid_574641 != nil:
    section.add "subscriptionId", valid_574641
  var valid_574642 = path.getOrDefault("deviceName")
  valid_574642 = validateParameter(valid_574642, JString, required = true,
                                 default = nil)
  if valid_574642 != nil:
    section.add "deviceName", valid_574642
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $expand: JString
  ##          : Specify $filter='CustomContextTag eq <tag>' to filter on custom context tag property
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574643 = query.getOrDefault("api-version")
  valid_574643 = validateParameter(valid_574643, JString, required = true,
                                 default = nil)
  if valid_574643 != nil:
    section.add "api-version", valid_574643
  var valid_574644 = query.getOrDefault("$expand")
  valid_574644 = validateParameter(valid_574644, JString, required = false,
                                 default = nil)
  if valid_574644 != nil:
    section.add "$expand", valid_574644
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574645: Call_TriggersListByDataBoxEdgeDevice_574637;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the triggers configured in the device.
  ## 
  let valid = call_574645.validator(path, query, header, formData, body)
  let scheme = call_574645.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574645.url(scheme.get, call_574645.host, call_574645.base,
                         call_574645.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574645, url, valid)

proc call*(call_574646: Call_TriggersListByDataBoxEdgeDevice_574637;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string; Expand: string = ""): Recallable =
  ## triggersListByDataBoxEdgeDevice
  ## Lists all the triggers configured in the device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Expand: string
  ##         : Specify $filter='CustomContextTag eq <tag>' to filter on custom context tag property
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574647 = newJObject()
  var query_574648 = newJObject()
  add(path_574647, "resourceGroupName", newJString(resourceGroupName))
  add(query_574648, "api-version", newJString(apiVersion))
  add(query_574648, "$expand", newJString(Expand))
  add(path_574647, "subscriptionId", newJString(subscriptionId))
  add(path_574647, "deviceName", newJString(deviceName))
  result = call_574646.call(path_574647, query_574648, nil, nil, nil)

var triggersListByDataBoxEdgeDevice* = Call_TriggersListByDataBoxEdgeDevice_574637(
    name: "triggersListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/triggers",
    validator: validate_TriggersListByDataBoxEdgeDevice_574638, base: "",
    url: url_TriggersListByDataBoxEdgeDevice_574639, schemes: {Scheme.Https})
type
  Call_TriggersCreateOrUpdate_574661 = ref object of OpenApiRestCall_573666
proc url_TriggersCreateOrUpdate_574663(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersCreateOrUpdate_574662(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The trigger name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : Creates or updates a trigger
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574664 = path.getOrDefault("resourceGroupName")
  valid_574664 = validateParameter(valid_574664, JString, required = true,
                                 default = nil)
  if valid_574664 != nil:
    section.add "resourceGroupName", valid_574664
  var valid_574665 = path.getOrDefault("name")
  valid_574665 = validateParameter(valid_574665, JString, required = true,
                                 default = nil)
  if valid_574665 != nil:
    section.add "name", valid_574665
  var valid_574666 = path.getOrDefault("subscriptionId")
  valid_574666 = validateParameter(valid_574666, JString, required = true,
                                 default = nil)
  if valid_574666 != nil:
    section.add "subscriptionId", valid_574666
  var valid_574667 = path.getOrDefault("deviceName")
  valid_574667 = validateParameter(valid_574667, JString, required = true,
                                 default = nil)
  if valid_574667 != nil:
    section.add "deviceName", valid_574667
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574668 = query.getOrDefault("api-version")
  valid_574668 = validateParameter(valid_574668, JString, required = true,
                                 default = nil)
  if valid_574668 != nil:
    section.add "api-version", valid_574668
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

proc call*(call_574670: Call_TriggersCreateOrUpdate_574661; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a trigger.
  ## 
  let valid = call_574670.validator(path, query, header, formData, body)
  let scheme = call_574670.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574670.url(scheme.get, call_574670.host, call_574670.base,
                         call_574670.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574670, url, valid)

proc call*(call_574671: Call_TriggersCreateOrUpdate_574661;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; trigger: JsonNode; deviceName: string): Recallable =
  ## triggersCreateOrUpdate
  ## Creates or updates a trigger.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The trigger name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   trigger: JObject (required)
  ##          : The trigger.
  ##   deviceName: string (required)
  ##             : Creates or updates a trigger
  var path_574672 = newJObject()
  var query_574673 = newJObject()
  var body_574674 = newJObject()
  add(path_574672, "resourceGroupName", newJString(resourceGroupName))
  add(query_574673, "api-version", newJString(apiVersion))
  add(path_574672, "name", newJString(name))
  add(path_574672, "subscriptionId", newJString(subscriptionId))
  if trigger != nil:
    body_574674 = trigger
  add(path_574672, "deviceName", newJString(deviceName))
  result = call_574671.call(path_574672, query_574673, nil, nil, body_574674)

var triggersCreateOrUpdate* = Call_TriggersCreateOrUpdate_574661(
    name: "triggersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/triggers/{name}",
    validator: validate_TriggersCreateOrUpdate_574662, base: "",
    url: url_TriggersCreateOrUpdate_574663, schemes: {Scheme.Https})
type
  Call_TriggersGet_574649 = ref object of OpenApiRestCall_573666
proc url_TriggersGet_574651(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersGet_574650(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific trigger by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The trigger name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574652 = path.getOrDefault("resourceGroupName")
  valid_574652 = validateParameter(valid_574652, JString, required = true,
                                 default = nil)
  if valid_574652 != nil:
    section.add "resourceGroupName", valid_574652
  var valid_574653 = path.getOrDefault("name")
  valid_574653 = validateParameter(valid_574653, JString, required = true,
                                 default = nil)
  if valid_574653 != nil:
    section.add "name", valid_574653
  var valid_574654 = path.getOrDefault("subscriptionId")
  valid_574654 = validateParameter(valid_574654, JString, required = true,
                                 default = nil)
  if valid_574654 != nil:
    section.add "subscriptionId", valid_574654
  var valid_574655 = path.getOrDefault("deviceName")
  valid_574655 = validateParameter(valid_574655, JString, required = true,
                                 default = nil)
  if valid_574655 != nil:
    section.add "deviceName", valid_574655
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574656 = query.getOrDefault("api-version")
  valid_574656 = validateParameter(valid_574656, JString, required = true,
                                 default = nil)
  if valid_574656 != nil:
    section.add "api-version", valid_574656
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574657: Call_TriggersGet_574649; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific trigger by name.
  ## 
  let valid = call_574657.validator(path, query, header, formData, body)
  let scheme = call_574657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574657.url(scheme.get, call_574657.host, call_574657.base,
                         call_574657.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574657, url, valid)

proc call*(call_574658: Call_TriggersGet_574649; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string; deviceName: string): Recallable =
  ## triggersGet
  ## Get a specific trigger by name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The trigger name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574659 = newJObject()
  var query_574660 = newJObject()
  add(path_574659, "resourceGroupName", newJString(resourceGroupName))
  add(query_574660, "api-version", newJString(apiVersion))
  add(path_574659, "name", newJString(name))
  add(path_574659, "subscriptionId", newJString(subscriptionId))
  add(path_574659, "deviceName", newJString(deviceName))
  result = call_574658.call(path_574659, query_574660, nil, nil, nil)

var triggersGet* = Call_TriggersGet_574649(name: "triggersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/triggers/{name}",
                                        validator: validate_TriggersGet_574650,
                                        base: "", url: url_TriggersGet_574651,
                                        schemes: {Scheme.Https})
type
  Call_TriggersDelete_574675 = ref object of OpenApiRestCall_573666
proc url_TriggersDelete_574677(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersDelete_574676(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes the trigger on the gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The trigger name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574678 = path.getOrDefault("resourceGroupName")
  valid_574678 = validateParameter(valid_574678, JString, required = true,
                                 default = nil)
  if valid_574678 != nil:
    section.add "resourceGroupName", valid_574678
  var valid_574679 = path.getOrDefault("name")
  valid_574679 = validateParameter(valid_574679, JString, required = true,
                                 default = nil)
  if valid_574679 != nil:
    section.add "name", valid_574679
  var valid_574680 = path.getOrDefault("subscriptionId")
  valid_574680 = validateParameter(valid_574680, JString, required = true,
                                 default = nil)
  if valid_574680 != nil:
    section.add "subscriptionId", valid_574680
  var valid_574681 = path.getOrDefault("deviceName")
  valid_574681 = validateParameter(valid_574681, JString, required = true,
                                 default = nil)
  if valid_574681 != nil:
    section.add "deviceName", valid_574681
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574682 = query.getOrDefault("api-version")
  valid_574682 = validateParameter(valid_574682, JString, required = true,
                                 default = nil)
  if valid_574682 != nil:
    section.add "api-version", valid_574682
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574683: Call_TriggersDelete_574675; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the trigger on the gateway device.
  ## 
  let valid = call_574683.validator(path, query, header, formData, body)
  let scheme = call_574683.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574683.url(scheme.get, call_574683.host, call_574683.base,
                         call_574683.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574683, url, valid)

proc call*(call_574684: Call_TriggersDelete_574675; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string; deviceName: string): Recallable =
  ## triggersDelete
  ## Deletes the trigger on the gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The trigger name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574685 = newJObject()
  var query_574686 = newJObject()
  add(path_574685, "resourceGroupName", newJString(resourceGroupName))
  add(query_574686, "api-version", newJString(apiVersion))
  add(path_574685, "name", newJString(name))
  add(path_574685, "subscriptionId", newJString(subscriptionId))
  add(path_574685, "deviceName", newJString(deviceName))
  result = call_574684.call(path_574685, query_574686, nil, nil, nil)

var triggersDelete* = Call_TriggersDelete_574675(name: "triggersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/triggers/{name}",
    validator: validate_TriggersDelete_574676, base: "", url: url_TriggersDelete_574677,
    schemes: {Scheme.Https})
type
  Call_DevicesGetUpdateSummary_574687 = ref object of OpenApiRestCall_573666
proc url_DevicesGetUpdateSummary_574689(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesGetUpdateSummary_574688(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574690 = path.getOrDefault("resourceGroupName")
  valid_574690 = validateParameter(valid_574690, JString, required = true,
                                 default = nil)
  if valid_574690 != nil:
    section.add "resourceGroupName", valid_574690
  var valid_574691 = path.getOrDefault("subscriptionId")
  valid_574691 = validateParameter(valid_574691, JString, required = true,
                                 default = nil)
  if valid_574691 != nil:
    section.add "subscriptionId", valid_574691
  var valid_574692 = path.getOrDefault("deviceName")
  valid_574692 = validateParameter(valid_574692, JString, required = true,
                                 default = nil)
  if valid_574692 != nil:
    section.add "deviceName", valid_574692
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574693 = query.getOrDefault("api-version")
  valid_574693 = validateParameter(valid_574693, JString, required = true,
                                 default = nil)
  if valid_574693 != nil:
    section.add "api-version", valid_574693
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574694: Call_DevicesGetUpdateSummary_574687; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574694.validator(path, query, header, formData, body)
  let scheme = call_574694.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574694.url(scheme.get, call_574694.host, call_574694.base,
                         call_574694.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574694, url, valid)

proc call*(call_574695: Call_DevicesGetUpdateSummary_574687;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## devicesGetUpdateSummary
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574696 = newJObject()
  var query_574697 = newJObject()
  add(path_574696, "resourceGroupName", newJString(resourceGroupName))
  add(query_574697, "api-version", newJString(apiVersion))
  add(path_574696, "subscriptionId", newJString(subscriptionId))
  add(path_574696, "deviceName", newJString(deviceName))
  result = call_574695.call(path_574696, query_574697, nil, nil, nil)

var devicesGetUpdateSummary* = Call_DevicesGetUpdateSummary_574687(
    name: "devicesGetUpdateSummary", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/updateSummary/default",
    validator: validate_DevicesGetUpdateSummary_574688, base: "",
    url: url_DevicesGetUpdateSummary_574689, schemes: {Scheme.Https})
type
  Call_DevicesUploadCertificate_574698 = ref object of OpenApiRestCall_573666
proc url_DevicesUploadCertificate_574700(protocol: Scheme; host: string;
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

proc validate_DevicesUploadCertificate_574699(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads registration certificate for the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574701 = path.getOrDefault("resourceGroupName")
  valid_574701 = validateParameter(valid_574701, JString, required = true,
                                 default = nil)
  if valid_574701 != nil:
    section.add "resourceGroupName", valid_574701
  var valid_574702 = path.getOrDefault("subscriptionId")
  valid_574702 = validateParameter(valid_574702, JString, required = true,
                                 default = nil)
  if valid_574702 != nil:
    section.add "subscriptionId", valid_574702
  var valid_574703 = path.getOrDefault("deviceName")
  valid_574703 = validateParameter(valid_574703, JString, required = true,
                                 default = nil)
  if valid_574703 != nil:
    section.add "deviceName", valid_574703
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574704 = query.getOrDefault("api-version")
  valid_574704 = validateParameter(valid_574704, JString, required = true,
                                 default = nil)
  if valid_574704 != nil:
    section.add "api-version", valid_574704
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

proc call*(call_574706: Call_DevicesUploadCertificate_574698; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads registration certificate for the device.
  ## 
  let valid = call_574706.validator(path, query, header, formData, body)
  let scheme = call_574706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574706.url(scheme.get, call_574706.host, call_574706.base,
                         call_574706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574706, url, valid)

proc call*(call_574707: Call_DevicesUploadCertificate_574698;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; deviceName: string): Recallable =
  ## devicesUploadCertificate
  ## Uploads registration certificate for the device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   parameters: JObject (required)
  ##             : The upload certificate request.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574708 = newJObject()
  var query_574709 = newJObject()
  var body_574710 = newJObject()
  add(path_574708, "resourceGroupName", newJString(resourceGroupName))
  add(query_574709, "api-version", newJString(apiVersion))
  add(path_574708, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574710 = parameters
  add(path_574708, "deviceName", newJString(deviceName))
  result = call_574707.call(path_574708, query_574709, nil, nil, body_574710)

var devicesUploadCertificate* = Call_DevicesUploadCertificate_574698(
    name: "devicesUploadCertificate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/uploadCertificate",
    validator: validate_DevicesUploadCertificate_574699, base: "",
    url: url_DevicesUploadCertificate_574700, schemes: {Scheme.Https})
type
  Call_UsersListByDataBoxEdgeDevice_574711 = ref object of OpenApiRestCall_573666
proc url_UsersListByDataBoxEdgeDevice_574713(protocol: Scheme; host: string;
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

proc validate_UsersListByDataBoxEdgeDevice_574712(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the users registered on a data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574714 = path.getOrDefault("resourceGroupName")
  valid_574714 = validateParameter(valid_574714, JString, required = true,
                                 default = nil)
  if valid_574714 != nil:
    section.add "resourceGroupName", valid_574714
  var valid_574715 = path.getOrDefault("subscriptionId")
  valid_574715 = validateParameter(valid_574715, JString, required = true,
                                 default = nil)
  if valid_574715 != nil:
    section.add "subscriptionId", valid_574715
  var valid_574716 = path.getOrDefault("deviceName")
  valid_574716 = validateParameter(valid_574716, JString, required = true,
                                 default = nil)
  if valid_574716 != nil:
    section.add "deviceName", valid_574716
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574717 = query.getOrDefault("api-version")
  valid_574717 = validateParameter(valid_574717, JString, required = true,
                                 default = nil)
  if valid_574717 != nil:
    section.add "api-version", valid_574717
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574718: Call_UsersListByDataBoxEdgeDevice_574711; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the users registered on a data box edge/gateway device.
  ## 
  let valid = call_574718.validator(path, query, header, formData, body)
  let scheme = call_574718.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574718.url(scheme.get, call_574718.host, call_574718.base,
                         call_574718.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574718, url, valid)

proc call*(call_574719: Call_UsersListByDataBoxEdgeDevice_574711;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## usersListByDataBoxEdgeDevice
  ## Gets all the users registered on a data box edge/gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574720 = newJObject()
  var query_574721 = newJObject()
  add(path_574720, "resourceGroupName", newJString(resourceGroupName))
  add(query_574721, "api-version", newJString(apiVersion))
  add(path_574720, "subscriptionId", newJString(subscriptionId))
  add(path_574720, "deviceName", newJString(deviceName))
  result = call_574719.call(path_574720, query_574721, nil, nil, nil)

var usersListByDataBoxEdgeDevice* = Call_UsersListByDataBoxEdgeDevice_574711(
    name: "usersListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/users",
    validator: validate_UsersListByDataBoxEdgeDevice_574712, base: "",
    url: url_UsersListByDataBoxEdgeDevice_574713, schemes: {Scheme.Https})
type
  Call_UsersCreateOrUpdate_574734 = ref object of OpenApiRestCall_573666
proc url_UsersCreateOrUpdate_574736(protocol: Scheme; host: string; base: string;
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

proc validate_UsersCreateOrUpdate_574735(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a new user or updates an existing user's information on a data box edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The user name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574737 = path.getOrDefault("resourceGroupName")
  valid_574737 = validateParameter(valid_574737, JString, required = true,
                                 default = nil)
  if valid_574737 != nil:
    section.add "resourceGroupName", valid_574737
  var valid_574738 = path.getOrDefault("name")
  valid_574738 = validateParameter(valid_574738, JString, required = true,
                                 default = nil)
  if valid_574738 != nil:
    section.add "name", valid_574738
  var valid_574739 = path.getOrDefault("subscriptionId")
  valid_574739 = validateParameter(valid_574739, JString, required = true,
                                 default = nil)
  if valid_574739 != nil:
    section.add "subscriptionId", valid_574739
  var valid_574740 = path.getOrDefault("deviceName")
  valid_574740 = validateParameter(valid_574740, JString, required = true,
                                 default = nil)
  if valid_574740 != nil:
    section.add "deviceName", valid_574740
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574741 = query.getOrDefault("api-version")
  valid_574741 = validateParameter(valid_574741, JString, required = true,
                                 default = nil)
  if valid_574741 != nil:
    section.add "api-version", valid_574741
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

proc call*(call_574743: Call_UsersCreateOrUpdate_574734; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new user or updates an existing user's information on a data box edge/gateway device.
  ## 
  let valid = call_574743.validator(path, query, header, formData, body)
  let scheme = call_574743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574743.url(scheme.get, call_574743.host, call_574743.base,
                         call_574743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574743, url, valid)

proc call*(call_574744: Call_UsersCreateOrUpdate_574734; resourceGroupName: string;
          apiVersion: string; name: string; user: JsonNode; subscriptionId: string;
          deviceName: string): Recallable =
  ## usersCreateOrUpdate
  ## Creates a new user or updates an existing user's information on a data box edge/gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The user name.
  ##   user: JObject (required)
  ##       : The user details.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574745 = newJObject()
  var query_574746 = newJObject()
  var body_574747 = newJObject()
  add(path_574745, "resourceGroupName", newJString(resourceGroupName))
  add(query_574746, "api-version", newJString(apiVersion))
  add(path_574745, "name", newJString(name))
  if user != nil:
    body_574747 = user
  add(path_574745, "subscriptionId", newJString(subscriptionId))
  add(path_574745, "deviceName", newJString(deviceName))
  result = call_574744.call(path_574745, query_574746, nil, nil, body_574747)

var usersCreateOrUpdate* = Call_UsersCreateOrUpdate_574734(
    name: "usersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/users/{name}",
    validator: validate_UsersCreateOrUpdate_574735, base: "",
    url: url_UsersCreateOrUpdate_574736, schemes: {Scheme.Https})
type
  Call_UsersGet_574722 = ref object of OpenApiRestCall_573666
proc url_UsersGet_574724(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsersGet_574723(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The user name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574725 = path.getOrDefault("resourceGroupName")
  valid_574725 = validateParameter(valid_574725, JString, required = true,
                                 default = nil)
  if valid_574725 != nil:
    section.add "resourceGroupName", valid_574725
  var valid_574726 = path.getOrDefault("name")
  valid_574726 = validateParameter(valid_574726, JString, required = true,
                                 default = nil)
  if valid_574726 != nil:
    section.add "name", valid_574726
  var valid_574727 = path.getOrDefault("subscriptionId")
  valid_574727 = validateParameter(valid_574727, JString, required = true,
                                 default = nil)
  if valid_574727 != nil:
    section.add "subscriptionId", valid_574727
  var valid_574728 = path.getOrDefault("deviceName")
  valid_574728 = validateParameter(valid_574728, JString, required = true,
                                 default = nil)
  if valid_574728 != nil:
    section.add "deviceName", valid_574728
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574729 = query.getOrDefault("api-version")
  valid_574729 = validateParameter(valid_574729, JString, required = true,
                                 default = nil)
  if valid_574729 != nil:
    section.add "api-version", valid_574729
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574730: Call_UsersGet_574722; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified user.
  ## 
  let valid = call_574730.validator(path, query, header, formData, body)
  let scheme = call_574730.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574730.url(scheme.get, call_574730.host, call_574730.base,
                         call_574730.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574730, url, valid)

proc call*(call_574731: Call_UsersGet_574722; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string; deviceName: string): Recallable =
  ## usersGet
  ## Gets the properties of the specified user.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The user name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574732 = newJObject()
  var query_574733 = newJObject()
  add(path_574732, "resourceGroupName", newJString(resourceGroupName))
  add(query_574733, "api-version", newJString(apiVersion))
  add(path_574732, "name", newJString(name))
  add(path_574732, "subscriptionId", newJString(subscriptionId))
  add(path_574732, "deviceName", newJString(deviceName))
  result = call_574731.call(path_574732, query_574733, nil, nil, nil)

var usersGet* = Call_UsersGet_574722(name: "usersGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/users/{name}",
                                  validator: validate_UsersGet_574723, base: "",
                                  url: url_UsersGet_574724,
                                  schemes: {Scheme.Https})
type
  Call_UsersDelete_574748 = ref object of OpenApiRestCall_573666
proc url_UsersDelete_574750(protocol: Scheme; host: string; base: string;
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

proc validate_UsersDelete_574749(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the user on a databox edge/gateway device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   name: JString (required)
  ##       : The user name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574751 = path.getOrDefault("resourceGroupName")
  valid_574751 = validateParameter(valid_574751, JString, required = true,
                                 default = nil)
  if valid_574751 != nil:
    section.add "resourceGroupName", valid_574751
  var valid_574752 = path.getOrDefault("name")
  valid_574752 = validateParameter(valid_574752, JString, required = true,
                                 default = nil)
  if valid_574752 != nil:
    section.add "name", valid_574752
  var valid_574753 = path.getOrDefault("subscriptionId")
  valid_574753 = validateParameter(valid_574753, JString, required = true,
                                 default = nil)
  if valid_574753 != nil:
    section.add "subscriptionId", valid_574753
  var valid_574754 = path.getOrDefault("deviceName")
  valid_574754 = validateParameter(valid_574754, JString, required = true,
                                 default = nil)
  if valid_574754 != nil:
    section.add "deviceName", valid_574754
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574755 = query.getOrDefault("api-version")
  valid_574755 = validateParameter(valid_574755, JString, required = true,
                                 default = nil)
  if valid_574755 != nil:
    section.add "api-version", valid_574755
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574756: Call_UsersDelete_574748; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the user on a databox edge/gateway device.
  ## 
  let valid = call_574756.validator(path, query, header, formData, body)
  let scheme = call_574756.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574756.url(scheme.get, call_574756.host, call_574756.base,
                         call_574756.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574756, url, valid)

proc call*(call_574757: Call_UsersDelete_574748; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string; deviceName: string): Recallable =
  ## usersDelete
  ## Deletes the user on a databox edge/gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   name: string (required)
  ##       : The user name.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574758 = newJObject()
  var query_574759 = newJObject()
  add(path_574758, "resourceGroupName", newJString(resourceGroupName))
  add(query_574759, "api-version", newJString(apiVersion))
  add(path_574758, "name", newJString(name))
  add(path_574758, "subscriptionId", newJString(subscriptionId))
  add(path_574758, "deviceName", newJString(deviceName))
  result = call_574757.call(path_574758, query_574759, nil, nil, nil)

var usersDelete* = Call_UsersDelete_574748(name: "usersDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/users/{name}",
                                        validator: validate_UsersDelete_574749,
                                        base: "", url: url_UsersDelete_574750,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
