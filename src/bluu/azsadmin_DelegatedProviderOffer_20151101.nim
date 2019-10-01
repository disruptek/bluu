
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SubscriptionsManagementClient
## version: 2015-11-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Admin Subscriptions Management Client.
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

  OpenApiRestCall_574457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574457): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-DelegatedProviderOffer"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DelegatedProviderOffersList_574679 = ref object of OpenApiRestCall_574457
proc url_DelegatedProviderOffersList_574681(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "delegatedProviderSubscriptionId" in path,
        "`delegatedProviderSubscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/delegatedProviders/"), (
        kind: VariableSegment, value: "delegatedProviderSubscriptionId"),
               (kind: ConstantSegment, value: "/offers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DelegatedProviderOffersList_574680(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of delegated provider offers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   delegatedProviderSubscriptionId: JString (required)
  ##                                  : Delegated provider subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574841 = path.getOrDefault("subscriptionId")
  valid_574841 = validateParameter(valid_574841, JString, required = true,
                                 default = nil)
  if valid_574841 != nil:
    section.add "subscriptionId", valid_574841
  var valid_574842 = path.getOrDefault("delegatedProviderSubscriptionId")
  valid_574842 = validateParameter(valid_574842, JString, required = true,
                                 default = nil)
  if valid_574842 != nil:
    section.add "delegatedProviderSubscriptionId", valid_574842
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574856 = query.getOrDefault("api-version")
  valid_574856 = validateParameter(valid_574856, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574856 != nil:
    section.add "api-version", valid_574856
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574883: Call_DelegatedProviderOffersList_574679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of delegated provider offers.
  ## 
  let valid = call_574883.validator(path, query, header, formData, body)
  let scheme = call_574883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574883.url(scheme.get, call_574883.host, call_574883.base,
                         call_574883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574883, url, valid)

proc call*(call_574954: Call_DelegatedProviderOffersList_574679;
          subscriptionId: string; delegatedProviderSubscriptionId: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## delegatedProviderOffersList
  ## Get the list of delegated provider offers.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   delegatedProviderSubscriptionId: string (required)
  ##                                  : Delegated provider subscription identifier.
  var path_574955 = newJObject()
  var query_574957 = newJObject()
  add(query_574957, "api-version", newJString(apiVersion))
  add(path_574955, "subscriptionId", newJString(subscriptionId))
  add(path_574955, "delegatedProviderSubscriptionId",
      newJString(delegatedProviderSubscriptionId))
  result = call_574954.call(path_574955, query_574957, nil, nil, nil)

var delegatedProviderOffersList* = Call_DelegatedProviderOffersList_574679(
    name: "delegatedProviderOffersList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/delegatedProviders/{delegatedProviderSubscriptionId}/offers",
    validator: validate_DelegatedProviderOffersList_574680, base: "",
    url: url_DelegatedProviderOffersList_574681, schemes: {Scheme.Https})
type
  Call_DelegatedProviderOffersGet_574996 = ref object of OpenApiRestCall_574457
proc url_DelegatedProviderOffersGet_574998(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "delegatedProviderSubscriptionId" in path,
        "`delegatedProviderSubscriptionId` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/delegatedProviders/"), (
        kind: VariableSegment, value: "delegatedProviderSubscriptionId"),
               (kind: ConstantSegment, value: "/offers/"),
               (kind: VariableSegment, value: "offer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DelegatedProviderOffersGet_574997(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified delegated provider offer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offer: JString (required)
  ##        : Name of an offer.
  ##   delegatedProviderSubscriptionId: JString (required)
  ##                                  : Delegated provider subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574999 = path.getOrDefault("subscriptionId")
  valid_574999 = validateParameter(valid_574999, JString, required = true,
                                 default = nil)
  if valid_574999 != nil:
    section.add "subscriptionId", valid_574999
  var valid_575000 = path.getOrDefault("offer")
  valid_575000 = validateParameter(valid_575000, JString, required = true,
                                 default = nil)
  if valid_575000 != nil:
    section.add "offer", valid_575000
  var valid_575001 = path.getOrDefault("delegatedProviderSubscriptionId")
  valid_575001 = validateParameter(valid_575001, JString, required = true,
                                 default = nil)
  if valid_575001 != nil:
    section.add "delegatedProviderSubscriptionId", valid_575001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575002 = query.getOrDefault("api-version")
  valid_575002 = validateParameter(valid_575002, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_575002 != nil:
    section.add "api-version", valid_575002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575003: Call_DelegatedProviderOffersGet_574996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified delegated provider offer.
  ## 
  let valid = call_575003.validator(path, query, header, formData, body)
  let scheme = call_575003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575003.url(scheme.get, call_575003.host, call_575003.base,
                         call_575003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575003, url, valid)

proc call*(call_575004: Call_DelegatedProviderOffersGet_574996;
          subscriptionId: string; offer: string;
          delegatedProviderSubscriptionId: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## delegatedProviderOffersGet
  ## Get the specified delegated provider offer.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offer: string (required)
  ##        : Name of an offer.
  ##   delegatedProviderSubscriptionId: string (required)
  ##                                  : Delegated provider subscription identifier.
  var path_575005 = newJObject()
  var query_575006 = newJObject()
  add(query_575006, "api-version", newJString(apiVersion))
  add(path_575005, "subscriptionId", newJString(subscriptionId))
  add(path_575005, "offer", newJString(offer))
  add(path_575005, "delegatedProviderSubscriptionId",
      newJString(delegatedProviderSubscriptionId))
  result = call_575004.call(path_575005, query_575006, nil, nil, nil)

var delegatedProviderOffersGet* = Call_DelegatedProviderOffersGet_574996(
    name: "delegatedProviderOffersGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/delegatedProviders/{delegatedProviderSubscriptionId}/offers/{offer}",
    validator: validate_DelegatedProviderOffersGet_574997, base: "",
    url: url_DelegatedProviderOffersGet_574998, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
