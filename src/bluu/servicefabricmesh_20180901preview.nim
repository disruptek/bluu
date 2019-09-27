
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593438 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593438](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593438): Option[Scheme] {.used.} =
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
  macServiceName = "servicefabricmesh"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593660 = ref object of OpenApiRestCall_593438
proc url_OperationsList_593662(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593661(path: JsonNode; query: JsonNode;
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
  var valid_593834 = query.getOrDefault("api-version")
  valid_593834 = validateParameter(valid_593834, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_593834 != nil:
    section.add "api-version", valid_593834
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593857: Call_OperationsList_593660; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available operations provided by Service Fabric SeaBreeze resource provider.
  ## 
  let valid = call_593857.validator(path, query, header, formData, body)
  let scheme = call_593857.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593857.url(scheme.get, call_593857.host, call_593857.base,
                         call_593857.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593857, url, valid)

proc call*(call_593928: Call_OperationsList_593660;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## operationsList
  ## Lists all the available operations provided by Service Fabric SeaBreeze resource provider.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  var query_593929 = newJObject()
  add(query_593929, "api-version", newJString(apiVersion))
  result = call_593928.call(nil, query_593929, nil, nil, nil)

var operationsList* = Call_OperationsList_593660(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ServiceFabricMesh/operations",
    validator: validate_OperationsList_593661, base: "", url: url_OperationsList_593662,
    schemes: {Scheme.Https})
type
  Call_ApplicationListBySubscription_593969 = ref object of OpenApiRestCall_593438
proc url_ApplicationListBySubscription_593971(protocol: Scheme; host: string;
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

proc validate_ApplicationListBySubscription_593970(path: JsonNode; query: JsonNode;
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
  var valid_593986 = path.getOrDefault("subscriptionId")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "subscriptionId", valid_593986
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593987 = query.getOrDefault("api-version")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_593987 != nil:
    section.add "api-version", valid_593987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593988: Call_ApplicationListBySubscription_593969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all application resources in a given resource group. The information include the description and other properties of the application.
  ## 
  let valid = call_593988.validator(path, query, header, formData, body)
  let scheme = call_593988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593988.url(scheme.get, call_593988.host, call_593988.base,
                         call_593988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593988, url, valid)

proc call*(call_593989: Call_ApplicationListBySubscription_593969;
          subscriptionId: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## applicationListBySubscription
  ## Gets the information about all application resources in a given resource group. The information include the description and other properties of the application.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_593990 = newJObject()
  var query_593991 = newJObject()
  add(query_593991, "api-version", newJString(apiVersion))
  add(path_593990, "subscriptionId", newJString(subscriptionId))
  result = call_593989.call(path_593990, query_593991, nil, nil, nil)

var applicationListBySubscription* = Call_ApplicationListBySubscription_593969(
    name: "applicationListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/applications",
    validator: validate_ApplicationListBySubscription_593970, base: "",
    url: url_ApplicationListBySubscription_593971, schemes: {Scheme.Https})
type
  Call_GatewayListBySubscription_593992 = ref object of OpenApiRestCall_593438
proc url_GatewayListBySubscription_593994(protocol: Scheme; host: string;
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

proc validate_GatewayListBySubscription_593993(path: JsonNode; query: JsonNode;
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
  var valid_593995 = path.getOrDefault("subscriptionId")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "subscriptionId", valid_593995
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593996 = query.getOrDefault("api-version")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_593996 != nil:
    section.add "api-version", valid_593996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593997: Call_GatewayListBySubscription_593992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all gateway resources in a given resource group. The information include the description and other properties of the gateway.
  ## 
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_GatewayListBySubscription_593992;
          subscriptionId: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## gatewayListBySubscription
  ## Gets the information about all gateway resources in a given resource group. The information include the description and other properties of the gateway.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_593999 = newJObject()
  var query_594000 = newJObject()
  add(query_594000, "api-version", newJString(apiVersion))
  add(path_593999, "subscriptionId", newJString(subscriptionId))
  result = call_593998.call(path_593999, query_594000, nil, nil, nil)

var gatewayListBySubscription* = Call_GatewayListBySubscription_593992(
    name: "gatewayListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/gateways",
    validator: validate_GatewayListBySubscription_593993, base: "",
    url: url_GatewayListBySubscription_593994, schemes: {Scheme.Https})
type
  Call_NetworkListBySubscription_594001 = ref object of OpenApiRestCall_593438
proc url_NetworkListBySubscription_594003(protocol: Scheme; host: string;
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

proc validate_NetworkListBySubscription_594002(path: JsonNode; query: JsonNode;
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
  var valid_594004 = path.getOrDefault("subscriptionId")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "subscriptionId", valid_594004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594005 = query.getOrDefault("api-version")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594005 != nil:
    section.add "api-version", valid_594005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594006: Call_NetworkListBySubscription_594001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all network resources in a given resource group. The information include the description and other properties of the network.
  ## 
  let valid = call_594006.validator(path, query, header, formData, body)
  let scheme = call_594006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594006.url(scheme.get, call_594006.host, call_594006.base,
                         call_594006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594006, url, valid)

proc call*(call_594007: Call_NetworkListBySubscription_594001;
          subscriptionId: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## networkListBySubscription
  ## Gets the information about all network resources in a given resource group. The information include the description and other properties of the network.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_594008 = newJObject()
  var query_594009 = newJObject()
  add(query_594009, "api-version", newJString(apiVersion))
  add(path_594008, "subscriptionId", newJString(subscriptionId))
  result = call_594007.call(path_594008, query_594009, nil, nil, nil)

var networkListBySubscription* = Call_NetworkListBySubscription_594001(
    name: "networkListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/networks",
    validator: validate_NetworkListBySubscription_594002, base: "",
    url: url_NetworkListBySubscription_594003, schemes: {Scheme.Https})
type
  Call_SecretListBySubscription_594010 = ref object of OpenApiRestCall_593438
proc url_SecretListBySubscription_594012(protocol: Scheme; host: string;
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

proc validate_SecretListBySubscription_594011(path: JsonNode; query: JsonNode;
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
  var valid_594013 = path.getOrDefault("subscriptionId")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "subscriptionId", valid_594013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594014 = query.getOrDefault("api-version")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594014 != nil:
    section.add "api-version", valid_594014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_SecretListBySubscription_594010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all secret resources in a given resource group. The information include the description and other properties of the secret.
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_SecretListBySubscription_594010;
          subscriptionId: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## secretListBySubscription
  ## Gets the information about all secret resources in a given resource group. The information include the description and other properties of the secret.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  add(query_594018, "api-version", newJString(apiVersion))
  add(path_594017, "subscriptionId", newJString(subscriptionId))
  result = call_594016.call(path_594017, query_594018, nil, nil, nil)

var secretListBySubscription* = Call_SecretListBySubscription_594010(
    name: "secretListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/secrets",
    validator: validate_SecretListBySubscription_594011, base: "",
    url: url_SecretListBySubscription_594012, schemes: {Scheme.Https})
type
  Call_VolumeListBySubscription_594019 = ref object of OpenApiRestCall_593438
proc url_VolumeListBySubscription_594021(protocol: Scheme; host: string;
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

proc validate_VolumeListBySubscription_594020(path: JsonNode; query: JsonNode;
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
  var valid_594022 = path.getOrDefault("subscriptionId")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "subscriptionId", valid_594022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594023 = query.getOrDefault("api-version")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594023 != nil:
    section.add "api-version", valid_594023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594024: Call_VolumeListBySubscription_594019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all volume resources in a given resource group. The information include the description and other properties of the volume.
  ## 
  let valid = call_594024.validator(path, query, header, formData, body)
  let scheme = call_594024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594024.url(scheme.get, call_594024.host, call_594024.base,
                         call_594024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594024, url, valid)

proc call*(call_594025: Call_VolumeListBySubscription_594019;
          subscriptionId: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## volumeListBySubscription
  ## Gets the information about all volume resources in a given resource group. The information include the description and other properties of the volume.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_594026 = newJObject()
  var query_594027 = newJObject()
  add(query_594027, "api-version", newJString(apiVersion))
  add(path_594026, "subscriptionId", newJString(subscriptionId))
  result = call_594025.call(path_594026, query_594027, nil, nil, nil)

var volumeListBySubscription* = Call_VolumeListBySubscription_594019(
    name: "volumeListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/volumes",
    validator: validate_VolumeListBySubscription_594020, base: "",
    url: url_VolumeListBySubscription_594021, schemes: {Scheme.Https})
type
  Call_ApplicationListByResourceGroup_594028 = ref object of OpenApiRestCall_593438
proc url_ApplicationListByResourceGroup_594030(protocol: Scheme; host: string;
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

proc validate_ApplicationListByResourceGroup_594029(path: JsonNode;
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
  var valid_594031 = path.getOrDefault("resourceGroupName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "resourceGroupName", valid_594031
  var valid_594032 = path.getOrDefault("subscriptionId")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "subscriptionId", valid_594032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594033 = query.getOrDefault("api-version")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594033 != nil:
    section.add "api-version", valid_594033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594034: Call_ApplicationListByResourceGroup_594028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all application resources in a given resource group. The information include the description and other properties of the Application.
  ## 
  let valid = call_594034.validator(path, query, header, formData, body)
  let scheme = call_594034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594034.url(scheme.get, call_594034.host, call_594034.base,
                         call_594034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594034, url, valid)

proc call*(call_594035: Call_ApplicationListByResourceGroup_594028;
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
  var path_594036 = newJObject()
  var query_594037 = newJObject()
  add(path_594036, "resourceGroupName", newJString(resourceGroupName))
  add(query_594037, "api-version", newJString(apiVersion))
  add(path_594036, "subscriptionId", newJString(subscriptionId))
  result = call_594035.call(path_594036, query_594037, nil, nil, nil)

var applicationListByResourceGroup* = Call_ApplicationListByResourceGroup_594028(
    name: "applicationListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications",
    validator: validate_ApplicationListByResourceGroup_594029, base: "",
    url: url_ApplicationListByResourceGroup_594030, schemes: {Scheme.Https})
type
  Call_ApplicationCreate_594049 = ref object of OpenApiRestCall_593438
proc url_ApplicationCreate_594051(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationCreate_594050(path: JsonNode; query: JsonNode;
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
  var valid_594069 = path.getOrDefault("resourceGroupName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "resourceGroupName", valid_594069
  var valid_594070 = path.getOrDefault("applicationResourceName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "applicationResourceName", valid_594070
  var valid_594071 = path.getOrDefault("subscriptionId")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "subscriptionId", valid_594071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594072 = query.getOrDefault("api-version")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594072 != nil:
    section.add "api-version", valid_594072
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

proc call*(call_594074: Call_ApplicationCreate_594049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an application resource with the specified name, description and properties. If an application resource with the same name exists, then it is updated with the specified description and properties.
  ## 
  let valid = call_594074.validator(path, query, header, formData, body)
  let scheme = call_594074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594074.url(scheme.get, call_594074.host, call_594074.base,
                         call_594074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594074, url, valid)

proc call*(call_594075: Call_ApplicationCreate_594049;
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
  var path_594076 = newJObject()
  var query_594077 = newJObject()
  var body_594078 = newJObject()
  if applicationResourceDescription != nil:
    body_594078 = applicationResourceDescription
  add(path_594076, "resourceGroupName", newJString(resourceGroupName))
  add(query_594077, "api-version", newJString(apiVersion))
  add(path_594076, "applicationResourceName", newJString(applicationResourceName))
  add(path_594076, "subscriptionId", newJString(subscriptionId))
  result = call_594075.call(path_594076, query_594077, nil, nil, body_594078)

var applicationCreate* = Call_ApplicationCreate_594049(name: "applicationCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}",
    validator: validate_ApplicationCreate_594050, base: "",
    url: url_ApplicationCreate_594051, schemes: {Scheme.Https})
type
  Call_ApplicationGet_594038 = ref object of OpenApiRestCall_593438
proc url_ApplicationGet_594040(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGet_594039(path: JsonNode; query: JsonNode;
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
  var valid_594041 = path.getOrDefault("resourceGroupName")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "resourceGroupName", valid_594041
  var valid_594042 = path.getOrDefault("applicationResourceName")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "applicationResourceName", valid_594042
  var valid_594043 = path.getOrDefault("subscriptionId")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "subscriptionId", valid_594043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594044 = query.getOrDefault("api-version")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594044 != nil:
    section.add "api-version", valid_594044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594045: Call_ApplicationGet_594038; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the application resource with the given name. The information include the description and other properties of the application.
  ## 
  let valid = call_594045.validator(path, query, header, formData, body)
  let scheme = call_594045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594045.url(scheme.get, call_594045.host, call_594045.base,
                         call_594045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594045, url, valid)

proc call*(call_594046: Call_ApplicationGet_594038; resourceGroupName: string;
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
  var path_594047 = newJObject()
  var query_594048 = newJObject()
  add(path_594047, "resourceGroupName", newJString(resourceGroupName))
  add(query_594048, "api-version", newJString(apiVersion))
  add(path_594047, "applicationResourceName", newJString(applicationResourceName))
  add(path_594047, "subscriptionId", newJString(subscriptionId))
  result = call_594046.call(path_594047, query_594048, nil, nil, nil)

var applicationGet* = Call_ApplicationGet_594038(name: "applicationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}",
    validator: validate_ApplicationGet_594039, base: "", url: url_ApplicationGet_594040,
    schemes: {Scheme.Https})
type
  Call_ApplicationDelete_594079 = ref object of OpenApiRestCall_593438
proc url_ApplicationDelete_594081(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationDelete_594080(path: JsonNode; query: JsonNode;
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
  var valid_594082 = path.getOrDefault("resourceGroupName")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "resourceGroupName", valid_594082
  var valid_594083 = path.getOrDefault("applicationResourceName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "applicationResourceName", valid_594083
  var valid_594084 = path.getOrDefault("subscriptionId")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "subscriptionId", valid_594084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594085 = query.getOrDefault("api-version")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594085 != nil:
    section.add "api-version", valid_594085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594086: Call_ApplicationDelete_594079; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the application resource identified by the name.
  ## 
  let valid = call_594086.validator(path, query, header, formData, body)
  let scheme = call_594086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594086.url(scheme.get, call_594086.host, call_594086.base,
                         call_594086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594086, url, valid)

proc call*(call_594087: Call_ApplicationDelete_594079; resourceGroupName: string;
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
  var path_594088 = newJObject()
  var query_594089 = newJObject()
  add(path_594088, "resourceGroupName", newJString(resourceGroupName))
  add(query_594089, "api-version", newJString(apiVersion))
  add(path_594088, "applicationResourceName", newJString(applicationResourceName))
  add(path_594088, "subscriptionId", newJString(subscriptionId))
  result = call_594087.call(path_594088, query_594089, nil, nil, nil)

var applicationDelete* = Call_ApplicationDelete_594079(name: "applicationDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}",
    validator: validate_ApplicationDelete_594080, base: "",
    url: url_ApplicationDelete_594081, schemes: {Scheme.Https})
type
  Call_ServiceList_594090 = ref object of OpenApiRestCall_593438
proc url_ServiceList_594092(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceList_594091(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594093 = path.getOrDefault("resourceGroupName")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "resourceGroupName", valid_594093
  var valid_594094 = path.getOrDefault("applicationResourceName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "applicationResourceName", valid_594094
  var valid_594095 = path.getOrDefault("subscriptionId")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "subscriptionId", valid_594095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594096 = query.getOrDefault("api-version")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594096 != nil:
    section.add "api-version", valid_594096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594097: Call_ServiceList_594090; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all services of an application resource. The information include the description and other properties of the Service.
  ## 
  let valid = call_594097.validator(path, query, header, formData, body)
  let scheme = call_594097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594097.url(scheme.get, call_594097.host, call_594097.base,
                         call_594097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594097, url, valid)

proc call*(call_594098: Call_ServiceList_594090; resourceGroupName: string;
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
  var path_594099 = newJObject()
  var query_594100 = newJObject()
  add(path_594099, "resourceGroupName", newJString(resourceGroupName))
  add(query_594100, "api-version", newJString(apiVersion))
  add(path_594099, "applicationResourceName", newJString(applicationResourceName))
  add(path_594099, "subscriptionId", newJString(subscriptionId))
  result = call_594098.call(path_594099, query_594100, nil, nil, nil)

var serviceList* = Call_ServiceList_594090(name: "serviceList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}/services",
                                        validator: validate_ServiceList_594091,
                                        base: "", url: url_ServiceList_594092,
                                        schemes: {Scheme.Https})
type
  Call_ServiceGet_594101 = ref object of OpenApiRestCall_593438
proc url_ServiceGet_594103(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ServiceGet_594102(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594104 = path.getOrDefault("resourceGroupName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "resourceGroupName", valid_594104
  var valid_594105 = path.getOrDefault("applicationResourceName")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "applicationResourceName", valid_594105
  var valid_594106 = path.getOrDefault("serviceResourceName")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "serviceResourceName", valid_594106
  var valid_594107 = path.getOrDefault("subscriptionId")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "subscriptionId", valid_594107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594108 = query.getOrDefault("api-version")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594108 != nil:
    section.add "api-version", valid_594108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594109: Call_ServiceGet_594101; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the service resource with the given name. The information include the description and other properties of the service.
  ## 
  let valid = call_594109.validator(path, query, header, formData, body)
  let scheme = call_594109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594109.url(scheme.get, call_594109.host, call_594109.base,
                         call_594109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594109, url, valid)

proc call*(call_594110: Call_ServiceGet_594101; resourceGroupName: string;
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
  var path_594111 = newJObject()
  var query_594112 = newJObject()
  add(path_594111, "resourceGroupName", newJString(resourceGroupName))
  add(query_594112, "api-version", newJString(apiVersion))
  add(path_594111, "applicationResourceName", newJString(applicationResourceName))
  add(path_594111, "serviceResourceName", newJString(serviceResourceName))
  add(path_594111, "subscriptionId", newJString(subscriptionId))
  result = call_594110.call(path_594111, query_594112, nil, nil, nil)

var serviceGet* = Call_ServiceGet_594101(name: "serviceGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}/services/{serviceResourceName}",
                                      validator: validate_ServiceGet_594102,
                                      base: "", url: url_ServiceGet_594103,
                                      schemes: {Scheme.Https})
type
  Call_ServiceReplicaList_594113 = ref object of OpenApiRestCall_593438
proc url_ServiceReplicaList_594115(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceReplicaList_594114(path: JsonNode; query: JsonNode;
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
  var valid_594116 = path.getOrDefault("resourceGroupName")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "resourceGroupName", valid_594116
  var valid_594117 = path.getOrDefault("applicationResourceName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "applicationResourceName", valid_594117
  var valid_594118 = path.getOrDefault("serviceResourceName")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "serviceResourceName", valid_594118
  var valid_594119 = path.getOrDefault("subscriptionId")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "subscriptionId", valid_594119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594120 = query.getOrDefault("api-version")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594120 != nil:
    section.add "api-version", valid_594120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594121: Call_ServiceReplicaList_594113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all replicas of a given service of an application. The information includes the runtime properties of the replica instance.
  ## 
  let valid = call_594121.validator(path, query, header, formData, body)
  let scheme = call_594121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594121.url(scheme.get, call_594121.host, call_594121.base,
                         call_594121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594121, url, valid)

proc call*(call_594122: Call_ServiceReplicaList_594113; resourceGroupName: string;
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
  var path_594123 = newJObject()
  var query_594124 = newJObject()
  add(path_594123, "resourceGroupName", newJString(resourceGroupName))
  add(query_594124, "api-version", newJString(apiVersion))
  add(path_594123, "applicationResourceName", newJString(applicationResourceName))
  add(path_594123, "serviceResourceName", newJString(serviceResourceName))
  add(path_594123, "subscriptionId", newJString(subscriptionId))
  result = call_594122.call(path_594123, query_594124, nil, nil, nil)

var serviceReplicaList* = Call_ServiceReplicaList_594113(
    name: "serviceReplicaList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}/services/{serviceResourceName}/replicas",
    validator: validate_ServiceReplicaList_594114, base: "",
    url: url_ServiceReplicaList_594115, schemes: {Scheme.Https})
type
  Call_ServiceReplicaGet_594125 = ref object of OpenApiRestCall_593438
proc url_ServiceReplicaGet_594127(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceReplicaGet_594126(path: JsonNode; query: JsonNode;
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
  var valid_594128 = path.getOrDefault("resourceGroupName")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "resourceGroupName", valid_594128
  var valid_594129 = path.getOrDefault("applicationResourceName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "applicationResourceName", valid_594129
  var valid_594130 = path.getOrDefault("serviceResourceName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "serviceResourceName", valid_594130
  var valid_594131 = path.getOrDefault("subscriptionId")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "subscriptionId", valid_594131
  var valid_594132 = path.getOrDefault("replicaName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "replicaName", valid_594132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594133 = query.getOrDefault("api-version")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594133 != nil:
    section.add "api-version", valid_594133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594134: Call_ServiceReplicaGet_594125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the service replica with the given name. The information include the description and other properties of the service replica.
  ## 
  let valid = call_594134.validator(path, query, header, formData, body)
  let scheme = call_594134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594134.url(scheme.get, call_594134.host, call_594134.base,
                         call_594134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594134, url, valid)

proc call*(call_594135: Call_ServiceReplicaGet_594125; resourceGroupName: string;
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
  var path_594136 = newJObject()
  var query_594137 = newJObject()
  add(path_594136, "resourceGroupName", newJString(resourceGroupName))
  add(query_594137, "api-version", newJString(apiVersion))
  add(path_594136, "applicationResourceName", newJString(applicationResourceName))
  add(path_594136, "serviceResourceName", newJString(serviceResourceName))
  add(path_594136, "subscriptionId", newJString(subscriptionId))
  add(path_594136, "replicaName", newJString(replicaName))
  result = call_594135.call(path_594136, query_594137, nil, nil, nil)

var serviceReplicaGet* = Call_ServiceReplicaGet_594125(name: "serviceReplicaGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}/services/{serviceResourceName}/replicas/{replicaName}",
    validator: validate_ServiceReplicaGet_594126, base: "",
    url: url_ServiceReplicaGet_594127, schemes: {Scheme.Https})
type
  Call_CodePackageGetContainerLogs_594138 = ref object of OpenApiRestCall_593438
proc url_CodePackageGetContainerLogs_594140(protocol: Scheme; host: string;
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

proc validate_CodePackageGetContainerLogs_594139(path: JsonNode; query: JsonNode;
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
  var valid_594141 = path.getOrDefault("resourceGroupName")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "resourceGroupName", valid_594141
  var valid_594142 = path.getOrDefault("applicationResourceName")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "applicationResourceName", valid_594142
  var valid_594143 = path.getOrDefault("serviceResourceName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "serviceResourceName", valid_594143
  var valid_594144 = path.getOrDefault("subscriptionId")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "subscriptionId", valid_594144
  var valid_594145 = path.getOrDefault("replicaName")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "replicaName", valid_594145
  var valid_594146 = path.getOrDefault("codePackageName")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "codePackageName", valid_594146
  result.add "path", section
  ## parameters in `query` object:
  ##   tail: JInt
  ##       : Number of lines to show from the end of the logs. Default is 100.
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  var valid_594147 = query.getOrDefault("tail")
  valid_594147 = validateParameter(valid_594147, JInt, required = false, default = nil)
  if valid_594147 != nil:
    section.add "tail", valid_594147
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594148 = query.getOrDefault("api-version")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594148 != nil:
    section.add "api-version", valid_594148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594149: Call_CodePackageGetContainerLogs_594138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the logs for the container of the specified code package of the service replica.
  ## 
  let valid = call_594149.validator(path, query, header, formData, body)
  let scheme = call_594149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594149.url(scheme.get, call_594149.host, call_594149.base,
                         call_594149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594149, url, valid)

proc call*(call_594150: Call_CodePackageGetContainerLogs_594138;
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
  var path_594151 = newJObject()
  var query_594152 = newJObject()
  add(path_594151, "resourceGroupName", newJString(resourceGroupName))
  add(query_594152, "tail", newJInt(tail))
  add(query_594152, "api-version", newJString(apiVersion))
  add(path_594151, "applicationResourceName", newJString(applicationResourceName))
  add(path_594151, "serviceResourceName", newJString(serviceResourceName))
  add(path_594151, "subscriptionId", newJString(subscriptionId))
  add(path_594151, "replicaName", newJString(replicaName))
  add(path_594151, "codePackageName", newJString(codePackageName))
  result = call_594150.call(path_594151, query_594152, nil, nil, nil)

var codePackageGetContainerLogs* = Call_CodePackageGetContainerLogs_594138(
    name: "codePackageGetContainerLogs", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationResourceName}/services/{serviceResourceName}/replicas/{replicaName}/codePackages/{codePackageName}/logs",
    validator: validate_CodePackageGetContainerLogs_594139, base: "",
    url: url_CodePackageGetContainerLogs_594140, schemes: {Scheme.Https})
type
  Call_GatewayListByResourceGroup_594153 = ref object of OpenApiRestCall_593438
proc url_GatewayListByResourceGroup_594155(protocol: Scheme; host: string;
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

proc validate_GatewayListByResourceGroup_594154(path: JsonNode; query: JsonNode;
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
  var valid_594156 = path.getOrDefault("resourceGroupName")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "resourceGroupName", valid_594156
  var valid_594157 = path.getOrDefault("subscriptionId")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "subscriptionId", valid_594157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594158 = query.getOrDefault("api-version")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594158 != nil:
    section.add "api-version", valid_594158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594159: Call_GatewayListByResourceGroup_594153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all gateway resources in a given resource group. The information include the description and other properties of the Gateway.
  ## 
  let valid = call_594159.validator(path, query, header, formData, body)
  let scheme = call_594159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594159.url(scheme.get, call_594159.host, call_594159.base,
                         call_594159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594159, url, valid)

proc call*(call_594160: Call_GatewayListByResourceGroup_594153;
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
  var path_594161 = newJObject()
  var query_594162 = newJObject()
  add(path_594161, "resourceGroupName", newJString(resourceGroupName))
  add(query_594162, "api-version", newJString(apiVersion))
  add(path_594161, "subscriptionId", newJString(subscriptionId))
  result = call_594160.call(path_594161, query_594162, nil, nil, nil)

var gatewayListByResourceGroup* = Call_GatewayListByResourceGroup_594153(
    name: "gatewayListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/gateways",
    validator: validate_GatewayListByResourceGroup_594154, base: "",
    url: url_GatewayListByResourceGroup_594155, schemes: {Scheme.Https})
type
  Call_GatewayCreate_594174 = ref object of OpenApiRestCall_593438
proc url_GatewayCreate_594176(protocol: Scheme; host: string; base: string;
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

proc validate_GatewayCreate_594175(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594177 = path.getOrDefault("resourceGroupName")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "resourceGroupName", valid_594177
  var valid_594178 = path.getOrDefault("subscriptionId")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "subscriptionId", valid_594178
  var valid_594179 = path.getOrDefault("gatewayResourceName")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "gatewayResourceName", valid_594179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594180 = query.getOrDefault("api-version")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594180 != nil:
    section.add "api-version", valid_594180
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

proc call*(call_594182: Call_GatewayCreate_594174; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a gateway resource with the specified name, description and properties. If a gateway resource with the same name exists, then it is updated with the specified description and properties. Use gateway resources to create a gateway for public connectivity for services within your application.
  ## 
  let valid = call_594182.validator(path, query, header, formData, body)
  let scheme = call_594182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594182.url(scheme.get, call_594182.host, call_594182.base,
                         call_594182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594182, url, valid)

proc call*(call_594183: Call_GatewayCreate_594174; resourceGroupName: string;
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
  var path_594184 = newJObject()
  var query_594185 = newJObject()
  var body_594186 = newJObject()
  add(path_594184, "resourceGroupName", newJString(resourceGroupName))
  add(query_594185, "api-version", newJString(apiVersion))
  if gatewayResourceDescription != nil:
    body_594186 = gatewayResourceDescription
  add(path_594184, "subscriptionId", newJString(subscriptionId))
  add(path_594184, "gatewayResourceName", newJString(gatewayResourceName))
  result = call_594183.call(path_594184, query_594185, nil, nil, body_594186)

var gatewayCreate* = Call_GatewayCreate_594174(name: "gatewayCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/gateways/{gatewayResourceName}",
    validator: validate_GatewayCreate_594175, base: "", url: url_GatewayCreate_594176,
    schemes: {Scheme.Https})
type
  Call_GatewayGet_594163 = ref object of OpenApiRestCall_593438
proc url_GatewayGet_594165(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GatewayGet_594164(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594166 = path.getOrDefault("resourceGroupName")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "resourceGroupName", valid_594166
  var valid_594167 = path.getOrDefault("subscriptionId")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "subscriptionId", valid_594167
  var valid_594168 = path.getOrDefault("gatewayResourceName")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "gatewayResourceName", valid_594168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594169 = query.getOrDefault("api-version")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594169 != nil:
    section.add "api-version", valid_594169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594170: Call_GatewayGet_594163; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the gateway resource with the given name. The information include the description and other properties of the gateway.
  ## 
  let valid = call_594170.validator(path, query, header, formData, body)
  let scheme = call_594170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594170.url(scheme.get, call_594170.host, call_594170.base,
                         call_594170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594170, url, valid)

proc call*(call_594171: Call_GatewayGet_594163; resourceGroupName: string;
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
  var path_594172 = newJObject()
  var query_594173 = newJObject()
  add(path_594172, "resourceGroupName", newJString(resourceGroupName))
  add(query_594173, "api-version", newJString(apiVersion))
  add(path_594172, "subscriptionId", newJString(subscriptionId))
  add(path_594172, "gatewayResourceName", newJString(gatewayResourceName))
  result = call_594171.call(path_594172, query_594173, nil, nil, nil)

var gatewayGet* = Call_GatewayGet_594163(name: "gatewayGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/gateways/{gatewayResourceName}",
                                      validator: validate_GatewayGet_594164,
                                      base: "", url: url_GatewayGet_594165,
                                      schemes: {Scheme.Https})
type
  Call_GatewayDelete_594187 = ref object of OpenApiRestCall_593438
proc url_GatewayDelete_594189(protocol: Scheme; host: string; base: string;
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

proc validate_GatewayDelete_594188(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594190 = path.getOrDefault("resourceGroupName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "resourceGroupName", valid_594190
  var valid_594191 = path.getOrDefault("subscriptionId")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "subscriptionId", valid_594191
  var valid_594192 = path.getOrDefault("gatewayResourceName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "gatewayResourceName", valid_594192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594193 = query.getOrDefault("api-version")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594193 != nil:
    section.add "api-version", valid_594193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594194: Call_GatewayDelete_594187; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the gateway resource identified by the name.
  ## 
  let valid = call_594194.validator(path, query, header, formData, body)
  let scheme = call_594194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594194.url(scheme.get, call_594194.host, call_594194.base,
                         call_594194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594194, url, valid)

proc call*(call_594195: Call_GatewayDelete_594187; resourceGroupName: string;
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
  var path_594196 = newJObject()
  var query_594197 = newJObject()
  add(path_594196, "resourceGroupName", newJString(resourceGroupName))
  add(query_594197, "api-version", newJString(apiVersion))
  add(path_594196, "subscriptionId", newJString(subscriptionId))
  add(path_594196, "gatewayResourceName", newJString(gatewayResourceName))
  result = call_594195.call(path_594196, query_594197, nil, nil, nil)

var gatewayDelete* = Call_GatewayDelete_594187(name: "gatewayDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/gateways/{gatewayResourceName}",
    validator: validate_GatewayDelete_594188, base: "", url: url_GatewayDelete_594189,
    schemes: {Scheme.Https})
type
  Call_NetworkListByResourceGroup_594198 = ref object of OpenApiRestCall_593438
proc url_NetworkListByResourceGroup_594200(protocol: Scheme; host: string;
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

proc validate_NetworkListByResourceGroup_594199(path: JsonNode; query: JsonNode;
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
  var valid_594201 = path.getOrDefault("resourceGroupName")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "resourceGroupName", valid_594201
  var valid_594202 = path.getOrDefault("subscriptionId")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "subscriptionId", valid_594202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594203 = query.getOrDefault("api-version")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594203 != nil:
    section.add "api-version", valid_594203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594204: Call_NetworkListByResourceGroup_594198; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all network resources in a given resource group. The information include the description and other properties of the Network.
  ## 
  let valid = call_594204.validator(path, query, header, formData, body)
  let scheme = call_594204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594204.url(scheme.get, call_594204.host, call_594204.base,
                         call_594204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594204, url, valid)

proc call*(call_594205: Call_NetworkListByResourceGroup_594198;
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
  var path_594206 = newJObject()
  var query_594207 = newJObject()
  add(path_594206, "resourceGroupName", newJString(resourceGroupName))
  add(query_594207, "api-version", newJString(apiVersion))
  add(path_594206, "subscriptionId", newJString(subscriptionId))
  result = call_594205.call(path_594206, query_594207, nil, nil, nil)

var networkListByResourceGroup* = Call_NetworkListByResourceGroup_594198(
    name: "networkListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks",
    validator: validate_NetworkListByResourceGroup_594199, base: "",
    url: url_NetworkListByResourceGroup_594200, schemes: {Scheme.Https})
type
  Call_NetworkCreate_594219 = ref object of OpenApiRestCall_593438
proc url_NetworkCreate_594221(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkCreate_594220(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594222 = path.getOrDefault("resourceGroupName")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "resourceGroupName", valid_594222
  var valid_594223 = path.getOrDefault("subscriptionId")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "subscriptionId", valid_594223
  var valid_594224 = path.getOrDefault("networkResourceName")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "networkResourceName", valid_594224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594225 = query.getOrDefault("api-version")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594225 != nil:
    section.add "api-version", valid_594225
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

proc call*(call_594227: Call_NetworkCreate_594219; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a network resource with the specified name, description and properties. If a network resource with the same name exists, then it is updated with the specified description and properties.
  ## 
  let valid = call_594227.validator(path, query, header, formData, body)
  let scheme = call_594227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594227.url(scheme.get, call_594227.host, call_594227.base,
                         call_594227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594227, url, valid)

proc call*(call_594228: Call_NetworkCreate_594219; resourceGroupName: string;
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
  var path_594229 = newJObject()
  var query_594230 = newJObject()
  var body_594231 = newJObject()
  add(path_594229, "resourceGroupName", newJString(resourceGroupName))
  add(query_594230, "api-version", newJString(apiVersion))
  if networkResourceDescription != nil:
    body_594231 = networkResourceDescription
  add(path_594229, "subscriptionId", newJString(subscriptionId))
  add(path_594229, "networkResourceName", newJString(networkResourceName))
  result = call_594228.call(path_594229, query_594230, nil, nil, body_594231)

var networkCreate* = Call_NetworkCreate_594219(name: "networkCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks/{networkResourceName}",
    validator: validate_NetworkCreate_594220, base: "", url: url_NetworkCreate_594221,
    schemes: {Scheme.Https})
type
  Call_NetworkGet_594208 = ref object of OpenApiRestCall_593438
proc url_NetworkGet_594210(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_NetworkGet_594209(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594211 = path.getOrDefault("resourceGroupName")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "resourceGroupName", valid_594211
  var valid_594212 = path.getOrDefault("subscriptionId")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "subscriptionId", valid_594212
  var valid_594213 = path.getOrDefault("networkResourceName")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "networkResourceName", valid_594213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594214 = query.getOrDefault("api-version")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594214 != nil:
    section.add "api-version", valid_594214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594215: Call_NetworkGet_594208; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the network resource with the given name. The information include the description and other properties of the network.
  ## 
  let valid = call_594215.validator(path, query, header, formData, body)
  let scheme = call_594215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594215.url(scheme.get, call_594215.host, call_594215.base,
                         call_594215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594215, url, valid)

proc call*(call_594216: Call_NetworkGet_594208; resourceGroupName: string;
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
  var path_594217 = newJObject()
  var query_594218 = newJObject()
  add(path_594217, "resourceGroupName", newJString(resourceGroupName))
  add(query_594218, "api-version", newJString(apiVersion))
  add(path_594217, "subscriptionId", newJString(subscriptionId))
  add(path_594217, "networkResourceName", newJString(networkResourceName))
  result = call_594216.call(path_594217, query_594218, nil, nil, nil)

var networkGet* = Call_NetworkGet_594208(name: "networkGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks/{networkResourceName}",
                                      validator: validate_NetworkGet_594209,
                                      base: "", url: url_NetworkGet_594210,
                                      schemes: {Scheme.Https})
type
  Call_NetworkDelete_594232 = ref object of OpenApiRestCall_593438
proc url_NetworkDelete_594234(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkDelete_594233(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594235 = path.getOrDefault("resourceGroupName")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "resourceGroupName", valid_594235
  var valid_594236 = path.getOrDefault("subscriptionId")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "subscriptionId", valid_594236
  var valid_594237 = path.getOrDefault("networkResourceName")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "networkResourceName", valid_594237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594238 = query.getOrDefault("api-version")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594238 != nil:
    section.add "api-version", valid_594238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594239: Call_NetworkDelete_594232; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the network resource identified by the name.
  ## 
  let valid = call_594239.validator(path, query, header, formData, body)
  let scheme = call_594239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594239.url(scheme.get, call_594239.host, call_594239.base,
                         call_594239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594239, url, valid)

proc call*(call_594240: Call_NetworkDelete_594232; resourceGroupName: string;
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
  var path_594241 = newJObject()
  var query_594242 = newJObject()
  add(path_594241, "resourceGroupName", newJString(resourceGroupName))
  add(query_594242, "api-version", newJString(apiVersion))
  add(path_594241, "subscriptionId", newJString(subscriptionId))
  add(path_594241, "networkResourceName", newJString(networkResourceName))
  result = call_594240.call(path_594241, query_594242, nil, nil, nil)

var networkDelete* = Call_NetworkDelete_594232(name: "networkDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks/{networkResourceName}",
    validator: validate_NetworkDelete_594233, base: "", url: url_NetworkDelete_594234,
    schemes: {Scheme.Https})
type
  Call_SecretListByResourceGroup_594243 = ref object of OpenApiRestCall_593438
proc url_SecretListByResourceGroup_594245(protocol: Scheme; host: string;
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

proc validate_SecretListByResourceGroup_594244(path: JsonNode; query: JsonNode;
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
  var valid_594246 = path.getOrDefault("resourceGroupName")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "resourceGroupName", valid_594246
  var valid_594247 = path.getOrDefault("subscriptionId")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "subscriptionId", valid_594247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594248 = query.getOrDefault("api-version")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594248 != nil:
    section.add "api-version", valid_594248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594249: Call_SecretListByResourceGroup_594243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all secret resources in a given resource group. The information include the description and other properties of the Secret.
  ## 
  let valid = call_594249.validator(path, query, header, formData, body)
  let scheme = call_594249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594249.url(scheme.get, call_594249.host, call_594249.base,
                         call_594249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594249, url, valid)

proc call*(call_594250: Call_SecretListByResourceGroup_594243;
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
  var path_594251 = newJObject()
  var query_594252 = newJObject()
  add(path_594251, "resourceGroupName", newJString(resourceGroupName))
  add(query_594252, "api-version", newJString(apiVersion))
  add(path_594251, "subscriptionId", newJString(subscriptionId))
  result = call_594250.call(path_594251, query_594252, nil, nil, nil)

var secretListByResourceGroup* = Call_SecretListByResourceGroup_594243(
    name: "secretListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets",
    validator: validate_SecretListByResourceGroup_594244, base: "",
    url: url_SecretListByResourceGroup_594245, schemes: {Scheme.Https})
type
  Call_SecretCreate_594264 = ref object of OpenApiRestCall_593438
proc url_SecretCreate_594266(protocol: Scheme; host: string; base: string;
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

proc validate_SecretCreate_594265(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594267 = path.getOrDefault("resourceGroupName")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "resourceGroupName", valid_594267
  var valid_594268 = path.getOrDefault("subscriptionId")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "subscriptionId", valid_594268
  var valid_594269 = path.getOrDefault("secretResourceName")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "secretResourceName", valid_594269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594270 = query.getOrDefault("api-version")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594270 != nil:
    section.add "api-version", valid_594270
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

proc call*(call_594272: Call_SecretCreate_594264; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a secret resource with the specified name, description and properties. If a secret resource with the same name exists, then it is updated with the specified description and properties.
  ## 
  let valid = call_594272.validator(path, query, header, formData, body)
  let scheme = call_594272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594272.url(scheme.get, call_594272.host, call_594272.base,
                         call_594272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594272, url, valid)

proc call*(call_594273: Call_SecretCreate_594264; resourceGroupName: string;
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
  var path_594274 = newJObject()
  var query_594275 = newJObject()
  var body_594276 = newJObject()
  add(path_594274, "resourceGroupName", newJString(resourceGroupName))
  add(query_594275, "api-version", newJString(apiVersion))
  if secretResourceDescription != nil:
    body_594276 = secretResourceDescription
  add(path_594274, "subscriptionId", newJString(subscriptionId))
  add(path_594274, "secretResourceName", newJString(secretResourceName))
  result = call_594273.call(path_594274, query_594275, nil, nil, body_594276)

var secretCreate* = Call_SecretCreate_594264(name: "secretCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}",
    validator: validate_SecretCreate_594265, base: "", url: url_SecretCreate_594266,
    schemes: {Scheme.Https})
type
  Call_SecretGet_594253 = ref object of OpenApiRestCall_593438
proc url_SecretGet_594255(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SecretGet_594254(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594256 = path.getOrDefault("resourceGroupName")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "resourceGroupName", valid_594256
  var valid_594257 = path.getOrDefault("subscriptionId")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "subscriptionId", valid_594257
  var valid_594258 = path.getOrDefault("secretResourceName")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "secretResourceName", valid_594258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594259 = query.getOrDefault("api-version")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594259 != nil:
    section.add "api-version", valid_594259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594260: Call_SecretGet_594253; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the secret resource with the given name. The information include the description and other properties of the secret.
  ## 
  let valid = call_594260.validator(path, query, header, formData, body)
  let scheme = call_594260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594260.url(scheme.get, call_594260.host, call_594260.base,
                         call_594260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594260, url, valid)

proc call*(call_594261: Call_SecretGet_594253; resourceGroupName: string;
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
  var path_594262 = newJObject()
  var query_594263 = newJObject()
  add(path_594262, "resourceGroupName", newJString(resourceGroupName))
  add(query_594263, "api-version", newJString(apiVersion))
  add(path_594262, "subscriptionId", newJString(subscriptionId))
  add(path_594262, "secretResourceName", newJString(secretResourceName))
  result = call_594261.call(path_594262, query_594263, nil, nil, nil)

var secretGet* = Call_SecretGet_594253(name: "secretGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}",
                                    validator: validate_SecretGet_594254,
                                    base: "", url: url_SecretGet_594255,
                                    schemes: {Scheme.Https})
type
  Call_SecretDelete_594277 = ref object of OpenApiRestCall_593438
proc url_SecretDelete_594279(protocol: Scheme; host: string; base: string;
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

proc validate_SecretDelete_594278(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594280 = path.getOrDefault("resourceGroupName")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "resourceGroupName", valid_594280
  var valid_594281 = path.getOrDefault("subscriptionId")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "subscriptionId", valid_594281
  var valid_594282 = path.getOrDefault("secretResourceName")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "secretResourceName", valid_594282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594283 = query.getOrDefault("api-version")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594283 != nil:
    section.add "api-version", valid_594283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594284: Call_SecretDelete_594277; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the secret resource identified by the name.
  ## 
  let valid = call_594284.validator(path, query, header, formData, body)
  let scheme = call_594284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594284.url(scheme.get, call_594284.host, call_594284.base,
                         call_594284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594284, url, valid)

proc call*(call_594285: Call_SecretDelete_594277; resourceGroupName: string;
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
  var path_594286 = newJObject()
  var query_594287 = newJObject()
  add(path_594286, "resourceGroupName", newJString(resourceGroupName))
  add(query_594287, "api-version", newJString(apiVersion))
  add(path_594286, "subscriptionId", newJString(subscriptionId))
  add(path_594286, "secretResourceName", newJString(secretResourceName))
  result = call_594285.call(path_594286, query_594287, nil, nil, nil)

var secretDelete* = Call_SecretDelete_594277(name: "secretDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}",
    validator: validate_SecretDelete_594278, base: "", url: url_SecretDelete_594279,
    schemes: {Scheme.Https})
type
  Call_SecretValueList_594288 = ref object of OpenApiRestCall_593438
proc url_SecretValueList_594290(protocol: Scheme; host: string; base: string;
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

proc validate_SecretValueList_594289(path: JsonNode; query: JsonNode;
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
  var valid_594291 = path.getOrDefault("resourceGroupName")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "resourceGroupName", valid_594291
  var valid_594292 = path.getOrDefault("subscriptionId")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "subscriptionId", valid_594292
  var valid_594293 = path.getOrDefault("secretResourceName")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "secretResourceName", valid_594293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594294 = query.getOrDefault("api-version")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594294 != nil:
    section.add "api-version", valid_594294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594295: Call_SecretValueList_594288; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all secret value resources of the specified secret resource. The information includes the names of the secret value resources, but not the actual values.
  ## 
  let valid = call_594295.validator(path, query, header, formData, body)
  let scheme = call_594295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594295.url(scheme.get, call_594295.host, call_594295.base,
                         call_594295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594295, url, valid)

proc call*(call_594296: Call_SecretValueList_594288; resourceGroupName: string;
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
  var path_594297 = newJObject()
  var query_594298 = newJObject()
  add(path_594297, "resourceGroupName", newJString(resourceGroupName))
  add(query_594298, "api-version", newJString(apiVersion))
  add(path_594297, "subscriptionId", newJString(subscriptionId))
  add(path_594297, "secretResourceName", newJString(secretResourceName))
  result = call_594296.call(path_594297, query_594298, nil, nil, nil)

var secretValueList* = Call_SecretValueList_594288(name: "secretValueList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}/values",
    validator: validate_SecretValueList_594289, base: "", url: url_SecretValueList_594290,
    schemes: {Scheme.Https})
type
  Call_SecretValueCreate_594311 = ref object of OpenApiRestCall_593438
proc url_SecretValueCreate_594313(protocol: Scheme; host: string; base: string;
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

proc validate_SecretValueCreate_594312(path: JsonNode; query: JsonNode;
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
  var valid_594314 = path.getOrDefault("resourceGroupName")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "resourceGroupName", valid_594314
  var valid_594315 = path.getOrDefault("subscriptionId")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "subscriptionId", valid_594315
  var valid_594316 = path.getOrDefault("secretValueResourceName")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "secretValueResourceName", valid_594316
  var valid_594317 = path.getOrDefault("secretResourceName")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "secretResourceName", valid_594317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594318 = query.getOrDefault("api-version")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594318 != nil:
    section.add "api-version", valid_594318
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

proc call*(call_594320: Call_SecretValueCreate_594311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new value of the specified secret resource. The name of the value is typically the version identifier. Once created the value cannot be changed.
  ## 
  let valid = call_594320.validator(path, query, header, formData, body)
  let scheme = call_594320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594320.url(scheme.get, call_594320.host, call_594320.base,
                         call_594320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594320, url, valid)

proc call*(call_594321: Call_SecretValueCreate_594311; resourceGroupName: string;
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
  var path_594322 = newJObject()
  var query_594323 = newJObject()
  var body_594324 = newJObject()
  add(path_594322, "resourceGroupName", newJString(resourceGroupName))
  add(query_594323, "api-version", newJString(apiVersion))
  add(path_594322, "subscriptionId", newJString(subscriptionId))
  add(path_594322, "secretValueResourceName", newJString(secretValueResourceName))
  add(path_594322, "secretResourceName", newJString(secretResourceName))
  if secretValueResourceDescription != nil:
    body_594324 = secretValueResourceDescription
  result = call_594321.call(path_594322, query_594323, nil, nil, body_594324)

var secretValueCreate* = Call_SecretValueCreate_594311(name: "secretValueCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}/values/{secretValueResourceName}",
    validator: validate_SecretValueCreate_594312, base: "",
    url: url_SecretValueCreate_594313, schemes: {Scheme.Https})
type
  Call_SecretValueGet_594299 = ref object of OpenApiRestCall_593438
proc url_SecretValueGet_594301(protocol: Scheme; host: string; base: string;
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

proc validate_SecretValueGet_594300(path: JsonNode; query: JsonNode;
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
  var valid_594302 = path.getOrDefault("resourceGroupName")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "resourceGroupName", valid_594302
  var valid_594303 = path.getOrDefault("subscriptionId")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "subscriptionId", valid_594303
  var valid_594304 = path.getOrDefault("secretValueResourceName")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "secretValueResourceName", valid_594304
  var valid_594305 = path.getOrDefault("secretResourceName")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "secretResourceName", valid_594305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594306 = query.getOrDefault("api-version")
  valid_594306 = validateParameter(valid_594306, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594306 != nil:
    section.add "api-version", valid_594306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594307: Call_SecretValueGet_594299; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the information about the specified named secret value resources. The information does not include the actual value of the secret.
  ## 
  let valid = call_594307.validator(path, query, header, formData, body)
  let scheme = call_594307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594307.url(scheme.get, call_594307.host, call_594307.base,
                         call_594307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594307, url, valid)

proc call*(call_594308: Call_SecretValueGet_594299; resourceGroupName: string;
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
  var path_594309 = newJObject()
  var query_594310 = newJObject()
  add(path_594309, "resourceGroupName", newJString(resourceGroupName))
  add(query_594310, "api-version", newJString(apiVersion))
  add(path_594309, "subscriptionId", newJString(subscriptionId))
  add(path_594309, "secretValueResourceName", newJString(secretValueResourceName))
  add(path_594309, "secretResourceName", newJString(secretResourceName))
  result = call_594308.call(path_594309, query_594310, nil, nil, nil)

var secretValueGet* = Call_SecretValueGet_594299(name: "secretValueGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}/values/{secretValueResourceName}",
    validator: validate_SecretValueGet_594300, base: "", url: url_SecretValueGet_594301,
    schemes: {Scheme.Https})
type
  Call_SecretValueDelete_594325 = ref object of OpenApiRestCall_593438
proc url_SecretValueDelete_594327(protocol: Scheme; host: string; base: string;
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

proc validate_SecretValueDelete_594326(path: JsonNode; query: JsonNode;
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
  var valid_594328 = path.getOrDefault("resourceGroupName")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "resourceGroupName", valid_594328
  var valid_594329 = path.getOrDefault("subscriptionId")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "subscriptionId", valid_594329
  var valid_594330 = path.getOrDefault("secretValueResourceName")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "secretValueResourceName", valid_594330
  var valid_594331 = path.getOrDefault("secretResourceName")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "secretResourceName", valid_594331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594332 = query.getOrDefault("api-version")
  valid_594332 = validateParameter(valid_594332, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594332 != nil:
    section.add "api-version", valid_594332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594333: Call_SecretValueDelete_594325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the secret value resource identified by the name. The name of the resource is typically the version associated with that value. Deletion will fail if the specified value is in use.
  ## 
  let valid = call_594333.validator(path, query, header, formData, body)
  let scheme = call_594333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594333.url(scheme.get, call_594333.host, call_594333.base,
                         call_594333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594333, url, valid)

proc call*(call_594334: Call_SecretValueDelete_594325; resourceGroupName: string;
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
  var path_594335 = newJObject()
  var query_594336 = newJObject()
  add(path_594335, "resourceGroupName", newJString(resourceGroupName))
  add(query_594336, "api-version", newJString(apiVersion))
  add(path_594335, "subscriptionId", newJString(subscriptionId))
  add(path_594335, "secretValueResourceName", newJString(secretValueResourceName))
  add(path_594335, "secretResourceName", newJString(secretResourceName))
  result = call_594334.call(path_594335, query_594336, nil, nil, nil)

var secretValueDelete* = Call_SecretValueDelete_594325(name: "secretValueDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}/values/{secretValueResourceName}",
    validator: validate_SecretValueDelete_594326, base: "",
    url: url_SecretValueDelete_594327, schemes: {Scheme.Https})
type
  Call_SecretValueListValue_594337 = ref object of OpenApiRestCall_593438
proc url_SecretValueListValue_594339(protocol: Scheme; host: string; base: string;
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

proc validate_SecretValueListValue_594338(path: JsonNode; query: JsonNode;
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
  var valid_594340 = path.getOrDefault("resourceGroupName")
  valid_594340 = validateParameter(valid_594340, JString, required = true,
                                 default = nil)
  if valid_594340 != nil:
    section.add "resourceGroupName", valid_594340
  var valid_594341 = path.getOrDefault("subscriptionId")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "subscriptionId", valid_594341
  var valid_594342 = path.getOrDefault("secretValueResourceName")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "secretValueResourceName", valid_594342
  var valid_594343 = path.getOrDefault("secretResourceName")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "secretResourceName", valid_594343
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594344 = query.getOrDefault("api-version")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594344 != nil:
    section.add "api-version", valid_594344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594345: Call_SecretValueListValue_594337; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the decrypted value of the specified named value of the secret resource. This is a privileged operation.
  ## 
  let valid = call_594345.validator(path, query, header, formData, body)
  let scheme = call_594345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594345.url(scheme.get, call_594345.host, call_594345.base,
                         call_594345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594345, url, valid)

proc call*(call_594346: Call_SecretValueListValue_594337;
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
  var path_594347 = newJObject()
  var query_594348 = newJObject()
  add(path_594347, "resourceGroupName", newJString(resourceGroupName))
  add(query_594348, "api-version", newJString(apiVersion))
  add(path_594347, "subscriptionId", newJString(subscriptionId))
  add(path_594347, "secretValueResourceName", newJString(secretValueResourceName))
  add(path_594347, "secretResourceName", newJString(secretResourceName))
  result = call_594346.call(path_594347, query_594348, nil, nil, nil)

var secretValueListValue* = Call_SecretValueListValue_594337(
    name: "secretValueListValue", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/secrets/{secretResourceName}/values/{secretValueResourceName}/list_value",
    validator: validate_SecretValueListValue_594338, base: "",
    url: url_SecretValueListValue_594339, schemes: {Scheme.Https})
type
  Call_VolumeListByResourceGroup_594349 = ref object of OpenApiRestCall_593438
proc url_VolumeListByResourceGroup_594351(protocol: Scheme; host: string;
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

proc validate_VolumeListByResourceGroup_594350(path: JsonNode; query: JsonNode;
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
  var valid_594352 = path.getOrDefault("resourceGroupName")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "resourceGroupName", valid_594352
  var valid_594353 = path.getOrDefault("subscriptionId")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "subscriptionId", valid_594353
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594354 = query.getOrDefault("api-version")
  valid_594354 = validateParameter(valid_594354, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594354 != nil:
    section.add "api-version", valid_594354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594355: Call_VolumeListByResourceGroup_594349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all volume resources in a given resource group. The information include the description and other properties of the Volume.
  ## 
  let valid = call_594355.validator(path, query, header, formData, body)
  let scheme = call_594355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594355.url(scheme.get, call_594355.host, call_594355.base,
                         call_594355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594355, url, valid)

proc call*(call_594356: Call_VolumeListByResourceGroup_594349;
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
  var path_594357 = newJObject()
  var query_594358 = newJObject()
  add(path_594357, "resourceGroupName", newJString(resourceGroupName))
  add(query_594358, "api-version", newJString(apiVersion))
  add(path_594357, "subscriptionId", newJString(subscriptionId))
  result = call_594356.call(path_594357, query_594358, nil, nil, nil)

var volumeListByResourceGroup* = Call_VolumeListByResourceGroup_594349(
    name: "volumeListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes",
    validator: validate_VolumeListByResourceGroup_594350, base: "",
    url: url_VolumeListByResourceGroup_594351, schemes: {Scheme.Https})
type
  Call_VolumeCreate_594370 = ref object of OpenApiRestCall_593438
proc url_VolumeCreate_594372(protocol: Scheme; host: string; base: string;
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

proc validate_VolumeCreate_594371(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594373 = path.getOrDefault("resourceGroupName")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "resourceGroupName", valid_594373
  var valid_594374 = path.getOrDefault("volumeResourceName")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = nil)
  if valid_594374 != nil:
    section.add "volumeResourceName", valid_594374
  var valid_594375 = path.getOrDefault("subscriptionId")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "subscriptionId", valid_594375
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594376 = query.getOrDefault("api-version")
  valid_594376 = validateParameter(valid_594376, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594376 != nil:
    section.add "api-version", valid_594376
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

proc call*(call_594378: Call_VolumeCreate_594370; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a volume resource with the specified name, description and properties. If a volume resource with the same name exists, then it is updated with the specified description and properties.
  ## 
  let valid = call_594378.validator(path, query, header, formData, body)
  let scheme = call_594378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594378.url(scheme.get, call_594378.host, call_594378.base,
                         call_594378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594378, url, valid)

proc call*(call_594379: Call_VolumeCreate_594370; resourceGroupName: string;
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
  var path_594380 = newJObject()
  var query_594381 = newJObject()
  var body_594382 = newJObject()
  add(path_594380, "resourceGroupName", newJString(resourceGroupName))
  add(query_594381, "api-version", newJString(apiVersion))
  add(path_594380, "volumeResourceName", newJString(volumeResourceName))
  add(path_594380, "subscriptionId", newJString(subscriptionId))
  if volumeResourceDescription != nil:
    body_594382 = volumeResourceDescription
  result = call_594379.call(path_594380, query_594381, nil, nil, body_594382)

var volumeCreate* = Call_VolumeCreate_594370(name: "volumeCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes/{volumeResourceName}",
    validator: validate_VolumeCreate_594371, base: "", url: url_VolumeCreate_594372,
    schemes: {Scheme.Https})
type
  Call_VolumeGet_594359 = ref object of OpenApiRestCall_593438
proc url_VolumeGet_594361(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_VolumeGet_594360(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594362 = path.getOrDefault("resourceGroupName")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "resourceGroupName", valid_594362
  var valid_594363 = path.getOrDefault("volumeResourceName")
  valid_594363 = validateParameter(valid_594363, JString, required = true,
                                 default = nil)
  if valid_594363 != nil:
    section.add "volumeResourceName", valid_594363
  var valid_594364 = path.getOrDefault("subscriptionId")
  valid_594364 = validateParameter(valid_594364, JString, required = true,
                                 default = nil)
  if valid_594364 != nil:
    section.add "subscriptionId", valid_594364
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594365 = query.getOrDefault("api-version")
  valid_594365 = validateParameter(valid_594365, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594365 != nil:
    section.add "api-version", valid_594365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594366: Call_VolumeGet_594359; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the volume resource with the given name. The information include the description and other properties of the volume.
  ## 
  let valid = call_594366.validator(path, query, header, formData, body)
  let scheme = call_594366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594366.url(scheme.get, call_594366.host, call_594366.base,
                         call_594366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594366, url, valid)

proc call*(call_594367: Call_VolumeGet_594359; resourceGroupName: string;
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
  var path_594368 = newJObject()
  var query_594369 = newJObject()
  add(path_594368, "resourceGroupName", newJString(resourceGroupName))
  add(query_594369, "api-version", newJString(apiVersion))
  add(path_594368, "volumeResourceName", newJString(volumeResourceName))
  add(path_594368, "subscriptionId", newJString(subscriptionId))
  result = call_594367.call(path_594368, query_594369, nil, nil, nil)

var volumeGet* = Call_VolumeGet_594359(name: "volumeGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes/{volumeResourceName}",
                                    validator: validate_VolumeGet_594360,
                                    base: "", url: url_VolumeGet_594361,
                                    schemes: {Scheme.Https})
type
  Call_VolumeDelete_594383 = ref object of OpenApiRestCall_593438
proc url_VolumeDelete_594385(protocol: Scheme; host: string; base: string;
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

proc validate_VolumeDelete_594384(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594386 = path.getOrDefault("resourceGroupName")
  valid_594386 = validateParameter(valid_594386, JString, required = true,
                                 default = nil)
  if valid_594386 != nil:
    section.add "resourceGroupName", valid_594386
  var valid_594387 = path.getOrDefault("volumeResourceName")
  valid_594387 = validateParameter(valid_594387, JString, required = true,
                                 default = nil)
  if valid_594387 != nil:
    section.add "volumeResourceName", valid_594387
  var valid_594388 = path.getOrDefault("subscriptionId")
  valid_594388 = validateParameter(valid_594388, JString, required = true,
                                 default = nil)
  if valid_594388 != nil:
    section.add "subscriptionId", valid_594388
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-09-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594389 = query.getOrDefault("api-version")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594389 != nil:
    section.add "api-version", valid_594389
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594390: Call_VolumeDelete_594383; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the volume resource identified by the name.
  ## 
  let valid = call_594390.validator(path, query, header, formData, body)
  let scheme = call_594390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594390.url(scheme.get, call_594390.host, call_594390.base,
                         call_594390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594390, url, valid)

proc call*(call_594391: Call_VolumeDelete_594383; resourceGroupName: string;
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
  var path_594392 = newJObject()
  var query_594393 = newJObject()
  add(path_594392, "resourceGroupName", newJString(resourceGroupName))
  add(query_594393, "api-version", newJString(apiVersion))
  add(path_594392, "volumeResourceName", newJString(volumeResourceName))
  add(path_594392, "subscriptionId", newJString(subscriptionId))
  result = call_594391.call(path_594392, query_594393, nil, nil, nil)

var volumeDelete* = Call_VolumeDelete_594383(name: "volumeDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes/{volumeResourceName}",
    validator: validate_VolumeDelete_594384, base: "", url: url_VolumeDelete_594385,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
