
import
  json, options, hashes, uri, rest, os, uri, httpcore

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
  macServiceName = "servicefabricmesh"
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
  var valid_563963 = query.getOrDefault("api-version")
  valid_563963 = validateParameter(valid_563963, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_563963 != nil:
    section.add "api-version", valid_563963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563986: Call_OperationsList_563787; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available operations provided by Service Fabric SeaBreeze resource provider.
  ## 
  let valid = call_563986.validator(path, query, header, formData, body)
  let scheme = call_563986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563986.url(scheme.get, call_563986.host, call_563986.base,
                         call_563986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563986, url, valid)

proc call*(call_564057: Call_OperationsList_563787;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## operationsList
  ## Lists all the available operations provided by Service Fabric SeaBreeze resource provider.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  var query_564058 = newJObject()
  add(query_564058, "api-version", newJString(apiVersion))
  result = call_564057.call(nil, query_564058, nil, nil, nil)

var operationsList* = Call_OperationsList_563787(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ServiceFabricMesh/operations",
    validator: validate_OperationsList_563788, base: "", url: url_OperationsList_563789,
    schemes: {Scheme.Https})
type
  Call_ApplicationListBySubscription_564098 = ref object of OpenApiRestCall_563565
proc url_ApplicationListBySubscription_564100(protocol: Scheme; host: string;
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

proc validate_ApplicationListBySubscription_564099(path: JsonNode; query: JsonNode;
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
  var valid_564115 = path.getOrDefault("subscriptionId")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "subscriptionId", valid_564115
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564116 = query.getOrDefault("api-version")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564116 != nil:
    section.add "api-version", valid_564116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564117: Call_ApplicationListBySubscription_564098; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all application resources in a given resource group. The information include the description and other properties of the application.
  ## 
  let valid = call_564117.validator(path, query, header, formData, body)
  let scheme = call_564117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564117.url(scheme.get, call_564117.host, call_564117.base,
                         call_564117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564117, url, valid)

proc call*(call_564118: Call_ApplicationListBySubscription_564098;
          subscriptionId: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## applicationListBySubscription
  ## Gets the information about all application resources in a given resource group. The information include the description and other properties of the application.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_564119 = newJObject()
  var query_564120 = newJObject()
  add(query_564120, "api-version", newJString(apiVersion))
  add(path_564119, "subscriptionId", newJString(subscriptionId))
  result = call_564118.call(path_564119, query_564120, nil, nil, nil)

var applicationListBySubscription* = Call_ApplicationListBySubscription_564098(
    name: "applicationListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/applications",
    validator: validate_ApplicationListBySubscription_564099, base: "",
    url: url_ApplicationListBySubscription_564100, schemes: {Scheme.Https})
type
  Call_GatewayListBySubscription_564121 = ref object of OpenApiRestCall_563565
proc url_GatewayListBySubscription_564123(protocol: Scheme; host: string;
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

proc validate_GatewayListBySubscription_564122(path: JsonNode; query: JsonNode;
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
  var valid_564124 = path.getOrDefault("subscriptionId")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "subscriptionId", valid_564124
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564125 = query.getOrDefault("api-version")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564125 != nil:
    section.add "api-version", valid_564125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564126: Call_GatewayListBySubscription_564121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all gateway resources in a given resource group. The information include the description and other properties of the gateway.
  ## 
  let valid = call_564126.validator(path, query, header, formData, body)
  let scheme = call_564126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564126.url(scheme.get, call_564126.host, call_564126.base,
                         call_564126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564126, url, valid)

proc call*(call_564127: Call_GatewayListBySubscription_564121;
          subscriptionId: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## gatewayListBySubscription
  ## Gets the information about all gateway resources in a given resource group. The information include the description and other properties of the gateway.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_564128 = newJObject()
  var query_564129 = newJObject()
  add(query_564129, "api-version", newJString(apiVersion))
  add(path_564128, "subscriptionId", newJString(subscriptionId))
  result = call_564127.call(path_564128, query_564129, nil, nil, nil)

var gatewayListBySubscription* = Call_GatewayListBySubscription_564121(
    name: "gatewayListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/gateways",
    validator: validate_GatewayListBySubscription_564122, base: "",
    url: url_GatewayListBySubscription_564123, schemes: {Scheme.Https})
type
  Call_NetworkListBySubscription_564130 = ref object of OpenApiRestCall_563565
proc url_NetworkListBySubscription_564132(protocol: Scheme; host: string;
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

proc validate_NetworkListBySubscription_564131(path: JsonNode; query: JsonNode;
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
  var valid_564133 = path.getOrDefault("subscriptionId")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "subscriptionId", valid_564133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564134 = query.getOrDefault("api-version")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564134 != nil:
    section.add "api-version", valid_564134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564135: Call_NetworkListBySubscription_564130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all network resources in a given resource group. The information include the description and other properties of the network.
  ## 
  let valid = call_564135.validator(path, query, header, formData, body)
  let scheme = call_564135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564135.url(scheme.get, call_564135.host, call_564135.base,
                         call_564135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564135, url, valid)

proc call*(call_564136: Call_NetworkListBySubscription_564130;
          subscriptionId: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## networkListBySubscription
  ## Gets the information about all network resources in a given resource group. The information include the description and other properties of the network.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_564137 = newJObject()
  var query_564138 = newJObject()
  add(query_564138, "api-version", newJString(apiVersion))
  add(path_564137, "subscriptionId", newJString(subscriptionId))
  result = call_564136.call(path_564137, query_564138, nil, nil, nil)

var networkListBySubscription* = Call_NetworkListBySubscription_564130(
    name: "networkListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/networks",
    validator: validate_NetworkListBySubscription_564131, base: "",
    url: url_NetworkListBySubscription_564132, schemes: {Scheme.Https})
type
  Call_SecretListBySubscription_564139 = ref object of OpenApiRestCall_563565
proc url_SecretListBySubscription_564141(protocol: Scheme; host: string;
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

proc validate_SecretListBySubscription_564140(path: JsonNode; query: JsonNode;
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
  var valid_564142 = path.getOrDefault("subscriptionId")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "subscriptionId", valid_564142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564143 = query.getOrDefault("api-version")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564143 != nil:
    section.add "api-version", valid_564143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564144: Call_SecretListBySubscription_564139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all secret resources in a given resource group. The information include the description and other properties of the secret.
  ## 
  let valid = call_564144.validator(path, query, header, formData, body)
  let scheme = call_564144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564144.url(scheme.get, call_564144.host, call_564144.base,
                         call_564144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564144, url, valid)

proc call*(call_564145: Call_SecretListBySubscription_564139;
          subscriptionId: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretListBySubscription
  ## Gets the information about all secret resources in a given resource group. The information include the description and other properties of the secret.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_564146 = newJObject()
  var query_564147 = newJObject()
  add(query_564147, "api-version", newJString(apiVersion))
  add(path_564146, "subscriptionId", newJString(subscriptionId))
  result = call_564145.call(path_564146, query_564147, nil, nil, nil)

var secretListBySubscription* = Call_SecretListBySubscription_564139(
    name: "secretListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/secrets",
    validator: validate_SecretListBySubscription_564140, base: "",
    url: url_SecretListBySubscription_564141, schemes: {Scheme.Https})
type
  Call_VolumeListBySubscription_564148 = ref object of OpenApiRestCall_563565
proc url_VolumeListBySubscription_564150(protocol: Scheme; host: string;
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

proc validate_VolumeListBySubscription_564149(path: JsonNode; query: JsonNode;
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
  var valid_564151 = path.getOrDefault("subscriptionId")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "subscriptionId", valid_564151
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564152 = query.getOrDefault("api-version")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564152 != nil:
    section.add "api-version", valid_564152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564153: Call_VolumeListBySubscription_564148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all volume resources in a given resource group. The information include the description and other properties of the volume.
  ## 
  let valid = call_564153.validator(path, query, header, formData, body)
  let scheme = call_564153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564153.url(scheme.get, call_564153.host, call_564153.base,
                         call_564153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564153, url, valid)

proc call*(call_564154: Call_VolumeListBySubscription_564148;
          subscriptionId: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## volumeListBySubscription
  ## Gets the information about all volume resources in a given resource group. The information include the description and other properties of the volume.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_564155 = newJObject()
  var query_564156 = newJObject()
  add(query_564156, "api-version", newJString(apiVersion))
  add(path_564155, "subscriptionId", newJString(subscriptionId))
  result = call_564154.call(path_564155, query_564156, nil, nil, nil)

var volumeListBySubscription* = Call_VolumeListBySubscription_564148(
    name: "volumeListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/volumes",
    validator: validate_VolumeListBySubscription_564149, base: "",
    url: url_VolumeListBySubscription_564150, schemes: {Scheme.Https})
type
  Call_ApplicationListByResourceGroup_564157 = ref object of OpenApiRestCall_563565
proc url_ApplicationListByResourceGroup_564159(protocol: Scheme; host: string;
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

proc validate_ApplicationListByResourceGroup_564158(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all application resources in a given resource group. The information include the description and other properties of the Application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564160 = path.getOrDefault("subscriptionId")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "subscriptionId", valid_564160
  var valid_564161 = path.getOrDefault("resourceGroupName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "resourceGroupName", valid_564161
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564162 = query.getOrDefault("api-version")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564162 != nil:
    section.add "api-version", valid_564162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564163: Call_ApplicationListByResourceGroup_564157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all application resources in a given resource group. The information include the description and other properties of the Application.
  ## 
  let valid = call_564163.validator(path, query, header, formData, body)
  let scheme = call_564163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564163.url(scheme.get, call_564163.host, call_564163.base,
                         call_564163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564163, url, valid)

proc call*(call_564164: Call_ApplicationListByResourceGroup_564157;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## applicationListByResourceGroup
  ## Gets the information about all application resources in a given resource group. The information include the description and other properties of the Application.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564165 = newJObject()
  var query_564166 = newJObject()
  add(query_564166, "api-version", newJString(apiVersion))
  add(path_564165, "subscriptionId", newJString(subscriptionId))
  add(path_564165, "resourceGroupName", newJString(resourceGroupName))
  result = call_564164.call(path_564165, query_564166, nil, nil, nil)

var applicationListByResourceGroup* = Call_ApplicationListByResourceGroup_564157(
    name: "applicationListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications",
    validator: validate_ApplicationListByResourceGroup_564158, base: "",
    url: url_ApplicationListByResourceGroup_564159, schemes: {Scheme.Https})
type
  Call_ApplicationCreate_564178 = ref object of OpenApiRestCall_563565
proc url_ApplicationCreate_564180(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationCreate_564179(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates an application resource with the specified name, description and properties. If an application resource with the same name exists, then it is updated with the specified description and properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationResourceName: JString (required)
  ##                          : The identity of the application.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564198 = path.getOrDefault("subscriptionId")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "subscriptionId", valid_564198
  var valid_564199 = path.getOrDefault("resourceGroupName")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "resourceGroupName", valid_564199
  var valid_564200 = path.getOrDefault("applicationResourceName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "applicationResourceName", valid_564200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564201 = query.getOrDefault("api-version")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564201 != nil:
    section.add "api-version", valid_564201
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

proc call*(call_564203: Call_ApplicationCreate_564178; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an application resource with the specified name, description and properties. If an application resource with the same name exists, then it is updated with the specified description and properties.
  ## 
  let valid = call_564203.validator(path, query, header, formData, body)
  let scheme = call_564203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564203.url(scheme.get, call_564203.host, call_564203.base,
                         call_564203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564203, url, valid)

proc call*(call_564204: Call_ApplicationCreate_564178;
          applicationResourceDescription: JsonNode; subscriptionId: string;
          resourceGroupName: string; applicationResourceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## applicationCreate
  ## Creates an application resource with the specified name, description and properties. If an application resource with the same name exists, then it is updated with the specified description and properties.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   applicationResourceDescription: JObject (required)
  ##                                 : Description for creating a Application resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   applicationResourceName: string (required)
  ##                          : The identity of the application.
  var path_564205 = newJObject()
  var query_564206 = newJObject()
  var body_564207 = newJObject()
  add(query_564206, "api-version", newJString(apiVersion))
  if applicationResourceDescription != nil:
    body_564207 = applicationResourceDescription
  add(path_564205, "subscriptionId", newJString(subscriptionId))
  add(path_564205, "resourceGroupName", newJString(resourceGroupName))
  add(path_564205, "applicationResourceName", newJString(applicationResourceName))
  result = call_564204.call(path_564205, query_564206, nil, nil, body_564207)

var applicationCreate* = Call_ApplicationCreate_564178(name: "applicationCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}",
    validator: validate_ApplicationCreate_564179, base: "",
    url: url_ApplicationCreate_564180, schemes: {Scheme.Https})
type
  Call_ApplicationGet_564167 = ref object of OpenApiRestCall_563565
proc url_ApplicationGet_564169(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGet_564168(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets the information about the application resource with the given name. The information include the description and other properties of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationResourceName: JString (required)
  ##                          : The identity of the application.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564170 = path.getOrDefault("subscriptionId")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "subscriptionId", valid_564170
  var valid_564171 = path.getOrDefault("resourceGroupName")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "resourceGroupName", valid_564171
  var valid_564172 = path.getOrDefault("applicationResourceName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "applicationResourceName", valid_564172
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564173 = query.getOrDefault("api-version")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564173 != nil:
    section.add "api-version", valid_564173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564174: Call_ApplicationGet_564167; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the application resource with the given name. The information include the description and other properties of the application.
  ## 
  let valid = call_564174.validator(path, query, header, formData, body)
  let scheme = call_564174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564174.url(scheme.get, call_564174.host, call_564174.base,
                         call_564174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564174, url, valid)

proc call*(call_564175: Call_ApplicationGet_564167; subscriptionId: string;
          resourceGroupName: string; applicationResourceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## applicationGet
  ## Gets the information about the application resource with the given name. The information include the description and other properties of the application.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   applicationResourceName: string (required)
  ##                          : The identity of the application.
  var path_564176 = newJObject()
  var query_564177 = newJObject()
  add(query_564177, "api-version", newJString(apiVersion))
  add(path_564176, "subscriptionId", newJString(subscriptionId))
  add(path_564176, "resourceGroupName", newJString(resourceGroupName))
  add(path_564176, "applicationResourceName", newJString(applicationResourceName))
  result = call_564175.call(path_564176, query_564177, nil, nil, nil)

var applicationGet* = Call_ApplicationGet_564167(name: "applicationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}",
    validator: validate_ApplicationGet_564168, base: "", url: url_ApplicationGet_564169,
    schemes: {Scheme.Https})
type
  Call_ApplicationDelete_564208 = ref object of OpenApiRestCall_563565
proc url_ApplicationDelete_564210(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationDelete_564209(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes the application resource identified by the name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationResourceName: JString (required)
  ##                          : The identity of the application.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564211 = path.getOrDefault("subscriptionId")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "subscriptionId", valid_564211
  var valid_564212 = path.getOrDefault("resourceGroupName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "resourceGroupName", valid_564212
  var valid_564213 = path.getOrDefault("applicationResourceName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "applicationResourceName", valid_564213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564214 = query.getOrDefault("api-version")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564214 != nil:
    section.add "api-version", valid_564214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564215: Call_ApplicationDelete_564208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the application resource identified by the name.
  ## 
  let valid = call_564215.validator(path, query, header, formData, body)
  let scheme = call_564215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564215.url(scheme.get, call_564215.host, call_564215.base,
                         call_564215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564215, url, valid)

proc call*(call_564216: Call_ApplicationDelete_564208; subscriptionId: string;
          resourceGroupName: string; applicationResourceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## applicationDelete
  ## Deletes the application resource identified by the name.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   applicationResourceName: string (required)
  ##                          : The identity of the application.
  var path_564217 = newJObject()
  var query_564218 = newJObject()
  add(query_564218, "api-version", newJString(apiVersion))
  add(path_564217, "subscriptionId", newJString(subscriptionId))
  add(path_564217, "resourceGroupName", newJString(resourceGroupName))
  add(path_564217, "applicationResourceName", newJString(applicationResourceName))
  result = call_564216.call(path_564217, query_564218, nil, nil, nil)

var applicationDelete* = Call_ApplicationDelete_564208(name: "applicationDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}",
    validator: validate_ApplicationDelete_564209, base: "",
    url: url_ApplicationDelete_564210, schemes: {Scheme.Https})
type
  Call_ServiceList_564219 = ref object of OpenApiRestCall_563565
proc url_ServiceList_564221(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceList_564220(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all services of an application resource. The information include the description and other properties of the Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationResourceName: JString (required)
  ##                          : The identity of the application.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564222 = path.getOrDefault("subscriptionId")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "subscriptionId", valid_564222
  var valid_564223 = path.getOrDefault("resourceGroupName")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "resourceGroupName", valid_564223
  var valid_564224 = path.getOrDefault("applicationResourceName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "applicationResourceName", valid_564224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564225 = query.getOrDefault("api-version")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564225 != nil:
    section.add "api-version", valid_564225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564226: Call_ServiceList_564219; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all services of an application resource. The information include the description and other properties of the Service.
  ## 
  let valid = call_564226.validator(path, query, header, formData, body)
  let scheme = call_564226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564226.url(scheme.get, call_564226.host, call_564226.base,
                         call_564226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564226, url, valid)

proc call*(call_564227: Call_ServiceList_564219; subscriptionId: string;
          resourceGroupName: string; applicationResourceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## serviceList
  ## Gets the information about all services of an application resource. The information include the description and other properties of the Service.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   applicationResourceName: string (required)
  ##                          : The identity of the application.
  var path_564228 = newJObject()
  var query_564229 = newJObject()
  add(query_564229, "api-version", newJString(apiVersion))
  add(path_564228, "subscriptionId", newJString(subscriptionId))
  add(path_564228, "resourceGroupName", newJString(resourceGroupName))
  add(path_564228, "applicationResourceName", newJString(applicationResourceName))
  result = call_564227.call(path_564228, query_564229, nil, nil, nil)

var serviceList* = Call_ServiceList_564219(name: "serviceList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}/services",
                                        validator: validate_ServiceList_564220,
                                        base: "", url: url_ServiceList_564221,
                                        schemes: {Scheme.Https})
type
  Call_ServiceGet_564230 = ref object of OpenApiRestCall_563565
proc url_ServiceGet_564232(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ServiceGet_564231(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the service resource with the given name. The information include the description and other properties of the service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationResourceName: JString (required)
  ##                          : The identity of the application.
  ##   serviceResourceName: JString (required)
  ##                      : The identity of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564233 = path.getOrDefault("subscriptionId")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "subscriptionId", valid_564233
  var valid_564234 = path.getOrDefault("resourceGroupName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "resourceGroupName", valid_564234
  var valid_564235 = path.getOrDefault("applicationResourceName")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "applicationResourceName", valid_564235
  var valid_564236 = path.getOrDefault("serviceResourceName")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "serviceResourceName", valid_564236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564237 = query.getOrDefault("api-version")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564237 != nil:
    section.add "api-version", valid_564237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564238: Call_ServiceGet_564230; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the service resource with the given name. The information include the description and other properties of the service.
  ## 
  let valid = call_564238.validator(path, query, header, formData, body)
  let scheme = call_564238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564238.url(scheme.get, call_564238.host, call_564238.base,
                         call_564238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564238, url, valid)

proc call*(call_564239: Call_ServiceGet_564230; subscriptionId: string;
          resourceGroupName: string; applicationResourceName: string;
          serviceResourceName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## serviceGet
  ## Gets the information about the service resource with the given name. The information include the description and other properties of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   applicationResourceName: string (required)
  ##                          : The identity of the application.
  ##   serviceResourceName: string (required)
  ##                      : The identity of the service.
  var path_564240 = newJObject()
  var query_564241 = newJObject()
  add(query_564241, "api-version", newJString(apiVersion))
  add(path_564240, "subscriptionId", newJString(subscriptionId))
  add(path_564240, "resourceGroupName", newJString(resourceGroupName))
  add(path_564240, "applicationResourceName", newJString(applicationResourceName))
  add(path_564240, "serviceResourceName", newJString(serviceResourceName))
  result = call_564239.call(path_564240, query_564241, nil, nil, nil)

var serviceGet* = Call_ServiceGet_564230(name: "serviceGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}/services/{serviceResourceName}",
                                      validator: validate_ServiceGet_564231,
                                      base: "", url: url_ServiceGet_564232,
                                      schemes: {Scheme.Https})
type
  Call_ServiceReplicaList_564242 = ref object of OpenApiRestCall_563565
proc url_ServiceReplicaList_564244(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceReplicaList_564243(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the information about all replicas of a given service of an application. The information includes the runtime properties of the replica instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationResourceName: JString (required)
  ##                          : The identity of the application.
  ##   serviceResourceName: JString (required)
  ##                      : The identity of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564245 = path.getOrDefault("subscriptionId")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "subscriptionId", valid_564245
  var valid_564246 = path.getOrDefault("resourceGroupName")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "resourceGroupName", valid_564246
  var valid_564247 = path.getOrDefault("applicationResourceName")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "applicationResourceName", valid_564247
  var valid_564248 = path.getOrDefault("serviceResourceName")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "serviceResourceName", valid_564248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564249 = query.getOrDefault("api-version")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564249 != nil:
    section.add "api-version", valid_564249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564250: Call_ServiceReplicaList_564242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all replicas of a given service of an application. The information includes the runtime properties of the replica instance.
  ## 
  let valid = call_564250.validator(path, query, header, formData, body)
  let scheme = call_564250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564250.url(scheme.get, call_564250.host, call_564250.base,
                         call_564250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564250, url, valid)

proc call*(call_564251: Call_ServiceReplicaList_564242; subscriptionId: string;
          resourceGroupName: string; applicationResourceName: string;
          serviceResourceName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## serviceReplicaList
  ## Gets the information about all replicas of a given service of an application. The information includes the runtime properties of the replica instance.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   applicationResourceName: string (required)
  ##                          : The identity of the application.
  ##   serviceResourceName: string (required)
  ##                      : The identity of the service.
  var path_564252 = newJObject()
  var query_564253 = newJObject()
  add(query_564253, "api-version", newJString(apiVersion))
  add(path_564252, "subscriptionId", newJString(subscriptionId))
  add(path_564252, "resourceGroupName", newJString(resourceGroupName))
  add(path_564252, "applicationResourceName", newJString(applicationResourceName))
  add(path_564252, "serviceResourceName", newJString(serviceResourceName))
  result = call_564251.call(path_564252, query_564253, nil, nil, nil)

var serviceReplicaList* = Call_ServiceReplicaList_564242(
    name: "serviceReplicaList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}/services/{serviceResourceName}/replicas",
    validator: validate_ServiceReplicaList_564243, base: "",
    url: url_ServiceReplicaList_564244, schemes: {Scheme.Https})
type
  Call_ServiceReplicaGet_564254 = ref object of OpenApiRestCall_563565
proc url_ServiceReplicaGet_564256(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceReplicaGet_564255(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the information about the service replica with the given name. The information include the description and other properties of the service replica.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   replicaName: JString (required)
  ##              : Service Fabric replica name.
  ##   applicationResourceName: JString (required)
  ##                          : The identity of the application.
  ##   serviceResourceName: JString (required)
  ##                      : The identity of the service.
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
  var valid_564259 = path.getOrDefault("replicaName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "replicaName", valid_564259
  var valid_564260 = path.getOrDefault("applicationResourceName")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "applicationResourceName", valid_564260
  var valid_564261 = path.getOrDefault("serviceResourceName")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "serviceResourceName", valid_564261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564262 = query.getOrDefault("api-version")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564262 != nil:
    section.add "api-version", valid_564262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564263: Call_ServiceReplicaGet_564254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the service replica with the given name. The information include the description and other properties of the service replica.
  ## 
  let valid = call_564263.validator(path, query, header, formData, body)
  let scheme = call_564263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564263.url(scheme.get, call_564263.host, call_564263.base,
                         call_564263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564263, url, valid)

proc call*(call_564264: Call_ServiceReplicaGet_564254; subscriptionId: string;
          resourceGroupName: string; replicaName: string;
          applicationResourceName: string; serviceResourceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## serviceReplicaGet
  ## Gets the information about the service replica with the given name. The information include the description and other properties of the service replica.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   replicaName: string (required)
  ##              : Service Fabric replica name.
  ##   applicationResourceName: string (required)
  ##                          : The identity of the application.
  ##   serviceResourceName: string (required)
  ##                      : The identity of the service.
  var path_564265 = newJObject()
  var query_564266 = newJObject()
  add(query_564266, "api-version", newJString(apiVersion))
  add(path_564265, "subscriptionId", newJString(subscriptionId))
  add(path_564265, "resourceGroupName", newJString(resourceGroupName))
  add(path_564265, "replicaName", newJString(replicaName))
  add(path_564265, "applicationResourceName", newJString(applicationResourceName))
  add(path_564265, "serviceResourceName", newJString(serviceResourceName))
  result = call_564264.call(path_564265, query_564266, nil, nil, nil)

var serviceReplicaGet* = Call_ServiceReplicaGet_564254(name: "serviceReplicaGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}/services/{serviceResourceName}/replicas/{replicaName}",
    validator: validate_ServiceReplicaGet_564255, base: "",
    url: url_ServiceReplicaGet_564256, schemes: {Scheme.Https})
type
  Call_CodePackageGetContainerLogs_564267 = ref object of OpenApiRestCall_563565
proc url_CodePackageGetContainerLogs_564269(protocol: Scheme; host: string;
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

proc validate_CodePackageGetContainerLogs_564268(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the logs for the container of the specified code package of the service replica.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   codePackageName: JString (required)
  ##                  : The name of code package of the service.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   replicaName: JString (required)
  ##              : Service Fabric replica name.
  ##   applicationResourceName: JString (required)
  ##                          : The identity of the application.
  ##   serviceResourceName: JString (required)
  ##                      : The identity of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `codePackageName` field"
  var valid_564270 = path.getOrDefault("codePackageName")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "codePackageName", valid_564270
  var valid_564271 = path.getOrDefault("subscriptionId")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "subscriptionId", valid_564271
  var valid_564272 = path.getOrDefault("resourceGroupName")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "resourceGroupName", valid_564272
  var valid_564273 = path.getOrDefault("replicaName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "replicaName", valid_564273
  var valid_564274 = path.getOrDefault("applicationResourceName")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "applicationResourceName", valid_564274
  var valid_564275 = path.getOrDefault("serviceResourceName")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "serviceResourceName", valid_564275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   tail: JInt
  ##       : Number of lines to show from the end of the logs. Default is 100.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564276 = query.getOrDefault("api-version")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564276 != nil:
    section.add "api-version", valid_564276
  var valid_564277 = query.getOrDefault("tail")
  valid_564277 = validateParameter(valid_564277, JInt, required = false, default = nil)
  if valid_564277 != nil:
    section.add "tail", valid_564277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564278: Call_CodePackageGetContainerLogs_564267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the logs for the container of the specified code package of the service replica.
  ## 
  let valid = call_564278.validator(path, query, header, formData, body)
  let scheme = call_564278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564278.url(scheme.get, call_564278.host, call_564278.base,
                         call_564278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564278, url, valid)

proc call*(call_564279: Call_CodePackageGetContainerLogs_564267;
          codePackageName: string; subscriptionId: string;
          resourceGroupName: string; replicaName: string;
          applicationResourceName: string; serviceResourceName: string;
          apiVersion: string = "2018-09-01-preview"; tail: int = 0): Recallable =
  ## codePackageGetContainerLogs
  ## Gets the logs for the container of the specified code package of the service replica.
  ##   codePackageName: string (required)
  ##                  : The name of code package of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   tail: int
  ##       : Number of lines to show from the end of the logs. Default is 100.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   replicaName: string (required)
  ##              : Service Fabric replica name.
  ##   applicationResourceName: string (required)
  ##                          : The identity of the application.
  ##   serviceResourceName: string (required)
  ##                      : The identity of the service.
  var path_564280 = newJObject()
  var query_564281 = newJObject()
  add(path_564280, "codePackageName", newJString(codePackageName))
  add(query_564281, "api-version", newJString(apiVersion))
  add(path_564280, "subscriptionId", newJString(subscriptionId))
  add(query_564281, "tail", newJInt(tail))
  add(path_564280, "resourceGroupName", newJString(resourceGroupName))
  add(path_564280, "replicaName", newJString(replicaName))
  add(path_564280, "applicationResourceName", newJString(applicationResourceName))
  add(path_564280, "serviceResourceName", newJString(serviceResourceName))
  result = call_564279.call(path_564280, query_564281, nil, nil, nil)

var codePackageGetContainerLogs* = Call_CodePackageGetContainerLogs_564267(
    name: "codePackageGetContainerLogs", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}/services/{serviceResourceName}/replicas/{replicaName}/codePackages/{codePackageName}/logs",
    validator: validate_CodePackageGetContainerLogs_564268, base: "",
    url: url_CodePackageGetContainerLogs_564269, schemes: {Scheme.Https})
type
  Call_GatewayListByResourceGroup_564282 = ref object of OpenApiRestCall_563565
proc url_GatewayListByResourceGroup_564284(protocol: Scheme; host: string;
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

proc validate_GatewayListByResourceGroup_564283(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all gateway resources in a given resource group. The information include the description and other properties of the Gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564285 = path.getOrDefault("subscriptionId")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "subscriptionId", valid_564285
  var valid_564286 = path.getOrDefault("resourceGroupName")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "resourceGroupName", valid_564286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564287 = query.getOrDefault("api-version")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564287 != nil:
    section.add "api-version", valid_564287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564288: Call_GatewayListByResourceGroup_564282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all gateway resources in a given resource group. The information include the description and other properties of the Gateway.
  ## 
  let valid = call_564288.validator(path, query, header, formData, body)
  let scheme = call_564288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564288.url(scheme.get, call_564288.host, call_564288.base,
                         call_564288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564288, url, valid)

proc call*(call_564289: Call_GatewayListByResourceGroup_564282;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## gatewayListByResourceGroup
  ## Gets the information about all gateway resources in a given resource group. The information include the description and other properties of the Gateway.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564290 = newJObject()
  var query_564291 = newJObject()
  add(query_564291, "api-version", newJString(apiVersion))
  add(path_564290, "subscriptionId", newJString(subscriptionId))
  add(path_564290, "resourceGroupName", newJString(resourceGroupName))
  result = call_564289.call(path_564290, query_564291, nil, nil, nil)

var gatewayListByResourceGroup* = Call_GatewayListByResourceGroup_564282(
    name: "gatewayListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/gateways",
    validator: validate_GatewayListByResourceGroup_564283, base: "",
    url: url_GatewayListByResourceGroup_564284, schemes: {Scheme.Https})
type
  Call_GatewayCreate_564303 = ref object of OpenApiRestCall_563565
proc url_GatewayCreate_564305(protocol: Scheme; host: string; base: string;
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

proc validate_GatewayCreate_564304(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a gateway resource with the specified name, description and properties. If a gateway resource with the same name exists, then it is updated with the specified description and properties. Use gateway resources to create a gateway for public connectivity for services within your application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   gatewayResourceName: JString (required)
  ##                      : The identity of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `gatewayResourceName` field"
  var valid_564306 = path.getOrDefault("gatewayResourceName")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "gatewayResourceName", valid_564306
  var valid_564307 = path.getOrDefault("subscriptionId")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "subscriptionId", valid_564307
  var valid_564308 = path.getOrDefault("resourceGroupName")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "resourceGroupName", valid_564308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564309 = query.getOrDefault("api-version")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564309 != nil:
    section.add "api-version", valid_564309
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

proc call*(call_564311: Call_GatewayCreate_564303; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a gateway resource with the specified name, description and properties. If a gateway resource with the same name exists, then it is updated with the specified description and properties. Use gateway resources to create a gateway for public connectivity for services within your application.
  ## 
  let valid = call_564311.validator(path, query, header, formData, body)
  let scheme = call_564311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564311.url(scheme.get, call_564311.host, call_564311.base,
                         call_564311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564311, url, valid)

proc call*(call_564312: Call_GatewayCreate_564303; gatewayResourceName: string;
          gatewayResourceDescription: JsonNode; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## gatewayCreate
  ## Creates a gateway resource with the specified name, description and properties. If a gateway resource with the same name exists, then it is updated with the specified description and properties. Use gateway resources to create a gateway for public connectivity for services within your application.
  ##   gatewayResourceName: string (required)
  ##                      : The identity of the gateway.
  ##   gatewayResourceDescription: JObject (required)
  ##                             : Description for creating a Gateway resource.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564313 = newJObject()
  var query_564314 = newJObject()
  var body_564315 = newJObject()
  add(path_564313, "gatewayResourceName", newJString(gatewayResourceName))
  if gatewayResourceDescription != nil:
    body_564315 = gatewayResourceDescription
  add(query_564314, "api-version", newJString(apiVersion))
  add(path_564313, "subscriptionId", newJString(subscriptionId))
  add(path_564313, "resourceGroupName", newJString(resourceGroupName))
  result = call_564312.call(path_564313, query_564314, nil, nil, body_564315)

var gatewayCreate* = Call_GatewayCreate_564303(name: "gatewayCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/gateways/{gatewayResourceName}",
    validator: validate_GatewayCreate_564304, base: "", url: url_GatewayCreate_564305,
    schemes: {Scheme.Https})
type
  Call_GatewayGet_564292 = ref object of OpenApiRestCall_563565
proc url_GatewayGet_564294(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GatewayGet_564293(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the gateway resource with the given name. The information include the description and other properties of the gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   gatewayResourceName: JString (required)
  ##                      : The identity of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `gatewayResourceName` field"
  var valid_564295 = path.getOrDefault("gatewayResourceName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "gatewayResourceName", valid_564295
  var valid_564296 = path.getOrDefault("subscriptionId")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "subscriptionId", valid_564296
  var valid_564297 = path.getOrDefault("resourceGroupName")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "resourceGroupName", valid_564297
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564298 = query.getOrDefault("api-version")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564298 != nil:
    section.add "api-version", valid_564298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564299: Call_GatewayGet_564292; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the gateway resource with the given name. The information include the description and other properties of the gateway.
  ## 
  let valid = call_564299.validator(path, query, header, formData, body)
  let scheme = call_564299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564299.url(scheme.get, call_564299.host, call_564299.base,
                         call_564299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564299, url, valid)

proc call*(call_564300: Call_GatewayGet_564292; gatewayResourceName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## gatewayGet
  ## Gets the information about the gateway resource with the given name. The information include the description and other properties of the gateway.
  ##   gatewayResourceName: string (required)
  ##                      : The identity of the gateway.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564301 = newJObject()
  var query_564302 = newJObject()
  add(path_564301, "gatewayResourceName", newJString(gatewayResourceName))
  add(query_564302, "api-version", newJString(apiVersion))
  add(path_564301, "subscriptionId", newJString(subscriptionId))
  add(path_564301, "resourceGroupName", newJString(resourceGroupName))
  result = call_564300.call(path_564301, query_564302, nil, nil, nil)

var gatewayGet* = Call_GatewayGet_564292(name: "gatewayGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/gateways/{gatewayResourceName}",
                                      validator: validate_GatewayGet_564293,
                                      base: "", url: url_GatewayGet_564294,
                                      schemes: {Scheme.Https})
type
  Call_GatewayDelete_564316 = ref object of OpenApiRestCall_563565
proc url_GatewayDelete_564318(protocol: Scheme; host: string; base: string;
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

proc validate_GatewayDelete_564317(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the gateway resource identified by the name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   gatewayResourceName: JString (required)
  ##                      : The identity of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `gatewayResourceName` field"
  var valid_564319 = path.getOrDefault("gatewayResourceName")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "gatewayResourceName", valid_564319
  var valid_564320 = path.getOrDefault("subscriptionId")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "subscriptionId", valid_564320
  var valid_564321 = path.getOrDefault("resourceGroupName")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "resourceGroupName", valid_564321
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564322 = query.getOrDefault("api-version")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564322 != nil:
    section.add "api-version", valid_564322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564323: Call_GatewayDelete_564316; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the gateway resource identified by the name.
  ## 
  let valid = call_564323.validator(path, query, header, formData, body)
  let scheme = call_564323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564323.url(scheme.get, call_564323.host, call_564323.base,
                         call_564323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564323, url, valid)

proc call*(call_564324: Call_GatewayDelete_564316; gatewayResourceName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## gatewayDelete
  ## Deletes the gateway resource identified by the name.
  ##   gatewayResourceName: string (required)
  ##                      : The identity of the gateway.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564325 = newJObject()
  var query_564326 = newJObject()
  add(path_564325, "gatewayResourceName", newJString(gatewayResourceName))
  add(query_564326, "api-version", newJString(apiVersion))
  add(path_564325, "subscriptionId", newJString(subscriptionId))
  add(path_564325, "resourceGroupName", newJString(resourceGroupName))
  result = call_564324.call(path_564325, query_564326, nil, nil, nil)

var gatewayDelete* = Call_GatewayDelete_564316(name: "gatewayDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/gateways/{gatewayResourceName}",
    validator: validate_GatewayDelete_564317, base: "", url: url_GatewayDelete_564318,
    schemes: {Scheme.Https})
type
  Call_NetworkListByResourceGroup_564327 = ref object of OpenApiRestCall_563565
proc url_NetworkListByResourceGroup_564329(protocol: Scheme; host: string;
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

proc validate_NetworkListByResourceGroup_564328(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all network resources in a given resource group. The information include the description and other properties of the Network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564330 = path.getOrDefault("subscriptionId")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "subscriptionId", valid_564330
  var valid_564331 = path.getOrDefault("resourceGroupName")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "resourceGroupName", valid_564331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564332 = query.getOrDefault("api-version")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564332 != nil:
    section.add "api-version", valid_564332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564333: Call_NetworkListByResourceGroup_564327; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all network resources in a given resource group. The information include the description and other properties of the Network.
  ## 
  let valid = call_564333.validator(path, query, header, formData, body)
  let scheme = call_564333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564333.url(scheme.get, call_564333.host, call_564333.base,
                         call_564333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564333, url, valid)

proc call*(call_564334: Call_NetworkListByResourceGroup_564327;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## networkListByResourceGroup
  ## Gets the information about all network resources in a given resource group. The information include the description and other properties of the Network.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564335 = newJObject()
  var query_564336 = newJObject()
  add(query_564336, "api-version", newJString(apiVersion))
  add(path_564335, "subscriptionId", newJString(subscriptionId))
  add(path_564335, "resourceGroupName", newJString(resourceGroupName))
  result = call_564334.call(path_564335, query_564336, nil, nil, nil)

var networkListByResourceGroup* = Call_NetworkListByResourceGroup_564327(
    name: "networkListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks",
    validator: validate_NetworkListByResourceGroup_564328, base: "",
    url: url_NetworkListByResourceGroup_564329, schemes: {Scheme.Https})
type
  Call_NetworkCreate_564348 = ref object of OpenApiRestCall_563565
proc url_NetworkCreate_564350(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkCreate_564349(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a network resource with the specified name, description and properties. If a network resource with the same name exists, then it is updated with the specified description and properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   networkResourceName: JString (required)
  ##                      : The identity of the network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564351 = path.getOrDefault("subscriptionId")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "subscriptionId", valid_564351
  var valid_564352 = path.getOrDefault("resourceGroupName")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "resourceGroupName", valid_564352
  var valid_564353 = path.getOrDefault("networkResourceName")
  valid_564353 = validateParameter(valid_564353, JString, required = true,
                                 default = nil)
  if valid_564353 != nil:
    section.add "networkResourceName", valid_564353
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564354 = query.getOrDefault("api-version")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564354 != nil:
    section.add "api-version", valid_564354
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

proc call*(call_564356: Call_NetworkCreate_564348; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a network resource with the specified name, description and properties. If a network resource with the same name exists, then it is updated with the specified description and properties.
  ## 
  let valid = call_564356.validator(path, query, header, formData, body)
  let scheme = call_564356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564356.url(scheme.get, call_564356.host, call_564356.base,
                         call_564356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564356, url, valid)

proc call*(call_564357: Call_NetworkCreate_564348;
          networkResourceDescription: JsonNode; subscriptionId: string;
          resourceGroupName: string; networkResourceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## networkCreate
  ## Creates a network resource with the specified name, description and properties. If a network resource with the same name exists, then it is updated with the specified description and properties.
  ##   networkResourceDescription: JObject (required)
  ##                             : Description for creating a Network resource.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   networkResourceName: string (required)
  ##                      : The identity of the network.
  var path_564358 = newJObject()
  var query_564359 = newJObject()
  var body_564360 = newJObject()
  if networkResourceDescription != nil:
    body_564360 = networkResourceDescription
  add(query_564359, "api-version", newJString(apiVersion))
  add(path_564358, "subscriptionId", newJString(subscriptionId))
  add(path_564358, "resourceGroupName", newJString(resourceGroupName))
  add(path_564358, "networkResourceName", newJString(networkResourceName))
  result = call_564357.call(path_564358, query_564359, nil, nil, body_564360)

var networkCreate* = Call_NetworkCreate_564348(name: "networkCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks/{networkResourceName}",
    validator: validate_NetworkCreate_564349, base: "", url: url_NetworkCreate_564350,
    schemes: {Scheme.Https})
type
  Call_NetworkGet_564337 = ref object of OpenApiRestCall_563565
proc url_NetworkGet_564339(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_NetworkGet_564338(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the network resource with the given name. The information include the description and other properties of the network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   networkResourceName: JString (required)
  ##                      : The identity of the network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564340 = path.getOrDefault("subscriptionId")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "subscriptionId", valid_564340
  var valid_564341 = path.getOrDefault("resourceGroupName")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "resourceGroupName", valid_564341
  var valid_564342 = path.getOrDefault("networkResourceName")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "networkResourceName", valid_564342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564343 = query.getOrDefault("api-version")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564343 != nil:
    section.add "api-version", valid_564343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564344: Call_NetworkGet_564337; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the network resource with the given name. The information include the description and other properties of the network.
  ## 
  let valid = call_564344.validator(path, query, header, formData, body)
  let scheme = call_564344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564344.url(scheme.get, call_564344.host, call_564344.base,
                         call_564344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564344, url, valid)

proc call*(call_564345: Call_NetworkGet_564337; subscriptionId: string;
          resourceGroupName: string; networkResourceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## networkGet
  ## Gets the information about the network resource with the given name. The information include the description and other properties of the network.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   networkResourceName: string (required)
  ##                      : The identity of the network.
  var path_564346 = newJObject()
  var query_564347 = newJObject()
  add(query_564347, "api-version", newJString(apiVersion))
  add(path_564346, "subscriptionId", newJString(subscriptionId))
  add(path_564346, "resourceGroupName", newJString(resourceGroupName))
  add(path_564346, "networkResourceName", newJString(networkResourceName))
  result = call_564345.call(path_564346, query_564347, nil, nil, nil)

var networkGet* = Call_NetworkGet_564337(name: "networkGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks/{networkResourceName}",
                                      validator: validate_NetworkGet_564338,
                                      base: "", url: url_NetworkGet_564339,
                                      schemes: {Scheme.Https})
type
  Call_NetworkDelete_564361 = ref object of OpenApiRestCall_563565
proc url_NetworkDelete_564363(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkDelete_564362(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the network resource identified by the name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   networkResourceName: JString (required)
  ##                      : The identity of the network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564364 = path.getOrDefault("subscriptionId")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "subscriptionId", valid_564364
  var valid_564365 = path.getOrDefault("resourceGroupName")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "resourceGroupName", valid_564365
  var valid_564366 = path.getOrDefault("networkResourceName")
  valid_564366 = validateParameter(valid_564366, JString, required = true,
                                 default = nil)
  if valid_564366 != nil:
    section.add "networkResourceName", valid_564366
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564367 = query.getOrDefault("api-version")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564367 != nil:
    section.add "api-version", valid_564367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564368: Call_NetworkDelete_564361; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the network resource identified by the name.
  ## 
  let valid = call_564368.validator(path, query, header, formData, body)
  let scheme = call_564368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564368.url(scheme.get, call_564368.host, call_564368.base,
                         call_564368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564368, url, valid)

proc call*(call_564369: Call_NetworkDelete_564361; subscriptionId: string;
          resourceGroupName: string; networkResourceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## networkDelete
  ## Deletes the network resource identified by the name.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   networkResourceName: string (required)
  ##                      : The identity of the network.
  var path_564370 = newJObject()
  var query_564371 = newJObject()
  add(query_564371, "api-version", newJString(apiVersion))
  add(path_564370, "subscriptionId", newJString(subscriptionId))
  add(path_564370, "resourceGroupName", newJString(resourceGroupName))
  add(path_564370, "networkResourceName", newJString(networkResourceName))
  result = call_564369.call(path_564370, query_564371, nil, nil, nil)

var networkDelete* = Call_NetworkDelete_564361(name: "networkDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks/{networkResourceName}",
    validator: validate_NetworkDelete_564362, base: "", url: url_NetworkDelete_564363,
    schemes: {Scheme.Https})
type
  Call_SecretListByResourceGroup_564372 = ref object of OpenApiRestCall_563565
proc url_SecretListByResourceGroup_564374(protocol: Scheme; host: string;
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

proc validate_SecretListByResourceGroup_564373(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all secret resources in a given resource group. The information include the description and other properties of the Secret.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564375 = path.getOrDefault("subscriptionId")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "subscriptionId", valid_564375
  var valid_564376 = path.getOrDefault("resourceGroupName")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "resourceGroupName", valid_564376
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564377 = query.getOrDefault("api-version")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564377 != nil:
    section.add "api-version", valid_564377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564378: Call_SecretListByResourceGroup_564372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all secret resources in a given resource group. The information include the description and other properties of the Secret.
  ## 
  let valid = call_564378.validator(path, query, header, formData, body)
  let scheme = call_564378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564378.url(scheme.get, call_564378.host, call_564378.base,
                         call_564378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564378, url, valid)

proc call*(call_564379: Call_SecretListByResourceGroup_564372;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretListByResourceGroup
  ## Gets the information about all secret resources in a given resource group. The information include the description and other properties of the Secret.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564380 = newJObject()
  var query_564381 = newJObject()
  add(query_564381, "api-version", newJString(apiVersion))
  add(path_564380, "subscriptionId", newJString(subscriptionId))
  add(path_564380, "resourceGroupName", newJString(resourceGroupName))
  result = call_564379.call(path_564380, query_564381, nil, nil, nil)

var secretListByResourceGroup* = Call_SecretListByResourceGroup_564372(
    name: "secretListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets",
    validator: validate_SecretListByResourceGroup_564373, base: "",
    url: url_SecretListByResourceGroup_564374, schemes: {Scheme.Https})
type
  Call_SecretCreate_564393 = ref object of OpenApiRestCall_563565
proc url_SecretCreate_564395(protocol: Scheme; host: string; base: string;
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

proc validate_SecretCreate_564394(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a secret resource with the specified name, description and properties. If a secret resource with the same name exists, then it is updated with the specified description and properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secretResourceName: JString (required)
  ##                     : The name of the secret resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secretResourceName` field"
  var valid_564396 = path.getOrDefault("secretResourceName")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "secretResourceName", valid_564396
  var valid_564397 = path.getOrDefault("subscriptionId")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "subscriptionId", valid_564397
  var valid_564398 = path.getOrDefault("resourceGroupName")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = nil)
  if valid_564398 != nil:
    section.add "resourceGroupName", valid_564398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564399 = query.getOrDefault("api-version")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564399 != nil:
    section.add "api-version", valid_564399
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

proc call*(call_564401: Call_SecretCreate_564393; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a secret resource with the specified name, description and properties. If a secret resource with the same name exists, then it is updated with the specified description and properties.
  ## 
  let valid = call_564401.validator(path, query, header, formData, body)
  let scheme = call_564401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564401.url(scheme.get, call_564401.host, call_564401.base,
                         call_564401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564401, url, valid)

proc call*(call_564402: Call_SecretCreate_564393; secretResourceName: string;
          subscriptionId: string; secretResourceDescription: JsonNode;
          resourceGroupName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretCreate
  ## Creates a secret resource with the specified name, description and properties. If a secret resource with the same name exists, then it is updated with the specified description and properties.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   secretResourceName: string (required)
  ##                     : The name of the secret resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   secretResourceDescription: JObject (required)
  ##                            : Description for creating a secret resource.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564403 = newJObject()
  var query_564404 = newJObject()
  var body_564405 = newJObject()
  add(query_564404, "api-version", newJString(apiVersion))
  add(path_564403, "secretResourceName", newJString(secretResourceName))
  add(path_564403, "subscriptionId", newJString(subscriptionId))
  if secretResourceDescription != nil:
    body_564405 = secretResourceDescription
  add(path_564403, "resourceGroupName", newJString(resourceGroupName))
  result = call_564402.call(path_564403, query_564404, nil, nil, body_564405)

var secretCreate* = Call_SecretCreate_564393(name: "secretCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}",
    validator: validate_SecretCreate_564394, base: "", url: url_SecretCreate_564395,
    schemes: {Scheme.Https})
type
  Call_SecretGet_564382 = ref object of OpenApiRestCall_563565
proc url_SecretGet_564384(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SecretGet_564383(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the secret resource with the given name. The information include the description and other properties of the secret.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secretResourceName: JString (required)
  ##                     : The name of the secret resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secretResourceName` field"
  var valid_564385 = path.getOrDefault("secretResourceName")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = nil)
  if valid_564385 != nil:
    section.add "secretResourceName", valid_564385
  var valid_564386 = path.getOrDefault("subscriptionId")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "subscriptionId", valid_564386
  var valid_564387 = path.getOrDefault("resourceGroupName")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "resourceGroupName", valid_564387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564388 = query.getOrDefault("api-version")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564388 != nil:
    section.add "api-version", valid_564388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564389: Call_SecretGet_564382; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the secret resource with the given name. The information include the description and other properties of the secret.
  ## 
  let valid = call_564389.validator(path, query, header, formData, body)
  let scheme = call_564389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564389.url(scheme.get, call_564389.host, call_564389.base,
                         call_564389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564389, url, valid)

proc call*(call_564390: Call_SecretGet_564382; secretResourceName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretGet
  ## Gets the information about the secret resource with the given name. The information include the description and other properties of the secret.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   secretResourceName: string (required)
  ##                     : The name of the secret resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564391 = newJObject()
  var query_564392 = newJObject()
  add(query_564392, "api-version", newJString(apiVersion))
  add(path_564391, "secretResourceName", newJString(secretResourceName))
  add(path_564391, "subscriptionId", newJString(subscriptionId))
  add(path_564391, "resourceGroupName", newJString(resourceGroupName))
  result = call_564390.call(path_564391, query_564392, nil, nil, nil)

var secretGet* = Call_SecretGet_564382(name: "secretGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}",
                                    validator: validate_SecretGet_564383,
                                    base: "", url: url_SecretGet_564384,
                                    schemes: {Scheme.Https})
type
  Call_SecretDelete_564406 = ref object of OpenApiRestCall_563565
proc url_SecretDelete_564408(protocol: Scheme; host: string; base: string;
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

proc validate_SecretDelete_564407(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the secret resource identified by the name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secretResourceName: JString (required)
  ##                     : The name of the secret resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secretResourceName` field"
  var valid_564409 = path.getOrDefault("secretResourceName")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "secretResourceName", valid_564409
  var valid_564410 = path.getOrDefault("subscriptionId")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "subscriptionId", valid_564410
  var valid_564411 = path.getOrDefault("resourceGroupName")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = nil)
  if valid_564411 != nil:
    section.add "resourceGroupName", valid_564411
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564412 = query.getOrDefault("api-version")
  valid_564412 = validateParameter(valid_564412, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564412 != nil:
    section.add "api-version", valid_564412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564413: Call_SecretDelete_564406; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the secret resource identified by the name.
  ## 
  let valid = call_564413.validator(path, query, header, formData, body)
  let scheme = call_564413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564413.url(scheme.get, call_564413.host, call_564413.base,
                         call_564413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564413, url, valid)

proc call*(call_564414: Call_SecretDelete_564406; secretResourceName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretDelete
  ## Deletes the secret resource identified by the name.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   secretResourceName: string (required)
  ##                     : The name of the secret resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564415 = newJObject()
  var query_564416 = newJObject()
  add(query_564416, "api-version", newJString(apiVersion))
  add(path_564415, "secretResourceName", newJString(secretResourceName))
  add(path_564415, "subscriptionId", newJString(subscriptionId))
  add(path_564415, "resourceGroupName", newJString(resourceGroupName))
  result = call_564414.call(path_564415, query_564416, nil, nil, nil)

var secretDelete* = Call_SecretDelete_564406(name: "secretDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}",
    validator: validate_SecretDelete_564407, base: "", url: url_SecretDelete_564408,
    schemes: {Scheme.Https})
type
  Call_SecretValueList_564417 = ref object of OpenApiRestCall_563565
proc url_SecretValueList_564419(protocol: Scheme; host: string; base: string;
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

proc validate_SecretValueList_564418(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets information about all secret value resources of the specified secret resource. The information includes the names of the secret value resources, but not the actual values.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secretResourceName: JString (required)
  ##                     : The name of the secret resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secretResourceName` field"
  var valid_564420 = path.getOrDefault("secretResourceName")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "secretResourceName", valid_564420
  var valid_564421 = path.getOrDefault("subscriptionId")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "subscriptionId", valid_564421
  var valid_564422 = path.getOrDefault("resourceGroupName")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "resourceGroupName", valid_564422
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564423 = query.getOrDefault("api-version")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564423 != nil:
    section.add "api-version", valid_564423
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564424: Call_SecretValueList_564417; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all secret value resources of the specified secret resource. The information includes the names of the secret value resources, but not the actual values.
  ## 
  let valid = call_564424.validator(path, query, header, formData, body)
  let scheme = call_564424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564424.url(scheme.get, call_564424.host, call_564424.base,
                         call_564424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564424, url, valid)

proc call*(call_564425: Call_SecretValueList_564417; secretResourceName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretValueList
  ## Gets information about all secret value resources of the specified secret resource. The information includes the names of the secret value resources, but not the actual values.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   secretResourceName: string (required)
  ##                     : The name of the secret resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564426 = newJObject()
  var query_564427 = newJObject()
  add(query_564427, "api-version", newJString(apiVersion))
  add(path_564426, "secretResourceName", newJString(secretResourceName))
  add(path_564426, "subscriptionId", newJString(subscriptionId))
  add(path_564426, "resourceGroupName", newJString(resourceGroupName))
  result = call_564425.call(path_564426, query_564427, nil, nil, nil)

var secretValueList* = Call_SecretValueList_564417(name: "secretValueList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}/values",
    validator: validate_SecretValueList_564418, base: "", url: url_SecretValueList_564419,
    schemes: {Scheme.Https})
type
  Call_SecretValueCreate_564440 = ref object of OpenApiRestCall_563565
proc url_SecretValueCreate_564442(protocol: Scheme; host: string; base: string;
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

proc validate_SecretValueCreate_564441(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a new value of the specified secret resource. The name of the value is typically the version identifier. Once created the value cannot be changed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secretResourceName: JString (required)
  ##                     : The name of the secret resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   secretValueResourceName: JString (required)
  ##                          : The name of the secret resource value which is typically the version identifier for the value.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secretResourceName` field"
  var valid_564443 = path.getOrDefault("secretResourceName")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "secretResourceName", valid_564443
  var valid_564444 = path.getOrDefault("subscriptionId")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "subscriptionId", valid_564444
  var valid_564445 = path.getOrDefault("resourceGroupName")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "resourceGroupName", valid_564445
  var valid_564446 = path.getOrDefault("secretValueResourceName")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "secretValueResourceName", valid_564446
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564447 = query.getOrDefault("api-version")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564447 != nil:
    section.add "api-version", valid_564447
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

proc call*(call_564449: Call_SecretValueCreate_564440; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new value of the specified secret resource. The name of the value is typically the version identifier. Once created the value cannot be changed.
  ## 
  let valid = call_564449.validator(path, query, header, formData, body)
  let scheme = call_564449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564449.url(scheme.get, call_564449.host, call_564449.base,
                         call_564449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564449, url, valid)

proc call*(call_564450: Call_SecretValueCreate_564440;
          secretValueResourceDescription: JsonNode; secretResourceName: string;
          subscriptionId: string; resourceGroupName: string;
          secretValueResourceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretValueCreate
  ## Creates a new value of the specified secret resource. The name of the value is typically the version identifier. Once created the value cannot be changed.
  ##   secretValueResourceDescription: JObject (required)
  ##                                 : Description for creating a value of a secret resource.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   secretResourceName: string (required)
  ##                     : The name of the secret resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   secretValueResourceName: string (required)
  ##                          : The name of the secret resource value which is typically the version identifier for the value.
  var path_564451 = newJObject()
  var query_564452 = newJObject()
  var body_564453 = newJObject()
  if secretValueResourceDescription != nil:
    body_564453 = secretValueResourceDescription
  add(query_564452, "api-version", newJString(apiVersion))
  add(path_564451, "secretResourceName", newJString(secretResourceName))
  add(path_564451, "subscriptionId", newJString(subscriptionId))
  add(path_564451, "resourceGroupName", newJString(resourceGroupName))
  add(path_564451, "secretValueResourceName", newJString(secretValueResourceName))
  result = call_564450.call(path_564451, query_564452, nil, nil, body_564453)

var secretValueCreate* = Call_SecretValueCreate_564440(name: "secretValueCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}/values/{secretValueResourceName}",
    validator: validate_SecretValueCreate_564441, base: "",
    url: url_SecretValueCreate_564442, schemes: {Scheme.Https})
type
  Call_SecretValueGet_564428 = ref object of OpenApiRestCall_563565
proc url_SecretValueGet_564430(protocol: Scheme; host: string; base: string;
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

proc validate_SecretValueGet_564429(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get the information about the specified named secret value resources. The information does not include the actual value of the secret.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secretResourceName: JString (required)
  ##                     : The name of the secret resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   secretValueResourceName: JString (required)
  ##                          : The name of the secret resource value which is typically the version identifier for the value.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secretResourceName` field"
  var valid_564431 = path.getOrDefault("secretResourceName")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "secretResourceName", valid_564431
  var valid_564432 = path.getOrDefault("subscriptionId")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "subscriptionId", valid_564432
  var valid_564433 = path.getOrDefault("resourceGroupName")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "resourceGroupName", valid_564433
  var valid_564434 = path.getOrDefault("secretValueResourceName")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "secretValueResourceName", valid_564434
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564435 = query.getOrDefault("api-version")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564435 != nil:
    section.add "api-version", valid_564435
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564436: Call_SecretValueGet_564428; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the information about the specified named secret value resources. The information does not include the actual value of the secret.
  ## 
  let valid = call_564436.validator(path, query, header, formData, body)
  let scheme = call_564436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564436.url(scheme.get, call_564436.host, call_564436.base,
                         call_564436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564436, url, valid)

proc call*(call_564437: Call_SecretValueGet_564428; secretResourceName: string;
          subscriptionId: string; resourceGroupName: string;
          secretValueResourceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretValueGet
  ## Get the information about the specified named secret value resources. The information does not include the actual value of the secret.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   secretResourceName: string (required)
  ##                     : The name of the secret resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   secretValueResourceName: string (required)
  ##                          : The name of the secret resource value which is typically the version identifier for the value.
  var path_564438 = newJObject()
  var query_564439 = newJObject()
  add(query_564439, "api-version", newJString(apiVersion))
  add(path_564438, "secretResourceName", newJString(secretResourceName))
  add(path_564438, "subscriptionId", newJString(subscriptionId))
  add(path_564438, "resourceGroupName", newJString(resourceGroupName))
  add(path_564438, "secretValueResourceName", newJString(secretValueResourceName))
  result = call_564437.call(path_564438, query_564439, nil, nil, nil)

var secretValueGet* = Call_SecretValueGet_564428(name: "secretValueGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}/values/{secretValueResourceName}",
    validator: validate_SecretValueGet_564429, base: "", url: url_SecretValueGet_564430,
    schemes: {Scheme.Https})
type
  Call_SecretValueDelete_564454 = ref object of OpenApiRestCall_563565
proc url_SecretValueDelete_564456(protocol: Scheme; host: string; base: string;
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

proc validate_SecretValueDelete_564455(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes the secret value resource identified by the name. The name of the resource is typically the version associated with that value. Deletion will fail if the specified value is in use.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secretResourceName: JString (required)
  ##                     : The name of the secret resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   secretValueResourceName: JString (required)
  ##                          : The name of the secret resource value which is typically the version identifier for the value.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secretResourceName` field"
  var valid_564457 = path.getOrDefault("secretResourceName")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "secretResourceName", valid_564457
  var valid_564458 = path.getOrDefault("subscriptionId")
  valid_564458 = validateParameter(valid_564458, JString, required = true,
                                 default = nil)
  if valid_564458 != nil:
    section.add "subscriptionId", valid_564458
  var valid_564459 = path.getOrDefault("resourceGroupName")
  valid_564459 = validateParameter(valid_564459, JString, required = true,
                                 default = nil)
  if valid_564459 != nil:
    section.add "resourceGroupName", valid_564459
  var valid_564460 = path.getOrDefault("secretValueResourceName")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "secretValueResourceName", valid_564460
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564461 = query.getOrDefault("api-version")
  valid_564461 = validateParameter(valid_564461, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564461 != nil:
    section.add "api-version", valid_564461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564462: Call_SecretValueDelete_564454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the secret value resource identified by the name. The name of the resource is typically the version associated with that value. Deletion will fail if the specified value is in use.
  ## 
  let valid = call_564462.validator(path, query, header, formData, body)
  let scheme = call_564462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564462.url(scheme.get, call_564462.host, call_564462.base,
                         call_564462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564462, url, valid)

proc call*(call_564463: Call_SecretValueDelete_564454; secretResourceName: string;
          subscriptionId: string; resourceGroupName: string;
          secretValueResourceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretValueDelete
  ## Deletes the secret value resource identified by the name. The name of the resource is typically the version associated with that value. Deletion will fail if the specified value is in use.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   secretResourceName: string (required)
  ##                     : The name of the secret resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   secretValueResourceName: string (required)
  ##                          : The name of the secret resource value which is typically the version identifier for the value.
  var path_564464 = newJObject()
  var query_564465 = newJObject()
  add(query_564465, "api-version", newJString(apiVersion))
  add(path_564464, "secretResourceName", newJString(secretResourceName))
  add(path_564464, "subscriptionId", newJString(subscriptionId))
  add(path_564464, "resourceGroupName", newJString(resourceGroupName))
  add(path_564464, "secretValueResourceName", newJString(secretValueResourceName))
  result = call_564463.call(path_564464, query_564465, nil, nil, nil)

var secretValueDelete* = Call_SecretValueDelete_564454(name: "secretValueDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}/values/{secretValueResourceName}",
    validator: validate_SecretValueDelete_564455, base: "",
    url: url_SecretValueDelete_564456, schemes: {Scheme.Https})
type
  Call_SecretValueListValue_564466 = ref object of OpenApiRestCall_563565
proc url_SecretValueListValue_564468(protocol: Scheme; host: string; base: string;
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

proc validate_SecretValueListValue_564467(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the decrypted value of the specified named value of the secret resource. This is a privileged operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secretResourceName: JString (required)
  ##                     : The name of the secret resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   secretValueResourceName: JString (required)
  ##                          : The name of the secret resource value which is typically the version identifier for the value.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secretResourceName` field"
  var valid_564469 = path.getOrDefault("secretResourceName")
  valid_564469 = validateParameter(valid_564469, JString, required = true,
                                 default = nil)
  if valid_564469 != nil:
    section.add "secretResourceName", valid_564469
  var valid_564470 = path.getOrDefault("subscriptionId")
  valid_564470 = validateParameter(valid_564470, JString, required = true,
                                 default = nil)
  if valid_564470 != nil:
    section.add "subscriptionId", valid_564470
  var valid_564471 = path.getOrDefault("resourceGroupName")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "resourceGroupName", valid_564471
  var valid_564472 = path.getOrDefault("secretValueResourceName")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "secretValueResourceName", valid_564472
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564473 = query.getOrDefault("api-version")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564473 != nil:
    section.add "api-version", valid_564473
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564474: Call_SecretValueListValue_564466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the decrypted value of the specified named value of the secret resource. This is a privileged operation.
  ## 
  let valid = call_564474.validator(path, query, header, formData, body)
  let scheme = call_564474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564474.url(scheme.get, call_564474.host, call_564474.base,
                         call_564474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564474, url, valid)

proc call*(call_564475: Call_SecretValueListValue_564466;
          secretResourceName: string; subscriptionId: string;
          resourceGroupName: string; secretValueResourceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretValueListValue
  ## Lists the decrypted value of the specified named value of the secret resource. This is a privileged operation.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   secretResourceName: string (required)
  ##                     : The name of the secret resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   secretValueResourceName: string (required)
  ##                          : The name of the secret resource value which is typically the version identifier for the value.
  var path_564476 = newJObject()
  var query_564477 = newJObject()
  add(query_564477, "api-version", newJString(apiVersion))
  add(path_564476, "secretResourceName", newJString(secretResourceName))
  add(path_564476, "subscriptionId", newJString(subscriptionId))
  add(path_564476, "resourceGroupName", newJString(resourceGroupName))
  add(path_564476, "secretValueResourceName", newJString(secretValueResourceName))
  result = call_564475.call(path_564476, query_564477, nil, nil, nil)

var secretValueListValue* = Call_SecretValueListValue_564466(
    name: "secretValueListValue", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}/values/{secretValueResourceName}/list_value",
    validator: validate_SecretValueListValue_564467, base: "",
    url: url_SecretValueListValue_564468, schemes: {Scheme.Https})
type
  Call_VolumeListByResourceGroup_564478 = ref object of OpenApiRestCall_563565
proc url_VolumeListByResourceGroup_564480(protocol: Scheme; host: string;
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

proc validate_VolumeListByResourceGroup_564479(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all volume resources in a given resource group. The information include the description and other properties of the Volume.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564481 = path.getOrDefault("subscriptionId")
  valid_564481 = validateParameter(valid_564481, JString, required = true,
                                 default = nil)
  if valid_564481 != nil:
    section.add "subscriptionId", valid_564481
  var valid_564482 = path.getOrDefault("resourceGroupName")
  valid_564482 = validateParameter(valid_564482, JString, required = true,
                                 default = nil)
  if valid_564482 != nil:
    section.add "resourceGroupName", valid_564482
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564483 = query.getOrDefault("api-version")
  valid_564483 = validateParameter(valid_564483, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564483 != nil:
    section.add "api-version", valid_564483
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564484: Call_VolumeListByResourceGroup_564478; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all volume resources in a given resource group. The information include the description and other properties of the Volume.
  ## 
  let valid = call_564484.validator(path, query, header, formData, body)
  let scheme = call_564484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564484.url(scheme.get, call_564484.host, call_564484.base,
                         call_564484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564484, url, valid)

proc call*(call_564485: Call_VolumeListByResourceGroup_564478;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## volumeListByResourceGroup
  ## Gets the information about all volume resources in a given resource group. The information include the description and other properties of the Volume.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564486 = newJObject()
  var query_564487 = newJObject()
  add(query_564487, "api-version", newJString(apiVersion))
  add(path_564486, "subscriptionId", newJString(subscriptionId))
  add(path_564486, "resourceGroupName", newJString(resourceGroupName))
  result = call_564485.call(path_564486, query_564487, nil, nil, nil)

var volumeListByResourceGroup* = Call_VolumeListByResourceGroup_564478(
    name: "volumeListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes",
    validator: validate_VolumeListByResourceGroup_564479, base: "",
    url: url_VolumeListByResourceGroup_564480, schemes: {Scheme.Https})
type
  Call_VolumeCreate_564499 = ref object of OpenApiRestCall_563565
proc url_VolumeCreate_564501(protocol: Scheme; host: string; base: string;
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

proc validate_VolumeCreate_564500(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a volume resource with the specified name, description and properties. If a volume resource with the same name exists, then it is updated with the specified description and properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeResourceName: JString (required)
  ##                     : The identity of the volume.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `volumeResourceName` field"
  var valid_564502 = path.getOrDefault("volumeResourceName")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "volumeResourceName", valid_564502
  var valid_564503 = path.getOrDefault("subscriptionId")
  valid_564503 = validateParameter(valid_564503, JString, required = true,
                                 default = nil)
  if valid_564503 != nil:
    section.add "subscriptionId", valid_564503
  var valid_564504 = path.getOrDefault("resourceGroupName")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "resourceGroupName", valid_564504
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564505 = query.getOrDefault("api-version")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564505 != nil:
    section.add "api-version", valid_564505
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

proc call*(call_564507: Call_VolumeCreate_564499; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a volume resource with the specified name, description and properties. If a volume resource with the same name exists, then it is updated with the specified description and properties.
  ## 
  let valid = call_564507.validator(path, query, header, formData, body)
  let scheme = call_564507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564507.url(scheme.get, call_564507.host, call_564507.base,
                         call_564507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564507, url, valid)

proc call*(call_564508: Call_VolumeCreate_564499;
          volumeResourceDescription: JsonNode; volumeResourceName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## volumeCreate
  ## Creates a volume resource with the specified name, description and properties. If a volume resource with the same name exists, then it is updated with the specified description and properties.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   volumeResourceDescription: JObject (required)
  ##                            : Description for creating a Volume resource.
  ##   volumeResourceName: string (required)
  ##                     : The identity of the volume.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564509 = newJObject()
  var query_564510 = newJObject()
  var body_564511 = newJObject()
  add(query_564510, "api-version", newJString(apiVersion))
  if volumeResourceDescription != nil:
    body_564511 = volumeResourceDescription
  add(path_564509, "volumeResourceName", newJString(volumeResourceName))
  add(path_564509, "subscriptionId", newJString(subscriptionId))
  add(path_564509, "resourceGroupName", newJString(resourceGroupName))
  result = call_564508.call(path_564509, query_564510, nil, nil, body_564511)

var volumeCreate* = Call_VolumeCreate_564499(name: "volumeCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes/{volumeResourceName}",
    validator: validate_VolumeCreate_564500, base: "", url: url_VolumeCreate_564501,
    schemes: {Scheme.Https})
type
  Call_VolumeGet_564488 = ref object of OpenApiRestCall_563565
proc url_VolumeGet_564490(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_VolumeGet_564489(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the volume resource with the given name. The information include the description and other properties of the volume.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeResourceName: JString (required)
  ##                     : The identity of the volume.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `volumeResourceName` field"
  var valid_564491 = path.getOrDefault("volumeResourceName")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "volumeResourceName", valid_564491
  var valid_564492 = path.getOrDefault("subscriptionId")
  valid_564492 = validateParameter(valid_564492, JString, required = true,
                                 default = nil)
  if valid_564492 != nil:
    section.add "subscriptionId", valid_564492
  var valid_564493 = path.getOrDefault("resourceGroupName")
  valid_564493 = validateParameter(valid_564493, JString, required = true,
                                 default = nil)
  if valid_564493 != nil:
    section.add "resourceGroupName", valid_564493
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564494 = query.getOrDefault("api-version")
  valid_564494 = validateParameter(valid_564494, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564494 != nil:
    section.add "api-version", valid_564494
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564495: Call_VolumeGet_564488; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the volume resource with the given name. The information include the description and other properties of the volume.
  ## 
  let valid = call_564495.validator(path, query, header, formData, body)
  let scheme = call_564495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564495.url(scheme.get, call_564495.host, call_564495.base,
                         call_564495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564495, url, valid)

proc call*(call_564496: Call_VolumeGet_564488; volumeResourceName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## volumeGet
  ## Gets the information about the volume resource with the given name. The information include the description and other properties of the volume.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   volumeResourceName: string (required)
  ##                     : The identity of the volume.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564497 = newJObject()
  var query_564498 = newJObject()
  add(query_564498, "api-version", newJString(apiVersion))
  add(path_564497, "volumeResourceName", newJString(volumeResourceName))
  add(path_564497, "subscriptionId", newJString(subscriptionId))
  add(path_564497, "resourceGroupName", newJString(resourceGroupName))
  result = call_564496.call(path_564497, query_564498, nil, nil, nil)

var volumeGet* = Call_VolumeGet_564488(name: "volumeGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes/{volumeResourceName}",
                                    validator: validate_VolumeGet_564489,
                                    base: "", url: url_VolumeGet_564490,
                                    schemes: {Scheme.Https})
type
  Call_VolumeDelete_564512 = ref object of OpenApiRestCall_563565
proc url_VolumeDelete_564514(protocol: Scheme; host: string; base: string;
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

proc validate_VolumeDelete_564513(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the volume resource identified by the name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   volumeResourceName: JString (required)
  ##                     : The identity of the volume.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `volumeResourceName` field"
  var valid_564515 = path.getOrDefault("volumeResourceName")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = nil)
  if valid_564515 != nil:
    section.add "volumeResourceName", valid_564515
  var valid_564516 = path.getOrDefault("subscriptionId")
  valid_564516 = validateParameter(valid_564516, JString, required = true,
                                 default = nil)
  if valid_564516 != nil:
    section.add "subscriptionId", valid_564516
  var valid_564517 = path.getOrDefault("resourceGroupName")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "resourceGroupName", valid_564517
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564518 = query.getOrDefault("api-version")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_564518 != nil:
    section.add "api-version", valid_564518
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564519: Call_VolumeDelete_564512; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the volume resource identified by the name.
  ## 
  let valid = call_564519.validator(path, query, header, formData, body)
  let scheme = call_564519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564519.url(scheme.get, call_564519.host, call_564519.base,
                         call_564519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564519, url, valid)

proc call*(call_564520: Call_VolumeDelete_564512; volumeResourceName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## volumeDelete
  ## Deletes the volume resource identified by the name.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   volumeResourceName: string (required)
  ##                     : The identity of the volume.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564521 = newJObject()
  var query_564522 = newJObject()
  add(query_564522, "api-version", newJString(apiVersion))
  add(path_564521, "volumeResourceName", newJString(volumeResourceName))
  add(path_564521, "subscriptionId", newJString(subscriptionId))
  add(path_564521, "resourceGroupName", newJString(resourceGroupName))
  result = call_564520.call(path_564521, query_564522, nil, nil, nil)

var volumeDelete* = Call_VolumeDelete_564512(name: "volumeDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes/{volumeResourceName}",
    validator: validate_VolumeDelete_564513, base: "", url: url_VolumeDelete_564514,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
