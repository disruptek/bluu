
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: PeeringManagementClient
## version: 2019-08-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## APIs to manage Peering resources through the Azure Resource Manager.
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  macServiceName = "peering"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_573879 = ref object of OpenApiRestCall_573657
proc url_OperationsList_573881(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_573880(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available API operations for peering resources.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574040 = query.getOrDefault("api-version")
  valid_574040 = validateParameter(valid_574040, JString, required = true,
                                 default = nil)
  if valid_574040 != nil:
    section.add "api-version", valid_574040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574063: Call_OperationsList_573879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available API operations for peering resources.
  ## 
  let valid = call_574063.validator(path, query, header, formData, body)
  let scheme = call_574063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574063.url(scheme.get, call_574063.host, call_574063.base,
                         call_574063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574063, url, valid)

proc call*(call_574134: Call_OperationsList_573879; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available API operations for peering resources.
  ##   apiVersion: string (required)
  ##             : The client API version.
  var query_574135 = newJObject()
  add(query_574135, "api-version", newJString(apiVersion))
  result = call_574134.call(nil, query_574135, nil, nil, nil)

var operationsList* = Call_OperationsList_573879(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Peering/operations",
    validator: validate_OperationsList_573880, base: "", url: url_OperationsList_573881,
    schemes: {Scheme.Https})
type
  Call_CheckServiceProviderAvailability_574175 = ref object of OpenApiRestCall_573657
proc url_CheckServiceProviderAvailability_574177(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Peering/CheckServiceProviderAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CheckServiceProviderAvailability_574176(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks if the peering service provider is present within 1000 miles of customer's location
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574192 = path.getOrDefault("subscriptionId")
  valid_574192 = validateParameter(valid_574192, JString, required = true,
                                 default = nil)
  if valid_574192 != nil:
    section.add "subscriptionId", valid_574192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574193 = query.getOrDefault("api-version")
  valid_574193 = validateParameter(valid_574193, JString, required = true,
                                 default = nil)
  if valid_574193 != nil:
    section.add "api-version", valid_574193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   checkServiceProviderAvailabilityInput: JObject (required)
  ##                                        : The CheckServiceProviderAvailabilityInput indicating customer location and service provider.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574195: Call_CheckServiceProviderAvailability_574175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks if the peering service provider is present within 1000 miles of customer's location
  ## 
  let valid = call_574195.validator(path, query, header, formData, body)
  let scheme = call_574195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574195.url(scheme.get, call_574195.host, call_574195.base,
                         call_574195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574195, url, valid)

proc call*(call_574196: Call_CheckServiceProviderAvailability_574175;
          apiVersion: string; subscriptionId: string;
          checkServiceProviderAvailabilityInput: JsonNode): Recallable =
  ## checkServiceProviderAvailability
  ## Checks if the peering service provider is present within 1000 miles of customer's location
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   checkServiceProviderAvailabilityInput: JObject (required)
  ##                                        : The CheckServiceProviderAvailabilityInput indicating customer location and service provider.
  var path_574197 = newJObject()
  var query_574198 = newJObject()
  var body_574199 = newJObject()
  add(query_574198, "api-version", newJString(apiVersion))
  add(path_574197, "subscriptionId", newJString(subscriptionId))
  if checkServiceProviderAvailabilityInput != nil:
    body_574199 = checkServiceProviderAvailabilityInput
  result = call_574196.call(path_574197, query_574198, nil, nil, body_574199)

var checkServiceProviderAvailability* = Call_CheckServiceProviderAvailability_574175(
    name: "checkServiceProviderAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/CheckServiceProviderAvailability",
    validator: validate_CheckServiceProviderAvailability_574176, base: "",
    url: url_CheckServiceProviderAvailability_574177, schemes: {Scheme.Https})
type
  Call_LegacyPeeringsList_574200 = ref object of OpenApiRestCall_573657
proc url_LegacyPeeringsList_574202(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Peering/legacyPeerings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LegacyPeeringsList_574201(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all of the legacy peerings under the given subscription matching the specified kind and location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
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
  ##              : The client API version.
  ##   kind: JString (required)
  ##       : The kind of the peering.
  ##   peeringLocation: JString (required)
  ##                  : The location of the peering.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574204 = query.getOrDefault("api-version")
  valid_574204 = validateParameter(valid_574204, JString, required = true,
                                 default = nil)
  if valid_574204 != nil:
    section.add "api-version", valid_574204
  var valid_574218 = query.getOrDefault("kind")
  valid_574218 = validateParameter(valid_574218, JString, required = true,
                                 default = newJString("Direct"))
  if valid_574218 != nil:
    section.add "kind", valid_574218
  var valid_574219 = query.getOrDefault("peeringLocation")
  valid_574219 = validateParameter(valid_574219, JString, required = true,
                                 default = nil)
  if valid_574219 != nil:
    section.add "peeringLocation", valid_574219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574220: Call_LegacyPeeringsList_574200; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the legacy peerings under the given subscription matching the specified kind and location.
  ## 
  let valid = call_574220.validator(path, query, header, formData, body)
  let scheme = call_574220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574220.url(scheme.get, call_574220.host, call_574220.base,
                         call_574220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574220, url, valid)

proc call*(call_574221: Call_LegacyPeeringsList_574200; apiVersion: string;
          subscriptionId: string; peeringLocation: string; kind: string = "Direct"): Recallable =
  ## legacyPeeringsList
  ## Lists all of the legacy peerings under the given subscription matching the specified kind and location.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   kind: string (required)
  ##       : The kind of the peering.
  ##   peeringLocation: string (required)
  ##                  : The location of the peering.
  var path_574222 = newJObject()
  var query_574223 = newJObject()
  add(query_574223, "api-version", newJString(apiVersion))
  add(path_574222, "subscriptionId", newJString(subscriptionId))
  add(query_574223, "kind", newJString(kind))
  add(query_574223, "peeringLocation", newJString(peeringLocation))
  result = call_574221.call(path_574222, query_574223, nil, nil, nil)

var legacyPeeringsList* = Call_LegacyPeeringsList_574200(
    name: "legacyPeeringsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/legacyPeerings",
    validator: validate_LegacyPeeringsList_574201, base: "",
    url: url_LegacyPeeringsList_574202, schemes: {Scheme.Https})
type
  Call_PeerAsnsListBySubscription_574224 = ref object of OpenApiRestCall_573657
proc url_PeerAsnsListBySubscription_574226(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Peering/peerAsns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeerAsnsListBySubscription_574225(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the peer ASNs under the given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574227 = path.getOrDefault("subscriptionId")
  valid_574227 = validateParameter(valid_574227, JString, required = true,
                                 default = nil)
  if valid_574227 != nil:
    section.add "subscriptionId", valid_574227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574228 = query.getOrDefault("api-version")
  valid_574228 = validateParameter(valid_574228, JString, required = true,
                                 default = nil)
  if valid_574228 != nil:
    section.add "api-version", valid_574228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574229: Call_PeerAsnsListBySubscription_574224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the peer ASNs under the given subscription.
  ## 
  let valid = call_574229.validator(path, query, header, formData, body)
  let scheme = call_574229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574229.url(scheme.get, call_574229.host, call_574229.base,
                         call_574229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574229, url, valid)

proc call*(call_574230: Call_PeerAsnsListBySubscription_574224; apiVersion: string;
          subscriptionId: string): Recallable =
  ## peerAsnsListBySubscription
  ## Lists all of the peer ASNs under the given subscription.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_574231 = newJObject()
  var query_574232 = newJObject()
  add(query_574232, "api-version", newJString(apiVersion))
  add(path_574231, "subscriptionId", newJString(subscriptionId))
  result = call_574230.call(path_574231, query_574232, nil, nil, nil)

var peerAsnsListBySubscription* = Call_PeerAsnsListBySubscription_574224(
    name: "peerAsnsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/peerAsns",
    validator: validate_PeerAsnsListBySubscription_574225, base: "",
    url: url_PeerAsnsListBySubscription_574226, schemes: {Scheme.Https})
type
  Call_PeerAsnsCreateOrUpdate_574243 = ref object of OpenApiRestCall_573657
proc url_PeerAsnsCreateOrUpdate_574245(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "peerAsnName" in path, "`peerAsnName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Peering/peerAsns/"),
               (kind: VariableSegment, value: "peerAsnName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeerAsnsCreateOrUpdate_574244(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new peer ASN or updates an existing peer ASN with the specified name under the given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peerAsnName: JString (required)
  ##              : The peer ASN name.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peerAsnName` field"
  var valid_574246 = path.getOrDefault("peerAsnName")
  valid_574246 = validateParameter(valid_574246, JString, required = true,
                                 default = nil)
  if valid_574246 != nil:
    section.add "peerAsnName", valid_574246
  var valid_574247 = path.getOrDefault("subscriptionId")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "subscriptionId", valid_574247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574248 = query.getOrDefault("api-version")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "api-version", valid_574248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   peerAsn: JObject (required)
  ##          : The peer ASN.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574250: Call_PeerAsnsCreateOrUpdate_574243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new peer ASN or updates an existing peer ASN with the specified name under the given subscription.
  ## 
  let valid = call_574250.validator(path, query, header, formData, body)
  let scheme = call_574250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574250.url(scheme.get, call_574250.host, call_574250.base,
                         call_574250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574250, url, valid)

proc call*(call_574251: Call_PeerAsnsCreateOrUpdate_574243; peerAsnName: string;
          apiVersion: string; subscriptionId: string; peerAsn: JsonNode): Recallable =
  ## peerAsnsCreateOrUpdate
  ## Creates a new peer ASN or updates an existing peer ASN with the specified name under the given subscription.
  ##   peerAsnName: string (required)
  ##              : The peer ASN name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   peerAsn: JObject (required)
  ##          : The peer ASN.
  var path_574252 = newJObject()
  var query_574253 = newJObject()
  var body_574254 = newJObject()
  add(path_574252, "peerAsnName", newJString(peerAsnName))
  add(query_574253, "api-version", newJString(apiVersion))
  add(path_574252, "subscriptionId", newJString(subscriptionId))
  if peerAsn != nil:
    body_574254 = peerAsn
  result = call_574251.call(path_574252, query_574253, nil, nil, body_574254)

var peerAsnsCreateOrUpdate* = Call_PeerAsnsCreateOrUpdate_574243(
    name: "peerAsnsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/peerAsns/{peerAsnName}",
    validator: validate_PeerAsnsCreateOrUpdate_574244, base: "",
    url: url_PeerAsnsCreateOrUpdate_574245, schemes: {Scheme.Https})
type
  Call_PeerAsnsGet_574233 = ref object of OpenApiRestCall_573657
proc url_PeerAsnsGet_574235(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "peerAsnName" in path, "`peerAsnName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Peering/peerAsns/"),
               (kind: VariableSegment, value: "peerAsnName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeerAsnsGet_574234(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the peer ASN with the specified name under the given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peerAsnName: JString (required)
  ##              : The peer ASN name.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peerAsnName` field"
  var valid_574236 = path.getOrDefault("peerAsnName")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = nil)
  if valid_574236 != nil:
    section.add "peerAsnName", valid_574236
  var valid_574237 = path.getOrDefault("subscriptionId")
  valid_574237 = validateParameter(valid_574237, JString, required = true,
                                 default = nil)
  if valid_574237 != nil:
    section.add "subscriptionId", valid_574237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_574239: Call_PeerAsnsGet_574233; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the peer ASN with the specified name under the given subscription.
  ## 
  let valid = call_574239.validator(path, query, header, formData, body)
  let scheme = call_574239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574239.url(scheme.get, call_574239.host, call_574239.base,
                         call_574239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574239, url, valid)

proc call*(call_574240: Call_PeerAsnsGet_574233; peerAsnName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## peerAsnsGet
  ## Gets the peer ASN with the specified name under the given subscription.
  ##   peerAsnName: string (required)
  ##              : The peer ASN name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_574241 = newJObject()
  var query_574242 = newJObject()
  add(path_574241, "peerAsnName", newJString(peerAsnName))
  add(query_574242, "api-version", newJString(apiVersion))
  add(path_574241, "subscriptionId", newJString(subscriptionId))
  result = call_574240.call(path_574241, query_574242, nil, nil, nil)

var peerAsnsGet* = Call_PeerAsnsGet_574233(name: "peerAsnsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/peerAsns/{peerAsnName}",
                                        validator: validate_PeerAsnsGet_574234,
                                        base: "", url: url_PeerAsnsGet_574235,
                                        schemes: {Scheme.Https})
type
  Call_PeerAsnsDelete_574255 = ref object of OpenApiRestCall_573657
proc url_PeerAsnsDelete_574257(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "peerAsnName" in path, "`peerAsnName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Peering/peerAsns/"),
               (kind: VariableSegment, value: "peerAsnName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeerAsnsDelete_574256(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes an existing peer ASN with the specified name under the given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peerAsnName: JString (required)
  ##              : The peer ASN name.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peerAsnName` field"
  var valid_574258 = path.getOrDefault("peerAsnName")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "peerAsnName", valid_574258
  var valid_574259 = path.getOrDefault("subscriptionId")
  valid_574259 = validateParameter(valid_574259, JString, required = true,
                                 default = nil)
  if valid_574259 != nil:
    section.add "subscriptionId", valid_574259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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

proc call*(call_574261: Call_PeerAsnsDelete_574255; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing peer ASN with the specified name under the given subscription.
  ## 
  let valid = call_574261.validator(path, query, header, formData, body)
  let scheme = call_574261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574261.url(scheme.get, call_574261.host, call_574261.base,
                         call_574261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574261, url, valid)

proc call*(call_574262: Call_PeerAsnsDelete_574255; peerAsnName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## peerAsnsDelete
  ## Deletes an existing peer ASN with the specified name under the given subscription.
  ##   peerAsnName: string (required)
  ##              : The peer ASN name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_574263 = newJObject()
  var query_574264 = newJObject()
  add(path_574263, "peerAsnName", newJString(peerAsnName))
  add(query_574264, "api-version", newJString(apiVersion))
  add(path_574263, "subscriptionId", newJString(subscriptionId))
  result = call_574262.call(path_574263, query_574264, nil, nil, nil)

var peerAsnsDelete* = Call_PeerAsnsDelete_574255(name: "peerAsnsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/peerAsns/{peerAsnName}",
    validator: validate_PeerAsnsDelete_574256, base: "", url: url_PeerAsnsDelete_574257,
    schemes: {Scheme.Https})
type
  Call_PeeringLocationsList_574265 = ref object of OpenApiRestCall_573657
proc url_PeeringLocationsList_574267(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Peering/peeringLocations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeeringLocationsList_574266(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the available peering locations for the specified kind of peering.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574268 = path.getOrDefault("subscriptionId")
  valid_574268 = validateParameter(valid_574268, JString, required = true,
                                 default = nil)
  if valid_574268 != nil:
    section.add "subscriptionId", valid_574268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  ##   kind: JString (required)
  ##       : The kind of the peering.
  ##   directPeeringType: JString
  ##                    : The type of direct peering.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574269 = query.getOrDefault("api-version")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "api-version", valid_574269
  var valid_574270 = query.getOrDefault("kind")
  valid_574270 = validateParameter(valid_574270, JString, required = true,
                                 default = newJString("Direct"))
  if valid_574270 != nil:
    section.add "kind", valid_574270
  var valid_574271 = query.getOrDefault("directPeeringType")
  valid_574271 = validateParameter(valid_574271, JString, required = false,
                                 default = newJString("Edge"))
  if valid_574271 != nil:
    section.add "directPeeringType", valid_574271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574272: Call_PeeringLocationsList_574265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available peering locations for the specified kind of peering.
  ## 
  let valid = call_574272.validator(path, query, header, formData, body)
  let scheme = call_574272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574272.url(scheme.get, call_574272.host, call_574272.base,
                         call_574272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574272, url, valid)

proc call*(call_574273: Call_PeeringLocationsList_574265; apiVersion: string;
          subscriptionId: string; kind: string = "Direct";
          directPeeringType: string = "Edge"): Recallable =
  ## peeringLocationsList
  ## Lists all of the available peering locations for the specified kind of peering.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   kind: string (required)
  ##       : The kind of the peering.
  ##   directPeeringType: string
  ##                    : The type of direct peering.
  var path_574274 = newJObject()
  var query_574275 = newJObject()
  add(query_574275, "api-version", newJString(apiVersion))
  add(path_574274, "subscriptionId", newJString(subscriptionId))
  add(query_574275, "kind", newJString(kind))
  add(query_574275, "directPeeringType", newJString(directPeeringType))
  result = call_574273.call(path_574274, query_574275, nil, nil, nil)

var peeringLocationsList* = Call_PeeringLocationsList_574265(
    name: "peeringLocationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/peeringLocations",
    validator: validate_PeeringLocationsList_574266, base: "",
    url: url_PeeringLocationsList_574267, schemes: {Scheme.Https})
type
  Call_PeeringServiceLocationsList_574276 = ref object of OpenApiRestCall_573657
proc url_PeeringServiceLocationsList_574278(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Peering/peeringServiceLocations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeeringServiceLocationsList_574277(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the available peering service locations for the specified kind of peering.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574279 = path.getOrDefault("subscriptionId")
  valid_574279 = validateParameter(valid_574279, JString, required = true,
                                 default = nil)
  if valid_574279 != nil:
    section.add "subscriptionId", valid_574279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574280 = query.getOrDefault("api-version")
  valid_574280 = validateParameter(valid_574280, JString, required = true,
                                 default = nil)
  if valid_574280 != nil:
    section.add "api-version", valid_574280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574281: Call_PeeringServiceLocationsList_574276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available peering service locations for the specified kind of peering.
  ## 
  let valid = call_574281.validator(path, query, header, formData, body)
  let scheme = call_574281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574281.url(scheme.get, call_574281.host, call_574281.base,
                         call_574281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574281, url, valid)

proc call*(call_574282: Call_PeeringServiceLocationsList_574276;
          apiVersion: string; subscriptionId: string): Recallable =
  ## peeringServiceLocationsList
  ## Lists all of the available peering service locations for the specified kind of peering.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_574283 = newJObject()
  var query_574284 = newJObject()
  add(query_574284, "api-version", newJString(apiVersion))
  add(path_574283, "subscriptionId", newJString(subscriptionId))
  result = call_574282.call(path_574283, query_574284, nil, nil, nil)

var peeringServiceLocationsList* = Call_PeeringServiceLocationsList_574276(
    name: "peeringServiceLocationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/peeringServiceLocations",
    validator: validate_PeeringServiceLocationsList_574277, base: "",
    url: url_PeeringServiceLocationsList_574278, schemes: {Scheme.Https})
type
  Call_PeeringServiceProvidersList_574285 = ref object of OpenApiRestCall_573657
proc url_PeeringServiceProvidersList_574287(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Peering/peeringServiceProviders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeeringServiceProvidersList_574286(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the available peering service locations for the specified kind of peering.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574288 = path.getOrDefault("subscriptionId")
  valid_574288 = validateParameter(valid_574288, JString, required = true,
                                 default = nil)
  if valid_574288 != nil:
    section.add "subscriptionId", valid_574288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574289 = query.getOrDefault("api-version")
  valid_574289 = validateParameter(valid_574289, JString, required = true,
                                 default = nil)
  if valid_574289 != nil:
    section.add "api-version", valid_574289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574290: Call_PeeringServiceProvidersList_574285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available peering service locations for the specified kind of peering.
  ## 
  let valid = call_574290.validator(path, query, header, formData, body)
  let scheme = call_574290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574290.url(scheme.get, call_574290.host, call_574290.base,
                         call_574290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574290, url, valid)

proc call*(call_574291: Call_PeeringServiceProvidersList_574285;
          apiVersion: string; subscriptionId: string): Recallable =
  ## peeringServiceProvidersList
  ## Lists all of the available peering service locations for the specified kind of peering.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_574292 = newJObject()
  var query_574293 = newJObject()
  add(query_574293, "api-version", newJString(apiVersion))
  add(path_574292, "subscriptionId", newJString(subscriptionId))
  result = call_574291.call(path_574292, query_574293, nil, nil, nil)

var peeringServiceProvidersList* = Call_PeeringServiceProvidersList_574285(
    name: "peeringServiceProvidersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/peeringServiceProviders",
    validator: validate_PeeringServiceProvidersList_574286, base: "",
    url: url_PeeringServiceProvidersList_574287, schemes: {Scheme.Https})
type
  Call_PeeringServicesListBySubscription_574294 = ref object of OpenApiRestCall_573657
proc url_PeeringServicesListBySubscription_574296(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Peering/peeringServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeeringServicesListBySubscription_574295(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the peerings under the given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574297 = path.getOrDefault("subscriptionId")
  valid_574297 = validateParameter(valid_574297, JString, required = true,
                                 default = nil)
  if valid_574297 != nil:
    section.add "subscriptionId", valid_574297
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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

proc call*(call_574299: Call_PeeringServicesListBySubscription_574294;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all of the peerings under the given subscription.
  ## 
  let valid = call_574299.validator(path, query, header, formData, body)
  let scheme = call_574299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574299.url(scheme.get, call_574299.host, call_574299.base,
                         call_574299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574299, url, valid)

proc call*(call_574300: Call_PeeringServicesListBySubscription_574294;
          apiVersion: string; subscriptionId: string): Recallable =
  ## peeringServicesListBySubscription
  ## Lists all of the peerings under the given subscription.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_574301 = newJObject()
  var query_574302 = newJObject()
  add(query_574302, "api-version", newJString(apiVersion))
  add(path_574301, "subscriptionId", newJString(subscriptionId))
  result = call_574300.call(path_574301, query_574302, nil, nil, nil)

var peeringServicesListBySubscription* = Call_PeeringServicesListBySubscription_574294(
    name: "peeringServicesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/peeringServices",
    validator: validate_PeeringServicesListBySubscription_574295, base: "",
    url: url_PeeringServicesListBySubscription_574296, schemes: {Scheme.Https})
type
  Call_PeeringsListBySubscription_574303 = ref object of OpenApiRestCall_573657
proc url_PeeringsListBySubscription_574305(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Peering/peerings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeeringsListBySubscription_574304(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the peerings under the given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574306 = path.getOrDefault("subscriptionId")
  valid_574306 = validateParameter(valid_574306, JString, required = true,
                                 default = nil)
  if valid_574306 != nil:
    section.add "subscriptionId", valid_574306
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574307 = query.getOrDefault("api-version")
  valid_574307 = validateParameter(valid_574307, JString, required = true,
                                 default = nil)
  if valid_574307 != nil:
    section.add "api-version", valid_574307
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574308: Call_PeeringsListBySubscription_574303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the peerings under the given subscription.
  ## 
  let valid = call_574308.validator(path, query, header, formData, body)
  let scheme = call_574308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574308.url(scheme.get, call_574308.host, call_574308.base,
                         call_574308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574308, url, valid)

proc call*(call_574309: Call_PeeringsListBySubscription_574303; apiVersion: string;
          subscriptionId: string): Recallable =
  ## peeringsListBySubscription
  ## Lists all of the peerings under the given subscription.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_574310 = newJObject()
  var query_574311 = newJObject()
  add(query_574311, "api-version", newJString(apiVersion))
  add(path_574310, "subscriptionId", newJString(subscriptionId))
  result = call_574309.call(path_574310, query_574311, nil, nil, nil)

var peeringsListBySubscription* = Call_PeeringsListBySubscription_574303(
    name: "peeringsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/peerings",
    validator: validate_PeeringsListBySubscription_574304, base: "",
    url: url_PeeringsListBySubscription_574305, schemes: {Scheme.Https})
type
  Call_PeeringServicesListByResourceGroup_574312 = ref object of OpenApiRestCall_573657
proc url_PeeringServicesListByResourceGroup_574314(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Peering/peeringServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeeringServicesListByResourceGroup_574313(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the peering services under the given subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574315 = path.getOrDefault("resourceGroupName")
  valid_574315 = validateParameter(valid_574315, JString, required = true,
                                 default = nil)
  if valid_574315 != nil:
    section.add "resourceGroupName", valid_574315
  var valid_574316 = path.getOrDefault("subscriptionId")
  valid_574316 = validateParameter(valid_574316, JString, required = true,
                                 default = nil)
  if valid_574316 != nil:
    section.add "subscriptionId", valid_574316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574317 = query.getOrDefault("api-version")
  valid_574317 = validateParameter(valid_574317, JString, required = true,
                                 default = nil)
  if valid_574317 != nil:
    section.add "api-version", valid_574317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574318: Call_PeeringServicesListByResourceGroup_574312;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all of the peering services under the given subscription and resource group.
  ## 
  let valid = call_574318.validator(path, query, header, formData, body)
  let scheme = call_574318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574318.url(scheme.get, call_574318.host, call_574318.base,
                         call_574318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574318, url, valid)

proc call*(call_574319: Call_PeeringServicesListByResourceGroup_574312;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## peeringServicesListByResourceGroup
  ## Lists all of the peering services under the given subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_574320 = newJObject()
  var query_574321 = newJObject()
  add(path_574320, "resourceGroupName", newJString(resourceGroupName))
  add(query_574321, "api-version", newJString(apiVersion))
  add(path_574320, "subscriptionId", newJString(subscriptionId))
  result = call_574319.call(path_574320, query_574321, nil, nil, nil)

var peeringServicesListByResourceGroup* = Call_PeeringServicesListByResourceGroup_574312(
    name: "peeringServicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peeringServices",
    validator: validate_PeeringServicesListByResourceGroup_574313, base: "",
    url: url_PeeringServicesListByResourceGroup_574314, schemes: {Scheme.Https})
type
  Call_PeeringServicesCreateOrUpdate_574333 = ref object of OpenApiRestCall_573657
proc url_PeeringServicesCreateOrUpdate_574335(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "peeringServiceName" in path,
        "`peeringServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Peering/peeringServices/"),
               (kind: VariableSegment, value: "peeringServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeeringServicesCreateOrUpdate_574334(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new peering service or updates an existing peering with the specified name under the given subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringServiceName: JString (required)
  ##                     : The name of the peering service.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574336 = path.getOrDefault("resourceGroupName")
  valid_574336 = validateParameter(valid_574336, JString, required = true,
                                 default = nil)
  if valid_574336 != nil:
    section.add "resourceGroupName", valid_574336
  var valid_574337 = path.getOrDefault("peeringServiceName")
  valid_574337 = validateParameter(valid_574337, JString, required = true,
                                 default = nil)
  if valid_574337 != nil:
    section.add "peeringServiceName", valid_574337
  var valid_574338 = path.getOrDefault("subscriptionId")
  valid_574338 = validateParameter(valid_574338, JString, required = true,
                                 default = nil)
  if valid_574338 != nil:
    section.add "subscriptionId", valid_574338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574339 = query.getOrDefault("api-version")
  valid_574339 = validateParameter(valid_574339, JString, required = true,
                                 default = nil)
  if valid_574339 != nil:
    section.add "api-version", valid_574339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   peeringService: JObject (required)
  ##                 : The properties needed to create or update a peering service.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574341: Call_PeeringServicesCreateOrUpdate_574333; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new peering service or updates an existing peering with the specified name under the given subscription and resource group.
  ## 
  let valid = call_574341.validator(path, query, header, formData, body)
  let scheme = call_574341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574341.url(scheme.get, call_574341.host, call_574341.base,
                         call_574341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574341, url, valid)

proc call*(call_574342: Call_PeeringServicesCreateOrUpdate_574333;
          resourceGroupName: string; apiVersion: string; peeringServiceName: string;
          subscriptionId: string; peeringService: JsonNode): Recallable =
  ## peeringServicesCreateOrUpdate
  ## Creates a new peering service or updates an existing peering with the specified name under the given subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   peeringServiceName: string (required)
  ##                     : The name of the peering service.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   peeringService: JObject (required)
  ##                 : The properties needed to create or update a peering service.
  var path_574343 = newJObject()
  var query_574344 = newJObject()
  var body_574345 = newJObject()
  add(path_574343, "resourceGroupName", newJString(resourceGroupName))
  add(query_574344, "api-version", newJString(apiVersion))
  add(path_574343, "peeringServiceName", newJString(peeringServiceName))
  add(path_574343, "subscriptionId", newJString(subscriptionId))
  if peeringService != nil:
    body_574345 = peeringService
  result = call_574342.call(path_574343, query_574344, nil, nil, body_574345)

var peeringServicesCreateOrUpdate* = Call_PeeringServicesCreateOrUpdate_574333(
    name: "peeringServicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peeringServices/{peeringServiceName}",
    validator: validate_PeeringServicesCreateOrUpdate_574334, base: "",
    url: url_PeeringServicesCreateOrUpdate_574335, schemes: {Scheme.Https})
type
  Call_PeeringServicesGet_574322 = ref object of OpenApiRestCall_573657
proc url_PeeringServicesGet_574324(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "peeringServiceName" in path,
        "`peeringServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Peering/peeringServices/"),
               (kind: VariableSegment, value: "peeringServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeeringServicesGet_574323(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets an existing peering service with the specified name under the given subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringServiceName: JString (required)
  ##                     : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574325 = path.getOrDefault("resourceGroupName")
  valid_574325 = validateParameter(valid_574325, JString, required = true,
                                 default = nil)
  if valid_574325 != nil:
    section.add "resourceGroupName", valid_574325
  var valid_574326 = path.getOrDefault("peeringServiceName")
  valid_574326 = validateParameter(valid_574326, JString, required = true,
                                 default = nil)
  if valid_574326 != nil:
    section.add "peeringServiceName", valid_574326
  var valid_574327 = path.getOrDefault("subscriptionId")
  valid_574327 = validateParameter(valid_574327, JString, required = true,
                                 default = nil)
  if valid_574327 != nil:
    section.add "subscriptionId", valid_574327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574328 = query.getOrDefault("api-version")
  valid_574328 = validateParameter(valid_574328, JString, required = true,
                                 default = nil)
  if valid_574328 != nil:
    section.add "api-version", valid_574328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574329: Call_PeeringServicesGet_574322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing peering service with the specified name under the given subscription and resource group.
  ## 
  let valid = call_574329.validator(path, query, header, formData, body)
  let scheme = call_574329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574329.url(scheme.get, call_574329.host, call_574329.base,
                         call_574329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574329, url, valid)

proc call*(call_574330: Call_PeeringServicesGet_574322; resourceGroupName: string;
          apiVersion: string; peeringServiceName: string; subscriptionId: string): Recallable =
  ## peeringServicesGet
  ## Gets an existing peering service with the specified name under the given subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   peeringServiceName: string (required)
  ##                     : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_574331 = newJObject()
  var query_574332 = newJObject()
  add(path_574331, "resourceGroupName", newJString(resourceGroupName))
  add(query_574332, "api-version", newJString(apiVersion))
  add(path_574331, "peeringServiceName", newJString(peeringServiceName))
  add(path_574331, "subscriptionId", newJString(subscriptionId))
  result = call_574330.call(path_574331, query_574332, nil, nil, nil)

var peeringServicesGet* = Call_PeeringServicesGet_574322(
    name: "peeringServicesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peeringServices/{peeringServiceName}",
    validator: validate_PeeringServicesGet_574323, base: "",
    url: url_PeeringServicesGet_574324, schemes: {Scheme.Https})
type
  Call_PeeringServicesUpdate_574357 = ref object of OpenApiRestCall_573657
proc url_PeeringServicesUpdate_574359(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "peeringServiceName" in path,
        "`peeringServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Peering/peeringServices/"),
               (kind: VariableSegment, value: "peeringServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeeringServicesUpdate_574358(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates tags for a peering service with the specified name under the given subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringServiceName: JString (required)
  ##                     : The name of the peering service.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574360 = path.getOrDefault("resourceGroupName")
  valid_574360 = validateParameter(valid_574360, JString, required = true,
                                 default = nil)
  if valid_574360 != nil:
    section.add "resourceGroupName", valid_574360
  var valid_574361 = path.getOrDefault("peeringServiceName")
  valid_574361 = validateParameter(valid_574361, JString, required = true,
                                 default = nil)
  if valid_574361 != nil:
    section.add "peeringServiceName", valid_574361
  var valid_574362 = path.getOrDefault("subscriptionId")
  valid_574362 = validateParameter(valid_574362, JString, required = true,
                                 default = nil)
  if valid_574362 != nil:
    section.add "subscriptionId", valid_574362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574363 = query.getOrDefault("api-version")
  valid_574363 = validateParameter(valid_574363, JString, required = true,
                                 default = nil)
  if valid_574363 != nil:
    section.add "api-version", valid_574363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   tags: JObject (required)
  ##       : The resource tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574365: Call_PeeringServicesUpdate_574357; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates tags for a peering service with the specified name under the given subscription and resource group.
  ## 
  let valid = call_574365.validator(path, query, header, formData, body)
  let scheme = call_574365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574365.url(scheme.get, call_574365.host, call_574365.base,
                         call_574365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574365, url, valid)

proc call*(call_574366: Call_PeeringServicesUpdate_574357;
          resourceGroupName: string; apiVersion: string; peeringServiceName: string;
          subscriptionId: string; tags: JsonNode): Recallable =
  ## peeringServicesUpdate
  ## Updates tags for a peering service with the specified name under the given subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   peeringServiceName: string (required)
  ##                     : The name of the peering service.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   tags: JObject (required)
  ##       : The resource tags.
  var path_574367 = newJObject()
  var query_574368 = newJObject()
  var body_574369 = newJObject()
  add(path_574367, "resourceGroupName", newJString(resourceGroupName))
  add(query_574368, "api-version", newJString(apiVersion))
  add(path_574367, "peeringServiceName", newJString(peeringServiceName))
  add(path_574367, "subscriptionId", newJString(subscriptionId))
  if tags != nil:
    body_574369 = tags
  result = call_574366.call(path_574367, query_574368, nil, nil, body_574369)

var peeringServicesUpdate* = Call_PeeringServicesUpdate_574357(
    name: "peeringServicesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peeringServices/{peeringServiceName}",
    validator: validate_PeeringServicesUpdate_574358, base: "",
    url: url_PeeringServicesUpdate_574359, schemes: {Scheme.Https})
type
  Call_PeeringServicesDelete_574346 = ref object of OpenApiRestCall_573657
proc url_PeeringServicesDelete_574348(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "peeringServiceName" in path,
        "`peeringServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Peering/peeringServices/"),
               (kind: VariableSegment, value: "peeringServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeeringServicesDelete_574347(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing peering service with the specified name under the given subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringServiceName: JString (required)
  ##                     : The name of the peering service.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574349 = path.getOrDefault("resourceGroupName")
  valid_574349 = validateParameter(valid_574349, JString, required = true,
                                 default = nil)
  if valid_574349 != nil:
    section.add "resourceGroupName", valid_574349
  var valid_574350 = path.getOrDefault("peeringServiceName")
  valid_574350 = validateParameter(valid_574350, JString, required = true,
                                 default = nil)
  if valid_574350 != nil:
    section.add "peeringServiceName", valid_574350
  var valid_574351 = path.getOrDefault("subscriptionId")
  valid_574351 = validateParameter(valid_574351, JString, required = true,
                                 default = nil)
  if valid_574351 != nil:
    section.add "subscriptionId", valid_574351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574352 = query.getOrDefault("api-version")
  valid_574352 = validateParameter(valid_574352, JString, required = true,
                                 default = nil)
  if valid_574352 != nil:
    section.add "api-version", valid_574352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574353: Call_PeeringServicesDelete_574346; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing peering service with the specified name under the given subscription and resource group.
  ## 
  let valid = call_574353.validator(path, query, header, formData, body)
  let scheme = call_574353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574353.url(scheme.get, call_574353.host, call_574353.base,
                         call_574353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574353, url, valid)

proc call*(call_574354: Call_PeeringServicesDelete_574346;
          resourceGroupName: string; apiVersion: string; peeringServiceName: string;
          subscriptionId: string): Recallable =
  ## peeringServicesDelete
  ## Deletes an existing peering service with the specified name under the given subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   peeringServiceName: string (required)
  ##                     : The name of the peering service.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_574355 = newJObject()
  var query_574356 = newJObject()
  add(path_574355, "resourceGroupName", newJString(resourceGroupName))
  add(query_574356, "api-version", newJString(apiVersion))
  add(path_574355, "peeringServiceName", newJString(peeringServiceName))
  add(path_574355, "subscriptionId", newJString(subscriptionId))
  result = call_574354.call(path_574355, query_574356, nil, nil, nil)

var peeringServicesDelete* = Call_PeeringServicesDelete_574346(
    name: "peeringServicesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peeringServices/{peeringServiceName}",
    validator: validate_PeeringServicesDelete_574347, base: "",
    url: url_PeeringServicesDelete_574348, schemes: {Scheme.Https})
type
  Call_PrefixesListByPeeringService_574370 = ref object of OpenApiRestCall_573657
proc url_PrefixesListByPeeringService_574372(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "peeringServiceName" in path,
        "`peeringServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Peering/peeringServices/"),
               (kind: VariableSegment, value: "peeringServiceName"),
               (kind: ConstantSegment, value: "/prefixes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrefixesListByPeeringService_574371(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the peerings prefix in the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   peeringServiceName: JString (required)
  ##                     : The peering service name.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574373 = path.getOrDefault("resourceGroupName")
  valid_574373 = validateParameter(valid_574373, JString, required = true,
                                 default = nil)
  if valid_574373 != nil:
    section.add "resourceGroupName", valid_574373
  var valid_574374 = path.getOrDefault("peeringServiceName")
  valid_574374 = validateParameter(valid_574374, JString, required = true,
                                 default = nil)
  if valid_574374 != nil:
    section.add "peeringServiceName", valid_574374
  var valid_574375 = path.getOrDefault("subscriptionId")
  valid_574375 = validateParameter(valid_574375, JString, required = true,
                                 default = nil)
  if valid_574375 != nil:
    section.add "subscriptionId", valid_574375
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574376 = query.getOrDefault("api-version")
  valid_574376 = validateParameter(valid_574376, JString, required = true,
                                 default = nil)
  if valid_574376 != nil:
    section.add "api-version", valid_574376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574377: Call_PrefixesListByPeeringService_574370; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the peerings prefix in the resource group.
  ## 
  let valid = call_574377.validator(path, query, header, formData, body)
  let scheme = call_574377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574377.url(scheme.get, call_574377.host, call_574377.base,
                         call_574377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574377, url, valid)

proc call*(call_574378: Call_PrefixesListByPeeringService_574370;
          resourceGroupName: string; apiVersion: string; peeringServiceName: string;
          subscriptionId: string): Recallable =
  ## prefixesListByPeeringService
  ## Lists the peerings prefix in the resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   peeringServiceName: string (required)
  ##                     : The peering service name.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_574379 = newJObject()
  var query_574380 = newJObject()
  add(path_574379, "resourceGroupName", newJString(resourceGroupName))
  add(query_574380, "api-version", newJString(apiVersion))
  add(path_574379, "peeringServiceName", newJString(peeringServiceName))
  add(path_574379, "subscriptionId", newJString(subscriptionId))
  result = call_574378.call(path_574379, query_574380, nil, nil, nil)

var prefixesListByPeeringService* = Call_PrefixesListByPeeringService_574370(
    name: "prefixesListByPeeringService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peeringServices/{peeringServiceName}/prefixes",
    validator: validate_PrefixesListByPeeringService_574371, base: "",
    url: url_PrefixesListByPeeringService_574372, schemes: {Scheme.Https})
type
  Call_PeeringServicePrefixesCreateOrUpdate_574393 = ref object of OpenApiRestCall_573657
proc url_PeeringServicePrefixesCreateOrUpdate_574395(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "peeringServiceName" in path,
        "`peeringServiceName` is a required path parameter"
  assert "prefixName" in path, "`prefixName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Peering/peeringServices/"),
               (kind: VariableSegment, value: "peeringServiceName"),
               (kind: ConstantSegment, value: "/prefixes/"),
               (kind: VariableSegment, value: "prefixName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeeringServicePrefixesCreateOrUpdate_574394(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the peering prefix.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   peeringServiceName: JString (required)
  ##                     : The peering service name.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   prefixName: JString (required)
  ##             : The prefix name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574396 = path.getOrDefault("resourceGroupName")
  valid_574396 = validateParameter(valid_574396, JString, required = true,
                                 default = nil)
  if valid_574396 != nil:
    section.add "resourceGroupName", valid_574396
  var valid_574397 = path.getOrDefault("peeringServiceName")
  valid_574397 = validateParameter(valid_574397, JString, required = true,
                                 default = nil)
  if valid_574397 != nil:
    section.add "peeringServiceName", valid_574397
  var valid_574398 = path.getOrDefault("subscriptionId")
  valid_574398 = validateParameter(valid_574398, JString, required = true,
                                 default = nil)
  if valid_574398 != nil:
    section.add "subscriptionId", valid_574398
  var valid_574399 = path.getOrDefault("prefixName")
  valid_574399 = validateParameter(valid_574399, JString, required = true,
                                 default = nil)
  if valid_574399 != nil:
    section.add "prefixName", valid_574399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574400 = query.getOrDefault("api-version")
  valid_574400 = validateParameter(valid_574400, JString, required = true,
                                 default = nil)
  if valid_574400 != nil:
    section.add "api-version", valid_574400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   peeringServicePrefix: JObject (required)
  ##                       : The IP prefix for an peering
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574402: Call_PeeringServicePrefixesCreateOrUpdate_574393;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the peering prefix.
  ## 
  let valid = call_574402.validator(path, query, header, formData, body)
  let scheme = call_574402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574402.url(scheme.get, call_574402.host, call_574402.base,
                         call_574402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574402, url, valid)

proc call*(call_574403: Call_PeeringServicePrefixesCreateOrUpdate_574393;
          resourceGroupName: string; apiVersion: string; peeringServiceName: string;
          subscriptionId: string; peeringServicePrefix: JsonNode; prefixName: string): Recallable =
  ## peeringServicePrefixesCreateOrUpdate
  ## Creates or updates the peering prefix.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   peeringServiceName: string (required)
  ##                     : The peering service name.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   peeringServicePrefix: JObject (required)
  ##                       : The IP prefix for an peering
  ##   prefixName: string (required)
  ##             : The prefix name
  var path_574404 = newJObject()
  var query_574405 = newJObject()
  var body_574406 = newJObject()
  add(path_574404, "resourceGroupName", newJString(resourceGroupName))
  add(query_574405, "api-version", newJString(apiVersion))
  add(path_574404, "peeringServiceName", newJString(peeringServiceName))
  add(path_574404, "subscriptionId", newJString(subscriptionId))
  if peeringServicePrefix != nil:
    body_574406 = peeringServicePrefix
  add(path_574404, "prefixName", newJString(prefixName))
  result = call_574403.call(path_574404, query_574405, nil, nil, body_574406)

var peeringServicePrefixesCreateOrUpdate* = Call_PeeringServicePrefixesCreateOrUpdate_574393(
    name: "peeringServicePrefixesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peeringServices/{peeringServiceName}/prefixes/{prefixName}",
    validator: validate_PeeringServicePrefixesCreateOrUpdate_574394, base: "",
    url: url_PeeringServicePrefixesCreateOrUpdate_574395, schemes: {Scheme.Https})
type
  Call_PeeringServicePrefixesGet_574381 = ref object of OpenApiRestCall_573657
proc url_PeeringServicePrefixesGet_574383(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "peeringServiceName" in path,
        "`peeringServiceName` is a required path parameter"
  assert "prefixName" in path, "`prefixName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Peering/peeringServices/"),
               (kind: VariableSegment, value: "peeringServiceName"),
               (kind: ConstantSegment, value: "/prefixes/"),
               (kind: VariableSegment, value: "prefixName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeeringServicePrefixesGet_574382(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the peering service prefix.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   peeringServiceName: JString (required)
  ##                     : The peering service name.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   prefixName: JString (required)
  ##             : The prefix name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574384 = path.getOrDefault("resourceGroupName")
  valid_574384 = validateParameter(valid_574384, JString, required = true,
                                 default = nil)
  if valid_574384 != nil:
    section.add "resourceGroupName", valid_574384
  var valid_574385 = path.getOrDefault("peeringServiceName")
  valid_574385 = validateParameter(valid_574385, JString, required = true,
                                 default = nil)
  if valid_574385 != nil:
    section.add "peeringServiceName", valid_574385
  var valid_574386 = path.getOrDefault("subscriptionId")
  valid_574386 = validateParameter(valid_574386, JString, required = true,
                                 default = nil)
  if valid_574386 != nil:
    section.add "subscriptionId", valid_574386
  var valid_574387 = path.getOrDefault("prefixName")
  valid_574387 = validateParameter(valid_574387, JString, required = true,
                                 default = nil)
  if valid_574387 != nil:
    section.add "prefixName", valid_574387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574388 = query.getOrDefault("api-version")
  valid_574388 = validateParameter(valid_574388, JString, required = true,
                                 default = nil)
  if valid_574388 != nil:
    section.add "api-version", valid_574388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574389: Call_PeeringServicePrefixesGet_574381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the peering service prefix.
  ## 
  let valid = call_574389.validator(path, query, header, formData, body)
  let scheme = call_574389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574389.url(scheme.get, call_574389.host, call_574389.base,
                         call_574389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574389, url, valid)

proc call*(call_574390: Call_PeeringServicePrefixesGet_574381;
          resourceGroupName: string; apiVersion: string; peeringServiceName: string;
          subscriptionId: string; prefixName: string): Recallable =
  ## peeringServicePrefixesGet
  ## Gets the peering service prefix.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   peeringServiceName: string (required)
  ##                     : The peering service name.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   prefixName: string (required)
  ##             : The prefix name.
  var path_574391 = newJObject()
  var query_574392 = newJObject()
  add(path_574391, "resourceGroupName", newJString(resourceGroupName))
  add(query_574392, "api-version", newJString(apiVersion))
  add(path_574391, "peeringServiceName", newJString(peeringServiceName))
  add(path_574391, "subscriptionId", newJString(subscriptionId))
  add(path_574391, "prefixName", newJString(prefixName))
  result = call_574390.call(path_574391, query_574392, nil, nil, nil)

var peeringServicePrefixesGet* = Call_PeeringServicePrefixesGet_574381(
    name: "peeringServicePrefixesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peeringServices/{peeringServiceName}/prefixes/{prefixName}",
    validator: validate_PeeringServicePrefixesGet_574382, base: "",
    url: url_PeeringServicePrefixesGet_574383, schemes: {Scheme.Https})
type
  Call_PeeringServicePrefixesDelete_574407 = ref object of OpenApiRestCall_573657
proc url_PeeringServicePrefixesDelete_574409(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "peeringServiceName" in path,
        "`peeringServiceName` is a required path parameter"
  assert "prefixName" in path, "`prefixName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Peering/peeringServices/"),
               (kind: VariableSegment, value: "peeringServiceName"),
               (kind: ConstantSegment, value: "/prefixes/"),
               (kind: VariableSegment, value: "prefixName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeeringServicePrefixesDelete_574408(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## removes the peering prefix.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   peeringServiceName: JString (required)
  ##                     : The peering service name.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   prefixName: JString (required)
  ##             : The prefix name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574410 = path.getOrDefault("resourceGroupName")
  valid_574410 = validateParameter(valid_574410, JString, required = true,
                                 default = nil)
  if valid_574410 != nil:
    section.add "resourceGroupName", valid_574410
  var valid_574411 = path.getOrDefault("peeringServiceName")
  valid_574411 = validateParameter(valid_574411, JString, required = true,
                                 default = nil)
  if valid_574411 != nil:
    section.add "peeringServiceName", valid_574411
  var valid_574412 = path.getOrDefault("subscriptionId")
  valid_574412 = validateParameter(valid_574412, JString, required = true,
                                 default = nil)
  if valid_574412 != nil:
    section.add "subscriptionId", valid_574412
  var valid_574413 = path.getOrDefault("prefixName")
  valid_574413 = validateParameter(valid_574413, JString, required = true,
                                 default = nil)
  if valid_574413 != nil:
    section.add "prefixName", valid_574413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574414 = query.getOrDefault("api-version")
  valid_574414 = validateParameter(valid_574414, JString, required = true,
                                 default = nil)
  if valid_574414 != nil:
    section.add "api-version", valid_574414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574415: Call_PeeringServicePrefixesDelete_574407; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## removes the peering prefix.
  ## 
  let valid = call_574415.validator(path, query, header, formData, body)
  let scheme = call_574415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574415.url(scheme.get, call_574415.host, call_574415.base,
                         call_574415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574415, url, valid)

proc call*(call_574416: Call_PeeringServicePrefixesDelete_574407;
          resourceGroupName: string; apiVersion: string; peeringServiceName: string;
          subscriptionId: string; prefixName: string): Recallable =
  ## peeringServicePrefixesDelete
  ## removes the peering prefix.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   peeringServiceName: string (required)
  ##                     : The peering service name.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   prefixName: string (required)
  ##             : The prefix name
  var path_574417 = newJObject()
  var query_574418 = newJObject()
  add(path_574417, "resourceGroupName", newJString(resourceGroupName))
  add(query_574418, "api-version", newJString(apiVersion))
  add(path_574417, "peeringServiceName", newJString(peeringServiceName))
  add(path_574417, "subscriptionId", newJString(subscriptionId))
  add(path_574417, "prefixName", newJString(prefixName))
  result = call_574416.call(path_574417, query_574418, nil, nil, nil)

var peeringServicePrefixesDelete* = Call_PeeringServicePrefixesDelete_574407(
    name: "peeringServicePrefixesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peeringServices/{peeringServiceName}/prefixes/{prefixName}",
    validator: validate_PeeringServicePrefixesDelete_574408, base: "",
    url: url_PeeringServicePrefixesDelete_574409, schemes: {Scheme.Https})
type
  Call_PeeringsListByResourceGroup_574419 = ref object of OpenApiRestCall_573657
proc url_PeeringsListByResourceGroup_574421(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Peering/peerings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeeringsListByResourceGroup_574420(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the peerings under the given subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574422 = path.getOrDefault("resourceGroupName")
  valid_574422 = validateParameter(valid_574422, JString, required = true,
                                 default = nil)
  if valid_574422 != nil:
    section.add "resourceGroupName", valid_574422
  var valid_574423 = path.getOrDefault("subscriptionId")
  valid_574423 = validateParameter(valid_574423, JString, required = true,
                                 default = nil)
  if valid_574423 != nil:
    section.add "subscriptionId", valid_574423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574424 = query.getOrDefault("api-version")
  valid_574424 = validateParameter(valid_574424, JString, required = true,
                                 default = nil)
  if valid_574424 != nil:
    section.add "api-version", valid_574424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574425: Call_PeeringsListByResourceGroup_574419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the peerings under the given subscription and resource group.
  ## 
  let valid = call_574425.validator(path, query, header, formData, body)
  let scheme = call_574425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574425.url(scheme.get, call_574425.host, call_574425.base,
                         call_574425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574425, url, valid)

proc call*(call_574426: Call_PeeringsListByResourceGroup_574419;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## peeringsListByResourceGroup
  ## Lists all of the peerings under the given subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_574427 = newJObject()
  var query_574428 = newJObject()
  add(path_574427, "resourceGroupName", newJString(resourceGroupName))
  add(query_574428, "api-version", newJString(apiVersion))
  add(path_574427, "subscriptionId", newJString(subscriptionId))
  result = call_574426.call(path_574427, query_574428, nil, nil, nil)

var peeringsListByResourceGroup* = Call_PeeringsListByResourceGroup_574419(
    name: "peeringsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peerings",
    validator: validate_PeeringsListByResourceGroup_574420, base: "",
    url: url_PeeringsListByResourceGroup_574421, schemes: {Scheme.Https})
type
  Call_PeeringsCreateOrUpdate_574440 = ref object of OpenApiRestCall_573657
proc url_PeeringsCreateOrUpdate_574442(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "peeringName" in path, "`peeringName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Peering/peerings/"),
               (kind: VariableSegment, value: "peeringName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeeringsCreateOrUpdate_574441(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new peering or updates an existing peering with the specified name under the given subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574443 = path.getOrDefault("resourceGroupName")
  valid_574443 = validateParameter(valid_574443, JString, required = true,
                                 default = nil)
  if valid_574443 != nil:
    section.add "resourceGroupName", valid_574443
  var valid_574444 = path.getOrDefault("peeringName")
  valid_574444 = validateParameter(valid_574444, JString, required = true,
                                 default = nil)
  if valid_574444 != nil:
    section.add "peeringName", valid_574444
  var valid_574445 = path.getOrDefault("subscriptionId")
  valid_574445 = validateParameter(valid_574445, JString, required = true,
                                 default = nil)
  if valid_574445 != nil:
    section.add "subscriptionId", valid_574445
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574446 = query.getOrDefault("api-version")
  valid_574446 = validateParameter(valid_574446, JString, required = true,
                                 default = nil)
  if valid_574446 != nil:
    section.add "api-version", valid_574446
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   peering: JObject (required)
  ##          : The properties needed to create or update a peering.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574448: Call_PeeringsCreateOrUpdate_574440; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new peering or updates an existing peering with the specified name under the given subscription and resource group.
  ## 
  let valid = call_574448.validator(path, query, header, formData, body)
  let scheme = call_574448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574448.url(scheme.get, call_574448.host, call_574448.base,
                         call_574448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574448, url, valid)

proc call*(call_574449: Call_PeeringsCreateOrUpdate_574440;
          resourceGroupName: string; apiVersion: string; peeringName: string;
          subscriptionId: string; peering: JsonNode): Recallable =
  ## peeringsCreateOrUpdate
  ## Creates a new peering or updates an existing peering with the specified name under the given subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   peering: JObject (required)
  ##          : The properties needed to create or update a peering.
  var path_574450 = newJObject()
  var query_574451 = newJObject()
  var body_574452 = newJObject()
  add(path_574450, "resourceGroupName", newJString(resourceGroupName))
  add(query_574451, "api-version", newJString(apiVersion))
  add(path_574450, "peeringName", newJString(peeringName))
  add(path_574450, "subscriptionId", newJString(subscriptionId))
  if peering != nil:
    body_574452 = peering
  result = call_574449.call(path_574450, query_574451, nil, nil, body_574452)

var peeringsCreateOrUpdate* = Call_PeeringsCreateOrUpdate_574440(
    name: "peeringsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peerings/{peeringName}",
    validator: validate_PeeringsCreateOrUpdate_574441, base: "",
    url: url_PeeringsCreateOrUpdate_574442, schemes: {Scheme.Https})
type
  Call_PeeringsGet_574429 = ref object of OpenApiRestCall_573657
proc url_PeeringsGet_574431(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "peeringName" in path, "`peeringName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Peering/peerings/"),
               (kind: VariableSegment, value: "peeringName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeeringsGet_574430(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an existing peering with the specified name under the given subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574432 = path.getOrDefault("resourceGroupName")
  valid_574432 = validateParameter(valid_574432, JString, required = true,
                                 default = nil)
  if valid_574432 != nil:
    section.add "resourceGroupName", valid_574432
  var valid_574433 = path.getOrDefault("peeringName")
  valid_574433 = validateParameter(valid_574433, JString, required = true,
                                 default = nil)
  if valid_574433 != nil:
    section.add "peeringName", valid_574433
  var valid_574434 = path.getOrDefault("subscriptionId")
  valid_574434 = validateParameter(valid_574434, JString, required = true,
                                 default = nil)
  if valid_574434 != nil:
    section.add "subscriptionId", valid_574434
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574435 = query.getOrDefault("api-version")
  valid_574435 = validateParameter(valid_574435, JString, required = true,
                                 default = nil)
  if valid_574435 != nil:
    section.add "api-version", valid_574435
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574436: Call_PeeringsGet_574429; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing peering with the specified name under the given subscription and resource group.
  ## 
  let valid = call_574436.validator(path, query, header, formData, body)
  let scheme = call_574436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574436.url(scheme.get, call_574436.host, call_574436.base,
                         call_574436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574436, url, valid)

proc call*(call_574437: Call_PeeringsGet_574429; resourceGroupName: string;
          apiVersion: string; peeringName: string; subscriptionId: string): Recallable =
  ## peeringsGet
  ## Gets an existing peering with the specified name under the given subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_574438 = newJObject()
  var query_574439 = newJObject()
  add(path_574438, "resourceGroupName", newJString(resourceGroupName))
  add(query_574439, "api-version", newJString(apiVersion))
  add(path_574438, "peeringName", newJString(peeringName))
  add(path_574438, "subscriptionId", newJString(subscriptionId))
  result = call_574437.call(path_574438, query_574439, nil, nil, nil)

var peeringsGet* = Call_PeeringsGet_574429(name: "peeringsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peerings/{peeringName}",
                                        validator: validate_PeeringsGet_574430,
                                        base: "", url: url_PeeringsGet_574431,
                                        schemes: {Scheme.Https})
type
  Call_PeeringsUpdate_574464 = ref object of OpenApiRestCall_573657
proc url_PeeringsUpdate_574466(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "peeringName" in path, "`peeringName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Peering/peerings/"),
               (kind: VariableSegment, value: "peeringName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeeringsUpdate_574465(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates tags for a peering with the specified name under the given subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574467 = path.getOrDefault("resourceGroupName")
  valid_574467 = validateParameter(valid_574467, JString, required = true,
                                 default = nil)
  if valid_574467 != nil:
    section.add "resourceGroupName", valid_574467
  var valid_574468 = path.getOrDefault("peeringName")
  valid_574468 = validateParameter(valid_574468, JString, required = true,
                                 default = nil)
  if valid_574468 != nil:
    section.add "peeringName", valid_574468
  var valid_574469 = path.getOrDefault("subscriptionId")
  valid_574469 = validateParameter(valid_574469, JString, required = true,
                                 default = nil)
  if valid_574469 != nil:
    section.add "subscriptionId", valid_574469
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574470 = query.getOrDefault("api-version")
  valid_574470 = validateParameter(valid_574470, JString, required = true,
                                 default = nil)
  if valid_574470 != nil:
    section.add "api-version", valid_574470
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   tags: JObject (required)
  ##       : The resource tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574472: Call_PeeringsUpdate_574464; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates tags for a peering with the specified name under the given subscription and resource group.
  ## 
  let valid = call_574472.validator(path, query, header, formData, body)
  let scheme = call_574472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574472.url(scheme.get, call_574472.host, call_574472.base,
                         call_574472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574472, url, valid)

proc call*(call_574473: Call_PeeringsUpdate_574464; resourceGroupName: string;
          apiVersion: string; peeringName: string; subscriptionId: string;
          tags: JsonNode): Recallable =
  ## peeringsUpdate
  ## Updates tags for a peering with the specified name under the given subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   tags: JObject (required)
  ##       : The resource tags.
  var path_574474 = newJObject()
  var query_574475 = newJObject()
  var body_574476 = newJObject()
  add(path_574474, "resourceGroupName", newJString(resourceGroupName))
  add(query_574475, "api-version", newJString(apiVersion))
  add(path_574474, "peeringName", newJString(peeringName))
  add(path_574474, "subscriptionId", newJString(subscriptionId))
  if tags != nil:
    body_574476 = tags
  result = call_574473.call(path_574474, query_574475, nil, nil, body_574476)

var peeringsUpdate* = Call_PeeringsUpdate_574464(name: "peeringsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peerings/{peeringName}",
    validator: validate_PeeringsUpdate_574465, base: "", url: url_PeeringsUpdate_574466,
    schemes: {Scheme.Https})
type
  Call_PeeringsDelete_574453 = ref object of OpenApiRestCall_573657
proc url_PeeringsDelete_574455(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "peeringName" in path, "`peeringName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Peering/peerings/"),
               (kind: VariableSegment, value: "peeringName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeeringsDelete_574454(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes an existing peering with the specified name under the given subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574456 = path.getOrDefault("resourceGroupName")
  valid_574456 = validateParameter(valid_574456, JString, required = true,
                                 default = nil)
  if valid_574456 != nil:
    section.add "resourceGroupName", valid_574456
  var valid_574457 = path.getOrDefault("peeringName")
  valid_574457 = validateParameter(valid_574457, JString, required = true,
                                 default = nil)
  if valid_574457 != nil:
    section.add "peeringName", valid_574457
  var valid_574458 = path.getOrDefault("subscriptionId")
  valid_574458 = validateParameter(valid_574458, JString, required = true,
                                 default = nil)
  if valid_574458 != nil:
    section.add "subscriptionId", valid_574458
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574459 = query.getOrDefault("api-version")
  valid_574459 = validateParameter(valid_574459, JString, required = true,
                                 default = nil)
  if valid_574459 != nil:
    section.add "api-version", valid_574459
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574460: Call_PeeringsDelete_574453; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing peering with the specified name under the given subscription and resource group.
  ## 
  let valid = call_574460.validator(path, query, header, formData, body)
  let scheme = call_574460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574460.url(scheme.get, call_574460.host, call_574460.base,
                         call_574460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574460, url, valid)

proc call*(call_574461: Call_PeeringsDelete_574453; resourceGroupName: string;
          apiVersion: string; peeringName: string; subscriptionId: string): Recallable =
  ## peeringsDelete
  ## Deletes an existing peering with the specified name under the given subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_574462 = newJObject()
  var query_574463 = newJObject()
  add(path_574462, "resourceGroupName", newJString(resourceGroupName))
  add(query_574463, "api-version", newJString(apiVersion))
  add(path_574462, "peeringName", newJString(peeringName))
  add(path_574462, "subscriptionId", newJString(subscriptionId))
  result = call_574461.call(path_574462, query_574463, nil, nil, nil)

var peeringsDelete* = Call_PeeringsDelete_574453(name: "peeringsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peerings/{peeringName}",
    validator: validate_PeeringsDelete_574454, base: "", url: url_PeeringsDelete_574455,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
