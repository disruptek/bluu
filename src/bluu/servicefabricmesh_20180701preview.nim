
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SeaBreezeManagementClient
## version: 2018-07-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## APIs to deploy and manage resources to SeaBreeze.
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

  OpenApiRestCall_567666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567666): Option[Scheme] {.used.} =
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
  macServiceName = "servicefabricmesh"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567888 = ref object of OpenApiRestCall_567666
proc url_OperationsList_567890(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567889(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all the available operations provided by Service Fabric SeaBreeze resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568062 = query.getOrDefault("api-version")
  valid_568062 = validateParameter(valid_568062, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568062 != nil:
    section.add "api-version", valid_568062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568085: Call_OperationsList_567888; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available operations provided by Service Fabric SeaBreeze resource provider.
  ## 
  let valid = call_568085.validator(path, query, header, formData, body)
  let scheme = call_568085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568085.url(scheme.get, call_568085.host, call_568085.base,
                         call_568085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568085, url, valid)

proc call*(call_568156: Call_OperationsList_567888;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## operationsList
  ## Lists all the available operations provided by Service Fabric SeaBreeze resource provider.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  var query_568157 = newJObject()
  add(query_568157, "api-version", newJString(apiVersion))
  result = call_568156.call(nil, query_568157, nil, nil, nil)

var operationsList* = Call_OperationsList_567888(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ServiceFabricMesh/operations",
    validator: validate_OperationsList_567889, base: "", url: url_OperationsList_567890,
    schemes: {Scheme.Https})
type
  Call_ApplicationListBySubscription_568197 = ref object of OpenApiRestCall_567666
proc url_ApplicationListBySubscription_568199(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.ServiceFabricMesh/applications")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationListBySubscription_568198(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all application resources in a given subscription. The information includes the information about the application's services and other runtime properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568214 = path.getOrDefault("subscriptionId")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "subscriptionId", valid_568214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568215 = query.getOrDefault("api-version")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568215 != nil:
    section.add "api-version", valid_568215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568216: Call_ApplicationListBySubscription_568197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all application resources in a given subscription. The information includes the information about the application's services and other runtime properties.
  ## 
  let valid = call_568216.validator(path, query, header, formData, body)
  let scheme = call_568216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568216.url(scheme.get, call_568216.host, call_568216.base,
                         call_568216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568216, url, valid)

proc call*(call_568217: Call_ApplicationListBySubscription_568197;
          subscriptionId: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## applicationListBySubscription
  ## Gets the information about all application resources in a given subscription. The information includes the information about the application's services and other runtime properties.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568218 = newJObject()
  var query_568219 = newJObject()
  add(query_568219, "api-version", newJString(apiVersion))
  add(path_568218, "subscriptionId", newJString(subscriptionId))
  result = call_568217.call(path_568218, query_568219, nil, nil, nil)

var applicationListBySubscription* = Call_ApplicationListBySubscription_568197(
    name: "applicationListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/applications",
    validator: validate_ApplicationListBySubscription_568198, base: "",
    url: url_ApplicationListBySubscription_568199, schemes: {Scheme.Https})
type
  Call_NetworkListBySubscription_568220 = ref object of OpenApiRestCall_567666
proc url_NetworkListBySubscription_568222(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.ServiceFabricMesh/networks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkListBySubscription_568221(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all network resources in a given subscription. The information includes the network description and other runtime properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568223 = path.getOrDefault("subscriptionId")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "subscriptionId", valid_568223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568224 = query.getOrDefault("api-version")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568224 != nil:
    section.add "api-version", valid_568224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568225: Call_NetworkListBySubscription_568220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all network resources in a given subscription. The information includes the network description and other runtime properties.
  ## 
  let valid = call_568225.validator(path, query, header, formData, body)
  let scheme = call_568225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568225.url(scheme.get, call_568225.host, call_568225.base,
                         call_568225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568225, url, valid)

proc call*(call_568226: Call_NetworkListBySubscription_568220;
          subscriptionId: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## networkListBySubscription
  ## Gets the information about all network resources in a given subscription. The information includes the network description and other runtime properties.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568227 = newJObject()
  var query_568228 = newJObject()
  add(query_568228, "api-version", newJString(apiVersion))
  add(path_568227, "subscriptionId", newJString(subscriptionId))
  result = call_568226.call(path_568227, query_568228, nil, nil, nil)

var networkListBySubscription* = Call_NetworkListBySubscription_568220(
    name: "networkListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/networks",
    validator: validate_NetworkListBySubscription_568221, base: "",
    url: url_NetworkListBySubscription_568222, schemes: {Scheme.Https})
type
  Call_VolumeListBySubscription_568229 = ref object of OpenApiRestCall_567666
proc url_VolumeListBySubscription_568231(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/volumes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeListBySubscription_568230(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all volume resources in a given subscription. The information includes the volume description and other runtime information.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568232 = path.getOrDefault("subscriptionId")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "subscriptionId", valid_568232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568233 = query.getOrDefault("api-version")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568233 != nil:
    section.add "api-version", valid_568233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568234: Call_VolumeListBySubscription_568229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all volume resources in a given subscription. The information includes the volume description and other runtime information.
  ## 
  ## 
  let valid = call_568234.validator(path, query, header, formData, body)
  let scheme = call_568234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568234.url(scheme.get, call_568234.host, call_568234.base,
                         call_568234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568234, url, valid)

proc call*(call_568235: Call_VolumeListBySubscription_568229;
          subscriptionId: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## volumeListBySubscription
  ## Gets the information about all volume resources in a given subscription. The information includes the volume description and other runtime information.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568236 = newJObject()
  var query_568237 = newJObject()
  add(query_568237, "api-version", newJString(apiVersion))
  add(path_568236, "subscriptionId", newJString(subscriptionId))
  result = call_568235.call(path_568236, query_568237, nil, nil, nil)

var volumeListBySubscription* = Call_VolumeListBySubscription_568229(
    name: "volumeListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/volumes",
    validator: validate_VolumeListBySubscription_568230, base: "",
    url: url_VolumeListBySubscription_568231, schemes: {Scheme.Https})
type
  Call_ApplicationListByResourceGroup_568238 = ref object of OpenApiRestCall_567666
proc url_ApplicationListByResourceGroup_568240(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.ServiceFabricMesh/applications")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationListByResourceGroup_568239(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all application resources in a given resource group. The information includes the information about the application's services and other runtime properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568241 = path.getOrDefault("resourceGroupName")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "resourceGroupName", valid_568241
  var valid_568242 = path.getOrDefault("subscriptionId")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "subscriptionId", valid_568242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568243 = query.getOrDefault("api-version")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568243 != nil:
    section.add "api-version", valid_568243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568244: Call_ApplicationListByResourceGroup_568238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all application resources in a given resource group. The information includes the information about the application's services and other runtime properties.
  ## 
  let valid = call_568244.validator(path, query, header, formData, body)
  let scheme = call_568244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568244.url(scheme.get, call_568244.host, call_568244.base,
                         call_568244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568244, url, valid)

proc call*(call_568245: Call_ApplicationListByResourceGroup_568238;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## applicationListByResourceGroup
  ## Gets the information about all application resources in a given resource group. The information includes the information about the application's services and other runtime properties.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568246 = newJObject()
  var query_568247 = newJObject()
  add(path_568246, "resourceGroupName", newJString(resourceGroupName))
  add(query_568247, "api-version", newJString(apiVersion))
  add(path_568246, "subscriptionId", newJString(subscriptionId))
  result = call_568245.call(path_568246, query_568247, nil, nil, nil)

var applicationListByResourceGroup* = Call_ApplicationListByResourceGroup_568238(
    name: "applicationListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications",
    validator: validate_ApplicationListByResourceGroup_568239, base: "",
    url: url_ApplicationListByResourceGroup_568240, schemes: {Scheme.Https})
type
  Call_ApplicationCreate_568259 = ref object of OpenApiRestCall_567666
proc url_ApplicationCreate_568261(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationCreate_568260(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates an application resource with the specified name and description. If an application with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## Use network resources to provide public connectivity to the services of an application.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568279 = path.getOrDefault("resourceGroupName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "resourceGroupName", valid_568279
  var valid_568280 = path.getOrDefault("applicationName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "applicationName", valid_568280
  var valid_568281 = path.getOrDefault("subscriptionId")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "subscriptionId", valid_568281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568282 = query.getOrDefault("api-version")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568282 != nil:
    section.add "api-version", valid_568282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   applicationResourceDescription: JObject (required)
  ##                                 : Description for creating an application resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568284: Call_ApplicationCreate_568259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an application resource with the specified name and description. If an application with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## Use network resources to provide public connectivity to the services of an application.
  ## 
  ## 
  let valid = call_568284.validator(path, query, header, formData, body)
  let scheme = call_568284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568284.url(scheme.get, call_568284.host, call_568284.base,
                         call_568284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568284, url, valid)

proc call*(call_568285: Call_ApplicationCreate_568259;
          applicationResourceDescription: JsonNode; resourceGroupName: string;
          applicationName: string; subscriptionId: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## applicationCreate
  ## Creates an application resource with the specified name and description. If an application with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## Use network resources to provide public connectivity to the services of an application.
  ## 
  ##   applicationResourceDescription: JObject (required)
  ##                                 : Description for creating an application resource.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568286 = newJObject()
  var query_568287 = newJObject()
  var body_568288 = newJObject()
  if applicationResourceDescription != nil:
    body_568288 = applicationResourceDescription
  add(path_568286, "resourceGroupName", newJString(resourceGroupName))
  add(query_568287, "api-version", newJString(apiVersion))
  add(path_568286, "applicationName", newJString(applicationName))
  add(path_568286, "subscriptionId", newJString(subscriptionId))
  result = call_568285.call(path_568286, query_568287, nil, nil, body_568288)

var applicationCreate* = Call_ApplicationCreate_568259(name: "applicationCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}",
    validator: validate_ApplicationCreate_568260, base: "",
    url: url_ApplicationCreate_568261, schemes: {Scheme.Https})
type
  Call_ApplicationGet_568248 = ref object of OpenApiRestCall_567666
proc url_ApplicationGet_568250(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGet_568249(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets the information about the application resource with a given name. The information includes the information about the application's services and other runtime properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568251 = path.getOrDefault("resourceGroupName")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "resourceGroupName", valid_568251
  var valid_568252 = path.getOrDefault("applicationName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "applicationName", valid_568252
  var valid_568253 = path.getOrDefault("subscriptionId")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "subscriptionId", valid_568253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568254 = query.getOrDefault("api-version")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568254 != nil:
    section.add "api-version", valid_568254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568255: Call_ApplicationGet_568248; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the application resource with a given name. The information includes the information about the application's services and other runtime properties.
  ## 
  let valid = call_568255.validator(path, query, header, formData, body)
  let scheme = call_568255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568255.url(scheme.get, call_568255.host, call_568255.base,
                         call_568255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568255, url, valid)

proc call*(call_568256: Call_ApplicationGet_568248; resourceGroupName: string;
          applicationName: string; subscriptionId: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## applicationGet
  ## Gets the information about the application resource with a given name. The information includes the information about the application's services and other runtime properties.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568257 = newJObject()
  var query_568258 = newJObject()
  add(path_568257, "resourceGroupName", newJString(resourceGroupName))
  add(query_568258, "api-version", newJString(apiVersion))
  add(path_568257, "applicationName", newJString(applicationName))
  add(path_568257, "subscriptionId", newJString(subscriptionId))
  result = call_568256.call(path_568257, query_568258, nil, nil, nil)

var applicationGet* = Call_ApplicationGet_568248(name: "applicationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}",
    validator: validate_ApplicationGet_568249, base: "", url: url_ApplicationGet_568250,
    schemes: {Scheme.Https})
type
  Call_ApplicationDelete_568289 = ref object of OpenApiRestCall_567666
proc url_ApplicationDelete_568291(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationDelete_568290(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes the application resource identified by the name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568292 = path.getOrDefault("resourceGroupName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "resourceGroupName", valid_568292
  var valid_568293 = path.getOrDefault("applicationName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "applicationName", valid_568293
  var valid_568294 = path.getOrDefault("subscriptionId")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "subscriptionId", valid_568294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568295 = query.getOrDefault("api-version")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568295 != nil:
    section.add "api-version", valid_568295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568296: Call_ApplicationDelete_568289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the application resource identified by the name.
  ## 
  let valid = call_568296.validator(path, query, header, formData, body)
  let scheme = call_568296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568296.url(scheme.get, call_568296.host, call_568296.base,
                         call_568296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568296, url, valid)

proc call*(call_568297: Call_ApplicationDelete_568289; resourceGroupName: string;
          applicationName: string; subscriptionId: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## applicationDelete
  ## Deletes the application resource identified by the name.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568298 = newJObject()
  var query_568299 = newJObject()
  add(path_568298, "resourceGroupName", newJString(resourceGroupName))
  add(query_568299, "api-version", newJString(apiVersion))
  add(path_568298, "applicationName", newJString(applicationName))
  add(path_568298, "subscriptionId", newJString(subscriptionId))
  result = call_568297.call(path_568298, query_568299, nil, nil, nil)

var applicationDelete* = Call_ApplicationDelete_568289(name: "applicationDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}",
    validator: validate_ApplicationDelete_568290, base: "",
    url: url_ApplicationDelete_568291, schemes: {Scheme.Https})
type
  Call_ServiceListByApplicationName_568300 = ref object of OpenApiRestCall_567666
proc url_ServiceListByApplicationName_568302(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceListByApplicationName_568301(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all services of a given service of an application. The information includes the runtime properties of the service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568303 = path.getOrDefault("resourceGroupName")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "resourceGroupName", valid_568303
  var valid_568304 = path.getOrDefault("applicationName")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "applicationName", valid_568304
  var valid_568305 = path.getOrDefault("subscriptionId")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "subscriptionId", valid_568305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568306 = query.getOrDefault("api-version")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568306 != nil:
    section.add "api-version", valid_568306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568307: Call_ServiceListByApplicationName_568300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all services of a given service of an application. The information includes the runtime properties of the service instance.
  ## 
  let valid = call_568307.validator(path, query, header, formData, body)
  let scheme = call_568307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568307.url(scheme.get, call_568307.host, call_568307.base,
                         call_568307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568307, url, valid)

proc call*(call_568308: Call_ServiceListByApplicationName_568300;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## serviceListByApplicationName
  ## Gets the information about all services of a given service of an application. The information includes the runtime properties of the service instance.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568309 = newJObject()
  var query_568310 = newJObject()
  add(path_568309, "resourceGroupName", newJString(resourceGroupName))
  add(query_568310, "api-version", newJString(apiVersion))
  add(path_568309, "applicationName", newJString(applicationName))
  add(path_568309, "subscriptionId", newJString(subscriptionId))
  result = call_568308.call(path_568309, query_568310, nil, nil, nil)

var serviceListByApplicationName* = Call_ServiceListByApplicationName_568300(
    name: "serviceListByApplicationName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}/services",
    validator: validate_ServiceListByApplicationName_568301, base: "",
    url: url_ServiceListByApplicationName_568302, schemes: {Scheme.Https})
type
  Call_ServiceGet_568311 = ref object of OpenApiRestCall_567666
proc url_ServiceGet_568313(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceGet_568312(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation returns the properties of the service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   serviceName: JString (required)
  ##              : The identity of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568314 = path.getOrDefault("resourceGroupName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "resourceGroupName", valid_568314
  var valid_568315 = path.getOrDefault("applicationName")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "applicationName", valid_568315
  var valid_568316 = path.getOrDefault("subscriptionId")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "subscriptionId", valid_568316
  var valid_568317 = path.getOrDefault("serviceName")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "serviceName", valid_568317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568318 = query.getOrDefault("api-version")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568318 != nil:
    section.add "api-version", valid_568318
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568319: Call_ServiceGet_568311; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation returns the properties of the service.
  ## 
  let valid = call_568319.validator(path, query, header, formData, body)
  let scheme = call_568319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568319.url(scheme.get, call_568319.host, call_568319.base,
                         call_568319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568319, url, valid)

proc call*(call_568320: Call_ServiceGet_568311; resourceGroupName: string;
          applicationName: string; subscriptionId: string; serviceName: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## serviceGet
  ## The operation returns the properties of the service.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   serviceName: string (required)
  ##              : The identity of the service.
  var path_568321 = newJObject()
  var query_568322 = newJObject()
  add(path_568321, "resourceGroupName", newJString(resourceGroupName))
  add(query_568322, "api-version", newJString(apiVersion))
  add(path_568321, "applicationName", newJString(applicationName))
  add(path_568321, "subscriptionId", newJString(subscriptionId))
  add(path_568321, "serviceName", newJString(serviceName))
  result = call_568320.call(path_568321, query_568322, nil, nil, nil)

var serviceGet* = Call_ServiceGet_568311(name: "serviceGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}/services/{serviceName}",
                                      validator: validate_ServiceGet_568312,
                                      base: "", url: url_ServiceGet_568313,
                                      schemes: {Scheme.Https})
type
  Call_ReplicaListByServiceName_568323 = ref object of OpenApiRestCall_567666
proc url_ReplicaListByServiceName_568325(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/replicas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicaListByServiceName_568324(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all replicas of a given service of an application. The information includes the runtime properties of the replica instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   serviceName: JString (required)
  ##              : The identity of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568326 = path.getOrDefault("resourceGroupName")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "resourceGroupName", valid_568326
  var valid_568327 = path.getOrDefault("applicationName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "applicationName", valid_568327
  var valid_568328 = path.getOrDefault("subscriptionId")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "subscriptionId", valid_568328
  var valid_568329 = path.getOrDefault("serviceName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "serviceName", valid_568329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568330 = query.getOrDefault("api-version")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568330 != nil:
    section.add "api-version", valid_568330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568331: Call_ReplicaListByServiceName_568323; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all replicas of a given service of an application. The information includes the runtime properties of the replica instance.
  ## 
  let valid = call_568331.validator(path, query, header, formData, body)
  let scheme = call_568331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568331.url(scheme.get, call_568331.host, call_568331.base,
                         call_568331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568331, url, valid)

proc call*(call_568332: Call_ReplicaListByServiceName_568323;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; serviceName: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## replicaListByServiceName
  ## Gets the information about all replicas of a given service of an application. The information includes the runtime properties of the replica instance.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   serviceName: string (required)
  ##              : The identity of the service.
  var path_568333 = newJObject()
  var query_568334 = newJObject()
  add(path_568333, "resourceGroupName", newJString(resourceGroupName))
  add(query_568334, "api-version", newJString(apiVersion))
  add(path_568333, "applicationName", newJString(applicationName))
  add(path_568333, "subscriptionId", newJString(subscriptionId))
  add(path_568333, "serviceName", newJString(serviceName))
  result = call_568332.call(path_568333, query_568334, nil, nil, nil)

var replicaListByServiceName* = Call_ReplicaListByServiceName_568323(
    name: "replicaListByServiceName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}/services/{serviceName}/replicas",
    validator: validate_ReplicaListByServiceName_568324, base: "",
    url: url_ReplicaListByServiceName_568325, schemes: {Scheme.Https})
type
  Call_ReplicaGet_568335 = ref object of OpenApiRestCall_567666
proc url_ReplicaGet_568337(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "replicaName" in path, "`replicaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/replicas/"),
               (kind: VariableSegment, value: "replicaName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicaGet_568336(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the specified replica of a given service of an application. The information includes the runtime properties of the replica instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   replicaName: JString (required)
  ##              : The identity of the service replica.
  ##   serviceName: JString (required)
  ##              : The identity of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568338 = path.getOrDefault("resourceGroupName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "resourceGroupName", valid_568338
  var valid_568339 = path.getOrDefault("applicationName")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "applicationName", valid_568339
  var valid_568340 = path.getOrDefault("subscriptionId")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "subscriptionId", valid_568340
  var valid_568341 = path.getOrDefault("replicaName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "replicaName", valid_568341
  var valid_568342 = path.getOrDefault("serviceName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "serviceName", valid_568342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568343 = query.getOrDefault("api-version")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568343 != nil:
    section.add "api-version", valid_568343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568344: Call_ReplicaGet_568335; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the specified replica of a given service of an application. The information includes the runtime properties of the replica instance.
  ## 
  let valid = call_568344.validator(path, query, header, formData, body)
  let scheme = call_568344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568344.url(scheme.get, call_568344.host, call_568344.base,
                         call_568344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568344, url, valid)

proc call*(call_568345: Call_ReplicaGet_568335; resourceGroupName: string;
          applicationName: string; subscriptionId: string; replicaName: string;
          serviceName: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## replicaGet
  ## Gets the information about the specified replica of a given service of an application. The information includes the runtime properties of the replica instance.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   replicaName: string (required)
  ##              : The identity of the service replica.
  ##   serviceName: string (required)
  ##              : The identity of the service.
  var path_568346 = newJObject()
  var query_568347 = newJObject()
  add(path_568346, "resourceGroupName", newJString(resourceGroupName))
  add(query_568347, "api-version", newJString(apiVersion))
  add(path_568346, "applicationName", newJString(applicationName))
  add(path_568346, "subscriptionId", newJString(subscriptionId))
  add(path_568346, "replicaName", newJString(replicaName))
  add(path_568346, "serviceName", newJString(serviceName))
  result = call_568345.call(path_568346, query_568347, nil, nil, nil)

var replicaGet* = Call_ReplicaGet_568335(name: "replicaGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}/services/{serviceName}/replicas/{replicaName}",
                                      validator: validate_ReplicaGet_568336,
                                      base: "", url: url_ReplicaGet_568337,
                                      schemes: {Scheme.Https})
type
  Call_CodePackageGetContainerLog_568348 = ref object of OpenApiRestCall_567666
proc url_CodePackageGetContainerLog_568350(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "replicaName" in path, "`replicaName` is a required path parameter"
  assert "codePackageName" in path, "`codePackageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/replicas/"),
               (kind: VariableSegment, value: "replicaName"),
               (kind: ConstantSegment, value: "/codePackages/"),
               (kind: VariableSegment, value: "codePackageName"),
               (kind: ConstantSegment, value: "/logs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CodePackageGetContainerLog_568349(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the logs for the container of a given code package of an application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   replicaName: JString (required)
  ##              : The identity of the service replica.
  ##   serviceName: JString (required)
  ##              : The identity of the service.
  ##   codePackageName: JString (required)
  ##                  : The name of the code package.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568351 = path.getOrDefault("resourceGroupName")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "resourceGroupName", valid_568351
  var valid_568352 = path.getOrDefault("applicationName")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "applicationName", valid_568352
  var valid_568353 = path.getOrDefault("subscriptionId")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "subscriptionId", valid_568353
  var valid_568354 = path.getOrDefault("replicaName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "replicaName", valid_568354
  var valid_568355 = path.getOrDefault("serviceName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "serviceName", valid_568355
  var valid_568356 = path.getOrDefault("codePackageName")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "codePackageName", valid_568356
  result.add "path", section
  ## parameters in `query` object:
  ##   tail: JInt
  ##       : Number of lines to show from the end of the logs. Default is 100.
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  var valid_568357 = query.getOrDefault("tail")
  valid_568357 = validateParameter(valid_568357, JInt, required = false, default = nil)
  if valid_568357 != nil:
    section.add "tail", valid_568357
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568358 = query.getOrDefault("api-version")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568358 != nil:
    section.add "api-version", valid_568358
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568359: Call_CodePackageGetContainerLog_568348; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the logs for the container of a given code package of an application.
  ## 
  let valid = call_568359.validator(path, query, header, formData, body)
  let scheme = call_568359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568359.url(scheme.get, call_568359.host, call_568359.base,
                         call_568359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568359, url, valid)

proc call*(call_568360: Call_CodePackageGetContainerLog_568348;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; replicaName: string; serviceName: string;
          codePackageName: string; tail: int = 0;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## codePackageGetContainerLog
  ## Get the logs for the container of a given code package of an application.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   tail: int
  ##       : Number of lines to show from the end of the logs. Default is 100.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   replicaName: string (required)
  ##              : The identity of the service replica.
  ##   serviceName: string (required)
  ##              : The identity of the service.
  ##   codePackageName: string (required)
  ##                  : The name of the code package.
  var path_568361 = newJObject()
  var query_568362 = newJObject()
  add(path_568361, "resourceGroupName", newJString(resourceGroupName))
  add(query_568362, "tail", newJInt(tail))
  add(query_568362, "api-version", newJString(apiVersion))
  add(path_568361, "applicationName", newJString(applicationName))
  add(path_568361, "subscriptionId", newJString(subscriptionId))
  add(path_568361, "replicaName", newJString(replicaName))
  add(path_568361, "serviceName", newJString(serviceName))
  add(path_568361, "codePackageName", newJString(codePackageName))
  result = call_568360.call(path_568361, query_568362, nil, nil, nil)

var codePackageGetContainerLog* = Call_CodePackageGetContainerLog_568348(
    name: "codePackageGetContainerLog", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}/services/{serviceName}/replicas/{replicaName}/codePackages/{codePackageName}/logs",
    validator: validate_CodePackageGetContainerLog_568349, base: "",
    url: url_CodePackageGetContainerLog_568350, schemes: {Scheme.Https})
type
  Call_NetworkListByResourceGroup_568363 = ref object of OpenApiRestCall_567666
proc url_NetworkListByResourceGroup_568365(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.ServiceFabricMesh/networks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkListByResourceGroup_568364(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all network resources in a given resource group. The information includes the network description and other runtime properties.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568366 = path.getOrDefault("resourceGroupName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "resourceGroupName", valid_568366
  var valid_568367 = path.getOrDefault("subscriptionId")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "subscriptionId", valid_568367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568368 = query.getOrDefault("api-version")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568368 != nil:
    section.add "api-version", valid_568368
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568369: Call_NetworkListByResourceGroup_568363; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all network resources in a given resource group. The information includes the network description and other runtime properties.
  ## 
  ## 
  let valid = call_568369.validator(path, query, header, formData, body)
  let scheme = call_568369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568369.url(scheme.get, call_568369.host, call_568369.base,
                         call_568369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568369, url, valid)

proc call*(call_568370: Call_NetworkListByResourceGroup_568363;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## networkListByResourceGroup
  ## Gets the information about all network resources in a given resource group. The information includes the network description and other runtime properties.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568371 = newJObject()
  var query_568372 = newJObject()
  add(path_568371, "resourceGroupName", newJString(resourceGroupName))
  add(query_568372, "api-version", newJString(apiVersion))
  add(path_568371, "subscriptionId", newJString(subscriptionId))
  result = call_568370.call(path_568371, query_568372, nil, nil, nil)

var networkListByResourceGroup* = Call_NetworkListByResourceGroup_568363(
    name: "networkListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks",
    validator: validate_NetworkListByResourceGroup_568364, base: "",
    url: url_NetworkListByResourceGroup_568365, schemes: {Scheme.Https})
type
  Call_NetworkCreate_568384 = ref object of OpenApiRestCall_567666
proc url_NetworkCreate_568386(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkName" in path, "`networkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/networks/"),
               (kind: VariableSegment, value: "networkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkCreate_568385(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a network resource with the specified name and description. If a network with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## Use network resources to create private network and configure public connectivity for services within your application. 
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   networkName: JString (required)
  ##              : The identity of the network.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568387 = path.getOrDefault("resourceGroupName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "resourceGroupName", valid_568387
  var valid_568388 = path.getOrDefault("networkName")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "networkName", valid_568388
  var valid_568389 = path.getOrDefault("subscriptionId")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "subscriptionId", valid_568389
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568390 = query.getOrDefault("api-version")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568390 != nil:
    section.add "api-version", valid_568390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   networkResourceDescription: JObject (required)
  ##                             : Description for creating a network resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568392: Call_NetworkCreate_568384; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a network resource with the specified name and description. If a network with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## Use network resources to create private network and configure public connectivity for services within your application. 
  ## 
  ## 
  let valid = call_568392.validator(path, query, header, formData, body)
  let scheme = call_568392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568392.url(scheme.get, call_568392.host, call_568392.base,
                         call_568392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568392, url, valid)

proc call*(call_568393: Call_NetworkCreate_568384; resourceGroupName: string;
          networkResourceDescription: JsonNode; networkName: string;
          subscriptionId: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## networkCreate
  ## Creates a network resource with the specified name and description. If a network with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## Use network resources to create private network and configure public connectivity for services within your application. 
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   networkResourceDescription: JObject (required)
  ##                             : Description for creating a network resource.
  ##   networkName: string (required)
  ##              : The identity of the network.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568394 = newJObject()
  var query_568395 = newJObject()
  var body_568396 = newJObject()
  add(path_568394, "resourceGroupName", newJString(resourceGroupName))
  add(query_568395, "api-version", newJString(apiVersion))
  if networkResourceDescription != nil:
    body_568396 = networkResourceDescription
  add(path_568394, "networkName", newJString(networkName))
  add(path_568394, "subscriptionId", newJString(subscriptionId))
  result = call_568393.call(path_568394, query_568395, nil, nil, body_568396)

var networkCreate* = Call_NetworkCreate_568384(name: "networkCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks/{networkName}",
    validator: validate_NetworkCreate_568385, base: "", url: url_NetworkCreate_568386,
    schemes: {Scheme.Https})
type
  Call_NetworkGet_568373 = ref object of OpenApiRestCall_567666
proc url_NetworkGet_568375(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkName" in path, "`networkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/networks/"),
               (kind: VariableSegment, value: "networkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkGet_568374(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the network resource with a given name. This information includes the network description and other runtime information.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   networkName: JString (required)
  ##              : The identity of the network.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568376 = path.getOrDefault("resourceGroupName")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "resourceGroupName", valid_568376
  var valid_568377 = path.getOrDefault("networkName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "networkName", valid_568377
  var valid_568378 = path.getOrDefault("subscriptionId")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "subscriptionId", valid_568378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568379 = query.getOrDefault("api-version")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568379 != nil:
    section.add "api-version", valid_568379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568380: Call_NetworkGet_568373; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the network resource with a given name. This information includes the network description and other runtime information.
  ## 
  ## 
  let valid = call_568380.validator(path, query, header, formData, body)
  let scheme = call_568380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568380.url(scheme.get, call_568380.host, call_568380.base,
                         call_568380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568380, url, valid)

proc call*(call_568381: Call_NetworkGet_568373; resourceGroupName: string;
          networkName: string; subscriptionId: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## networkGet
  ## Gets the information about the network resource with a given name. This information includes the network description and other runtime information.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   networkName: string (required)
  ##              : The identity of the network.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568382 = newJObject()
  var query_568383 = newJObject()
  add(path_568382, "resourceGroupName", newJString(resourceGroupName))
  add(query_568383, "api-version", newJString(apiVersion))
  add(path_568382, "networkName", newJString(networkName))
  add(path_568382, "subscriptionId", newJString(subscriptionId))
  result = call_568381.call(path_568382, query_568383, nil, nil, nil)

var networkGet* = Call_NetworkGet_568373(name: "networkGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks/{networkName}",
                                      validator: validate_NetworkGet_568374,
                                      base: "", url: url_NetworkGet_568375,
                                      schemes: {Scheme.Https})
type
  Call_NetworkDelete_568397 = ref object of OpenApiRestCall_567666
proc url_NetworkDelete_568399(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkName" in path, "`networkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/networks/"),
               (kind: VariableSegment, value: "networkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkDelete_568398(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the network resource identified by the name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   networkName: JString (required)
  ##              : The identity of the network.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568400 = path.getOrDefault("resourceGroupName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "resourceGroupName", valid_568400
  var valid_568401 = path.getOrDefault("networkName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "networkName", valid_568401
  var valid_568402 = path.getOrDefault("subscriptionId")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "subscriptionId", valid_568402
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568403 = query.getOrDefault("api-version")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568403 != nil:
    section.add "api-version", valid_568403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568404: Call_NetworkDelete_568397; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the network resource identified by the name.
  ## 
  let valid = call_568404.validator(path, query, header, formData, body)
  let scheme = call_568404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568404.url(scheme.get, call_568404.host, call_568404.base,
                         call_568404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568404, url, valid)

proc call*(call_568405: Call_NetworkDelete_568397; resourceGroupName: string;
          networkName: string; subscriptionId: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## networkDelete
  ## Deletes the network resource identified by the name.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   networkName: string (required)
  ##              : The identity of the network.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568406 = newJObject()
  var query_568407 = newJObject()
  add(path_568406, "resourceGroupName", newJString(resourceGroupName))
  add(query_568407, "api-version", newJString(apiVersion))
  add(path_568406, "networkName", newJString(networkName))
  add(path_568406, "subscriptionId", newJString(subscriptionId))
  result = call_568405.call(path_568406, query_568407, nil, nil, nil)

var networkDelete* = Call_NetworkDelete_568397(name: "networkDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks/{networkName}",
    validator: validate_NetworkDelete_568398, base: "", url: url_NetworkDelete_568399,
    schemes: {Scheme.Https})
type
  Call_VolumeListByResourceGroup_568408 = ref object of OpenApiRestCall_567666
proc url_VolumeListByResourceGroup_568410(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.ServiceFabricMesh/volumes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeListByResourceGroup_568409(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all volume resources in a given resource group. The information includes the volume description and other runtime information.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568411 = path.getOrDefault("resourceGroupName")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "resourceGroupName", valid_568411
  var valid_568412 = path.getOrDefault("subscriptionId")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "subscriptionId", valid_568412
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568413 = query.getOrDefault("api-version")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568413 != nil:
    section.add "api-version", valid_568413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568414: Call_VolumeListByResourceGroup_568408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all volume resources in a given resource group. The information includes the volume description and other runtime information.
  ## 
  ## 
  let valid = call_568414.validator(path, query, header, formData, body)
  let scheme = call_568414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568414.url(scheme.get, call_568414.host, call_568414.base,
                         call_568414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568414, url, valid)

proc call*(call_568415: Call_VolumeListByResourceGroup_568408;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## volumeListByResourceGroup
  ## Gets the information about all volume resources in a given resource group. The information includes the volume description and other runtime information.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568416 = newJObject()
  var query_568417 = newJObject()
  add(path_568416, "resourceGroupName", newJString(resourceGroupName))
  add(query_568417, "api-version", newJString(apiVersion))
  add(path_568416, "subscriptionId", newJString(subscriptionId))
  result = call_568415.call(path_568416, query_568417, nil, nil, nil)

var volumeListByResourceGroup* = Call_VolumeListByResourceGroup_568408(
    name: "volumeListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes",
    validator: validate_VolumeListByResourceGroup_568409, base: "",
    url: url_VolumeListByResourceGroup_568410, schemes: {Scheme.Https})
type
  Call_VolumeCreate_568429 = ref object of OpenApiRestCall_567666
proc url_VolumeCreate_568431(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/volumes/"),
               (kind: VariableSegment, value: "volumeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeCreate_568430(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a volume resource with the specified name and description. If a volume with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   volumeName: JString (required)
  ##             : The identity of the volume.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568432 = path.getOrDefault("resourceGroupName")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "resourceGroupName", valid_568432
  var valid_568433 = path.getOrDefault("subscriptionId")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "subscriptionId", valid_568433
  var valid_568434 = path.getOrDefault("volumeName")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "volumeName", valid_568434
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568435 = query.getOrDefault("api-version")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568435 != nil:
    section.add "api-version", valid_568435
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   volumeResourceDescription: JObject (required)
  ##                            : Description for creating a volume resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568437: Call_VolumeCreate_568429; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a volume resource with the specified name and description. If a volume with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## 
  let valid = call_568437.validator(path, query, header, formData, body)
  let scheme = call_568437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568437.url(scheme.get, call_568437.host, call_568437.base,
                         call_568437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568437, url, valid)

proc call*(call_568438: Call_VolumeCreate_568429; resourceGroupName: string;
          subscriptionId: string; volumeResourceDescription: JsonNode;
          volumeName: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## volumeCreate
  ## Creates a volume resource with the specified name and description. If a volume with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   volumeResourceDescription: JObject (required)
  ##                            : Description for creating a volume resource.
  ##   volumeName: string (required)
  ##             : The identity of the volume.
  var path_568439 = newJObject()
  var query_568440 = newJObject()
  var body_568441 = newJObject()
  add(path_568439, "resourceGroupName", newJString(resourceGroupName))
  add(query_568440, "api-version", newJString(apiVersion))
  add(path_568439, "subscriptionId", newJString(subscriptionId))
  if volumeResourceDescription != nil:
    body_568441 = volumeResourceDescription
  add(path_568439, "volumeName", newJString(volumeName))
  result = call_568438.call(path_568439, query_568440, nil, nil, body_568441)

var volumeCreate* = Call_VolumeCreate_568429(name: "volumeCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes/{volumeName}",
    validator: validate_VolumeCreate_568430, base: "", url: url_VolumeCreate_568431,
    schemes: {Scheme.Https})
type
  Call_VolumeGet_568418 = ref object of OpenApiRestCall_567666
proc url_VolumeGet_568420(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/volumes/"),
               (kind: VariableSegment, value: "volumeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeGet_568419(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the volume resource with a given name. This information includes the volume description and other runtime information.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   volumeName: JString (required)
  ##             : The identity of the volume.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568421 = path.getOrDefault("resourceGroupName")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "resourceGroupName", valid_568421
  var valid_568422 = path.getOrDefault("subscriptionId")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "subscriptionId", valid_568422
  var valid_568423 = path.getOrDefault("volumeName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "volumeName", valid_568423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568424 = query.getOrDefault("api-version")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568424 != nil:
    section.add "api-version", valid_568424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568425: Call_VolumeGet_568418; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the volume resource with a given name. This information includes the volume description and other runtime information.
  ## 
  ## 
  let valid = call_568425.validator(path, query, header, formData, body)
  let scheme = call_568425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568425.url(scheme.get, call_568425.host, call_568425.base,
                         call_568425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568425, url, valid)

proc call*(call_568426: Call_VolumeGet_568418; resourceGroupName: string;
          subscriptionId: string; volumeName: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## volumeGet
  ## Gets the information about the volume resource with a given name. This information includes the volume description and other runtime information.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   volumeName: string (required)
  ##             : The identity of the volume.
  var path_568427 = newJObject()
  var query_568428 = newJObject()
  add(path_568427, "resourceGroupName", newJString(resourceGroupName))
  add(query_568428, "api-version", newJString(apiVersion))
  add(path_568427, "subscriptionId", newJString(subscriptionId))
  add(path_568427, "volumeName", newJString(volumeName))
  result = call_568426.call(path_568427, query_568428, nil, nil, nil)

var volumeGet* = Call_VolumeGet_568418(name: "volumeGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes/{volumeName}",
                                    validator: validate_VolumeGet_568419,
                                    base: "", url: url_VolumeGet_568420,
                                    schemes: {Scheme.Https})
type
  Call_VolumeDelete_568442 = ref object of OpenApiRestCall_567666
proc url_VolumeDelete_568444(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/volumes/"),
               (kind: VariableSegment, value: "volumeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeDelete_568443(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the volume identified by the name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   volumeName: JString (required)
  ##             : The identity of the volume.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568445 = path.getOrDefault("resourceGroupName")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "resourceGroupName", valid_568445
  var valid_568446 = path.getOrDefault("subscriptionId")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "subscriptionId", valid_568446
  var valid_568447 = path.getOrDefault("volumeName")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "volumeName", valid_568447
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568448 = query.getOrDefault("api-version")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_568448 != nil:
    section.add "api-version", valid_568448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568449: Call_VolumeDelete_568442; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the volume identified by the name.
  ## 
  let valid = call_568449.validator(path, query, header, formData, body)
  let scheme = call_568449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568449.url(scheme.get, call_568449.host, call_568449.base,
                         call_568449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568449, url, valid)

proc call*(call_568450: Call_VolumeDelete_568442; resourceGroupName: string;
          subscriptionId: string; volumeName: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## volumeDelete
  ## Deletes the volume identified by the name.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   volumeName: string (required)
  ##             : The identity of the volume.
  var path_568451 = newJObject()
  var query_568452 = newJObject()
  add(path_568451, "resourceGroupName", newJString(resourceGroupName))
  add(query_568452, "api-version", newJString(apiVersion))
  add(path_568451, "subscriptionId", newJString(subscriptionId))
  add(path_568451, "volumeName", newJString(volumeName))
  result = call_568450.call(path_568451, query_568452, nil, nil, nil)

var volumeDelete* = Call_VolumeDelete_568442(name: "volumeDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes/{volumeName}",
    validator: validate_VolumeDelete_568443, base: "", url: url_VolumeDelete_568444,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
