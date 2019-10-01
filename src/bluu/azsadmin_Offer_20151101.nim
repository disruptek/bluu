
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SubscriptionClient
## version: 2015-11-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The User Subscription Management Client.
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

  OpenApiRestCall_574441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574441): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-Offer"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DelegatedProviderOffersList_574663 = ref object of OpenApiRestCall_574441
proc url_DelegatedProviderOffersList_574665(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "delegatedProviderId" in path,
        "`delegatedProviderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/delegatedProviders/"),
               (kind: VariableSegment, value: "delegatedProviderId"),
               (kind: ConstantSegment, value: "/offers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DelegatedProviderOffersList_574664(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of offers for the specified delegated provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   delegatedProviderId: JString (required)
  ##                      : Id of the delegated provider.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `delegatedProviderId` field"
  var valid_574825 = path.getOrDefault("delegatedProviderId")
  valid_574825 = validateParameter(valid_574825, JString, required = true,
                                 default = nil)
  if valid_574825 != nil:
    section.add "delegatedProviderId", valid_574825
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574839 = query.getOrDefault("api-version")
  valid_574839 = validateParameter(valid_574839, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574839 != nil:
    section.add "api-version", valid_574839
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574866: Call_DelegatedProviderOffersList_574663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of offers for the specified delegated provider.
  ## 
  let valid = call_574866.validator(path, query, header, formData, body)
  let scheme = call_574866.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574866.url(scheme.get, call_574866.host, call_574866.base,
                         call_574866.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574866, url, valid)

proc call*(call_574937: Call_DelegatedProviderOffersList_574663;
          delegatedProviderId: string; apiVersion: string = "2015-11-01"): Recallable =
  ## delegatedProviderOffersList
  ## Get the list of offers for the specified delegated provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   delegatedProviderId: string (required)
  ##                      : Id of the delegated provider.
  var path_574938 = newJObject()
  var query_574940 = newJObject()
  add(query_574940, "api-version", newJString(apiVersion))
  add(path_574938, "delegatedProviderId", newJString(delegatedProviderId))
  result = call_574937.call(path_574938, query_574940, nil, nil, nil)

var delegatedProviderOffersList* = Call_DelegatedProviderOffersList_574663(
    name: "delegatedProviderOffersList", meth: HttpMethod.HttpGet,
    host: "management.local.azurestack.external",
    route: "/delegatedProviders/{delegatedProviderId}/offers",
    validator: validate_DelegatedProviderOffersList_574664, base: "",
    url: url_DelegatedProviderOffersList_574665, schemes: {Scheme.Https})
type
  Call_DelegatedProviderOffersGet_574979 = ref object of OpenApiRestCall_574441
proc url_DelegatedProviderOffersGet_574981(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "delegatedProviderId" in path,
        "`delegatedProviderId` is a required path parameter"
  assert "offerName" in path, "`offerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/delegatedProviders/"),
               (kind: VariableSegment, value: "delegatedProviderId"),
               (kind: ConstantSegment, value: "/offers/"),
               (kind: VariableSegment, value: "offerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DelegatedProviderOffersGet_574980(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified offer for the delegated provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   offerName: JString (required)
  ##            : Name of the offer.
  ##   delegatedProviderId: JString (required)
  ##                      : Id of the delegated provider.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `offerName` field"
  var valid_574982 = path.getOrDefault("offerName")
  valid_574982 = validateParameter(valid_574982, JString, required = true,
                                 default = nil)
  if valid_574982 != nil:
    section.add "offerName", valid_574982
  var valid_574983 = path.getOrDefault("delegatedProviderId")
  valid_574983 = validateParameter(valid_574983, JString, required = true,
                                 default = nil)
  if valid_574983 != nil:
    section.add "delegatedProviderId", valid_574983
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574984 = query.getOrDefault("api-version")
  valid_574984 = validateParameter(valid_574984, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574984 != nil:
    section.add "api-version", valid_574984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574985: Call_DelegatedProviderOffersGet_574979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified offer for the delegated provider.
  ## 
  let valid = call_574985.validator(path, query, header, formData, body)
  let scheme = call_574985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574985.url(scheme.get, call_574985.host, call_574985.base,
                         call_574985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574985, url, valid)

proc call*(call_574986: Call_DelegatedProviderOffersGet_574979; offerName: string;
          delegatedProviderId: string; apiVersion: string = "2015-11-01"): Recallable =
  ## delegatedProviderOffersGet
  ## Get the specified offer for the delegated provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   offerName: string (required)
  ##            : Name of the offer.
  ##   delegatedProviderId: string (required)
  ##                      : Id of the delegated provider.
  var path_574987 = newJObject()
  var query_574988 = newJObject()
  add(query_574988, "api-version", newJString(apiVersion))
  add(path_574987, "offerName", newJString(offerName))
  add(path_574987, "delegatedProviderId", newJString(delegatedProviderId))
  result = call_574986.call(path_574987, query_574988, nil, nil, nil)

var delegatedProviderOffersGet* = Call_DelegatedProviderOffersGet_574979(
    name: "delegatedProviderOffersGet", meth: HttpMethod.HttpGet,
    host: "management.local.azurestack.external",
    route: "/delegatedProviders/{delegatedProviderId}/offers/{offerName}",
    validator: validate_DelegatedProviderOffersGet_574980, base: "",
    url: url_DelegatedProviderOffersGet_574981, schemes: {Scheme.Https})
type
  Call_OffersList_574989 = ref object of OpenApiRestCall_574441
proc url_OffersList_574991(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OffersList_574990(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of public offers for the root provider.
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
  var valid_574992 = query.getOrDefault("api-version")
  valid_574992 = validateParameter(valid_574992, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574992 != nil:
    section.add "api-version", valid_574992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574993: Call_OffersList_574989; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of public offers for the root provider.
  ## 
  let valid = call_574993.validator(path, query, header, formData, body)
  let scheme = call_574993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574993.url(scheme.get, call_574993.host, call_574993.base,
                         call_574993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574993, url, valid)

proc call*(call_574994: Call_OffersList_574989; apiVersion: string = "2015-11-01"): Recallable =
  ## offersList
  ## Get the list of public offers for the root provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_574995 = newJObject()
  add(query_574995, "api-version", newJString(apiVersion))
  result = call_574994.call(nil, query_574995, nil, nil, nil)

var offersList* = Call_OffersList_574989(name: "offersList",
                                      meth: HttpMethod.HttpGet, host: "management.local.azurestack.external",
                                      route: "/offers",
                                      validator: validate_OffersList_574990,
                                      base: "", url: url_OffersList_574991,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
