
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SeaBreezeManagementClient
## version: 2018-09-01-preview
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

  OpenApiRestCall_567667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567667): Option[Scheme] {.used.} =
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
  Call_OperationsList_567889 = ref object of OpenApiRestCall_567667
proc url_OperationsList_567891(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567890(path: JsonNode; query: JsonNode;
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
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568063 = query.getOrDefault("api-version")
  valid_568063 = validateParameter(valid_568063, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568063 != nil:
    section.add "api-version", valid_568063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568086: Call_OperationsList_567889; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available operations provided by Service Fabric SeaBreeze resource provider.
  ## 
  let valid = call_568086.validator(path, query, header, formData, body)
  let scheme = call_568086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568086.url(scheme.get, call_568086.host, call_568086.base,
                         call_568086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568086, url, valid)

proc call*(call_568157: Call_OperationsList_567889;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## operationsList
  ## Lists all the available operations provided by Service Fabric SeaBreeze resource provider.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  var query_568158 = newJObject()
  add(query_568158, "api-version", newJString(apiVersion))
  result = call_568157.call(nil, query_568158, nil, nil, nil)

var operationsList* = Call_OperationsList_567889(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ServiceFabricMesh/operations",
    validator: validate_OperationsList_567890, base: "", url: url_OperationsList_567891,
    schemes: {Scheme.Https})
type
  Call_ApplicationListBySubscription_568198 = ref object of OpenApiRestCall_567667
proc url_ApplicationListBySubscription_568200(protocol: Scheme; host: string;
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

proc validate_ApplicationListBySubscription_568199(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all application resources in a given resource group. The information include the description and other properties of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568215 = path.getOrDefault("subscriptionId")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "subscriptionId", valid_568215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568216 = query.getOrDefault("api-version")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568216 != nil:
    section.add "api-version", valid_568216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568217: Call_ApplicationListBySubscription_568198; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all application resources in a given resource group. The information include the description and other properties of the application.
  ## 
  let valid = call_568217.validator(path, query, header, formData, body)
  let scheme = call_568217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568217.url(scheme.get, call_568217.host, call_568217.base,
                         call_568217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568217, url, valid)

proc call*(call_568218: Call_ApplicationListBySubscription_568198;
          subscriptionId: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## applicationListBySubscription
  ## Gets the information about all application resources in a given resource group. The information include the description and other properties of the application.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568219 = newJObject()
  var query_568220 = newJObject()
  add(query_568220, "api-version", newJString(apiVersion))
  add(path_568219, "subscriptionId", newJString(subscriptionId))
  result = call_568218.call(path_568219, query_568220, nil, nil, nil)

var applicationListBySubscription* = Call_ApplicationListBySubscription_568198(
    name: "applicationListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/applications",
    validator: validate_ApplicationListBySubscription_568199, base: "",
    url: url_ApplicationListBySubscription_568200, schemes: {Scheme.Https})
type
  Call_GatewayListBySubscription_568221 = ref object of OpenApiRestCall_567667
proc url_GatewayListBySubscription_568223(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.ServiceFabricMesh/gateways")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GatewayListBySubscription_568222(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all gateway resources in a given resource group. The information include the description and other properties of the gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568224 = path.getOrDefault("subscriptionId")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "subscriptionId", valid_568224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568225 = query.getOrDefault("api-version")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568225 != nil:
    section.add "api-version", valid_568225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568226: Call_GatewayListBySubscription_568221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all gateway resources in a given resource group. The information include the description and other properties of the gateway.
  ## 
  let valid = call_568226.validator(path, query, header, formData, body)
  let scheme = call_568226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568226.url(scheme.get, call_568226.host, call_568226.base,
                         call_568226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568226, url, valid)

proc call*(call_568227: Call_GatewayListBySubscription_568221;
          subscriptionId: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## gatewayListBySubscription
  ## Gets the information about all gateway resources in a given resource group. The information include the description and other properties of the gateway.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568228 = newJObject()
  var query_568229 = newJObject()
  add(query_568229, "api-version", newJString(apiVersion))
  add(path_568228, "subscriptionId", newJString(subscriptionId))
  result = call_568227.call(path_568228, query_568229, nil, nil, nil)

var gatewayListBySubscription* = Call_GatewayListBySubscription_568221(
    name: "gatewayListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/gateways",
    validator: validate_GatewayListBySubscription_568222, base: "",
    url: url_GatewayListBySubscription_568223, schemes: {Scheme.Https})
type
  Call_NetworkListBySubscription_568230 = ref object of OpenApiRestCall_567667
proc url_NetworkListBySubscription_568232(protocol: Scheme; host: string;
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

proc validate_NetworkListBySubscription_568231(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all network resources in a given resource group. The information include the description and other properties of the network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568233 = path.getOrDefault("subscriptionId")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "subscriptionId", valid_568233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568234 = query.getOrDefault("api-version")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568234 != nil:
    section.add "api-version", valid_568234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568235: Call_NetworkListBySubscription_568230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all network resources in a given resource group. The information include the description and other properties of the network.
  ## 
  let valid = call_568235.validator(path, query, header, formData, body)
  let scheme = call_568235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568235.url(scheme.get, call_568235.host, call_568235.base,
                         call_568235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568235, url, valid)

proc call*(call_568236: Call_NetworkListBySubscription_568230;
          subscriptionId: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## networkListBySubscription
  ## Gets the information about all network resources in a given resource group. The information include the description and other properties of the network.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568237 = newJObject()
  var query_568238 = newJObject()
  add(query_568238, "api-version", newJString(apiVersion))
  add(path_568237, "subscriptionId", newJString(subscriptionId))
  result = call_568236.call(path_568237, query_568238, nil, nil, nil)

var networkListBySubscription* = Call_NetworkListBySubscription_568230(
    name: "networkListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/networks",
    validator: validate_NetworkListBySubscription_568231, base: "",
    url: url_NetworkListBySubscription_568232, schemes: {Scheme.Https})
type
  Call_SecretListBySubscription_568239 = ref object of OpenApiRestCall_567667
proc url_SecretListBySubscription_568241(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.ServiceFabricMesh/secrets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecretListBySubscription_568240(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all secret resources in a given resource group. The information include the description and other properties of the secret.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568242 = path.getOrDefault("subscriptionId")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "subscriptionId", valid_568242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568243 = query.getOrDefault("api-version")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568243 != nil:
    section.add "api-version", valid_568243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568244: Call_SecretListBySubscription_568239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all secret resources in a given resource group. The information include the description and other properties of the secret.
  ## 
  let valid = call_568244.validator(path, query, header, formData, body)
  let scheme = call_568244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568244.url(scheme.get, call_568244.host, call_568244.base,
                         call_568244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568244, url, valid)

proc call*(call_568245: Call_SecretListBySubscription_568239;
          subscriptionId: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretListBySubscription
  ## Gets the information about all secret resources in a given resource group. The information include the description and other properties of the secret.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568246 = newJObject()
  var query_568247 = newJObject()
  add(query_568247, "api-version", newJString(apiVersion))
  add(path_568246, "subscriptionId", newJString(subscriptionId))
  result = call_568245.call(path_568246, query_568247, nil, nil, nil)

var secretListBySubscription* = Call_SecretListBySubscription_568239(
    name: "secretListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/secrets",
    validator: validate_SecretListBySubscription_568240, base: "",
    url: url_SecretListBySubscription_568241, schemes: {Scheme.Https})
type
  Call_VolumeListBySubscription_568248 = ref object of OpenApiRestCall_567667
proc url_VolumeListBySubscription_568250(protocol: Scheme; host: string;
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

proc validate_VolumeListBySubscription_568249(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all volume resources in a given resource group. The information include the description and other properties of the volume.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568251 = path.getOrDefault("subscriptionId")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "subscriptionId", valid_568251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568252 = query.getOrDefault("api-version")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568252 != nil:
    section.add "api-version", valid_568252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568253: Call_VolumeListBySubscription_568248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all volume resources in a given resource group. The information include the description and other properties of the volume.
  ## 
  let valid = call_568253.validator(path, query, header, formData, body)
  let scheme = call_568253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568253.url(scheme.get, call_568253.host, call_568253.base,
                         call_568253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568253, url, valid)

proc call*(call_568254: Call_VolumeListBySubscription_568248;
          subscriptionId: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## volumeListBySubscription
  ## Gets the information about all volume resources in a given resource group. The information include the description and other properties of the volume.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568255 = newJObject()
  var query_568256 = newJObject()
  add(query_568256, "api-version", newJString(apiVersion))
  add(path_568255, "subscriptionId", newJString(subscriptionId))
  result = call_568254.call(path_568255, query_568256, nil, nil, nil)

var volumeListBySubscription* = Call_VolumeListBySubscription_568248(
    name: "volumeListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/volumes",
    validator: validate_VolumeListBySubscription_568249, base: "",
    url: url_VolumeListBySubscription_568250, schemes: {Scheme.Https})
type
  Call_ApplicationListByResourceGroup_568257 = ref object of OpenApiRestCall_567667
proc url_ApplicationListByResourceGroup_568259(protocol: Scheme; host: string;
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

proc validate_ApplicationListByResourceGroup_568258(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all application resources in a given resource group. The information include the description and other properties of the Application.
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
  var valid_568260 = path.getOrDefault("resourceGroupName")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "resourceGroupName", valid_568260
  var valid_568261 = path.getOrDefault("subscriptionId")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "subscriptionId", valid_568261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568262 = query.getOrDefault("api-version")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568262 != nil:
    section.add "api-version", valid_568262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568263: Call_ApplicationListByResourceGroup_568257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all application resources in a given resource group. The information include the description and other properties of the Application.
  ## 
  let valid = call_568263.validator(path, query, header, formData, body)
  let scheme = call_568263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568263.url(scheme.get, call_568263.host, call_568263.base,
                         call_568263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568263, url, valid)

proc call*(call_568264: Call_ApplicationListByResourceGroup_568257;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## applicationListByResourceGroup
  ## Gets the information about all application resources in a given resource group. The information include the description and other properties of the Application.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568265 = newJObject()
  var query_568266 = newJObject()
  add(path_568265, "resourceGroupName", newJString(resourceGroupName))
  add(query_568266, "api-version", newJString(apiVersion))
  add(path_568265, "subscriptionId", newJString(subscriptionId))
  result = call_568264.call(path_568265, query_568266, nil, nil, nil)

var applicationListByResourceGroup* = Call_ApplicationListByResourceGroup_568257(
    name: "applicationListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications",
    validator: validate_ApplicationListByResourceGroup_568258, base: "",
    url: url_ApplicationListByResourceGroup_568259, schemes: {Scheme.Https})
type
  Call_ApplicationCreate_568278 = ref object of OpenApiRestCall_567667
proc url_ApplicationCreate_568280(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationResourceName" in path,
        "`applicationResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationCreate_568279(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates an application resource with the specified name, description and properties. If an application resource with the same name exists, then it is updated with the specified description and properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationResourceName: JString (required)
  ##                          : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568298 = path.getOrDefault("resourceGroupName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "resourceGroupName", valid_568298
  var valid_568299 = path.getOrDefault("applicationResourceName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "applicationResourceName", valid_568299
  var valid_568300 = path.getOrDefault("subscriptionId")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "subscriptionId", valid_568300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568301 = query.getOrDefault("api-version")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568301 != nil:
    section.add "api-version", valid_568301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   applicationResourceDescription: JObject (required)
  ##                                 : Description for creating a Application resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568303: Call_ApplicationCreate_568278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an application resource with the specified name, description and properties. If an application resource with the same name exists, then it is updated with the specified description and properties.
  ## 
  let valid = call_568303.validator(path, query, header, formData, body)
  let scheme = call_568303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568303.url(scheme.get, call_568303.host, call_568303.base,
                         call_568303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568303, url, valid)

proc call*(call_568304: Call_ApplicationCreate_568278;
          applicationResourceDescription: JsonNode; resourceGroupName: string;
          applicationResourceName: string; subscriptionId: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## applicationCreate
  ## Creates an application resource with the specified name, description and properties. If an application resource with the same name exists, then it is updated with the specified description and properties.
  ##   applicationResourceDescription: JObject (required)
  ##                                 : Description for creating a Application resource.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   applicationResourceName: string (required)
  ##                          : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568305 = newJObject()
  var query_568306 = newJObject()
  var body_568307 = newJObject()
  if applicationResourceDescription != nil:
    body_568307 = applicationResourceDescription
  add(path_568305, "resourceGroupName", newJString(resourceGroupName))
  add(query_568306, "api-version", newJString(apiVersion))
  add(path_568305, "applicationResourceName", newJString(applicationResourceName))
  add(path_568305, "subscriptionId", newJString(subscriptionId))
  result = call_568304.call(path_568305, query_568306, nil, nil, body_568307)

var applicationCreate* = Call_ApplicationCreate_568278(name: "applicationCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}",
    validator: validate_ApplicationCreate_568279, base: "",
    url: url_ApplicationCreate_568280, schemes: {Scheme.Https})
type
  Call_ApplicationGet_568267 = ref object of OpenApiRestCall_567667
proc url_ApplicationGet_568269(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationResourceName" in path,
        "`applicationResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGet_568268(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets the information about the application resource with the given name. The information include the description and other properties of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationResourceName: JString (required)
  ##                          : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568270 = path.getOrDefault("resourceGroupName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "resourceGroupName", valid_568270
  var valid_568271 = path.getOrDefault("applicationResourceName")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "applicationResourceName", valid_568271
  var valid_568272 = path.getOrDefault("subscriptionId")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "subscriptionId", valid_568272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568273 = query.getOrDefault("api-version")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568273 != nil:
    section.add "api-version", valid_568273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568274: Call_ApplicationGet_568267; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the application resource with the given name. The information include the description and other properties of the application.
  ## 
  let valid = call_568274.validator(path, query, header, formData, body)
  let scheme = call_568274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568274.url(scheme.get, call_568274.host, call_568274.base,
                         call_568274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568274, url, valid)

proc call*(call_568275: Call_ApplicationGet_568267; resourceGroupName: string;
          applicationResourceName: string; subscriptionId: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## applicationGet
  ## Gets the information about the application resource with the given name. The information include the description and other properties of the application.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   applicationResourceName: string (required)
  ##                          : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568276 = newJObject()
  var query_568277 = newJObject()
  add(path_568276, "resourceGroupName", newJString(resourceGroupName))
  add(query_568277, "api-version", newJString(apiVersion))
  add(path_568276, "applicationResourceName", newJString(applicationResourceName))
  add(path_568276, "subscriptionId", newJString(subscriptionId))
  result = call_568275.call(path_568276, query_568277, nil, nil, nil)

var applicationGet* = Call_ApplicationGet_568267(name: "applicationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}",
    validator: validate_ApplicationGet_568268, base: "", url: url_ApplicationGet_568269,
    schemes: {Scheme.Https})
type
  Call_ApplicationDelete_568308 = ref object of OpenApiRestCall_567667
proc url_ApplicationDelete_568310(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationResourceName" in path,
        "`applicationResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationDelete_568309(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes the application resource identified by the name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationResourceName: JString (required)
  ##                          : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568311 = path.getOrDefault("resourceGroupName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "resourceGroupName", valid_568311
  var valid_568312 = path.getOrDefault("applicationResourceName")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "applicationResourceName", valid_568312
  var valid_568313 = path.getOrDefault("subscriptionId")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "subscriptionId", valid_568313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568314 = query.getOrDefault("api-version")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568314 != nil:
    section.add "api-version", valid_568314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568315: Call_ApplicationDelete_568308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the application resource identified by the name.
  ## 
  let valid = call_568315.validator(path, query, header, formData, body)
  let scheme = call_568315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568315.url(scheme.get, call_568315.host, call_568315.base,
                         call_568315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568315, url, valid)

proc call*(call_568316: Call_ApplicationDelete_568308; resourceGroupName: string;
          applicationResourceName: string; subscriptionId: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## applicationDelete
  ## Deletes the application resource identified by the name.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   applicationResourceName: string (required)
  ##                          : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568317 = newJObject()
  var query_568318 = newJObject()
  add(path_568317, "resourceGroupName", newJString(resourceGroupName))
  add(query_568318, "api-version", newJString(apiVersion))
  add(path_568317, "applicationResourceName", newJString(applicationResourceName))
  add(path_568317, "subscriptionId", newJString(subscriptionId))
  result = call_568316.call(path_568317, query_568318, nil, nil, nil)

var applicationDelete* = Call_ApplicationDelete_568308(name: "applicationDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}",
    validator: validate_ApplicationDelete_568309, base: "",
    url: url_ApplicationDelete_568310, schemes: {Scheme.Https})
type
  Call_ServiceList_568319 = ref object of OpenApiRestCall_567667
proc url_ServiceList_568321(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationResourceName" in path,
        "`applicationResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationResourceName"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceList_568320(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all services of an application resource. The information include the description and other properties of the Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationResourceName: JString (required)
  ##                          : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568322 = path.getOrDefault("resourceGroupName")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "resourceGroupName", valid_568322
  var valid_568323 = path.getOrDefault("applicationResourceName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "applicationResourceName", valid_568323
  var valid_568324 = path.getOrDefault("subscriptionId")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "subscriptionId", valid_568324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568325 = query.getOrDefault("api-version")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568325 != nil:
    section.add "api-version", valid_568325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568326: Call_ServiceList_568319; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all services of an application resource. The information include the description and other properties of the Service.
  ## 
  let valid = call_568326.validator(path, query, header, formData, body)
  let scheme = call_568326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568326.url(scheme.get, call_568326.host, call_568326.base,
                         call_568326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568326, url, valid)

proc call*(call_568327: Call_ServiceList_568319; resourceGroupName: string;
          applicationResourceName: string; subscriptionId: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## serviceList
  ## Gets the information about all services of an application resource. The information include the description and other properties of the Service.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   applicationResourceName: string (required)
  ##                          : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568328 = newJObject()
  var query_568329 = newJObject()
  add(path_568328, "resourceGroupName", newJString(resourceGroupName))
  add(query_568329, "api-version", newJString(apiVersion))
  add(path_568328, "applicationResourceName", newJString(applicationResourceName))
  add(path_568328, "subscriptionId", newJString(subscriptionId))
  result = call_568327.call(path_568328, query_568329, nil, nil, nil)

var serviceList* = Call_ServiceList_568319(name: "serviceList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}/services",
                                        validator: validate_ServiceList_568320,
                                        base: "", url: url_ServiceList_568321,
                                        schemes: {Scheme.Https})
type
  Call_ServiceGet_568330 = ref object of OpenApiRestCall_567667
proc url_ServiceGet_568332(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationResourceName" in path,
        "`applicationResourceName` is a required path parameter"
  assert "serviceResourceName" in path,
        "`serviceResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationResourceName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceGet_568331(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the service resource with the given name. The information include the description and other properties of the service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationResourceName: JString (required)
  ##                          : The identity of the application.
  ##   serviceResourceName: JString (required)
  ##                      : The identity of the service.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568333 = path.getOrDefault("resourceGroupName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "resourceGroupName", valid_568333
  var valid_568334 = path.getOrDefault("applicationResourceName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "applicationResourceName", valid_568334
  var valid_568335 = path.getOrDefault("serviceResourceName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "serviceResourceName", valid_568335
  var valid_568336 = path.getOrDefault("subscriptionId")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "subscriptionId", valid_568336
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568337 = query.getOrDefault("api-version")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568337 != nil:
    section.add "api-version", valid_568337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568338: Call_ServiceGet_568330; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the service resource with the given name. The information include the description and other properties of the service.
  ## 
  let valid = call_568338.validator(path, query, header, formData, body)
  let scheme = call_568338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568338.url(scheme.get, call_568338.host, call_568338.base,
                         call_568338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568338, url, valid)

proc call*(call_568339: Call_ServiceGet_568330; resourceGroupName: string;
          applicationResourceName: string; serviceResourceName: string;
          subscriptionId: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## serviceGet
  ## Gets the information about the service resource with the given name. The information include the description and other properties of the service.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   applicationResourceName: string (required)
  ##                          : The identity of the application.
  ##   serviceResourceName: string (required)
  ##                      : The identity of the service.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568340 = newJObject()
  var query_568341 = newJObject()
  add(path_568340, "resourceGroupName", newJString(resourceGroupName))
  add(query_568341, "api-version", newJString(apiVersion))
  add(path_568340, "applicationResourceName", newJString(applicationResourceName))
  add(path_568340, "serviceResourceName", newJString(serviceResourceName))
  add(path_568340, "subscriptionId", newJString(subscriptionId))
  result = call_568339.call(path_568340, query_568341, nil, nil, nil)

var serviceGet* = Call_ServiceGet_568330(name: "serviceGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}/services/{serviceResourceName}",
                                      validator: validate_ServiceGet_568331,
                                      base: "", url: url_ServiceGet_568332,
                                      schemes: {Scheme.Https})
type
  Call_ServiceReplicaList_568342 = ref object of OpenApiRestCall_567667
proc url_ServiceReplicaList_568344(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationResourceName" in path,
        "`applicationResourceName` is a required path parameter"
  assert "serviceResourceName" in path,
        "`serviceResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationResourceName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceResourceName"),
               (kind: ConstantSegment, value: "/replicas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceReplicaList_568343(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the information about all replicas of a given service of an application. The information includes the runtime properties of the replica instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationResourceName: JString (required)
  ##                          : The identity of the application.
  ##   serviceResourceName: JString (required)
  ##                      : The identity of the service.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568345 = path.getOrDefault("resourceGroupName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "resourceGroupName", valid_568345
  var valid_568346 = path.getOrDefault("applicationResourceName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "applicationResourceName", valid_568346
  var valid_568347 = path.getOrDefault("serviceResourceName")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "serviceResourceName", valid_568347
  var valid_568348 = path.getOrDefault("subscriptionId")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "subscriptionId", valid_568348
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568349 = query.getOrDefault("api-version")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568349 != nil:
    section.add "api-version", valid_568349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568350: Call_ServiceReplicaList_568342; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all replicas of a given service of an application. The information includes the runtime properties of the replica instance.
  ## 
  let valid = call_568350.validator(path, query, header, formData, body)
  let scheme = call_568350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568350.url(scheme.get, call_568350.host, call_568350.base,
                         call_568350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568350, url, valid)

proc call*(call_568351: Call_ServiceReplicaList_568342; resourceGroupName: string;
          applicationResourceName: string; serviceResourceName: string;
          subscriptionId: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## serviceReplicaList
  ## Gets the information about all replicas of a given service of an application. The information includes the runtime properties of the replica instance.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   applicationResourceName: string (required)
  ##                          : The identity of the application.
  ##   serviceResourceName: string (required)
  ##                      : The identity of the service.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568352 = newJObject()
  var query_568353 = newJObject()
  add(path_568352, "resourceGroupName", newJString(resourceGroupName))
  add(query_568353, "api-version", newJString(apiVersion))
  add(path_568352, "applicationResourceName", newJString(applicationResourceName))
  add(path_568352, "serviceResourceName", newJString(serviceResourceName))
  add(path_568352, "subscriptionId", newJString(subscriptionId))
  result = call_568351.call(path_568352, query_568353, nil, nil, nil)

var serviceReplicaList* = Call_ServiceReplicaList_568342(
    name: "serviceReplicaList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}/services/{serviceResourceName}/replicas",
    validator: validate_ServiceReplicaList_568343, base: "",
    url: url_ServiceReplicaList_568344, schemes: {Scheme.Https})
type
  Call_ServiceReplicaGet_568354 = ref object of OpenApiRestCall_567667
proc url_ServiceReplicaGet_568356(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationResourceName" in path,
        "`applicationResourceName` is a required path parameter"
  assert "serviceResourceName" in path,
        "`serviceResourceName` is a required path parameter"
  assert "replicaName" in path, "`replicaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationResourceName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceResourceName"),
               (kind: ConstantSegment, value: "/replicas/"),
               (kind: VariableSegment, value: "replicaName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceReplicaGet_568355(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the information about the service replica with the given name. The information include the description and other properties of the service replica.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationResourceName: JString (required)
  ##                          : The identity of the application.
  ##   serviceResourceName: JString (required)
  ##                      : The identity of the service.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   replicaName: JString (required)
  ##              : Service Fabric replica name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568357 = path.getOrDefault("resourceGroupName")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "resourceGroupName", valid_568357
  var valid_568358 = path.getOrDefault("applicationResourceName")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "applicationResourceName", valid_568358
  var valid_568359 = path.getOrDefault("serviceResourceName")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "serviceResourceName", valid_568359
  var valid_568360 = path.getOrDefault("subscriptionId")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "subscriptionId", valid_568360
  var valid_568361 = path.getOrDefault("replicaName")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "replicaName", valid_568361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568362 = query.getOrDefault("api-version")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568362 != nil:
    section.add "api-version", valid_568362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568363: Call_ServiceReplicaGet_568354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the service replica with the given name. The information include the description and other properties of the service replica.
  ## 
  let valid = call_568363.validator(path, query, header, formData, body)
  let scheme = call_568363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568363.url(scheme.get, call_568363.host, call_568363.base,
                         call_568363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568363, url, valid)

proc call*(call_568364: Call_ServiceReplicaGet_568354; resourceGroupName: string;
          applicationResourceName: string; serviceResourceName: string;
          subscriptionId: string; replicaName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## serviceReplicaGet
  ## Gets the information about the service replica with the given name. The information include the description and other properties of the service replica.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   applicationResourceName: string (required)
  ##                          : The identity of the application.
  ##   serviceResourceName: string (required)
  ##                      : The identity of the service.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   replicaName: string (required)
  ##              : Service Fabric replica name.
  var path_568365 = newJObject()
  var query_568366 = newJObject()
  add(path_568365, "resourceGroupName", newJString(resourceGroupName))
  add(query_568366, "api-version", newJString(apiVersion))
  add(path_568365, "applicationResourceName", newJString(applicationResourceName))
  add(path_568365, "serviceResourceName", newJString(serviceResourceName))
  add(path_568365, "subscriptionId", newJString(subscriptionId))
  add(path_568365, "replicaName", newJString(replicaName))
  result = call_568364.call(path_568365, query_568366, nil, nil, nil)

var serviceReplicaGet* = Call_ServiceReplicaGet_568354(name: "serviceReplicaGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}/services/{serviceResourceName}/replicas/{replicaName}",
    validator: validate_ServiceReplicaGet_568355, base: "",
    url: url_ServiceReplicaGet_568356, schemes: {Scheme.Https})
type
  Call_CodePackageGetContainerLogs_568367 = ref object of OpenApiRestCall_567667
proc url_CodePackageGetContainerLogs_568369(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationResourceName" in path,
        "`applicationResourceName` is a required path parameter"
  assert "serviceResourceName" in path,
        "`serviceResourceName` is a required path parameter"
  assert "replicaName" in path, "`replicaName` is a required path parameter"
  assert "codePackageName" in path, "`codePackageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationResourceName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceResourceName"),
               (kind: ConstantSegment, value: "/replicas/"),
               (kind: VariableSegment, value: "replicaName"),
               (kind: ConstantSegment, value: "/codePackages/"),
               (kind: VariableSegment, value: "codePackageName"),
               (kind: ConstantSegment, value: "/logs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CodePackageGetContainerLogs_568368(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the logs for the container of the specified code package of the service replica.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationResourceName: JString (required)
  ##                          : The identity of the application.
  ##   serviceResourceName: JString (required)
  ##                      : The identity of the service.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   replicaName: JString (required)
  ##              : Service Fabric replica name.
  ##   codePackageName: JString (required)
  ##                  : The name of code package of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568370 = path.getOrDefault("resourceGroupName")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "resourceGroupName", valid_568370
  var valid_568371 = path.getOrDefault("applicationResourceName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "applicationResourceName", valid_568371
  var valid_568372 = path.getOrDefault("serviceResourceName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "serviceResourceName", valid_568372
  var valid_568373 = path.getOrDefault("subscriptionId")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "subscriptionId", valid_568373
  var valid_568374 = path.getOrDefault("replicaName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "replicaName", valid_568374
  var valid_568375 = path.getOrDefault("codePackageName")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "codePackageName", valid_568375
  result.add "path", section
  ## parameters in `query` object:
  ##   tail: JInt
  ##       : Number of lines to show from the end of the logs. Default is 100.
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  var valid_568376 = query.getOrDefault("tail")
  valid_568376 = validateParameter(valid_568376, JInt, required = false, default = nil)
  if valid_568376 != nil:
    section.add "tail", valid_568376
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568377 = query.getOrDefault("api-version")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568377 != nil:
    section.add "api-version", valid_568377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568378: Call_CodePackageGetContainerLogs_568367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the logs for the container of the specified code package of the service replica.
  ## 
  let valid = call_568378.validator(path, query, header, formData, body)
  let scheme = call_568378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568378.url(scheme.get, call_568378.host, call_568378.base,
                         call_568378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568378, url, valid)

proc call*(call_568379: Call_CodePackageGetContainerLogs_568367;
          resourceGroupName: string; applicationResourceName: string;
          serviceResourceName: string; subscriptionId: string; replicaName: string;
          codePackageName: string; tail: int = 0;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## codePackageGetContainerLogs
  ## Gets the logs for the container of the specified code package of the service replica.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   tail: int
  ##       : Number of lines to show from the end of the logs. Default is 100.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   applicationResourceName: string (required)
  ##                          : The identity of the application.
  ##   serviceResourceName: string (required)
  ##                      : The identity of the service.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   replicaName: string (required)
  ##              : Service Fabric replica name.
  ##   codePackageName: string (required)
  ##                  : The name of code package of the service.
  var path_568380 = newJObject()
  var query_568381 = newJObject()
  add(path_568380, "resourceGroupName", newJString(resourceGroupName))
  add(query_568381, "tail", newJInt(tail))
  add(query_568381, "api-version", newJString(apiVersion))
  add(path_568380, "applicationResourceName", newJString(applicationResourceName))
  add(path_568380, "serviceResourceName", newJString(serviceResourceName))
  add(path_568380, "subscriptionId", newJString(subscriptionId))
  add(path_568380, "replicaName", newJString(replicaName))
  add(path_568380, "codePackageName", newJString(codePackageName))
  result = call_568379.call(path_568380, query_568381, nil, nil, nil)

var codePackageGetContainerLogs* = Call_CodePackageGetContainerLogs_568367(
    name: "codePackageGetContainerLogs", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}/services/{serviceResourceName}/replicas/{replicaName}/codePackages/{codePackageName}/logs",
    validator: validate_CodePackageGetContainerLogs_568368, base: "",
    url: url_CodePackageGetContainerLogs_568369, schemes: {Scheme.Https})
type
  Call_GatewayListByResourceGroup_568382 = ref object of OpenApiRestCall_567667
proc url_GatewayListByResourceGroup_568384(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.ServiceFabricMesh/gateways")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GatewayListByResourceGroup_568383(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all gateway resources in a given resource group. The information include the description and other properties of the Gateway.
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
  var valid_568385 = path.getOrDefault("resourceGroupName")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "resourceGroupName", valid_568385
  var valid_568386 = path.getOrDefault("subscriptionId")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "subscriptionId", valid_568386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568387 = query.getOrDefault("api-version")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568387 != nil:
    section.add "api-version", valid_568387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568388: Call_GatewayListByResourceGroup_568382; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all gateway resources in a given resource group. The information include the description and other properties of the Gateway.
  ## 
  let valid = call_568388.validator(path, query, header, formData, body)
  let scheme = call_568388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568388.url(scheme.get, call_568388.host, call_568388.base,
                         call_568388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568388, url, valid)

proc call*(call_568389: Call_GatewayListByResourceGroup_568382;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## gatewayListByResourceGroup
  ## Gets the information about all gateway resources in a given resource group. The information include the description and other properties of the Gateway.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568390 = newJObject()
  var query_568391 = newJObject()
  add(path_568390, "resourceGroupName", newJString(resourceGroupName))
  add(query_568391, "api-version", newJString(apiVersion))
  add(path_568390, "subscriptionId", newJString(subscriptionId))
  result = call_568389.call(path_568390, query_568391, nil, nil, nil)

var gatewayListByResourceGroup* = Call_GatewayListByResourceGroup_568382(
    name: "gatewayListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/gateways",
    validator: validate_GatewayListByResourceGroup_568383, base: "",
    url: url_GatewayListByResourceGroup_568384, schemes: {Scheme.Https})
type
  Call_GatewayCreate_568403 = ref object of OpenApiRestCall_567667
proc url_GatewayCreate_568405(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayResourceName" in path,
        "`gatewayResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/gateways/"),
               (kind: VariableSegment, value: "gatewayResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GatewayCreate_568404(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a gateway resource with the specified name, description and properties. If a gateway resource with the same name exists, then it is updated with the specified description and properties. Use gateway resources to create a gateway for public connectivity for services within your application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   gatewayResourceName: JString (required)
  ##                      : The identity of the gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568406 = path.getOrDefault("resourceGroupName")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "resourceGroupName", valid_568406
  var valid_568407 = path.getOrDefault("subscriptionId")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "subscriptionId", valid_568407
  var valid_568408 = path.getOrDefault("gatewayResourceName")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "gatewayResourceName", valid_568408
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568409 = query.getOrDefault("api-version")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568409 != nil:
    section.add "api-version", valid_568409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   gatewayResourceDescription: JObject (required)
  ##                             : Description for creating a Gateway resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568411: Call_GatewayCreate_568403; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a gateway resource with the specified name, description and properties. If a gateway resource with the same name exists, then it is updated with the specified description and properties. Use gateway resources to create a gateway for public connectivity for services within your application.
  ## 
  let valid = call_568411.validator(path, query, header, formData, body)
  let scheme = call_568411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568411.url(scheme.get, call_568411.host, call_568411.base,
                         call_568411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568411, url, valid)

proc call*(call_568412: Call_GatewayCreate_568403; resourceGroupName: string;
          gatewayResourceDescription: JsonNode; subscriptionId: string;
          gatewayResourceName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## gatewayCreate
  ## Creates a gateway resource with the specified name, description and properties. If a gateway resource with the same name exists, then it is updated with the specified description and properties. Use gateway resources to create a gateway for public connectivity for services within your application.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   gatewayResourceDescription: JObject (required)
  ##                             : Description for creating a Gateway resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   gatewayResourceName: string (required)
  ##                      : The identity of the gateway.
  var path_568413 = newJObject()
  var query_568414 = newJObject()
  var body_568415 = newJObject()
  add(path_568413, "resourceGroupName", newJString(resourceGroupName))
  add(query_568414, "api-version", newJString(apiVersion))
  if gatewayResourceDescription != nil:
    body_568415 = gatewayResourceDescription
  add(path_568413, "subscriptionId", newJString(subscriptionId))
  add(path_568413, "gatewayResourceName", newJString(gatewayResourceName))
  result = call_568412.call(path_568413, query_568414, nil, nil, body_568415)

var gatewayCreate* = Call_GatewayCreate_568403(name: "gatewayCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/gateways/{gatewayResourceName}",
    validator: validate_GatewayCreate_568404, base: "", url: url_GatewayCreate_568405,
    schemes: {Scheme.Https})
type
  Call_GatewayGet_568392 = ref object of OpenApiRestCall_567667
proc url_GatewayGet_568394(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayResourceName" in path,
        "`gatewayResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/gateways/"),
               (kind: VariableSegment, value: "gatewayResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GatewayGet_568393(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the gateway resource with the given name. The information include the description and other properties of the gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   gatewayResourceName: JString (required)
  ##                      : The identity of the gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568395 = path.getOrDefault("resourceGroupName")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "resourceGroupName", valid_568395
  var valid_568396 = path.getOrDefault("subscriptionId")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "subscriptionId", valid_568396
  var valid_568397 = path.getOrDefault("gatewayResourceName")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "gatewayResourceName", valid_568397
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568398 = query.getOrDefault("api-version")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568398 != nil:
    section.add "api-version", valid_568398
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568399: Call_GatewayGet_568392; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the gateway resource with the given name. The information include the description and other properties of the gateway.
  ## 
  let valid = call_568399.validator(path, query, header, formData, body)
  let scheme = call_568399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568399.url(scheme.get, call_568399.host, call_568399.base,
                         call_568399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568399, url, valid)

proc call*(call_568400: Call_GatewayGet_568392; resourceGroupName: string;
          subscriptionId: string; gatewayResourceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## gatewayGet
  ## Gets the information about the gateway resource with the given name. The information include the description and other properties of the gateway.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   gatewayResourceName: string (required)
  ##                      : The identity of the gateway.
  var path_568401 = newJObject()
  var query_568402 = newJObject()
  add(path_568401, "resourceGroupName", newJString(resourceGroupName))
  add(query_568402, "api-version", newJString(apiVersion))
  add(path_568401, "subscriptionId", newJString(subscriptionId))
  add(path_568401, "gatewayResourceName", newJString(gatewayResourceName))
  result = call_568400.call(path_568401, query_568402, nil, nil, nil)

var gatewayGet* = Call_GatewayGet_568392(name: "gatewayGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/gateways/{gatewayResourceName}",
                                      validator: validate_GatewayGet_568393,
                                      base: "", url: url_GatewayGet_568394,
                                      schemes: {Scheme.Https})
type
  Call_GatewayDelete_568416 = ref object of OpenApiRestCall_567667
proc url_GatewayDelete_568418(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayResourceName" in path,
        "`gatewayResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/gateways/"),
               (kind: VariableSegment, value: "gatewayResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GatewayDelete_568417(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the gateway resource identified by the name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   gatewayResourceName: JString (required)
  ##                      : The identity of the gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568419 = path.getOrDefault("resourceGroupName")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "resourceGroupName", valid_568419
  var valid_568420 = path.getOrDefault("subscriptionId")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "subscriptionId", valid_568420
  var valid_568421 = path.getOrDefault("gatewayResourceName")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "gatewayResourceName", valid_568421
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568422 = query.getOrDefault("api-version")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568422 != nil:
    section.add "api-version", valid_568422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568423: Call_GatewayDelete_568416; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the gateway resource identified by the name.
  ## 
  let valid = call_568423.validator(path, query, header, formData, body)
  let scheme = call_568423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568423.url(scheme.get, call_568423.host, call_568423.base,
                         call_568423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568423, url, valid)

proc call*(call_568424: Call_GatewayDelete_568416; resourceGroupName: string;
          subscriptionId: string; gatewayResourceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## gatewayDelete
  ## Deletes the gateway resource identified by the name.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   gatewayResourceName: string (required)
  ##                      : The identity of the gateway.
  var path_568425 = newJObject()
  var query_568426 = newJObject()
  add(path_568425, "resourceGroupName", newJString(resourceGroupName))
  add(query_568426, "api-version", newJString(apiVersion))
  add(path_568425, "subscriptionId", newJString(subscriptionId))
  add(path_568425, "gatewayResourceName", newJString(gatewayResourceName))
  result = call_568424.call(path_568425, query_568426, nil, nil, nil)

var gatewayDelete* = Call_GatewayDelete_568416(name: "gatewayDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/gateways/{gatewayResourceName}",
    validator: validate_GatewayDelete_568417, base: "", url: url_GatewayDelete_568418,
    schemes: {Scheme.Https})
type
  Call_NetworkListByResourceGroup_568427 = ref object of OpenApiRestCall_567667
proc url_NetworkListByResourceGroup_568429(protocol: Scheme; host: string;
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

proc validate_NetworkListByResourceGroup_568428(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all network resources in a given resource group. The information include the description and other properties of the Network.
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
  var valid_568430 = path.getOrDefault("resourceGroupName")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "resourceGroupName", valid_568430
  var valid_568431 = path.getOrDefault("subscriptionId")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "subscriptionId", valid_568431
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568432 = query.getOrDefault("api-version")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568432 != nil:
    section.add "api-version", valid_568432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568433: Call_NetworkListByResourceGroup_568427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all network resources in a given resource group. The information include the description and other properties of the Network.
  ## 
  let valid = call_568433.validator(path, query, header, formData, body)
  let scheme = call_568433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568433.url(scheme.get, call_568433.host, call_568433.base,
                         call_568433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568433, url, valid)

proc call*(call_568434: Call_NetworkListByResourceGroup_568427;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## networkListByResourceGroup
  ## Gets the information about all network resources in a given resource group. The information include the description and other properties of the Network.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568435 = newJObject()
  var query_568436 = newJObject()
  add(path_568435, "resourceGroupName", newJString(resourceGroupName))
  add(query_568436, "api-version", newJString(apiVersion))
  add(path_568435, "subscriptionId", newJString(subscriptionId))
  result = call_568434.call(path_568435, query_568436, nil, nil, nil)

var networkListByResourceGroup* = Call_NetworkListByResourceGroup_568427(
    name: "networkListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks",
    validator: validate_NetworkListByResourceGroup_568428, base: "",
    url: url_NetworkListByResourceGroup_568429, schemes: {Scheme.Https})
type
  Call_NetworkCreate_568448 = ref object of OpenApiRestCall_567667
proc url_NetworkCreate_568450(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkResourceName" in path,
        "`networkResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/networks/"),
               (kind: VariableSegment, value: "networkResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkCreate_568449(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a network resource with the specified name, description and properties. If a network resource with the same name exists, then it is updated with the specified description and properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   networkResourceName: JString (required)
  ##                      : The identity of the network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568451 = path.getOrDefault("resourceGroupName")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "resourceGroupName", valid_568451
  var valid_568452 = path.getOrDefault("subscriptionId")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "subscriptionId", valid_568452
  var valid_568453 = path.getOrDefault("networkResourceName")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "networkResourceName", valid_568453
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568454 = query.getOrDefault("api-version")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568454 != nil:
    section.add "api-version", valid_568454
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   networkResourceDescription: JObject (required)
  ##                             : Description for creating a Network resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568456: Call_NetworkCreate_568448; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a network resource with the specified name, description and properties. If a network resource with the same name exists, then it is updated with the specified description and properties.
  ## 
  let valid = call_568456.validator(path, query, header, formData, body)
  let scheme = call_568456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568456.url(scheme.get, call_568456.host, call_568456.base,
                         call_568456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568456, url, valid)

proc call*(call_568457: Call_NetworkCreate_568448; resourceGroupName: string;
          networkResourceDescription: JsonNode; subscriptionId: string;
          networkResourceName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## networkCreate
  ## Creates a network resource with the specified name, description and properties. If a network resource with the same name exists, then it is updated with the specified description and properties.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   networkResourceDescription: JObject (required)
  ##                             : Description for creating a Network resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   networkResourceName: string (required)
  ##                      : The identity of the network.
  var path_568458 = newJObject()
  var query_568459 = newJObject()
  var body_568460 = newJObject()
  add(path_568458, "resourceGroupName", newJString(resourceGroupName))
  add(query_568459, "api-version", newJString(apiVersion))
  if networkResourceDescription != nil:
    body_568460 = networkResourceDescription
  add(path_568458, "subscriptionId", newJString(subscriptionId))
  add(path_568458, "networkResourceName", newJString(networkResourceName))
  result = call_568457.call(path_568458, query_568459, nil, nil, body_568460)

var networkCreate* = Call_NetworkCreate_568448(name: "networkCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks/{networkResourceName}",
    validator: validate_NetworkCreate_568449, base: "", url: url_NetworkCreate_568450,
    schemes: {Scheme.Https})
type
  Call_NetworkGet_568437 = ref object of OpenApiRestCall_567667
proc url_NetworkGet_568439(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkResourceName" in path,
        "`networkResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/networks/"),
               (kind: VariableSegment, value: "networkResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkGet_568438(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the network resource with the given name. The information include the description and other properties of the network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   networkResourceName: JString (required)
  ##                      : The identity of the network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568440 = path.getOrDefault("resourceGroupName")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "resourceGroupName", valid_568440
  var valid_568441 = path.getOrDefault("subscriptionId")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "subscriptionId", valid_568441
  var valid_568442 = path.getOrDefault("networkResourceName")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "networkResourceName", valid_568442
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568443 = query.getOrDefault("api-version")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568443 != nil:
    section.add "api-version", valid_568443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568444: Call_NetworkGet_568437; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the network resource with the given name. The information include the description and other properties of the network.
  ## 
  let valid = call_568444.validator(path, query, header, formData, body)
  let scheme = call_568444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568444.url(scheme.get, call_568444.host, call_568444.base,
                         call_568444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568444, url, valid)

proc call*(call_568445: Call_NetworkGet_568437; resourceGroupName: string;
          subscriptionId: string; networkResourceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## networkGet
  ## Gets the information about the network resource with the given name. The information include the description and other properties of the network.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   networkResourceName: string (required)
  ##                      : The identity of the network.
  var path_568446 = newJObject()
  var query_568447 = newJObject()
  add(path_568446, "resourceGroupName", newJString(resourceGroupName))
  add(query_568447, "api-version", newJString(apiVersion))
  add(path_568446, "subscriptionId", newJString(subscriptionId))
  add(path_568446, "networkResourceName", newJString(networkResourceName))
  result = call_568445.call(path_568446, query_568447, nil, nil, nil)

var networkGet* = Call_NetworkGet_568437(name: "networkGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks/{networkResourceName}",
                                      validator: validate_NetworkGet_568438,
                                      base: "", url: url_NetworkGet_568439,
                                      schemes: {Scheme.Https})
type
  Call_NetworkDelete_568461 = ref object of OpenApiRestCall_567667
proc url_NetworkDelete_568463(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkResourceName" in path,
        "`networkResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/networks/"),
               (kind: VariableSegment, value: "networkResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkDelete_568462(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the network resource identified by the name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   networkResourceName: JString (required)
  ##                      : The identity of the network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568464 = path.getOrDefault("resourceGroupName")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "resourceGroupName", valid_568464
  var valid_568465 = path.getOrDefault("subscriptionId")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "subscriptionId", valid_568465
  var valid_568466 = path.getOrDefault("networkResourceName")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "networkResourceName", valid_568466
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568467 = query.getOrDefault("api-version")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568467 != nil:
    section.add "api-version", valid_568467
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568468: Call_NetworkDelete_568461; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the network resource identified by the name.
  ## 
  let valid = call_568468.validator(path, query, header, formData, body)
  let scheme = call_568468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568468.url(scheme.get, call_568468.host, call_568468.base,
                         call_568468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568468, url, valid)

proc call*(call_568469: Call_NetworkDelete_568461; resourceGroupName: string;
          subscriptionId: string; networkResourceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## networkDelete
  ## Deletes the network resource identified by the name.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   networkResourceName: string (required)
  ##                      : The identity of the network.
  var path_568470 = newJObject()
  var query_568471 = newJObject()
  add(path_568470, "resourceGroupName", newJString(resourceGroupName))
  add(query_568471, "api-version", newJString(apiVersion))
  add(path_568470, "subscriptionId", newJString(subscriptionId))
  add(path_568470, "networkResourceName", newJString(networkResourceName))
  result = call_568469.call(path_568470, query_568471, nil, nil, nil)

var networkDelete* = Call_NetworkDelete_568461(name: "networkDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks/{networkResourceName}",
    validator: validate_NetworkDelete_568462, base: "", url: url_NetworkDelete_568463,
    schemes: {Scheme.Https})
type
  Call_SecretListByResourceGroup_568472 = ref object of OpenApiRestCall_567667
proc url_SecretListByResourceGroup_568474(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.ServiceFabricMesh/secrets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecretListByResourceGroup_568473(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all secret resources in a given resource group. The information include the description and other properties of the Secret.
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
  var valid_568475 = path.getOrDefault("resourceGroupName")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "resourceGroupName", valid_568475
  var valid_568476 = path.getOrDefault("subscriptionId")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "subscriptionId", valid_568476
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568477 = query.getOrDefault("api-version")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568477 != nil:
    section.add "api-version", valid_568477
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568478: Call_SecretListByResourceGroup_568472; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all secret resources in a given resource group. The information include the description and other properties of the Secret.
  ## 
  let valid = call_568478.validator(path, query, header, formData, body)
  let scheme = call_568478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568478.url(scheme.get, call_568478.host, call_568478.base,
                         call_568478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568478, url, valid)

proc call*(call_568479: Call_SecretListByResourceGroup_568472;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretListByResourceGroup
  ## Gets the information about all secret resources in a given resource group. The information include the description and other properties of the Secret.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568480 = newJObject()
  var query_568481 = newJObject()
  add(path_568480, "resourceGroupName", newJString(resourceGroupName))
  add(query_568481, "api-version", newJString(apiVersion))
  add(path_568480, "subscriptionId", newJString(subscriptionId))
  result = call_568479.call(path_568480, query_568481, nil, nil, nil)

var secretListByResourceGroup* = Call_SecretListByResourceGroup_568472(
    name: "secretListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets",
    validator: validate_SecretListByResourceGroup_568473, base: "",
    url: url_SecretListByResourceGroup_568474, schemes: {Scheme.Https})
type
  Call_SecretCreate_568493 = ref object of OpenApiRestCall_567667
proc url_SecretCreate_568495(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "secretResourceName" in path,
        "`secretResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/secrets/"),
               (kind: VariableSegment, value: "secretResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecretCreate_568494(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a secret resource with the specified name, description and properties. If a secret resource with the same name exists, then it is updated with the specified description and properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   secretResourceName: JString (required)
  ##                     : The name of the secret resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568496 = path.getOrDefault("resourceGroupName")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "resourceGroupName", valid_568496
  var valid_568497 = path.getOrDefault("subscriptionId")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "subscriptionId", valid_568497
  var valid_568498 = path.getOrDefault("secretResourceName")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "secretResourceName", valid_568498
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568499 = query.getOrDefault("api-version")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568499 != nil:
    section.add "api-version", valid_568499
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   secretResourceDescription: JObject (required)
  ##                            : Description for creating a secret resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568501: Call_SecretCreate_568493; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a secret resource with the specified name, description and properties. If a secret resource with the same name exists, then it is updated with the specified description and properties.
  ## 
  let valid = call_568501.validator(path, query, header, formData, body)
  let scheme = call_568501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568501.url(scheme.get, call_568501.host, call_568501.base,
                         call_568501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568501, url, valid)

proc call*(call_568502: Call_SecretCreate_568493; resourceGroupName: string;
          secretResourceDescription: JsonNode; subscriptionId: string;
          secretResourceName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretCreate
  ## Creates a secret resource with the specified name, description and properties. If a secret resource with the same name exists, then it is updated with the specified description and properties.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   secretResourceDescription: JObject (required)
  ##                            : Description for creating a secret resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   secretResourceName: string (required)
  ##                     : The name of the secret resource.
  var path_568503 = newJObject()
  var query_568504 = newJObject()
  var body_568505 = newJObject()
  add(path_568503, "resourceGroupName", newJString(resourceGroupName))
  add(query_568504, "api-version", newJString(apiVersion))
  if secretResourceDescription != nil:
    body_568505 = secretResourceDescription
  add(path_568503, "subscriptionId", newJString(subscriptionId))
  add(path_568503, "secretResourceName", newJString(secretResourceName))
  result = call_568502.call(path_568503, query_568504, nil, nil, body_568505)

var secretCreate* = Call_SecretCreate_568493(name: "secretCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}",
    validator: validate_SecretCreate_568494, base: "", url: url_SecretCreate_568495,
    schemes: {Scheme.Https})
type
  Call_SecretGet_568482 = ref object of OpenApiRestCall_567667
proc url_SecretGet_568484(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "secretResourceName" in path,
        "`secretResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/secrets/"),
               (kind: VariableSegment, value: "secretResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecretGet_568483(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the secret resource with the given name. The information include the description and other properties of the secret.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   secretResourceName: JString (required)
  ##                     : The name of the secret resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568485 = path.getOrDefault("resourceGroupName")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "resourceGroupName", valid_568485
  var valid_568486 = path.getOrDefault("subscriptionId")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "subscriptionId", valid_568486
  var valid_568487 = path.getOrDefault("secretResourceName")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "secretResourceName", valid_568487
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568488 = query.getOrDefault("api-version")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568488 != nil:
    section.add "api-version", valid_568488
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568489: Call_SecretGet_568482; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the secret resource with the given name. The information include the description and other properties of the secret.
  ## 
  let valid = call_568489.validator(path, query, header, formData, body)
  let scheme = call_568489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568489.url(scheme.get, call_568489.host, call_568489.base,
                         call_568489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568489, url, valid)

proc call*(call_568490: Call_SecretGet_568482; resourceGroupName: string;
          subscriptionId: string; secretResourceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretGet
  ## Gets the information about the secret resource with the given name. The information include the description and other properties of the secret.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   secretResourceName: string (required)
  ##                     : The name of the secret resource.
  var path_568491 = newJObject()
  var query_568492 = newJObject()
  add(path_568491, "resourceGroupName", newJString(resourceGroupName))
  add(query_568492, "api-version", newJString(apiVersion))
  add(path_568491, "subscriptionId", newJString(subscriptionId))
  add(path_568491, "secretResourceName", newJString(secretResourceName))
  result = call_568490.call(path_568491, query_568492, nil, nil, nil)

var secretGet* = Call_SecretGet_568482(name: "secretGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}",
                                    validator: validate_SecretGet_568483,
                                    base: "", url: url_SecretGet_568484,
                                    schemes: {Scheme.Https})
type
  Call_SecretDelete_568506 = ref object of OpenApiRestCall_567667
proc url_SecretDelete_568508(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "secretResourceName" in path,
        "`secretResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/secrets/"),
               (kind: VariableSegment, value: "secretResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecretDelete_568507(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the secret resource identified by the name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   secretResourceName: JString (required)
  ##                     : The name of the secret resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568509 = path.getOrDefault("resourceGroupName")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "resourceGroupName", valid_568509
  var valid_568510 = path.getOrDefault("subscriptionId")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "subscriptionId", valid_568510
  var valid_568511 = path.getOrDefault("secretResourceName")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = nil)
  if valid_568511 != nil:
    section.add "secretResourceName", valid_568511
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568512 = query.getOrDefault("api-version")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568512 != nil:
    section.add "api-version", valid_568512
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568513: Call_SecretDelete_568506; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the secret resource identified by the name.
  ## 
  let valid = call_568513.validator(path, query, header, formData, body)
  let scheme = call_568513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568513.url(scheme.get, call_568513.host, call_568513.base,
                         call_568513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568513, url, valid)

proc call*(call_568514: Call_SecretDelete_568506; resourceGroupName: string;
          subscriptionId: string; secretResourceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretDelete
  ## Deletes the secret resource identified by the name.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   secretResourceName: string (required)
  ##                     : The name of the secret resource.
  var path_568515 = newJObject()
  var query_568516 = newJObject()
  add(path_568515, "resourceGroupName", newJString(resourceGroupName))
  add(query_568516, "api-version", newJString(apiVersion))
  add(path_568515, "subscriptionId", newJString(subscriptionId))
  add(path_568515, "secretResourceName", newJString(secretResourceName))
  result = call_568514.call(path_568515, query_568516, nil, nil, nil)

var secretDelete* = Call_SecretDelete_568506(name: "secretDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}",
    validator: validate_SecretDelete_568507, base: "", url: url_SecretDelete_568508,
    schemes: {Scheme.Https})
type
  Call_SecretValueList_568517 = ref object of OpenApiRestCall_567667
proc url_SecretValueList_568519(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "secretResourceName" in path,
        "`secretResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/secrets/"),
               (kind: VariableSegment, value: "secretResourceName"),
               (kind: ConstantSegment, value: "/values")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecretValueList_568518(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets information about all secret value resources of the specified secret resource. The information includes the names of the secret value resources, but not the actual values.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   secretResourceName: JString (required)
  ##                     : The name of the secret resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568520 = path.getOrDefault("resourceGroupName")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "resourceGroupName", valid_568520
  var valid_568521 = path.getOrDefault("subscriptionId")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "subscriptionId", valid_568521
  var valid_568522 = path.getOrDefault("secretResourceName")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "secretResourceName", valid_568522
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568523 = query.getOrDefault("api-version")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568523 != nil:
    section.add "api-version", valid_568523
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568524: Call_SecretValueList_568517; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all secret value resources of the specified secret resource. The information includes the names of the secret value resources, but not the actual values.
  ## 
  let valid = call_568524.validator(path, query, header, formData, body)
  let scheme = call_568524.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568524.url(scheme.get, call_568524.host, call_568524.base,
                         call_568524.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568524, url, valid)

proc call*(call_568525: Call_SecretValueList_568517; resourceGroupName: string;
          subscriptionId: string; secretResourceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretValueList
  ## Gets information about all secret value resources of the specified secret resource. The information includes the names of the secret value resources, but not the actual values.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   secretResourceName: string (required)
  ##                     : The name of the secret resource.
  var path_568526 = newJObject()
  var query_568527 = newJObject()
  add(path_568526, "resourceGroupName", newJString(resourceGroupName))
  add(query_568527, "api-version", newJString(apiVersion))
  add(path_568526, "subscriptionId", newJString(subscriptionId))
  add(path_568526, "secretResourceName", newJString(secretResourceName))
  result = call_568525.call(path_568526, query_568527, nil, nil, nil)

var secretValueList* = Call_SecretValueList_568517(name: "secretValueList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}/values",
    validator: validate_SecretValueList_568518, base: "", url: url_SecretValueList_568519,
    schemes: {Scheme.Https})
type
  Call_SecretValueCreate_568540 = ref object of OpenApiRestCall_567667
proc url_SecretValueCreate_568542(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "secretResourceName" in path,
        "`secretResourceName` is a required path parameter"
  assert "secretValueResourceName" in path,
        "`secretValueResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/secrets/"),
               (kind: VariableSegment, value: "secretResourceName"),
               (kind: ConstantSegment, value: "/values/"),
               (kind: VariableSegment, value: "secretValueResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecretValueCreate_568541(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a new value of the specified secret resource. The name of the value is typically the version identifier. Once created the value cannot be changed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   secretValueResourceName: JString (required)
  ##                          : The name of the secret resource value which is typically the version identifier for the value.
  ##   secretResourceName: JString (required)
  ##                     : The name of the secret resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568543 = path.getOrDefault("resourceGroupName")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "resourceGroupName", valid_568543
  var valid_568544 = path.getOrDefault("subscriptionId")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "subscriptionId", valid_568544
  var valid_568545 = path.getOrDefault("secretValueResourceName")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "secretValueResourceName", valid_568545
  var valid_568546 = path.getOrDefault("secretResourceName")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "secretResourceName", valid_568546
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568547 = query.getOrDefault("api-version")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568547 != nil:
    section.add "api-version", valid_568547
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   secretValueResourceDescription: JObject (required)
  ##                                 : Description for creating a value of a secret resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568549: Call_SecretValueCreate_568540; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new value of the specified secret resource. The name of the value is typically the version identifier. Once created the value cannot be changed.
  ## 
  let valid = call_568549.validator(path, query, header, formData, body)
  let scheme = call_568549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568549.url(scheme.get, call_568549.host, call_568549.base,
                         call_568549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568549, url, valid)

proc call*(call_568550: Call_SecretValueCreate_568540; resourceGroupName: string;
          subscriptionId: string; secretValueResourceName: string;
          secretResourceName: string; secretValueResourceDescription: JsonNode;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretValueCreate
  ## Creates a new value of the specified secret resource. The name of the value is typically the version identifier. Once created the value cannot be changed.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   secretValueResourceName: string (required)
  ##                          : The name of the secret resource value which is typically the version identifier for the value.
  ##   secretResourceName: string (required)
  ##                     : The name of the secret resource.
  ##   secretValueResourceDescription: JObject (required)
  ##                                 : Description for creating a value of a secret resource.
  var path_568551 = newJObject()
  var query_568552 = newJObject()
  var body_568553 = newJObject()
  add(path_568551, "resourceGroupName", newJString(resourceGroupName))
  add(query_568552, "api-version", newJString(apiVersion))
  add(path_568551, "subscriptionId", newJString(subscriptionId))
  add(path_568551, "secretValueResourceName", newJString(secretValueResourceName))
  add(path_568551, "secretResourceName", newJString(secretResourceName))
  if secretValueResourceDescription != nil:
    body_568553 = secretValueResourceDescription
  result = call_568550.call(path_568551, query_568552, nil, nil, body_568553)

var secretValueCreate* = Call_SecretValueCreate_568540(name: "secretValueCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}/values/{secretValueResourceName}",
    validator: validate_SecretValueCreate_568541, base: "",
    url: url_SecretValueCreate_568542, schemes: {Scheme.Https})
type
  Call_SecretValueGet_568528 = ref object of OpenApiRestCall_567667
proc url_SecretValueGet_568530(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "secretResourceName" in path,
        "`secretResourceName` is a required path parameter"
  assert "secretValueResourceName" in path,
        "`secretValueResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/secrets/"),
               (kind: VariableSegment, value: "secretResourceName"),
               (kind: ConstantSegment, value: "/values/"),
               (kind: VariableSegment, value: "secretValueResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecretValueGet_568529(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get the information about the specified named secret value resources. The information does not include the actual value of the secret.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   secretValueResourceName: JString (required)
  ##                          : The name of the secret resource value which is typically the version identifier for the value.
  ##   secretResourceName: JString (required)
  ##                     : The name of the secret resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568531 = path.getOrDefault("resourceGroupName")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "resourceGroupName", valid_568531
  var valid_568532 = path.getOrDefault("subscriptionId")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "subscriptionId", valid_568532
  var valid_568533 = path.getOrDefault("secretValueResourceName")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "secretValueResourceName", valid_568533
  var valid_568534 = path.getOrDefault("secretResourceName")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "secretResourceName", valid_568534
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568535 = query.getOrDefault("api-version")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568535 != nil:
    section.add "api-version", valid_568535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568536: Call_SecretValueGet_568528; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the information about the specified named secret value resources. The information does not include the actual value of the secret.
  ## 
  let valid = call_568536.validator(path, query, header, formData, body)
  let scheme = call_568536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568536.url(scheme.get, call_568536.host, call_568536.base,
                         call_568536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568536, url, valid)

proc call*(call_568537: Call_SecretValueGet_568528; resourceGroupName: string;
          subscriptionId: string; secretValueResourceName: string;
          secretResourceName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretValueGet
  ## Get the information about the specified named secret value resources. The information does not include the actual value of the secret.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   secretValueResourceName: string (required)
  ##                          : The name of the secret resource value which is typically the version identifier for the value.
  ##   secretResourceName: string (required)
  ##                     : The name of the secret resource.
  var path_568538 = newJObject()
  var query_568539 = newJObject()
  add(path_568538, "resourceGroupName", newJString(resourceGroupName))
  add(query_568539, "api-version", newJString(apiVersion))
  add(path_568538, "subscriptionId", newJString(subscriptionId))
  add(path_568538, "secretValueResourceName", newJString(secretValueResourceName))
  add(path_568538, "secretResourceName", newJString(secretResourceName))
  result = call_568537.call(path_568538, query_568539, nil, nil, nil)

var secretValueGet* = Call_SecretValueGet_568528(name: "secretValueGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}/values/{secretValueResourceName}",
    validator: validate_SecretValueGet_568529, base: "", url: url_SecretValueGet_568530,
    schemes: {Scheme.Https})
type
  Call_SecretValueDelete_568554 = ref object of OpenApiRestCall_567667
proc url_SecretValueDelete_568556(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "secretResourceName" in path,
        "`secretResourceName` is a required path parameter"
  assert "secretValueResourceName" in path,
        "`secretValueResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/secrets/"),
               (kind: VariableSegment, value: "secretResourceName"),
               (kind: ConstantSegment, value: "/values/"),
               (kind: VariableSegment, value: "secretValueResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecretValueDelete_568555(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes the secret value resource identified by the name. The name of the resource is typically the version associated with that value. Deletion will fail if the specified value is in use.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   secretValueResourceName: JString (required)
  ##                          : The name of the secret resource value which is typically the version identifier for the value.
  ##   secretResourceName: JString (required)
  ##                     : The name of the secret resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568557 = path.getOrDefault("resourceGroupName")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "resourceGroupName", valid_568557
  var valid_568558 = path.getOrDefault("subscriptionId")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "subscriptionId", valid_568558
  var valid_568559 = path.getOrDefault("secretValueResourceName")
  valid_568559 = validateParameter(valid_568559, JString, required = true,
                                 default = nil)
  if valid_568559 != nil:
    section.add "secretValueResourceName", valid_568559
  var valid_568560 = path.getOrDefault("secretResourceName")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "secretResourceName", valid_568560
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568561 = query.getOrDefault("api-version")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568561 != nil:
    section.add "api-version", valid_568561
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568562: Call_SecretValueDelete_568554; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the secret value resource identified by the name. The name of the resource is typically the version associated with that value. Deletion will fail if the specified value is in use.
  ## 
  let valid = call_568562.validator(path, query, header, formData, body)
  let scheme = call_568562.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568562.url(scheme.get, call_568562.host, call_568562.base,
                         call_568562.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568562, url, valid)

proc call*(call_568563: Call_SecretValueDelete_568554; resourceGroupName: string;
          subscriptionId: string; secretValueResourceName: string;
          secretResourceName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretValueDelete
  ## Deletes the secret value resource identified by the name. The name of the resource is typically the version associated with that value. Deletion will fail if the specified value is in use.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   secretValueResourceName: string (required)
  ##                          : The name of the secret resource value which is typically the version identifier for the value.
  ##   secretResourceName: string (required)
  ##                     : The name of the secret resource.
  var path_568564 = newJObject()
  var query_568565 = newJObject()
  add(path_568564, "resourceGroupName", newJString(resourceGroupName))
  add(query_568565, "api-version", newJString(apiVersion))
  add(path_568564, "subscriptionId", newJString(subscriptionId))
  add(path_568564, "secretValueResourceName", newJString(secretValueResourceName))
  add(path_568564, "secretResourceName", newJString(secretResourceName))
  result = call_568563.call(path_568564, query_568565, nil, nil, nil)

var secretValueDelete* = Call_SecretValueDelete_568554(name: "secretValueDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}/values/{secretValueResourceName}",
    validator: validate_SecretValueDelete_568555, base: "",
    url: url_SecretValueDelete_568556, schemes: {Scheme.Https})
type
  Call_SecretValueListValue_568566 = ref object of OpenApiRestCall_567667
proc url_SecretValueListValue_568568(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "secretResourceName" in path,
        "`secretResourceName` is a required path parameter"
  assert "secretValueResourceName" in path,
        "`secretValueResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/secrets/"),
               (kind: VariableSegment, value: "secretResourceName"),
               (kind: ConstantSegment, value: "/values/"),
               (kind: VariableSegment, value: "secretValueResourceName"),
               (kind: ConstantSegment, value: "/list_value")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecretValueListValue_568567(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the decrypted value of the specified named value of the secret resource. This is a privileged operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   secretValueResourceName: JString (required)
  ##                          : The name of the secret resource value which is typically the version identifier for the value.
  ##   secretResourceName: JString (required)
  ##                     : The name of the secret resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568569 = path.getOrDefault("resourceGroupName")
  valid_568569 = validateParameter(valid_568569, JString, required = true,
                                 default = nil)
  if valid_568569 != nil:
    section.add "resourceGroupName", valid_568569
  var valid_568570 = path.getOrDefault("subscriptionId")
  valid_568570 = validateParameter(valid_568570, JString, required = true,
                                 default = nil)
  if valid_568570 != nil:
    section.add "subscriptionId", valid_568570
  var valid_568571 = path.getOrDefault("secretValueResourceName")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "secretValueResourceName", valid_568571
  var valid_568572 = path.getOrDefault("secretResourceName")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "secretResourceName", valid_568572
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568573 = query.getOrDefault("api-version")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568573 != nil:
    section.add "api-version", valid_568573
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568574: Call_SecretValueListValue_568566; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the decrypted value of the specified named value of the secret resource. This is a privileged operation.
  ## 
  let valid = call_568574.validator(path, query, header, formData, body)
  let scheme = call_568574.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568574.url(scheme.get, call_568574.host, call_568574.base,
                         call_568574.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568574, url, valid)

proc call*(call_568575: Call_SecretValueListValue_568566;
          resourceGroupName: string; subscriptionId: string;
          secretValueResourceName: string; secretResourceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretValueListValue
  ## Lists the decrypted value of the specified named value of the secret resource. This is a privileged operation.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   secretValueResourceName: string (required)
  ##                          : The name of the secret resource value which is typically the version identifier for the value.
  ##   secretResourceName: string (required)
  ##                     : The name of the secret resource.
  var path_568576 = newJObject()
  var query_568577 = newJObject()
  add(path_568576, "resourceGroupName", newJString(resourceGroupName))
  add(query_568577, "api-version", newJString(apiVersion))
  add(path_568576, "subscriptionId", newJString(subscriptionId))
  add(path_568576, "secretValueResourceName", newJString(secretValueResourceName))
  add(path_568576, "secretResourceName", newJString(secretResourceName))
  result = call_568575.call(path_568576, query_568577, nil, nil, nil)

var secretValueListValue* = Call_SecretValueListValue_568566(
    name: "secretValueListValue", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}/values/{secretValueResourceName}/list_value",
    validator: validate_SecretValueListValue_568567, base: "",
    url: url_SecretValueListValue_568568, schemes: {Scheme.Https})
type
  Call_VolumeListByResourceGroup_568578 = ref object of OpenApiRestCall_567667
proc url_VolumeListByResourceGroup_568580(protocol: Scheme; host: string;
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

proc validate_VolumeListByResourceGroup_568579(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all volume resources in a given resource group. The information include the description and other properties of the Volume.
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
  var valid_568581 = path.getOrDefault("resourceGroupName")
  valid_568581 = validateParameter(valid_568581, JString, required = true,
                                 default = nil)
  if valid_568581 != nil:
    section.add "resourceGroupName", valid_568581
  var valid_568582 = path.getOrDefault("subscriptionId")
  valid_568582 = validateParameter(valid_568582, JString, required = true,
                                 default = nil)
  if valid_568582 != nil:
    section.add "subscriptionId", valid_568582
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568583 = query.getOrDefault("api-version")
  valid_568583 = validateParameter(valid_568583, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568583 != nil:
    section.add "api-version", valid_568583
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568584: Call_VolumeListByResourceGroup_568578; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all volume resources in a given resource group. The information include the description and other properties of the Volume.
  ## 
  let valid = call_568584.validator(path, query, header, formData, body)
  let scheme = call_568584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568584.url(scheme.get, call_568584.host, call_568584.base,
                         call_568584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568584, url, valid)

proc call*(call_568585: Call_VolumeListByResourceGroup_568578;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## volumeListByResourceGroup
  ## Gets the information about all volume resources in a given resource group. The information include the description and other properties of the Volume.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568586 = newJObject()
  var query_568587 = newJObject()
  add(path_568586, "resourceGroupName", newJString(resourceGroupName))
  add(query_568587, "api-version", newJString(apiVersion))
  add(path_568586, "subscriptionId", newJString(subscriptionId))
  result = call_568585.call(path_568586, query_568587, nil, nil, nil)

var volumeListByResourceGroup* = Call_VolumeListByResourceGroup_568578(
    name: "volumeListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes",
    validator: validate_VolumeListByResourceGroup_568579, base: "",
    url: url_VolumeListByResourceGroup_568580, schemes: {Scheme.Https})
type
  Call_VolumeCreate_568599 = ref object of OpenApiRestCall_567667
proc url_VolumeCreate_568601(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "volumeResourceName" in path,
        "`volumeResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/volumes/"),
               (kind: VariableSegment, value: "volumeResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeCreate_568600(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a volume resource with the specified name, description and properties. If a volume resource with the same name exists, then it is updated with the specified description and properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   volumeResourceName: JString (required)
  ##                     : The identity of the volume.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568602 = path.getOrDefault("resourceGroupName")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "resourceGroupName", valid_568602
  var valid_568603 = path.getOrDefault("volumeResourceName")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = nil)
  if valid_568603 != nil:
    section.add "volumeResourceName", valid_568603
  var valid_568604 = path.getOrDefault("subscriptionId")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "subscriptionId", valid_568604
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568605 = query.getOrDefault("api-version")
  valid_568605 = validateParameter(valid_568605, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568605 != nil:
    section.add "api-version", valid_568605
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   volumeResourceDescription: JObject (required)
  ##                            : Description for creating a Volume resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568607: Call_VolumeCreate_568599; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a volume resource with the specified name, description and properties. If a volume resource with the same name exists, then it is updated with the specified description and properties.
  ## 
  let valid = call_568607.validator(path, query, header, formData, body)
  let scheme = call_568607.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568607.url(scheme.get, call_568607.host, call_568607.base,
                         call_568607.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568607, url, valid)

proc call*(call_568608: Call_VolumeCreate_568599; resourceGroupName: string;
          volumeResourceName: string; subscriptionId: string;
          volumeResourceDescription: JsonNode;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## volumeCreate
  ## Creates a volume resource with the specified name, description and properties. If a volume resource with the same name exists, then it is updated with the specified description and properties.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   volumeResourceName: string (required)
  ##                     : The identity of the volume.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   volumeResourceDescription: JObject (required)
  ##                            : Description for creating a Volume resource.
  var path_568609 = newJObject()
  var query_568610 = newJObject()
  var body_568611 = newJObject()
  add(path_568609, "resourceGroupName", newJString(resourceGroupName))
  add(query_568610, "api-version", newJString(apiVersion))
  add(path_568609, "volumeResourceName", newJString(volumeResourceName))
  add(path_568609, "subscriptionId", newJString(subscriptionId))
  if volumeResourceDescription != nil:
    body_568611 = volumeResourceDescription
  result = call_568608.call(path_568609, query_568610, nil, nil, body_568611)

var volumeCreate* = Call_VolumeCreate_568599(name: "volumeCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes/{volumeResourceName}",
    validator: validate_VolumeCreate_568600, base: "", url: url_VolumeCreate_568601,
    schemes: {Scheme.Https})
type
  Call_VolumeGet_568588 = ref object of OpenApiRestCall_567667
proc url_VolumeGet_568590(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "volumeResourceName" in path,
        "`volumeResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/volumes/"),
               (kind: VariableSegment, value: "volumeResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeGet_568589(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the volume resource with the given name. The information include the description and other properties of the volume.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   volumeResourceName: JString (required)
  ##                     : The identity of the volume.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568591 = path.getOrDefault("resourceGroupName")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "resourceGroupName", valid_568591
  var valid_568592 = path.getOrDefault("volumeResourceName")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = nil)
  if valid_568592 != nil:
    section.add "volumeResourceName", valid_568592
  var valid_568593 = path.getOrDefault("subscriptionId")
  valid_568593 = validateParameter(valid_568593, JString, required = true,
                                 default = nil)
  if valid_568593 != nil:
    section.add "subscriptionId", valid_568593
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568594 = query.getOrDefault("api-version")
  valid_568594 = validateParameter(valid_568594, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568594 != nil:
    section.add "api-version", valid_568594
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568595: Call_VolumeGet_568588; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the volume resource with the given name. The information include the description and other properties of the volume.
  ## 
  let valid = call_568595.validator(path, query, header, formData, body)
  let scheme = call_568595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568595.url(scheme.get, call_568595.host, call_568595.base,
                         call_568595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568595, url, valid)

proc call*(call_568596: Call_VolumeGet_568588; resourceGroupName: string;
          volumeResourceName: string; subscriptionId: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## volumeGet
  ## Gets the information about the volume resource with the given name. The information include the description and other properties of the volume.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   volumeResourceName: string (required)
  ##                     : The identity of the volume.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568597 = newJObject()
  var query_568598 = newJObject()
  add(path_568597, "resourceGroupName", newJString(resourceGroupName))
  add(query_568598, "api-version", newJString(apiVersion))
  add(path_568597, "volumeResourceName", newJString(volumeResourceName))
  add(path_568597, "subscriptionId", newJString(subscriptionId))
  result = call_568596.call(path_568597, query_568598, nil, nil, nil)

var volumeGet* = Call_VolumeGet_568588(name: "volumeGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes/{volumeResourceName}",
                                    validator: validate_VolumeGet_568589,
                                    base: "", url: url_VolumeGet_568590,
                                    schemes: {Scheme.Https})
type
  Call_VolumeDelete_568612 = ref object of OpenApiRestCall_567667
proc url_VolumeDelete_568614(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "volumeResourceName" in path,
        "`volumeResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/volumes/"),
               (kind: VariableSegment, value: "volumeResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeDelete_568613(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the volume resource identified by the name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   volumeResourceName: JString (required)
  ##                     : The identity of the volume.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568615 = path.getOrDefault("resourceGroupName")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "resourceGroupName", valid_568615
  var valid_568616 = path.getOrDefault("volumeResourceName")
  valid_568616 = validateParameter(valid_568616, JString, required = true,
                                 default = nil)
  if valid_568616 != nil:
    section.add "volumeResourceName", valid_568616
  var valid_568617 = path.getOrDefault("subscriptionId")
  valid_568617 = validateParameter(valid_568617, JString, required = true,
                                 default = nil)
  if valid_568617 != nil:
    section.add "subscriptionId", valid_568617
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568618 = query.getOrDefault("api-version")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_568618 != nil:
    section.add "api-version", valid_568618
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568619: Call_VolumeDelete_568612; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the volume resource identified by the name.
  ## 
  let valid = call_568619.validator(path, query, header, formData, body)
  let scheme = call_568619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568619.url(scheme.get, call_568619.host, call_568619.base,
                         call_568619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568619, url, valid)

proc call*(call_568620: Call_VolumeDelete_568612; resourceGroupName: string;
          volumeResourceName: string; subscriptionId: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## volumeDelete
  ## Deletes the volume resource identified by the name.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   volumeResourceName: string (required)
  ##                     : The identity of the volume.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568621 = newJObject()
  var query_568622 = newJObject()
  add(path_568621, "resourceGroupName", newJString(resourceGroupName))
  add(query_568622, "api-version", newJString(apiVersion))
  add(path_568621, "volumeResourceName", newJString(volumeResourceName))
  add(path_568621, "subscriptionId", newJString(subscriptionId))
  result = call_568620.call(path_568621, query_568622, nil, nil, nil)

var volumeDelete* = Call_VolumeDelete_568612(name: "volumeDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes/{volumeResourceName}",
    validator: validate_VolumeDelete_568613, base: "", url: url_VolumeDelete_568614,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
