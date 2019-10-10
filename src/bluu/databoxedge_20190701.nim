
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

  OpenApiRestCall_573667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573667): Option[Scheme] {.used.} =
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
  Call_OperationsList_573889 = ref object of OpenApiRestCall_573667
proc url_OperationsList_573891(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_573890(path: JsonNode; query: JsonNode;
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
  var valid_574050 = query.getOrDefault("api-version")
  valid_574050 = validateParameter(valid_574050, JString, required = true,
                                 default = nil)
  if valid_574050 != nil:
    section.add "api-version", valid_574050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574073: Call_OperationsList_573889; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574073.validator(path, query, header, formData, body)
  let scheme = call_574073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574073.url(scheme.get, call_574073.host, call_574073.base,
                         call_574073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574073, url, valid)

proc call*(call_574144: Call_OperationsList_573889; apiVersion: string): Recallable =
  ## operationsList
  ##   apiVersion: string (required)
  ##             : The API version.
  var query_574145 = newJObject()
  add(query_574145, "api-version", newJString(apiVersion))
  result = call_574144.call(nil, query_574145, nil, nil, nil)

var operationsList* = Call_OperationsList_573889(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataBoxEdge/operations",
    validator: validate_OperationsList_573890, base: "", url: url_OperationsList_573891,
    schemes: {Scheme.Https})
type
  Call_DevicesListBySubscription_574185 = ref object of OpenApiRestCall_573667
proc url_DevicesListBySubscription_574187(protocol: Scheme; host: string;
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

proc validate_DevicesListBySubscription_574186(path: JsonNode; query: JsonNode;
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
  var valid_574203 = path.getOrDefault("subscriptionId")
  valid_574203 = validateParameter(valid_574203, JString, required = true,
                                 default = nil)
  if valid_574203 != nil:
    section.add "subscriptionId", valid_574203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the resource or Specify $skipToken=<token> to populate the next page in the list.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574204 = query.getOrDefault("api-version")
  valid_574204 = validateParameter(valid_574204, JString, required = true,
                                 default = nil)
  if valid_574204 != nil:
    section.add "api-version", valid_574204
  var valid_574205 = query.getOrDefault("$expand")
  valid_574205 = validateParameter(valid_574205, JString, required = false,
                                 default = nil)
  if valid_574205 != nil:
    section.add "$expand", valid_574205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574206: Call_DevicesListBySubscription_574185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the Data Box Edge/Data Box Gateway devices in a subscription.
  ## 
  let valid = call_574206.validator(path, query, header, formData, body)
  let scheme = call_574206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574206.url(scheme.get, call_574206.host, call_574206.base,
                         call_574206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574206, url, valid)

proc call*(call_574207: Call_DevicesListBySubscription_574185; apiVersion: string;
          subscriptionId: string; Expand: string = ""): Recallable =
  ## devicesListBySubscription
  ## Gets all the Data Box Edge/Data Box Gateway devices in a subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Expand: string
  ##         : Specify $expand=details to populate additional fields related to the resource or Specify $skipToken=<token> to populate the next page in the list.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_574208 = newJObject()
  var query_574209 = newJObject()
  add(query_574209, "api-version", newJString(apiVersion))
  add(query_574209, "$expand", newJString(Expand))
  add(path_574208, "subscriptionId", newJString(subscriptionId))
  result = call_574207.call(path_574208, query_574209, nil, nil, nil)

var devicesListBySubscription* = Call_DevicesListBySubscription_574185(
    name: "devicesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices",
    validator: validate_DevicesListBySubscription_574186, base: "",
    url: url_DevicesListBySubscription_574187, schemes: {Scheme.Https})
type
  Call_DevicesListByResourceGroup_574210 = ref object of OpenApiRestCall_573667
proc url_DevicesListByResourceGroup_574212(protocol: Scheme; host: string;
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

proc validate_DevicesListByResourceGroup_574211(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the Data Box Edge/Data Box Gateway devices in a resource group.
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
  var valid_574213 = path.getOrDefault("resourceGroupName")
  valid_574213 = validateParameter(valid_574213, JString, required = true,
                                 default = nil)
  if valid_574213 != nil:
    section.add "resourceGroupName", valid_574213
  var valid_574214 = path.getOrDefault("subscriptionId")
  valid_574214 = validateParameter(valid_574214, JString, required = true,
                                 default = nil)
  if valid_574214 != nil:
    section.add "subscriptionId", valid_574214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the resource or Specify $skipToken=<token> to populate the next page in the list.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574215 = query.getOrDefault("api-version")
  valid_574215 = validateParameter(valid_574215, JString, required = true,
                                 default = nil)
  if valid_574215 != nil:
    section.add "api-version", valid_574215
  var valid_574216 = query.getOrDefault("$expand")
  valid_574216 = validateParameter(valid_574216, JString, required = false,
                                 default = nil)
  if valid_574216 != nil:
    section.add "$expand", valid_574216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574217: Call_DevicesListByResourceGroup_574210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the Data Box Edge/Data Box Gateway devices in a resource group.
  ## 
  let valid = call_574217.validator(path, query, header, formData, body)
  let scheme = call_574217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574217.url(scheme.get, call_574217.host, call_574217.base,
                         call_574217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574217, url, valid)

proc call*(call_574218: Call_DevicesListByResourceGroup_574210;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Expand: string = ""): Recallable =
  ## devicesListByResourceGroup
  ## Gets all the Data Box Edge/Data Box Gateway devices in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Expand: string
  ##         : Specify $expand=details to populate additional fields related to the resource or Specify $skipToken=<token> to populate the next page in the list.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_574219 = newJObject()
  var query_574220 = newJObject()
  add(path_574219, "resourceGroupName", newJString(resourceGroupName))
  add(query_574220, "api-version", newJString(apiVersion))
  add(query_574220, "$expand", newJString(Expand))
  add(path_574219, "subscriptionId", newJString(subscriptionId))
  result = call_574218.call(path_574219, query_574220, nil, nil, nil)

var devicesListByResourceGroup* = Call_DevicesListByResourceGroup_574210(
    name: "devicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices",
    validator: validate_DevicesListByResourceGroup_574211, base: "",
    url: url_DevicesListByResourceGroup_574212, schemes: {Scheme.Https})
type
  Call_DevicesCreateOrUpdate_574232 = ref object of OpenApiRestCall_573667
proc url_DevicesCreateOrUpdate_574234(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesCreateOrUpdate_574233(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a Data Box Edge/Data Box Gateway resource.
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
  var valid_574235 = path.getOrDefault("resourceGroupName")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "resourceGroupName", valid_574235
  var valid_574236 = path.getOrDefault("subscriptionId")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = nil)
  if valid_574236 != nil:
    section.add "subscriptionId", valid_574236
  var valid_574237 = path.getOrDefault("deviceName")
  valid_574237 = validateParameter(valid_574237, JString, required = true,
                                 default = nil)
  if valid_574237 != nil:
    section.add "deviceName", valid_574237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574238 = query.getOrDefault("api-version")
  valid_574238 = validateParameter(valid_574238, JString, required = true,
                                 default = nil)
  if valid_574238 != nil:
    section.add "api-version", valid_574238
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

proc call*(call_574240: Call_DevicesCreateOrUpdate_574232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Data Box Edge/Data Box Gateway resource.
  ## 
  let valid = call_574240.validator(path, query, header, formData, body)
  let scheme = call_574240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574240.url(scheme.get, call_574240.host, call_574240.base,
                         call_574240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574240, url, valid)

proc call*(call_574241: Call_DevicesCreateOrUpdate_574232;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          DataBoxEdgeDevice: JsonNode; deviceName: string): Recallable =
  ## devicesCreateOrUpdate
  ## Creates or updates a Data Box Edge/Data Box Gateway resource.
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
  var path_574242 = newJObject()
  var query_574243 = newJObject()
  var body_574244 = newJObject()
  add(path_574242, "resourceGroupName", newJString(resourceGroupName))
  add(query_574243, "api-version", newJString(apiVersion))
  add(path_574242, "subscriptionId", newJString(subscriptionId))
  if DataBoxEdgeDevice != nil:
    body_574244 = DataBoxEdgeDevice
  add(path_574242, "deviceName", newJString(deviceName))
  result = call_574241.call(path_574242, query_574243, nil, nil, body_574244)

var devicesCreateOrUpdate* = Call_DevicesCreateOrUpdate_574232(
    name: "devicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}",
    validator: validate_DevicesCreateOrUpdate_574233, base: "",
    url: url_DevicesCreateOrUpdate_574234, schemes: {Scheme.Https})
type
  Call_DevicesGet_574221 = ref object of OpenApiRestCall_573667
proc url_DevicesGet_574223(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DevicesGet_574222(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the Data Box Edge/Data Box Gateway device.
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
  var valid_574224 = path.getOrDefault("resourceGroupName")
  valid_574224 = validateParameter(valid_574224, JString, required = true,
                                 default = nil)
  if valid_574224 != nil:
    section.add "resourceGroupName", valid_574224
  var valid_574225 = path.getOrDefault("subscriptionId")
  valid_574225 = validateParameter(valid_574225, JString, required = true,
                                 default = nil)
  if valid_574225 != nil:
    section.add "subscriptionId", valid_574225
  var valid_574226 = path.getOrDefault("deviceName")
  valid_574226 = validateParameter(valid_574226, JString, required = true,
                                 default = nil)
  if valid_574226 != nil:
    section.add "deviceName", valid_574226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574227 = query.getOrDefault("api-version")
  valid_574227 = validateParameter(valid_574227, JString, required = true,
                                 default = nil)
  if valid_574227 != nil:
    section.add "api-version", valid_574227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574228: Call_DevicesGet_574221; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_574228.validator(path, query, header, formData, body)
  let scheme = call_574228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574228.url(scheme.get, call_574228.host, call_574228.base,
                         call_574228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574228, url, valid)

proc call*(call_574229: Call_DevicesGet_574221; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; deviceName: string): Recallable =
  ## devicesGet
  ## Gets the properties of the Data Box Edge/Data Box Gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574230 = newJObject()
  var query_574231 = newJObject()
  add(path_574230, "resourceGroupName", newJString(resourceGroupName))
  add(query_574231, "api-version", newJString(apiVersion))
  add(path_574230, "subscriptionId", newJString(subscriptionId))
  add(path_574230, "deviceName", newJString(deviceName))
  result = call_574229.call(path_574230, query_574231, nil, nil, nil)

var devicesGet* = Call_DevicesGet_574221(name: "devicesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}",
                                      validator: validate_DevicesGet_574222,
                                      base: "", url: url_DevicesGet_574223,
                                      schemes: {Scheme.Https})
type
  Call_DevicesUpdate_574256 = ref object of OpenApiRestCall_573667
proc url_DevicesUpdate_574258(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesUpdate_574257(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies a Data Box Edge/Data Box Gateway resource.
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
  var valid_574259 = path.getOrDefault("resourceGroupName")
  valid_574259 = validateParameter(valid_574259, JString, required = true,
                                 default = nil)
  if valid_574259 != nil:
    section.add "resourceGroupName", valid_574259
  var valid_574260 = path.getOrDefault("subscriptionId")
  valid_574260 = validateParameter(valid_574260, JString, required = true,
                                 default = nil)
  if valid_574260 != nil:
    section.add "subscriptionId", valid_574260
  var valid_574261 = path.getOrDefault("deviceName")
  valid_574261 = validateParameter(valid_574261, JString, required = true,
                                 default = nil)
  if valid_574261 != nil:
    section.add "deviceName", valid_574261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574262 = query.getOrDefault("api-version")
  valid_574262 = validateParameter(valid_574262, JString, required = true,
                                 default = nil)
  if valid_574262 != nil:
    section.add "api-version", valid_574262
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

proc call*(call_574264: Call_DevicesUpdate_574256; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a Data Box Edge/Data Box Gateway resource.
  ## 
  let valid = call_574264.validator(path, query, header, formData, body)
  let scheme = call_574264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574264.url(scheme.get, call_574264.host, call_574264.base,
                         call_574264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574264, url, valid)

proc call*(call_574265: Call_DevicesUpdate_574256; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          deviceName: string): Recallable =
  ## devicesUpdate
  ## Modifies a Data Box Edge/Data Box Gateway resource.
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
  var path_574266 = newJObject()
  var query_574267 = newJObject()
  var body_574268 = newJObject()
  add(path_574266, "resourceGroupName", newJString(resourceGroupName))
  add(query_574267, "api-version", newJString(apiVersion))
  add(path_574266, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574268 = parameters
  add(path_574266, "deviceName", newJString(deviceName))
  result = call_574265.call(path_574266, query_574267, nil, nil, body_574268)

var devicesUpdate* = Call_DevicesUpdate_574256(name: "devicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}",
    validator: validate_DevicesUpdate_574257, base: "", url: url_DevicesUpdate_574258,
    schemes: {Scheme.Https})
type
  Call_DevicesDelete_574245 = ref object of OpenApiRestCall_573667
proc url_DevicesDelete_574247(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesDelete_574246(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the Data Box Edge/Data Box Gateway device.
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
  var valid_574248 = path.getOrDefault("resourceGroupName")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "resourceGroupName", valid_574248
  var valid_574249 = path.getOrDefault("subscriptionId")
  valid_574249 = validateParameter(valid_574249, JString, required = true,
                                 default = nil)
  if valid_574249 != nil:
    section.add "subscriptionId", valid_574249
  var valid_574250 = path.getOrDefault("deviceName")
  valid_574250 = validateParameter(valid_574250, JString, required = true,
                                 default = nil)
  if valid_574250 != nil:
    section.add "deviceName", valid_574250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574251 = query.getOrDefault("api-version")
  valid_574251 = validateParameter(valid_574251, JString, required = true,
                                 default = nil)
  if valid_574251 != nil:
    section.add "api-version", valid_574251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574252: Call_DevicesDelete_574245; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_574252.validator(path, query, header, formData, body)
  let scheme = call_574252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574252.url(scheme.get, call_574252.host, call_574252.base,
                         call_574252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574252, url, valid)

proc call*(call_574253: Call_DevicesDelete_574245; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; deviceName: string): Recallable =
  ## devicesDelete
  ## Deletes the Data Box Edge/Data Box Gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574254 = newJObject()
  var query_574255 = newJObject()
  add(path_574254, "resourceGroupName", newJString(resourceGroupName))
  add(query_574255, "api-version", newJString(apiVersion))
  add(path_574254, "subscriptionId", newJString(subscriptionId))
  add(path_574254, "deviceName", newJString(deviceName))
  result = call_574253.call(path_574254, query_574255, nil, nil, nil)

var devicesDelete* = Call_DevicesDelete_574245(name: "devicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}",
    validator: validate_DevicesDelete_574246, base: "", url: url_DevicesDelete_574247,
    schemes: {Scheme.Https})
type
  Call_AlertsListByDataBoxEdgeDevice_574269 = ref object of OpenApiRestCall_573667
proc url_AlertsListByDataBoxEdgeDevice_574271(protocol: Scheme; host: string;
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

proc validate_AlertsListByDataBoxEdgeDevice_574270(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the alerts for a Data Box Edge/Data Box Gateway device.
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
  var valid_574272 = path.getOrDefault("resourceGroupName")
  valid_574272 = validateParameter(valid_574272, JString, required = true,
                                 default = nil)
  if valid_574272 != nil:
    section.add "resourceGroupName", valid_574272
  var valid_574273 = path.getOrDefault("subscriptionId")
  valid_574273 = validateParameter(valid_574273, JString, required = true,
                                 default = nil)
  if valid_574273 != nil:
    section.add "subscriptionId", valid_574273
  var valid_574274 = path.getOrDefault("deviceName")
  valid_574274 = validateParameter(valid_574274, JString, required = true,
                                 default = nil)
  if valid_574274 != nil:
    section.add "deviceName", valid_574274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574275 = query.getOrDefault("api-version")
  valid_574275 = validateParameter(valid_574275, JString, required = true,
                                 default = nil)
  if valid_574275 != nil:
    section.add "api-version", valid_574275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574276: Call_AlertsListByDataBoxEdgeDevice_574269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the alerts for a Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_574276.validator(path, query, header, formData, body)
  let scheme = call_574276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574276.url(scheme.get, call_574276.host, call_574276.base,
                         call_574276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574276, url, valid)

proc call*(call_574277: Call_AlertsListByDataBoxEdgeDevice_574269;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## alertsListByDataBoxEdgeDevice
  ## Gets all the alerts for a Data Box Edge/Data Box Gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574278 = newJObject()
  var query_574279 = newJObject()
  add(path_574278, "resourceGroupName", newJString(resourceGroupName))
  add(query_574279, "api-version", newJString(apiVersion))
  add(path_574278, "subscriptionId", newJString(subscriptionId))
  add(path_574278, "deviceName", newJString(deviceName))
  result = call_574277.call(path_574278, query_574279, nil, nil, nil)

var alertsListByDataBoxEdgeDevice* = Call_AlertsListByDataBoxEdgeDevice_574269(
    name: "alertsListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/alerts",
    validator: validate_AlertsListByDataBoxEdgeDevice_574270, base: "",
    url: url_AlertsListByDataBoxEdgeDevice_574271, schemes: {Scheme.Https})
type
  Call_AlertsGet_574280 = ref object of OpenApiRestCall_573667
proc url_AlertsGet_574282(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AlertsGet_574281(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574283 = path.getOrDefault("resourceGroupName")
  valid_574283 = validateParameter(valid_574283, JString, required = true,
                                 default = nil)
  if valid_574283 != nil:
    section.add "resourceGroupName", valid_574283
  var valid_574284 = path.getOrDefault("name")
  valid_574284 = validateParameter(valid_574284, JString, required = true,
                                 default = nil)
  if valid_574284 != nil:
    section.add "name", valid_574284
  var valid_574285 = path.getOrDefault("subscriptionId")
  valid_574285 = validateParameter(valid_574285, JString, required = true,
                                 default = nil)
  if valid_574285 != nil:
    section.add "subscriptionId", valid_574285
  var valid_574286 = path.getOrDefault("deviceName")
  valid_574286 = validateParameter(valid_574286, JString, required = true,
                                 default = nil)
  if valid_574286 != nil:
    section.add "deviceName", valid_574286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574287 = query.getOrDefault("api-version")
  valid_574287 = validateParameter(valid_574287, JString, required = true,
                                 default = nil)
  if valid_574287 != nil:
    section.add "api-version", valid_574287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574288: Call_AlertsGet_574280; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574288.validator(path, query, header, formData, body)
  let scheme = call_574288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574288.url(scheme.get, call_574288.host, call_574288.base,
                         call_574288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574288, url, valid)

proc call*(call_574289: Call_AlertsGet_574280; resourceGroupName: string;
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
  var path_574290 = newJObject()
  var query_574291 = newJObject()
  add(path_574290, "resourceGroupName", newJString(resourceGroupName))
  add(query_574291, "api-version", newJString(apiVersion))
  add(path_574290, "name", newJString(name))
  add(path_574290, "subscriptionId", newJString(subscriptionId))
  add(path_574290, "deviceName", newJString(deviceName))
  result = call_574289.call(path_574290, query_574291, nil, nil, nil)

var alertsGet* = Call_AlertsGet_574280(name: "alertsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/alerts/{name}",
                                    validator: validate_AlertsGet_574281,
                                    base: "", url: url_AlertsGet_574282,
                                    schemes: {Scheme.Https})
type
  Call_BandwidthSchedulesListByDataBoxEdgeDevice_574292 = ref object of OpenApiRestCall_573667
proc url_BandwidthSchedulesListByDataBoxEdgeDevice_574294(protocol: Scheme;
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

proc validate_BandwidthSchedulesListByDataBoxEdgeDevice_574293(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the bandwidth schedules for a Data Box Edge/Data Box Gateway device.
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
  var valid_574295 = path.getOrDefault("resourceGroupName")
  valid_574295 = validateParameter(valid_574295, JString, required = true,
                                 default = nil)
  if valid_574295 != nil:
    section.add "resourceGroupName", valid_574295
  var valid_574296 = path.getOrDefault("subscriptionId")
  valid_574296 = validateParameter(valid_574296, JString, required = true,
                                 default = nil)
  if valid_574296 != nil:
    section.add "subscriptionId", valid_574296
  var valid_574297 = path.getOrDefault("deviceName")
  valid_574297 = validateParameter(valid_574297, JString, required = true,
                                 default = nil)
  if valid_574297 != nil:
    section.add "deviceName", valid_574297
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574298 = query.getOrDefault("api-version")
  valid_574298 = validateParameter(valid_574298, JString, required = true,
                                 default = nil)
  if valid_574298 != nil:
    section.add "api-version", valid_574298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574299: Call_BandwidthSchedulesListByDataBoxEdgeDevice_574292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the bandwidth schedules for a Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_574299.validator(path, query, header, formData, body)
  let scheme = call_574299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574299.url(scheme.get, call_574299.host, call_574299.base,
                         call_574299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574299, url, valid)

proc call*(call_574300: Call_BandwidthSchedulesListByDataBoxEdgeDevice_574292;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## bandwidthSchedulesListByDataBoxEdgeDevice
  ## Gets all the bandwidth schedules for a Data Box Edge/Data Box Gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574301 = newJObject()
  var query_574302 = newJObject()
  add(path_574301, "resourceGroupName", newJString(resourceGroupName))
  add(query_574302, "api-version", newJString(apiVersion))
  add(path_574301, "subscriptionId", newJString(subscriptionId))
  add(path_574301, "deviceName", newJString(deviceName))
  result = call_574300.call(path_574301, query_574302, nil, nil, nil)

var bandwidthSchedulesListByDataBoxEdgeDevice* = Call_BandwidthSchedulesListByDataBoxEdgeDevice_574292(
    name: "bandwidthSchedulesListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/bandwidthSchedules",
    validator: validate_BandwidthSchedulesListByDataBoxEdgeDevice_574293,
    base: "", url: url_BandwidthSchedulesListByDataBoxEdgeDevice_574294,
    schemes: {Scheme.Https})
type
  Call_BandwidthSchedulesCreateOrUpdate_574315 = ref object of OpenApiRestCall_573667
proc url_BandwidthSchedulesCreateOrUpdate_574317(protocol: Scheme; host: string;
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

proc validate_BandwidthSchedulesCreateOrUpdate_574316(path: JsonNode;
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
  var valid_574318 = path.getOrDefault("resourceGroupName")
  valid_574318 = validateParameter(valid_574318, JString, required = true,
                                 default = nil)
  if valid_574318 != nil:
    section.add "resourceGroupName", valid_574318
  var valid_574319 = path.getOrDefault("name")
  valid_574319 = validateParameter(valid_574319, JString, required = true,
                                 default = nil)
  if valid_574319 != nil:
    section.add "name", valid_574319
  var valid_574320 = path.getOrDefault("subscriptionId")
  valid_574320 = validateParameter(valid_574320, JString, required = true,
                                 default = nil)
  if valid_574320 != nil:
    section.add "subscriptionId", valid_574320
  var valid_574321 = path.getOrDefault("deviceName")
  valid_574321 = validateParameter(valid_574321, JString, required = true,
                                 default = nil)
  if valid_574321 != nil:
    section.add "deviceName", valid_574321
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574322 = query.getOrDefault("api-version")
  valid_574322 = validateParameter(valid_574322, JString, required = true,
                                 default = nil)
  if valid_574322 != nil:
    section.add "api-version", valid_574322
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

proc call*(call_574324: Call_BandwidthSchedulesCreateOrUpdate_574315;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a bandwidth schedule.
  ## 
  let valid = call_574324.validator(path, query, header, formData, body)
  let scheme = call_574324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574324.url(scheme.get, call_574324.host, call_574324.base,
                         call_574324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574324, url, valid)

proc call*(call_574325: Call_BandwidthSchedulesCreateOrUpdate_574315;
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
  var path_574326 = newJObject()
  var query_574327 = newJObject()
  var body_574328 = newJObject()
  add(path_574326, "resourceGroupName", newJString(resourceGroupName))
  add(query_574327, "api-version", newJString(apiVersion))
  add(path_574326, "name", newJString(name))
  add(path_574326, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574328 = parameters
  add(path_574326, "deviceName", newJString(deviceName))
  result = call_574325.call(path_574326, query_574327, nil, nil, body_574328)

var bandwidthSchedulesCreateOrUpdate* = Call_BandwidthSchedulesCreateOrUpdate_574315(
    name: "bandwidthSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/bandwidthSchedules/{name}",
    validator: validate_BandwidthSchedulesCreateOrUpdate_574316, base: "",
    url: url_BandwidthSchedulesCreateOrUpdate_574317, schemes: {Scheme.Https})
type
  Call_BandwidthSchedulesGet_574303 = ref object of OpenApiRestCall_573667
proc url_BandwidthSchedulesGet_574305(protocol: Scheme; host: string; base: string;
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

proc validate_BandwidthSchedulesGet_574304(path: JsonNode; query: JsonNode;
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
  var valid_574306 = path.getOrDefault("resourceGroupName")
  valid_574306 = validateParameter(valid_574306, JString, required = true,
                                 default = nil)
  if valid_574306 != nil:
    section.add "resourceGroupName", valid_574306
  var valid_574307 = path.getOrDefault("name")
  valid_574307 = validateParameter(valid_574307, JString, required = true,
                                 default = nil)
  if valid_574307 != nil:
    section.add "name", valid_574307
  var valid_574308 = path.getOrDefault("subscriptionId")
  valid_574308 = validateParameter(valid_574308, JString, required = true,
                                 default = nil)
  if valid_574308 != nil:
    section.add "subscriptionId", valid_574308
  var valid_574309 = path.getOrDefault("deviceName")
  valid_574309 = validateParameter(valid_574309, JString, required = true,
                                 default = nil)
  if valid_574309 != nil:
    section.add "deviceName", valid_574309
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574310 = query.getOrDefault("api-version")
  valid_574310 = validateParameter(valid_574310, JString, required = true,
                                 default = nil)
  if valid_574310 != nil:
    section.add "api-version", valid_574310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574311: Call_BandwidthSchedulesGet_574303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified bandwidth schedule.
  ## 
  let valid = call_574311.validator(path, query, header, formData, body)
  let scheme = call_574311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574311.url(scheme.get, call_574311.host, call_574311.base,
                         call_574311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574311, url, valid)

proc call*(call_574312: Call_BandwidthSchedulesGet_574303;
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
  var path_574313 = newJObject()
  var query_574314 = newJObject()
  add(path_574313, "resourceGroupName", newJString(resourceGroupName))
  add(query_574314, "api-version", newJString(apiVersion))
  add(path_574313, "name", newJString(name))
  add(path_574313, "subscriptionId", newJString(subscriptionId))
  add(path_574313, "deviceName", newJString(deviceName))
  result = call_574312.call(path_574313, query_574314, nil, nil, nil)

var bandwidthSchedulesGet* = Call_BandwidthSchedulesGet_574303(
    name: "bandwidthSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/bandwidthSchedules/{name}",
    validator: validate_BandwidthSchedulesGet_574304, base: "",
    url: url_BandwidthSchedulesGet_574305, schemes: {Scheme.Https})
type
  Call_BandwidthSchedulesDelete_574329 = ref object of OpenApiRestCall_573667
proc url_BandwidthSchedulesDelete_574331(protocol: Scheme; host: string;
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

proc validate_BandwidthSchedulesDelete_574330(path: JsonNode; query: JsonNode;
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
  var valid_574332 = path.getOrDefault("resourceGroupName")
  valid_574332 = validateParameter(valid_574332, JString, required = true,
                                 default = nil)
  if valid_574332 != nil:
    section.add "resourceGroupName", valid_574332
  var valid_574333 = path.getOrDefault("name")
  valid_574333 = validateParameter(valid_574333, JString, required = true,
                                 default = nil)
  if valid_574333 != nil:
    section.add "name", valid_574333
  var valid_574334 = path.getOrDefault("subscriptionId")
  valid_574334 = validateParameter(valid_574334, JString, required = true,
                                 default = nil)
  if valid_574334 != nil:
    section.add "subscriptionId", valid_574334
  var valid_574335 = path.getOrDefault("deviceName")
  valid_574335 = validateParameter(valid_574335, JString, required = true,
                                 default = nil)
  if valid_574335 != nil:
    section.add "deviceName", valid_574335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574336 = query.getOrDefault("api-version")
  valid_574336 = validateParameter(valid_574336, JString, required = true,
                                 default = nil)
  if valid_574336 != nil:
    section.add "api-version", valid_574336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574337: Call_BandwidthSchedulesDelete_574329; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified bandwidth schedule.
  ## 
  let valid = call_574337.validator(path, query, header, formData, body)
  let scheme = call_574337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574337.url(scheme.get, call_574337.host, call_574337.base,
                         call_574337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574337, url, valid)

proc call*(call_574338: Call_BandwidthSchedulesDelete_574329;
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
  var path_574339 = newJObject()
  var query_574340 = newJObject()
  add(path_574339, "resourceGroupName", newJString(resourceGroupName))
  add(query_574340, "api-version", newJString(apiVersion))
  add(path_574339, "name", newJString(name))
  add(path_574339, "subscriptionId", newJString(subscriptionId))
  add(path_574339, "deviceName", newJString(deviceName))
  result = call_574338.call(path_574339, query_574340, nil, nil, nil)

var bandwidthSchedulesDelete* = Call_BandwidthSchedulesDelete_574329(
    name: "bandwidthSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/bandwidthSchedules/{name}",
    validator: validate_BandwidthSchedulesDelete_574330, base: "",
    url: url_BandwidthSchedulesDelete_574331, schemes: {Scheme.Https})
type
  Call_DevicesDownloadUpdates_574341 = ref object of OpenApiRestCall_573667
proc url_DevicesDownloadUpdates_574343(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesDownloadUpdates_574342(path: JsonNode; query: JsonNode;
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
  var valid_574344 = path.getOrDefault("resourceGroupName")
  valid_574344 = validateParameter(valid_574344, JString, required = true,
                                 default = nil)
  if valid_574344 != nil:
    section.add "resourceGroupName", valid_574344
  var valid_574345 = path.getOrDefault("subscriptionId")
  valid_574345 = validateParameter(valid_574345, JString, required = true,
                                 default = nil)
  if valid_574345 != nil:
    section.add "subscriptionId", valid_574345
  var valid_574346 = path.getOrDefault("deviceName")
  valid_574346 = validateParameter(valid_574346, JString, required = true,
                                 default = nil)
  if valid_574346 != nil:
    section.add "deviceName", valid_574346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574347 = query.getOrDefault("api-version")
  valid_574347 = validateParameter(valid_574347, JString, required = true,
                                 default = nil)
  if valid_574347 != nil:
    section.add "api-version", valid_574347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574348: Call_DevicesDownloadUpdates_574341; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574348.validator(path, query, header, formData, body)
  let scheme = call_574348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574348.url(scheme.get, call_574348.host, call_574348.base,
                         call_574348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574348, url, valid)

proc call*(call_574349: Call_DevicesDownloadUpdates_574341;
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
  var path_574350 = newJObject()
  var query_574351 = newJObject()
  add(path_574350, "resourceGroupName", newJString(resourceGroupName))
  add(query_574351, "api-version", newJString(apiVersion))
  add(path_574350, "subscriptionId", newJString(subscriptionId))
  add(path_574350, "deviceName", newJString(deviceName))
  result = call_574349.call(path_574350, query_574351, nil, nil, nil)

var devicesDownloadUpdates* = Call_DevicesDownloadUpdates_574341(
    name: "devicesDownloadUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/downloadUpdates",
    validator: validate_DevicesDownloadUpdates_574342, base: "",
    url: url_DevicesDownloadUpdates_574343, schemes: {Scheme.Https})
type
  Call_DevicesGetExtendedInformation_574352 = ref object of OpenApiRestCall_573667
proc url_DevicesGetExtendedInformation_574354(protocol: Scheme; host: string;
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

proc validate_DevicesGetExtendedInformation_574353(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets additional information for the specified Data Box Edge/Data Box Gateway device.
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
  var valid_574355 = path.getOrDefault("resourceGroupName")
  valid_574355 = validateParameter(valid_574355, JString, required = true,
                                 default = nil)
  if valid_574355 != nil:
    section.add "resourceGroupName", valid_574355
  var valid_574356 = path.getOrDefault("subscriptionId")
  valid_574356 = validateParameter(valid_574356, JString, required = true,
                                 default = nil)
  if valid_574356 != nil:
    section.add "subscriptionId", valid_574356
  var valid_574357 = path.getOrDefault("deviceName")
  valid_574357 = validateParameter(valid_574357, JString, required = true,
                                 default = nil)
  if valid_574357 != nil:
    section.add "deviceName", valid_574357
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574358 = query.getOrDefault("api-version")
  valid_574358 = validateParameter(valid_574358, JString, required = true,
                                 default = nil)
  if valid_574358 != nil:
    section.add "api-version", valid_574358
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574359: Call_DevicesGetExtendedInformation_574352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets additional information for the specified Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_574359.validator(path, query, header, formData, body)
  let scheme = call_574359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574359.url(scheme.get, call_574359.host, call_574359.base,
                         call_574359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574359, url, valid)

proc call*(call_574360: Call_DevicesGetExtendedInformation_574352;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## devicesGetExtendedInformation
  ## Gets additional information for the specified Data Box Edge/Data Box Gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574361 = newJObject()
  var query_574362 = newJObject()
  add(path_574361, "resourceGroupName", newJString(resourceGroupName))
  add(query_574362, "api-version", newJString(apiVersion))
  add(path_574361, "subscriptionId", newJString(subscriptionId))
  add(path_574361, "deviceName", newJString(deviceName))
  result = call_574360.call(path_574361, query_574362, nil, nil, nil)

var devicesGetExtendedInformation* = Call_DevicesGetExtendedInformation_574352(
    name: "devicesGetExtendedInformation", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/getExtendedInformation",
    validator: validate_DevicesGetExtendedInformation_574353, base: "",
    url: url_DevicesGetExtendedInformation_574354, schemes: {Scheme.Https})
type
  Call_DevicesInstallUpdates_574363 = ref object of OpenApiRestCall_573667
proc url_DevicesInstallUpdates_574365(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesInstallUpdates_574364(path: JsonNode; query: JsonNode;
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
  var valid_574366 = path.getOrDefault("resourceGroupName")
  valid_574366 = validateParameter(valid_574366, JString, required = true,
                                 default = nil)
  if valid_574366 != nil:
    section.add "resourceGroupName", valid_574366
  var valid_574367 = path.getOrDefault("subscriptionId")
  valid_574367 = validateParameter(valid_574367, JString, required = true,
                                 default = nil)
  if valid_574367 != nil:
    section.add "subscriptionId", valid_574367
  var valid_574368 = path.getOrDefault("deviceName")
  valid_574368 = validateParameter(valid_574368, JString, required = true,
                                 default = nil)
  if valid_574368 != nil:
    section.add "deviceName", valid_574368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574369 = query.getOrDefault("api-version")
  valid_574369 = validateParameter(valid_574369, JString, required = true,
                                 default = nil)
  if valid_574369 != nil:
    section.add "api-version", valid_574369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574370: Call_DevicesInstallUpdates_574363; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574370.validator(path, query, header, formData, body)
  let scheme = call_574370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574370.url(scheme.get, call_574370.host, call_574370.base,
                         call_574370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574370, url, valid)

proc call*(call_574371: Call_DevicesInstallUpdates_574363;
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
  var path_574372 = newJObject()
  var query_574373 = newJObject()
  add(path_574372, "resourceGroupName", newJString(resourceGroupName))
  add(query_574373, "api-version", newJString(apiVersion))
  add(path_574372, "subscriptionId", newJString(subscriptionId))
  add(path_574372, "deviceName", newJString(deviceName))
  result = call_574371.call(path_574372, query_574373, nil, nil, nil)

var devicesInstallUpdates* = Call_DevicesInstallUpdates_574363(
    name: "devicesInstallUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/installUpdates",
    validator: validate_DevicesInstallUpdates_574364, base: "",
    url: url_DevicesInstallUpdates_574365, schemes: {Scheme.Https})
type
  Call_JobsGet_574374 = ref object of OpenApiRestCall_573667
proc url_JobsGet_574376(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsGet_574375(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574377 = path.getOrDefault("resourceGroupName")
  valid_574377 = validateParameter(valid_574377, JString, required = true,
                                 default = nil)
  if valid_574377 != nil:
    section.add "resourceGroupName", valid_574377
  var valid_574378 = path.getOrDefault("name")
  valid_574378 = validateParameter(valid_574378, JString, required = true,
                                 default = nil)
  if valid_574378 != nil:
    section.add "name", valid_574378
  var valid_574379 = path.getOrDefault("subscriptionId")
  valid_574379 = validateParameter(valid_574379, JString, required = true,
                                 default = nil)
  if valid_574379 != nil:
    section.add "subscriptionId", valid_574379
  var valid_574380 = path.getOrDefault("deviceName")
  valid_574380 = validateParameter(valid_574380, JString, required = true,
                                 default = nil)
  if valid_574380 != nil:
    section.add "deviceName", valid_574380
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574381 = query.getOrDefault("api-version")
  valid_574381 = validateParameter(valid_574381, JString, required = true,
                                 default = nil)
  if valid_574381 != nil:
    section.add "api-version", valid_574381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574382: Call_JobsGet_574374; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574382.validator(path, query, header, formData, body)
  let scheme = call_574382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574382.url(scheme.get, call_574382.host, call_574382.base,
                         call_574382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574382, url, valid)

proc call*(call_574383: Call_JobsGet_574374; resourceGroupName: string;
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
  var path_574384 = newJObject()
  var query_574385 = newJObject()
  add(path_574384, "resourceGroupName", newJString(resourceGroupName))
  add(query_574385, "api-version", newJString(apiVersion))
  add(path_574384, "name", newJString(name))
  add(path_574384, "subscriptionId", newJString(subscriptionId))
  add(path_574384, "deviceName", newJString(deviceName))
  result = call_574383.call(path_574384, query_574385, nil, nil, nil)

var jobsGet* = Call_JobsGet_574374(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/jobs/{name}",
                                validator: validate_JobsGet_574375, base: "",
                                url: url_JobsGet_574376, schemes: {Scheme.Https})
type
  Call_DevicesGetNetworkSettings_574386 = ref object of OpenApiRestCall_573667
proc url_DevicesGetNetworkSettings_574388(protocol: Scheme; host: string;
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

proc validate_DevicesGetNetworkSettings_574387(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the network settings of the specified Data Box Edge/Data Box Gateway device.
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
  var valid_574389 = path.getOrDefault("resourceGroupName")
  valid_574389 = validateParameter(valid_574389, JString, required = true,
                                 default = nil)
  if valid_574389 != nil:
    section.add "resourceGroupName", valid_574389
  var valid_574390 = path.getOrDefault("subscriptionId")
  valid_574390 = validateParameter(valid_574390, JString, required = true,
                                 default = nil)
  if valid_574390 != nil:
    section.add "subscriptionId", valid_574390
  var valid_574391 = path.getOrDefault("deviceName")
  valid_574391 = validateParameter(valid_574391, JString, required = true,
                                 default = nil)
  if valid_574391 != nil:
    section.add "deviceName", valid_574391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574392 = query.getOrDefault("api-version")
  valid_574392 = validateParameter(valid_574392, JString, required = true,
                                 default = nil)
  if valid_574392 != nil:
    section.add "api-version", valid_574392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574393: Call_DevicesGetNetworkSettings_574386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the network settings of the specified Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_574393.validator(path, query, header, formData, body)
  let scheme = call_574393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574393.url(scheme.get, call_574393.host, call_574393.base,
                         call_574393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574393, url, valid)

proc call*(call_574394: Call_DevicesGetNetworkSettings_574386;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## devicesGetNetworkSettings
  ## Gets the network settings of the specified Data Box Edge/Data Box Gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574395 = newJObject()
  var query_574396 = newJObject()
  add(path_574395, "resourceGroupName", newJString(resourceGroupName))
  add(query_574396, "api-version", newJString(apiVersion))
  add(path_574395, "subscriptionId", newJString(subscriptionId))
  add(path_574395, "deviceName", newJString(deviceName))
  result = call_574394.call(path_574395, query_574396, nil, nil, nil)

var devicesGetNetworkSettings* = Call_DevicesGetNetworkSettings_574386(
    name: "devicesGetNetworkSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/networkSettings/default",
    validator: validate_DevicesGetNetworkSettings_574387, base: "",
    url: url_DevicesGetNetworkSettings_574388, schemes: {Scheme.Https})
type
  Call_NodesListByDataBoxEdgeDevice_574397 = ref object of OpenApiRestCall_573667
proc url_NodesListByDataBoxEdgeDevice_574399(protocol: Scheme; host: string;
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

proc validate_NodesListByDataBoxEdgeDevice_574398(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the nodes currently configured under this Data Box Edge device
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
  var valid_574400 = path.getOrDefault("resourceGroupName")
  valid_574400 = validateParameter(valid_574400, JString, required = true,
                                 default = nil)
  if valid_574400 != nil:
    section.add "resourceGroupName", valid_574400
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

proc call*(call_574404: Call_NodesListByDataBoxEdgeDevice_574397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the nodes currently configured under this Data Box Edge device
  ## 
  let valid = call_574404.validator(path, query, header, formData, body)
  let scheme = call_574404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574404.url(scheme.get, call_574404.host, call_574404.base,
                         call_574404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574404, url, valid)

proc call*(call_574405: Call_NodesListByDataBoxEdgeDevice_574397;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## nodesListByDataBoxEdgeDevice
  ## Gets all the nodes currently configured under this Data Box Edge device
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574406 = newJObject()
  var query_574407 = newJObject()
  add(path_574406, "resourceGroupName", newJString(resourceGroupName))
  add(query_574407, "api-version", newJString(apiVersion))
  add(path_574406, "subscriptionId", newJString(subscriptionId))
  add(path_574406, "deviceName", newJString(deviceName))
  result = call_574405.call(path_574406, query_574407, nil, nil, nil)

var nodesListByDataBoxEdgeDevice* = Call_NodesListByDataBoxEdgeDevice_574397(
    name: "nodesListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/nodes",
    validator: validate_NodesListByDataBoxEdgeDevice_574398, base: "",
    url: url_NodesListByDataBoxEdgeDevice_574399, schemes: {Scheme.Https})
type
  Call_OperationsStatusGet_574408 = ref object of OpenApiRestCall_573667
proc url_OperationsStatusGet_574410(protocol: Scheme; host: string; base: string;
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

proc validate_OperationsStatusGet_574409(path: JsonNode; query: JsonNode;
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
  var valid_574411 = path.getOrDefault("resourceGroupName")
  valid_574411 = validateParameter(valid_574411, JString, required = true,
                                 default = nil)
  if valid_574411 != nil:
    section.add "resourceGroupName", valid_574411
  var valid_574412 = path.getOrDefault("name")
  valid_574412 = validateParameter(valid_574412, JString, required = true,
                                 default = nil)
  if valid_574412 != nil:
    section.add "name", valid_574412
  var valid_574413 = path.getOrDefault("subscriptionId")
  valid_574413 = validateParameter(valid_574413, JString, required = true,
                                 default = nil)
  if valid_574413 != nil:
    section.add "subscriptionId", valid_574413
  var valid_574414 = path.getOrDefault("deviceName")
  valid_574414 = validateParameter(valid_574414, JString, required = true,
                                 default = nil)
  if valid_574414 != nil:
    section.add "deviceName", valid_574414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574415 = query.getOrDefault("api-version")
  valid_574415 = validateParameter(valid_574415, JString, required = true,
                                 default = nil)
  if valid_574415 != nil:
    section.add "api-version", valid_574415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574416: Call_OperationsStatusGet_574408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574416.validator(path, query, header, formData, body)
  let scheme = call_574416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574416.url(scheme.get, call_574416.host, call_574416.base,
                         call_574416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574416, url, valid)

proc call*(call_574417: Call_OperationsStatusGet_574408; resourceGroupName: string;
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
  var path_574418 = newJObject()
  var query_574419 = newJObject()
  add(path_574418, "resourceGroupName", newJString(resourceGroupName))
  add(query_574419, "api-version", newJString(apiVersion))
  add(path_574418, "name", newJString(name))
  add(path_574418, "subscriptionId", newJString(subscriptionId))
  add(path_574418, "deviceName", newJString(deviceName))
  result = call_574417.call(path_574418, query_574419, nil, nil, nil)

var operationsStatusGet* = Call_OperationsStatusGet_574408(
    name: "operationsStatusGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/operationsStatus/{name}",
    validator: validate_OperationsStatusGet_574409, base: "",
    url: url_OperationsStatusGet_574410, schemes: {Scheme.Https})
type
  Call_OrdersListByDataBoxEdgeDevice_574420 = ref object of OpenApiRestCall_573667
proc url_OrdersListByDataBoxEdgeDevice_574422(protocol: Scheme; host: string;
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

proc validate_OrdersListByDataBoxEdgeDevice_574421(path: JsonNode; query: JsonNode;
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
  var valid_574423 = path.getOrDefault("resourceGroupName")
  valid_574423 = validateParameter(valid_574423, JString, required = true,
                                 default = nil)
  if valid_574423 != nil:
    section.add "resourceGroupName", valid_574423
  var valid_574424 = path.getOrDefault("subscriptionId")
  valid_574424 = validateParameter(valid_574424, JString, required = true,
                                 default = nil)
  if valid_574424 != nil:
    section.add "subscriptionId", valid_574424
  var valid_574425 = path.getOrDefault("deviceName")
  valid_574425 = validateParameter(valid_574425, JString, required = true,
                                 default = nil)
  if valid_574425 != nil:
    section.add "deviceName", valid_574425
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574426 = query.getOrDefault("api-version")
  valid_574426 = validateParameter(valid_574426, JString, required = true,
                                 default = nil)
  if valid_574426 != nil:
    section.add "api-version", valid_574426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574427: Call_OrdersListByDataBoxEdgeDevice_574420; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574427.validator(path, query, header, formData, body)
  let scheme = call_574427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574427.url(scheme.get, call_574427.host, call_574427.base,
                         call_574427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574427, url, valid)

proc call*(call_574428: Call_OrdersListByDataBoxEdgeDevice_574420;
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
  var path_574429 = newJObject()
  var query_574430 = newJObject()
  add(path_574429, "resourceGroupName", newJString(resourceGroupName))
  add(query_574430, "api-version", newJString(apiVersion))
  add(path_574429, "subscriptionId", newJString(subscriptionId))
  add(path_574429, "deviceName", newJString(deviceName))
  result = call_574428.call(path_574429, query_574430, nil, nil, nil)

var ordersListByDataBoxEdgeDevice* = Call_OrdersListByDataBoxEdgeDevice_574420(
    name: "ordersListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/orders",
    validator: validate_OrdersListByDataBoxEdgeDevice_574421, base: "",
    url: url_OrdersListByDataBoxEdgeDevice_574422, schemes: {Scheme.Https})
type
  Call_OrdersCreateOrUpdate_574442 = ref object of OpenApiRestCall_573667
proc url_OrdersCreateOrUpdate_574444(protocol: Scheme; host: string; base: string;
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

proc validate_OrdersCreateOrUpdate_574443(path: JsonNode; query: JsonNode;
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
  var valid_574445 = path.getOrDefault("resourceGroupName")
  valid_574445 = validateParameter(valid_574445, JString, required = true,
                                 default = nil)
  if valid_574445 != nil:
    section.add "resourceGroupName", valid_574445
  var valid_574446 = path.getOrDefault("subscriptionId")
  valid_574446 = validateParameter(valid_574446, JString, required = true,
                                 default = nil)
  if valid_574446 != nil:
    section.add "subscriptionId", valid_574446
  var valid_574447 = path.getOrDefault("deviceName")
  valid_574447 = validateParameter(valid_574447, JString, required = true,
                                 default = nil)
  if valid_574447 != nil:
    section.add "deviceName", valid_574447
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574448 = query.getOrDefault("api-version")
  valid_574448 = validateParameter(valid_574448, JString, required = true,
                                 default = nil)
  if valid_574448 != nil:
    section.add "api-version", valid_574448
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

proc call*(call_574450: Call_OrdersCreateOrUpdate_574442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574450.validator(path, query, header, formData, body)
  let scheme = call_574450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574450.url(scheme.get, call_574450.host, call_574450.base,
                         call_574450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574450, url, valid)

proc call*(call_574451: Call_OrdersCreateOrUpdate_574442;
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
  var path_574452 = newJObject()
  var query_574453 = newJObject()
  var body_574454 = newJObject()
  add(path_574452, "resourceGroupName", newJString(resourceGroupName))
  add(query_574453, "api-version", newJString(apiVersion))
  if order != nil:
    body_574454 = order
  add(path_574452, "subscriptionId", newJString(subscriptionId))
  add(path_574452, "deviceName", newJString(deviceName))
  result = call_574451.call(path_574452, query_574453, nil, nil, body_574454)

var ordersCreateOrUpdate* = Call_OrdersCreateOrUpdate_574442(
    name: "ordersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/orders/default",
    validator: validate_OrdersCreateOrUpdate_574443, base: "",
    url: url_OrdersCreateOrUpdate_574444, schemes: {Scheme.Https})
type
  Call_OrdersGet_574431 = ref object of OpenApiRestCall_573667
proc url_OrdersGet_574433(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_OrdersGet_574432(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574434 = path.getOrDefault("resourceGroupName")
  valid_574434 = validateParameter(valid_574434, JString, required = true,
                                 default = nil)
  if valid_574434 != nil:
    section.add "resourceGroupName", valid_574434
  var valid_574435 = path.getOrDefault("subscriptionId")
  valid_574435 = validateParameter(valid_574435, JString, required = true,
                                 default = nil)
  if valid_574435 != nil:
    section.add "subscriptionId", valid_574435
  var valid_574436 = path.getOrDefault("deviceName")
  valid_574436 = validateParameter(valid_574436, JString, required = true,
                                 default = nil)
  if valid_574436 != nil:
    section.add "deviceName", valid_574436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574437 = query.getOrDefault("api-version")
  valid_574437 = validateParameter(valid_574437, JString, required = true,
                                 default = nil)
  if valid_574437 != nil:
    section.add "api-version", valid_574437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574438: Call_OrdersGet_574431; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574438.validator(path, query, header, formData, body)
  let scheme = call_574438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574438.url(scheme.get, call_574438.host, call_574438.base,
                         call_574438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574438, url, valid)

proc call*(call_574439: Call_OrdersGet_574431; resourceGroupName: string;
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
  var path_574440 = newJObject()
  var query_574441 = newJObject()
  add(path_574440, "resourceGroupName", newJString(resourceGroupName))
  add(query_574441, "api-version", newJString(apiVersion))
  add(path_574440, "subscriptionId", newJString(subscriptionId))
  add(path_574440, "deviceName", newJString(deviceName))
  result = call_574439.call(path_574440, query_574441, nil, nil, nil)

var ordersGet* = Call_OrdersGet_574431(name: "ordersGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/orders/default",
                                    validator: validate_OrdersGet_574432,
                                    base: "", url: url_OrdersGet_574433,
                                    schemes: {Scheme.Https})
type
  Call_OrdersDelete_574455 = ref object of OpenApiRestCall_573667
proc url_OrdersDelete_574457(protocol: Scheme; host: string; base: string;
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

proc validate_OrdersDelete_574456(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574458 = path.getOrDefault("resourceGroupName")
  valid_574458 = validateParameter(valid_574458, JString, required = true,
                                 default = nil)
  if valid_574458 != nil:
    section.add "resourceGroupName", valid_574458
  var valid_574459 = path.getOrDefault("subscriptionId")
  valid_574459 = validateParameter(valid_574459, JString, required = true,
                                 default = nil)
  if valid_574459 != nil:
    section.add "subscriptionId", valid_574459
  var valid_574460 = path.getOrDefault("deviceName")
  valid_574460 = validateParameter(valid_574460, JString, required = true,
                                 default = nil)
  if valid_574460 != nil:
    section.add "deviceName", valid_574460
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574461 = query.getOrDefault("api-version")
  valid_574461 = validateParameter(valid_574461, JString, required = true,
                                 default = nil)
  if valid_574461 != nil:
    section.add "api-version", valid_574461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574462: Call_OrdersDelete_574455; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574462.validator(path, query, header, formData, body)
  let scheme = call_574462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574462.url(scheme.get, call_574462.host, call_574462.base,
                         call_574462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574462, url, valid)

proc call*(call_574463: Call_OrdersDelete_574455; resourceGroupName: string;
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
  var path_574464 = newJObject()
  var query_574465 = newJObject()
  add(path_574464, "resourceGroupName", newJString(resourceGroupName))
  add(query_574465, "api-version", newJString(apiVersion))
  add(path_574464, "subscriptionId", newJString(subscriptionId))
  add(path_574464, "deviceName", newJString(deviceName))
  result = call_574463.call(path_574464, query_574465, nil, nil, nil)

var ordersDelete* = Call_OrdersDelete_574455(name: "ordersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/orders/default",
    validator: validate_OrdersDelete_574456, base: "", url: url_OrdersDelete_574457,
    schemes: {Scheme.Https})
type
  Call_RolesListByDataBoxEdgeDevice_574466 = ref object of OpenApiRestCall_573667
proc url_RolesListByDataBoxEdgeDevice_574468(protocol: Scheme; host: string;
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

proc validate_RolesListByDataBoxEdgeDevice_574467(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the roles configured in a Data Box Edge/Data Box Gateway device.
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
  var valid_574469 = path.getOrDefault("resourceGroupName")
  valid_574469 = validateParameter(valid_574469, JString, required = true,
                                 default = nil)
  if valid_574469 != nil:
    section.add "resourceGroupName", valid_574469
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

proc call*(call_574473: Call_RolesListByDataBoxEdgeDevice_574466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the roles configured in a Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_574473.validator(path, query, header, formData, body)
  let scheme = call_574473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574473.url(scheme.get, call_574473.host, call_574473.base,
                         call_574473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574473, url, valid)

proc call*(call_574474: Call_RolesListByDataBoxEdgeDevice_574466;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## rolesListByDataBoxEdgeDevice
  ## Lists all the roles configured in a Data Box Edge/Data Box Gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574475 = newJObject()
  var query_574476 = newJObject()
  add(path_574475, "resourceGroupName", newJString(resourceGroupName))
  add(query_574476, "api-version", newJString(apiVersion))
  add(path_574475, "subscriptionId", newJString(subscriptionId))
  add(path_574475, "deviceName", newJString(deviceName))
  result = call_574474.call(path_574475, query_574476, nil, nil, nil)

var rolesListByDataBoxEdgeDevice* = Call_RolesListByDataBoxEdgeDevice_574466(
    name: "rolesListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/roles",
    validator: validate_RolesListByDataBoxEdgeDevice_574467, base: "",
    url: url_RolesListByDataBoxEdgeDevice_574468, schemes: {Scheme.Https})
type
  Call_RolesCreateOrUpdate_574489 = ref object of OpenApiRestCall_573667
proc url_RolesCreateOrUpdate_574491(protocol: Scheme; host: string; base: string;
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

proc validate_RolesCreateOrUpdate_574490(path: JsonNode; query: JsonNode;
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
  var valid_574492 = path.getOrDefault("resourceGroupName")
  valid_574492 = validateParameter(valid_574492, JString, required = true,
                                 default = nil)
  if valid_574492 != nil:
    section.add "resourceGroupName", valid_574492
  var valid_574493 = path.getOrDefault("name")
  valid_574493 = validateParameter(valid_574493, JString, required = true,
                                 default = nil)
  if valid_574493 != nil:
    section.add "name", valid_574493
  var valid_574494 = path.getOrDefault("subscriptionId")
  valid_574494 = validateParameter(valid_574494, JString, required = true,
                                 default = nil)
  if valid_574494 != nil:
    section.add "subscriptionId", valid_574494
  var valid_574495 = path.getOrDefault("deviceName")
  valid_574495 = validateParameter(valid_574495, JString, required = true,
                                 default = nil)
  if valid_574495 != nil:
    section.add "deviceName", valid_574495
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574496 = query.getOrDefault("api-version")
  valid_574496 = validateParameter(valid_574496, JString, required = true,
                                 default = nil)
  if valid_574496 != nil:
    section.add "api-version", valid_574496
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

proc call*(call_574498: Call_RolesCreateOrUpdate_574489; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a role.
  ## 
  let valid = call_574498.validator(path, query, header, formData, body)
  let scheme = call_574498.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574498.url(scheme.get, call_574498.host, call_574498.base,
                         call_574498.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574498, url, valid)

proc call*(call_574499: Call_RolesCreateOrUpdate_574489; resourceGroupName: string;
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
  var path_574500 = newJObject()
  var query_574501 = newJObject()
  var body_574502 = newJObject()
  add(path_574500, "resourceGroupName", newJString(resourceGroupName))
  add(query_574501, "api-version", newJString(apiVersion))
  add(path_574500, "name", newJString(name))
  add(path_574500, "subscriptionId", newJString(subscriptionId))
  if role != nil:
    body_574502 = role
  add(path_574500, "deviceName", newJString(deviceName))
  result = call_574499.call(path_574500, query_574501, nil, nil, body_574502)

var rolesCreateOrUpdate* = Call_RolesCreateOrUpdate_574489(
    name: "rolesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/roles/{name}",
    validator: validate_RolesCreateOrUpdate_574490, base: "",
    url: url_RolesCreateOrUpdate_574491, schemes: {Scheme.Https})
type
  Call_RolesGet_574477 = ref object of OpenApiRestCall_573667
proc url_RolesGet_574479(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_RolesGet_574478(path: JsonNode; query: JsonNode; header: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_574485: Call_RolesGet_574477; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific role by name.
  ## 
  let valid = call_574485.validator(path, query, header, formData, body)
  let scheme = call_574485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574485.url(scheme.get, call_574485.host, call_574485.base,
                         call_574485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574485, url, valid)

proc call*(call_574486: Call_RolesGet_574477; resourceGroupName: string;
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
  var path_574487 = newJObject()
  var query_574488 = newJObject()
  add(path_574487, "resourceGroupName", newJString(resourceGroupName))
  add(query_574488, "api-version", newJString(apiVersion))
  add(path_574487, "name", newJString(name))
  add(path_574487, "subscriptionId", newJString(subscriptionId))
  add(path_574487, "deviceName", newJString(deviceName))
  result = call_574486.call(path_574487, query_574488, nil, nil, nil)

var rolesGet* = Call_RolesGet_574477(name: "rolesGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/roles/{name}",
                                  validator: validate_RolesGet_574478, base: "",
                                  url: url_RolesGet_574479,
                                  schemes: {Scheme.Https})
type
  Call_RolesDelete_574503 = ref object of OpenApiRestCall_573667
proc url_RolesDelete_574505(protocol: Scheme; host: string; base: string;
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

proc validate_RolesDelete_574504(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the role on the device.
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
  var valid_574506 = path.getOrDefault("resourceGroupName")
  valid_574506 = validateParameter(valid_574506, JString, required = true,
                                 default = nil)
  if valid_574506 != nil:
    section.add "resourceGroupName", valid_574506
  var valid_574507 = path.getOrDefault("name")
  valid_574507 = validateParameter(valid_574507, JString, required = true,
                                 default = nil)
  if valid_574507 != nil:
    section.add "name", valid_574507
  var valid_574508 = path.getOrDefault("subscriptionId")
  valid_574508 = validateParameter(valid_574508, JString, required = true,
                                 default = nil)
  if valid_574508 != nil:
    section.add "subscriptionId", valid_574508
  var valid_574509 = path.getOrDefault("deviceName")
  valid_574509 = validateParameter(valid_574509, JString, required = true,
                                 default = nil)
  if valid_574509 != nil:
    section.add "deviceName", valid_574509
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574510 = query.getOrDefault("api-version")
  valid_574510 = validateParameter(valid_574510, JString, required = true,
                                 default = nil)
  if valid_574510 != nil:
    section.add "api-version", valid_574510
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574511: Call_RolesDelete_574503; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the role on the device.
  ## 
  let valid = call_574511.validator(path, query, header, formData, body)
  let scheme = call_574511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574511.url(scheme.get, call_574511.host, call_574511.base,
                         call_574511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574511, url, valid)

proc call*(call_574512: Call_RolesDelete_574503; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string; deviceName: string): Recallable =
  ## rolesDelete
  ## Deletes the role on the device.
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
  var path_574513 = newJObject()
  var query_574514 = newJObject()
  add(path_574513, "resourceGroupName", newJString(resourceGroupName))
  add(query_574514, "api-version", newJString(apiVersion))
  add(path_574513, "name", newJString(name))
  add(path_574513, "subscriptionId", newJString(subscriptionId))
  add(path_574513, "deviceName", newJString(deviceName))
  result = call_574512.call(path_574513, query_574514, nil, nil, nil)

var rolesDelete* = Call_RolesDelete_574503(name: "rolesDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/roles/{name}",
                                        validator: validate_RolesDelete_574504,
                                        base: "", url: url_RolesDelete_574505,
                                        schemes: {Scheme.Https})
type
  Call_DevicesScanForUpdates_574515 = ref object of OpenApiRestCall_573667
proc url_DevicesScanForUpdates_574517(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesScanForUpdates_574516(path: JsonNode; query: JsonNode;
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
  var valid_574518 = path.getOrDefault("resourceGroupName")
  valid_574518 = validateParameter(valid_574518, JString, required = true,
                                 default = nil)
  if valid_574518 != nil:
    section.add "resourceGroupName", valid_574518
  var valid_574519 = path.getOrDefault("subscriptionId")
  valid_574519 = validateParameter(valid_574519, JString, required = true,
                                 default = nil)
  if valid_574519 != nil:
    section.add "subscriptionId", valid_574519
  var valid_574520 = path.getOrDefault("deviceName")
  valid_574520 = validateParameter(valid_574520, JString, required = true,
                                 default = nil)
  if valid_574520 != nil:
    section.add "deviceName", valid_574520
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574521 = query.getOrDefault("api-version")
  valid_574521 = validateParameter(valid_574521, JString, required = true,
                                 default = nil)
  if valid_574521 != nil:
    section.add "api-version", valid_574521
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574522: Call_DevicesScanForUpdates_574515; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574522.validator(path, query, header, formData, body)
  let scheme = call_574522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574522.url(scheme.get, call_574522.host, call_574522.base,
                         call_574522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574522, url, valid)

proc call*(call_574523: Call_DevicesScanForUpdates_574515;
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
  var path_574524 = newJObject()
  var query_574525 = newJObject()
  add(path_574524, "resourceGroupName", newJString(resourceGroupName))
  add(query_574525, "api-version", newJString(apiVersion))
  add(path_574524, "subscriptionId", newJString(subscriptionId))
  add(path_574524, "deviceName", newJString(deviceName))
  result = call_574523.call(path_574524, query_574525, nil, nil, nil)

var devicesScanForUpdates* = Call_DevicesScanForUpdates_574515(
    name: "devicesScanForUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/scanForUpdates",
    validator: validate_DevicesScanForUpdates_574516, base: "",
    url: url_DevicesScanForUpdates_574517, schemes: {Scheme.Https})
type
  Call_DevicesCreateOrUpdateSecuritySettings_574526 = ref object of OpenApiRestCall_573667
proc url_DevicesCreateOrUpdateSecuritySettings_574528(protocol: Scheme;
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

proc validate_DevicesCreateOrUpdateSecuritySettings_574527(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the security settings on a Data Box Edge/Data Box Gateway device.
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
  var valid_574529 = path.getOrDefault("resourceGroupName")
  valid_574529 = validateParameter(valid_574529, JString, required = true,
                                 default = nil)
  if valid_574529 != nil:
    section.add "resourceGroupName", valid_574529
  var valid_574530 = path.getOrDefault("subscriptionId")
  valid_574530 = validateParameter(valid_574530, JString, required = true,
                                 default = nil)
  if valid_574530 != nil:
    section.add "subscriptionId", valid_574530
  var valid_574531 = path.getOrDefault("deviceName")
  valid_574531 = validateParameter(valid_574531, JString, required = true,
                                 default = nil)
  if valid_574531 != nil:
    section.add "deviceName", valid_574531
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574532 = query.getOrDefault("api-version")
  valid_574532 = validateParameter(valid_574532, JString, required = true,
                                 default = nil)
  if valid_574532 != nil:
    section.add "api-version", valid_574532
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

proc call*(call_574534: Call_DevicesCreateOrUpdateSecuritySettings_574526;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the security settings on a Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_574534.validator(path, query, header, formData, body)
  let scheme = call_574534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574534.url(scheme.get, call_574534.host, call_574534.base,
                         call_574534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574534, url, valid)

proc call*(call_574535: Call_DevicesCreateOrUpdateSecuritySettings_574526;
          resourceGroupName: string; apiVersion: string; securitySettings: JsonNode;
          subscriptionId: string; deviceName: string): Recallable =
  ## devicesCreateOrUpdateSecuritySettings
  ## Updates the security settings on a Data Box Edge/Data Box Gateway device.
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
  var path_574536 = newJObject()
  var query_574537 = newJObject()
  var body_574538 = newJObject()
  add(path_574536, "resourceGroupName", newJString(resourceGroupName))
  add(query_574537, "api-version", newJString(apiVersion))
  if securitySettings != nil:
    body_574538 = securitySettings
  add(path_574536, "subscriptionId", newJString(subscriptionId))
  add(path_574536, "deviceName", newJString(deviceName))
  result = call_574535.call(path_574536, query_574537, nil, nil, body_574538)

var devicesCreateOrUpdateSecuritySettings* = Call_DevicesCreateOrUpdateSecuritySettings_574526(
    name: "devicesCreateOrUpdateSecuritySettings", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/securitySettings/default/update",
    validator: validate_DevicesCreateOrUpdateSecuritySettings_574527, base: "",
    url: url_DevicesCreateOrUpdateSecuritySettings_574528, schemes: {Scheme.Https})
type
  Call_SharesListByDataBoxEdgeDevice_574539 = ref object of OpenApiRestCall_573667
proc url_SharesListByDataBoxEdgeDevice_574541(protocol: Scheme; host: string;
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

proc validate_SharesListByDataBoxEdgeDevice_574540(path: JsonNode; query: JsonNode;
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
  var valid_574542 = path.getOrDefault("resourceGroupName")
  valid_574542 = validateParameter(valid_574542, JString, required = true,
                                 default = nil)
  if valid_574542 != nil:
    section.add "resourceGroupName", valid_574542
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

proc call*(call_574546: Call_SharesListByDataBoxEdgeDevice_574539; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574546.validator(path, query, header, formData, body)
  let scheme = call_574546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574546.url(scheme.get, call_574546.host, call_574546.base,
                         call_574546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574546, url, valid)

proc call*(call_574547: Call_SharesListByDataBoxEdgeDevice_574539;
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
  var path_574548 = newJObject()
  var query_574549 = newJObject()
  add(path_574548, "resourceGroupName", newJString(resourceGroupName))
  add(query_574549, "api-version", newJString(apiVersion))
  add(path_574548, "subscriptionId", newJString(subscriptionId))
  add(path_574548, "deviceName", newJString(deviceName))
  result = call_574547.call(path_574548, query_574549, nil, nil, nil)

var sharesListByDataBoxEdgeDevice* = Call_SharesListByDataBoxEdgeDevice_574539(
    name: "sharesListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares",
    validator: validate_SharesListByDataBoxEdgeDevice_574540, base: "",
    url: url_SharesListByDataBoxEdgeDevice_574541, schemes: {Scheme.Https})
type
  Call_SharesCreateOrUpdate_574562 = ref object of OpenApiRestCall_573667
proc url_SharesCreateOrUpdate_574564(protocol: Scheme; host: string; base: string;
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

proc validate_SharesCreateOrUpdate_574563(path: JsonNode; query: JsonNode;
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
  var valid_574565 = path.getOrDefault("resourceGroupName")
  valid_574565 = validateParameter(valid_574565, JString, required = true,
                                 default = nil)
  if valid_574565 != nil:
    section.add "resourceGroupName", valid_574565
  var valid_574566 = path.getOrDefault("name")
  valid_574566 = validateParameter(valid_574566, JString, required = true,
                                 default = nil)
  if valid_574566 != nil:
    section.add "name", valid_574566
  var valid_574567 = path.getOrDefault("subscriptionId")
  valid_574567 = validateParameter(valid_574567, JString, required = true,
                                 default = nil)
  if valid_574567 != nil:
    section.add "subscriptionId", valid_574567
  var valid_574568 = path.getOrDefault("deviceName")
  valid_574568 = validateParameter(valid_574568, JString, required = true,
                                 default = nil)
  if valid_574568 != nil:
    section.add "deviceName", valid_574568
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574569 = query.getOrDefault("api-version")
  valid_574569 = validateParameter(valid_574569, JString, required = true,
                                 default = nil)
  if valid_574569 != nil:
    section.add "api-version", valid_574569
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

proc call*(call_574571: Call_SharesCreateOrUpdate_574562; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574571.validator(path, query, header, formData, body)
  let scheme = call_574571.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574571.url(scheme.get, call_574571.host, call_574571.base,
                         call_574571.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574571, url, valid)

proc call*(call_574572: Call_SharesCreateOrUpdate_574562;
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
  var path_574573 = newJObject()
  var query_574574 = newJObject()
  var body_574575 = newJObject()
  add(path_574573, "resourceGroupName", newJString(resourceGroupName))
  add(query_574574, "api-version", newJString(apiVersion))
  add(path_574573, "name", newJString(name))
  add(path_574573, "subscriptionId", newJString(subscriptionId))
  if share != nil:
    body_574575 = share
  add(path_574573, "deviceName", newJString(deviceName))
  result = call_574572.call(path_574573, query_574574, nil, nil, body_574575)

var sharesCreateOrUpdate* = Call_SharesCreateOrUpdate_574562(
    name: "sharesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares/{name}",
    validator: validate_SharesCreateOrUpdate_574563, base: "",
    url: url_SharesCreateOrUpdate_574564, schemes: {Scheme.Https})
type
  Call_SharesGet_574550 = ref object of OpenApiRestCall_573667
proc url_SharesGet_574552(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SharesGet_574551(path: JsonNode; query: JsonNode; header: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_574558: Call_SharesGet_574550; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574558.validator(path, query, header, formData, body)
  let scheme = call_574558.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574558.url(scheme.get, call_574558.host, call_574558.base,
                         call_574558.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574558, url, valid)

proc call*(call_574559: Call_SharesGet_574550; resourceGroupName: string;
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
  var path_574560 = newJObject()
  var query_574561 = newJObject()
  add(path_574560, "resourceGroupName", newJString(resourceGroupName))
  add(query_574561, "api-version", newJString(apiVersion))
  add(path_574560, "name", newJString(name))
  add(path_574560, "subscriptionId", newJString(subscriptionId))
  add(path_574560, "deviceName", newJString(deviceName))
  result = call_574559.call(path_574560, query_574561, nil, nil, nil)

var sharesGet* = Call_SharesGet_574550(name: "sharesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares/{name}",
                                    validator: validate_SharesGet_574551,
                                    base: "", url: url_SharesGet_574552,
                                    schemes: {Scheme.Https})
type
  Call_SharesDelete_574576 = ref object of OpenApiRestCall_573667
proc url_SharesDelete_574578(protocol: Scheme; host: string; base: string;
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

proc validate_SharesDelete_574577(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the share on the Data Box Edge/Data Box Gateway device.
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

proc call*(call_574584: Call_SharesDelete_574576; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the share on the Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_574584.validator(path, query, header, formData, body)
  let scheme = call_574584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574584.url(scheme.get, call_574584.host, call_574584.base,
                         call_574584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574584, url, valid)

proc call*(call_574585: Call_SharesDelete_574576; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string; deviceName: string): Recallable =
  ## sharesDelete
  ## Deletes the share on the Data Box Edge/Data Box Gateway device.
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

var sharesDelete* = Call_SharesDelete_574576(name: "sharesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares/{name}",
    validator: validate_SharesDelete_574577, base: "", url: url_SharesDelete_574578,
    schemes: {Scheme.Https})
type
  Call_SharesRefresh_574588 = ref object of OpenApiRestCall_573667
proc url_SharesRefresh_574590(protocol: Scheme; host: string; base: string;
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

proc validate_SharesRefresh_574589(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574591 = path.getOrDefault("resourceGroupName")
  valid_574591 = validateParameter(valid_574591, JString, required = true,
                                 default = nil)
  if valid_574591 != nil:
    section.add "resourceGroupName", valid_574591
  var valid_574592 = path.getOrDefault("name")
  valid_574592 = validateParameter(valid_574592, JString, required = true,
                                 default = nil)
  if valid_574592 != nil:
    section.add "name", valid_574592
  var valid_574593 = path.getOrDefault("subscriptionId")
  valid_574593 = validateParameter(valid_574593, JString, required = true,
                                 default = nil)
  if valid_574593 != nil:
    section.add "subscriptionId", valid_574593
  var valid_574594 = path.getOrDefault("deviceName")
  valid_574594 = validateParameter(valid_574594, JString, required = true,
                                 default = nil)
  if valid_574594 != nil:
    section.add "deviceName", valid_574594
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574595 = query.getOrDefault("api-version")
  valid_574595 = validateParameter(valid_574595, JString, required = true,
                                 default = nil)
  if valid_574595 != nil:
    section.add "api-version", valid_574595
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574596: Call_SharesRefresh_574588; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574596.validator(path, query, header, formData, body)
  let scheme = call_574596.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574596.url(scheme.get, call_574596.host, call_574596.base,
                         call_574596.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574596, url, valid)

proc call*(call_574597: Call_SharesRefresh_574588; resourceGroupName: string;
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
  var path_574598 = newJObject()
  var query_574599 = newJObject()
  add(path_574598, "resourceGroupName", newJString(resourceGroupName))
  add(query_574599, "api-version", newJString(apiVersion))
  add(path_574598, "name", newJString(name))
  add(path_574598, "subscriptionId", newJString(subscriptionId))
  add(path_574598, "deviceName", newJString(deviceName))
  result = call_574597.call(path_574598, query_574599, nil, nil, nil)

var sharesRefresh* = Call_SharesRefresh_574588(name: "sharesRefresh",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares/{name}/refresh",
    validator: validate_SharesRefresh_574589, base: "", url: url_SharesRefresh_574590,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsListByDataBoxEdgeDevice_574600 = ref object of OpenApiRestCall_573667
proc url_StorageAccountCredentialsListByDataBoxEdgeDevice_574602(
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

proc validate_StorageAccountCredentialsListByDataBoxEdgeDevice_574601(
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
  var valid_574603 = path.getOrDefault("resourceGroupName")
  valid_574603 = validateParameter(valid_574603, JString, required = true,
                                 default = nil)
  if valid_574603 != nil:
    section.add "resourceGroupName", valid_574603
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

proc call*(call_574607: Call_StorageAccountCredentialsListByDataBoxEdgeDevice_574600;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_574607.validator(path, query, header, formData, body)
  let scheme = call_574607.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574607.url(scheme.get, call_574607.host, call_574607.base,
                         call_574607.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574607, url, valid)

proc call*(call_574608: Call_StorageAccountCredentialsListByDataBoxEdgeDevice_574600;
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
  var path_574609 = newJObject()
  var query_574610 = newJObject()
  add(path_574609, "resourceGroupName", newJString(resourceGroupName))
  add(query_574610, "api-version", newJString(apiVersion))
  add(path_574609, "subscriptionId", newJString(subscriptionId))
  add(path_574609, "deviceName", newJString(deviceName))
  result = call_574608.call(path_574609, query_574610, nil, nil, nil)

var storageAccountCredentialsListByDataBoxEdgeDevice* = Call_StorageAccountCredentialsListByDataBoxEdgeDevice_574600(
    name: "storageAccountCredentialsListByDataBoxEdgeDevice",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/storageAccountCredentials",
    validator: validate_StorageAccountCredentialsListByDataBoxEdgeDevice_574601,
    base: "", url: url_StorageAccountCredentialsListByDataBoxEdgeDevice_574602,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsCreateOrUpdate_574623 = ref object of OpenApiRestCall_573667
proc url_StorageAccountCredentialsCreateOrUpdate_574625(protocol: Scheme;
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

proc validate_StorageAccountCredentialsCreateOrUpdate_574624(path: JsonNode;
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
  var valid_574626 = path.getOrDefault("resourceGroupName")
  valid_574626 = validateParameter(valid_574626, JString, required = true,
                                 default = nil)
  if valid_574626 != nil:
    section.add "resourceGroupName", valid_574626
  var valid_574627 = path.getOrDefault("name")
  valid_574627 = validateParameter(valid_574627, JString, required = true,
                                 default = nil)
  if valid_574627 != nil:
    section.add "name", valid_574627
  var valid_574628 = path.getOrDefault("subscriptionId")
  valid_574628 = validateParameter(valid_574628, JString, required = true,
                                 default = nil)
  if valid_574628 != nil:
    section.add "subscriptionId", valid_574628
  var valid_574629 = path.getOrDefault("deviceName")
  valid_574629 = validateParameter(valid_574629, JString, required = true,
                                 default = nil)
  if valid_574629 != nil:
    section.add "deviceName", valid_574629
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574630 = query.getOrDefault("api-version")
  valid_574630 = validateParameter(valid_574630, JString, required = true,
                                 default = nil)
  if valid_574630 != nil:
    section.add "api-version", valid_574630
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

proc call*(call_574632: Call_StorageAccountCredentialsCreateOrUpdate_574623;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the storage account credential.
  ## 
  let valid = call_574632.validator(path, query, header, formData, body)
  let scheme = call_574632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574632.url(scheme.get, call_574632.host, call_574632.base,
                         call_574632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574632, url, valid)

proc call*(call_574633: Call_StorageAccountCredentialsCreateOrUpdate_574623;
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
  var path_574634 = newJObject()
  var query_574635 = newJObject()
  var body_574636 = newJObject()
  add(path_574634, "resourceGroupName", newJString(resourceGroupName))
  add(query_574635, "api-version", newJString(apiVersion))
  add(path_574634, "name", newJString(name))
  add(path_574634, "subscriptionId", newJString(subscriptionId))
  if storageAccountCredential != nil:
    body_574636 = storageAccountCredential
  add(path_574634, "deviceName", newJString(deviceName))
  result = call_574633.call(path_574634, query_574635, nil, nil, body_574636)

var storageAccountCredentialsCreateOrUpdate* = Call_StorageAccountCredentialsCreateOrUpdate_574623(
    name: "storageAccountCredentialsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/storageAccountCredentials/{name}",
    validator: validate_StorageAccountCredentialsCreateOrUpdate_574624, base: "",
    url: url_StorageAccountCredentialsCreateOrUpdate_574625,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsGet_574611 = ref object of OpenApiRestCall_573667
proc url_StorageAccountCredentialsGet_574613(protocol: Scheme; host: string;
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

proc validate_StorageAccountCredentialsGet_574612(path: JsonNode; query: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_574619: Call_StorageAccountCredentialsGet_574611; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified storage account credential.
  ## 
  let valid = call_574619.validator(path, query, header, formData, body)
  let scheme = call_574619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574619.url(scheme.get, call_574619.host, call_574619.base,
                         call_574619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574619, url, valid)

proc call*(call_574620: Call_StorageAccountCredentialsGet_574611;
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
  var path_574621 = newJObject()
  var query_574622 = newJObject()
  add(path_574621, "resourceGroupName", newJString(resourceGroupName))
  add(query_574622, "api-version", newJString(apiVersion))
  add(path_574621, "name", newJString(name))
  add(path_574621, "subscriptionId", newJString(subscriptionId))
  add(path_574621, "deviceName", newJString(deviceName))
  result = call_574620.call(path_574621, query_574622, nil, nil, nil)

var storageAccountCredentialsGet* = Call_StorageAccountCredentialsGet_574611(
    name: "storageAccountCredentialsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/storageAccountCredentials/{name}",
    validator: validate_StorageAccountCredentialsGet_574612, base: "",
    url: url_StorageAccountCredentialsGet_574613, schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsDelete_574637 = ref object of OpenApiRestCall_573667
proc url_StorageAccountCredentialsDelete_574639(protocol: Scheme; host: string;
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

proc validate_StorageAccountCredentialsDelete_574638(path: JsonNode;
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
  var valid_574640 = path.getOrDefault("resourceGroupName")
  valid_574640 = validateParameter(valid_574640, JString, required = true,
                                 default = nil)
  if valid_574640 != nil:
    section.add "resourceGroupName", valid_574640
  var valid_574641 = path.getOrDefault("name")
  valid_574641 = validateParameter(valid_574641, JString, required = true,
                                 default = nil)
  if valid_574641 != nil:
    section.add "name", valid_574641
  var valid_574642 = path.getOrDefault("subscriptionId")
  valid_574642 = validateParameter(valid_574642, JString, required = true,
                                 default = nil)
  if valid_574642 != nil:
    section.add "subscriptionId", valid_574642
  var valid_574643 = path.getOrDefault("deviceName")
  valid_574643 = validateParameter(valid_574643, JString, required = true,
                                 default = nil)
  if valid_574643 != nil:
    section.add "deviceName", valid_574643
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574644 = query.getOrDefault("api-version")
  valid_574644 = validateParameter(valid_574644, JString, required = true,
                                 default = nil)
  if valid_574644 != nil:
    section.add "api-version", valid_574644
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574645: Call_StorageAccountCredentialsDelete_574637;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the storage account credential.
  ## 
  let valid = call_574645.validator(path, query, header, formData, body)
  let scheme = call_574645.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574645.url(scheme.get, call_574645.host, call_574645.base,
                         call_574645.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574645, url, valid)

proc call*(call_574646: Call_StorageAccountCredentialsDelete_574637;
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
  var path_574647 = newJObject()
  var query_574648 = newJObject()
  add(path_574647, "resourceGroupName", newJString(resourceGroupName))
  add(query_574648, "api-version", newJString(apiVersion))
  add(path_574647, "name", newJString(name))
  add(path_574647, "subscriptionId", newJString(subscriptionId))
  add(path_574647, "deviceName", newJString(deviceName))
  result = call_574646.call(path_574647, query_574648, nil, nil, nil)

var storageAccountCredentialsDelete* = Call_StorageAccountCredentialsDelete_574637(
    name: "storageAccountCredentialsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/storageAccountCredentials/{name}",
    validator: validate_StorageAccountCredentialsDelete_574638, base: "",
    url: url_StorageAccountCredentialsDelete_574639, schemes: {Scheme.Https})
type
  Call_TriggersListByDataBoxEdgeDevice_574649 = ref object of OpenApiRestCall_573667
proc url_TriggersListByDataBoxEdgeDevice_574651(protocol: Scheme; host: string;
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

proc validate_TriggersListByDataBoxEdgeDevice_574650(path: JsonNode;
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
  var valid_574652 = path.getOrDefault("resourceGroupName")
  valid_574652 = validateParameter(valid_574652, JString, required = true,
                                 default = nil)
  if valid_574652 != nil:
    section.add "resourceGroupName", valid_574652
  var valid_574653 = path.getOrDefault("subscriptionId")
  valid_574653 = validateParameter(valid_574653, JString, required = true,
                                 default = nil)
  if valid_574653 != nil:
    section.add "subscriptionId", valid_574653
  var valid_574654 = path.getOrDefault("deviceName")
  valid_574654 = validateParameter(valid_574654, JString, required = true,
                                 default = nil)
  if valid_574654 != nil:
    section.add "deviceName", valid_574654
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $expand: JString
  ##          : Specify $filter='CustomContextTag eq <tag>' to filter on custom context tag property
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574655 = query.getOrDefault("api-version")
  valid_574655 = validateParameter(valid_574655, JString, required = true,
                                 default = nil)
  if valid_574655 != nil:
    section.add "api-version", valid_574655
  var valid_574656 = query.getOrDefault("$expand")
  valid_574656 = validateParameter(valid_574656, JString, required = false,
                                 default = nil)
  if valid_574656 != nil:
    section.add "$expand", valid_574656
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574657: Call_TriggersListByDataBoxEdgeDevice_574649;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the triggers configured in the device.
  ## 
  let valid = call_574657.validator(path, query, header, formData, body)
  let scheme = call_574657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574657.url(scheme.get, call_574657.host, call_574657.base,
                         call_574657.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574657, url, valid)

proc call*(call_574658: Call_TriggersListByDataBoxEdgeDevice_574649;
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
  var path_574659 = newJObject()
  var query_574660 = newJObject()
  add(path_574659, "resourceGroupName", newJString(resourceGroupName))
  add(query_574660, "api-version", newJString(apiVersion))
  add(query_574660, "$expand", newJString(Expand))
  add(path_574659, "subscriptionId", newJString(subscriptionId))
  add(path_574659, "deviceName", newJString(deviceName))
  result = call_574658.call(path_574659, query_574660, nil, nil, nil)

var triggersListByDataBoxEdgeDevice* = Call_TriggersListByDataBoxEdgeDevice_574649(
    name: "triggersListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/triggers",
    validator: validate_TriggersListByDataBoxEdgeDevice_574650, base: "",
    url: url_TriggersListByDataBoxEdgeDevice_574651, schemes: {Scheme.Https})
type
  Call_TriggersCreateOrUpdate_574673 = ref object of OpenApiRestCall_573667
proc url_TriggersCreateOrUpdate_574675(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersCreateOrUpdate_574674(path: JsonNode; query: JsonNode;
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
  var valid_574676 = path.getOrDefault("resourceGroupName")
  valid_574676 = validateParameter(valid_574676, JString, required = true,
                                 default = nil)
  if valid_574676 != nil:
    section.add "resourceGroupName", valid_574676
  var valid_574677 = path.getOrDefault("name")
  valid_574677 = validateParameter(valid_574677, JString, required = true,
                                 default = nil)
  if valid_574677 != nil:
    section.add "name", valid_574677
  var valid_574678 = path.getOrDefault("subscriptionId")
  valid_574678 = validateParameter(valid_574678, JString, required = true,
                                 default = nil)
  if valid_574678 != nil:
    section.add "subscriptionId", valid_574678
  var valid_574679 = path.getOrDefault("deviceName")
  valid_574679 = validateParameter(valid_574679, JString, required = true,
                                 default = nil)
  if valid_574679 != nil:
    section.add "deviceName", valid_574679
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574680 = query.getOrDefault("api-version")
  valid_574680 = validateParameter(valid_574680, JString, required = true,
                                 default = nil)
  if valid_574680 != nil:
    section.add "api-version", valid_574680
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

proc call*(call_574682: Call_TriggersCreateOrUpdate_574673; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a trigger.
  ## 
  let valid = call_574682.validator(path, query, header, formData, body)
  let scheme = call_574682.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574682.url(scheme.get, call_574682.host, call_574682.base,
                         call_574682.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574682, url, valid)

proc call*(call_574683: Call_TriggersCreateOrUpdate_574673;
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
  var path_574684 = newJObject()
  var query_574685 = newJObject()
  var body_574686 = newJObject()
  add(path_574684, "resourceGroupName", newJString(resourceGroupName))
  add(query_574685, "api-version", newJString(apiVersion))
  add(path_574684, "name", newJString(name))
  add(path_574684, "subscriptionId", newJString(subscriptionId))
  if trigger != nil:
    body_574686 = trigger
  add(path_574684, "deviceName", newJString(deviceName))
  result = call_574683.call(path_574684, query_574685, nil, nil, body_574686)

var triggersCreateOrUpdate* = Call_TriggersCreateOrUpdate_574673(
    name: "triggersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/triggers/{name}",
    validator: validate_TriggersCreateOrUpdate_574674, base: "",
    url: url_TriggersCreateOrUpdate_574675, schemes: {Scheme.Https})
type
  Call_TriggersGet_574661 = ref object of OpenApiRestCall_573667
proc url_TriggersGet_574663(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersGet_574662(path: JsonNode; query: JsonNode; header: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_574669: Call_TriggersGet_574661; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific trigger by name.
  ## 
  let valid = call_574669.validator(path, query, header, formData, body)
  let scheme = call_574669.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574669.url(scheme.get, call_574669.host, call_574669.base,
                         call_574669.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574669, url, valid)

proc call*(call_574670: Call_TriggersGet_574661; resourceGroupName: string;
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
  var path_574671 = newJObject()
  var query_574672 = newJObject()
  add(path_574671, "resourceGroupName", newJString(resourceGroupName))
  add(query_574672, "api-version", newJString(apiVersion))
  add(path_574671, "name", newJString(name))
  add(path_574671, "subscriptionId", newJString(subscriptionId))
  add(path_574671, "deviceName", newJString(deviceName))
  result = call_574670.call(path_574671, query_574672, nil, nil, nil)

var triggersGet* = Call_TriggersGet_574661(name: "triggersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/triggers/{name}",
                                        validator: validate_TriggersGet_574662,
                                        base: "", url: url_TriggersGet_574663,
                                        schemes: {Scheme.Https})
type
  Call_TriggersDelete_574687 = ref object of OpenApiRestCall_573667
proc url_TriggersDelete_574689(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersDelete_574688(path: JsonNode; query: JsonNode;
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
  var valid_574690 = path.getOrDefault("resourceGroupName")
  valid_574690 = validateParameter(valid_574690, JString, required = true,
                                 default = nil)
  if valid_574690 != nil:
    section.add "resourceGroupName", valid_574690
  var valid_574691 = path.getOrDefault("name")
  valid_574691 = validateParameter(valid_574691, JString, required = true,
                                 default = nil)
  if valid_574691 != nil:
    section.add "name", valid_574691
  var valid_574692 = path.getOrDefault("subscriptionId")
  valid_574692 = validateParameter(valid_574692, JString, required = true,
                                 default = nil)
  if valid_574692 != nil:
    section.add "subscriptionId", valid_574692
  var valid_574693 = path.getOrDefault("deviceName")
  valid_574693 = validateParameter(valid_574693, JString, required = true,
                                 default = nil)
  if valid_574693 != nil:
    section.add "deviceName", valid_574693
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574694 = query.getOrDefault("api-version")
  valid_574694 = validateParameter(valid_574694, JString, required = true,
                                 default = nil)
  if valid_574694 != nil:
    section.add "api-version", valid_574694
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574695: Call_TriggersDelete_574687; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the trigger on the gateway device.
  ## 
  let valid = call_574695.validator(path, query, header, formData, body)
  let scheme = call_574695.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574695.url(scheme.get, call_574695.host, call_574695.base,
                         call_574695.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574695, url, valid)

proc call*(call_574696: Call_TriggersDelete_574687; resourceGroupName: string;
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
  var path_574697 = newJObject()
  var query_574698 = newJObject()
  add(path_574697, "resourceGroupName", newJString(resourceGroupName))
  add(query_574698, "api-version", newJString(apiVersion))
  add(path_574697, "name", newJString(name))
  add(path_574697, "subscriptionId", newJString(subscriptionId))
  add(path_574697, "deviceName", newJString(deviceName))
  result = call_574696.call(path_574697, query_574698, nil, nil, nil)

var triggersDelete* = Call_TriggersDelete_574687(name: "triggersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/triggers/{name}",
    validator: validate_TriggersDelete_574688, base: "", url: url_TriggersDelete_574689,
    schemes: {Scheme.Https})
type
  Call_DevicesGetUpdateSummary_574699 = ref object of OpenApiRestCall_573667
proc url_DevicesGetUpdateSummary_574701(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesGetUpdateSummary_574700(path: JsonNode; query: JsonNode;
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
  var valid_574702 = path.getOrDefault("resourceGroupName")
  valid_574702 = validateParameter(valid_574702, JString, required = true,
                                 default = nil)
  if valid_574702 != nil:
    section.add "resourceGroupName", valid_574702
  var valid_574703 = path.getOrDefault("subscriptionId")
  valid_574703 = validateParameter(valid_574703, JString, required = true,
                                 default = nil)
  if valid_574703 != nil:
    section.add "subscriptionId", valid_574703
  var valid_574704 = path.getOrDefault("deviceName")
  valid_574704 = validateParameter(valid_574704, JString, required = true,
                                 default = nil)
  if valid_574704 != nil:
    section.add "deviceName", valid_574704
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574705 = query.getOrDefault("api-version")
  valid_574705 = validateParameter(valid_574705, JString, required = true,
                                 default = nil)
  if valid_574705 != nil:
    section.add "api-version", valid_574705
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574706: Call_DevicesGetUpdateSummary_574699; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574706.validator(path, query, header, formData, body)
  let scheme = call_574706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574706.url(scheme.get, call_574706.host, call_574706.base,
                         call_574706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574706, url, valid)

proc call*(call_574707: Call_DevicesGetUpdateSummary_574699;
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
  var path_574708 = newJObject()
  var query_574709 = newJObject()
  add(path_574708, "resourceGroupName", newJString(resourceGroupName))
  add(query_574709, "api-version", newJString(apiVersion))
  add(path_574708, "subscriptionId", newJString(subscriptionId))
  add(path_574708, "deviceName", newJString(deviceName))
  result = call_574707.call(path_574708, query_574709, nil, nil, nil)

var devicesGetUpdateSummary* = Call_DevicesGetUpdateSummary_574699(
    name: "devicesGetUpdateSummary", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/updateSummary/default",
    validator: validate_DevicesGetUpdateSummary_574700, base: "",
    url: url_DevicesGetUpdateSummary_574701, schemes: {Scheme.Https})
type
  Call_DevicesUploadCertificate_574710 = ref object of OpenApiRestCall_573667
proc url_DevicesUploadCertificate_574712(protocol: Scheme; host: string;
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

proc validate_DevicesUploadCertificate_574711(path: JsonNode; query: JsonNode;
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
  var valid_574713 = path.getOrDefault("resourceGroupName")
  valid_574713 = validateParameter(valid_574713, JString, required = true,
                                 default = nil)
  if valid_574713 != nil:
    section.add "resourceGroupName", valid_574713
  var valid_574714 = path.getOrDefault("subscriptionId")
  valid_574714 = validateParameter(valid_574714, JString, required = true,
                                 default = nil)
  if valid_574714 != nil:
    section.add "subscriptionId", valid_574714
  var valid_574715 = path.getOrDefault("deviceName")
  valid_574715 = validateParameter(valid_574715, JString, required = true,
                                 default = nil)
  if valid_574715 != nil:
    section.add "deviceName", valid_574715
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574716 = query.getOrDefault("api-version")
  valid_574716 = validateParameter(valid_574716, JString, required = true,
                                 default = nil)
  if valid_574716 != nil:
    section.add "api-version", valid_574716
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

proc call*(call_574718: Call_DevicesUploadCertificate_574710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads registration certificate for the device.
  ## 
  let valid = call_574718.validator(path, query, header, formData, body)
  let scheme = call_574718.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574718.url(scheme.get, call_574718.host, call_574718.base,
                         call_574718.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574718, url, valid)

proc call*(call_574719: Call_DevicesUploadCertificate_574710;
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
  var path_574720 = newJObject()
  var query_574721 = newJObject()
  var body_574722 = newJObject()
  add(path_574720, "resourceGroupName", newJString(resourceGroupName))
  add(query_574721, "api-version", newJString(apiVersion))
  add(path_574720, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574722 = parameters
  add(path_574720, "deviceName", newJString(deviceName))
  result = call_574719.call(path_574720, query_574721, nil, nil, body_574722)

var devicesUploadCertificate* = Call_DevicesUploadCertificate_574710(
    name: "devicesUploadCertificate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/uploadCertificate",
    validator: validate_DevicesUploadCertificate_574711, base: "",
    url: url_DevicesUploadCertificate_574712, schemes: {Scheme.Https})
type
  Call_UsersListByDataBoxEdgeDevice_574723 = ref object of OpenApiRestCall_573667
proc url_UsersListByDataBoxEdgeDevice_574725(protocol: Scheme; host: string;
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

proc validate_UsersListByDataBoxEdgeDevice_574724(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the users registered on a Data Box Edge/Data Box Gateway device.
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
  var valid_574726 = path.getOrDefault("resourceGroupName")
  valid_574726 = validateParameter(valid_574726, JString, required = true,
                                 default = nil)
  if valid_574726 != nil:
    section.add "resourceGroupName", valid_574726
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

proc call*(call_574730: Call_UsersListByDataBoxEdgeDevice_574723; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the users registered on a Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_574730.validator(path, query, header, formData, body)
  let scheme = call_574730.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574730.url(scheme.get, call_574730.host, call_574730.base,
                         call_574730.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574730, url, valid)

proc call*(call_574731: Call_UsersListByDataBoxEdgeDevice_574723;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## usersListByDataBoxEdgeDevice
  ## Gets all the users registered on a Data Box Edge/Data Box Gateway device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_574732 = newJObject()
  var query_574733 = newJObject()
  add(path_574732, "resourceGroupName", newJString(resourceGroupName))
  add(query_574733, "api-version", newJString(apiVersion))
  add(path_574732, "subscriptionId", newJString(subscriptionId))
  add(path_574732, "deviceName", newJString(deviceName))
  result = call_574731.call(path_574732, query_574733, nil, nil, nil)

var usersListByDataBoxEdgeDevice* = Call_UsersListByDataBoxEdgeDevice_574723(
    name: "usersListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/users",
    validator: validate_UsersListByDataBoxEdgeDevice_574724, base: "",
    url: url_UsersListByDataBoxEdgeDevice_574725, schemes: {Scheme.Https})
type
  Call_UsersCreateOrUpdate_574746 = ref object of OpenApiRestCall_573667
proc url_UsersCreateOrUpdate_574748(protocol: Scheme; host: string; base: string;
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

proc validate_UsersCreateOrUpdate_574747(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a new user or updates an existing user's information on a Data Box Edge/Data Box Gateway device.
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
  var valid_574749 = path.getOrDefault("resourceGroupName")
  valid_574749 = validateParameter(valid_574749, JString, required = true,
                                 default = nil)
  if valid_574749 != nil:
    section.add "resourceGroupName", valid_574749
  var valid_574750 = path.getOrDefault("name")
  valid_574750 = validateParameter(valid_574750, JString, required = true,
                                 default = nil)
  if valid_574750 != nil:
    section.add "name", valid_574750
  var valid_574751 = path.getOrDefault("subscriptionId")
  valid_574751 = validateParameter(valid_574751, JString, required = true,
                                 default = nil)
  if valid_574751 != nil:
    section.add "subscriptionId", valid_574751
  var valid_574752 = path.getOrDefault("deviceName")
  valid_574752 = validateParameter(valid_574752, JString, required = true,
                                 default = nil)
  if valid_574752 != nil:
    section.add "deviceName", valid_574752
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574753 = query.getOrDefault("api-version")
  valid_574753 = validateParameter(valid_574753, JString, required = true,
                                 default = nil)
  if valid_574753 != nil:
    section.add "api-version", valid_574753
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

proc call*(call_574755: Call_UsersCreateOrUpdate_574746; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new user or updates an existing user's information on a Data Box Edge/Data Box Gateway device.
  ## 
  let valid = call_574755.validator(path, query, header, formData, body)
  let scheme = call_574755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574755.url(scheme.get, call_574755.host, call_574755.base,
                         call_574755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574755, url, valid)

proc call*(call_574756: Call_UsersCreateOrUpdate_574746; resourceGroupName: string;
          apiVersion: string; name: string; user: JsonNode; subscriptionId: string;
          deviceName: string): Recallable =
  ## usersCreateOrUpdate
  ## Creates a new user or updates an existing user's information on a Data Box Edge/Data Box Gateway device.
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
  var path_574757 = newJObject()
  var query_574758 = newJObject()
  var body_574759 = newJObject()
  add(path_574757, "resourceGroupName", newJString(resourceGroupName))
  add(query_574758, "api-version", newJString(apiVersion))
  add(path_574757, "name", newJString(name))
  if user != nil:
    body_574759 = user
  add(path_574757, "subscriptionId", newJString(subscriptionId))
  add(path_574757, "deviceName", newJString(deviceName))
  result = call_574756.call(path_574757, query_574758, nil, nil, body_574759)

var usersCreateOrUpdate* = Call_UsersCreateOrUpdate_574746(
    name: "usersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/users/{name}",
    validator: validate_UsersCreateOrUpdate_574747, base: "",
    url: url_UsersCreateOrUpdate_574748, schemes: {Scheme.Https})
type
  Call_UsersGet_574734 = ref object of OpenApiRestCall_573667
proc url_UsersGet_574736(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsersGet_574735(path: JsonNode; query: JsonNode; header: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_574742: Call_UsersGet_574734; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified user.
  ## 
  let valid = call_574742.validator(path, query, header, formData, body)
  let scheme = call_574742.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574742.url(scheme.get, call_574742.host, call_574742.base,
                         call_574742.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574742, url, valid)

proc call*(call_574743: Call_UsersGet_574734; resourceGroupName: string;
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
  var path_574744 = newJObject()
  var query_574745 = newJObject()
  add(path_574744, "resourceGroupName", newJString(resourceGroupName))
  add(query_574745, "api-version", newJString(apiVersion))
  add(path_574744, "name", newJString(name))
  add(path_574744, "subscriptionId", newJString(subscriptionId))
  add(path_574744, "deviceName", newJString(deviceName))
  result = call_574743.call(path_574744, query_574745, nil, nil, nil)

var usersGet* = Call_UsersGet_574734(name: "usersGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/users/{name}",
                                  validator: validate_UsersGet_574735, base: "",
                                  url: url_UsersGet_574736,
                                  schemes: {Scheme.Https})
type
  Call_UsersDelete_574760 = ref object of OpenApiRestCall_573667
proc url_UsersDelete_574762(protocol: Scheme; host: string; base: string;
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

proc validate_UsersDelete_574761(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574763 = path.getOrDefault("resourceGroupName")
  valid_574763 = validateParameter(valid_574763, JString, required = true,
                                 default = nil)
  if valid_574763 != nil:
    section.add "resourceGroupName", valid_574763
  var valid_574764 = path.getOrDefault("name")
  valid_574764 = validateParameter(valid_574764, JString, required = true,
                                 default = nil)
  if valid_574764 != nil:
    section.add "name", valid_574764
  var valid_574765 = path.getOrDefault("subscriptionId")
  valid_574765 = validateParameter(valid_574765, JString, required = true,
                                 default = nil)
  if valid_574765 != nil:
    section.add "subscriptionId", valid_574765
  var valid_574766 = path.getOrDefault("deviceName")
  valid_574766 = validateParameter(valid_574766, JString, required = true,
                                 default = nil)
  if valid_574766 != nil:
    section.add "deviceName", valid_574766
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574767 = query.getOrDefault("api-version")
  valid_574767 = validateParameter(valid_574767, JString, required = true,
                                 default = nil)
  if valid_574767 != nil:
    section.add "api-version", valid_574767
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574768: Call_UsersDelete_574760; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the user on a databox edge/gateway device.
  ## 
  let valid = call_574768.validator(path, query, header, formData, body)
  let scheme = call_574768.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574768.url(scheme.get, call_574768.host, call_574768.base,
                         call_574768.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574768, url, valid)

proc call*(call_574769: Call_UsersDelete_574760; resourceGroupName: string;
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
  var path_574770 = newJObject()
  var query_574771 = newJObject()
  add(path_574770, "resourceGroupName", newJString(resourceGroupName))
  add(query_574771, "api-version", newJString(apiVersion))
  add(path_574770, "name", newJString(name))
  add(path_574770, "subscriptionId", newJString(subscriptionId))
  add(path_574770, "deviceName", newJString(deviceName))
  result = call_574769.call(path_574770, query_574771, nil, nil, nil)

var usersDelete* = Call_UsersDelete_574760(name: "usersDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/users/{name}",
                                        validator: validate_UsersDelete_574761,
                                        base: "", url: url_UsersDelete_574762,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
