
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  macServiceName = "edgegateway"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593659 = ref object of OpenApiRestCall_593437
proc url_OperationsList_593661(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593660(path: JsonNode; query: JsonNode;
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
  var valid_593820 = query.getOrDefault("api-version")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = nil)
  if valid_593820 != nil:
    section.add "api-version", valid_593820
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593843: Call_OperationsList_593659; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593843.validator(path, query, header, formData, body)
  let scheme = call_593843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593843.url(scheme.get, call_593843.host, call_593843.base,
                         call_593843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593843, url, valid)

proc call*(call_593914: Call_OperationsList_593659; apiVersion: string): Recallable =
  ## operationsList
  ##   apiVersion: string (required)
  ##             : The API version.
  var query_593915 = newJObject()
  add(query_593915, "api-version", newJString(apiVersion))
  result = call_593914.call(nil, query_593915, nil, nil, nil)

var operationsList* = Call_OperationsList_593659(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataBoxEdge/operations",
    validator: validate_OperationsList_593660, base: "", url: url_OperationsList_593661,
    schemes: {Scheme.Https})
type
  Call_DevicesListBySubscription_593955 = ref object of OpenApiRestCall_593437
proc url_DevicesListBySubscription_593957(protocol: Scheme; host: string;
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

proc validate_DevicesListBySubscription_593956(path: JsonNode; query: JsonNode;
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
  var valid_593973 = path.getOrDefault("subscriptionId")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "subscriptionId", valid_593973
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the resource or Specify $skipToken=<token> to populate the next page in the list.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593974 = query.getOrDefault("api-version")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "api-version", valid_593974
  var valid_593975 = query.getOrDefault("$expand")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "$expand", valid_593975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593976: Call_DevicesListBySubscription_593955; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the data box edge/gateway devices in a subscription.
  ## 
  let valid = call_593976.validator(path, query, header, formData, body)
  let scheme = call_593976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593976.url(scheme.get, call_593976.host, call_593976.base,
                         call_593976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593976, url, valid)

proc call*(call_593977: Call_DevicesListBySubscription_593955; apiVersion: string;
          subscriptionId: string; Expand: string = ""): Recallable =
  ## devicesListBySubscription
  ## Gets all the data box edge/gateway devices in a subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   Expand: string
  ##         : Specify $expand=details to populate additional fields related to the resource or Specify $skipToken=<token> to populate the next page in the list.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_593978 = newJObject()
  var query_593979 = newJObject()
  add(query_593979, "api-version", newJString(apiVersion))
  add(query_593979, "$expand", newJString(Expand))
  add(path_593978, "subscriptionId", newJString(subscriptionId))
  result = call_593977.call(path_593978, query_593979, nil, nil, nil)

var devicesListBySubscription* = Call_DevicesListBySubscription_593955(
    name: "devicesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices",
    validator: validate_DevicesListBySubscription_593956, base: "",
    url: url_DevicesListBySubscription_593957, schemes: {Scheme.Https})
type
  Call_DevicesListByResourceGroup_593980 = ref object of OpenApiRestCall_593437
proc url_DevicesListByResourceGroup_593982(protocol: Scheme; host: string;
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

proc validate_DevicesListByResourceGroup_593981(path: JsonNode; query: JsonNode;
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
  var valid_593983 = path.getOrDefault("resourceGroupName")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "resourceGroupName", valid_593983
  var valid_593984 = path.getOrDefault("subscriptionId")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "subscriptionId", valid_593984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the resource or Specify $skipToken=<token> to populate the next page in the list.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593985 = query.getOrDefault("api-version")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "api-version", valid_593985
  var valid_593986 = query.getOrDefault("$expand")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "$expand", valid_593986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593987: Call_DevicesListByResourceGroup_593980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the data box edge/gateway devices in a resource group.
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_DevicesListByResourceGroup_593980;
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
  var path_593989 = newJObject()
  var query_593990 = newJObject()
  add(path_593989, "resourceGroupName", newJString(resourceGroupName))
  add(query_593990, "api-version", newJString(apiVersion))
  add(query_593990, "$expand", newJString(Expand))
  add(path_593989, "subscriptionId", newJString(subscriptionId))
  result = call_593988.call(path_593989, query_593990, nil, nil, nil)

var devicesListByResourceGroup* = Call_DevicesListByResourceGroup_593980(
    name: "devicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices",
    validator: validate_DevicesListByResourceGroup_593981, base: "",
    url: url_DevicesListByResourceGroup_593982, schemes: {Scheme.Https})
type
  Call_DevicesCreateOrUpdate_594002 = ref object of OpenApiRestCall_593437
proc url_DevicesCreateOrUpdate_594004(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesCreateOrUpdate_594003(path: JsonNode; query: JsonNode;
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
  var valid_594005 = path.getOrDefault("resourceGroupName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "resourceGroupName", valid_594005
  var valid_594006 = path.getOrDefault("subscriptionId")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "subscriptionId", valid_594006
  var valid_594007 = path.getOrDefault("deviceName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "deviceName", valid_594007
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594008 = query.getOrDefault("api-version")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "api-version", valid_594008
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

proc call*(call_594010: Call_DevicesCreateOrUpdate_594002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Data Box Edge/Gateway resource.
  ## 
  let valid = call_594010.validator(path, query, header, formData, body)
  let scheme = call_594010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594010.url(scheme.get, call_594010.host, call_594010.base,
                         call_594010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594010, url, valid)

proc call*(call_594011: Call_DevicesCreateOrUpdate_594002;
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
  var path_594012 = newJObject()
  var query_594013 = newJObject()
  var body_594014 = newJObject()
  add(path_594012, "resourceGroupName", newJString(resourceGroupName))
  add(query_594013, "api-version", newJString(apiVersion))
  add(path_594012, "subscriptionId", newJString(subscriptionId))
  if DataBoxEdgeDevice != nil:
    body_594014 = DataBoxEdgeDevice
  add(path_594012, "deviceName", newJString(deviceName))
  result = call_594011.call(path_594012, query_594013, nil, nil, body_594014)

var devicesCreateOrUpdate* = Call_DevicesCreateOrUpdate_594002(
    name: "devicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}",
    validator: validate_DevicesCreateOrUpdate_594003, base: "",
    url: url_DevicesCreateOrUpdate_594004, schemes: {Scheme.Https})
type
  Call_DevicesGet_593991 = ref object of OpenApiRestCall_593437
proc url_DevicesGet_593993(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DevicesGet_593992(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593994 = path.getOrDefault("resourceGroupName")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "resourceGroupName", valid_593994
  var valid_593995 = path.getOrDefault("subscriptionId")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "subscriptionId", valid_593995
  var valid_593996 = path.getOrDefault("deviceName")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "deviceName", valid_593996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593997 = query.getOrDefault("api-version")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "api-version", valid_593997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593998: Call_DevicesGet_593991; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the data box edge/gateway device.
  ## 
  let valid = call_593998.validator(path, query, header, formData, body)
  let scheme = call_593998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593998.url(scheme.get, call_593998.host, call_593998.base,
                         call_593998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593998, url, valid)

proc call*(call_593999: Call_DevicesGet_593991; resourceGroupName: string;
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
  var path_594000 = newJObject()
  var query_594001 = newJObject()
  add(path_594000, "resourceGroupName", newJString(resourceGroupName))
  add(query_594001, "api-version", newJString(apiVersion))
  add(path_594000, "subscriptionId", newJString(subscriptionId))
  add(path_594000, "deviceName", newJString(deviceName))
  result = call_593999.call(path_594000, query_594001, nil, nil, nil)

var devicesGet* = Call_DevicesGet_593991(name: "devicesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}",
                                      validator: validate_DevicesGet_593992,
                                      base: "", url: url_DevicesGet_593993,
                                      schemes: {Scheme.Https})
type
  Call_DevicesUpdate_594026 = ref object of OpenApiRestCall_593437
proc url_DevicesUpdate_594028(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesUpdate_594027(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594029 = path.getOrDefault("resourceGroupName")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "resourceGroupName", valid_594029
  var valid_594030 = path.getOrDefault("subscriptionId")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "subscriptionId", valid_594030
  var valid_594031 = path.getOrDefault("deviceName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "deviceName", valid_594031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594032 = query.getOrDefault("api-version")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "api-version", valid_594032
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

proc call*(call_594034: Call_DevicesUpdate_594026; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a Data Box Edge/Gateway resource.
  ## 
  let valid = call_594034.validator(path, query, header, formData, body)
  let scheme = call_594034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594034.url(scheme.get, call_594034.host, call_594034.base,
                         call_594034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594034, url, valid)

proc call*(call_594035: Call_DevicesUpdate_594026; resourceGroupName: string;
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
  var path_594036 = newJObject()
  var query_594037 = newJObject()
  var body_594038 = newJObject()
  add(path_594036, "resourceGroupName", newJString(resourceGroupName))
  add(query_594037, "api-version", newJString(apiVersion))
  add(path_594036, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594038 = parameters
  add(path_594036, "deviceName", newJString(deviceName))
  result = call_594035.call(path_594036, query_594037, nil, nil, body_594038)

var devicesUpdate* = Call_DevicesUpdate_594026(name: "devicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}",
    validator: validate_DevicesUpdate_594027, base: "", url: url_DevicesUpdate_594028,
    schemes: {Scheme.Https})
type
  Call_DevicesDelete_594015 = ref object of OpenApiRestCall_593437
proc url_DevicesDelete_594017(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesDelete_594016(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594018 = path.getOrDefault("resourceGroupName")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "resourceGroupName", valid_594018
  var valid_594019 = path.getOrDefault("subscriptionId")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "subscriptionId", valid_594019
  var valid_594020 = path.getOrDefault("deviceName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "deviceName", valid_594020
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594021 = query.getOrDefault("api-version")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "api-version", valid_594021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594022: Call_DevicesDelete_594015; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the data box edge/gateway device.
  ## 
  let valid = call_594022.validator(path, query, header, formData, body)
  let scheme = call_594022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594022.url(scheme.get, call_594022.host, call_594022.base,
                         call_594022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594022, url, valid)

proc call*(call_594023: Call_DevicesDelete_594015; resourceGroupName: string;
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
  var path_594024 = newJObject()
  var query_594025 = newJObject()
  add(path_594024, "resourceGroupName", newJString(resourceGroupName))
  add(query_594025, "api-version", newJString(apiVersion))
  add(path_594024, "subscriptionId", newJString(subscriptionId))
  add(path_594024, "deviceName", newJString(deviceName))
  result = call_594023.call(path_594024, query_594025, nil, nil, nil)

var devicesDelete* = Call_DevicesDelete_594015(name: "devicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}",
    validator: validate_DevicesDelete_594016, base: "", url: url_DevicesDelete_594017,
    schemes: {Scheme.Https})
type
  Call_AlertsListByDataBoxEdgeDevice_594039 = ref object of OpenApiRestCall_593437
proc url_AlertsListByDataBoxEdgeDevice_594041(protocol: Scheme; host: string;
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

proc validate_AlertsListByDataBoxEdgeDevice_594040(path: JsonNode; query: JsonNode;
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
  var valid_594042 = path.getOrDefault("resourceGroupName")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "resourceGroupName", valid_594042
  var valid_594043 = path.getOrDefault("subscriptionId")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "subscriptionId", valid_594043
  var valid_594044 = path.getOrDefault("deviceName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "deviceName", valid_594044
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594045 = query.getOrDefault("api-version")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "api-version", valid_594045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594046: Call_AlertsListByDataBoxEdgeDevice_594039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the alerts for a data box edge/gateway device.
  ## 
  let valid = call_594046.validator(path, query, header, formData, body)
  let scheme = call_594046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594046.url(scheme.get, call_594046.host, call_594046.base,
                         call_594046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594046, url, valid)

proc call*(call_594047: Call_AlertsListByDataBoxEdgeDevice_594039;
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
  var path_594048 = newJObject()
  var query_594049 = newJObject()
  add(path_594048, "resourceGroupName", newJString(resourceGroupName))
  add(query_594049, "api-version", newJString(apiVersion))
  add(path_594048, "subscriptionId", newJString(subscriptionId))
  add(path_594048, "deviceName", newJString(deviceName))
  result = call_594047.call(path_594048, query_594049, nil, nil, nil)

var alertsListByDataBoxEdgeDevice* = Call_AlertsListByDataBoxEdgeDevice_594039(
    name: "alertsListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/alerts",
    validator: validate_AlertsListByDataBoxEdgeDevice_594040, base: "",
    url: url_AlertsListByDataBoxEdgeDevice_594041, schemes: {Scheme.Https})
type
  Call_AlertsGet_594050 = ref object of OpenApiRestCall_593437
proc url_AlertsGet_594052(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AlertsGet_594051(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594053 = path.getOrDefault("resourceGroupName")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "resourceGroupName", valid_594053
  var valid_594054 = path.getOrDefault("name")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "name", valid_594054
  var valid_594055 = path.getOrDefault("subscriptionId")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "subscriptionId", valid_594055
  var valid_594056 = path.getOrDefault("deviceName")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "deviceName", valid_594056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594057 = query.getOrDefault("api-version")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "api-version", valid_594057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594058: Call_AlertsGet_594050; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594058.validator(path, query, header, formData, body)
  let scheme = call_594058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594058.url(scheme.get, call_594058.host, call_594058.base,
                         call_594058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594058, url, valid)

proc call*(call_594059: Call_AlertsGet_594050; resourceGroupName: string;
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
  var path_594060 = newJObject()
  var query_594061 = newJObject()
  add(path_594060, "resourceGroupName", newJString(resourceGroupName))
  add(query_594061, "api-version", newJString(apiVersion))
  add(path_594060, "name", newJString(name))
  add(path_594060, "subscriptionId", newJString(subscriptionId))
  add(path_594060, "deviceName", newJString(deviceName))
  result = call_594059.call(path_594060, query_594061, nil, nil, nil)

var alertsGet* = Call_AlertsGet_594050(name: "alertsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/alerts/{name}",
                                    validator: validate_AlertsGet_594051,
                                    base: "", url: url_AlertsGet_594052,
                                    schemes: {Scheme.Https})
type
  Call_BandwidthSchedulesListByDataBoxEdgeDevice_594062 = ref object of OpenApiRestCall_593437
proc url_BandwidthSchedulesListByDataBoxEdgeDevice_594064(protocol: Scheme;
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

proc validate_BandwidthSchedulesListByDataBoxEdgeDevice_594063(path: JsonNode;
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
  var valid_594065 = path.getOrDefault("resourceGroupName")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "resourceGroupName", valid_594065
  var valid_594066 = path.getOrDefault("subscriptionId")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "subscriptionId", valid_594066
  var valid_594067 = path.getOrDefault("deviceName")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "deviceName", valid_594067
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594068 = query.getOrDefault("api-version")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "api-version", valid_594068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594069: Call_BandwidthSchedulesListByDataBoxEdgeDevice_594062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the bandwidth schedules for a data box edge/gateway device.
  ## 
  let valid = call_594069.validator(path, query, header, formData, body)
  let scheme = call_594069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594069.url(scheme.get, call_594069.host, call_594069.base,
                         call_594069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594069, url, valid)

proc call*(call_594070: Call_BandwidthSchedulesListByDataBoxEdgeDevice_594062;
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
  var path_594071 = newJObject()
  var query_594072 = newJObject()
  add(path_594071, "resourceGroupName", newJString(resourceGroupName))
  add(query_594072, "api-version", newJString(apiVersion))
  add(path_594071, "subscriptionId", newJString(subscriptionId))
  add(path_594071, "deviceName", newJString(deviceName))
  result = call_594070.call(path_594071, query_594072, nil, nil, nil)

var bandwidthSchedulesListByDataBoxEdgeDevice* = Call_BandwidthSchedulesListByDataBoxEdgeDevice_594062(
    name: "bandwidthSchedulesListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/bandwidthSchedules",
    validator: validate_BandwidthSchedulesListByDataBoxEdgeDevice_594063,
    base: "", url: url_BandwidthSchedulesListByDataBoxEdgeDevice_594064,
    schemes: {Scheme.Https})
type
  Call_BandwidthSchedulesCreateOrUpdate_594085 = ref object of OpenApiRestCall_593437
proc url_BandwidthSchedulesCreateOrUpdate_594087(protocol: Scheme; host: string;
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

proc validate_BandwidthSchedulesCreateOrUpdate_594086(path: JsonNode;
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
  var valid_594088 = path.getOrDefault("resourceGroupName")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "resourceGroupName", valid_594088
  var valid_594089 = path.getOrDefault("name")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "name", valid_594089
  var valid_594090 = path.getOrDefault("subscriptionId")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "subscriptionId", valid_594090
  var valid_594091 = path.getOrDefault("deviceName")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "deviceName", valid_594091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594092 = query.getOrDefault("api-version")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "api-version", valid_594092
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

proc call*(call_594094: Call_BandwidthSchedulesCreateOrUpdate_594085;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a bandwidth schedule.
  ## 
  let valid = call_594094.validator(path, query, header, formData, body)
  let scheme = call_594094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594094.url(scheme.get, call_594094.host, call_594094.base,
                         call_594094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594094, url, valid)

proc call*(call_594095: Call_BandwidthSchedulesCreateOrUpdate_594085;
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
  var path_594096 = newJObject()
  var query_594097 = newJObject()
  var body_594098 = newJObject()
  add(path_594096, "resourceGroupName", newJString(resourceGroupName))
  add(query_594097, "api-version", newJString(apiVersion))
  add(path_594096, "name", newJString(name))
  add(path_594096, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594098 = parameters
  add(path_594096, "deviceName", newJString(deviceName))
  result = call_594095.call(path_594096, query_594097, nil, nil, body_594098)

var bandwidthSchedulesCreateOrUpdate* = Call_BandwidthSchedulesCreateOrUpdate_594085(
    name: "bandwidthSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/bandwidthSchedules/{name}",
    validator: validate_BandwidthSchedulesCreateOrUpdate_594086, base: "",
    url: url_BandwidthSchedulesCreateOrUpdate_594087, schemes: {Scheme.Https})
type
  Call_BandwidthSchedulesGet_594073 = ref object of OpenApiRestCall_593437
proc url_BandwidthSchedulesGet_594075(protocol: Scheme; host: string; base: string;
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

proc validate_BandwidthSchedulesGet_594074(path: JsonNode; query: JsonNode;
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
  var valid_594076 = path.getOrDefault("resourceGroupName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "resourceGroupName", valid_594076
  var valid_594077 = path.getOrDefault("name")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "name", valid_594077
  var valid_594078 = path.getOrDefault("subscriptionId")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "subscriptionId", valid_594078
  var valid_594079 = path.getOrDefault("deviceName")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "deviceName", valid_594079
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594080 = query.getOrDefault("api-version")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "api-version", valid_594080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594081: Call_BandwidthSchedulesGet_594073; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified bandwidth schedule.
  ## 
  let valid = call_594081.validator(path, query, header, formData, body)
  let scheme = call_594081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594081.url(scheme.get, call_594081.host, call_594081.base,
                         call_594081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594081, url, valid)

proc call*(call_594082: Call_BandwidthSchedulesGet_594073;
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
  var path_594083 = newJObject()
  var query_594084 = newJObject()
  add(path_594083, "resourceGroupName", newJString(resourceGroupName))
  add(query_594084, "api-version", newJString(apiVersion))
  add(path_594083, "name", newJString(name))
  add(path_594083, "subscriptionId", newJString(subscriptionId))
  add(path_594083, "deviceName", newJString(deviceName))
  result = call_594082.call(path_594083, query_594084, nil, nil, nil)

var bandwidthSchedulesGet* = Call_BandwidthSchedulesGet_594073(
    name: "bandwidthSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/bandwidthSchedules/{name}",
    validator: validate_BandwidthSchedulesGet_594074, base: "",
    url: url_BandwidthSchedulesGet_594075, schemes: {Scheme.Https})
type
  Call_BandwidthSchedulesDelete_594099 = ref object of OpenApiRestCall_593437
proc url_BandwidthSchedulesDelete_594101(protocol: Scheme; host: string;
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

proc validate_BandwidthSchedulesDelete_594100(path: JsonNode; query: JsonNode;
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
  var valid_594102 = path.getOrDefault("resourceGroupName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "resourceGroupName", valid_594102
  var valid_594103 = path.getOrDefault("name")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "name", valid_594103
  var valid_594104 = path.getOrDefault("subscriptionId")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "subscriptionId", valid_594104
  var valid_594105 = path.getOrDefault("deviceName")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "deviceName", valid_594105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594106 = query.getOrDefault("api-version")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "api-version", valid_594106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594107: Call_BandwidthSchedulesDelete_594099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified bandwidth schedule.
  ## 
  let valid = call_594107.validator(path, query, header, formData, body)
  let scheme = call_594107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594107.url(scheme.get, call_594107.host, call_594107.base,
                         call_594107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594107, url, valid)

proc call*(call_594108: Call_BandwidthSchedulesDelete_594099;
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
  var path_594109 = newJObject()
  var query_594110 = newJObject()
  add(path_594109, "resourceGroupName", newJString(resourceGroupName))
  add(query_594110, "api-version", newJString(apiVersion))
  add(path_594109, "name", newJString(name))
  add(path_594109, "subscriptionId", newJString(subscriptionId))
  add(path_594109, "deviceName", newJString(deviceName))
  result = call_594108.call(path_594109, query_594110, nil, nil, nil)

var bandwidthSchedulesDelete* = Call_BandwidthSchedulesDelete_594099(
    name: "bandwidthSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/bandwidthSchedules/{name}",
    validator: validate_BandwidthSchedulesDelete_594100, base: "",
    url: url_BandwidthSchedulesDelete_594101, schemes: {Scheme.Https})
type
  Call_DevicesDownloadUpdates_594111 = ref object of OpenApiRestCall_593437
proc url_DevicesDownloadUpdates_594113(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesDownloadUpdates_594112(path: JsonNode; query: JsonNode;
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
  var valid_594114 = path.getOrDefault("resourceGroupName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "resourceGroupName", valid_594114
  var valid_594115 = path.getOrDefault("subscriptionId")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "subscriptionId", valid_594115
  var valid_594116 = path.getOrDefault("deviceName")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "deviceName", valid_594116
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594117 = query.getOrDefault("api-version")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "api-version", valid_594117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594118: Call_DevicesDownloadUpdates_594111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594118.validator(path, query, header, formData, body)
  let scheme = call_594118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594118.url(scheme.get, call_594118.host, call_594118.base,
                         call_594118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594118, url, valid)

proc call*(call_594119: Call_DevicesDownloadUpdates_594111;
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
  var path_594120 = newJObject()
  var query_594121 = newJObject()
  add(path_594120, "resourceGroupName", newJString(resourceGroupName))
  add(query_594121, "api-version", newJString(apiVersion))
  add(path_594120, "subscriptionId", newJString(subscriptionId))
  add(path_594120, "deviceName", newJString(deviceName))
  result = call_594119.call(path_594120, query_594121, nil, nil, nil)

var devicesDownloadUpdates* = Call_DevicesDownloadUpdates_594111(
    name: "devicesDownloadUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/downloadUpdates",
    validator: validate_DevicesDownloadUpdates_594112, base: "",
    url: url_DevicesDownloadUpdates_594113, schemes: {Scheme.Https})
type
  Call_DevicesGetExtendedInformation_594122 = ref object of OpenApiRestCall_593437
proc url_DevicesGetExtendedInformation_594124(protocol: Scheme; host: string;
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

proc validate_DevicesGetExtendedInformation_594123(path: JsonNode; query: JsonNode;
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
  var valid_594125 = path.getOrDefault("resourceGroupName")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "resourceGroupName", valid_594125
  var valid_594126 = path.getOrDefault("subscriptionId")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "subscriptionId", valid_594126
  var valid_594127 = path.getOrDefault("deviceName")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "deviceName", valid_594127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594128 = query.getOrDefault("api-version")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "api-version", valid_594128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594129: Call_DevicesGetExtendedInformation_594122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets additional information for the specified data box edge/gateway device.
  ## 
  let valid = call_594129.validator(path, query, header, formData, body)
  let scheme = call_594129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594129.url(scheme.get, call_594129.host, call_594129.base,
                         call_594129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594129, url, valid)

proc call*(call_594130: Call_DevicesGetExtendedInformation_594122;
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
  var path_594131 = newJObject()
  var query_594132 = newJObject()
  add(path_594131, "resourceGroupName", newJString(resourceGroupName))
  add(query_594132, "api-version", newJString(apiVersion))
  add(path_594131, "subscriptionId", newJString(subscriptionId))
  add(path_594131, "deviceName", newJString(deviceName))
  result = call_594130.call(path_594131, query_594132, nil, nil, nil)

var devicesGetExtendedInformation* = Call_DevicesGetExtendedInformation_594122(
    name: "devicesGetExtendedInformation", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/getExtendedInformation",
    validator: validate_DevicesGetExtendedInformation_594123, base: "",
    url: url_DevicesGetExtendedInformation_594124, schemes: {Scheme.Https})
type
  Call_DevicesInstallUpdates_594133 = ref object of OpenApiRestCall_593437
proc url_DevicesInstallUpdates_594135(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesInstallUpdates_594134(path: JsonNode; query: JsonNode;
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
  var valid_594136 = path.getOrDefault("resourceGroupName")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "resourceGroupName", valid_594136
  var valid_594137 = path.getOrDefault("subscriptionId")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "subscriptionId", valid_594137
  var valid_594138 = path.getOrDefault("deviceName")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "deviceName", valid_594138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594139 = query.getOrDefault("api-version")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "api-version", valid_594139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594140: Call_DevicesInstallUpdates_594133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594140.validator(path, query, header, formData, body)
  let scheme = call_594140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594140.url(scheme.get, call_594140.host, call_594140.base,
                         call_594140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594140, url, valid)

proc call*(call_594141: Call_DevicesInstallUpdates_594133;
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
  var path_594142 = newJObject()
  var query_594143 = newJObject()
  add(path_594142, "resourceGroupName", newJString(resourceGroupName))
  add(query_594143, "api-version", newJString(apiVersion))
  add(path_594142, "subscriptionId", newJString(subscriptionId))
  add(path_594142, "deviceName", newJString(deviceName))
  result = call_594141.call(path_594142, query_594143, nil, nil, nil)

var devicesInstallUpdates* = Call_DevicesInstallUpdates_594133(
    name: "devicesInstallUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/installUpdates",
    validator: validate_DevicesInstallUpdates_594134, base: "",
    url: url_DevicesInstallUpdates_594135, schemes: {Scheme.Https})
type
  Call_JobsGet_594144 = ref object of OpenApiRestCall_593437
proc url_JobsGet_594146(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsGet_594145(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594147 = path.getOrDefault("resourceGroupName")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "resourceGroupName", valid_594147
  var valid_594148 = path.getOrDefault("name")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "name", valid_594148
  var valid_594149 = path.getOrDefault("subscriptionId")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "subscriptionId", valid_594149
  var valid_594150 = path.getOrDefault("deviceName")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "deviceName", valid_594150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594151 = query.getOrDefault("api-version")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "api-version", valid_594151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594152: Call_JobsGet_594144; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594152.validator(path, query, header, formData, body)
  let scheme = call_594152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594152.url(scheme.get, call_594152.host, call_594152.base,
                         call_594152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594152, url, valid)

proc call*(call_594153: Call_JobsGet_594144; resourceGroupName: string;
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
  var path_594154 = newJObject()
  var query_594155 = newJObject()
  add(path_594154, "resourceGroupName", newJString(resourceGroupName))
  add(query_594155, "api-version", newJString(apiVersion))
  add(path_594154, "name", newJString(name))
  add(path_594154, "subscriptionId", newJString(subscriptionId))
  add(path_594154, "deviceName", newJString(deviceName))
  result = call_594153.call(path_594154, query_594155, nil, nil, nil)

var jobsGet* = Call_JobsGet_594144(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/jobs/{name}",
                                validator: validate_JobsGet_594145, base: "",
                                url: url_JobsGet_594146, schemes: {Scheme.Https})
type
  Call_DevicesGetNetworkSettings_594156 = ref object of OpenApiRestCall_593437
proc url_DevicesGetNetworkSettings_594158(protocol: Scheme; host: string;
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

proc validate_DevicesGetNetworkSettings_594157(path: JsonNode; query: JsonNode;
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
  var valid_594159 = path.getOrDefault("resourceGroupName")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "resourceGroupName", valid_594159
  var valid_594160 = path.getOrDefault("subscriptionId")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "subscriptionId", valid_594160
  var valid_594161 = path.getOrDefault("deviceName")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "deviceName", valid_594161
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594162 = query.getOrDefault("api-version")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "api-version", valid_594162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594163: Call_DevicesGetNetworkSettings_594156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the network settings of the specified data box edge/gateway device.
  ## 
  let valid = call_594163.validator(path, query, header, formData, body)
  let scheme = call_594163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594163.url(scheme.get, call_594163.host, call_594163.base,
                         call_594163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594163, url, valid)

proc call*(call_594164: Call_DevicesGetNetworkSettings_594156;
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
  var path_594165 = newJObject()
  var query_594166 = newJObject()
  add(path_594165, "resourceGroupName", newJString(resourceGroupName))
  add(query_594166, "api-version", newJString(apiVersion))
  add(path_594165, "subscriptionId", newJString(subscriptionId))
  add(path_594165, "deviceName", newJString(deviceName))
  result = call_594164.call(path_594165, query_594166, nil, nil, nil)

var devicesGetNetworkSettings* = Call_DevicesGetNetworkSettings_594156(
    name: "devicesGetNetworkSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/networkSettings/default",
    validator: validate_DevicesGetNetworkSettings_594157, base: "",
    url: url_DevicesGetNetworkSettings_594158, schemes: {Scheme.Https})
type
  Call_OperationsStatusGet_594167 = ref object of OpenApiRestCall_593437
proc url_OperationsStatusGet_594169(protocol: Scheme; host: string; base: string;
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

proc validate_OperationsStatusGet_594168(path: JsonNode; query: JsonNode;
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
  var valid_594170 = path.getOrDefault("resourceGroupName")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "resourceGroupName", valid_594170
  var valid_594171 = path.getOrDefault("name")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "name", valid_594171
  var valid_594172 = path.getOrDefault("subscriptionId")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "subscriptionId", valid_594172
  var valid_594173 = path.getOrDefault("deviceName")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "deviceName", valid_594173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594174 = query.getOrDefault("api-version")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "api-version", valid_594174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594175: Call_OperationsStatusGet_594167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594175.validator(path, query, header, formData, body)
  let scheme = call_594175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594175.url(scheme.get, call_594175.host, call_594175.base,
                         call_594175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594175, url, valid)

proc call*(call_594176: Call_OperationsStatusGet_594167; resourceGroupName: string;
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
  var path_594177 = newJObject()
  var query_594178 = newJObject()
  add(path_594177, "resourceGroupName", newJString(resourceGroupName))
  add(query_594178, "api-version", newJString(apiVersion))
  add(path_594177, "name", newJString(name))
  add(path_594177, "subscriptionId", newJString(subscriptionId))
  add(path_594177, "deviceName", newJString(deviceName))
  result = call_594176.call(path_594177, query_594178, nil, nil, nil)

var operationsStatusGet* = Call_OperationsStatusGet_594167(
    name: "operationsStatusGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/operationsStatus/{name}",
    validator: validate_OperationsStatusGet_594168, base: "",
    url: url_OperationsStatusGet_594169, schemes: {Scheme.Https})
type
  Call_OrdersListByDataBoxEdgeDevice_594179 = ref object of OpenApiRestCall_593437
proc url_OrdersListByDataBoxEdgeDevice_594181(protocol: Scheme; host: string;
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

proc validate_OrdersListByDataBoxEdgeDevice_594180(path: JsonNode; query: JsonNode;
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
  var valid_594182 = path.getOrDefault("resourceGroupName")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "resourceGroupName", valid_594182
  var valid_594183 = path.getOrDefault("subscriptionId")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "subscriptionId", valid_594183
  var valid_594184 = path.getOrDefault("deviceName")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "deviceName", valid_594184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594185 = query.getOrDefault("api-version")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "api-version", valid_594185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594186: Call_OrdersListByDataBoxEdgeDevice_594179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594186.validator(path, query, header, formData, body)
  let scheme = call_594186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594186.url(scheme.get, call_594186.host, call_594186.base,
                         call_594186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594186, url, valid)

proc call*(call_594187: Call_OrdersListByDataBoxEdgeDevice_594179;
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
  var path_594188 = newJObject()
  var query_594189 = newJObject()
  add(path_594188, "resourceGroupName", newJString(resourceGroupName))
  add(query_594189, "api-version", newJString(apiVersion))
  add(path_594188, "subscriptionId", newJString(subscriptionId))
  add(path_594188, "deviceName", newJString(deviceName))
  result = call_594187.call(path_594188, query_594189, nil, nil, nil)

var ordersListByDataBoxEdgeDevice* = Call_OrdersListByDataBoxEdgeDevice_594179(
    name: "ordersListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/orders",
    validator: validate_OrdersListByDataBoxEdgeDevice_594180, base: "",
    url: url_OrdersListByDataBoxEdgeDevice_594181, schemes: {Scheme.Https})
type
  Call_OrdersCreateOrUpdate_594201 = ref object of OpenApiRestCall_593437
proc url_OrdersCreateOrUpdate_594203(protocol: Scheme; host: string; base: string;
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

proc validate_OrdersCreateOrUpdate_594202(path: JsonNode; query: JsonNode;
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
  var valid_594204 = path.getOrDefault("resourceGroupName")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "resourceGroupName", valid_594204
  var valid_594205 = path.getOrDefault("subscriptionId")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "subscriptionId", valid_594205
  var valid_594206 = path.getOrDefault("deviceName")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "deviceName", valid_594206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594207 = query.getOrDefault("api-version")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "api-version", valid_594207
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

proc call*(call_594209: Call_OrdersCreateOrUpdate_594201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594209.validator(path, query, header, formData, body)
  let scheme = call_594209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594209.url(scheme.get, call_594209.host, call_594209.base,
                         call_594209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594209, url, valid)

proc call*(call_594210: Call_OrdersCreateOrUpdate_594201;
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
  var path_594211 = newJObject()
  var query_594212 = newJObject()
  var body_594213 = newJObject()
  add(path_594211, "resourceGroupName", newJString(resourceGroupName))
  add(query_594212, "api-version", newJString(apiVersion))
  if order != nil:
    body_594213 = order
  add(path_594211, "subscriptionId", newJString(subscriptionId))
  add(path_594211, "deviceName", newJString(deviceName))
  result = call_594210.call(path_594211, query_594212, nil, nil, body_594213)

var ordersCreateOrUpdate* = Call_OrdersCreateOrUpdate_594201(
    name: "ordersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/orders/default",
    validator: validate_OrdersCreateOrUpdate_594202, base: "",
    url: url_OrdersCreateOrUpdate_594203, schemes: {Scheme.Https})
type
  Call_OrdersGet_594190 = ref object of OpenApiRestCall_593437
proc url_OrdersGet_594192(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_OrdersGet_594191(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594193 = path.getOrDefault("resourceGroupName")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "resourceGroupName", valid_594193
  var valid_594194 = path.getOrDefault("subscriptionId")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "subscriptionId", valid_594194
  var valid_594195 = path.getOrDefault("deviceName")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "deviceName", valid_594195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594196 = query.getOrDefault("api-version")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "api-version", valid_594196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594197: Call_OrdersGet_594190; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594197.validator(path, query, header, formData, body)
  let scheme = call_594197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594197.url(scheme.get, call_594197.host, call_594197.base,
                         call_594197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594197, url, valid)

proc call*(call_594198: Call_OrdersGet_594190; resourceGroupName: string;
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
  var path_594199 = newJObject()
  var query_594200 = newJObject()
  add(path_594199, "resourceGroupName", newJString(resourceGroupName))
  add(query_594200, "api-version", newJString(apiVersion))
  add(path_594199, "subscriptionId", newJString(subscriptionId))
  add(path_594199, "deviceName", newJString(deviceName))
  result = call_594198.call(path_594199, query_594200, nil, nil, nil)

var ordersGet* = Call_OrdersGet_594190(name: "ordersGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/orders/default",
                                    validator: validate_OrdersGet_594191,
                                    base: "", url: url_OrdersGet_594192,
                                    schemes: {Scheme.Https})
type
  Call_OrdersDelete_594214 = ref object of OpenApiRestCall_593437
proc url_OrdersDelete_594216(protocol: Scheme; host: string; base: string;
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

proc validate_OrdersDelete_594215(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594217 = path.getOrDefault("resourceGroupName")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "resourceGroupName", valid_594217
  var valid_594218 = path.getOrDefault("subscriptionId")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "subscriptionId", valid_594218
  var valid_594219 = path.getOrDefault("deviceName")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "deviceName", valid_594219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594220 = query.getOrDefault("api-version")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "api-version", valid_594220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594221: Call_OrdersDelete_594214; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594221.validator(path, query, header, formData, body)
  let scheme = call_594221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594221.url(scheme.get, call_594221.host, call_594221.base,
                         call_594221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594221, url, valid)

proc call*(call_594222: Call_OrdersDelete_594214; resourceGroupName: string;
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
  var path_594223 = newJObject()
  var query_594224 = newJObject()
  add(path_594223, "resourceGroupName", newJString(resourceGroupName))
  add(query_594224, "api-version", newJString(apiVersion))
  add(path_594223, "subscriptionId", newJString(subscriptionId))
  add(path_594223, "deviceName", newJString(deviceName))
  result = call_594222.call(path_594223, query_594224, nil, nil, nil)

var ordersDelete* = Call_OrdersDelete_594214(name: "ordersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/orders/default",
    validator: validate_OrdersDelete_594215, base: "", url: url_OrdersDelete_594216,
    schemes: {Scheme.Https})
type
  Call_RolesListByDataBoxEdgeDevice_594225 = ref object of OpenApiRestCall_593437
proc url_RolesListByDataBoxEdgeDevice_594227(protocol: Scheme; host: string;
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

proc validate_RolesListByDataBoxEdgeDevice_594226(path: JsonNode; query: JsonNode;
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
  var valid_594228 = path.getOrDefault("resourceGroupName")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "resourceGroupName", valid_594228
  var valid_594229 = path.getOrDefault("subscriptionId")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "subscriptionId", valid_594229
  var valid_594230 = path.getOrDefault("deviceName")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "deviceName", valid_594230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594231 = query.getOrDefault("api-version")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "api-version", valid_594231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594232: Call_RolesListByDataBoxEdgeDevice_594225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the roles configured in a data box edge/gateway device.
  ## 
  let valid = call_594232.validator(path, query, header, formData, body)
  let scheme = call_594232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594232.url(scheme.get, call_594232.host, call_594232.base,
                         call_594232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594232, url, valid)

proc call*(call_594233: Call_RolesListByDataBoxEdgeDevice_594225;
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
  var path_594234 = newJObject()
  var query_594235 = newJObject()
  add(path_594234, "resourceGroupName", newJString(resourceGroupName))
  add(query_594235, "api-version", newJString(apiVersion))
  add(path_594234, "subscriptionId", newJString(subscriptionId))
  add(path_594234, "deviceName", newJString(deviceName))
  result = call_594233.call(path_594234, query_594235, nil, nil, nil)

var rolesListByDataBoxEdgeDevice* = Call_RolesListByDataBoxEdgeDevice_594225(
    name: "rolesListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/roles",
    validator: validate_RolesListByDataBoxEdgeDevice_594226, base: "",
    url: url_RolesListByDataBoxEdgeDevice_594227, schemes: {Scheme.Https})
type
  Call_RolesCreateOrUpdate_594248 = ref object of OpenApiRestCall_593437
proc url_RolesCreateOrUpdate_594250(protocol: Scheme; host: string; base: string;
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

proc validate_RolesCreateOrUpdate_594249(path: JsonNode; query: JsonNode;
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
  var valid_594251 = path.getOrDefault("resourceGroupName")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "resourceGroupName", valid_594251
  var valid_594252 = path.getOrDefault("name")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "name", valid_594252
  var valid_594253 = path.getOrDefault("subscriptionId")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "subscriptionId", valid_594253
  var valid_594254 = path.getOrDefault("deviceName")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "deviceName", valid_594254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594255 = query.getOrDefault("api-version")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "api-version", valid_594255
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

proc call*(call_594257: Call_RolesCreateOrUpdate_594248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a role.
  ## 
  let valid = call_594257.validator(path, query, header, formData, body)
  let scheme = call_594257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594257.url(scheme.get, call_594257.host, call_594257.base,
                         call_594257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594257, url, valid)

proc call*(call_594258: Call_RolesCreateOrUpdate_594248; resourceGroupName: string;
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
  var path_594259 = newJObject()
  var query_594260 = newJObject()
  var body_594261 = newJObject()
  add(path_594259, "resourceGroupName", newJString(resourceGroupName))
  add(query_594260, "api-version", newJString(apiVersion))
  add(path_594259, "name", newJString(name))
  add(path_594259, "subscriptionId", newJString(subscriptionId))
  if role != nil:
    body_594261 = role
  add(path_594259, "deviceName", newJString(deviceName))
  result = call_594258.call(path_594259, query_594260, nil, nil, body_594261)

var rolesCreateOrUpdate* = Call_RolesCreateOrUpdate_594248(
    name: "rolesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/roles/{name}",
    validator: validate_RolesCreateOrUpdate_594249, base: "",
    url: url_RolesCreateOrUpdate_594250, schemes: {Scheme.Https})
type
  Call_RolesGet_594236 = ref object of OpenApiRestCall_593437
proc url_RolesGet_594238(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_RolesGet_594237(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594239 = path.getOrDefault("resourceGroupName")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "resourceGroupName", valid_594239
  var valid_594240 = path.getOrDefault("name")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "name", valid_594240
  var valid_594241 = path.getOrDefault("subscriptionId")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "subscriptionId", valid_594241
  var valid_594242 = path.getOrDefault("deviceName")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "deviceName", valid_594242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594243 = query.getOrDefault("api-version")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "api-version", valid_594243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594244: Call_RolesGet_594236; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific role by name.
  ## 
  let valid = call_594244.validator(path, query, header, formData, body)
  let scheme = call_594244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594244.url(scheme.get, call_594244.host, call_594244.base,
                         call_594244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594244, url, valid)

proc call*(call_594245: Call_RolesGet_594236; resourceGroupName: string;
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
  var path_594246 = newJObject()
  var query_594247 = newJObject()
  add(path_594246, "resourceGroupName", newJString(resourceGroupName))
  add(query_594247, "api-version", newJString(apiVersion))
  add(path_594246, "name", newJString(name))
  add(path_594246, "subscriptionId", newJString(subscriptionId))
  add(path_594246, "deviceName", newJString(deviceName))
  result = call_594245.call(path_594246, query_594247, nil, nil, nil)

var rolesGet* = Call_RolesGet_594236(name: "rolesGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/roles/{name}",
                                  validator: validate_RolesGet_594237, base: "",
                                  url: url_RolesGet_594238,
                                  schemes: {Scheme.Https})
type
  Call_RolesDelete_594262 = ref object of OpenApiRestCall_593437
proc url_RolesDelete_594264(protocol: Scheme; host: string; base: string;
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

proc validate_RolesDelete_594263(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594265 = path.getOrDefault("resourceGroupName")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "resourceGroupName", valid_594265
  var valid_594266 = path.getOrDefault("name")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "name", valid_594266
  var valid_594267 = path.getOrDefault("subscriptionId")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "subscriptionId", valid_594267
  var valid_594268 = path.getOrDefault("deviceName")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "deviceName", valid_594268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594269 = query.getOrDefault("api-version")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "api-version", valid_594269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594270: Call_RolesDelete_594262; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the role on the data box edge device.
  ## 
  let valid = call_594270.validator(path, query, header, formData, body)
  let scheme = call_594270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594270.url(scheme.get, call_594270.host, call_594270.base,
                         call_594270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594270, url, valid)

proc call*(call_594271: Call_RolesDelete_594262; resourceGroupName: string;
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
  var path_594272 = newJObject()
  var query_594273 = newJObject()
  add(path_594272, "resourceGroupName", newJString(resourceGroupName))
  add(query_594273, "api-version", newJString(apiVersion))
  add(path_594272, "name", newJString(name))
  add(path_594272, "subscriptionId", newJString(subscriptionId))
  add(path_594272, "deviceName", newJString(deviceName))
  result = call_594271.call(path_594272, query_594273, nil, nil, nil)

var rolesDelete* = Call_RolesDelete_594262(name: "rolesDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/roles/{name}",
                                        validator: validate_RolesDelete_594263,
                                        base: "", url: url_RolesDelete_594264,
                                        schemes: {Scheme.Https})
type
  Call_DevicesScanForUpdates_594274 = ref object of OpenApiRestCall_593437
proc url_DevicesScanForUpdates_594276(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesScanForUpdates_594275(path: JsonNode; query: JsonNode;
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
  var valid_594277 = path.getOrDefault("resourceGroupName")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "resourceGroupName", valid_594277
  var valid_594278 = path.getOrDefault("subscriptionId")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "subscriptionId", valid_594278
  var valid_594279 = path.getOrDefault("deviceName")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "deviceName", valid_594279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594280 = query.getOrDefault("api-version")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "api-version", valid_594280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594281: Call_DevicesScanForUpdates_594274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594281.validator(path, query, header, formData, body)
  let scheme = call_594281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594281.url(scheme.get, call_594281.host, call_594281.base,
                         call_594281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594281, url, valid)

proc call*(call_594282: Call_DevicesScanForUpdates_594274;
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
  var path_594283 = newJObject()
  var query_594284 = newJObject()
  add(path_594283, "resourceGroupName", newJString(resourceGroupName))
  add(query_594284, "api-version", newJString(apiVersion))
  add(path_594283, "subscriptionId", newJString(subscriptionId))
  add(path_594283, "deviceName", newJString(deviceName))
  result = call_594282.call(path_594283, query_594284, nil, nil, nil)

var devicesScanForUpdates* = Call_DevicesScanForUpdates_594274(
    name: "devicesScanForUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/scanForUpdates",
    validator: validate_DevicesScanForUpdates_594275, base: "",
    url: url_DevicesScanForUpdates_594276, schemes: {Scheme.Https})
type
  Call_DevicesCreateOrUpdateSecuritySettings_594285 = ref object of OpenApiRestCall_593437
proc url_DevicesCreateOrUpdateSecuritySettings_594287(protocol: Scheme;
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

proc validate_DevicesCreateOrUpdateSecuritySettings_594286(path: JsonNode;
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
  var valid_594288 = path.getOrDefault("resourceGroupName")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "resourceGroupName", valid_594288
  var valid_594289 = path.getOrDefault("subscriptionId")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "subscriptionId", valid_594289
  var valid_594290 = path.getOrDefault("deviceName")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "deviceName", valid_594290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594291 = query.getOrDefault("api-version")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "api-version", valid_594291
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

proc call*(call_594293: Call_DevicesCreateOrUpdateSecuritySettings_594285;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the security settings on a data box edge/gateway device.
  ## 
  let valid = call_594293.validator(path, query, header, formData, body)
  let scheme = call_594293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594293.url(scheme.get, call_594293.host, call_594293.base,
                         call_594293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594293, url, valid)

proc call*(call_594294: Call_DevicesCreateOrUpdateSecuritySettings_594285;
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
  var path_594295 = newJObject()
  var query_594296 = newJObject()
  var body_594297 = newJObject()
  add(path_594295, "resourceGroupName", newJString(resourceGroupName))
  add(query_594296, "api-version", newJString(apiVersion))
  if securitySettings != nil:
    body_594297 = securitySettings
  add(path_594295, "subscriptionId", newJString(subscriptionId))
  add(path_594295, "deviceName", newJString(deviceName))
  result = call_594294.call(path_594295, query_594296, nil, nil, body_594297)

var devicesCreateOrUpdateSecuritySettings* = Call_DevicesCreateOrUpdateSecuritySettings_594285(
    name: "devicesCreateOrUpdateSecuritySettings", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/securitySettings/default/update",
    validator: validate_DevicesCreateOrUpdateSecuritySettings_594286, base: "",
    url: url_DevicesCreateOrUpdateSecuritySettings_594287, schemes: {Scheme.Https})
type
  Call_SharesListByDataBoxEdgeDevice_594298 = ref object of OpenApiRestCall_593437
proc url_SharesListByDataBoxEdgeDevice_594300(protocol: Scheme; host: string;
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

proc validate_SharesListByDataBoxEdgeDevice_594299(path: JsonNode; query: JsonNode;
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
  var valid_594301 = path.getOrDefault("resourceGroupName")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "resourceGroupName", valid_594301
  var valid_594302 = path.getOrDefault("subscriptionId")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "subscriptionId", valid_594302
  var valid_594303 = path.getOrDefault("deviceName")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "deviceName", valid_594303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594304 = query.getOrDefault("api-version")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "api-version", valid_594304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594305: Call_SharesListByDataBoxEdgeDevice_594298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594305.validator(path, query, header, formData, body)
  let scheme = call_594305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594305.url(scheme.get, call_594305.host, call_594305.base,
                         call_594305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594305, url, valid)

proc call*(call_594306: Call_SharesListByDataBoxEdgeDevice_594298;
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
  var path_594307 = newJObject()
  var query_594308 = newJObject()
  add(path_594307, "resourceGroupName", newJString(resourceGroupName))
  add(query_594308, "api-version", newJString(apiVersion))
  add(path_594307, "subscriptionId", newJString(subscriptionId))
  add(path_594307, "deviceName", newJString(deviceName))
  result = call_594306.call(path_594307, query_594308, nil, nil, nil)

var sharesListByDataBoxEdgeDevice* = Call_SharesListByDataBoxEdgeDevice_594298(
    name: "sharesListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares",
    validator: validate_SharesListByDataBoxEdgeDevice_594299, base: "",
    url: url_SharesListByDataBoxEdgeDevice_594300, schemes: {Scheme.Https})
type
  Call_SharesCreateOrUpdate_594321 = ref object of OpenApiRestCall_593437
proc url_SharesCreateOrUpdate_594323(protocol: Scheme; host: string; base: string;
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

proc validate_SharesCreateOrUpdate_594322(path: JsonNode; query: JsonNode;
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
  var valid_594324 = path.getOrDefault("resourceGroupName")
  valid_594324 = validateParameter(valid_594324, JString, required = true,
                                 default = nil)
  if valid_594324 != nil:
    section.add "resourceGroupName", valid_594324
  var valid_594325 = path.getOrDefault("name")
  valid_594325 = validateParameter(valid_594325, JString, required = true,
                                 default = nil)
  if valid_594325 != nil:
    section.add "name", valid_594325
  var valid_594326 = path.getOrDefault("subscriptionId")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "subscriptionId", valid_594326
  var valid_594327 = path.getOrDefault("deviceName")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "deviceName", valid_594327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594328 = query.getOrDefault("api-version")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "api-version", valid_594328
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

proc call*(call_594330: Call_SharesCreateOrUpdate_594321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594330.validator(path, query, header, formData, body)
  let scheme = call_594330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594330.url(scheme.get, call_594330.host, call_594330.base,
                         call_594330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594330, url, valid)

proc call*(call_594331: Call_SharesCreateOrUpdate_594321;
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
  var path_594332 = newJObject()
  var query_594333 = newJObject()
  var body_594334 = newJObject()
  add(path_594332, "resourceGroupName", newJString(resourceGroupName))
  add(query_594333, "api-version", newJString(apiVersion))
  add(path_594332, "name", newJString(name))
  add(path_594332, "subscriptionId", newJString(subscriptionId))
  if share != nil:
    body_594334 = share
  add(path_594332, "deviceName", newJString(deviceName))
  result = call_594331.call(path_594332, query_594333, nil, nil, body_594334)

var sharesCreateOrUpdate* = Call_SharesCreateOrUpdate_594321(
    name: "sharesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares/{name}",
    validator: validate_SharesCreateOrUpdate_594322, base: "",
    url: url_SharesCreateOrUpdate_594323, schemes: {Scheme.Https})
type
  Call_SharesGet_594309 = ref object of OpenApiRestCall_593437
proc url_SharesGet_594311(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SharesGet_594310(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594312 = path.getOrDefault("resourceGroupName")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "resourceGroupName", valid_594312
  var valid_594313 = path.getOrDefault("name")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "name", valid_594313
  var valid_594314 = path.getOrDefault("subscriptionId")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "subscriptionId", valid_594314
  var valid_594315 = path.getOrDefault("deviceName")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "deviceName", valid_594315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594316 = query.getOrDefault("api-version")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "api-version", valid_594316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594317: Call_SharesGet_594309; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594317.validator(path, query, header, formData, body)
  let scheme = call_594317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594317.url(scheme.get, call_594317.host, call_594317.base,
                         call_594317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594317, url, valid)

proc call*(call_594318: Call_SharesGet_594309; resourceGroupName: string;
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
  var path_594319 = newJObject()
  var query_594320 = newJObject()
  add(path_594319, "resourceGroupName", newJString(resourceGroupName))
  add(query_594320, "api-version", newJString(apiVersion))
  add(path_594319, "name", newJString(name))
  add(path_594319, "subscriptionId", newJString(subscriptionId))
  add(path_594319, "deviceName", newJString(deviceName))
  result = call_594318.call(path_594319, query_594320, nil, nil, nil)

var sharesGet* = Call_SharesGet_594309(name: "sharesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares/{name}",
                                    validator: validate_SharesGet_594310,
                                    base: "", url: url_SharesGet_594311,
                                    schemes: {Scheme.Https})
type
  Call_SharesDelete_594335 = ref object of OpenApiRestCall_593437
proc url_SharesDelete_594337(protocol: Scheme; host: string; base: string;
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

proc validate_SharesDelete_594336(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594338 = path.getOrDefault("resourceGroupName")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "resourceGroupName", valid_594338
  var valid_594339 = path.getOrDefault("name")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "name", valid_594339
  var valid_594340 = path.getOrDefault("subscriptionId")
  valid_594340 = validateParameter(valid_594340, JString, required = true,
                                 default = nil)
  if valid_594340 != nil:
    section.add "subscriptionId", valid_594340
  var valid_594341 = path.getOrDefault("deviceName")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "deviceName", valid_594341
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594342 = query.getOrDefault("api-version")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "api-version", valid_594342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594343: Call_SharesDelete_594335; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the share on the data box edge/gateway device.
  ## 
  let valid = call_594343.validator(path, query, header, formData, body)
  let scheme = call_594343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594343.url(scheme.get, call_594343.host, call_594343.base,
                         call_594343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594343, url, valid)

proc call*(call_594344: Call_SharesDelete_594335; resourceGroupName: string;
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
  var path_594345 = newJObject()
  var query_594346 = newJObject()
  add(path_594345, "resourceGroupName", newJString(resourceGroupName))
  add(query_594346, "api-version", newJString(apiVersion))
  add(path_594345, "name", newJString(name))
  add(path_594345, "subscriptionId", newJString(subscriptionId))
  add(path_594345, "deviceName", newJString(deviceName))
  result = call_594344.call(path_594345, query_594346, nil, nil, nil)

var sharesDelete* = Call_SharesDelete_594335(name: "sharesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares/{name}",
    validator: validate_SharesDelete_594336, base: "", url: url_SharesDelete_594337,
    schemes: {Scheme.Https})
type
  Call_SharesRefresh_594347 = ref object of OpenApiRestCall_593437
proc url_SharesRefresh_594349(protocol: Scheme; host: string; base: string;
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

proc validate_SharesRefresh_594348(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594350 = path.getOrDefault("resourceGroupName")
  valid_594350 = validateParameter(valid_594350, JString, required = true,
                                 default = nil)
  if valid_594350 != nil:
    section.add "resourceGroupName", valid_594350
  var valid_594351 = path.getOrDefault("name")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "name", valid_594351
  var valid_594352 = path.getOrDefault("subscriptionId")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "subscriptionId", valid_594352
  var valid_594353 = path.getOrDefault("deviceName")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "deviceName", valid_594353
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594354 = query.getOrDefault("api-version")
  valid_594354 = validateParameter(valid_594354, JString, required = true,
                                 default = nil)
  if valid_594354 != nil:
    section.add "api-version", valid_594354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594355: Call_SharesRefresh_594347; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594355.validator(path, query, header, formData, body)
  let scheme = call_594355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594355.url(scheme.get, call_594355.host, call_594355.base,
                         call_594355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594355, url, valid)

proc call*(call_594356: Call_SharesRefresh_594347; resourceGroupName: string;
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
  var path_594357 = newJObject()
  var query_594358 = newJObject()
  add(path_594357, "resourceGroupName", newJString(resourceGroupName))
  add(query_594358, "api-version", newJString(apiVersion))
  add(path_594357, "name", newJString(name))
  add(path_594357, "subscriptionId", newJString(subscriptionId))
  add(path_594357, "deviceName", newJString(deviceName))
  result = call_594356.call(path_594357, query_594358, nil, nil, nil)

var sharesRefresh* = Call_SharesRefresh_594347(name: "sharesRefresh",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/shares/{name}/refresh",
    validator: validate_SharesRefresh_594348, base: "", url: url_SharesRefresh_594349,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsListByDataBoxEdgeDevice_594359 = ref object of OpenApiRestCall_593437
proc url_StorageAccountCredentialsListByDataBoxEdgeDevice_594361(
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

proc validate_StorageAccountCredentialsListByDataBoxEdgeDevice_594360(
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
  var valid_594362 = path.getOrDefault("resourceGroupName")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "resourceGroupName", valid_594362
  var valid_594363 = path.getOrDefault("subscriptionId")
  valid_594363 = validateParameter(valid_594363, JString, required = true,
                                 default = nil)
  if valid_594363 != nil:
    section.add "subscriptionId", valid_594363
  var valid_594364 = path.getOrDefault("deviceName")
  valid_594364 = validateParameter(valid_594364, JString, required = true,
                                 default = nil)
  if valid_594364 != nil:
    section.add "deviceName", valid_594364
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594365 = query.getOrDefault("api-version")
  valid_594365 = validateParameter(valid_594365, JString, required = true,
                                 default = nil)
  if valid_594365 != nil:
    section.add "api-version", valid_594365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594366: Call_StorageAccountCredentialsListByDataBoxEdgeDevice_594359;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_594366.validator(path, query, header, formData, body)
  let scheme = call_594366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594366.url(scheme.get, call_594366.host, call_594366.base,
                         call_594366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594366, url, valid)

proc call*(call_594367: Call_StorageAccountCredentialsListByDataBoxEdgeDevice_594359;
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
  var path_594368 = newJObject()
  var query_594369 = newJObject()
  add(path_594368, "resourceGroupName", newJString(resourceGroupName))
  add(query_594369, "api-version", newJString(apiVersion))
  add(path_594368, "subscriptionId", newJString(subscriptionId))
  add(path_594368, "deviceName", newJString(deviceName))
  result = call_594367.call(path_594368, query_594369, nil, nil, nil)

var storageAccountCredentialsListByDataBoxEdgeDevice* = Call_StorageAccountCredentialsListByDataBoxEdgeDevice_594359(
    name: "storageAccountCredentialsListByDataBoxEdgeDevice",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/storageAccountCredentials",
    validator: validate_StorageAccountCredentialsListByDataBoxEdgeDevice_594360,
    base: "", url: url_StorageAccountCredentialsListByDataBoxEdgeDevice_594361,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsCreateOrUpdate_594382 = ref object of OpenApiRestCall_593437
proc url_StorageAccountCredentialsCreateOrUpdate_594384(protocol: Scheme;
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

proc validate_StorageAccountCredentialsCreateOrUpdate_594383(path: JsonNode;
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
  var valid_594385 = path.getOrDefault("resourceGroupName")
  valid_594385 = validateParameter(valid_594385, JString, required = true,
                                 default = nil)
  if valid_594385 != nil:
    section.add "resourceGroupName", valid_594385
  var valid_594386 = path.getOrDefault("name")
  valid_594386 = validateParameter(valid_594386, JString, required = true,
                                 default = nil)
  if valid_594386 != nil:
    section.add "name", valid_594386
  var valid_594387 = path.getOrDefault("subscriptionId")
  valid_594387 = validateParameter(valid_594387, JString, required = true,
                                 default = nil)
  if valid_594387 != nil:
    section.add "subscriptionId", valid_594387
  var valid_594388 = path.getOrDefault("deviceName")
  valid_594388 = validateParameter(valid_594388, JString, required = true,
                                 default = nil)
  if valid_594388 != nil:
    section.add "deviceName", valid_594388
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594389 = query.getOrDefault("api-version")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "api-version", valid_594389
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

proc call*(call_594391: Call_StorageAccountCredentialsCreateOrUpdate_594382;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the storage account credential.
  ## 
  let valid = call_594391.validator(path, query, header, formData, body)
  let scheme = call_594391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594391.url(scheme.get, call_594391.host, call_594391.base,
                         call_594391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594391, url, valid)

proc call*(call_594392: Call_StorageAccountCredentialsCreateOrUpdate_594382;
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
  var path_594393 = newJObject()
  var query_594394 = newJObject()
  var body_594395 = newJObject()
  add(path_594393, "resourceGroupName", newJString(resourceGroupName))
  add(query_594394, "api-version", newJString(apiVersion))
  add(path_594393, "name", newJString(name))
  add(path_594393, "subscriptionId", newJString(subscriptionId))
  if storageAccountCredential != nil:
    body_594395 = storageAccountCredential
  add(path_594393, "deviceName", newJString(deviceName))
  result = call_594392.call(path_594393, query_594394, nil, nil, body_594395)

var storageAccountCredentialsCreateOrUpdate* = Call_StorageAccountCredentialsCreateOrUpdate_594382(
    name: "storageAccountCredentialsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/storageAccountCredentials/{name}",
    validator: validate_StorageAccountCredentialsCreateOrUpdate_594383, base: "",
    url: url_StorageAccountCredentialsCreateOrUpdate_594384,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsGet_594370 = ref object of OpenApiRestCall_593437
proc url_StorageAccountCredentialsGet_594372(protocol: Scheme; host: string;
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

proc validate_StorageAccountCredentialsGet_594371(path: JsonNode; query: JsonNode;
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
  var valid_594373 = path.getOrDefault("resourceGroupName")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "resourceGroupName", valid_594373
  var valid_594374 = path.getOrDefault("name")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = nil)
  if valid_594374 != nil:
    section.add "name", valid_594374
  var valid_594375 = path.getOrDefault("subscriptionId")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "subscriptionId", valid_594375
  var valid_594376 = path.getOrDefault("deviceName")
  valid_594376 = validateParameter(valid_594376, JString, required = true,
                                 default = nil)
  if valid_594376 != nil:
    section.add "deviceName", valid_594376
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594377 = query.getOrDefault("api-version")
  valid_594377 = validateParameter(valid_594377, JString, required = true,
                                 default = nil)
  if valid_594377 != nil:
    section.add "api-version", valid_594377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594378: Call_StorageAccountCredentialsGet_594370; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified storage account credential.
  ## 
  let valid = call_594378.validator(path, query, header, formData, body)
  let scheme = call_594378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594378.url(scheme.get, call_594378.host, call_594378.base,
                         call_594378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594378, url, valid)

proc call*(call_594379: Call_StorageAccountCredentialsGet_594370;
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
  var path_594380 = newJObject()
  var query_594381 = newJObject()
  add(path_594380, "resourceGroupName", newJString(resourceGroupName))
  add(query_594381, "api-version", newJString(apiVersion))
  add(path_594380, "name", newJString(name))
  add(path_594380, "subscriptionId", newJString(subscriptionId))
  add(path_594380, "deviceName", newJString(deviceName))
  result = call_594379.call(path_594380, query_594381, nil, nil, nil)

var storageAccountCredentialsGet* = Call_StorageAccountCredentialsGet_594370(
    name: "storageAccountCredentialsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/storageAccountCredentials/{name}",
    validator: validate_StorageAccountCredentialsGet_594371, base: "",
    url: url_StorageAccountCredentialsGet_594372, schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsDelete_594396 = ref object of OpenApiRestCall_593437
proc url_StorageAccountCredentialsDelete_594398(protocol: Scheme; host: string;
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

proc validate_StorageAccountCredentialsDelete_594397(path: JsonNode;
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
  var valid_594399 = path.getOrDefault("resourceGroupName")
  valid_594399 = validateParameter(valid_594399, JString, required = true,
                                 default = nil)
  if valid_594399 != nil:
    section.add "resourceGroupName", valid_594399
  var valid_594400 = path.getOrDefault("name")
  valid_594400 = validateParameter(valid_594400, JString, required = true,
                                 default = nil)
  if valid_594400 != nil:
    section.add "name", valid_594400
  var valid_594401 = path.getOrDefault("subscriptionId")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = nil)
  if valid_594401 != nil:
    section.add "subscriptionId", valid_594401
  var valid_594402 = path.getOrDefault("deviceName")
  valid_594402 = validateParameter(valid_594402, JString, required = true,
                                 default = nil)
  if valid_594402 != nil:
    section.add "deviceName", valid_594402
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594403 = query.getOrDefault("api-version")
  valid_594403 = validateParameter(valid_594403, JString, required = true,
                                 default = nil)
  if valid_594403 != nil:
    section.add "api-version", valid_594403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594404: Call_StorageAccountCredentialsDelete_594396;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the storage account credential.
  ## 
  let valid = call_594404.validator(path, query, header, formData, body)
  let scheme = call_594404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594404.url(scheme.get, call_594404.host, call_594404.base,
                         call_594404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594404, url, valid)

proc call*(call_594405: Call_StorageAccountCredentialsDelete_594396;
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
  var path_594406 = newJObject()
  var query_594407 = newJObject()
  add(path_594406, "resourceGroupName", newJString(resourceGroupName))
  add(query_594407, "api-version", newJString(apiVersion))
  add(path_594406, "name", newJString(name))
  add(path_594406, "subscriptionId", newJString(subscriptionId))
  add(path_594406, "deviceName", newJString(deviceName))
  result = call_594405.call(path_594406, query_594407, nil, nil, nil)

var storageAccountCredentialsDelete* = Call_StorageAccountCredentialsDelete_594396(
    name: "storageAccountCredentialsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/storageAccountCredentials/{name}",
    validator: validate_StorageAccountCredentialsDelete_594397, base: "",
    url: url_StorageAccountCredentialsDelete_594398, schemes: {Scheme.Https})
type
  Call_TriggersListByDataBoxEdgeDevice_594408 = ref object of OpenApiRestCall_593437
proc url_TriggersListByDataBoxEdgeDevice_594410(protocol: Scheme; host: string;
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

proc validate_TriggersListByDataBoxEdgeDevice_594409(path: JsonNode;
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
  var valid_594411 = path.getOrDefault("resourceGroupName")
  valid_594411 = validateParameter(valid_594411, JString, required = true,
                                 default = nil)
  if valid_594411 != nil:
    section.add "resourceGroupName", valid_594411
  var valid_594412 = path.getOrDefault("subscriptionId")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "subscriptionId", valid_594412
  var valid_594413 = path.getOrDefault("deviceName")
  valid_594413 = validateParameter(valid_594413, JString, required = true,
                                 default = nil)
  if valid_594413 != nil:
    section.add "deviceName", valid_594413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $expand: JString
  ##          : Specify $filter='CustomContextTag eq <tag>' to filter on custom context tag property
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594414 = query.getOrDefault("api-version")
  valid_594414 = validateParameter(valid_594414, JString, required = true,
                                 default = nil)
  if valid_594414 != nil:
    section.add "api-version", valid_594414
  var valid_594415 = query.getOrDefault("$expand")
  valid_594415 = validateParameter(valid_594415, JString, required = false,
                                 default = nil)
  if valid_594415 != nil:
    section.add "$expand", valid_594415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594416: Call_TriggersListByDataBoxEdgeDevice_594408;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the triggers configured in the device.
  ## 
  let valid = call_594416.validator(path, query, header, formData, body)
  let scheme = call_594416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594416.url(scheme.get, call_594416.host, call_594416.base,
                         call_594416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594416, url, valid)

proc call*(call_594417: Call_TriggersListByDataBoxEdgeDevice_594408;
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
  var path_594418 = newJObject()
  var query_594419 = newJObject()
  add(path_594418, "resourceGroupName", newJString(resourceGroupName))
  add(query_594419, "api-version", newJString(apiVersion))
  add(query_594419, "$expand", newJString(Expand))
  add(path_594418, "subscriptionId", newJString(subscriptionId))
  add(path_594418, "deviceName", newJString(deviceName))
  result = call_594417.call(path_594418, query_594419, nil, nil, nil)

var triggersListByDataBoxEdgeDevice* = Call_TriggersListByDataBoxEdgeDevice_594408(
    name: "triggersListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/triggers",
    validator: validate_TriggersListByDataBoxEdgeDevice_594409, base: "",
    url: url_TriggersListByDataBoxEdgeDevice_594410, schemes: {Scheme.Https})
type
  Call_TriggersCreateOrUpdate_594432 = ref object of OpenApiRestCall_593437
proc url_TriggersCreateOrUpdate_594434(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersCreateOrUpdate_594433(path: JsonNode; query: JsonNode;
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
  var valid_594435 = path.getOrDefault("resourceGroupName")
  valid_594435 = validateParameter(valid_594435, JString, required = true,
                                 default = nil)
  if valid_594435 != nil:
    section.add "resourceGroupName", valid_594435
  var valid_594436 = path.getOrDefault("name")
  valid_594436 = validateParameter(valid_594436, JString, required = true,
                                 default = nil)
  if valid_594436 != nil:
    section.add "name", valid_594436
  var valid_594437 = path.getOrDefault("subscriptionId")
  valid_594437 = validateParameter(valid_594437, JString, required = true,
                                 default = nil)
  if valid_594437 != nil:
    section.add "subscriptionId", valid_594437
  var valid_594438 = path.getOrDefault("deviceName")
  valid_594438 = validateParameter(valid_594438, JString, required = true,
                                 default = nil)
  if valid_594438 != nil:
    section.add "deviceName", valid_594438
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594439 = query.getOrDefault("api-version")
  valid_594439 = validateParameter(valid_594439, JString, required = true,
                                 default = nil)
  if valid_594439 != nil:
    section.add "api-version", valid_594439
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

proc call*(call_594441: Call_TriggersCreateOrUpdate_594432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a trigger.
  ## 
  let valid = call_594441.validator(path, query, header, formData, body)
  let scheme = call_594441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594441.url(scheme.get, call_594441.host, call_594441.base,
                         call_594441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594441, url, valid)

proc call*(call_594442: Call_TriggersCreateOrUpdate_594432;
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
  var path_594443 = newJObject()
  var query_594444 = newJObject()
  var body_594445 = newJObject()
  add(path_594443, "resourceGroupName", newJString(resourceGroupName))
  add(query_594444, "api-version", newJString(apiVersion))
  add(path_594443, "name", newJString(name))
  add(path_594443, "subscriptionId", newJString(subscriptionId))
  if trigger != nil:
    body_594445 = trigger
  add(path_594443, "deviceName", newJString(deviceName))
  result = call_594442.call(path_594443, query_594444, nil, nil, body_594445)

var triggersCreateOrUpdate* = Call_TriggersCreateOrUpdate_594432(
    name: "triggersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/triggers/{name}",
    validator: validate_TriggersCreateOrUpdate_594433, base: "",
    url: url_TriggersCreateOrUpdate_594434, schemes: {Scheme.Https})
type
  Call_TriggersGet_594420 = ref object of OpenApiRestCall_593437
proc url_TriggersGet_594422(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersGet_594421(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594423 = path.getOrDefault("resourceGroupName")
  valid_594423 = validateParameter(valid_594423, JString, required = true,
                                 default = nil)
  if valid_594423 != nil:
    section.add "resourceGroupName", valid_594423
  var valid_594424 = path.getOrDefault("name")
  valid_594424 = validateParameter(valid_594424, JString, required = true,
                                 default = nil)
  if valid_594424 != nil:
    section.add "name", valid_594424
  var valid_594425 = path.getOrDefault("subscriptionId")
  valid_594425 = validateParameter(valid_594425, JString, required = true,
                                 default = nil)
  if valid_594425 != nil:
    section.add "subscriptionId", valid_594425
  var valid_594426 = path.getOrDefault("deviceName")
  valid_594426 = validateParameter(valid_594426, JString, required = true,
                                 default = nil)
  if valid_594426 != nil:
    section.add "deviceName", valid_594426
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594427 = query.getOrDefault("api-version")
  valid_594427 = validateParameter(valid_594427, JString, required = true,
                                 default = nil)
  if valid_594427 != nil:
    section.add "api-version", valid_594427
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594428: Call_TriggersGet_594420; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific trigger by name.
  ## 
  let valid = call_594428.validator(path, query, header, formData, body)
  let scheme = call_594428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594428.url(scheme.get, call_594428.host, call_594428.base,
                         call_594428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594428, url, valid)

proc call*(call_594429: Call_TriggersGet_594420; resourceGroupName: string;
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
  var path_594430 = newJObject()
  var query_594431 = newJObject()
  add(path_594430, "resourceGroupName", newJString(resourceGroupName))
  add(query_594431, "api-version", newJString(apiVersion))
  add(path_594430, "name", newJString(name))
  add(path_594430, "subscriptionId", newJString(subscriptionId))
  add(path_594430, "deviceName", newJString(deviceName))
  result = call_594429.call(path_594430, query_594431, nil, nil, nil)

var triggersGet* = Call_TriggersGet_594420(name: "triggersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/triggers/{name}",
                                        validator: validate_TriggersGet_594421,
                                        base: "", url: url_TriggersGet_594422,
                                        schemes: {Scheme.Https})
type
  Call_TriggersDelete_594446 = ref object of OpenApiRestCall_593437
proc url_TriggersDelete_594448(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersDelete_594447(path: JsonNode; query: JsonNode;
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
  var valid_594449 = path.getOrDefault("resourceGroupName")
  valid_594449 = validateParameter(valid_594449, JString, required = true,
                                 default = nil)
  if valid_594449 != nil:
    section.add "resourceGroupName", valid_594449
  var valid_594450 = path.getOrDefault("name")
  valid_594450 = validateParameter(valid_594450, JString, required = true,
                                 default = nil)
  if valid_594450 != nil:
    section.add "name", valid_594450
  var valid_594451 = path.getOrDefault("subscriptionId")
  valid_594451 = validateParameter(valid_594451, JString, required = true,
                                 default = nil)
  if valid_594451 != nil:
    section.add "subscriptionId", valid_594451
  var valid_594452 = path.getOrDefault("deviceName")
  valid_594452 = validateParameter(valid_594452, JString, required = true,
                                 default = nil)
  if valid_594452 != nil:
    section.add "deviceName", valid_594452
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594453 = query.getOrDefault("api-version")
  valid_594453 = validateParameter(valid_594453, JString, required = true,
                                 default = nil)
  if valid_594453 != nil:
    section.add "api-version", valid_594453
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594454: Call_TriggersDelete_594446; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the trigger on the gateway device.
  ## 
  let valid = call_594454.validator(path, query, header, formData, body)
  let scheme = call_594454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594454.url(scheme.get, call_594454.host, call_594454.base,
                         call_594454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594454, url, valid)

proc call*(call_594455: Call_TriggersDelete_594446; resourceGroupName: string;
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
  var path_594456 = newJObject()
  var query_594457 = newJObject()
  add(path_594456, "resourceGroupName", newJString(resourceGroupName))
  add(query_594457, "api-version", newJString(apiVersion))
  add(path_594456, "name", newJString(name))
  add(path_594456, "subscriptionId", newJString(subscriptionId))
  add(path_594456, "deviceName", newJString(deviceName))
  result = call_594455.call(path_594456, query_594457, nil, nil, nil)

var triggersDelete* = Call_TriggersDelete_594446(name: "triggersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/triggers/{name}",
    validator: validate_TriggersDelete_594447, base: "", url: url_TriggersDelete_594448,
    schemes: {Scheme.Https})
type
  Call_DevicesGetUpdateSummary_594458 = ref object of OpenApiRestCall_593437
proc url_DevicesGetUpdateSummary_594460(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesGetUpdateSummary_594459(path: JsonNode; query: JsonNode;
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
  var valid_594461 = path.getOrDefault("resourceGroupName")
  valid_594461 = validateParameter(valid_594461, JString, required = true,
                                 default = nil)
  if valid_594461 != nil:
    section.add "resourceGroupName", valid_594461
  var valid_594462 = path.getOrDefault("subscriptionId")
  valid_594462 = validateParameter(valid_594462, JString, required = true,
                                 default = nil)
  if valid_594462 != nil:
    section.add "subscriptionId", valid_594462
  var valid_594463 = path.getOrDefault("deviceName")
  valid_594463 = validateParameter(valid_594463, JString, required = true,
                                 default = nil)
  if valid_594463 != nil:
    section.add "deviceName", valid_594463
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594464 = query.getOrDefault("api-version")
  valid_594464 = validateParameter(valid_594464, JString, required = true,
                                 default = nil)
  if valid_594464 != nil:
    section.add "api-version", valid_594464
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594465: Call_DevicesGetUpdateSummary_594458; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594465.validator(path, query, header, formData, body)
  let scheme = call_594465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594465.url(scheme.get, call_594465.host, call_594465.base,
                         call_594465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594465, url, valid)

proc call*(call_594466: Call_DevicesGetUpdateSummary_594458;
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
  var path_594467 = newJObject()
  var query_594468 = newJObject()
  add(path_594467, "resourceGroupName", newJString(resourceGroupName))
  add(query_594468, "api-version", newJString(apiVersion))
  add(path_594467, "subscriptionId", newJString(subscriptionId))
  add(path_594467, "deviceName", newJString(deviceName))
  result = call_594466.call(path_594467, query_594468, nil, nil, nil)

var devicesGetUpdateSummary* = Call_DevicesGetUpdateSummary_594458(
    name: "devicesGetUpdateSummary", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/updateSummary/default",
    validator: validate_DevicesGetUpdateSummary_594459, base: "",
    url: url_DevicesGetUpdateSummary_594460, schemes: {Scheme.Https})
type
  Call_DevicesUploadCertificate_594469 = ref object of OpenApiRestCall_593437
proc url_DevicesUploadCertificate_594471(protocol: Scheme; host: string;
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

proc validate_DevicesUploadCertificate_594470(path: JsonNode; query: JsonNode;
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
  var valid_594472 = path.getOrDefault("resourceGroupName")
  valid_594472 = validateParameter(valid_594472, JString, required = true,
                                 default = nil)
  if valid_594472 != nil:
    section.add "resourceGroupName", valid_594472
  var valid_594473 = path.getOrDefault("subscriptionId")
  valid_594473 = validateParameter(valid_594473, JString, required = true,
                                 default = nil)
  if valid_594473 != nil:
    section.add "subscriptionId", valid_594473
  var valid_594474 = path.getOrDefault("deviceName")
  valid_594474 = validateParameter(valid_594474, JString, required = true,
                                 default = nil)
  if valid_594474 != nil:
    section.add "deviceName", valid_594474
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594475 = query.getOrDefault("api-version")
  valid_594475 = validateParameter(valid_594475, JString, required = true,
                                 default = nil)
  if valid_594475 != nil:
    section.add "api-version", valid_594475
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

proc call*(call_594477: Call_DevicesUploadCertificate_594469; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads registration certificate for the device.
  ## 
  let valid = call_594477.validator(path, query, header, formData, body)
  let scheme = call_594477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594477.url(scheme.get, call_594477.host, call_594477.base,
                         call_594477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594477, url, valid)

proc call*(call_594478: Call_DevicesUploadCertificate_594469;
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
  var path_594479 = newJObject()
  var query_594480 = newJObject()
  var body_594481 = newJObject()
  add(path_594479, "resourceGroupName", newJString(resourceGroupName))
  add(query_594480, "api-version", newJString(apiVersion))
  add(path_594479, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594481 = parameters
  add(path_594479, "deviceName", newJString(deviceName))
  result = call_594478.call(path_594479, query_594480, nil, nil, body_594481)

var devicesUploadCertificate* = Call_DevicesUploadCertificate_594469(
    name: "devicesUploadCertificate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/uploadCertificate",
    validator: validate_DevicesUploadCertificate_594470, base: "",
    url: url_DevicesUploadCertificate_594471, schemes: {Scheme.Https})
type
  Call_UsersListByDataBoxEdgeDevice_594482 = ref object of OpenApiRestCall_593437
proc url_UsersListByDataBoxEdgeDevice_594484(protocol: Scheme; host: string;
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

proc validate_UsersListByDataBoxEdgeDevice_594483(path: JsonNode; query: JsonNode;
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
  var valid_594485 = path.getOrDefault("resourceGroupName")
  valid_594485 = validateParameter(valid_594485, JString, required = true,
                                 default = nil)
  if valid_594485 != nil:
    section.add "resourceGroupName", valid_594485
  var valid_594486 = path.getOrDefault("subscriptionId")
  valid_594486 = validateParameter(valid_594486, JString, required = true,
                                 default = nil)
  if valid_594486 != nil:
    section.add "subscriptionId", valid_594486
  var valid_594487 = path.getOrDefault("deviceName")
  valid_594487 = validateParameter(valid_594487, JString, required = true,
                                 default = nil)
  if valid_594487 != nil:
    section.add "deviceName", valid_594487
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594488 = query.getOrDefault("api-version")
  valid_594488 = validateParameter(valid_594488, JString, required = true,
                                 default = nil)
  if valid_594488 != nil:
    section.add "api-version", valid_594488
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594489: Call_UsersListByDataBoxEdgeDevice_594482; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the users registered on a data box edge/gateway device.
  ## 
  let valid = call_594489.validator(path, query, header, formData, body)
  let scheme = call_594489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594489.url(scheme.get, call_594489.host, call_594489.base,
                         call_594489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594489, url, valid)

proc call*(call_594490: Call_UsersListByDataBoxEdgeDevice_594482;
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
  var path_594491 = newJObject()
  var query_594492 = newJObject()
  add(path_594491, "resourceGroupName", newJString(resourceGroupName))
  add(query_594492, "api-version", newJString(apiVersion))
  add(path_594491, "subscriptionId", newJString(subscriptionId))
  add(path_594491, "deviceName", newJString(deviceName))
  result = call_594490.call(path_594491, query_594492, nil, nil, nil)

var usersListByDataBoxEdgeDevice* = Call_UsersListByDataBoxEdgeDevice_594482(
    name: "usersListByDataBoxEdgeDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/users",
    validator: validate_UsersListByDataBoxEdgeDevice_594483, base: "",
    url: url_UsersListByDataBoxEdgeDevice_594484, schemes: {Scheme.Https})
type
  Call_UsersCreateOrUpdate_594505 = ref object of OpenApiRestCall_593437
proc url_UsersCreateOrUpdate_594507(protocol: Scheme; host: string; base: string;
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

proc validate_UsersCreateOrUpdate_594506(path: JsonNode; query: JsonNode;
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
  var valid_594508 = path.getOrDefault("resourceGroupName")
  valid_594508 = validateParameter(valid_594508, JString, required = true,
                                 default = nil)
  if valid_594508 != nil:
    section.add "resourceGroupName", valid_594508
  var valid_594509 = path.getOrDefault("name")
  valid_594509 = validateParameter(valid_594509, JString, required = true,
                                 default = nil)
  if valid_594509 != nil:
    section.add "name", valid_594509
  var valid_594510 = path.getOrDefault("subscriptionId")
  valid_594510 = validateParameter(valid_594510, JString, required = true,
                                 default = nil)
  if valid_594510 != nil:
    section.add "subscriptionId", valid_594510
  var valid_594511 = path.getOrDefault("deviceName")
  valid_594511 = validateParameter(valid_594511, JString, required = true,
                                 default = nil)
  if valid_594511 != nil:
    section.add "deviceName", valid_594511
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594512 = query.getOrDefault("api-version")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "api-version", valid_594512
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

proc call*(call_594514: Call_UsersCreateOrUpdate_594505; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new user or updates an existing user's information on a data box edge/gateway device.
  ## 
  let valid = call_594514.validator(path, query, header, formData, body)
  let scheme = call_594514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594514.url(scheme.get, call_594514.host, call_594514.base,
                         call_594514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594514, url, valid)

proc call*(call_594515: Call_UsersCreateOrUpdate_594505; resourceGroupName: string;
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
  var path_594516 = newJObject()
  var query_594517 = newJObject()
  var body_594518 = newJObject()
  add(path_594516, "resourceGroupName", newJString(resourceGroupName))
  add(query_594517, "api-version", newJString(apiVersion))
  add(path_594516, "name", newJString(name))
  if user != nil:
    body_594518 = user
  add(path_594516, "subscriptionId", newJString(subscriptionId))
  add(path_594516, "deviceName", newJString(deviceName))
  result = call_594515.call(path_594516, query_594517, nil, nil, body_594518)

var usersCreateOrUpdate* = Call_UsersCreateOrUpdate_594505(
    name: "usersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/users/{name}",
    validator: validate_UsersCreateOrUpdate_594506, base: "",
    url: url_UsersCreateOrUpdate_594507, schemes: {Scheme.Https})
type
  Call_UsersGet_594493 = ref object of OpenApiRestCall_593437
proc url_UsersGet_594495(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsersGet_594494(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594496 = path.getOrDefault("resourceGroupName")
  valid_594496 = validateParameter(valid_594496, JString, required = true,
                                 default = nil)
  if valid_594496 != nil:
    section.add "resourceGroupName", valid_594496
  var valid_594497 = path.getOrDefault("name")
  valid_594497 = validateParameter(valid_594497, JString, required = true,
                                 default = nil)
  if valid_594497 != nil:
    section.add "name", valid_594497
  var valid_594498 = path.getOrDefault("subscriptionId")
  valid_594498 = validateParameter(valid_594498, JString, required = true,
                                 default = nil)
  if valid_594498 != nil:
    section.add "subscriptionId", valid_594498
  var valid_594499 = path.getOrDefault("deviceName")
  valid_594499 = validateParameter(valid_594499, JString, required = true,
                                 default = nil)
  if valid_594499 != nil:
    section.add "deviceName", valid_594499
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594500 = query.getOrDefault("api-version")
  valid_594500 = validateParameter(valid_594500, JString, required = true,
                                 default = nil)
  if valid_594500 != nil:
    section.add "api-version", valid_594500
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594501: Call_UsersGet_594493; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified user.
  ## 
  let valid = call_594501.validator(path, query, header, formData, body)
  let scheme = call_594501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594501.url(scheme.get, call_594501.host, call_594501.base,
                         call_594501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594501, url, valid)

proc call*(call_594502: Call_UsersGet_594493; resourceGroupName: string;
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
  var path_594503 = newJObject()
  var query_594504 = newJObject()
  add(path_594503, "resourceGroupName", newJString(resourceGroupName))
  add(query_594504, "api-version", newJString(apiVersion))
  add(path_594503, "name", newJString(name))
  add(path_594503, "subscriptionId", newJString(subscriptionId))
  add(path_594503, "deviceName", newJString(deviceName))
  result = call_594502.call(path_594503, query_594504, nil, nil, nil)

var usersGet* = Call_UsersGet_594493(name: "usersGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/users/{name}",
                                  validator: validate_UsersGet_594494, base: "",
                                  url: url_UsersGet_594495,
                                  schemes: {Scheme.Https})
type
  Call_UsersDelete_594519 = ref object of OpenApiRestCall_593437
proc url_UsersDelete_594521(protocol: Scheme; host: string; base: string;
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

proc validate_UsersDelete_594520(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594522 = path.getOrDefault("resourceGroupName")
  valid_594522 = validateParameter(valid_594522, JString, required = true,
                                 default = nil)
  if valid_594522 != nil:
    section.add "resourceGroupName", valid_594522
  var valid_594523 = path.getOrDefault("name")
  valid_594523 = validateParameter(valid_594523, JString, required = true,
                                 default = nil)
  if valid_594523 != nil:
    section.add "name", valid_594523
  var valid_594524 = path.getOrDefault("subscriptionId")
  valid_594524 = validateParameter(valid_594524, JString, required = true,
                                 default = nil)
  if valid_594524 != nil:
    section.add "subscriptionId", valid_594524
  var valid_594525 = path.getOrDefault("deviceName")
  valid_594525 = validateParameter(valid_594525, JString, required = true,
                                 default = nil)
  if valid_594525 != nil:
    section.add "deviceName", valid_594525
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594526 = query.getOrDefault("api-version")
  valid_594526 = validateParameter(valid_594526, JString, required = true,
                                 default = nil)
  if valid_594526 != nil:
    section.add "api-version", valid_594526
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594527: Call_UsersDelete_594519; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the user on a databox edge/gateway device.
  ## 
  let valid = call_594527.validator(path, query, header, formData, body)
  let scheme = call_594527.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594527.url(scheme.get, call_594527.host, call_594527.base,
                         call_594527.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594527, url, valid)

proc call*(call_594528: Call_UsersDelete_594519; resourceGroupName: string;
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
  var path_594529 = newJObject()
  var query_594530 = newJObject()
  add(path_594529, "resourceGroupName", newJString(resourceGroupName))
  add(query_594530, "api-version", newJString(apiVersion))
  add(path_594529, "name", newJString(name))
  add(path_594529, "subscriptionId", newJString(subscriptionId))
  add(path_594529, "deviceName", newJString(deviceName))
  result = call_594528.call(path_594529, query_594530, nil, nil, nil)

var usersDelete* = Call_UsersDelete_594519(name: "usersDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataBoxEdge/dataBoxEdgeDevices/{deviceName}/users/{name}",
                                        validator: validate_UsersDelete_594520,
                                        base: "", url: url_UsersDelete_594521,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
