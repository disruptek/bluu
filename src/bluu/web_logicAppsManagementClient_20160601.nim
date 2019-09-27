
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: LogicAppsManagementClient
## version: 2016-06-01
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  macServiceName = "web-logicAppsManagementClient"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ConnectionGatewaysList_593630 = ref object of OpenApiRestCall_593408
proc url_ConnectionGatewaysList_593632(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Web/connectionGateways")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionGatewaysList_593631(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of gateways under a subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593805 = path.getOrDefault("subscriptionId")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "subscriptionId", valid_593805
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593806 = query.getOrDefault("api-version")
  valid_593806 = validateParameter(valid_593806, JString, required = true,
                                 default = nil)
  if valid_593806 != nil:
    section.add "api-version", valid_593806
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593829: Call_ConnectionGatewaysList_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of gateways under a subscription
  ## 
  let valid = call_593829.validator(path, query, header, formData, body)
  let scheme = call_593829.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593829.url(scheme.get, call_593829.host, call_593829.base,
                         call_593829.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593829, url, valid)

proc call*(call_593900: Call_ConnectionGatewaysList_593630; apiVersion: string;
          subscriptionId: string): Recallable =
  ## connectionGatewaysList
  ## Gets a list of gateways under a subscription
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  var path_593901 = newJObject()
  var query_593903 = newJObject()
  add(query_593903, "api-version", newJString(apiVersion))
  add(path_593901, "subscriptionId", newJString(subscriptionId))
  result = call_593900.call(path_593901, query_593903, nil, nil, nil)

var connectionGatewaysList* = Call_ConnectionGatewaysList_593630(
    name: "connectionGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/connectionGateways",
    validator: validate_ConnectionGatewaysList_593631, base: "",
    url: url_ConnectionGatewaysList_593632, schemes: {Scheme.Https})
type
  Call_CustomApisList_593942 = ref object of OpenApiRestCall_593408
proc url_CustomApisList_593944(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/customApis")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomApisList_593943(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a list of all custom APIs for a subscription id
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593946 = path.getOrDefault("subscriptionId")
  valid_593946 = validateParameter(valid_593946, JString, required = true,
                                 default = nil)
  if valid_593946 != nil:
    section.add "subscriptionId", valid_593946
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   skiptoken: JString
  ##            : Skip Token
  ##   $top: JInt
  ##       : The number of items to be included in the result
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593947 = query.getOrDefault("api-version")
  valid_593947 = validateParameter(valid_593947, JString, required = true,
                                 default = nil)
  if valid_593947 != nil:
    section.add "api-version", valid_593947
  var valid_593948 = query.getOrDefault("skiptoken")
  valid_593948 = validateParameter(valid_593948, JString, required = false,
                                 default = nil)
  if valid_593948 != nil:
    section.add "skiptoken", valid_593948
  var valid_593949 = query.getOrDefault("$top")
  valid_593949 = validateParameter(valid_593949, JInt, required = false, default = nil)
  if valid_593949 != nil:
    section.add "$top", valid_593949
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593950: Call_CustomApisList_593942; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all custom APIs for a subscription id
  ## 
  let valid = call_593950.validator(path, query, header, formData, body)
  let scheme = call_593950.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593950.url(scheme.get, call_593950.host, call_593950.base,
                         call_593950.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593950, url, valid)

proc call*(call_593951: Call_CustomApisList_593942; apiVersion: string;
          subscriptionId: string; skiptoken: string = ""; Top: int = 0): Recallable =
  ## customApisList
  ## Gets a list of all custom APIs for a subscription id
  ##   apiVersion: string (required)
  ##             : API Version
  ##   skiptoken: string
  ##            : Skip Token
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   Top: int
  ##      : The number of items to be included in the result
  var path_593952 = newJObject()
  var query_593953 = newJObject()
  add(query_593953, "api-version", newJString(apiVersion))
  add(query_593953, "skiptoken", newJString(skiptoken))
  add(path_593952, "subscriptionId", newJString(subscriptionId))
  add(query_593953, "$top", newJInt(Top))
  result = call_593951.call(path_593952, query_593953, nil, nil, nil)

var customApisList* = Call_CustomApisList_593942(name: "customApisList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/customApis",
    validator: validate_CustomApisList_593943, base: "", url: url_CustomApisList_593944,
    schemes: {Scheme.Https})
type
  Call_ConnectionGatewayInstallationsList_593954 = ref object of OpenApiRestCall_593408
proc url_ConnectionGatewayInstallationsList_593956(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/locations/"),
               (kind: VariableSegment, value: "location"), (kind: ConstantSegment,
        value: "/connectionGatewayInstallations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionGatewayInstallationsList_593955(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of installed gateways that the user is an admin of, in a specific subscription and at a certain location
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  ##   location: JString (required)
  ##           : The location
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593957 = path.getOrDefault("subscriptionId")
  valid_593957 = validateParameter(valid_593957, JString, required = true,
                                 default = nil)
  if valid_593957 != nil:
    section.add "subscriptionId", valid_593957
  var valid_593958 = path.getOrDefault("location")
  valid_593958 = validateParameter(valid_593958, JString, required = true,
                                 default = nil)
  if valid_593958 != nil:
    section.add "location", valid_593958
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593959 = query.getOrDefault("api-version")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = nil)
  if valid_593959 != nil:
    section.add "api-version", valid_593959
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593960: Call_ConnectionGatewayInstallationsList_593954;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of installed gateways that the user is an admin of, in a specific subscription and at a certain location
  ## 
  let valid = call_593960.validator(path, query, header, formData, body)
  let scheme = call_593960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593960.url(scheme.get, call_593960.host, call_593960.base,
                         call_593960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593960, url, valid)

proc call*(call_593961: Call_ConnectionGatewayInstallationsList_593954;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## connectionGatewayInstallationsList
  ## Gets a list of installed gateways that the user is an admin of, in a specific subscription and at a certain location
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   location: string (required)
  ##           : The location
  var path_593962 = newJObject()
  var query_593963 = newJObject()
  add(query_593963, "api-version", newJString(apiVersion))
  add(path_593962, "subscriptionId", newJString(subscriptionId))
  add(path_593962, "location", newJString(location))
  result = call_593961.call(path_593962, query_593963, nil, nil, nil)

var connectionGatewayInstallationsList* = Call_ConnectionGatewayInstallationsList_593954(
    name: "connectionGatewayInstallationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/locations/{location}/connectionGatewayInstallations",
    validator: validate_ConnectionGatewayInstallationsList_593955, base: "",
    url: url_ConnectionGatewayInstallationsList_593956, schemes: {Scheme.Https})
type
  Call_ConnectionGatewayInstallationsGet_593964 = ref object of OpenApiRestCall_593408
proc url_ConnectionGatewayInstallationsGet_593966(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "gatewayId" in path, "`gatewayId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/locations/"),
               (kind: VariableSegment, value: "location"), (kind: ConstantSegment,
        value: "/connectionGatewayInstallations/"),
               (kind: VariableSegment, value: "gatewayId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionGatewayInstallationsGet_593965(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific installed gateway that the user is an admin of, in a specific subscription and at a certain location
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  ##   gatewayId: JString (required)
  ##            : Gateway ID
  ##   location: JString (required)
  ##           : The location
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593967 = path.getOrDefault("subscriptionId")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "subscriptionId", valid_593967
  var valid_593968 = path.getOrDefault("gatewayId")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "gatewayId", valid_593968
  var valid_593969 = path.getOrDefault("location")
  valid_593969 = validateParameter(valid_593969, JString, required = true,
                                 default = nil)
  if valid_593969 != nil:
    section.add "location", valid_593969
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593970 = query.getOrDefault("api-version")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "api-version", valid_593970
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593971: Call_ConnectionGatewayInstallationsGet_593964;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a specific installed gateway that the user is an admin of, in a specific subscription and at a certain location
  ## 
  let valid = call_593971.validator(path, query, header, formData, body)
  let scheme = call_593971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593971.url(scheme.get, call_593971.host, call_593971.base,
                         call_593971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593971, url, valid)

proc call*(call_593972: Call_ConnectionGatewayInstallationsGet_593964;
          apiVersion: string; subscriptionId: string; gatewayId: string;
          location: string): Recallable =
  ## connectionGatewayInstallationsGet
  ## Get a specific installed gateway that the user is an admin of, in a specific subscription and at a certain location
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   gatewayId: string (required)
  ##            : Gateway ID
  ##   location: string (required)
  ##           : The location
  var path_593973 = newJObject()
  var query_593974 = newJObject()
  add(query_593974, "api-version", newJString(apiVersion))
  add(path_593973, "subscriptionId", newJString(subscriptionId))
  add(path_593973, "gatewayId", newJString(gatewayId))
  add(path_593973, "location", newJString(location))
  result = call_593972.call(path_593973, query_593974, nil, nil, nil)

var connectionGatewayInstallationsGet* = Call_ConnectionGatewayInstallationsGet_593964(
    name: "connectionGatewayInstallationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/locations/{location}/connectionGatewayInstallations/{gatewayId}",
    validator: validate_ConnectionGatewayInstallationsGet_593965, base: "",
    url: url_ConnectionGatewayInstallationsGet_593966, schemes: {Scheme.Https})
type
  Call_CustomApisExtractApiDefinitionFromWsdl_593975 = ref object of OpenApiRestCall_593408
proc url_CustomApisExtractApiDefinitionFromWsdl_593977(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/extractApiDefinitionFromWsdl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomApisExtractApiDefinitionFromWsdl_593976(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Parses the specified WSDL and extracts the API definition
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  ##   location: JString (required)
  ##           : The location
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593978 = path.getOrDefault("subscriptionId")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "subscriptionId", valid_593978
  var valid_593979 = path.getOrDefault("location")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "location", valid_593979
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593980 = query.getOrDefault("api-version")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "api-version", valid_593980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   wsdlDefinition: JObject (required)
  ##                 : WSDL definition
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593982: Call_CustomApisExtractApiDefinitionFromWsdl_593975;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Parses the specified WSDL and extracts the API definition
  ## 
  let valid = call_593982.validator(path, query, header, formData, body)
  let scheme = call_593982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593982.url(scheme.get, call_593982.host, call_593982.base,
                         call_593982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593982, url, valid)

proc call*(call_593983: Call_CustomApisExtractApiDefinitionFromWsdl_593975;
          apiVersion: string; subscriptionId: string; wsdlDefinition: JsonNode;
          location: string): Recallable =
  ## customApisExtractApiDefinitionFromWsdl
  ## Parses the specified WSDL and extracts the API definition
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   wsdlDefinition: JObject (required)
  ##                 : WSDL definition
  ##   location: string (required)
  ##           : The location
  var path_593984 = newJObject()
  var query_593985 = newJObject()
  var body_593986 = newJObject()
  add(query_593985, "api-version", newJString(apiVersion))
  add(path_593984, "subscriptionId", newJString(subscriptionId))
  if wsdlDefinition != nil:
    body_593986 = wsdlDefinition
  add(path_593984, "location", newJString(location))
  result = call_593983.call(path_593984, query_593985, nil, nil, body_593986)

var customApisExtractApiDefinitionFromWsdl* = Call_CustomApisExtractApiDefinitionFromWsdl_593975(
    name: "customApisExtractApiDefinitionFromWsdl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/locations/{location}/extractApiDefinitionFromWsdl",
    validator: validate_CustomApisExtractApiDefinitionFromWsdl_593976, base: "",
    url: url_CustomApisExtractApiDefinitionFromWsdl_593977,
    schemes: {Scheme.Https})
type
  Call_CustomApisListWsdlInterfaces_593987 = ref object of OpenApiRestCall_593408
proc url_CustomApisListWsdlInterfaces_593989(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/listWsdlInterfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomApisListWsdlInterfaces_593988(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This returns the list of interfaces in the WSDL
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  ##   location: JString (required)
  ##           : The location
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593990 = path.getOrDefault("subscriptionId")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "subscriptionId", valid_593990
  var valid_593991 = path.getOrDefault("location")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "location", valid_593991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593992 = query.getOrDefault("api-version")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "api-version", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   wsdlDefinition: JObject (required)
  ##                 : WSDL definition
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593994: Call_CustomApisListWsdlInterfaces_593987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This returns the list of interfaces in the WSDL
  ## 
  let valid = call_593994.validator(path, query, header, formData, body)
  let scheme = call_593994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593994.url(scheme.get, call_593994.host, call_593994.base,
                         call_593994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593994, url, valid)

proc call*(call_593995: Call_CustomApisListWsdlInterfaces_593987;
          apiVersion: string; subscriptionId: string; wsdlDefinition: JsonNode;
          location: string): Recallable =
  ## customApisListWsdlInterfaces
  ## This returns the list of interfaces in the WSDL
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   wsdlDefinition: JObject (required)
  ##                 : WSDL definition
  ##   location: string (required)
  ##           : The location
  var path_593996 = newJObject()
  var query_593997 = newJObject()
  var body_593998 = newJObject()
  add(query_593997, "api-version", newJString(apiVersion))
  add(path_593996, "subscriptionId", newJString(subscriptionId))
  if wsdlDefinition != nil:
    body_593998 = wsdlDefinition
  add(path_593996, "location", newJString(location))
  result = call_593995.call(path_593996, query_593997, nil, nil, body_593998)

var customApisListWsdlInterfaces* = Call_CustomApisListWsdlInterfaces_593987(
    name: "customApisListWsdlInterfaces", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/locations/{location}/listWsdlInterfaces",
    validator: validate_CustomApisListWsdlInterfaces_593988, base: "",
    url: url_CustomApisListWsdlInterfaces_593989, schemes: {Scheme.Https})
type
  Call_ManagedApisList_593999 = ref object of OpenApiRestCall_593408
proc url_ManagedApisList_594001(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/managedApis")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedApisList_594000(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a list of managed APIs
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  ##   location: JString (required)
  ##           : The location
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594002 = path.getOrDefault("subscriptionId")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "subscriptionId", valid_594002
  var valid_594003 = path.getOrDefault("location")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "location", valid_594003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594004 = query.getOrDefault("api-version")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "api-version", valid_594004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594005: Call_ManagedApisList_593999; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of managed APIs
  ## 
  let valid = call_594005.validator(path, query, header, formData, body)
  let scheme = call_594005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594005.url(scheme.get, call_594005.host, call_594005.base,
                         call_594005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594005, url, valid)

proc call*(call_594006: Call_ManagedApisList_593999; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## managedApisList
  ## Gets a list of managed APIs
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   location: string (required)
  ##           : The location
  var path_594007 = newJObject()
  var query_594008 = newJObject()
  add(query_594008, "api-version", newJString(apiVersion))
  add(path_594007, "subscriptionId", newJString(subscriptionId))
  add(path_594007, "location", newJString(location))
  result = call_594006.call(path_594007, query_594008, nil, nil, nil)

var managedApisList* = Call_ManagedApisList_593999(name: "managedApisList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/locations/{location}/managedApis",
    validator: validate_ManagedApisList_594000, base: "", url: url_ManagedApisList_594001,
    schemes: {Scheme.Https})
type
  Call_ManagedApisGet_594009 = ref object of OpenApiRestCall_593408
proc url_ManagedApisGet_594011(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "apiName" in path, "`apiName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/managedApis/"),
               (kind: VariableSegment, value: "apiName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedApisGet_594010(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a managed API
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiName: JString (required)
  ##          : API name
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  ##   location: JString (required)
  ##           : The location
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiName` field"
  var valid_594012 = path.getOrDefault("apiName")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "apiName", valid_594012
  var valid_594013 = path.getOrDefault("subscriptionId")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "subscriptionId", valid_594013
  var valid_594014 = path.getOrDefault("location")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "location", valid_594014
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594015 = query.getOrDefault("api-version")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "api-version", valid_594015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594016: Call_ManagedApisGet_594009; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a managed API
  ## 
  let valid = call_594016.validator(path, query, header, formData, body)
  let scheme = call_594016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594016.url(scheme.get, call_594016.host, call_594016.base,
                         call_594016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594016, url, valid)

proc call*(call_594017: Call_ManagedApisGet_594009; apiVersion: string;
          apiName: string; subscriptionId: string; location: string): Recallable =
  ## managedApisGet
  ## Gets a managed API
  ##   apiVersion: string (required)
  ##             : API Version
  ##   apiName: string (required)
  ##          : API name
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   location: string (required)
  ##           : The location
  var path_594018 = newJObject()
  var query_594019 = newJObject()
  add(query_594019, "api-version", newJString(apiVersion))
  add(path_594018, "apiName", newJString(apiName))
  add(path_594018, "subscriptionId", newJString(subscriptionId))
  add(path_594018, "location", newJString(location))
  result = call_594017.call(path_594018, query_594019, nil, nil, nil)

var managedApisGet* = Call_ManagedApisGet_594009(name: "managedApisGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/locations/{location}/managedApis/{apiName}",
    validator: validate_ManagedApisGet_594010, base: "", url: url_ManagedApisGet_594011,
    schemes: {Scheme.Https})
type
  Call_ConnectionGatewaysListByResourceGroup_594020 = ref object of OpenApiRestCall_593408
proc url_ConnectionGatewaysListByResourceGroup_594022(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Web/connectionGateways")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionGatewaysListByResourceGroup_594021(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of gateways under a subscription and in a specific resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594023 = path.getOrDefault("resourceGroupName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "resourceGroupName", valid_594023
  var valid_594024 = path.getOrDefault("subscriptionId")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "subscriptionId", valid_594024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594025 = query.getOrDefault("api-version")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "api-version", valid_594025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594026: Call_ConnectionGatewaysListByResourceGroup_594020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of gateways under a subscription and in a specific resource group
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_ConnectionGatewaysListByResourceGroup_594020;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## connectionGatewaysListByResourceGroup
  ## Gets a list of gateways under a subscription and in a specific resource group
  ##   resourceGroupName: string (required)
  ##                    : The resource group
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  add(path_594028, "resourceGroupName", newJString(resourceGroupName))
  add(query_594029, "api-version", newJString(apiVersion))
  add(path_594028, "subscriptionId", newJString(subscriptionId))
  result = call_594027.call(path_594028, query_594029, nil, nil, nil)

var connectionGatewaysListByResourceGroup* = Call_ConnectionGatewaysListByResourceGroup_594020(
    name: "connectionGatewaysListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/connectionGateways",
    validator: validate_ConnectionGatewaysListByResourceGroup_594021, base: "",
    url: url_ConnectionGatewaysListByResourceGroup_594022, schemes: {Scheme.Https})
type
  Call_ConnectionGatewaysCreateOrUpdate_594041 = ref object of OpenApiRestCall_593408
proc url_ConnectionGatewaysCreateOrUpdate_594043(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "connectionGatewayName" in path,
        "`connectionGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/connectionGateways/"),
               (kind: VariableSegment, value: "connectionGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionGatewaysCreateOrUpdate_594042(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a specific gateway for under a subscription and in a specific resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group
  ##   connectionGatewayName: JString (required)
  ##                        : The connection gateway name
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594044 = path.getOrDefault("resourceGroupName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "resourceGroupName", valid_594044
  var valid_594045 = path.getOrDefault("connectionGatewayName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "connectionGatewayName", valid_594045
  var valid_594046 = path.getOrDefault("subscriptionId")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "subscriptionId", valid_594046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594047 = query.getOrDefault("api-version")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "api-version", valid_594047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   connectionGateway: JObject (required)
  ##                    : The connection gateway
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594049: Call_ConnectionGatewaysCreateOrUpdate_594041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a specific gateway for under a subscription and in a specific resource group
  ## 
  let valid = call_594049.validator(path, query, header, formData, body)
  let scheme = call_594049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594049.url(scheme.get, call_594049.host, call_594049.base,
                         call_594049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594049, url, valid)

proc call*(call_594050: Call_ConnectionGatewaysCreateOrUpdate_594041;
          resourceGroupName: string; apiVersion: string;
          connectionGatewayName: string; connectionGateway: JsonNode;
          subscriptionId: string): Recallable =
  ## connectionGatewaysCreateOrUpdate
  ## Creates or updates a specific gateway for under a subscription and in a specific resource group
  ##   resourceGroupName: string (required)
  ##                    : The resource group
  ##   apiVersion: string (required)
  ##             : API Version
  ##   connectionGatewayName: string (required)
  ##                        : The connection gateway name
  ##   connectionGateway: JObject (required)
  ##                    : The connection gateway
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  var path_594051 = newJObject()
  var query_594052 = newJObject()
  var body_594053 = newJObject()
  add(path_594051, "resourceGroupName", newJString(resourceGroupName))
  add(query_594052, "api-version", newJString(apiVersion))
  add(path_594051, "connectionGatewayName", newJString(connectionGatewayName))
  if connectionGateway != nil:
    body_594053 = connectionGateway
  add(path_594051, "subscriptionId", newJString(subscriptionId))
  result = call_594050.call(path_594051, query_594052, nil, nil, body_594053)

var connectionGatewaysCreateOrUpdate* = Call_ConnectionGatewaysCreateOrUpdate_594041(
    name: "connectionGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/connectionGateways/{connectionGatewayName}",
    validator: validate_ConnectionGatewaysCreateOrUpdate_594042, base: "",
    url: url_ConnectionGatewaysCreateOrUpdate_594043, schemes: {Scheme.Https})
type
  Call_ConnectionGatewaysGet_594030 = ref object of OpenApiRestCall_593408
proc url_ConnectionGatewaysGet_594032(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "connectionGatewayName" in path,
        "`connectionGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/connectionGateways/"),
               (kind: VariableSegment, value: "connectionGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionGatewaysGet_594031(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a specific gateway under a subscription and in a specific resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group
  ##   connectionGatewayName: JString (required)
  ##                        : The connection gateway name
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594033 = path.getOrDefault("resourceGroupName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "resourceGroupName", valid_594033
  var valid_594034 = path.getOrDefault("connectionGatewayName")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "connectionGatewayName", valid_594034
  var valid_594035 = path.getOrDefault("subscriptionId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "subscriptionId", valid_594035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594036 = query.getOrDefault("api-version")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "api-version", valid_594036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594037: Call_ConnectionGatewaysGet_594030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific gateway under a subscription and in a specific resource group
  ## 
  let valid = call_594037.validator(path, query, header, formData, body)
  let scheme = call_594037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594037.url(scheme.get, call_594037.host, call_594037.base,
                         call_594037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594037, url, valid)

proc call*(call_594038: Call_ConnectionGatewaysGet_594030;
          resourceGroupName: string; apiVersion: string;
          connectionGatewayName: string; subscriptionId: string): Recallable =
  ## connectionGatewaysGet
  ## Gets a specific gateway under a subscription and in a specific resource group
  ##   resourceGroupName: string (required)
  ##                    : The resource group
  ##   apiVersion: string (required)
  ##             : API Version
  ##   connectionGatewayName: string (required)
  ##                        : The connection gateway name
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  var path_594039 = newJObject()
  var query_594040 = newJObject()
  add(path_594039, "resourceGroupName", newJString(resourceGroupName))
  add(query_594040, "api-version", newJString(apiVersion))
  add(path_594039, "connectionGatewayName", newJString(connectionGatewayName))
  add(path_594039, "subscriptionId", newJString(subscriptionId))
  result = call_594038.call(path_594039, query_594040, nil, nil, nil)

var connectionGatewaysGet* = Call_ConnectionGatewaysGet_594030(
    name: "connectionGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/connectionGateways/{connectionGatewayName}",
    validator: validate_ConnectionGatewaysGet_594031, base: "",
    url: url_ConnectionGatewaysGet_594032, schemes: {Scheme.Https})
type
  Call_ConnectionGatewaysUpdate_594065 = ref object of OpenApiRestCall_593408
proc url_ConnectionGatewaysUpdate_594067(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "connectionGatewayName" in path,
        "`connectionGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/connectionGateways/"),
               (kind: VariableSegment, value: "connectionGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionGatewaysUpdate_594066(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a connection gateway's tags
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group
  ##   connectionGatewayName: JString (required)
  ##                        : The connection gateway name
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594068 = path.getOrDefault("resourceGroupName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "resourceGroupName", valid_594068
  var valid_594069 = path.getOrDefault("connectionGatewayName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "connectionGatewayName", valid_594069
  var valid_594070 = path.getOrDefault("subscriptionId")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "subscriptionId", valid_594070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594071 = query.getOrDefault("api-version")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "api-version", valid_594071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   connectionGateway: JObject (required)
  ##                    : The connection gateway
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594073: Call_ConnectionGatewaysUpdate_594065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a connection gateway's tags
  ## 
  let valid = call_594073.validator(path, query, header, formData, body)
  let scheme = call_594073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594073.url(scheme.get, call_594073.host, call_594073.base,
                         call_594073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594073, url, valid)

proc call*(call_594074: Call_ConnectionGatewaysUpdate_594065;
          resourceGroupName: string; apiVersion: string;
          connectionGatewayName: string; connectionGateway: JsonNode;
          subscriptionId: string): Recallable =
  ## connectionGatewaysUpdate
  ## Updates a connection gateway's tags
  ##   resourceGroupName: string (required)
  ##                    : The resource group
  ##   apiVersion: string (required)
  ##             : API Version
  ##   connectionGatewayName: string (required)
  ##                        : The connection gateway name
  ##   connectionGateway: JObject (required)
  ##                    : The connection gateway
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  var path_594075 = newJObject()
  var query_594076 = newJObject()
  var body_594077 = newJObject()
  add(path_594075, "resourceGroupName", newJString(resourceGroupName))
  add(query_594076, "api-version", newJString(apiVersion))
  add(path_594075, "connectionGatewayName", newJString(connectionGatewayName))
  if connectionGateway != nil:
    body_594077 = connectionGateway
  add(path_594075, "subscriptionId", newJString(subscriptionId))
  result = call_594074.call(path_594075, query_594076, nil, nil, body_594077)

var connectionGatewaysUpdate* = Call_ConnectionGatewaysUpdate_594065(
    name: "connectionGatewaysUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/connectionGateways/{connectionGatewayName}",
    validator: validate_ConnectionGatewaysUpdate_594066, base: "",
    url: url_ConnectionGatewaysUpdate_594067, schemes: {Scheme.Https})
type
  Call_ConnectionGatewaysDelete_594054 = ref object of OpenApiRestCall_593408
proc url_ConnectionGatewaysDelete_594056(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "connectionGatewayName" in path,
        "`connectionGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/connectionGateways/"),
               (kind: VariableSegment, value: "connectionGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionGatewaysDelete_594055(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a specific gateway for under a subscription and in a specific resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group
  ##   connectionGatewayName: JString (required)
  ##                        : The connection gateway name
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594057 = path.getOrDefault("resourceGroupName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "resourceGroupName", valid_594057
  var valid_594058 = path.getOrDefault("connectionGatewayName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "connectionGatewayName", valid_594058
  var valid_594059 = path.getOrDefault("subscriptionId")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "subscriptionId", valid_594059
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594060 = query.getOrDefault("api-version")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "api-version", valid_594060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594061: Call_ConnectionGatewaysDelete_594054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a specific gateway for under a subscription and in a specific resource group
  ## 
  let valid = call_594061.validator(path, query, header, formData, body)
  let scheme = call_594061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594061.url(scheme.get, call_594061.host, call_594061.base,
                         call_594061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594061, url, valid)

proc call*(call_594062: Call_ConnectionGatewaysDelete_594054;
          resourceGroupName: string; apiVersion: string;
          connectionGatewayName: string; subscriptionId: string): Recallable =
  ## connectionGatewaysDelete
  ## Deletes a specific gateway for under a subscription and in a specific resource group
  ##   resourceGroupName: string (required)
  ##                    : The resource group
  ##   apiVersion: string (required)
  ##             : API Version
  ##   connectionGatewayName: string (required)
  ##                        : The connection gateway name
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  var path_594063 = newJObject()
  var query_594064 = newJObject()
  add(path_594063, "resourceGroupName", newJString(resourceGroupName))
  add(query_594064, "api-version", newJString(apiVersion))
  add(path_594063, "connectionGatewayName", newJString(connectionGatewayName))
  add(path_594063, "subscriptionId", newJString(subscriptionId))
  result = call_594062.call(path_594063, query_594064, nil, nil, nil)

var connectionGatewaysDelete* = Call_ConnectionGatewaysDelete_594054(
    name: "connectionGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/connectionGateways/{connectionGatewayName}",
    validator: validate_ConnectionGatewaysDelete_594055, base: "",
    url: url_ConnectionGatewaysDelete_594056, schemes: {Scheme.Https})
type
  Call_ConnectionsList_594078 = ref object of OpenApiRestCall_593408
proc url_ConnectionsList_594080(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Web/connections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionsList_594079(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a list of connections
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594081 = path.getOrDefault("resourceGroupName")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "resourceGroupName", valid_594081
  var valid_594082 = path.getOrDefault("subscriptionId")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "subscriptionId", valid_594082
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   $top: JInt
  ##       : The number of items to be included in the result
  ##   $filter: JString
  ##          : The filter to apply on the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594083 = query.getOrDefault("api-version")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "api-version", valid_594083
  var valid_594084 = query.getOrDefault("$top")
  valid_594084 = validateParameter(valid_594084, JInt, required = false, default = nil)
  if valid_594084 != nil:
    section.add "$top", valid_594084
  var valid_594085 = query.getOrDefault("$filter")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "$filter", valid_594085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594086: Call_ConnectionsList_594078; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of connections
  ## 
  let valid = call_594086.validator(path, query, header, formData, body)
  let scheme = call_594086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594086.url(scheme.get, call_594086.host, call_594086.base,
                         call_594086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594086, url, valid)

proc call*(call_594087: Call_ConnectionsList_594078; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## connectionsList
  ## Gets a list of connections
  ##   resourceGroupName: string (required)
  ##                    : The resource group
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   Top: int
  ##      : The number of items to be included in the result
  ##   Filter: string
  ##         : The filter to apply on the operation
  var path_594088 = newJObject()
  var query_594089 = newJObject()
  add(path_594088, "resourceGroupName", newJString(resourceGroupName))
  add(query_594089, "api-version", newJString(apiVersion))
  add(path_594088, "subscriptionId", newJString(subscriptionId))
  add(query_594089, "$top", newJInt(Top))
  add(query_594089, "$filter", newJString(Filter))
  result = call_594087.call(path_594088, query_594089, nil, nil, nil)

var connectionsList* = Call_ConnectionsList_594078(name: "connectionsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/connections",
    validator: validate_ConnectionsList_594079, base: "", url: url_ConnectionsList_594080,
    schemes: {Scheme.Https})
type
  Call_ConnectionsCreateOrUpdate_594101 = ref object of OpenApiRestCall_593408
proc url_ConnectionsCreateOrUpdate_594103(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/connections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionsCreateOrUpdate_594102(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a connection
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  ##   connectionName: JString (required)
  ##                 : Connection name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594104 = path.getOrDefault("resourceGroupName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "resourceGroupName", valid_594104
  var valid_594105 = path.getOrDefault("subscriptionId")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "subscriptionId", valid_594105
  var valid_594106 = path.getOrDefault("connectionName")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "connectionName", valid_594106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594107 = query.getOrDefault("api-version")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "api-version", valid_594107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   connection: JObject (required)
  ##             : The connection
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594109: Call_ConnectionsCreateOrUpdate_594101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a connection
  ## 
  let valid = call_594109.validator(path, query, header, formData, body)
  let scheme = call_594109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594109.url(scheme.get, call_594109.host, call_594109.base,
                         call_594109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594109, url, valid)

proc call*(call_594110: Call_ConnectionsCreateOrUpdate_594101;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          connection: JsonNode; connectionName: string): Recallable =
  ## connectionsCreateOrUpdate
  ## Creates or updates a connection
  ##   resourceGroupName: string (required)
  ##                    : The resource group
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   connection: JObject (required)
  ##             : The connection
  ##   connectionName: string (required)
  ##                 : Connection name
  var path_594111 = newJObject()
  var query_594112 = newJObject()
  var body_594113 = newJObject()
  add(path_594111, "resourceGroupName", newJString(resourceGroupName))
  add(query_594112, "api-version", newJString(apiVersion))
  add(path_594111, "subscriptionId", newJString(subscriptionId))
  if connection != nil:
    body_594113 = connection
  add(path_594111, "connectionName", newJString(connectionName))
  result = call_594110.call(path_594111, query_594112, nil, nil, body_594113)

var connectionsCreateOrUpdate* = Call_ConnectionsCreateOrUpdate_594101(
    name: "connectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/connections/{connectionName}",
    validator: validate_ConnectionsCreateOrUpdate_594102, base: "",
    url: url_ConnectionsCreateOrUpdate_594103, schemes: {Scheme.Https})
type
  Call_ConnectionsGet_594090 = ref object of OpenApiRestCall_593408
proc url_ConnectionsGet_594092(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/connections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionsGet_594091(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get a specific connection
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  ##   connectionName: JString (required)
  ##                 : Connection name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594093 = path.getOrDefault("resourceGroupName")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "resourceGroupName", valid_594093
  var valid_594094 = path.getOrDefault("subscriptionId")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "subscriptionId", valid_594094
  var valid_594095 = path.getOrDefault("connectionName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "connectionName", valid_594095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594096 = query.getOrDefault("api-version")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "api-version", valid_594096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594097: Call_ConnectionsGet_594090; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific connection
  ## 
  let valid = call_594097.validator(path, query, header, formData, body)
  let scheme = call_594097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594097.url(scheme.get, call_594097.host, call_594097.base,
                         call_594097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594097, url, valid)

proc call*(call_594098: Call_ConnectionsGet_594090; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; connectionName: string): Recallable =
  ## connectionsGet
  ## Get a specific connection
  ##   resourceGroupName: string (required)
  ##                    : The resource group
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   connectionName: string (required)
  ##                 : Connection name
  var path_594099 = newJObject()
  var query_594100 = newJObject()
  add(path_594099, "resourceGroupName", newJString(resourceGroupName))
  add(query_594100, "api-version", newJString(apiVersion))
  add(path_594099, "subscriptionId", newJString(subscriptionId))
  add(path_594099, "connectionName", newJString(connectionName))
  result = call_594098.call(path_594099, query_594100, nil, nil, nil)

var connectionsGet* = Call_ConnectionsGet_594090(name: "connectionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/connections/{connectionName}",
    validator: validate_ConnectionsGet_594091, base: "", url: url_ConnectionsGet_594092,
    schemes: {Scheme.Https})
type
  Call_ConnectionsUpdate_594125 = ref object of OpenApiRestCall_593408
proc url_ConnectionsUpdate_594127(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/connections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionsUpdate_594126(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates a connection's tags
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  ##   connectionName: JString (required)
  ##                 : Connection name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594128 = path.getOrDefault("resourceGroupName")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "resourceGroupName", valid_594128
  var valid_594129 = path.getOrDefault("subscriptionId")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "subscriptionId", valid_594129
  var valid_594130 = path.getOrDefault("connectionName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "connectionName", valid_594130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594131 = query.getOrDefault("api-version")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "api-version", valid_594131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   connection: JObject (required)
  ##             : The connection
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594133: Call_ConnectionsUpdate_594125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a connection's tags
  ## 
  let valid = call_594133.validator(path, query, header, formData, body)
  let scheme = call_594133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594133.url(scheme.get, call_594133.host, call_594133.base,
                         call_594133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594133, url, valid)

proc call*(call_594134: Call_ConnectionsUpdate_594125; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; connection: JsonNode;
          connectionName: string): Recallable =
  ## connectionsUpdate
  ## Updates a connection's tags
  ##   resourceGroupName: string (required)
  ##                    : The resource group
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   connection: JObject (required)
  ##             : The connection
  ##   connectionName: string (required)
  ##                 : Connection name
  var path_594135 = newJObject()
  var query_594136 = newJObject()
  var body_594137 = newJObject()
  add(path_594135, "resourceGroupName", newJString(resourceGroupName))
  add(query_594136, "api-version", newJString(apiVersion))
  add(path_594135, "subscriptionId", newJString(subscriptionId))
  if connection != nil:
    body_594137 = connection
  add(path_594135, "connectionName", newJString(connectionName))
  result = call_594134.call(path_594135, query_594136, nil, nil, body_594137)

var connectionsUpdate* = Call_ConnectionsUpdate_594125(name: "connectionsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/connections/{connectionName}",
    validator: validate_ConnectionsUpdate_594126, base: "",
    url: url_ConnectionsUpdate_594127, schemes: {Scheme.Https})
type
  Call_ConnectionsDelete_594114 = ref object of OpenApiRestCall_593408
proc url_ConnectionsDelete_594116(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/connections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionsDelete_594115(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes a connection
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  ##   connectionName: JString (required)
  ##                 : Connection name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594117 = path.getOrDefault("resourceGroupName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "resourceGroupName", valid_594117
  var valid_594118 = path.getOrDefault("subscriptionId")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "subscriptionId", valid_594118
  var valid_594119 = path.getOrDefault("connectionName")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "connectionName", valid_594119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594120 = query.getOrDefault("api-version")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "api-version", valid_594120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594121: Call_ConnectionsDelete_594114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a connection
  ## 
  let valid = call_594121.validator(path, query, header, formData, body)
  let scheme = call_594121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594121.url(scheme.get, call_594121.host, call_594121.base,
                         call_594121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594121, url, valid)

proc call*(call_594122: Call_ConnectionsDelete_594114; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; connectionName: string): Recallable =
  ## connectionsDelete
  ## Deletes a connection
  ##   resourceGroupName: string (required)
  ##                    : The resource group
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   connectionName: string (required)
  ##                 : Connection name
  var path_594123 = newJObject()
  var query_594124 = newJObject()
  add(path_594123, "resourceGroupName", newJString(resourceGroupName))
  add(query_594124, "api-version", newJString(apiVersion))
  add(path_594123, "subscriptionId", newJString(subscriptionId))
  add(path_594123, "connectionName", newJString(connectionName))
  result = call_594122.call(path_594123, query_594124, nil, nil, nil)

var connectionsDelete* = Call_ConnectionsDelete_594114(name: "connectionsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/connections/{connectionName}",
    validator: validate_ConnectionsDelete_594115, base: "",
    url: url_ConnectionsDelete_594116, schemes: {Scheme.Https})
type
  Call_ConnectionsConfirmConsentCode_594138 = ref object of OpenApiRestCall_593408
proc url_ConnectionsConfirmConsentCode_594140(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/connections/"),
               (kind: VariableSegment, value: "connectionName"),
               (kind: ConstantSegment, value: "/confirmConsentCode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionsConfirmConsentCode_594139(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Confirms consent code of a connection
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  ##   connectionName: JString (required)
  ##                 : Connection name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594141 = path.getOrDefault("resourceGroupName")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "resourceGroupName", valid_594141
  var valid_594142 = path.getOrDefault("subscriptionId")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "subscriptionId", valid_594142
  var valid_594143 = path.getOrDefault("connectionName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "connectionName", valid_594143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594144 = query.getOrDefault("api-version")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "api-version", valid_594144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   confirmConsentCode: JObject (required)
  ##                     : The consent code confirmation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594146: Call_ConnectionsConfirmConsentCode_594138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Confirms consent code of a connection
  ## 
  let valid = call_594146.validator(path, query, header, formData, body)
  let scheme = call_594146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594146.url(scheme.get, call_594146.host, call_594146.base,
                         call_594146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594146, url, valid)

proc call*(call_594147: Call_ConnectionsConfirmConsentCode_594138;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          confirmConsentCode: JsonNode; connectionName: string): Recallable =
  ## connectionsConfirmConsentCode
  ## Confirms consent code of a connection
  ##   resourceGroupName: string (required)
  ##                    : The resource group
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   confirmConsentCode: JObject (required)
  ##                     : The consent code confirmation
  ##   connectionName: string (required)
  ##                 : Connection name
  var path_594148 = newJObject()
  var query_594149 = newJObject()
  var body_594150 = newJObject()
  add(path_594148, "resourceGroupName", newJString(resourceGroupName))
  add(query_594149, "api-version", newJString(apiVersion))
  add(path_594148, "subscriptionId", newJString(subscriptionId))
  if confirmConsentCode != nil:
    body_594150 = confirmConsentCode
  add(path_594148, "connectionName", newJString(connectionName))
  result = call_594147.call(path_594148, query_594149, nil, nil, body_594150)

var connectionsConfirmConsentCode* = Call_ConnectionsConfirmConsentCode_594138(
    name: "connectionsConfirmConsentCode", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/connections/{connectionName}/confirmConsentCode",
    validator: validate_ConnectionsConfirmConsentCode_594139, base: "",
    url: url_ConnectionsConfirmConsentCode_594140, schemes: {Scheme.Https})
type
  Call_ConnectionsListConsentLinks_594151 = ref object of OpenApiRestCall_593408
proc url_ConnectionsListConsentLinks_594153(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/connections/"),
               (kind: VariableSegment, value: "connectionName"),
               (kind: ConstantSegment, value: "/listConsentLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionsListConsentLinks_594152(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the consent links of a connection
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  ##   connectionName: JString (required)
  ##                 : Connection name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594154 = path.getOrDefault("resourceGroupName")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "resourceGroupName", valid_594154
  var valid_594155 = path.getOrDefault("subscriptionId")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "subscriptionId", valid_594155
  var valid_594156 = path.getOrDefault("connectionName")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "connectionName", valid_594156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594157 = query.getOrDefault("api-version")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "api-version", valid_594157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   listConsentLink: JObject (required)
  ##                  : The consent links
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594159: Call_ConnectionsListConsentLinks_594151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the consent links of a connection
  ## 
  let valid = call_594159.validator(path, query, header, formData, body)
  let scheme = call_594159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594159.url(scheme.get, call_594159.host, call_594159.base,
                         call_594159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594159, url, valid)

proc call*(call_594160: Call_ConnectionsListConsentLinks_594151;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          listConsentLink: JsonNode; connectionName: string): Recallable =
  ## connectionsListConsentLinks
  ## Lists the consent links of a connection
  ##   resourceGroupName: string (required)
  ##                    : The resource group
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   listConsentLink: JObject (required)
  ##                  : The consent links
  ##   connectionName: string (required)
  ##                 : Connection name
  var path_594161 = newJObject()
  var query_594162 = newJObject()
  var body_594163 = newJObject()
  add(path_594161, "resourceGroupName", newJString(resourceGroupName))
  add(query_594162, "api-version", newJString(apiVersion))
  add(path_594161, "subscriptionId", newJString(subscriptionId))
  if listConsentLink != nil:
    body_594163 = listConsentLink
  add(path_594161, "connectionName", newJString(connectionName))
  result = call_594160.call(path_594161, query_594162, nil, nil, body_594163)

var connectionsListConsentLinks* = Call_ConnectionsListConsentLinks_594151(
    name: "connectionsListConsentLinks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/connections/{connectionName}/listConsentLinks",
    validator: validate_ConnectionsListConsentLinks_594152, base: "",
    url: url_ConnectionsListConsentLinks_594153, schemes: {Scheme.Https})
type
  Call_CustomApisListByResourceGroup_594164 = ref object of OpenApiRestCall_593408
proc url_CustomApisListByResourceGroup_594166(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Web/customApis")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomApisListByResourceGroup_594165(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all custom APIs in a subscription for a specific resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594167 = path.getOrDefault("resourceGroupName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "resourceGroupName", valid_594167
  var valid_594168 = path.getOrDefault("subscriptionId")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "subscriptionId", valid_594168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   skiptoken: JString
  ##            : Skip Token
  ##   $top: JInt
  ##       : The number of items to be included in the result
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594169 = query.getOrDefault("api-version")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "api-version", valid_594169
  var valid_594170 = query.getOrDefault("skiptoken")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "skiptoken", valid_594170
  var valid_594171 = query.getOrDefault("$top")
  valid_594171 = validateParameter(valid_594171, JInt, required = false, default = nil)
  if valid_594171 != nil:
    section.add "$top", valid_594171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594172: Call_CustomApisListByResourceGroup_594164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all custom APIs in a subscription for a specific resource group
  ## 
  let valid = call_594172.validator(path, query, header, formData, body)
  let scheme = call_594172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594172.url(scheme.get, call_594172.host, call_594172.base,
                         call_594172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594172, url, valid)

proc call*(call_594173: Call_CustomApisListByResourceGroup_594164;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          skiptoken: string = ""; Top: int = 0): Recallable =
  ## customApisListByResourceGroup
  ## Gets a list of all custom APIs in a subscription for a specific resource group
  ##   resourceGroupName: string (required)
  ##                    : The resource group
  ##   apiVersion: string (required)
  ##             : API Version
  ##   skiptoken: string
  ##            : Skip Token
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   Top: int
  ##      : The number of items to be included in the result
  var path_594174 = newJObject()
  var query_594175 = newJObject()
  add(path_594174, "resourceGroupName", newJString(resourceGroupName))
  add(query_594175, "api-version", newJString(apiVersion))
  add(query_594175, "skiptoken", newJString(skiptoken))
  add(path_594174, "subscriptionId", newJString(subscriptionId))
  add(query_594175, "$top", newJInt(Top))
  result = call_594173.call(path_594174, query_594175, nil, nil, nil)

var customApisListByResourceGroup* = Call_CustomApisListByResourceGroup_594164(
    name: "customApisListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/customApis",
    validator: validate_CustomApisListByResourceGroup_594165, base: "",
    url: url_CustomApisListByResourceGroup_594166, schemes: {Scheme.Https})
type
  Call_CustomApisCreateOrUpdate_594187 = ref object of OpenApiRestCall_593408
proc url_CustomApisCreateOrUpdate_594189(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "apiName" in path, "`apiName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/customApis/"),
               (kind: VariableSegment, value: "apiName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomApisCreateOrUpdate_594188(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an existing custom API
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group
  ##   apiName: JString (required)
  ##          : API name
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594190 = path.getOrDefault("resourceGroupName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "resourceGroupName", valid_594190
  var valid_594191 = path.getOrDefault("apiName")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "apiName", valid_594191
  var valid_594192 = path.getOrDefault("subscriptionId")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "subscriptionId", valid_594192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594193 = query.getOrDefault("api-version")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "api-version", valid_594193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customApi: JObject (required)
  ##            : The custom API
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594195: Call_CustomApisCreateOrUpdate_594187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an existing custom API
  ## 
  let valid = call_594195.validator(path, query, header, formData, body)
  let scheme = call_594195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594195.url(scheme.get, call_594195.host, call_594195.base,
                         call_594195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594195, url, valid)

proc call*(call_594196: Call_CustomApisCreateOrUpdate_594187;
          resourceGroupName: string; apiVersion: string; apiName: string;
          subscriptionId: string; customApi: JsonNode): Recallable =
  ## customApisCreateOrUpdate
  ## Creates or updates an existing custom API
  ##   resourceGroupName: string (required)
  ##                    : The resource group
  ##   apiVersion: string (required)
  ##             : API Version
  ##   apiName: string (required)
  ##          : API name
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   customApi: JObject (required)
  ##            : The custom API
  var path_594197 = newJObject()
  var query_594198 = newJObject()
  var body_594199 = newJObject()
  add(path_594197, "resourceGroupName", newJString(resourceGroupName))
  add(query_594198, "api-version", newJString(apiVersion))
  add(path_594197, "apiName", newJString(apiName))
  add(path_594197, "subscriptionId", newJString(subscriptionId))
  if customApi != nil:
    body_594199 = customApi
  result = call_594196.call(path_594197, query_594198, nil, nil, body_594199)

var customApisCreateOrUpdate* = Call_CustomApisCreateOrUpdate_594187(
    name: "customApisCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/customApis/{apiName}",
    validator: validate_CustomApisCreateOrUpdate_594188, base: "",
    url: url_CustomApisCreateOrUpdate_594189, schemes: {Scheme.Https})
type
  Call_CustomApisGet_594176 = ref object of OpenApiRestCall_593408
proc url_CustomApisGet_594178(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "apiName" in path, "`apiName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/customApis/"),
               (kind: VariableSegment, value: "apiName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomApisGet_594177(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a custom API by name for a specific subscription and resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group
  ##   apiName: JString (required)
  ##          : API name
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594179 = path.getOrDefault("resourceGroupName")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "resourceGroupName", valid_594179
  var valid_594180 = path.getOrDefault("apiName")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "apiName", valid_594180
  var valid_594181 = path.getOrDefault("subscriptionId")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "subscriptionId", valid_594181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594182 = query.getOrDefault("api-version")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "api-version", valid_594182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594183: Call_CustomApisGet_594176; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a custom API by name for a specific subscription and resource group
  ## 
  let valid = call_594183.validator(path, query, header, formData, body)
  let scheme = call_594183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594183.url(scheme.get, call_594183.host, call_594183.base,
                         call_594183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594183, url, valid)

proc call*(call_594184: Call_CustomApisGet_594176; resourceGroupName: string;
          apiVersion: string; apiName: string; subscriptionId: string): Recallable =
  ## customApisGet
  ## Gets a custom API by name for a specific subscription and resource group
  ##   resourceGroupName: string (required)
  ##                    : The resource group
  ##   apiVersion: string (required)
  ##             : API Version
  ##   apiName: string (required)
  ##          : API name
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  var path_594185 = newJObject()
  var query_594186 = newJObject()
  add(path_594185, "resourceGroupName", newJString(resourceGroupName))
  add(query_594186, "api-version", newJString(apiVersion))
  add(path_594185, "apiName", newJString(apiName))
  add(path_594185, "subscriptionId", newJString(subscriptionId))
  result = call_594184.call(path_594185, query_594186, nil, nil, nil)

var customApisGet* = Call_CustomApisGet_594176(name: "customApisGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/customApis/{apiName}",
    validator: validate_CustomApisGet_594177, base: "", url: url_CustomApisGet_594178,
    schemes: {Scheme.Https})
type
  Call_CustomApisUpdate_594211 = ref object of OpenApiRestCall_593408
proc url_CustomApisUpdate_594213(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "apiName" in path, "`apiName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/customApis/"),
               (kind: VariableSegment, value: "apiName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomApisUpdate_594212(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates an existing custom API's tags
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group
  ##   apiName: JString (required)
  ##          : API name
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594214 = path.getOrDefault("resourceGroupName")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "resourceGroupName", valid_594214
  var valid_594215 = path.getOrDefault("apiName")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "apiName", valid_594215
  var valid_594216 = path.getOrDefault("subscriptionId")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "subscriptionId", valid_594216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594217 = query.getOrDefault("api-version")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "api-version", valid_594217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customApi: JObject (required)
  ##            : The custom API
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594219: Call_CustomApisUpdate_594211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing custom API's tags
  ## 
  let valid = call_594219.validator(path, query, header, formData, body)
  let scheme = call_594219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594219.url(scheme.get, call_594219.host, call_594219.base,
                         call_594219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594219, url, valid)

proc call*(call_594220: Call_CustomApisUpdate_594211; resourceGroupName: string;
          apiVersion: string; apiName: string; subscriptionId: string;
          customApi: JsonNode): Recallable =
  ## customApisUpdate
  ## Updates an existing custom API's tags
  ##   resourceGroupName: string (required)
  ##                    : The resource group
  ##   apiVersion: string (required)
  ##             : API Version
  ##   apiName: string (required)
  ##          : API name
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   customApi: JObject (required)
  ##            : The custom API
  var path_594221 = newJObject()
  var query_594222 = newJObject()
  var body_594223 = newJObject()
  add(path_594221, "resourceGroupName", newJString(resourceGroupName))
  add(query_594222, "api-version", newJString(apiVersion))
  add(path_594221, "apiName", newJString(apiName))
  add(path_594221, "subscriptionId", newJString(subscriptionId))
  if customApi != nil:
    body_594223 = customApi
  result = call_594220.call(path_594221, query_594222, nil, nil, body_594223)

var customApisUpdate* = Call_CustomApisUpdate_594211(name: "customApisUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/customApis/{apiName}",
    validator: validate_CustomApisUpdate_594212, base: "",
    url: url_CustomApisUpdate_594213, schemes: {Scheme.Https})
type
  Call_CustomApisDelete_594200 = ref object of OpenApiRestCall_593408
proc url_CustomApisDelete_594202(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "apiName" in path, "`apiName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/customApis/"),
               (kind: VariableSegment, value: "apiName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomApisDelete_594201(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a custom API from the resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group
  ##   apiName: JString (required)
  ##          : API name
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594203 = path.getOrDefault("resourceGroupName")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "resourceGroupName", valid_594203
  var valid_594204 = path.getOrDefault("apiName")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "apiName", valid_594204
  var valid_594205 = path.getOrDefault("subscriptionId")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "subscriptionId", valid_594205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594206 = query.getOrDefault("api-version")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "api-version", valid_594206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594207: Call_CustomApisDelete_594200; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a custom API from the resource group
  ## 
  let valid = call_594207.validator(path, query, header, formData, body)
  let scheme = call_594207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594207.url(scheme.get, call_594207.host, call_594207.base,
                         call_594207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594207, url, valid)

proc call*(call_594208: Call_CustomApisDelete_594200; resourceGroupName: string;
          apiVersion: string; apiName: string; subscriptionId: string): Recallable =
  ## customApisDelete
  ## Deletes a custom API from the resource group
  ##   resourceGroupName: string (required)
  ##                    : The resource group
  ##   apiVersion: string (required)
  ##             : API Version
  ##   apiName: string (required)
  ##          : API name
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  var path_594209 = newJObject()
  var query_594210 = newJObject()
  add(path_594209, "resourceGroupName", newJString(resourceGroupName))
  add(query_594210, "api-version", newJString(apiVersion))
  add(path_594209, "apiName", newJString(apiName))
  add(path_594209, "subscriptionId", newJString(subscriptionId))
  result = call_594208.call(path_594209, query_594210, nil, nil, nil)

var customApisDelete* = Call_CustomApisDelete_594200(name: "customApisDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/customApis/{apiName}",
    validator: validate_CustomApisDelete_594201, base: "",
    url: url_CustomApisDelete_594202, schemes: {Scheme.Https})
type
  Call_CustomApisMove_594224 = ref object of OpenApiRestCall_593408
proc url_CustomApisMove_594226(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "apiName" in path, "`apiName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/customApis/"),
               (kind: VariableSegment, value: "apiName"),
               (kind: ConstantSegment, value: "/move")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomApisMove_594225(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Moves a specific custom API
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group
  ##   apiName: JString (required)
  ##          : API name
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594227 = path.getOrDefault("resourceGroupName")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "resourceGroupName", valid_594227
  var valid_594228 = path.getOrDefault("apiName")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "apiName", valid_594228
  var valid_594229 = path.getOrDefault("subscriptionId")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "subscriptionId", valid_594229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594230 = query.getOrDefault("api-version")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "api-version", valid_594230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customApiReference: JObject (required)
  ##                     : The custom API reference
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594232: Call_CustomApisMove_594224; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves a specific custom API
  ## 
  let valid = call_594232.validator(path, query, header, formData, body)
  let scheme = call_594232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594232.url(scheme.get, call_594232.host, call_594232.base,
                         call_594232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594232, url, valid)

proc call*(call_594233: Call_CustomApisMove_594224; resourceGroupName: string;
          apiVersion: string; apiName: string; subscriptionId: string;
          customApiReference: JsonNode): Recallable =
  ## customApisMove
  ## Moves a specific custom API
  ##   resourceGroupName: string (required)
  ##                    : The resource group
  ##   apiVersion: string (required)
  ##             : API Version
  ##   apiName: string (required)
  ##          : API name
  ##   subscriptionId: string (required)
  ##                 : Subscription Id
  ##   customApiReference: JObject (required)
  ##                     : The custom API reference
  var path_594234 = newJObject()
  var query_594235 = newJObject()
  var body_594236 = newJObject()
  add(path_594234, "resourceGroupName", newJString(resourceGroupName))
  add(query_594235, "api-version", newJString(apiVersion))
  add(path_594234, "apiName", newJString(apiName))
  add(path_594234, "subscriptionId", newJString(subscriptionId))
  if customApiReference != nil:
    body_594236 = customApiReference
  result = call_594233.call(path_594234, query_594235, nil, nil, body_594236)

var customApisMove* = Call_CustomApisMove_594224(name: "customApisMove",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/customApis/{apiName}/move",
    validator: validate_CustomApisMove_594225, base: "", url: url_CustomApisMove_594226,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
