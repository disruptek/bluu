
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: TrafficManagerManagementClient
## version: 2018-04-01
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

  OpenApiRestCall_567659 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567659](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567659): Option[Scheme] {.used.} =
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
  macServiceName = "trafficmanager"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_567881 = ref object of OpenApiRestCall_567659
proc url_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_567883(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_567882(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Checks the availability of a Traffic Manager Relative DNS name.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568059 = query.getOrDefault("api-version")
  valid_568059 = validateParameter(valid_568059, JString, required = true,
                                 default = nil)
  if valid_568059 != nil:
    section.add "api-version", valid_568059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The Traffic Manager name parameters supplied to the CheckTrafficManagerNameAvailability operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568083: Call_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_567881;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks the availability of a Traffic Manager Relative DNS name.
  ## 
  let valid = call_568083.validator(path, query, header, formData, body)
  let scheme = call_568083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568083.url(scheme.get, call_568083.host, call_568083.base,
                         call_568083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568083, url, valid)

proc call*(call_568154: Call_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_567881;
          apiVersion: string; parameters: JsonNode): Recallable =
  ## profilesCheckTrafficManagerRelativeDnsNameAvailability
  ## Checks the availability of a Traffic Manager Relative DNS name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameters: JObject (required)
  ##             : The Traffic Manager name parameters supplied to the CheckTrafficManagerNameAvailability operation.
  var query_568155 = newJObject()
  var body_568157 = newJObject()
  add(query_568155, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568157 = parameters
  result = call_568154.call(nil, query_568155, nil, nil, body_568157)

var profilesCheckTrafficManagerRelativeDnsNameAvailability* = Call_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_567881(
    name: "profilesCheckTrafficManagerRelativeDnsNameAvailability",
    meth: HttpMethod.HttpPost, host: "management.azure.com",
    route: "/providers/Microsoft.Network/checkTrafficManagerNameAvailability",
    validator: validate_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_567882,
    base: "", url: url_ProfilesCheckTrafficManagerRelativeDnsNameAvailability_567883,
    schemes: {Scheme.Https})
type
  Call_GeographicHierarchiesGetDefault_568196 = ref object of OpenApiRestCall_567659
proc url_GeographicHierarchiesGetDefault_568198(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GeographicHierarchiesGetDefault_568197(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the default Geographic Hierarchy used by the Geographic traffic routing method.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568199 = query.getOrDefault("api-version")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "api-version", valid_568199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568200: Call_GeographicHierarchiesGetDefault_568196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the default Geographic Hierarchy used by the Geographic traffic routing method.
  ## 
  let valid = call_568200.validator(path, query, header, formData, body)
  let scheme = call_568200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568200.url(scheme.get, call_568200.host, call_568200.base,
                         call_568200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568200, url, valid)

proc call*(call_568201: Call_GeographicHierarchiesGetDefault_568196;
          apiVersion: string): Recallable =
  ## geographicHierarchiesGetDefault
  ## Gets the default Geographic Hierarchy used by the Geographic traffic routing method.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568202 = newJObject()
  add(query_568202, "api-version", newJString(apiVersion))
  result = call_568201.call(nil, query_568202, nil, nil, nil)

var geographicHierarchiesGetDefault* = Call_GeographicHierarchiesGetDefault_568196(
    name: "geographicHierarchiesGetDefault", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Network/trafficManagerGeographicHierarchies/default",
    validator: validate_GeographicHierarchiesGetDefault_568197, base: "",
    url: url_GeographicHierarchiesGetDefault_568198, schemes: {Scheme.Https})
type
  Call_TrafficManagerUserMetricsKeysCreateOrUpdate_568226 = ref object of OpenApiRestCall_567659
proc url_TrafficManagerUserMetricsKeysCreateOrUpdate_568228(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/trafficManagerUserMetricsKeys/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TrafficManagerUserMetricsKeysCreateOrUpdate_568227(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a subscription-level key used for Real User Metrics collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568229 = path.getOrDefault("subscriptionId")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "subscriptionId", valid_568229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568230 = query.getOrDefault("api-version")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "api-version", valid_568230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568231: Call_TrafficManagerUserMetricsKeysCreateOrUpdate_568226;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a subscription-level key used for Real User Metrics collection.
  ## 
  let valid = call_568231.validator(path, query, header, formData, body)
  let scheme = call_568231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568231.url(scheme.get, call_568231.host, call_568231.base,
                         call_568231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568231, url, valid)

proc call*(call_568232: Call_TrafficManagerUserMetricsKeysCreateOrUpdate_568226;
          apiVersion: string; subscriptionId: string): Recallable =
  ## trafficManagerUserMetricsKeysCreateOrUpdate
  ## Create or update a subscription-level key used for Real User Metrics collection.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568233 = newJObject()
  var query_568234 = newJObject()
  add(query_568234, "api-version", newJString(apiVersion))
  add(path_568233, "subscriptionId", newJString(subscriptionId))
  result = call_568232.call(path_568233, query_568234, nil, nil, nil)

var trafficManagerUserMetricsKeysCreateOrUpdate* = Call_TrafficManagerUserMetricsKeysCreateOrUpdate_568226(
    name: "trafficManagerUserMetricsKeysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/trafficManagerUserMetricsKeys/default",
    validator: validate_TrafficManagerUserMetricsKeysCreateOrUpdate_568227,
    base: "", url: url_TrafficManagerUserMetricsKeysCreateOrUpdate_568228,
    schemes: {Scheme.Https})
type
  Call_TrafficManagerUserMetricsKeysGet_568203 = ref object of OpenApiRestCall_567659
proc url_TrafficManagerUserMetricsKeysGet_568205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/trafficManagerUserMetricsKeys/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TrafficManagerUserMetricsKeysGet_568204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the subscription-level key used for Real User Metrics collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568220 = path.getOrDefault("subscriptionId")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "subscriptionId", valid_568220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568221 = query.getOrDefault("api-version")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "api-version", valid_568221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_TrafficManagerUserMetricsKeysGet_568203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the subscription-level key used for Real User Metrics collection.
  ## 
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_TrafficManagerUserMetricsKeysGet_568203;
          apiVersion: string; subscriptionId: string): Recallable =
  ## trafficManagerUserMetricsKeysGet
  ## Get the subscription-level key used for Real User Metrics collection.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568224 = newJObject()
  var query_568225 = newJObject()
  add(query_568225, "api-version", newJString(apiVersion))
  add(path_568224, "subscriptionId", newJString(subscriptionId))
  result = call_568223.call(path_568224, query_568225, nil, nil, nil)

var trafficManagerUserMetricsKeysGet* = Call_TrafficManagerUserMetricsKeysGet_568203(
    name: "trafficManagerUserMetricsKeysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/trafficManagerUserMetricsKeys/default",
    validator: validate_TrafficManagerUserMetricsKeysGet_568204, base: "",
    url: url_TrafficManagerUserMetricsKeysGet_568205, schemes: {Scheme.Https})
type
  Call_TrafficManagerUserMetricsKeysDelete_568235 = ref object of OpenApiRestCall_567659
proc url_TrafficManagerUserMetricsKeysDelete_568237(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/trafficManagerUserMetricsKeys/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TrafficManagerUserMetricsKeysDelete_568236(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a subscription-level key used for Real User Metrics collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568238 = path.getOrDefault("subscriptionId")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "subscriptionId", valid_568238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568239 = query.getOrDefault("api-version")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "api-version", valid_568239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568240: Call_TrafficManagerUserMetricsKeysDelete_568235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a subscription-level key used for Real User Metrics collection.
  ## 
  let valid = call_568240.validator(path, query, header, formData, body)
  let scheme = call_568240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568240.url(scheme.get, call_568240.host, call_568240.base,
                         call_568240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568240, url, valid)

proc call*(call_568241: Call_TrafficManagerUserMetricsKeysDelete_568235;
          apiVersion: string; subscriptionId: string): Recallable =
  ## trafficManagerUserMetricsKeysDelete
  ## Delete a subscription-level key used for Real User Metrics collection.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568242 = newJObject()
  var query_568243 = newJObject()
  add(query_568243, "api-version", newJString(apiVersion))
  add(path_568242, "subscriptionId", newJString(subscriptionId))
  result = call_568241.call(path_568242, query_568243, nil, nil, nil)

var trafficManagerUserMetricsKeysDelete* = Call_TrafficManagerUserMetricsKeysDelete_568235(
    name: "trafficManagerUserMetricsKeysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/trafficManagerUserMetricsKeys/default",
    validator: validate_TrafficManagerUserMetricsKeysDelete_568236, base: "",
    url: url_TrafficManagerUserMetricsKeysDelete_568237, schemes: {Scheme.Https})
type
  Call_ProfilesListBySubscription_568244 = ref object of OpenApiRestCall_567659
proc url_ProfilesListBySubscription_568246(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Network/trafficmanagerprofiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesListBySubscription_568245(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Traffic Manager profiles within a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568247 = path.getOrDefault("subscriptionId")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "subscriptionId", valid_568247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568248 = query.getOrDefault("api-version")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "api-version", valid_568248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568249: Call_ProfilesListBySubscription_568244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Traffic Manager profiles within a subscription.
  ## 
  let valid = call_568249.validator(path, query, header, formData, body)
  let scheme = call_568249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568249.url(scheme.get, call_568249.host, call_568249.base,
                         call_568249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568249, url, valid)

proc call*(call_568250: Call_ProfilesListBySubscription_568244; apiVersion: string;
          subscriptionId: string): Recallable =
  ## profilesListBySubscription
  ## Lists all Traffic Manager profiles within a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568251 = newJObject()
  var query_568252 = newJObject()
  add(query_568252, "api-version", newJString(apiVersion))
  add(path_568251, "subscriptionId", newJString(subscriptionId))
  result = call_568250.call(path_568251, query_568252, nil, nil, nil)

var profilesListBySubscription* = Call_ProfilesListBySubscription_568244(
    name: "profilesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/trafficmanagerprofiles",
    validator: validate_ProfilesListBySubscription_568245, base: "",
    url: url_ProfilesListBySubscription_568246, schemes: {Scheme.Https})
type
  Call_ProfilesListByResourceGroup_568253 = ref object of OpenApiRestCall_567659
proc url_ProfilesListByResourceGroup_568255(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Network/trafficmanagerprofiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesListByResourceGroup_568254(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Traffic Manager profiles within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Traffic Manager profiles to be listed.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568256 = path.getOrDefault("resourceGroupName")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "resourceGroupName", valid_568256
  var valid_568257 = path.getOrDefault("subscriptionId")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "subscriptionId", valid_568257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568258 = query.getOrDefault("api-version")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "api-version", valid_568258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568259: Call_ProfilesListByResourceGroup_568253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Traffic Manager profiles within a resource group.
  ## 
  let valid = call_568259.validator(path, query, header, formData, body)
  let scheme = call_568259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568259.url(scheme.get, call_568259.host, call_568259.base,
                         call_568259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568259, url, valid)

proc call*(call_568260: Call_ProfilesListByResourceGroup_568253;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## profilesListByResourceGroup
  ## Lists all Traffic Manager profiles within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Traffic Manager profiles to be listed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568261 = newJObject()
  var query_568262 = newJObject()
  add(path_568261, "resourceGroupName", newJString(resourceGroupName))
  add(query_568262, "api-version", newJString(apiVersion))
  add(path_568261, "subscriptionId", newJString(subscriptionId))
  result = call_568260.call(path_568261, query_568262, nil, nil, nil)

var profilesListByResourceGroup* = Call_ProfilesListByResourceGroup_568253(
    name: "profilesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles",
    validator: validate_ProfilesListByResourceGroup_568254, base: "",
    url: url_ProfilesListByResourceGroup_568255, schemes: {Scheme.Https})
type
  Call_ProfilesCreateOrUpdate_568274 = ref object of OpenApiRestCall_567659
proc url_ProfilesCreateOrUpdate_568276(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/trafficmanagerprofiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesCreateOrUpdate_568275(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Traffic Manager profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Traffic Manager profile.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: JString (required)
  ##              : The name of the Traffic Manager profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568277 = path.getOrDefault("resourceGroupName")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "resourceGroupName", valid_568277
  var valid_568278 = path.getOrDefault("subscriptionId")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "subscriptionId", valid_568278
  var valid_568279 = path.getOrDefault("profileName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "profileName", valid_568279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568280 = query.getOrDefault("api-version")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "api-version", valid_568280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The Traffic Manager profile parameters supplied to the CreateOrUpdate operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568282: Call_ProfilesCreateOrUpdate_568274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Traffic Manager profile.
  ## 
  let valid = call_568282.validator(path, query, header, formData, body)
  let scheme = call_568282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568282.url(scheme.get, call_568282.host, call_568282.base,
                         call_568282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568282, url, valid)

proc call*(call_568283: Call_ProfilesCreateOrUpdate_568274;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string; parameters: JsonNode): Recallable =
  ## profilesCreateOrUpdate
  ## Create or update a Traffic Manager profile.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Traffic Manager profile.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: string (required)
  ##              : The name of the Traffic Manager profile.
  ##   parameters: JObject (required)
  ##             : The Traffic Manager profile parameters supplied to the CreateOrUpdate operation.
  var path_568284 = newJObject()
  var query_568285 = newJObject()
  var body_568286 = newJObject()
  add(path_568284, "resourceGroupName", newJString(resourceGroupName))
  add(query_568285, "api-version", newJString(apiVersion))
  add(path_568284, "subscriptionId", newJString(subscriptionId))
  add(path_568284, "profileName", newJString(profileName))
  if parameters != nil:
    body_568286 = parameters
  result = call_568283.call(path_568284, query_568285, nil, nil, body_568286)

var profilesCreateOrUpdate* = Call_ProfilesCreateOrUpdate_568274(
    name: "profilesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}",
    validator: validate_ProfilesCreateOrUpdate_568275, base: "",
    url: url_ProfilesCreateOrUpdate_568276, schemes: {Scheme.Https})
type
  Call_ProfilesGet_568263 = ref object of OpenApiRestCall_567659
proc url_ProfilesGet_568265(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/trafficmanagerprofiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesGet_568264(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a Traffic Manager profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Traffic Manager profile.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: JString (required)
  ##              : The name of the Traffic Manager profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568266 = path.getOrDefault("resourceGroupName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "resourceGroupName", valid_568266
  var valid_568267 = path.getOrDefault("subscriptionId")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "subscriptionId", valid_568267
  var valid_568268 = path.getOrDefault("profileName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "profileName", valid_568268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568269 = query.getOrDefault("api-version")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "api-version", valid_568269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568270: Call_ProfilesGet_568263; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Traffic Manager profile.
  ## 
  let valid = call_568270.validator(path, query, header, formData, body)
  let scheme = call_568270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568270.url(scheme.get, call_568270.host, call_568270.base,
                         call_568270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568270, url, valid)

proc call*(call_568271: Call_ProfilesGet_568263; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string): Recallable =
  ## profilesGet
  ## Gets a Traffic Manager profile.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Traffic Manager profile.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: string (required)
  ##              : The name of the Traffic Manager profile.
  var path_568272 = newJObject()
  var query_568273 = newJObject()
  add(path_568272, "resourceGroupName", newJString(resourceGroupName))
  add(query_568273, "api-version", newJString(apiVersion))
  add(path_568272, "subscriptionId", newJString(subscriptionId))
  add(path_568272, "profileName", newJString(profileName))
  result = call_568271.call(path_568272, query_568273, nil, nil, nil)

var profilesGet* = Call_ProfilesGet_568263(name: "profilesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}",
                                        validator: validate_ProfilesGet_568264,
                                        base: "", url: url_ProfilesGet_568265,
                                        schemes: {Scheme.Https})
type
  Call_ProfilesUpdate_568298 = ref object of OpenApiRestCall_567659
proc url_ProfilesUpdate_568300(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/trafficmanagerprofiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesUpdate_568299(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update a Traffic Manager profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Traffic Manager profile.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: JString (required)
  ##              : The name of the Traffic Manager profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568301 = path.getOrDefault("resourceGroupName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "resourceGroupName", valid_568301
  var valid_568302 = path.getOrDefault("subscriptionId")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "subscriptionId", valid_568302
  var valid_568303 = path.getOrDefault("profileName")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "profileName", valid_568303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568304 = query.getOrDefault("api-version")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "api-version", valid_568304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The Traffic Manager profile parameters supplied to the Update operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568306: Call_ProfilesUpdate_568298; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a Traffic Manager profile.
  ## 
  let valid = call_568306.validator(path, query, header, formData, body)
  let scheme = call_568306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568306.url(scheme.get, call_568306.host, call_568306.base,
                         call_568306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568306, url, valid)

proc call*(call_568307: Call_ProfilesUpdate_568298; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          parameters: JsonNode): Recallable =
  ## profilesUpdate
  ## Update a Traffic Manager profile.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Traffic Manager profile.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: string (required)
  ##              : The name of the Traffic Manager profile.
  ##   parameters: JObject (required)
  ##             : The Traffic Manager profile parameters supplied to the Update operation.
  var path_568308 = newJObject()
  var query_568309 = newJObject()
  var body_568310 = newJObject()
  add(path_568308, "resourceGroupName", newJString(resourceGroupName))
  add(query_568309, "api-version", newJString(apiVersion))
  add(path_568308, "subscriptionId", newJString(subscriptionId))
  add(path_568308, "profileName", newJString(profileName))
  if parameters != nil:
    body_568310 = parameters
  result = call_568307.call(path_568308, query_568309, nil, nil, body_568310)

var profilesUpdate* = Call_ProfilesUpdate_568298(name: "profilesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}",
    validator: validate_ProfilesUpdate_568299, base: "", url: url_ProfilesUpdate_568300,
    schemes: {Scheme.Https})
type
  Call_ProfilesDelete_568287 = ref object of OpenApiRestCall_567659
proc url_ProfilesDelete_568289(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/trafficmanagerprofiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesDelete_568288(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a Traffic Manager profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Traffic Manager profile to be deleted.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: JString (required)
  ##              : The name of the Traffic Manager profile to be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568290 = path.getOrDefault("resourceGroupName")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "resourceGroupName", valid_568290
  var valid_568291 = path.getOrDefault("subscriptionId")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "subscriptionId", valid_568291
  var valid_568292 = path.getOrDefault("profileName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "profileName", valid_568292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568293 = query.getOrDefault("api-version")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "api-version", valid_568293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568294: Call_ProfilesDelete_568287; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Traffic Manager profile.
  ## 
  let valid = call_568294.validator(path, query, header, formData, body)
  let scheme = call_568294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568294.url(scheme.get, call_568294.host, call_568294.base,
                         call_568294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568294, url, valid)

proc call*(call_568295: Call_ProfilesDelete_568287; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string): Recallable =
  ## profilesDelete
  ## Deletes a Traffic Manager profile.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Traffic Manager profile to be deleted.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: string (required)
  ##              : The name of the Traffic Manager profile to be deleted.
  var path_568296 = newJObject()
  var query_568297 = newJObject()
  add(path_568296, "resourceGroupName", newJString(resourceGroupName))
  add(query_568297, "api-version", newJString(apiVersion))
  add(path_568296, "subscriptionId", newJString(subscriptionId))
  add(path_568296, "profileName", newJString(profileName))
  result = call_568295.call(path_568296, query_568297, nil, nil, nil)

var profilesDelete* = Call_ProfilesDelete_568287(name: "profilesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}",
    validator: validate_ProfilesDelete_568288, base: "", url: url_ProfilesDelete_568289,
    schemes: {Scheme.Https})
type
  Call_HeatMapGet_568311 = ref object of OpenApiRestCall_567659
proc url_HeatMapGet_568313(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "heatMapType" in path, "`heatMapType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/trafficmanagerprofiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/heatMaps/"),
               (kind: VariableSegment, value: "heatMapType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HeatMapGet_568312(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets latest heatmap for Traffic Manager profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Traffic Manager endpoint.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   heatMapType: JString (required)
  ##              : The type of HeatMap for the Traffic Manager profile.
  ##   profileName: JString (required)
  ##              : The name of the Traffic Manager profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568314 = path.getOrDefault("resourceGroupName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "resourceGroupName", valid_568314
  var valid_568315 = path.getOrDefault("subscriptionId")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "subscriptionId", valid_568315
  var valid_568329 = path.getOrDefault("heatMapType")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = newJString("default"))
  if valid_568329 != nil:
    section.add "heatMapType", valid_568329
  var valid_568330 = path.getOrDefault("profileName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "profileName", valid_568330
  result.add "path", section
  ## parameters in `query` object:
  ##   topLeft: JArray
  ##          : The top left latitude,longitude pair of the rectangular viewport to query for.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   botRight: JArray
  ##           : The bottom right latitude,longitude pair of the rectangular viewport to query for.
  section = newJObject()
  var valid_568331 = query.getOrDefault("topLeft")
  valid_568331 = validateParameter(valid_568331, JArray, required = false,
                                 default = nil)
  if valid_568331 != nil:
    section.add "topLeft", valid_568331
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568332 = query.getOrDefault("api-version")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "api-version", valid_568332
  var valid_568333 = query.getOrDefault("botRight")
  valid_568333 = validateParameter(valid_568333, JArray, required = false,
                                 default = nil)
  if valid_568333 != nil:
    section.add "botRight", valid_568333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568334: Call_HeatMapGet_568311; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets latest heatmap for Traffic Manager profile.
  ## 
  let valid = call_568334.validator(path, query, header, formData, body)
  let scheme = call_568334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568334.url(scheme.get, call_568334.host, call_568334.base,
                         call_568334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568334, url, valid)

proc call*(call_568335: Call_HeatMapGet_568311; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          topLeft: JsonNode = nil; botRight: JsonNode = nil;
          heatMapType: string = "default"): Recallable =
  ## heatMapGet
  ## Gets latest heatmap for Traffic Manager profile.
  ##   topLeft: JArray
  ##          : The top left latitude,longitude pair of the rectangular viewport to query for.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Traffic Manager endpoint.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   botRight: JArray
  ##           : The bottom right latitude,longitude pair of the rectangular viewport to query for.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   heatMapType: string (required)
  ##              : The type of HeatMap for the Traffic Manager profile.
  ##   profileName: string (required)
  ##              : The name of the Traffic Manager profile.
  var path_568336 = newJObject()
  var query_568337 = newJObject()
  if topLeft != nil:
    query_568337.add "topLeft", topLeft
  add(path_568336, "resourceGroupName", newJString(resourceGroupName))
  add(query_568337, "api-version", newJString(apiVersion))
  if botRight != nil:
    query_568337.add "botRight", botRight
  add(path_568336, "subscriptionId", newJString(subscriptionId))
  add(path_568336, "heatMapType", newJString(heatMapType))
  add(path_568336, "profileName", newJString(profileName))
  result = call_568335.call(path_568336, query_568337, nil, nil, nil)

var heatMapGet* = Call_HeatMapGet_568311(name: "heatMapGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}/heatMaps/{heatMapType}",
                                      validator: validate_HeatMapGet_568312,
                                      base: "", url: url_HeatMapGet_568313,
                                      schemes: {Scheme.Https})
type
  Call_EndpointsCreateOrUpdate_568351 = ref object of OpenApiRestCall_567659
proc url_EndpointsCreateOrUpdate_568353(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointType" in path, "`endpointType` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/trafficmanagerprofiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "endpointType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "endpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsCreateOrUpdate_568352(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Traffic Manager endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Traffic Manager endpoint to be created or updated.
  ##   endpointType: JString (required)
  ##               : The type of the Traffic Manager endpoint to be created or updated.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: JString (required)
  ##              : The name of the Traffic Manager profile.
  ##   endpointName: JString (required)
  ##               : The name of the Traffic Manager endpoint to be created or updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568354 = path.getOrDefault("resourceGroupName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "resourceGroupName", valid_568354
  var valid_568355 = path.getOrDefault("endpointType")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "endpointType", valid_568355
  var valid_568356 = path.getOrDefault("subscriptionId")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "subscriptionId", valid_568356
  var valid_568357 = path.getOrDefault("profileName")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "profileName", valid_568357
  var valid_568358 = path.getOrDefault("endpointName")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "endpointName", valid_568358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568359 = query.getOrDefault("api-version")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "api-version", valid_568359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The Traffic Manager endpoint parameters supplied to the CreateOrUpdate operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568361: Call_EndpointsCreateOrUpdate_568351; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Traffic Manager endpoint.
  ## 
  let valid = call_568361.validator(path, query, header, formData, body)
  let scheme = call_568361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568361.url(scheme.get, call_568361.host, call_568361.base,
                         call_568361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568361, url, valid)

proc call*(call_568362: Call_EndpointsCreateOrUpdate_568351;
          resourceGroupName: string; apiVersion: string; endpointType: string;
          subscriptionId: string; profileName: string; parameters: JsonNode;
          endpointName: string): Recallable =
  ## endpointsCreateOrUpdate
  ## Create or update a Traffic Manager endpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Traffic Manager endpoint to be created or updated.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   endpointType: string (required)
  ##               : The type of the Traffic Manager endpoint to be created or updated.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: string (required)
  ##              : The name of the Traffic Manager profile.
  ##   parameters: JObject (required)
  ##             : The Traffic Manager endpoint parameters supplied to the CreateOrUpdate operation.
  ##   endpointName: string (required)
  ##               : The name of the Traffic Manager endpoint to be created or updated.
  var path_568363 = newJObject()
  var query_568364 = newJObject()
  var body_568365 = newJObject()
  add(path_568363, "resourceGroupName", newJString(resourceGroupName))
  add(query_568364, "api-version", newJString(apiVersion))
  add(path_568363, "endpointType", newJString(endpointType))
  add(path_568363, "subscriptionId", newJString(subscriptionId))
  add(path_568363, "profileName", newJString(profileName))
  if parameters != nil:
    body_568365 = parameters
  add(path_568363, "endpointName", newJString(endpointName))
  result = call_568362.call(path_568363, query_568364, nil, nil, body_568365)

var endpointsCreateOrUpdate* = Call_EndpointsCreateOrUpdate_568351(
    name: "endpointsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}/{endpointType}/{endpointName}",
    validator: validate_EndpointsCreateOrUpdate_568352, base: "",
    url: url_EndpointsCreateOrUpdate_568353, schemes: {Scheme.Https})
type
  Call_EndpointsGet_568338 = ref object of OpenApiRestCall_567659
proc url_EndpointsGet_568340(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointType" in path, "`endpointType` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/trafficmanagerprofiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "endpointType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "endpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsGet_568339(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a Traffic Manager endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Traffic Manager endpoint.
  ##   endpointType: JString (required)
  ##               : The type of the Traffic Manager endpoint.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: JString (required)
  ##              : The name of the Traffic Manager profile.
  ##   endpointName: JString (required)
  ##               : The name of the Traffic Manager endpoint.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568341 = path.getOrDefault("resourceGroupName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "resourceGroupName", valid_568341
  var valid_568342 = path.getOrDefault("endpointType")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "endpointType", valid_568342
  var valid_568343 = path.getOrDefault("subscriptionId")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "subscriptionId", valid_568343
  var valid_568344 = path.getOrDefault("profileName")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "profileName", valid_568344
  var valid_568345 = path.getOrDefault("endpointName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "endpointName", valid_568345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568346 = query.getOrDefault("api-version")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "api-version", valid_568346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568347: Call_EndpointsGet_568338; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Traffic Manager endpoint.
  ## 
  let valid = call_568347.validator(path, query, header, formData, body)
  let scheme = call_568347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568347.url(scheme.get, call_568347.host, call_568347.base,
                         call_568347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568347, url, valid)

proc call*(call_568348: Call_EndpointsGet_568338; resourceGroupName: string;
          apiVersion: string; endpointType: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## endpointsGet
  ## Gets a Traffic Manager endpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Traffic Manager endpoint.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   endpointType: string (required)
  ##               : The type of the Traffic Manager endpoint.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: string (required)
  ##              : The name of the Traffic Manager profile.
  ##   endpointName: string (required)
  ##               : The name of the Traffic Manager endpoint.
  var path_568349 = newJObject()
  var query_568350 = newJObject()
  add(path_568349, "resourceGroupName", newJString(resourceGroupName))
  add(query_568350, "api-version", newJString(apiVersion))
  add(path_568349, "endpointType", newJString(endpointType))
  add(path_568349, "subscriptionId", newJString(subscriptionId))
  add(path_568349, "profileName", newJString(profileName))
  add(path_568349, "endpointName", newJString(endpointName))
  result = call_568348.call(path_568349, query_568350, nil, nil, nil)

var endpointsGet* = Call_EndpointsGet_568338(name: "endpointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}/{endpointType}/{endpointName}",
    validator: validate_EndpointsGet_568339, base: "", url: url_EndpointsGet_568340,
    schemes: {Scheme.Https})
type
  Call_EndpointsUpdate_568379 = ref object of OpenApiRestCall_567659
proc url_EndpointsUpdate_568381(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointType" in path, "`endpointType` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/trafficmanagerprofiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "endpointType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "endpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsUpdate_568380(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Update a Traffic Manager endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Traffic Manager endpoint to be updated.
  ##   endpointType: JString (required)
  ##               : The type of the Traffic Manager endpoint to be updated.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: JString (required)
  ##              : The name of the Traffic Manager profile.
  ##   endpointName: JString (required)
  ##               : The name of the Traffic Manager endpoint to be updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568382 = path.getOrDefault("resourceGroupName")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "resourceGroupName", valid_568382
  var valid_568383 = path.getOrDefault("endpointType")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "endpointType", valid_568383
  var valid_568384 = path.getOrDefault("subscriptionId")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "subscriptionId", valid_568384
  var valid_568385 = path.getOrDefault("profileName")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "profileName", valid_568385
  var valid_568386 = path.getOrDefault("endpointName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "endpointName", valid_568386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568387 = query.getOrDefault("api-version")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "api-version", valid_568387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The Traffic Manager endpoint parameters supplied to the Update operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568389: Call_EndpointsUpdate_568379; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a Traffic Manager endpoint.
  ## 
  let valid = call_568389.validator(path, query, header, formData, body)
  let scheme = call_568389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568389.url(scheme.get, call_568389.host, call_568389.base,
                         call_568389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568389, url, valid)

proc call*(call_568390: Call_EndpointsUpdate_568379; resourceGroupName: string;
          apiVersion: string; endpointType: string; subscriptionId: string;
          profileName: string; parameters: JsonNode; endpointName: string): Recallable =
  ## endpointsUpdate
  ## Update a Traffic Manager endpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Traffic Manager endpoint to be updated.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   endpointType: string (required)
  ##               : The type of the Traffic Manager endpoint to be updated.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: string (required)
  ##              : The name of the Traffic Manager profile.
  ##   parameters: JObject (required)
  ##             : The Traffic Manager endpoint parameters supplied to the Update operation.
  ##   endpointName: string (required)
  ##               : The name of the Traffic Manager endpoint to be updated.
  var path_568391 = newJObject()
  var query_568392 = newJObject()
  var body_568393 = newJObject()
  add(path_568391, "resourceGroupName", newJString(resourceGroupName))
  add(query_568392, "api-version", newJString(apiVersion))
  add(path_568391, "endpointType", newJString(endpointType))
  add(path_568391, "subscriptionId", newJString(subscriptionId))
  add(path_568391, "profileName", newJString(profileName))
  if parameters != nil:
    body_568393 = parameters
  add(path_568391, "endpointName", newJString(endpointName))
  result = call_568390.call(path_568391, query_568392, nil, nil, body_568393)

var endpointsUpdate* = Call_EndpointsUpdate_568379(name: "endpointsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}/{endpointType}/{endpointName}",
    validator: validate_EndpointsUpdate_568380, base: "", url: url_EndpointsUpdate_568381,
    schemes: {Scheme.Https})
type
  Call_EndpointsDelete_568366 = ref object of OpenApiRestCall_567659
proc url_EndpointsDelete_568368(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointType" in path, "`endpointType` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/trafficmanagerprofiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "endpointType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "endpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsDelete_568367(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a Traffic Manager endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the Traffic Manager endpoint to be deleted.
  ##   endpointType: JString (required)
  ##               : The type of the Traffic Manager endpoint to be deleted.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: JString (required)
  ##              : The name of the Traffic Manager profile.
  ##   endpointName: JString (required)
  ##               : The name of the Traffic Manager endpoint to be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568369 = path.getOrDefault("resourceGroupName")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "resourceGroupName", valid_568369
  var valid_568370 = path.getOrDefault("endpointType")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "endpointType", valid_568370
  var valid_568371 = path.getOrDefault("subscriptionId")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "subscriptionId", valid_568371
  var valid_568372 = path.getOrDefault("profileName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "profileName", valid_568372
  var valid_568373 = path.getOrDefault("endpointName")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "endpointName", valid_568373
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568374 = query.getOrDefault("api-version")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "api-version", valid_568374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568375: Call_EndpointsDelete_568366; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Traffic Manager endpoint.
  ## 
  let valid = call_568375.validator(path, query, header, formData, body)
  let scheme = call_568375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568375.url(scheme.get, call_568375.host, call_568375.base,
                         call_568375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568375, url, valid)

proc call*(call_568376: Call_EndpointsDelete_568366; resourceGroupName: string;
          apiVersion: string; endpointType: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## endpointsDelete
  ## Deletes a Traffic Manager endpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the Traffic Manager endpoint to be deleted.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   endpointType: string (required)
  ##               : The type of the Traffic Manager endpoint to be deleted.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: string (required)
  ##              : The name of the Traffic Manager profile.
  ##   endpointName: string (required)
  ##               : The name of the Traffic Manager endpoint to be deleted.
  var path_568377 = newJObject()
  var query_568378 = newJObject()
  add(path_568377, "resourceGroupName", newJString(resourceGroupName))
  add(query_568378, "api-version", newJString(apiVersion))
  add(path_568377, "endpointType", newJString(endpointType))
  add(path_568377, "subscriptionId", newJString(subscriptionId))
  add(path_568377, "profileName", newJString(profileName))
  add(path_568377, "endpointName", newJString(endpointName))
  result = call_568376.call(path_568377, query_568378, nil, nil, nil)

var endpointsDelete* = Call_EndpointsDelete_568366(name: "endpointsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles/{profileName}/{endpointType}/{endpointName}",
    validator: validate_EndpointsDelete_568367, base: "", url: url_EndpointsDelete_568368,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
