
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2019-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Microsoft Azure Network management API provides a RESTful set of web services that interact with Microsoft Azure Networks service to manage your network resources. The API has entities that capture the relationship between an end user and the Microsoft Azure Networks service.
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
  macServiceName = "network-applicationGateway"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ApplicationGatewaysListAvailableRequestHeaders_567888 = ref object of OpenApiRestCall_567666
proc url_ApplicationGatewaysListAvailableRequestHeaders_567890(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/applicationGatewayAvailableRequestHeaders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysListAvailableRequestHeaders_567889(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all available request headers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568050 = path.getOrDefault("subscriptionId")
  valid_568050 = validateParameter(valid_568050, JString, required = true,
                                 default = nil)
  if valid_568050 != nil:
    section.add "subscriptionId", valid_568050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568051 = query.getOrDefault("api-version")
  valid_568051 = validateParameter(valid_568051, JString, required = true,
                                 default = nil)
  if valid_568051 != nil:
    section.add "api-version", valid_568051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568078: Call_ApplicationGatewaysListAvailableRequestHeaders_567888;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available request headers.
  ## 
  let valid = call_568078.validator(path, query, header, formData, body)
  let scheme = call_568078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568078.url(scheme.get, call_568078.host, call_568078.base,
                         call_568078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568078, url, valid)

proc call*(call_568149: Call_ApplicationGatewaysListAvailableRequestHeaders_567888;
          apiVersion: string; subscriptionId: string): Recallable =
  ## applicationGatewaysListAvailableRequestHeaders
  ## Lists all available request headers.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568150 = newJObject()
  var query_568152 = newJObject()
  add(query_568152, "api-version", newJString(apiVersion))
  add(path_568150, "subscriptionId", newJString(subscriptionId))
  result = call_568149.call(path_568150, query_568152, nil, nil, nil)

var applicationGatewaysListAvailableRequestHeaders* = Call_ApplicationGatewaysListAvailableRequestHeaders_567888(
    name: "applicationGatewaysListAvailableRequestHeaders",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGatewayAvailableRequestHeaders",
    validator: validate_ApplicationGatewaysListAvailableRequestHeaders_567889,
    base: "", url: url_ApplicationGatewaysListAvailableRequestHeaders_567890,
    schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysListAvailableResponseHeaders_568191 = ref object of OpenApiRestCall_567666
proc url_ApplicationGatewaysListAvailableResponseHeaders_568193(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/applicationGatewayAvailableResponseHeaders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysListAvailableResponseHeaders_568192(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all available response headers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568194 = path.getOrDefault("subscriptionId")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "subscriptionId", valid_568194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568195 = query.getOrDefault("api-version")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "api-version", valid_568195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568196: Call_ApplicationGatewaysListAvailableResponseHeaders_568191;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available response headers.
  ## 
  let valid = call_568196.validator(path, query, header, formData, body)
  let scheme = call_568196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568196.url(scheme.get, call_568196.host, call_568196.base,
                         call_568196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568196, url, valid)

proc call*(call_568197: Call_ApplicationGatewaysListAvailableResponseHeaders_568191;
          apiVersion: string; subscriptionId: string): Recallable =
  ## applicationGatewaysListAvailableResponseHeaders
  ## Lists all available response headers.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568198 = newJObject()
  var query_568199 = newJObject()
  add(query_568199, "api-version", newJString(apiVersion))
  add(path_568198, "subscriptionId", newJString(subscriptionId))
  result = call_568197.call(path_568198, query_568199, nil, nil, nil)

var applicationGatewaysListAvailableResponseHeaders* = Call_ApplicationGatewaysListAvailableResponseHeaders_568191(
    name: "applicationGatewaysListAvailableResponseHeaders",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGatewayAvailableResponseHeaders",
    validator: validate_ApplicationGatewaysListAvailableResponseHeaders_568192,
    base: "", url: url_ApplicationGatewaysListAvailableResponseHeaders_568193,
    schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysListAvailableServerVariables_568200 = ref object of OpenApiRestCall_567666
proc url_ApplicationGatewaysListAvailableServerVariables_568202(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/applicationGatewayAvailableServerVariables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysListAvailableServerVariables_568201(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all available server variables.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568203 = path.getOrDefault("subscriptionId")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "subscriptionId", valid_568203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568204 = query.getOrDefault("api-version")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "api-version", valid_568204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568205: Call_ApplicationGatewaysListAvailableServerVariables_568200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available server variables.
  ## 
  let valid = call_568205.validator(path, query, header, formData, body)
  let scheme = call_568205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568205.url(scheme.get, call_568205.host, call_568205.base,
                         call_568205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568205, url, valid)

proc call*(call_568206: Call_ApplicationGatewaysListAvailableServerVariables_568200;
          apiVersion: string; subscriptionId: string): Recallable =
  ## applicationGatewaysListAvailableServerVariables
  ## Lists all available server variables.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568207 = newJObject()
  var query_568208 = newJObject()
  add(query_568208, "api-version", newJString(apiVersion))
  add(path_568207, "subscriptionId", newJString(subscriptionId))
  result = call_568206.call(path_568207, query_568208, nil, nil, nil)

var applicationGatewaysListAvailableServerVariables* = Call_ApplicationGatewaysListAvailableServerVariables_568200(
    name: "applicationGatewaysListAvailableServerVariables",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGatewayAvailableServerVariables",
    validator: validate_ApplicationGatewaysListAvailableServerVariables_568201,
    base: "", url: url_ApplicationGatewaysListAvailableServerVariables_568202,
    schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysListAvailableSslOptions_568209 = ref object of OpenApiRestCall_567666
proc url_ApplicationGatewaysListAvailableSslOptions_568211(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/applicationGatewayAvailableSslOptions/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysListAvailableSslOptions_568210(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists available Ssl options for configuring Ssl policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568212 = path.getOrDefault("subscriptionId")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "subscriptionId", valid_568212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568213 = query.getOrDefault("api-version")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "api-version", valid_568213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568214: Call_ApplicationGatewaysListAvailableSslOptions_568209;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists available Ssl options for configuring Ssl policy.
  ## 
  let valid = call_568214.validator(path, query, header, formData, body)
  let scheme = call_568214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568214.url(scheme.get, call_568214.host, call_568214.base,
                         call_568214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568214, url, valid)

proc call*(call_568215: Call_ApplicationGatewaysListAvailableSslOptions_568209;
          apiVersion: string; subscriptionId: string): Recallable =
  ## applicationGatewaysListAvailableSslOptions
  ## Lists available Ssl options for configuring Ssl policy.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568216 = newJObject()
  var query_568217 = newJObject()
  add(query_568217, "api-version", newJString(apiVersion))
  add(path_568216, "subscriptionId", newJString(subscriptionId))
  result = call_568215.call(path_568216, query_568217, nil, nil, nil)

var applicationGatewaysListAvailableSslOptions* = Call_ApplicationGatewaysListAvailableSslOptions_568209(
    name: "applicationGatewaysListAvailableSslOptions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGatewayAvailableSslOptions/default",
    validator: validate_ApplicationGatewaysListAvailableSslOptions_568210,
    base: "", url: url_ApplicationGatewaysListAvailableSslOptions_568211,
    schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysListAvailableSslPredefinedPolicies_568218 = ref object of OpenApiRestCall_567666
proc url_ApplicationGatewaysListAvailableSslPredefinedPolicies_568220(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/applicationGatewayAvailableSslOptions/default/predefinedPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysListAvailableSslPredefinedPolicies_568219(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all SSL predefined policies for configuring Ssl policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568221 = path.getOrDefault("subscriptionId")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "subscriptionId", valid_568221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568222 = query.getOrDefault("api-version")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "api-version", valid_568222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568223: Call_ApplicationGatewaysListAvailableSslPredefinedPolicies_568218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all SSL predefined policies for configuring Ssl policy.
  ## 
  let valid = call_568223.validator(path, query, header, formData, body)
  let scheme = call_568223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568223.url(scheme.get, call_568223.host, call_568223.base,
                         call_568223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568223, url, valid)

proc call*(call_568224: Call_ApplicationGatewaysListAvailableSslPredefinedPolicies_568218;
          apiVersion: string; subscriptionId: string): Recallable =
  ## applicationGatewaysListAvailableSslPredefinedPolicies
  ## Lists all SSL predefined policies for configuring Ssl policy.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568225 = newJObject()
  var query_568226 = newJObject()
  add(query_568226, "api-version", newJString(apiVersion))
  add(path_568225, "subscriptionId", newJString(subscriptionId))
  result = call_568224.call(path_568225, query_568226, nil, nil, nil)

var applicationGatewaysListAvailableSslPredefinedPolicies* = Call_ApplicationGatewaysListAvailableSslPredefinedPolicies_568218(
    name: "applicationGatewaysListAvailableSslPredefinedPolicies",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGatewayAvailableSslOptions/default/predefinedPolicies",
    validator: validate_ApplicationGatewaysListAvailableSslPredefinedPolicies_568219,
    base: "", url: url_ApplicationGatewaysListAvailableSslPredefinedPolicies_568220,
    schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysGetSslPredefinedPolicy_568227 = ref object of OpenApiRestCall_567666
proc url_ApplicationGatewaysGetSslPredefinedPolicy_568229(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "predefinedPolicyName" in path,
        "`predefinedPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/applicationGatewayAvailableSslOptions/default/predefinedPolicies/"),
               (kind: VariableSegment, value: "predefinedPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysGetSslPredefinedPolicy_568228(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets Ssl predefined policy with the specified policy name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   predefinedPolicyName: JString (required)
  ##                       : Name of Ssl predefined policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568230 = path.getOrDefault("subscriptionId")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "subscriptionId", valid_568230
  var valid_568231 = path.getOrDefault("predefinedPolicyName")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "predefinedPolicyName", valid_568231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568232 = query.getOrDefault("api-version")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "api-version", valid_568232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568233: Call_ApplicationGatewaysGetSslPredefinedPolicy_568227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets Ssl predefined policy with the specified policy name.
  ## 
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_ApplicationGatewaysGetSslPredefinedPolicy_568227;
          apiVersion: string; subscriptionId: string; predefinedPolicyName: string): Recallable =
  ## applicationGatewaysGetSslPredefinedPolicy
  ## Gets Ssl predefined policy with the specified policy name.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   predefinedPolicyName: string (required)
  ##                       : Name of Ssl predefined policy.
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  add(query_568236, "api-version", newJString(apiVersion))
  add(path_568235, "subscriptionId", newJString(subscriptionId))
  add(path_568235, "predefinedPolicyName", newJString(predefinedPolicyName))
  result = call_568234.call(path_568235, query_568236, nil, nil, nil)

var applicationGatewaysGetSslPredefinedPolicy* = Call_ApplicationGatewaysGetSslPredefinedPolicy_568227(
    name: "applicationGatewaysGetSslPredefinedPolicy", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGatewayAvailableSslOptions/default/predefinedPolicies/{predefinedPolicyName}",
    validator: validate_ApplicationGatewaysGetSslPredefinedPolicy_568228,
    base: "", url: url_ApplicationGatewaysGetSslPredefinedPolicy_568229,
    schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysListAvailableWafRuleSets_568237 = ref object of OpenApiRestCall_567666
proc url_ApplicationGatewaysListAvailableWafRuleSets_568239(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/applicationGatewayAvailableWafRuleSets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysListAvailableWafRuleSets_568238(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all available web application firewall rule sets.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568240 = path.getOrDefault("subscriptionId")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "subscriptionId", valid_568240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568241 = query.getOrDefault("api-version")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "api-version", valid_568241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568242: Call_ApplicationGatewaysListAvailableWafRuleSets_568237;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available web application firewall rule sets.
  ## 
  let valid = call_568242.validator(path, query, header, formData, body)
  let scheme = call_568242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568242.url(scheme.get, call_568242.host, call_568242.base,
                         call_568242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568242, url, valid)

proc call*(call_568243: Call_ApplicationGatewaysListAvailableWafRuleSets_568237;
          apiVersion: string; subscriptionId: string): Recallable =
  ## applicationGatewaysListAvailableWafRuleSets
  ## Lists all available web application firewall rule sets.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568244 = newJObject()
  var query_568245 = newJObject()
  add(query_568245, "api-version", newJString(apiVersion))
  add(path_568244, "subscriptionId", newJString(subscriptionId))
  result = call_568243.call(path_568244, query_568245, nil, nil, nil)

var applicationGatewaysListAvailableWafRuleSets* = Call_ApplicationGatewaysListAvailableWafRuleSets_568237(
    name: "applicationGatewaysListAvailableWafRuleSets", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGatewayAvailableWafRuleSets",
    validator: validate_ApplicationGatewaysListAvailableWafRuleSets_568238,
    base: "", url: url_ApplicationGatewaysListAvailableWafRuleSets_568239,
    schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysListAll_568246 = ref object of OpenApiRestCall_567666
proc url_ApplicationGatewaysListAll_568248(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Network/applicationGateways")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysListAll_568247(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the application gateways in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568249 = path.getOrDefault("subscriptionId")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "subscriptionId", valid_568249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568250 = query.getOrDefault("api-version")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "api-version", valid_568250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568251: Call_ApplicationGatewaysListAll_568246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the application gateways in a subscription.
  ## 
  let valid = call_568251.validator(path, query, header, formData, body)
  let scheme = call_568251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568251.url(scheme.get, call_568251.host, call_568251.base,
                         call_568251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568251, url, valid)

proc call*(call_568252: Call_ApplicationGatewaysListAll_568246; apiVersion: string;
          subscriptionId: string): Recallable =
  ## applicationGatewaysListAll
  ## Gets all the application gateways in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568253 = newJObject()
  var query_568254 = newJObject()
  add(query_568254, "api-version", newJString(apiVersion))
  add(path_568253, "subscriptionId", newJString(subscriptionId))
  result = call_568252.call(path_568253, query_568254, nil, nil, nil)

var applicationGatewaysListAll* = Call_ApplicationGatewaysListAll_568246(
    name: "applicationGatewaysListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGateways",
    validator: validate_ApplicationGatewaysListAll_568247, base: "",
    url: url_ApplicationGatewaysListAll_568248, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysList_568255 = ref object of OpenApiRestCall_567666
proc url_ApplicationGatewaysList_568257(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Network/applicationGateways")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysList_568256(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all application gateways in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568258 = path.getOrDefault("resourceGroupName")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "resourceGroupName", valid_568258
  var valid_568259 = path.getOrDefault("subscriptionId")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "subscriptionId", valid_568259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568260 = query.getOrDefault("api-version")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "api-version", valid_568260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568261: Call_ApplicationGatewaysList_568255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all application gateways in a resource group.
  ## 
  let valid = call_568261.validator(path, query, header, formData, body)
  let scheme = call_568261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568261.url(scheme.get, call_568261.host, call_568261.base,
                         call_568261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568261, url, valid)

proc call*(call_568262: Call_ApplicationGatewaysList_568255;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## applicationGatewaysList
  ## Lists all application gateways in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568263 = newJObject()
  var query_568264 = newJObject()
  add(path_568263, "resourceGroupName", newJString(resourceGroupName))
  add(query_568264, "api-version", newJString(apiVersion))
  add(path_568263, "subscriptionId", newJString(subscriptionId))
  result = call_568262.call(path_568263, query_568264, nil, nil, nil)

var applicationGatewaysList* = Call_ApplicationGatewaysList_568255(
    name: "applicationGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways",
    validator: validate_ApplicationGatewaysList_568256, base: "",
    url: url_ApplicationGatewaysList_568257, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysCreateOrUpdate_568276 = ref object of OpenApiRestCall_567666
proc url_ApplicationGatewaysCreateOrUpdate_568278(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationGatewayName" in path,
        "`applicationGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/applicationGateways/"),
               (kind: VariableSegment, value: "applicationGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysCreateOrUpdate_568277(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the specified application gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: JString (required)
  ##                         : The name of the application gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568305 = path.getOrDefault("resourceGroupName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "resourceGroupName", valid_568305
  var valid_568306 = path.getOrDefault("subscriptionId")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "subscriptionId", valid_568306
  var valid_568307 = path.getOrDefault("applicationGatewayName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "applicationGatewayName", valid_568307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568308 = query.getOrDefault("api-version")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "api-version", valid_568308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update application gateway operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568310: Call_ApplicationGatewaysCreateOrUpdate_568276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the specified application gateway.
  ## 
  let valid = call_568310.validator(path, query, header, formData, body)
  let scheme = call_568310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568310.url(scheme.get, call_568310.host, call_568310.base,
                         call_568310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568310, url, valid)

proc call*(call_568311: Call_ApplicationGatewaysCreateOrUpdate_568276;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; applicationGatewayName: string): Recallable =
  ## applicationGatewaysCreateOrUpdate
  ## Creates or updates the specified application gateway.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update application gateway operation.
  ##   applicationGatewayName: string (required)
  ##                         : The name of the application gateway.
  var path_568312 = newJObject()
  var query_568313 = newJObject()
  var body_568314 = newJObject()
  add(path_568312, "resourceGroupName", newJString(resourceGroupName))
  add(query_568313, "api-version", newJString(apiVersion))
  add(path_568312, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568314 = parameters
  add(path_568312, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_568311.call(path_568312, query_568313, nil, nil, body_568314)

var applicationGatewaysCreateOrUpdate* = Call_ApplicationGatewaysCreateOrUpdate_568276(
    name: "applicationGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysCreateOrUpdate_568277, base: "",
    url: url_ApplicationGatewaysCreateOrUpdate_568278, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysGet_568265 = ref object of OpenApiRestCall_567666
proc url_ApplicationGatewaysGet_568267(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationGatewayName" in path,
        "`applicationGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/applicationGateways/"),
               (kind: VariableSegment, value: "applicationGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysGet_568266(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified application gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: JString (required)
  ##                         : The name of the application gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568268 = path.getOrDefault("resourceGroupName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "resourceGroupName", valid_568268
  var valid_568269 = path.getOrDefault("subscriptionId")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "subscriptionId", valid_568269
  var valid_568270 = path.getOrDefault("applicationGatewayName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "applicationGatewayName", valid_568270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568271 = query.getOrDefault("api-version")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "api-version", valid_568271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568272: Call_ApplicationGatewaysGet_568265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified application gateway.
  ## 
  let valid = call_568272.validator(path, query, header, formData, body)
  let scheme = call_568272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568272.url(scheme.get, call_568272.host, call_568272.base,
                         call_568272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568272, url, valid)

proc call*(call_568273: Call_ApplicationGatewaysGet_568265;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          applicationGatewayName: string): Recallable =
  ## applicationGatewaysGet
  ## Gets the specified application gateway.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: string (required)
  ##                         : The name of the application gateway.
  var path_568274 = newJObject()
  var query_568275 = newJObject()
  add(path_568274, "resourceGroupName", newJString(resourceGroupName))
  add(query_568275, "api-version", newJString(apiVersion))
  add(path_568274, "subscriptionId", newJString(subscriptionId))
  add(path_568274, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_568273.call(path_568274, query_568275, nil, nil, nil)

var applicationGatewaysGet* = Call_ApplicationGatewaysGet_568265(
    name: "applicationGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysGet_568266, base: "",
    url: url_ApplicationGatewaysGet_568267, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysUpdateTags_568326 = ref object of OpenApiRestCall_567666
proc url_ApplicationGatewaysUpdateTags_568328(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationGatewayName" in path,
        "`applicationGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/applicationGateways/"),
               (kind: VariableSegment, value: "applicationGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysUpdateTags_568327(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified application gateway tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: JString (required)
  ##                         : The name of the application gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568329 = path.getOrDefault("resourceGroupName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "resourceGroupName", valid_568329
  var valid_568330 = path.getOrDefault("subscriptionId")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "subscriptionId", valid_568330
  var valid_568331 = path.getOrDefault("applicationGatewayName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "applicationGatewayName", valid_568331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568332 = query.getOrDefault("api-version")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "api-version", valid_568332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update application gateway tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568334: Call_ApplicationGatewaysUpdateTags_568326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified application gateway tags.
  ## 
  let valid = call_568334.validator(path, query, header, formData, body)
  let scheme = call_568334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568334.url(scheme.get, call_568334.host, call_568334.base,
                         call_568334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568334, url, valid)

proc call*(call_568335: Call_ApplicationGatewaysUpdateTags_568326;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; applicationGatewayName: string): Recallable =
  ## applicationGatewaysUpdateTags
  ## Updates the specified application gateway tags.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update application gateway tags.
  ##   applicationGatewayName: string (required)
  ##                         : The name of the application gateway.
  var path_568336 = newJObject()
  var query_568337 = newJObject()
  var body_568338 = newJObject()
  add(path_568336, "resourceGroupName", newJString(resourceGroupName))
  add(query_568337, "api-version", newJString(apiVersion))
  add(path_568336, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568338 = parameters
  add(path_568336, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_568335.call(path_568336, query_568337, nil, nil, body_568338)

var applicationGatewaysUpdateTags* = Call_ApplicationGatewaysUpdateTags_568326(
    name: "applicationGatewaysUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysUpdateTags_568327, base: "",
    url: url_ApplicationGatewaysUpdateTags_568328, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysDelete_568315 = ref object of OpenApiRestCall_567666
proc url_ApplicationGatewaysDelete_568317(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationGatewayName" in path,
        "`applicationGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/applicationGateways/"),
               (kind: VariableSegment, value: "applicationGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysDelete_568316(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified application gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: JString (required)
  ##                         : The name of the application gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568318 = path.getOrDefault("resourceGroupName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "resourceGroupName", valid_568318
  var valid_568319 = path.getOrDefault("subscriptionId")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "subscriptionId", valid_568319
  var valid_568320 = path.getOrDefault("applicationGatewayName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "applicationGatewayName", valid_568320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568321 = query.getOrDefault("api-version")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "api-version", valid_568321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568322: Call_ApplicationGatewaysDelete_568315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified application gateway.
  ## 
  let valid = call_568322.validator(path, query, header, formData, body)
  let scheme = call_568322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568322.url(scheme.get, call_568322.host, call_568322.base,
                         call_568322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568322, url, valid)

proc call*(call_568323: Call_ApplicationGatewaysDelete_568315;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          applicationGatewayName: string): Recallable =
  ## applicationGatewaysDelete
  ## Deletes the specified application gateway.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: string (required)
  ##                         : The name of the application gateway.
  var path_568324 = newJObject()
  var query_568325 = newJObject()
  add(path_568324, "resourceGroupName", newJString(resourceGroupName))
  add(query_568325, "api-version", newJString(apiVersion))
  add(path_568324, "subscriptionId", newJString(subscriptionId))
  add(path_568324, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_568323.call(path_568324, query_568325, nil, nil, nil)

var applicationGatewaysDelete* = Call_ApplicationGatewaysDelete_568315(
    name: "applicationGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysDelete_568316, base: "",
    url: url_ApplicationGatewaysDelete_568317, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysBackendHealth_568339 = ref object of OpenApiRestCall_567666
proc url_ApplicationGatewaysBackendHealth_568341(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationGatewayName" in path,
        "`applicationGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/applicationGateways/"),
               (kind: VariableSegment, value: "applicationGatewayName"),
               (kind: ConstantSegment, value: "/backendhealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysBackendHealth_568340(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the backend health of the specified application gateway in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: JString (required)
  ##                         : The name of the application gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568343 = path.getOrDefault("resourceGroupName")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "resourceGroupName", valid_568343
  var valid_568344 = path.getOrDefault("subscriptionId")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "subscriptionId", valid_568344
  var valid_568345 = path.getOrDefault("applicationGatewayName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "applicationGatewayName", valid_568345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands BackendAddressPool and BackendHttpSettings referenced in backend health.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568346 = query.getOrDefault("api-version")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "api-version", valid_568346
  var valid_568347 = query.getOrDefault("$expand")
  valid_568347 = validateParameter(valid_568347, JString, required = false,
                                 default = nil)
  if valid_568347 != nil:
    section.add "$expand", valid_568347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568348: Call_ApplicationGatewaysBackendHealth_568339;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the backend health of the specified application gateway in a resource group.
  ## 
  let valid = call_568348.validator(path, query, header, formData, body)
  let scheme = call_568348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568348.url(scheme.get, call_568348.host, call_568348.base,
                         call_568348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568348, url, valid)

proc call*(call_568349: Call_ApplicationGatewaysBackendHealth_568339;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          applicationGatewayName: string; Expand: string = ""): Recallable =
  ## applicationGatewaysBackendHealth
  ## Gets the backend health of the specified application gateway in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Expands BackendAddressPool and BackendHttpSettings referenced in backend health.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: string (required)
  ##                         : The name of the application gateway.
  var path_568350 = newJObject()
  var query_568351 = newJObject()
  add(path_568350, "resourceGroupName", newJString(resourceGroupName))
  add(query_568351, "api-version", newJString(apiVersion))
  add(query_568351, "$expand", newJString(Expand))
  add(path_568350, "subscriptionId", newJString(subscriptionId))
  add(path_568350, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_568349.call(path_568350, query_568351, nil, nil, nil)

var applicationGatewaysBackendHealth* = Call_ApplicationGatewaysBackendHealth_568339(
    name: "applicationGatewaysBackendHealth", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}/backendhealth",
    validator: validate_ApplicationGatewaysBackendHealth_568340, base: "",
    url: url_ApplicationGatewaysBackendHealth_568341, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysBackendHealthOnDemand_568352 = ref object of OpenApiRestCall_567666
proc url_ApplicationGatewaysBackendHealthOnDemand_568354(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationGatewayName" in path,
        "`applicationGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/applicationGateways/"),
               (kind: VariableSegment, value: "applicationGatewayName"),
               (kind: ConstantSegment, value: "/getBackendHealthOnDemand")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysBackendHealthOnDemand_568353(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the backend health for given combination of backend pool and http setting of the specified application gateway in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: JString (required)
  ##                         : The name of the application gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568355 = path.getOrDefault("resourceGroupName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "resourceGroupName", valid_568355
  var valid_568356 = path.getOrDefault("subscriptionId")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "subscriptionId", valid_568356
  var valid_568357 = path.getOrDefault("applicationGatewayName")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "applicationGatewayName", valid_568357
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands BackendAddressPool and BackendHttpSettings referenced in backend health.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568358 = query.getOrDefault("api-version")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "api-version", valid_568358
  var valid_568359 = query.getOrDefault("$expand")
  valid_568359 = validateParameter(valid_568359, JString, required = false,
                                 default = nil)
  if valid_568359 != nil:
    section.add "$expand", valid_568359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   probeRequest: JObject (required)
  ##               : Request body for on-demand test probe operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568361: Call_ApplicationGatewaysBackendHealthOnDemand_568352;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the backend health for given combination of backend pool and http setting of the specified application gateway in a resource group.
  ## 
  let valid = call_568361.validator(path, query, header, formData, body)
  let scheme = call_568361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568361.url(scheme.get, call_568361.host, call_568361.base,
                         call_568361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568361, url, valid)

proc call*(call_568362: Call_ApplicationGatewaysBackendHealthOnDemand_568352;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          probeRequest: JsonNode; applicationGatewayName: string;
          Expand: string = ""): Recallable =
  ## applicationGatewaysBackendHealthOnDemand
  ## Gets the backend health for given combination of backend pool and http setting of the specified application gateway in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Expands BackendAddressPool and BackendHttpSettings referenced in backend health.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   probeRequest: JObject (required)
  ##               : Request body for on-demand test probe operation.
  ##   applicationGatewayName: string (required)
  ##                         : The name of the application gateway.
  var path_568363 = newJObject()
  var query_568364 = newJObject()
  var body_568365 = newJObject()
  add(path_568363, "resourceGroupName", newJString(resourceGroupName))
  add(query_568364, "api-version", newJString(apiVersion))
  add(query_568364, "$expand", newJString(Expand))
  add(path_568363, "subscriptionId", newJString(subscriptionId))
  if probeRequest != nil:
    body_568365 = probeRequest
  add(path_568363, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_568362.call(path_568363, query_568364, nil, nil, body_568365)

var applicationGatewaysBackendHealthOnDemand* = Call_ApplicationGatewaysBackendHealthOnDemand_568352(
    name: "applicationGatewaysBackendHealthOnDemand", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}/getBackendHealthOnDemand",
    validator: validate_ApplicationGatewaysBackendHealthOnDemand_568353, base: "",
    url: url_ApplicationGatewaysBackendHealthOnDemand_568354,
    schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysStart_568366 = ref object of OpenApiRestCall_567666
proc url_ApplicationGatewaysStart_568368(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationGatewayName" in path,
        "`applicationGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/applicationGateways/"),
               (kind: VariableSegment, value: "applicationGatewayName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysStart_568367(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts the specified application gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: JString (required)
  ##                         : The name of the application gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568369 = path.getOrDefault("resourceGroupName")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "resourceGroupName", valid_568369
  var valid_568370 = path.getOrDefault("subscriptionId")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "subscriptionId", valid_568370
  var valid_568371 = path.getOrDefault("applicationGatewayName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "applicationGatewayName", valid_568371
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568372 = query.getOrDefault("api-version")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "api-version", valid_568372
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568373: Call_ApplicationGatewaysStart_568366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts the specified application gateway.
  ## 
  let valid = call_568373.validator(path, query, header, formData, body)
  let scheme = call_568373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568373.url(scheme.get, call_568373.host, call_568373.base,
                         call_568373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568373, url, valid)

proc call*(call_568374: Call_ApplicationGatewaysStart_568366;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          applicationGatewayName: string): Recallable =
  ## applicationGatewaysStart
  ## Starts the specified application gateway.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: string (required)
  ##                         : The name of the application gateway.
  var path_568375 = newJObject()
  var query_568376 = newJObject()
  add(path_568375, "resourceGroupName", newJString(resourceGroupName))
  add(query_568376, "api-version", newJString(apiVersion))
  add(path_568375, "subscriptionId", newJString(subscriptionId))
  add(path_568375, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_568374.call(path_568375, query_568376, nil, nil, nil)

var applicationGatewaysStart* = Call_ApplicationGatewaysStart_568366(
    name: "applicationGatewaysStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}/start",
    validator: validate_ApplicationGatewaysStart_568367, base: "",
    url: url_ApplicationGatewaysStart_568368, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysStop_568377 = ref object of OpenApiRestCall_567666
proc url_ApplicationGatewaysStop_568379(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationGatewayName" in path,
        "`applicationGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/applicationGateways/"),
               (kind: VariableSegment, value: "applicationGatewayName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysStop_568378(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops the specified application gateway in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: JString (required)
  ##                         : The name of the application gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568380 = path.getOrDefault("resourceGroupName")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "resourceGroupName", valid_568380
  var valid_568381 = path.getOrDefault("subscriptionId")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "subscriptionId", valid_568381
  var valid_568382 = path.getOrDefault("applicationGatewayName")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "applicationGatewayName", valid_568382
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568383 = query.getOrDefault("api-version")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "api-version", valid_568383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568384: Call_ApplicationGatewaysStop_568377; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops the specified application gateway in a resource group.
  ## 
  let valid = call_568384.validator(path, query, header, formData, body)
  let scheme = call_568384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568384.url(scheme.get, call_568384.host, call_568384.base,
                         call_568384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568384, url, valid)

proc call*(call_568385: Call_ApplicationGatewaysStop_568377;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          applicationGatewayName: string): Recallable =
  ## applicationGatewaysStop
  ## Stops the specified application gateway in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: string (required)
  ##                         : The name of the application gateway.
  var path_568386 = newJObject()
  var query_568387 = newJObject()
  add(path_568386, "resourceGroupName", newJString(resourceGroupName))
  add(query_568387, "api-version", newJString(apiVersion))
  add(path_568386, "subscriptionId", newJString(subscriptionId))
  add(path_568386, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_568385.call(path_568386, query_568387, nil, nil, nil)

var applicationGatewaysStop* = Call_ApplicationGatewaysStop_568377(
    name: "applicationGatewaysStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}/stop",
    validator: validate_ApplicationGatewaysStop_568378, base: "",
    url: url_ApplicationGatewaysStop_568379, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
