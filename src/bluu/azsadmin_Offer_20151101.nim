
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  macServiceName = "azsadmin-Offer"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DelegatedProviderOffersList_593630 = ref object of OpenApiRestCall_593408
proc url_DelegatedProviderOffersList_593632(protocol: Scheme; host: string;
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

proc validate_DelegatedProviderOffersList_593631(path: JsonNode; query: JsonNode;
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
  var valid_593792 = path.getOrDefault("delegatedProviderId")
  valid_593792 = validateParameter(valid_593792, JString, required = true,
                                 default = nil)
  if valid_593792 != nil:
    section.add "delegatedProviderId", valid_593792
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593806 = query.getOrDefault("api-version")
  valid_593806 = validateParameter(valid_593806, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_593806 != nil:
    section.add "api-version", valid_593806
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593833: Call_DelegatedProviderOffersList_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of offers for the specified delegated provider.
  ## 
  let valid = call_593833.validator(path, query, header, formData, body)
  let scheme = call_593833.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593833.url(scheme.get, call_593833.host, call_593833.base,
                         call_593833.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593833, url, valid)

proc call*(call_593904: Call_DelegatedProviderOffersList_593630;
          delegatedProviderId: string; apiVersion: string = "2015-11-01"): Recallable =
  ## delegatedProviderOffersList
  ## Get the list of offers for the specified delegated provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   delegatedProviderId: string (required)
  ##                      : Id of the delegated provider.
  var path_593905 = newJObject()
  var query_593907 = newJObject()
  add(query_593907, "api-version", newJString(apiVersion))
  add(path_593905, "delegatedProviderId", newJString(delegatedProviderId))
  result = call_593904.call(path_593905, query_593907, nil, nil, nil)

var delegatedProviderOffersList* = Call_DelegatedProviderOffersList_593630(
    name: "delegatedProviderOffersList", meth: HttpMethod.HttpGet,
    host: "management.local.azurestack.external",
    route: "/delegatedProviders/{delegatedProviderId}/offers",
    validator: validate_DelegatedProviderOffersList_593631, base: "",
    url: url_DelegatedProviderOffersList_593632, schemes: {Scheme.Https})
type
  Call_DelegatedProviderOffersGet_593946 = ref object of OpenApiRestCall_593408
proc url_DelegatedProviderOffersGet_593948(protocol: Scheme; host: string;
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

proc validate_DelegatedProviderOffersGet_593947(path: JsonNode; query: JsonNode;
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
  var valid_593949 = path.getOrDefault("offerName")
  valid_593949 = validateParameter(valid_593949, JString, required = true,
                                 default = nil)
  if valid_593949 != nil:
    section.add "offerName", valid_593949
  var valid_593950 = path.getOrDefault("delegatedProviderId")
  valid_593950 = validateParameter(valid_593950, JString, required = true,
                                 default = nil)
  if valid_593950 != nil:
    section.add "delegatedProviderId", valid_593950
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593951 = query.getOrDefault("api-version")
  valid_593951 = validateParameter(valid_593951, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_593951 != nil:
    section.add "api-version", valid_593951
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593952: Call_DelegatedProviderOffersGet_593946; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified offer for the delegated provider.
  ## 
  let valid = call_593952.validator(path, query, header, formData, body)
  let scheme = call_593952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593952.url(scheme.get, call_593952.host, call_593952.base,
                         call_593952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593952, url, valid)

proc call*(call_593953: Call_DelegatedProviderOffersGet_593946; offerName: string;
          delegatedProviderId: string; apiVersion: string = "2015-11-01"): Recallable =
  ## delegatedProviderOffersGet
  ## Get the specified offer for the delegated provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   offerName: string (required)
  ##            : Name of the offer.
  ##   delegatedProviderId: string (required)
  ##                      : Id of the delegated provider.
  var path_593954 = newJObject()
  var query_593955 = newJObject()
  add(query_593955, "api-version", newJString(apiVersion))
  add(path_593954, "offerName", newJString(offerName))
  add(path_593954, "delegatedProviderId", newJString(delegatedProviderId))
  result = call_593953.call(path_593954, query_593955, nil, nil, nil)

var delegatedProviderOffersGet* = Call_DelegatedProviderOffersGet_593946(
    name: "delegatedProviderOffersGet", meth: HttpMethod.HttpGet,
    host: "management.local.azurestack.external",
    route: "/delegatedProviders/{delegatedProviderId}/offers/{offerName}",
    validator: validate_DelegatedProviderOffersGet_593947, base: "",
    url: url_DelegatedProviderOffersGet_593948, schemes: {Scheme.Https})
type
  Call_OffersList_593956 = ref object of OpenApiRestCall_593408
proc url_OffersList_593958(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OffersList_593957(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593959 = query.getOrDefault("api-version")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_593959 != nil:
    section.add "api-version", valid_593959
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593960: Call_OffersList_593956; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of public offers for the root provider.
  ## 
  let valid = call_593960.validator(path, query, header, formData, body)
  let scheme = call_593960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593960.url(scheme.get, call_593960.host, call_593960.base,
                         call_593960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593960, url, valid)

proc call*(call_593961: Call_OffersList_593956; apiVersion: string = "2015-11-01"): Recallable =
  ## offersList
  ## Get the list of public offers for the root provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_593962 = newJObject()
  add(query_593962, "api-version", newJString(apiVersion))
  result = call_593961.call(nil, query_593962, nil, nil, nil)

var offersList* = Call_OffersList_593956(name: "offersList",
                                      meth: HttpMethod.HttpGet, host: "management.local.azurestack.external",
                                      route: "/offers",
                                      validator: validate_OffersList_593957,
                                      base: "", url: url_OffersList_593958,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
