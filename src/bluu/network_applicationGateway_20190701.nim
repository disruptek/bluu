
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2019-07-01
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
  macServiceName = "network-applicationGateway"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ApplicationGatewaysListAvailableRequestHeaders_573888 = ref object of OpenApiRestCall_573666
proc url_ApplicationGatewaysListAvailableRequestHeaders_573890(protocol: Scheme;
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

proc validate_ApplicationGatewaysListAvailableRequestHeaders_573889(
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
  var valid_574050 = path.getOrDefault("subscriptionId")
  valid_574050 = validateParameter(valid_574050, JString, required = true,
                                 default = nil)
  if valid_574050 != nil:
    section.add "subscriptionId", valid_574050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574051 = query.getOrDefault("api-version")
  valid_574051 = validateParameter(valid_574051, JString, required = true,
                                 default = nil)
  if valid_574051 != nil:
    section.add "api-version", valid_574051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574078: Call_ApplicationGatewaysListAvailableRequestHeaders_573888;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available request headers.
  ## 
  let valid = call_574078.validator(path, query, header, formData, body)
  let scheme = call_574078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574078.url(scheme.get, call_574078.host, call_574078.base,
                         call_574078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574078, url, valid)

proc call*(call_574149: Call_ApplicationGatewaysListAvailableRequestHeaders_573888;
          apiVersion: string; subscriptionId: string): Recallable =
  ## applicationGatewaysListAvailableRequestHeaders
  ## Lists all available request headers.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574150 = newJObject()
  var query_574152 = newJObject()
  add(query_574152, "api-version", newJString(apiVersion))
  add(path_574150, "subscriptionId", newJString(subscriptionId))
  result = call_574149.call(path_574150, query_574152, nil, nil, nil)

var applicationGatewaysListAvailableRequestHeaders* = Call_ApplicationGatewaysListAvailableRequestHeaders_573888(
    name: "applicationGatewaysListAvailableRequestHeaders",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGatewayAvailableRequestHeaders",
    validator: validate_ApplicationGatewaysListAvailableRequestHeaders_573889,
    base: "", url: url_ApplicationGatewaysListAvailableRequestHeaders_573890,
    schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysListAvailableResponseHeaders_574191 = ref object of OpenApiRestCall_573666
proc url_ApplicationGatewaysListAvailableResponseHeaders_574193(protocol: Scheme;
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

proc validate_ApplicationGatewaysListAvailableResponseHeaders_574192(
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
  var valid_574194 = path.getOrDefault("subscriptionId")
  valid_574194 = validateParameter(valid_574194, JString, required = true,
                                 default = nil)
  if valid_574194 != nil:
    section.add "subscriptionId", valid_574194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574195 = query.getOrDefault("api-version")
  valid_574195 = validateParameter(valid_574195, JString, required = true,
                                 default = nil)
  if valid_574195 != nil:
    section.add "api-version", valid_574195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574196: Call_ApplicationGatewaysListAvailableResponseHeaders_574191;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available response headers.
  ## 
  let valid = call_574196.validator(path, query, header, formData, body)
  let scheme = call_574196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574196.url(scheme.get, call_574196.host, call_574196.base,
                         call_574196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574196, url, valid)

proc call*(call_574197: Call_ApplicationGatewaysListAvailableResponseHeaders_574191;
          apiVersion: string; subscriptionId: string): Recallable =
  ## applicationGatewaysListAvailableResponseHeaders
  ## Lists all available response headers.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574198 = newJObject()
  var query_574199 = newJObject()
  add(query_574199, "api-version", newJString(apiVersion))
  add(path_574198, "subscriptionId", newJString(subscriptionId))
  result = call_574197.call(path_574198, query_574199, nil, nil, nil)

var applicationGatewaysListAvailableResponseHeaders* = Call_ApplicationGatewaysListAvailableResponseHeaders_574191(
    name: "applicationGatewaysListAvailableResponseHeaders",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGatewayAvailableResponseHeaders",
    validator: validate_ApplicationGatewaysListAvailableResponseHeaders_574192,
    base: "", url: url_ApplicationGatewaysListAvailableResponseHeaders_574193,
    schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysListAvailableServerVariables_574200 = ref object of OpenApiRestCall_573666
proc url_ApplicationGatewaysListAvailableServerVariables_574202(protocol: Scheme;
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

proc validate_ApplicationGatewaysListAvailableServerVariables_574201(
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
  var valid_574203 = path.getOrDefault("subscriptionId")
  valid_574203 = validateParameter(valid_574203, JString, required = true,
                                 default = nil)
  if valid_574203 != nil:
    section.add "subscriptionId", valid_574203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574204 = query.getOrDefault("api-version")
  valid_574204 = validateParameter(valid_574204, JString, required = true,
                                 default = nil)
  if valid_574204 != nil:
    section.add "api-version", valid_574204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574205: Call_ApplicationGatewaysListAvailableServerVariables_574200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available server variables.
  ## 
  let valid = call_574205.validator(path, query, header, formData, body)
  let scheme = call_574205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574205.url(scheme.get, call_574205.host, call_574205.base,
                         call_574205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574205, url, valid)

proc call*(call_574206: Call_ApplicationGatewaysListAvailableServerVariables_574200;
          apiVersion: string; subscriptionId: string): Recallable =
  ## applicationGatewaysListAvailableServerVariables
  ## Lists all available server variables.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574207 = newJObject()
  var query_574208 = newJObject()
  add(query_574208, "api-version", newJString(apiVersion))
  add(path_574207, "subscriptionId", newJString(subscriptionId))
  result = call_574206.call(path_574207, query_574208, nil, nil, nil)

var applicationGatewaysListAvailableServerVariables* = Call_ApplicationGatewaysListAvailableServerVariables_574200(
    name: "applicationGatewaysListAvailableServerVariables",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGatewayAvailableServerVariables",
    validator: validate_ApplicationGatewaysListAvailableServerVariables_574201,
    base: "", url: url_ApplicationGatewaysListAvailableServerVariables_574202,
    schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysListAvailableSslOptions_574209 = ref object of OpenApiRestCall_573666
proc url_ApplicationGatewaysListAvailableSslOptions_574211(protocol: Scheme;
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

proc validate_ApplicationGatewaysListAvailableSslOptions_574210(path: JsonNode;
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
  var valid_574212 = path.getOrDefault("subscriptionId")
  valid_574212 = validateParameter(valid_574212, JString, required = true,
                                 default = nil)
  if valid_574212 != nil:
    section.add "subscriptionId", valid_574212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574213 = query.getOrDefault("api-version")
  valid_574213 = validateParameter(valid_574213, JString, required = true,
                                 default = nil)
  if valid_574213 != nil:
    section.add "api-version", valid_574213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574214: Call_ApplicationGatewaysListAvailableSslOptions_574209;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists available Ssl options for configuring Ssl policy.
  ## 
  let valid = call_574214.validator(path, query, header, formData, body)
  let scheme = call_574214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574214.url(scheme.get, call_574214.host, call_574214.base,
                         call_574214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574214, url, valid)

proc call*(call_574215: Call_ApplicationGatewaysListAvailableSslOptions_574209;
          apiVersion: string; subscriptionId: string): Recallable =
  ## applicationGatewaysListAvailableSslOptions
  ## Lists available Ssl options for configuring Ssl policy.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574216 = newJObject()
  var query_574217 = newJObject()
  add(query_574217, "api-version", newJString(apiVersion))
  add(path_574216, "subscriptionId", newJString(subscriptionId))
  result = call_574215.call(path_574216, query_574217, nil, nil, nil)

var applicationGatewaysListAvailableSslOptions* = Call_ApplicationGatewaysListAvailableSslOptions_574209(
    name: "applicationGatewaysListAvailableSslOptions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGatewayAvailableSslOptions/default",
    validator: validate_ApplicationGatewaysListAvailableSslOptions_574210,
    base: "", url: url_ApplicationGatewaysListAvailableSslOptions_574211,
    schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysListAvailableSslPredefinedPolicies_574218 = ref object of OpenApiRestCall_573666
proc url_ApplicationGatewaysListAvailableSslPredefinedPolicies_574220(
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

proc validate_ApplicationGatewaysListAvailableSslPredefinedPolicies_574219(
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
  var valid_574221 = path.getOrDefault("subscriptionId")
  valid_574221 = validateParameter(valid_574221, JString, required = true,
                                 default = nil)
  if valid_574221 != nil:
    section.add "subscriptionId", valid_574221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574222 = query.getOrDefault("api-version")
  valid_574222 = validateParameter(valid_574222, JString, required = true,
                                 default = nil)
  if valid_574222 != nil:
    section.add "api-version", valid_574222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574223: Call_ApplicationGatewaysListAvailableSslPredefinedPolicies_574218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all SSL predefined policies for configuring Ssl policy.
  ## 
  let valid = call_574223.validator(path, query, header, formData, body)
  let scheme = call_574223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574223.url(scheme.get, call_574223.host, call_574223.base,
                         call_574223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574223, url, valid)

proc call*(call_574224: Call_ApplicationGatewaysListAvailableSslPredefinedPolicies_574218;
          apiVersion: string; subscriptionId: string): Recallable =
  ## applicationGatewaysListAvailableSslPredefinedPolicies
  ## Lists all SSL predefined policies for configuring Ssl policy.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574225 = newJObject()
  var query_574226 = newJObject()
  add(query_574226, "api-version", newJString(apiVersion))
  add(path_574225, "subscriptionId", newJString(subscriptionId))
  result = call_574224.call(path_574225, query_574226, nil, nil, nil)

var applicationGatewaysListAvailableSslPredefinedPolicies* = Call_ApplicationGatewaysListAvailableSslPredefinedPolicies_574218(
    name: "applicationGatewaysListAvailableSslPredefinedPolicies",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGatewayAvailableSslOptions/default/predefinedPolicies",
    validator: validate_ApplicationGatewaysListAvailableSslPredefinedPolicies_574219,
    base: "", url: url_ApplicationGatewaysListAvailableSslPredefinedPolicies_574220,
    schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysGetSslPredefinedPolicy_574227 = ref object of OpenApiRestCall_573666
proc url_ApplicationGatewaysGetSslPredefinedPolicy_574229(protocol: Scheme;
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

proc validate_ApplicationGatewaysGetSslPredefinedPolicy_574228(path: JsonNode;
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
  var valid_574230 = path.getOrDefault("subscriptionId")
  valid_574230 = validateParameter(valid_574230, JString, required = true,
                                 default = nil)
  if valid_574230 != nil:
    section.add "subscriptionId", valid_574230
  var valid_574231 = path.getOrDefault("predefinedPolicyName")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "predefinedPolicyName", valid_574231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574232 = query.getOrDefault("api-version")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = nil)
  if valid_574232 != nil:
    section.add "api-version", valid_574232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574233: Call_ApplicationGatewaysGetSslPredefinedPolicy_574227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets Ssl predefined policy with the specified policy name.
  ## 
  let valid = call_574233.validator(path, query, header, formData, body)
  let scheme = call_574233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574233.url(scheme.get, call_574233.host, call_574233.base,
                         call_574233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574233, url, valid)

proc call*(call_574234: Call_ApplicationGatewaysGetSslPredefinedPolicy_574227;
          apiVersion: string; subscriptionId: string; predefinedPolicyName: string): Recallable =
  ## applicationGatewaysGetSslPredefinedPolicy
  ## Gets Ssl predefined policy with the specified policy name.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   predefinedPolicyName: string (required)
  ##                       : Name of Ssl predefined policy.
  var path_574235 = newJObject()
  var query_574236 = newJObject()
  add(query_574236, "api-version", newJString(apiVersion))
  add(path_574235, "subscriptionId", newJString(subscriptionId))
  add(path_574235, "predefinedPolicyName", newJString(predefinedPolicyName))
  result = call_574234.call(path_574235, query_574236, nil, nil, nil)

var applicationGatewaysGetSslPredefinedPolicy* = Call_ApplicationGatewaysGetSslPredefinedPolicy_574227(
    name: "applicationGatewaysGetSslPredefinedPolicy", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGatewayAvailableSslOptions/default/predefinedPolicies/{predefinedPolicyName}",
    validator: validate_ApplicationGatewaysGetSslPredefinedPolicy_574228,
    base: "", url: url_ApplicationGatewaysGetSslPredefinedPolicy_574229,
    schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysListAvailableWafRuleSets_574237 = ref object of OpenApiRestCall_573666
proc url_ApplicationGatewaysListAvailableWafRuleSets_574239(protocol: Scheme;
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

proc validate_ApplicationGatewaysListAvailableWafRuleSets_574238(path: JsonNode;
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
  var valid_574240 = path.getOrDefault("subscriptionId")
  valid_574240 = validateParameter(valid_574240, JString, required = true,
                                 default = nil)
  if valid_574240 != nil:
    section.add "subscriptionId", valid_574240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574241 = query.getOrDefault("api-version")
  valid_574241 = validateParameter(valid_574241, JString, required = true,
                                 default = nil)
  if valid_574241 != nil:
    section.add "api-version", valid_574241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574242: Call_ApplicationGatewaysListAvailableWafRuleSets_574237;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available web application firewall rule sets.
  ## 
  let valid = call_574242.validator(path, query, header, formData, body)
  let scheme = call_574242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574242.url(scheme.get, call_574242.host, call_574242.base,
                         call_574242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574242, url, valid)

proc call*(call_574243: Call_ApplicationGatewaysListAvailableWafRuleSets_574237;
          apiVersion: string; subscriptionId: string): Recallable =
  ## applicationGatewaysListAvailableWafRuleSets
  ## Lists all available web application firewall rule sets.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574244 = newJObject()
  var query_574245 = newJObject()
  add(query_574245, "api-version", newJString(apiVersion))
  add(path_574244, "subscriptionId", newJString(subscriptionId))
  result = call_574243.call(path_574244, query_574245, nil, nil, nil)

var applicationGatewaysListAvailableWafRuleSets* = Call_ApplicationGatewaysListAvailableWafRuleSets_574237(
    name: "applicationGatewaysListAvailableWafRuleSets", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGatewayAvailableWafRuleSets",
    validator: validate_ApplicationGatewaysListAvailableWafRuleSets_574238,
    base: "", url: url_ApplicationGatewaysListAvailableWafRuleSets_574239,
    schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysListAll_574246 = ref object of OpenApiRestCall_573666
proc url_ApplicationGatewaysListAll_574248(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysListAll_574247(path: JsonNode; query: JsonNode;
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
  var valid_574249 = path.getOrDefault("subscriptionId")
  valid_574249 = validateParameter(valid_574249, JString, required = true,
                                 default = nil)
  if valid_574249 != nil:
    section.add "subscriptionId", valid_574249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_574251: Call_ApplicationGatewaysListAll_574246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the application gateways in a subscription.
  ## 
  let valid = call_574251.validator(path, query, header, formData, body)
  let scheme = call_574251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574251.url(scheme.get, call_574251.host, call_574251.base,
                         call_574251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574251, url, valid)

proc call*(call_574252: Call_ApplicationGatewaysListAll_574246; apiVersion: string;
          subscriptionId: string): Recallable =
  ## applicationGatewaysListAll
  ## Gets all the application gateways in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574253 = newJObject()
  var query_574254 = newJObject()
  add(query_574254, "api-version", newJString(apiVersion))
  add(path_574253, "subscriptionId", newJString(subscriptionId))
  result = call_574252.call(path_574253, query_574254, nil, nil, nil)

var applicationGatewaysListAll* = Call_ApplicationGatewaysListAll_574246(
    name: "applicationGatewaysListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGateways",
    validator: validate_ApplicationGatewaysListAll_574247, base: "",
    url: url_ApplicationGatewaysListAll_574248, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysList_574255 = ref object of OpenApiRestCall_573666
proc url_ApplicationGatewaysList_574257(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGatewaysList_574256(path: JsonNode; query: JsonNode;
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574260 = query.getOrDefault("api-version")
  valid_574260 = validateParameter(valid_574260, JString, required = true,
                                 default = nil)
  if valid_574260 != nil:
    section.add "api-version", valid_574260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574261: Call_ApplicationGatewaysList_574255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all application gateways in a resource group.
  ## 
  let valid = call_574261.validator(path, query, header, formData, body)
  let scheme = call_574261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574261.url(scheme.get, call_574261.host, call_574261.base,
                         call_574261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574261, url, valid)

proc call*(call_574262: Call_ApplicationGatewaysList_574255;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## applicationGatewaysList
  ## Lists all application gateways in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574263 = newJObject()
  var query_574264 = newJObject()
  add(path_574263, "resourceGroupName", newJString(resourceGroupName))
  add(query_574264, "api-version", newJString(apiVersion))
  add(path_574263, "subscriptionId", newJString(subscriptionId))
  result = call_574262.call(path_574263, query_574264, nil, nil, nil)

var applicationGatewaysList* = Call_ApplicationGatewaysList_574255(
    name: "applicationGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways",
    validator: validate_ApplicationGatewaysList_574256, base: "",
    url: url_ApplicationGatewaysList_574257, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysCreateOrUpdate_574276 = ref object of OpenApiRestCall_573666
proc url_ApplicationGatewaysCreateOrUpdate_574278(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysCreateOrUpdate_574277(path: JsonNode;
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
  var valid_574305 = path.getOrDefault("resourceGroupName")
  valid_574305 = validateParameter(valid_574305, JString, required = true,
                                 default = nil)
  if valid_574305 != nil:
    section.add "resourceGroupName", valid_574305
  var valid_574306 = path.getOrDefault("subscriptionId")
  valid_574306 = validateParameter(valid_574306, JString, required = true,
                                 default = nil)
  if valid_574306 != nil:
    section.add "subscriptionId", valid_574306
  var valid_574307 = path.getOrDefault("applicationGatewayName")
  valid_574307 = validateParameter(valid_574307, JString, required = true,
                                 default = nil)
  if valid_574307 != nil:
    section.add "applicationGatewayName", valid_574307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574308 = query.getOrDefault("api-version")
  valid_574308 = validateParameter(valid_574308, JString, required = true,
                                 default = nil)
  if valid_574308 != nil:
    section.add "api-version", valid_574308
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

proc call*(call_574310: Call_ApplicationGatewaysCreateOrUpdate_574276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the specified application gateway.
  ## 
  let valid = call_574310.validator(path, query, header, formData, body)
  let scheme = call_574310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574310.url(scheme.get, call_574310.host, call_574310.base,
                         call_574310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574310, url, valid)

proc call*(call_574311: Call_ApplicationGatewaysCreateOrUpdate_574276;
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
  var path_574312 = newJObject()
  var query_574313 = newJObject()
  var body_574314 = newJObject()
  add(path_574312, "resourceGroupName", newJString(resourceGroupName))
  add(query_574313, "api-version", newJString(apiVersion))
  add(path_574312, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574314 = parameters
  add(path_574312, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_574311.call(path_574312, query_574313, nil, nil, body_574314)

var applicationGatewaysCreateOrUpdate* = Call_ApplicationGatewaysCreateOrUpdate_574276(
    name: "applicationGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysCreateOrUpdate_574277, base: "",
    url: url_ApplicationGatewaysCreateOrUpdate_574278, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysGet_574265 = ref object of OpenApiRestCall_573666
proc url_ApplicationGatewaysGet_574267(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGatewaysGet_574266(path: JsonNode; query: JsonNode;
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
  var valid_574268 = path.getOrDefault("resourceGroupName")
  valid_574268 = validateParameter(valid_574268, JString, required = true,
                                 default = nil)
  if valid_574268 != nil:
    section.add "resourceGroupName", valid_574268
  var valid_574269 = path.getOrDefault("subscriptionId")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "subscriptionId", valid_574269
  var valid_574270 = path.getOrDefault("applicationGatewayName")
  valid_574270 = validateParameter(valid_574270, JString, required = true,
                                 default = nil)
  if valid_574270 != nil:
    section.add "applicationGatewayName", valid_574270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574271 = query.getOrDefault("api-version")
  valid_574271 = validateParameter(valid_574271, JString, required = true,
                                 default = nil)
  if valid_574271 != nil:
    section.add "api-version", valid_574271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574272: Call_ApplicationGatewaysGet_574265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified application gateway.
  ## 
  let valid = call_574272.validator(path, query, header, formData, body)
  let scheme = call_574272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574272.url(scheme.get, call_574272.host, call_574272.base,
                         call_574272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574272, url, valid)

proc call*(call_574273: Call_ApplicationGatewaysGet_574265;
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
  var path_574274 = newJObject()
  var query_574275 = newJObject()
  add(path_574274, "resourceGroupName", newJString(resourceGroupName))
  add(query_574275, "api-version", newJString(apiVersion))
  add(path_574274, "subscriptionId", newJString(subscriptionId))
  add(path_574274, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_574273.call(path_574274, query_574275, nil, nil, nil)

var applicationGatewaysGet* = Call_ApplicationGatewaysGet_574265(
    name: "applicationGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysGet_574266, base: "",
    url: url_ApplicationGatewaysGet_574267, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysUpdateTags_574326 = ref object of OpenApiRestCall_573666
proc url_ApplicationGatewaysUpdateTags_574328(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysUpdateTags_574327(path: JsonNode; query: JsonNode;
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
  var valid_574329 = path.getOrDefault("resourceGroupName")
  valid_574329 = validateParameter(valid_574329, JString, required = true,
                                 default = nil)
  if valid_574329 != nil:
    section.add "resourceGroupName", valid_574329
  var valid_574330 = path.getOrDefault("subscriptionId")
  valid_574330 = validateParameter(valid_574330, JString, required = true,
                                 default = nil)
  if valid_574330 != nil:
    section.add "subscriptionId", valid_574330
  var valid_574331 = path.getOrDefault("applicationGatewayName")
  valid_574331 = validateParameter(valid_574331, JString, required = true,
                                 default = nil)
  if valid_574331 != nil:
    section.add "applicationGatewayName", valid_574331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574332 = query.getOrDefault("api-version")
  valid_574332 = validateParameter(valid_574332, JString, required = true,
                                 default = nil)
  if valid_574332 != nil:
    section.add "api-version", valid_574332
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

proc call*(call_574334: Call_ApplicationGatewaysUpdateTags_574326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified application gateway tags.
  ## 
  let valid = call_574334.validator(path, query, header, formData, body)
  let scheme = call_574334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574334.url(scheme.get, call_574334.host, call_574334.base,
                         call_574334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574334, url, valid)

proc call*(call_574335: Call_ApplicationGatewaysUpdateTags_574326;
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
  var path_574336 = newJObject()
  var query_574337 = newJObject()
  var body_574338 = newJObject()
  add(path_574336, "resourceGroupName", newJString(resourceGroupName))
  add(query_574337, "api-version", newJString(apiVersion))
  add(path_574336, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574338 = parameters
  add(path_574336, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_574335.call(path_574336, query_574337, nil, nil, body_574338)

var applicationGatewaysUpdateTags* = Call_ApplicationGatewaysUpdateTags_574326(
    name: "applicationGatewaysUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysUpdateTags_574327, base: "",
    url: url_ApplicationGatewaysUpdateTags_574328, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysDelete_574315 = ref object of OpenApiRestCall_573666
proc url_ApplicationGatewaysDelete_574317(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysDelete_574316(path: JsonNode; query: JsonNode;
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
  var valid_574318 = path.getOrDefault("resourceGroupName")
  valid_574318 = validateParameter(valid_574318, JString, required = true,
                                 default = nil)
  if valid_574318 != nil:
    section.add "resourceGroupName", valid_574318
  var valid_574319 = path.getOrDefault("subscriptionId")
  valid_574319 = validateParameter(valid_574319, JString, required = true,
                                 default = nil)
  if valid_574319 != nil:
    section.add "subscriptionId", valid_574319
  var valid_574320 = path.getOrDefault("applicationGatewayName")
  valid_574320 = validateParameter(valid_574320, JString, required = true,
                                 default = nil)
  if valid_574320 != nil:
    section.add "applicationGatewayName", valid_574320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_574322: Call_ApplicationGatewaysDelete_574315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified application gateway.
  ## 
  let valid = call_574322.validator(path, query, header, formData, body)
  let scheme = call_574322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574322.url(scheme.get, call_574322.host, call_574322.base,
                         call_574322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574322, url, valid)

proc call*(call_574323: Call_ApplicationGatewaysDelete_574315;
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
  var path_574324 = newJObject()
  var query_574325 = newJObject()
  add(path_574324, "resourceGroupName", newJString(resourceGroupName))
  add(query_574325, "api-version", newJString(apiVersion))
  add(path_574324, "subscriptionId", newJString(subscriptionId))
  add(path_574324, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_574323.call(path_574324, query_574325, nil, nil, nil)

var applicationGatewaysDelete* = Call_ApplicationGatewaysDelete_574315(
    name: "applicationGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysDelete_574316, base: "",
    url: url_ApplicationGatewaysDelete_574317, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysBackendHealth_574339 = ref object of OpenApiRestCall_573666
proc url_ApplicationGatewaysBackendHealth_574341(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysBackendHealth_574340(path: JsonNode;
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
  var valid_574345 = path.getOrDefault("applicationGatewayName")
  valid_574345 = validateParameter(valid_574345, JString, required = true,
                                 default = nil)
  if valid_574345 != nil:
    section.add "applicationGatewayName", valid_574345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands BackendAddressPool and BackendHttpSettings referenced in backend health.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574346 = query.getOrDefault("api-version")
  valid_574346 = validateParameter(valid_574346, JString, required = true,
                                 default = nil)
  if valid_574346 != nil:
    section.add "api-version", valid_574346
  var valid_574347 = query.getOrDefault("$expand")
  valid_574347 = validateParameter(valid_574347, JString, required = false,
                                 default = nil)
  if valid_574347 != nil:
    section.add "$expand", valid_574347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574348: Call_ApplicationGatewaysBackendHealth_574339;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the backend health of the specified application gateway in a resource group.
  ## 
  let valid = call_574348.validator(path, query, header, formData, body)
  let scheme = call_574348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574348.url(scheme.get, call_574348.host, call_574348.base,
                         call_574348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574348, url, valid)

proc call*(call_574349: Call_ApplicationGatewaysBackendHealth_574339;
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
  var path_574350 = newJObject()
  var query_574351 = newJObject()
  add(path_574350, "resourceGroupName", newJString(resourceGroupName))
  add(query_574351, "api-version", newJString(apiVersion))
  add(query_574351, "$expand", newJString(Expand))
  add(path_574350, "subscriptionId", newJString(subscriptionId))
  add(path_574350, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_574349.call(path_574350, query_574351, nil, nil, nil)

var applicationGatewaysBackendHealth* = Call_ApplicationGatewaysBackendHealth_574339(
    name: "applicationGatewaysBackendHealth", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}/backendhealth",
    validator: validate_ApplicationGatewaysBackendHealth_574340, base: "",
    url: url_ApplicationGatewaysBackendHealth_574341, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysBackendHealthOnDemand_574352 = ref object of OpenApiRestCall_573666
proc url_ApplicationGatewaysBackendHealthOnDemand_574354(protocol: Scheme;
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

proc validate_ApplicationGatewaysBackendHealthOnDemand_574353(path: JsonNode;
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
  var valid_574357 = path.getOrDefault("applicationGatewayName")
  valid_574357 = validateParameter(valid_574357, JString, required = true,
                                 default = nil)
  if valid_574357 != nil:
    section.add "applicationGatewayName", valid_574357
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands BackendAddressPool and BackendHttpSettings referenced in backend health.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574358 = query.getOrDefault("api-version")
  valid_574358 = validateParameter(valid_574358, JString, required = true,
                                 default = nil)
  if valid_574358 != nil:
    section.add "api-version", valid_574358
  var valid_574359 = query.getOrDefault("$expand")
  valid_574359 = validateParameter(valid_574359, JString, required = false,
                                 default = nil)
  if valid_574359 != nil:
    section.add "$expand", valid_574359
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

proc call*(call_574361: Call_ApplicationGatewaysBackendHealthOnDemand_574352;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the backend health for given combination of backend pool and http setting of the specified application gateway in a resource group.
  ## 
  let valid = call_574361.validator(path, query, header, formData, body)
  let scheme = call_574361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574361.url(scheme.get, call_574361.host, call_574361.base,
                         call_574361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574361, url, valid)

proc call*(call_574362: Call_ApplicationGatewaysBackendHealthOnDemand_574352;
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
  var path_574363 = newJObject()
  var query_574364 = newJObject()
  var body_574365 = newJObject()
  add(path_574363, "resourceGroupName", newJString(resourceGroupName))
  add(query_574364, "api-version", newJString(apiVersion))
  add(query_574364, "$expand", newJString(Expand))
  add(path_574363, "subscriptionId", newJString(subscriptionId))
  if probeRequest != nil:
    body_574365 = probeRequest
  add(path_574363, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_574362.call(path_574363, query_574364, nil, nil, body_574365)

var applicationGatewaysBackendHealthOnDemand* = Call_ApplicationGatewaysBackendHealthOnDemand_574352(
    name: "applicationGatewaysBackendHealthOnDemand", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}/getBackendHealthOnDemand",
    validator: validate_ApplicationGatewaysBackendHealthOnDemand_574353, base: "",
    url: url_ApplicationGatewaysBackendHealthOnDemand_574354,
    schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysStart_574366 = ref object of OpenApiRestCall_573666
proc url_ApplicationGatewaysStart_574368(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysStart_574367(path: JsonNode; query: JsonNode;
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
  var valid_574369 = path.getOrDefault("resourceGroupName")
  valid_574369 = validateParameter(valid_574369, JString, required = true,
                                 default = nil)
  if valid_574369 != nil:
    section.add "resourceGroupName", valid_574369
  var valid_574370 = path.getOrDefault("subscriptionId")
  valid_574370 = validateParameter(valid_574370, JString, required = true,
                                 default = nil)
  if valid_574370 != nil:
    section.add "subscriptionId", valid_574370
  var valid_574371 = path.getOrDefault("applicationGatewayName")
  valid_574371 = validateParameter(valid_574371, JString, required = true,
                                 default = nil)
  if valid_574371 != nil:
    section.add "applicationGatewayName", valid_574371
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574372 = query.getOrDefault("api-version")
  valid_574372 = validateParameter(valid_574372, JString, required = true,
                                 default = nil)
  if valid_574372 != nil:
    section.add "api-version", valid_574372
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574373: Call_ApplicationGatewaysStart_574366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts the specified application gateway.
  ## 
  let valid = call_574373.validator(path, query, header, formData, body)
  let scheme = call_574373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574373.url(scheme.get, call_574373.host, call_574373.base,
                         call_574373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574373, url, valid)

proc call*(call_574374: Call_ApplicationGatewaysStart_574366;
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
  var path_574375 = newJObject()
  var query_574376 = newJObject()
  add(path_574375, "resourceGroupName", newJString(resourceGroupName))
  add(query_574376, "api-version", newJString(apiVersion))
  add(path_574375, "subscriptionId", newJString(subscriptionId))
  add(path_574375, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_574374.call(path_574375, query_574376, nil, nil, nil)

var applicationGatewaysStart* = Call_ApplicationGatewaysStart_574366(
    name: "applicationGatewaysStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}/start",
    validator: validate_ApplicationGatewaysStart_574367, base: "",
    url: url_ApplicationGatewaysStart_574368, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysStop_574377 = ref object of OpenApiRestCall_573666
proc url_ApplicationGatewaysStop_574379(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGatewaysStop_574378(path: JsonNode; query: JsonNode;
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
  var valid_574380 = path.getOrDefault("resourceGroupName")
  valid_574380 = validateParameter(valid_574380, JString, required = true,
                                 default = nil)
  if valid_574380 != nil:
    section.add "resourceGroupName", valid_574380
  var valid_574381 = path.getOrDefault("subscriptionId")
  valid_574381 = validateParameter(valid_574381, JString, required = true,
                                 default = nil)
  if valid_574381 != nil:
    section.add "subscriptionId", valid_574381
  var valid_574382 = path.getOrDefault("applicationGatewayName")
  valid_574382 = validateParameter(valid_574382, JString, required = true,
                                 default = nil)
  if valid_574382 != nil:
    section.add "applicationGatewayName", valid_574382
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574383 = query.getOrDefault("api-version")
  valid_574383 = validateParameter(valid_574383, JString, required = true,
                                 default = nil)
  if valid_574383 != nil:
    section.add "api-version", valid_574383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574384: Call_ApplicationGatewaysStop_574377; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops the specified application gateway in a resource group.
  ## 
  let valid = call_574384.validator(path, query, header, formData, body)
  let scheme = call_574384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574384.url(scheme.get, call_574384.host, call_574384.base,
                         call_574384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574384, url, valid)

proc call*(call_574385: Call_ApplicationGatewaysStop_574377;
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
  var path_574386 = newJObject()
  var query_574387 = newJObject()
  add(path_574386, "resourceGroupName", newJString(resourceGroupName))
  add(query_574387, "api-version", newJString(apiVersion))
  add(path_574386, "subscriptionId", newJString(subscriptionId))
  add(path_574386, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_574385.call(path_574386, query_574387, nil, nil, nil)

var applicationGatewaysStop* = Call_ApplicationGatewaysStop_574377(
    name: "applicationGatewaysStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}/stop",
    validator: validate_ApplicationGatewaysStop_574378, base: "",
    url: url_ApplicationGatewaysStop_574379, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
