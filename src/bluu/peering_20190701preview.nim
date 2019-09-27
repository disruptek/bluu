
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: PeeringManagementClient
## version: 2019-07-01-preview
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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "peering"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593646 = ref object of OpenApiRestCall_593424
proc url_OperationsList_593648(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593647(path: JsonNode; query: JsonNode;
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
  var valid_593807 = query.getOrDefault("api-version")
  valid_593807 = validateParameter(valid_593807, JString, required = true,
                                 default = nil)
  if valid_593807 != nil:
    section.add "api-version", valid_593807
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593830: Call_OperationsList_593646; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available API operations for peering resources.
  ## 
  let valid = call_593830.validator(path, query, header, formData, body)
  let scheme = call_593830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593830.url(scheme.get, call_593830.host, call_593830.base,
                         call_593830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593830, url, valid)

proc call*(call_593901: Call_OperationsList_593646; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available API operations for peering resources.
  ##   apiVersion: string (required)
  ##             : The client API version.
  var query_593902 = newJObject()
  add(query_593902, "api-version", newJString(apiVersion))
  result = call_593901.call(nil, query_593902, nil, nil, nil)

var operationsList* = Call_OperationsList_593646(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Peering/operations",
    validator: validate_OperationsList_593647, base: "", url: url_OperationsList_593648,
    schemes: {Scheme.Https})
type
  Call_CheckServiceProviderAvailability_593942 = ref object of OpenApiRestCall_593424
proc url_CheckServiceProviderAvailability_593944(protocol: Scheme; host: string;
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

proc validate_CheckServiceProviderAvailability_593943(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks if the peering service provider is present within 1000 distance of customer's location
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593959 = path.getOrDefault("subscriptionId")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = nil)
  if valid_593959 != nil:
    section.add "subscriptionId", valid_593959
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593960 = query.getOrDefault("api-version")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "api-version", valid_593960
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   checkServiceProviderAvailabilityInput: JObject (required)
  ##                                        : The CheckServiceProviderAvailabilityInput.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593962: Call_CheckServiceProviderAvailability_593942;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks if the peering service provider is present within 1000 distance of customer's location
  ## 
  let valid = call_593962.validator(path, query, header, formData, body)
  let scheme = call_593962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593962.url(scheme.get, call_593962.host, call_593962.base,
                         call_593962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593962, url, valid)

proc call*(call_593963: Call_CheckServiceProviderAvailability_593942;
          apiVersion: string; subscriptionId: string;
          checkServiceProviderAvailabilityInput: JsonNode): Recallable =
  ## checkServiceProviderAvailability
  ## Checks if the peering service provider is present within 1000 distance of customer's location
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   checkServiceProviderAvailabilityInput: JObject (required)
  ##                                        : The CheckServiceProviderAvailabilityInput.
  var path_593964 = newJObject()
  var query_593965 = newJObject()
  var body_593966 = newJObject()
  add(query_593965, "api-version", newJString(apiVersion))
  add(path_593964, "subscriptionId", newJString(subscriptionId))
  if checkServiceProviderAvailabilityInput != nil:
    body_593966 = checkServiceProviderAvailabilityInput
  result = call_593963.call(path_593964, query_593965, nil, nil, body_593966)

var checkServiceProviderAvailability* = Call_CheckServiceProviderAvailability_593942(
    name: "checkServiceProviderAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/CheckServiceProviderAvailability",
    validator: validate_CheckServiceProviderAvailability_593943, base: "",
    url: url_CheckServiceProviderAvailability_593944, schemes: {Scheme.Https})
type
  Call_LegacyPeeringsList_593967 = ref object of OpenApiRestCall_593424
proc url_LegacyPeeringsList_593969(protocol: Scheme; host: string; base: string;
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

proc validate_LegacyPeeringsList_593968(path: JsonNode; query: JsonNode;
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
  var valid_593970 = path.getOrDefault("subscriptionId")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "subscriptionId", valid_593970
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
  var valid_593971 = query.getOrDefault("api-version")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "api-version", valid_593971
  var valid_593985 = query.getOrDefault("kind")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = newJString("Direct"))
  if valid_593985 != nil:
    section.add "kind", valid_593985
  var valid_593986 = query.getOrDefault("peeringLocation")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "peeringLocation", valid_593986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593987: Call_LegacyPeeringsList_593967; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the legacy peerings under the given subscription matching the specified kind and location.
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_LegacyPeeringsList_593967; apiVersion: string;
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
  var path_593989 = newJObject()
  var query_593990 = newJObject()
  add(query_593990, "api-version", newJString(apiVersion))
  add(path_593989, "subscriptionId", newJString(subscriptionId))
  add(query_593990, "kind", newJString(kind))
  add(query_593990, "peeringLocation", newJString(peeringLocation))
  result = call_593988.call(path_593989, query_593990, nil, nil, nil)

var legacyPeeringsList* = Call_LegacyPeeringsList_593967(
    name: "legacyPeeringsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/legacyPeerings",
    validator: validate_LegacyPeeringsList_593968, base: "",
    url: url_LegacyPeeringsList_593969, schemes: {Scheme.Https})
type
  Call_PeerAsnsListBySubscription_593991 = ref object of OpenApiRestCall_593424
proc url_PeerAsnsListBySubscription_593993(protocol: Scheme; host: string;
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

proc validate_PeerAsnsListBySubscription_593992(path: JsonNode; query: JsonNode;
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
  var valid_593994 = path.getOrDefault("subscriptionId")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "subscriptionId", valid_593994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593995 = query.getOrDefault("api-version")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "api-version", valid_593995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593996: Call_PeerAsnsListBySubscription_593991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the peer ASNs under the given subscription.
  ## 
  let valid = call_593996.validator(path, query, header, formData, body)
  let scheme = call_593996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593996.url(scheme.get, call_593996.host, call_593996.base,
                         call_593996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593996, url, valid)

proc call*(call_593997: Call_PeerAsnsListBySubscription_593991; apiVersion: string;
          subscriptionId: string): Recallable =
  ## peerAsnsListBySubscription
  ## Lists all of the peer ASNs under the given subscription.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_593998 = newJObject()
  var query_593999 = newJObject()
  add(query_593999, "api-version", newJString(apiVersion))
  add(path_593998, "subscriptionId", newJString(subscriptionId))
  result = call_593997.call(path_593998, query_593999, nil, nil, nil)

var peerAsnsListBySubscription* = Call_PeerAsnsListBySubscription_593991(
    name: "peerAsnsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/peerAsns",
    validator: validate_PeerAsnsListBySubscription_593992, base: "",
    url: url_PeerAsnsListBySubscription_593993, schemes: {Scheme.Https})
type
  Call_PeerAsnsCreateOrUpdate_594010 = ref object of OpenApiRestCall_593424
proc url_PeerAsnsCreateOrUpdate_594012(protocol: Scheme; host: string; base: string;
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

proc validate_PeerAsnsCreateOrUpdate_594011(path: JsonNode; query: JsonNode;
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
  var valid_594013 = path.getOrDefault("peerAsnName")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "peerAsnName", valid_594013
  var valid_594014 = path.getOrDefault("subscriptionId")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "subscriptionId", valid_594014
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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
  ## parameters in `body` object:
  ##   peerAsn: JObject (required)
  ##          : The peer ASN.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594017: Call_PeerAsnsCreateOrUpdate_594010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new peer ASN or updates an existing peer ASN with the specified name under the given subscription.
  ## 
  let valid = call_594017.validator(path, query, header, formData, body)
  let scheme = call_594017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594017.url(scheme.get, call_594017.host, call_594017.base,
                         call_594017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594017, url, valid)

proc call*(call_594018: Call_PeerAsnsCreateOrUpdate_594010; peerAsnName: string;
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
  var path_594019 = newJObject()
  var query_594020 = newJObject()
  var body_594021 = newJObject()
  add(path_594019, "peerAsnName", newJString(peerAsnName))
  add(query_594020, "api-version", newJString(apiVersion))
  add(path_594019, "subscriptionId", newJString(subscriptionId))
  if peerAsn != nil:
    body_594021 = peerAsn
  result = call_594018.call(path_594019, query_594020, nil, nil, body_594021)

var peerAsnsCreateOrUpdate* = Call_PeerAsnsCreateOrUpdate_594010(
    name: "peerAsnsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/peerAsns/{peerAsnName}",
    validator: validate_PeerAsnsCreateOrUpdate_594011, base: "",
    url: url_PeerAsnsCreateOrUpdate_594012, schemes: {Scheme.Https})
type
  Call_PeerAsnsGet_594000 = ref object of OpenApiRestCall_593424
proc url_PeerAsnsGet_594002(protocol: Scheme; host: string; base: string;
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

proc validate_PeerAsnsGet_594001(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594003 = path.getOrDefault("peerAsnName")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "peerAsnName", valid_594003
  var valid_594004 = path.getOrDefault("subscriptionId")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "subscriptionId", valid_594004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594005 = query.getOrDefault("api-version")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "api-version", valid_594005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594006: Call_PeerAsnsGet_594000; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the peer ASN with the specified name under the given subscription.
  ## 
  let valid = call_594006.validator(path, query, header, formData, body)
  let scheme = call_594006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594006.url(scheme.get, call_594006.host, call_594006.base,
                         call_594006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594006, url, valid)

proc call*(call_594007: Call_PeerAsnsGet_594000; peerAsnName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## peerAsnsGet
  ## Gets the peer ASN with the specified name under the given subscription.
  ##   peerAsnName: string (required)
  ##              : The peer ASN name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_594008 = newJObject()
  var query_594009 = newJObject()
  add(path_594008, "peerAsnName", newJString(peerAsnName))
  add(query_594009, "api-version", newJString(apiVersion))
  add(path_594008, "subscriptionId", newJString(subscriptionId))
  result = call_594007.call(path_594008, query_594009, nil, nil, nil)

var peerAsnsGet* = Call_PeerAsnsGet_594000(name: "peerAsnsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/peerAsns/{peerAsnName}",
                                        validator: validate_PeerAsnsGet_594001,
                                        base: "", url: url_PeerAsnsGet_594002,
                                        schemes: {Scheme.Https})
type
  Call_PeerAsnsDelete_594022 = ref object of OpenApiRestCall_593424
proc url_PeerAsnsDelete_594024(protocol: Scheme; host: string; base: string;
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

proc validate_PeerAsnsDelete_594023(path: JsonNode; query: JsonNode;
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
  var valid_594025 = path.getOrDefault("peerAsnName")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "peerAsnName", valid_594025
  var valid_594026 = path.getOrDefault("subscriptionId")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "subscriptionId", valid_594026
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594027 = query.getOrDefault("api-version")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "api-version", valid_594027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594028: Call_PeerAsnsDelete_594022; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing peer ASN with the specified name under the given subscription.
  ## 
  let valid = call_594028.validator(path, query, header, formData, body)
  let scheme = call_594028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594028.url(scheme.get, call_594028.host, call_594028.base,
                         call_594028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594028, url, valid)

proc call*(call_594029: Call_PeerAsnsDelete_594022; peerAsnName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## peerAsnsDelete
  ## Deletes an existing peer ASN with the specified name under the given subscription.
  ##   peerAsnName: string (required)
  ##              : The peer ASN name.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_594030 = newJObject()
  var query_594031 = newJObject()
  add(path_594030, "peerAsnName", newJString(peerAsnName))
  add(query_594031, "api-version", newJString(apiVersion))
  add(path_594030, "subscriptionId", newJString(subscriptionId))
  result = call_594029.call(path_594030, query_594031, nil, nil, nil)

var peerAsnsDelete* = Call_PeerAsnsDelete_594022(name: "peerAsnsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/peerAsns/{peerAsnName}",
    validator: validate_PeerAsnsDelete_594023, base: "", url: url_PeerAsnsDelete_594024,
    schemes: {Scheme.Https})
type
  Call_PeeringLocationsList_594032 = ref object of OpenApiRestCall_593424
proc url_PeeringLocationsList_594034(protocol: Scheme; host: string; base: string;
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

proc validate_PeeringLocationsList_594033(path: JsonNode; query: JsonNode;
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
  var valid_594035 = path.getOrDefault("subscriptionId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "subscriptionId", valid_594035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  ##   kind: JString (required)
  ##       : The kind of the peering.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594036 = query.getOrDefault("api-version")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "api-version", valid_594036
  var valid_594037 = query.getOrDefault("kind")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = newJString("Direct"))
  if valid_594037 != nil:
    section.add "kind", valid_594037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594038: Call_PeeringLocationsList_594032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available peering locations for the specified kind of peering.
  ## 
  let valid = call_594038.validator(path, query, header, formData, body)
  let scheme = call_594038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594038.url(scheme.get, call_594038.host, call_594038.base,
                         call_594038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594038, url, valid)

proc call*(call_594039: Call_PeeringLocationsList_594032; apiVersion: string;
          subscriptionId: string; kind: string = "Direct"): Recallable =
  ## peeringLocationsList
  ## Lists all of the available peering locations for the specified kind of peering.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   kind: string (required)
  ##       : The kind of the peering.
  var path_594040 = newJObject()
  var query_594041 = newJObject()
  add(query_594041, "api-version", newJString(apiVersion))
  add(path_594040, "subscriptionId", newJString(subscriptionId))
  add(query_594041, "kind", newJString(kind))
  result = call_594039.call(path_594040, query_594041, nil, nil, nil)

var peeringLocationsList* = Call_PeeringLocationsList_594032(
    name: "peeringLocationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/peeringLocations",
    validator: validate_PeeringLocationsList_594033, base: "",
    url: url_PeeringLocationsList_594034, schemes: {Scheme.Https})
type
  Call_PeeringServiceLocationsList_594042 = ref object of OpenApiRestCall_593424
proc url_PeeringServiceLocationsList_594044(protocol: Scheme; host: string;
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

proc validate_PeeringServiceLocationsList_594043(path: JsonNode; query: JsonNode;
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
  var valid_594045 = path.getOrDefault("subscriptionId")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "subscriptionId", valid_594045
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594046 = query.getOrDefault("api-version")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "api-version", valid_594046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594047: Call_PeeringServiceLocationsList_594042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available peering service locations for the specified kind of peering.
  ## 
  let valid = call_594047.validator(path, query, header, formData, body)
  let scheme = call_594047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594047.url(scheme.get, call_594047.host, call_594047.base,
                         call_594047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594047, url, valid)

proc call*(call_594048: Call_PeeringServiceLocationsList_594042;
          apiVersion: string; subscriptionId: string): Recallable =
  ## peeringServiceLocationsList
  ## Lists all of the available peering service locations for the specified kind of peering.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_594049 = newJObject()
  var query_594050 = newJObject()
  add(query_594050, "api-version", newJString(apiVersion))
  add(path_594049, "subscriptionId", newJString(subscriptionId))
  result = call_594048.call(path_594049, query_594050, nil, nil, nil)

var peeringServiceLocationsList* = Call_PeeringServiceLocationsList_594042(
    name: "peeringServiceLocationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/peeringServiceLocations",
    validator: validate_PeeringServiceLocationsList_594043, base: "",
    url: url_PeeringServiceLocationsList_594044, schemes: {Scheme.Https})
type
  Call_PeeringServiceProvidersList_594051 = ref object of OpenApiRestCall_593424
proc url_PeeringServiceProvidersList_594053(protocol: Scheme; host: string;
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

proc validate_PeeringServiceProvidersList_594052(path: JsonNode; query: JsonNode;
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
  var valid_594054 = path.getOrDefault("subscriptionId")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "subscriptionId", valid_594054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594055 = query.getOrDefault("api-version")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "api-version", valid_594055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594056: Call_PeeringServiceProvidersList_594051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available peering service locations for the specified kind of peering.
  ## 
  let valid = call_594056.validator(path, query, header, formData, body)
  let scheme = call_594056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594056.url(scheme.get, call_594056.host, call_594056.base,
                         call_594056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594056, url, valid)

proc call*(call_594057: Call_PeeringServiceProvidersList_594051;
          apiVersion: string; subscriptionId: string): Recallable =
  ## peeringServiceProvidersList
  ## Lists all of the available peering service locations for the specified kind of peering.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_594058 = newJObject()
  var query_594059 = newJObject()
  add(query_594059, "api-version", newJString(apiVersion))
  add(path_594058, "subscriptionId", newJString(subscriptionId))
  result = call_594057.call(path_594058, query_594059, nil, nil, nil)

var peeringServiceProvidersList* = Call_PeeringServiceProvidersList_594051(
    name: "peeringServiceProvidersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/peeringServiceProviders",
    validator: validate_PeeringServiceProvidersList_594052, base: "",
    url: url_PeeringServiceProvidersList_594053, schemes: {Scheme.Https})
type
  Call_PeeringServicesListBySubscription_594060 = ref object of OpenApiRestCall_593424
proc url_PeeringServicesListBySubscription_594062(protocol: Scheme; host: string;
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

proc validate_PeeringServicesListBySubscription_594061(path: JsonNode;
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
  var valid_594063 = path.getOrDefault("subscriptionId")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "subscriptionId", valid_594063
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594064 = query.getOrDefault("api-version")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "api-version", valid_594064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594065: Call_PeeringServicesListBySubscription_594060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all of the peerings under the given subscription.
  ## 
  let valid = call_594065.validator(path, query, header, formData, body)
  let scheme = call_594065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594065.url(scheme.get, call_594065.host, call_594065.base,
                         call_594065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594065, url, valid)

proc call*(call_594066: Call_PeeringServicesListBySubscription_594060;
          apiVersion: string; subscriptionId: string): Recallable =
  ## peeringServicesListBySubscription
  ## Lists all of the peerings under the given subscription.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_594067 = newJObject()
  var query_594068 = newJObject()
  add(query_594068, "api-version", newJString(apiVersion))
  add(path_594067, "subscriptionId", newJString(subscriptionId))
  result = call_594066.call(path_594067, query_594068, nil, nil, nil)

var peeringServicesListBySubscription* = Call_PeeringServicesListBySubscription_594060(
    name: "peeringServicesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/peeringServices",
    validator: validate_PeeringServicesListBySubscription_594061, base: "",
    url: url_PeeringServicesListBySubscription_594062, schemes: {Scheme.Https})
type
  Call_PeeringsListBySubscription_594069 = ref object of OpenApiRestCall_593424
proc url_PeeringsListBySubscription_594071(protocol: Scheme; host: string;
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

proc validate_PeeringsListBySubscription_594070(path: JsonNode; query: JsonNode;
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
  var valid_594072 = path.getOrDefault("subscriptionId")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "subscriptionId", valid_594072
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594073 = query.getOrDefault("api-version")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "api-version", valid_594073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594074: Call_PeeringsListBySubscription_594069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the peerings under the given subscription.
  ## 
  let valid = call_594074.validator(path, query, header, formData, body)
  let scheme = call_594074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594074.url(scheme.get, call_594074.host, call_594074.base,
                         call_594074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594074, url, valid)

proc call*(call_594075: Call_PeeringsListBySubscription_594069; apiVersion: string;
          subscriptionId: string): Recallable =
  ## peeringsListBySubscription
  ## Lists all of the peerings under the given subscription.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_594076 = newJObject()
  var query_594077 = newJObject()
  add(query_594077, "api-version", newJString(apiVersion))
  add(path_594076, "subscriptionId", newJString(subscriptionId))
  result = call_594075.call(path_594076, query_594077, nil, nil, nil)

var peeringsListBySubscription* = Call_PeeringsListBySubscription_594069(
    name: "peeringsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Peering/peerings",
    validator: validate_PeeringsListBySubscription_594070, base: "",
    url: url_PeeringsListBySubscription_594071, schemes: {Scheme.Https})
type
  Call_PeeringServicesListByResourceGroup_594078 = ref object of OpenApiRestCall_593424
proc url_PeeringServicesListByResourceGroup_594080(protocol: Scheme; host: string;
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

proc validate_PeeringServicesListByResourceGroup_594079(path: JsonNode;
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
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594083 = query.getOrDefault("api-version")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "api-version", valid_594083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594084: Call_PeeringServicesListByResourceGroup_594078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all of the peering services under the given subscription and resource group.
  ## 
  let valid = call_594084.validator(path, query, header, formData, body)
  let scheme = call_594084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594084.url(scheme.get, call_594084.host, call_594084.base,
                         call_594084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594084, url, valid)

proc call*(call_594085: Call_PeeringServicesListByResourceGroup_594078;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## peeringServicesListByResourceGroup
  ## Lists all of the peering services under the given subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_594086 = newJObject()
  var query_594087 = newJObject()
  add(path_594086, "resourceGroupName", newJString(resourceGroupName))
  add(query_594087, "api-version", newJString(apiVersion))
  add(path_594086, "subscriptionId", newJString(subscriptionId))
  result = call_594085.call(path_594086, query_594087, nil, nil, nil)

var peeringServicesListByResourceGroup* = Call_PeeringServicesListByResourceGroup_594078(
    name: "peeringServicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peeringServices",
    validator: validate_PeeringServicesListByResourceGroup_594079, base: "",
    url: url_PeeringServicesListByResourceGroup_594080, schemes: {Scheme.Https})
type
  Call_PeeringServicesCreateOrUpdate_594099 = ref object of OpenApiRestCall_593424
proc url_PeeringServicesCreateOrUpdate_594101(protocol: Scheme; host: string;
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

proc validate_PeeringServicesCreateOrUpdate_594100(path: JsonNode; query: JsonNode;
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
  var valid_594102 = path.getOrDefault("resourceGroupName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "resourceGroupName", valid_594102
  var valid_594103 = path.getOrDefault("peeringServiceName")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "peeringServiceName", valid_594103
  var valid_594104 = path.getOrDefault("subscriptionId")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "subscriptionId", valid_594104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594105 = query.getOrDefault("api-version")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "api-version", valid_594105
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

proc call*(call_594107: Call_PeeringServicesCreateOrUpdate_594099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new peering service or updates an existing peering with the specified name under the given subscription and resource group.
  ## 
  let valid = call_594107.validator(path, query, header, formData, body)
  let scheme = call_594107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594107.url(scheme.get, call_594107.host, call_594107.base,
                         call_594107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594107, url, valid)

proc call*(call_594108: Call_PeeringServicesCreateOrUpdate_594099;
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
  var path_594109 = newJObject()
  var query_594110 = newJObject()
  var body_594111 = newJObject()
  add(path_594109, "resourceGroupName", newJString(resourceGroupName))
  add(query_594110, "api-version", newJString(apiVersion))
  add(path_594109, "peeringServiceName", newJString(peeringServiceName))
  add(path_594109, "subscriptionId", newJString(subscriptionId))
  if peeringService != nil:
    body_594111 = peeringService
  result = call_594108.call(path_594109, query_594110, nil, nil, body_594111)

var peeringServicesCreateOrUpdate* = Call_PeeringServicesCreateOrUpdate_594099(
    name: "peeringServicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peeringServices/{peeringServiceName}",
    validator: validate_PeeringServicesCreateOrUpdate_594100, base: "",
    url: url_PeeringServicesCreateOrUpdate_594101, schemes: {Scheme.Https})
type
  Call_PeeringServicesGet_594088 = ref object of OpenApiRestCall_593424
proc url_PeeringServicesGet_594090(protocol: Scheme; host: string; base: string;
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

proc validate_PeeringServicesGet_594089(path: JsonNode; query: JsonNode;
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
  var valid_594091 = path.getOrDefault("resourceGroupName")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "resourceGroupName", valid_594091
  var valid_594092 = path.getOrDefault("peeringServiceName")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "peeringServiceName", valid_594092
  var valid_594093 = path.getOrDefault("subscriptionId")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "subscriptionId", valid_594093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594094 = query.getOrDefault("api-version")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "api-version", valid_594094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594095: Call_PeeringServicesGet_594088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing peering service with the specified name under the given subscription and resource group.
  ## 
  let valid = call_594095.validator(path, query, header, formData, body)
  let scheme = call_594095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594095.url(scheme.get, call_594095.host, call_594095.base,
                         call_594095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594095, url, valid)

proc call*(call_594096: Call_PeeringServicesGet_594088; resourceGroupName: string;
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
  var path_594097 = newJObject()
  var query_594098 = newJObject()
  add(path_594097, "resourceGroupName", newJString(resourceGroupName))
  add(query_594098, "api-version", newJString(apiVersion))
  add(path_594097, "peeringServiceName", newJString(peeringServiceName))
  add(path_594097, "subscriptionId", newJString(subscriptionId))
  result = call_594096.call(path_594097, query_594098, nil, nil, nil)

var peeringServicesGet* = Call_PeeringServicesGet_594088(
    name: "peeringServicesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peeringServices/{peeringServiceName}",
    validator: validate_PeeringServicesGet_594089, base: "",
    url: url_PeeringServicesGet_594090, schemes: {Scheme.Https})
type
  Call_PeeringServicesUpdate_594123 = ref object of OpenApiRestCall_593424
proc url_PeeringServicesUpdate_594125(protocol: Scheme; host: string; base: string;
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

proc validate_PeeringServicesUpdate_594124(path: JsonNode; query: JsonNode;
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
  var valid_594126 = path.getOrDefault("resourceGroupName")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "resourceGroupName", valid_594126
  var valid_594127 = path.getOrDefault("peeringServiceName")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "peeringServiceName", valid_594127
  var valid_594128 = path.getOrDefault("subscriptionId")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "subscriptionId", valid_594128
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594129 = query.getOrDefault("api-version")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "api-version", valid_594129
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

proc call*(call_594131: Call_PeeringServicesUpdate_594123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates tags for a peering service with the specified name under the given subscription and resource group.
  ## 
  let valid = call_594131.validator(path, query, header, formData, body)
  let scheme = call_594131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594131.url(scheme.get, call_594131.host, call_594131.base,
                         call_594131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594131, url, valid)

proc call*(call_594132: Call_PeeringServicesUpdate_594123;
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
  var path_594133 = newJObject()
  var query_594134 = newJObject()
  var body_594135 = newJObject()
  add(path_594133, "resourceGroupName", newJString(resourceGroupName))
  add(query_594134, "api-version", newJString(apiVersion))
  add(path_594133, "peeringServiceName", newJString(peeringServiceName))
  add(path_594133, "subscriptionId", newJString(subscriptionId))
  if tags != nil:
    body_594135 = tags
  result = call_594132.call(path_594133, query_594134, nil, nil, body_594135)

var peeringServicesUpdate* = Call_PeeringServicesUpdate_594123(
    name: "peeringServicesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peeringServices/{peeringServiceName}",
    validator: validate_PeeringServicesUpdate_594124, base: "",
    url: url_PeeringServicesUpdate_594125, schemes: {Scheme.Https})
type
  Call_PeeringServicesDelete_594112 = ref object of OpenApiRestCall_593424
proc url_PeeringServicesDelete_594114(protocol: Scheme; host: string; base: string;
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

proc validate_PeeringServicesDelete_594113(path: JsonNode; query: JsonNode;
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
  var valid_594115 = path.getOrDefault("resourceGroupName")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "resourceGroupName", valid_594115
  var valid_594116 = path.getOrDefault("peeringServiceName")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "peeringServiceName", valid_594116
  var valid_594117 = path.getOrDefault("subscriptionId")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "subscriptionId", valid_594117
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594118 = query.getOrDefault("api-version")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "api-version", valid_594118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594119: Call_PeeringServicesDelete_594112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing peering service with the specified name under the given subscription and resource group.
  ## 
  let valid = call_594119.validator(path, query, header, formData, body)
  let scheme = call_594119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594119.url(scheme.get, call_594119.host, call_594119.base,
                         call_594119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594119, url, valid)

proc call*(call_594120: Call_PeeringServicesDelete_594112;
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
  var path_594121 = newJObject()
  var query_594122 = newJObject()
  add(path_594121, "resourceGroupName", newJString(resourceGroupName))
  add(query_594122, "api-version", newJString(apiVersion))
  add(path_594121, "peeringServiceName", newJString(peeringServiceName))
  add(path_594121, "subscriptionId", newJString(subscriptionId))
  result = call_594120.call(path_594121, query_594122, nil, nil, nil)

var peeringServicesDelete* = Call_PeeringServicesDelete_594112(
    name: "peeringServicesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peeringServices/{peeringServiceName}",
    validator: validate_PeeringServicesDelete_594113, base: "",
    url: url_PeeringServicesDelete_594114, schemes: {Scheme.Https})
type
  Call_PrefixesListByPeeringService_594136 = ref object of OpenApiRestCall_593424
proc url_PrefixesListByPeeringService_594138(protocol: Scheme; host: string;
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

proc validate_PrefixesListByPeeringService_594137(path: JsonNode; query: JsonNode;
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
  var valid_594139 = path.getOrDefault("resourceGroupName")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "resourceGroupName", valid_594139
  var valid_594140 = path.getOrDefault("peeringServiceName")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "peeringServiceName", valid_594140
  var valid_594141 = path.getOrDefault("subscriptionId")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "subscriptionId", valid_594141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594142 = query.getOrDefault("api-version")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "api-version", valid_594142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594143: Call_PrefixesListByPeeringService_594136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the peerings prefix in the resource group.
  ## 
  let valid = call_594143.validator(path, query, header, formData, body)
  let scheme = call_594143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594143.url(scheme.get, call_594143.host, call_594143.base,
                         call_594143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594143, url, valid)

proc call*(call_594144: Call_PrefixesListByPeeringService_594136;
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
  var path_594145 = newJObject()
  var query_594146 = newJObject()
  add(path_594145, "resourceGroupName", newJString(resourceGroupName))
  add(query_594146, "api-version", newJString(apiVersion))
  add(path_594145, "peeringServiceName", newJString(peeringServiceName))
  add(path_594145, "subscriptionId", newJString(subscriptionId))
  result = call_594144.call(path_594145, query_594146, nil, nil, nil)

var prefixesListByPeeringService* = Call_PrefixesListByPeeringService_594136(
    name: "prefixesListByPeeringService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peeringServices/{peeringServiceName}/prefixes",
    validator: validate_PrefixesListByPeeringService_594137, base: "",
    url: url_PrefixesListByPeeringService_594138, schemes: {Scheme.Https})
type
  Call_PeeringServicePrefixesCreateOrUpdate_594159 = ref object of OpenApiRestCall_593424
proc url_PeeringServicePrefixesCreateOrUpdate_594161(protocol: Scheme;
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

proc validate_PeeringServicePrefixesCreateOrUpdate_594160(path: JsonNode;
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
  var valid_594162 = path.getOrDefault("resourceGroupName")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "resourceGroupName", valid_594162
  var valid_594163 = path.getOrDefault("peeringServiceName")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "peeringServiceName", valid_594163
  var valid_594164 = path.getOrDefault("subscriptionId")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "subscriptionId", valid_594164
  var valid_594165 = path.getOrDefault("prefixName")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "prefixName", valid_594165
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594166 = query.getOrDefault("api-version")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "api-version", valid_594166
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

proc call*(call_594168: Call_PeeringServicePrefixesCreateOrUpdate_594159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the peering prefix.
  ## 
  let valid = call_594168.validator(path, query, header, formData, body)
  let scheme = call_594168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594168.url(scheme.get, call_594168.host, call_594168.base,
                         call_594168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594168, url, valid)

proc call*(call_594169: Call_PeeringServicePrefixesCreateOrUpdate_594159;
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
  var path_594170 = newJObject()
  var query_594171 = newJObject()
  var body_594172 = newJObject()
  add(path_594170, "resourceGroupName", newJString(resourceGroupName))
  add(query_594171, "api-version", newJString(apiVersion))
  add(path_594170, "peeringServiceName", newJString(peeringServiceName))
  add(path_594170, "subscriptionId", newJString(subscriptionId))
  if peeringServicePrefix != nil:
    body_594172 = peeringServicePrefix
  add(path_594170, "prefixName", newJString(prefixName))
  result = call_594169.call(path_594170, query_594171, nil, nil, body_594172)

var peeringServicePrefixesCreateOrUpdate* = Call_PeeringServicePrefixesCreateOrUpdate_594159(
    name: "peeringServicePrefixesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peeringServices/{peeringServiceName}/prefixes/{prefixName}",
    validator: validate_PeeringServicePrefixesCreateOrUpdate_594160, base: "",
    url: url_PeeringServicePrefixesCreateOrUpdate_594161, schemes: {Scheme.Https})
type
  Call_PeeringServicePrefixesGet_594147 = ref object of OpenApiRestCall_593424
proc url_PeeringServicePrefixesGet_594149(protocol: Scheme; host: string;
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

proc validate_PeeringServicePrefixesGet_594148(path: JsonNode; query: JsonNode;
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
  var valid_594150 = path.getOrDefault("resourceGroupName")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "resourceGroupName", valid_594150
  var valid_594151 = path.getOrDefault("peeringServiceName")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "peeringServiceName", valid_594151
  var valid_594152 = path.getOrDefault("subscriptionId")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "subscriptionId", valid_594152
  var valid_594153 = path.getOrDefault("prefixName")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "prefixName", valid_594153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594154 = query.getOrDefault("api-version")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "api-version", valid_594154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594155: Call_PeeringServicePrefixesGet_594147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the peering service prefix.
  ## 
  let valid = call_594155.validator(path, query, header, formData, body)
  let scheme = call_594155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594155.url(scheme.get, call_594155.host, call_594155.base,
                         call_594155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594155, url, valid)

proc call*(call_594156: Call_PeeringServicePrefixesGet_594147;
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
  var path_594157 = newJObject()
  var query_594158 = newJObject()
  add(path_594157, "resourceGroupName", newJString(resourceGroupName))
  add(query_594158, "api-version", newJString(apiVersion))
  add(path_594157, "peeringServiceName", newJString(peeringServiceName))
  add(path_594157, "subscriptionId", newJString(subscriptionId))
  add(path_594157, "prefixName", newJString(prefixName))
  result = call_594156.call(path_594157, query_594158, nil, nil, nil)

var peeringServicePrefixesGet* = Call_PeeringServicePrefixesGet_594147(
    name: "peeringServicePrefixesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peeringServices/{peeringServiceName}/prefixes/{prefixName}",
    validator: validate_PeeringServicePrefixesGet_594148, base: "",
    url: url_PeeringServicePrefixesGet_594149, schemes: {Scheme.Https})
type
  Call_PeeringServicePrefixesDelete_594173 = ref object of OpenApiRestCall_593424
proc url_PeeringServicePrefixesDelete_594175(protocol: Scheme; host: string;
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

proc validate_PeeringServicePrefixesDelete_594174(path: JsonNode; query: JsonNode;
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
  var valid_594176 = path.getOrDefault("resourceGroupName")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "resourceGroupName", valid_594176
  var valid_594177 = path.getOrDefault("peeringServiceName")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "peeringServiceName", valid_594177
  var valid_594178 = path.getOrDefault("subscriptionId")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "subscriptionId", valid_594178
  var valid_594179 = path.getOrDefault("prefixName")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "prefixName", valid_594179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594180 = query.getOrDefault("api-version")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "api-version", valid_594180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594181: Call_PeeringServicePrefixesDelete_594173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## removes the peering prefix.
  ## 
  let valid = call_594181.validator(path, query, header, formData, body)
  let scheme = call_594181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594181.url(scheme.get, call_594181.host, call_594181.base,
                         call_594181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594181, url, valid)

proc call*(call_594182: Call_PeeringServicePrefixesDelete_594173;
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
  var path_594183 = newJObject()
  var query_594184 = newJObject()
  add(path_594183, "resourceGroupName", newJString(resourceGroupName))
  add(query_594184, "api-version", newJString(apiVersion))
  add(path_594183, "peeringServiceName", newJString(peeringServiceName))
  add(path_594183, "subscriptionId", newJString(subscriptionId))
  add(path_594183, "prefixName", newJString(prefixName))
  result = call_594182.call(path_594183, query_594184, nil, nil, nil)

var peeringServicePrefixesDelete* = Call_PeeringServicePrefixesDelete_594173(
    name: "peeringServicePrefixesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peeringServices/{peeringServiceName}/prefixes/{prefixName}",
    validator: validate_PeeringServicePrefixesDelete_594174, base: "",
    url: url_PeeringServicePrefixesDelete_594175, schemes: {Scheme.Https})
type
  Call_PeeringsListByResourceGroup_594185 = ref object of OpenApiRestCall_593424
proc url_PeeringsListByResourceGroup_594187(protocol: Scheme; host: string;
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

proc validate_PeeringsListByResourceGroup_594186(path: JsonNode; query: JsonNode;
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
  var valid_594188 = path.getOrDefault("resourceGroupName")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "resourceGroupName", valid_594188
  var valid_594189 = path.getOrDefault("subscriptionId")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "subscriptionId", valid_594189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594190 = query.getOrDefault("api-version")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "api-version", valid_594190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594191: Call_PeeringsListByResourceGroup_594185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the peerings under the given subscription and resource group.
  ## 
  let valid = call_594191.validator(path, query, header, formData, body)
  let scheme = call_594191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594191.url(scheme.get, call_594191.host, call_594191.base,
                         call_594191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594191, url, valid)

proc call*(call_594192: Call_PeeringsListByResourceGroup_594185;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## peeringsListByResourceGroup
  ## Lists all of the peerings under the given subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_594193 = newJObject()
  var query_594194 = newJObject()
  add(path_594193, "resourceGroupName", newJString(resourceGroupName))
  add(query_594194, "api-version", newJString(apiVersion))
  add(path_594193, "subscriptionId", newJString(subscriptionId))
  result = call_594192.call(path_594193, query_594194, nil, nil, nil)

var peeringsListByResourceGroup* = Call_PeeringsListByResourceGroup_594185(
    name: "peeringsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peerings",
    validator: validate_PeeringsListByResourceGroup_594186, base: "",
    url: url_PeeringsListByResourceGroup_594187, schemes: {Scheme.Https})
type
  Call_PeeringsCreateOrUpdate_594206 = ref object of OpenApiRestCall_593424
proc url_PeeringsCreateOrUpdate_594208(protocol: Scheme; host: string; base: string;
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

proc validate_PeeringsCreateOrUpdate_594207(path: JsonNode; query: JsonNode;
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
  var valid_594209 = path.getOrDefault("resourceGroupName")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "resourceGroupName", valid_594209
  var valid_594210 = path.getOrDefault("peeringName")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "peeringName", valid_594210
  var valid_594211 = path.getOrDefault("subscriptionId")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "subscriptionId", valid_594211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594212 = query.getOrDefault("api-version")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "api-version", valid_594212
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

proc call*(call_594214: Call_PeeringsCreateOrUpdate_594206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new peering or updates an existing peering with the specified name under the given subscription and resource group.
  ## 
  let valid = call_594214.validator(path, query, header, formData, body)
  let scheme = call_594214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594214.url(scheme.get, call_594214.host, call_594214.base,
                         call_594214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594214, url, valid)

proc call*(call_594215: Call_PeeringsCreateOrUpdate_594206;
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
  var path_594216 = newJObject()
  var query_594217 = newJObject()
  var body_594218 = newJObject()
  add(path_594216, "resourceGroupName", newJString(resourceGroupName))
  add(query_594217, "api-version", newJString(apiVersion))
  add(path_594216, "peeringName", newJString(peeringName))
  add(path_594216, "subscriptionId", newJString(subscriptionId))
  if peering != nil:
    body_594218 = peering
  result = call_594215.call(path_594216, query_594217, nil, nil, body_594218)

var peeringsCreateOrUpdate* = Call_PeeringsCreateOrUpdate_594206(
    name: "peeringsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peerings/{peeringName}",
    validator: validate_PeeringsCreateOrUpdate_594207, base: "",
    url: url_PeeringsCreateOrUpdate_594208, schemes: {Scheme.Https})
type
  Call_PeeringsGet_594195 = ref object of OpenApiRestCall_593424
proc url_PeeringsGet_594197(protocol: Scheme; host: string; base: string;
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

proc validate_PeeringsGet_594196(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594198 = path.getOrDefault("resourceGroupName")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "resourceGroupName", valid_594198
  var valid_594199 = path.getOrDefault("peeringName")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "peeringName", valid_594199
  var valid_594200 = path.getOrDefault("subscriptionId")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "subscriptionId", valid_594200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594201 = query.getOrDefault("api-version")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "api-version", valid_594201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594202: Call_PeeringsGet_594195; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing peering with the specified name under the given subscription and resource group.
  ## 
  let valid = call_594202.validator(path, query, header, formData, body)
  let scheme = call_594202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594202.url(scheme.get, call_594202.host, call_594202.base,
                         call_594202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594202, url, valid)

proc call*(call_594203: Call_PeeringsGet_594195; resourceGroupName: string;
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
  var path_594204 = newJObject()
  var query_594205 = newJObject()
  add(path_594204, "resourceGroupName", newJString(resourceGroupName))
  add(query_594205, "api-version", newJString(apiVersion))
  add(path_594204, "peeringName", newJString(peeringName))
  add(path_594204, "subscriptionId", newJString(subscriptionId))
  result = call_594203.call(path_594204, query_594205, nil, nil, nil)

var peeringsGet* = Call_PeeringsGet_594195(name: "peeringsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peerings/{peeringName}",
                                        validator: validate_PeeringsGet_594196,
                                        base: "", url: url_PeeringsGet_594197,
                                        schemes: {Scheme.Https})
type
  Call_PeeringsUpdate_594230 = ref object of OpenApiRestCall_593424
proc url_PeeringsUpdate_594232(protocol: Scheme; host: string; base: string;
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

proc validate_PeeringsUpdate_594231(path: JsonNode; query: JsonNode;
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
  var valid_594233 = path.getOrDefault("resourceGroupName")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "resourceGroupName", valid_594233
  var valid_594234 = path.getOrDefault("peeringName")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "peeringName", valid_594234
  var valid_594235 = path.getOrDefault("subscriptionId")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "subscriptionId", valid_594235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594236 = query.getOrDefault("api-version")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "api-version", valid_594236
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

proc call*(call_594238: Call_PeeringsUpdate_594230; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates tags for a peering with the specified name under the given subscription and resource group.
  ## 
  let valid = call_594238.validator(path, query, header, formData, body)
  let scheme = call_594238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594238.url(scheme.get, call_594238.host, call_594238.base,
                         call_594238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594238, url, valid)

proc call*(call_594239: Call_PeeringsUpdate_594230; resourceGroupName: string;
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
  var path_594240 = newJObject()
  var query_594241 = newJObject()
  var body_594242 = newJObject()
  add(path_594240, "resourceGroupName", newJString(resourceGroupName))
  add(query_594241, "api-version", newJString(apiVersion))
  add(path_594240, "peeringName", newJString(peeringName))
  add(path_594240, "subscriptionId", newJString(subscriptionId))
  if tags != nil:
    body_594242 = tags
  result = call_594239.call(path_594240, query_594241, nil, nil, body_594242)

var peeringsUpdate* = Call_PeeringsUpdate_594230(name: "peeringsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peerings/{peeringName}",
    validator: validate_PeeringsUpdate_594231, base: "", url: url_PeeringsUpdate_594232,
    schemes: {Scheme.Https})
type
  Call_PeeringsDelete_594219 = ref object of OpenApiRestCall_593424
proc url_PeeringsDelete_594221(protocol: Scheme; host: string; base: string;
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

proc validate_PeeringsDelete_594220(path: JsonNode; query: JsonNode;
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
  var valid_594222 = path.getOrDefault("resourceGroupName")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "resourceGroupName", valid_594222
  var valid_594223 = path.getOrDefault("peeringName")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "peeringName", valid_594223
  var valid_594224 = path.getOrDefault("subscriptionId")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "subscriptionId", valid_594224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594225 = query.getOrDefault("api-version")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "api-version", valid_594225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594226: Call_PeeringsDelete_594219; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing peering with the specified name under the given subscription and resource group.
  ## 
  let valid = call_594226.validator(path, query, header, formData, body)
  let scheme = call_594226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594226.url(scheme.get, call_594226.host, call_594226.base,
                         call_594226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594226, url, valid)

proc call*(call_594227: Call_PeeringsDelete_594219; resourceGroupName: string;
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
  var path_594228 = newJObject()
  var query_594229 = newJObject()
  add(path_594228, "resourceGroupName", newJString(resourceGroupName))
  add(query_594229, "api-version", newJString(apiVersion))
  add(path_594228, "peeringName", newJString(peeringName))
  add(path_594228, "subscriptionId", newJString(subscriptionId))
  result = call_594227.call(path_594228, query_594229, nil, nil, nil)

var peeringsDelete* = Call_PeeringsDelete_594219(name: "peeringsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Peering/peerings/{peeringName}",
    validator: validate_PeeringsDelete_594220, base: "", url: url_PeeringsDelete_594221,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
