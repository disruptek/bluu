
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_573658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573658): Option[Scheme] {.used.} =
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
  Call_OffersListAll_573880 = ref object of OpenApiRestCall_573658
proc url_OffersListAll_573882(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Subscriptions.Admin/offers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OffersListAll_573881(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of offers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574042 = path.getOrDefault("subscriptionId")
  valid_574042 = validateParameter(valid_574042, JString, required = true,
                                 default = nil)
  if valid_574042 != nil:
    section.add "subscriptionId", valid_574042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574056 = query.getOrDefault("api-version")
  valid_574056 = validateParameter(valid_574056, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574056 != nil:
    section.add "api-version", valid_574056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574083: Call_OffersListAll_573880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of offers.
  ## 
  let valid = call_574083.validator(path, query, header, formData, body)
  let scheme = call_574083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574083.url(scheme.get, call_574083.host, call_574083.base,
                         call_574083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574083, url, valid)

proc call*(call_574154: Call_OffersListAll_573880; subscriptionId: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## offersListAll
  ## Get the list of offers.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  var path_574155 = newJObject()
  var query_574157 = newJObject()
  add(query_574157, "api-version", newJString(apiVersion))
  add(path_574155, "subscriptionId", newJString(subscriptionId))
  result = call_574154.call(path_574155, query_574157, nil, nil, nil)

var offersListAll* = Call_OffersListAll_573880(name: "offersListAll",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/offers",
    validator: validate_OffersListAll_573881, base: "", url: url_OffersListAll_573882,
    schemes: {Scheme.Https})
type
  Call_OffersList_574196 = ref object of OpenApiRestCall_573658
proc url_OffersList_574198(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/offers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OffersList_574197(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of offers under a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574199 = path.getOrDefault("resourceGroupName")
  valid_574199 = validateParameter(valid_574199, JString, required = true,
                                 default = nil)
  if valid_574199 != nil:
    section.add "resourceGroupName", valid_574199
  var valid_574200 = path.getOrDefault("subscriptionId")
  valid_574200 = validateParameter(valid_574200, JString, required = true,
                                 default = nil)
  if valid_574200 != nil:
    section.add "subscriptionId", valid_574200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574201 = query.getOrDefault("api-version")
  valid_574201 = validateParameter(valid_574201, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574201 != nil:
    section.add "api-version", valid_574201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574202: Call_OffersList_574196; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of offers under a resource group.
  ## 
  let valid = call_574202.validator(path, query, header, formData, body)
  let scheme = call_574202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574202.url(scheme.get, call_574202.host, call_574202.base,
                         call_574202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574202, url, valid)

proc call*(call_574203: Call_OffersList_574196; resourceGroupName: string;
          subscriptionId: string; apiVersion: string = "2015-11-01"): Recallable =
  ## offersList
  ## Get the list of offers under a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  var path_574204 = newJObject()
  var query_574205 = newJObject()
  add(path_574204, "resourceGroupName", newJString(resourceGroupName))
  add(query_574205, "api-version", newJString(apiVersion))
  add(path_574204, "subscriptionId", newJString(subscriptionId))
  result = call_574203.call(path_574204, query_574205, nil, nil, nil)

var offersList* = Call_OffersList_574196(name: "offersList",
                                      meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/offers",
                                      validator: validate_OffersList_574197,
                                      base: "", url: url_OffersList_574198,
                                      schemes: {Scheme.Https})
type
  Call_OffersCreateOrUpdate_574217 = ref object of OpenApiRestCall_573658
proc url_OffersCreateOrUpdate_574219(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/offers/"),
               (kind: VariableSegment, value: "offer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OffersCreateOrUpdate_574218(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update the offer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offer: JString (required)
  ##        : Name of an offer.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574229 = path.getOrDefault("resourceGroupName")
  valid_574229 = validateParameter(valid_574229, JString, required = true,
                                 default = nil)
  if valid_574229 != nil:
    section.add "resourceGroupName", valid_574229
  var valid_574230 = path.getOrDefault("subscriptionId")
  valid_574230 = validateParameter(valid_574230, JString, required = true,
                                 default = nil)
  if valid_574230 != nil:
    section.add "subscriptionId", valid_574230
  var valid_574231 = path.getOrDefault("offer")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "offer", valid_574231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574232 = query.getOrDefault("api-version")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574232 != nil:
    section.add "api-version", valid_574232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   newOffer: JObject (required)
  ##           : New offer.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574234: Call_OffersCreateOrUpdate_574217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update the offer.
  ## 
  let valid = call_574234.validator(path, query, header, formData, body)
  let scheme = call_574234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574234.url(scheme.get, call_574234.host, call_574234.base,
                         call_574234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574234, url, valid)

proc call*(call_574235: Call_OffersCreateOrUpdate_574217;
          resourceGroupName: string; subscriptionId: string; offer: string;
          newOffer: JsonNode; apiVersion: string = "2015-11-01"): Recallable =
  ## offersCreateOrUpdate
  ## Create or update the offer.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offer: string (required)
  ##        : Name of an offer.
  ##   newOffer: JObject (required)
  ##           : New offer.
  var path_574236 = newJObject()
  var query_574237 = newJObject()
  var body_574238 = newJObject()
  add(path_574236, "resourceGroupName", newJString(resourceGroupName))
  add(query_574237, "api-version", newJString(apiVersion))
  add(path_574236, "subscriptionId", newJString(subscriptionId))
  add(path_574236, "offer", newJString(offer))
  if newOffer != nil:
    body_574238 = newOffer
  result = call_574235.call(path_574236, query_574237, nil, nil, body_574238)

var offersCreateOrUpdate* = Call_OffersCreateOrUpdate_574217(
    name: "offersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/offers/{offer}",
    validator: validate_OffersCreateOrUpdate_574218, base: "",
    url: url_OffersCreateOrUpdate_574219, schemes: {Scheme.Https})
type
  Call_OffersGet_574206 = ref object of OpenApiRestCall_573658
proc url_OffersGet_574208(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/offers/"),
               (kind: VariableSegment, value: "offer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OffersGet_574207(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified offer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offer: JString (required)
  ##        : Name of an offer.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574209 = path.getOrDefault("resourceGroupName")
  valid_574209 = validateParameter(valid_574209, JString, required = true,
                                 default = nil)
  if valid_574209 != nil:
    section.add "resourceGroupName", valid_574209
  var valid_574210 = path.getOrDefault("subscriptionId")
  valid_574210 = validateParameter(valid_574210, JString, required = true,
                                 default = nil)
  if valid_574210 != nil:
    section.add "subscriptionId", valid_574210
  var valid_574211 = path.getOrDefault("offer")
  valid_574211 = validateParameter(valid_574211, JString, required = true,
                                 default = nil)
  if valid_574211 != nil:
    section.add "offer", valid_574211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574212 = query.getOrDefault("api-version")
  valid_574212 = validateParameter(valid_574212, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574212 != nil:
    section.add "api-version", valid_574212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574213: Call_OffersGet_574206; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified offer.
  ## 
  let valid = call_574213.validator(path, query, header, formData, body)
  let scheme = call_574213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574213.url(scheme.get, call_574213.host, call_574213.base,
                         call_574213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574213, url, valid)

proc call*(call_574214: Call_OffersGet_574206; resourceGroupName: string;
          subscriptionId: string; offer: string; apiVersion: string = "2015-11-01"): Recallable =
  ## offersGet
  ## Get the specified offer.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offer: string (required)
  ##        : Name of an offer.
  var path_574215 = newJObject()
  var query_574216 = newJObject()
  add(path_574215, "resourceGroupName", newJString(resourceGroupName))
  add(query_574216, "api-version", newJString(apiVersion))
  add(path_574215, "subscriptionId", newJString(subscriptionId))
  add(path_574215, "offer", newJString(offer))
  result = call_574214.call(path_574215, query_574216, nil, nil, nil)

var offersGet* = Call_OffersGet_574206(name: "offersGet", meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/offers/{offer}",
                                    validator: validate_OffersGet_574207,
                                    base: "", url: url_OffersGet_574208,
                                    schemes: {Scheme.Https})
type
  Call_OffersDelete_574239 = ref object of OpenApiRestCall_573658
proc url_OffersDelete_574241(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/offers/"),
               (kind: VariableSegment, value: "offer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OffersDelete_574240(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the specified offer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offer: JString (required)
  ##        : Name of an offer.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574242 = path.getOrDefault("resourceGroupName")
  valid_574242 = validateParameter(valid_574242, JString, required = true,
                                 default = nil)
  if valid_574242 != nil:
    section.add "resourceGroupName", valid_574242
  var valid_574243 = path.getOrDefault("subscriptionId")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = nil)
  if valid_574243 != nil:
    section.add "subscriptionId", valid_574243
  var valid_574244 = path.getOrDefault("offer")
  valid_574244 = validateParameter(valid_574244, JString, required = true,
                                 default = nil)
  if valid_574244 != nil:
    section.add "offer", valid_574244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574245 = query.getOrDefault("api-version")
  valid_574245 = validateParameter(valid_574245, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574245 != nil:
    section.add "api-version", valid_574245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574246: Call_OffersDelete_574239; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the specified offer.
  ## 
  let valid = call_574246.validator(path, query, header, formData, body)
  let scheme = call_574246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574246.url(scheme.get, call_574246.host, call_574246.base,
                         call_574246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574246, url, valid)

proc call*(call_574247: Call_OffersDelete_574239; resourceGroupName: string;
          subscriptionId: string; offer: string; apiVersion: string = "2015-11-01"): Recallable =
  ## offersDelete
  ## Delete the specified offer.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offer: string (required)
  ##        : Name of an offer.
  var path_574248 = newJObject()
  var query_574249 = newJObject()
  add(path_574248, "resourceGroupName", newJString(resourceGroupName))
  add(query_574249, "api-version", newJString(apiVersion))
  add(path_574248, "subscriptionId", newJString(subscriptionId))
  add(path_574248, "offer", newJString(offer))
  result = call_574247.call(path_574248, query_574249, nil, nil, nil)

var offersDelete* = Call_OffersDelete_574239(name: "offersDelete",
    meth: HttpMethod.HttpDelete,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/offers/{offer}",
    validator: validate_OffersDelete_574240, base: "", url: url_OffersDelete_574241,
    schemes: {Scheme.Https})
type
  Call_OffersLink_574250 = ref object of OpenApiRestCall_573658
proc url_OffersLink_574252(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/offers/"),
               (kind: VariableSegment, value: "offer"),
               (kind: ConstantSegment, value: "/link")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OffersLink_574251(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Links a plan to an offer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offer: JString (required)
  ##        : Name of an offer.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574253 = path.getOrDefault("resourceGroupName")
  valid_574253 = validateParameter(valid_574253, JString, required = true,
                                 default = nil)
  if valid_574253 != nil:
    section.add "resourceGroupName", valid_574253
  var valid_574254 = path.getOrDefault("subscriptionId")
  valid_574254 = validateParameter(valid_574254, JString, required = true,
                                 default = nil)
  if valid_574254 != nil:
    section.add "subscriptionId", valid_574254
  var valid_574255 = path.getOrDefault("offer")
  valid_574255 = validateParameter(valid_574255, JString, required = true,
                                 default = nil)
  if valid_574255 != nil:
    section.add "offer", valid_574255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574256 = query.getOrDefault("api-version")
  valid_574256 = validateParameter(valid_574256, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574256 != nil:
    section.add "api-version", valid_574256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   planLink: JObject (required)
  ##           : New plan link.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574258: Call_OffersLink_574250; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Links a plan to an offer.
  ## 
  let valid = call_574258.validator(path, query, header, formData, body)
  let scheme = call_574258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574258.url(scheme.get, call_574258.host, call_574258.base,
                         call_574258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574258, url, valid)

proc call*(call_574259: Call_OffersLink_574250; resourceGroupName: string;
          subscriptionId: string; offer: string; planLink: JsonNode;
          apiVersion: string = "2015-11-01"): Recallable =
  ## offersLink
  ## Links a plan to an offer.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offer: string (required)
  ##        : Name of an offer.
  ##   planLink: JObject (required)
  ##           : New plan link.
  var path_574260 = newJObject()
  var query_574261 = newJObject()
  var body_574262 = newJObject()
  add(path_574260, "resourceGroupName", newJString(resourceGroupName))
  add(query_574261, "api-version", newJString(apiVersion))
  add(path_574260, "subscriptionId", newJString(subscriptionId))
  add(path_574260, "offer", newJString(offer))
  if planLink != nil:
    body_574262 = planLink
  result = call_574259.call(path_574260, query_574261, nil, nil, body_574262)

var offersLink* = Call_OffersLink_574250(name: "offersLink",
                                      meth: HttpMethod.HttpPost, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/offers/{offer}/link",
                                      validator: validate_OffersLink_574251,
                                      base: "", url: url_OffersLink_574252,
                                      schemes: {Scheme.Https})
type
  Call_OffersListMetricDefinitions_574263 = ref object of OpenApiRestCall_573658
proc url_OffersListMetricDefinitions_574265(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/offers/"),
               (kind: VariableSegment, value: "offer"),
               (kind: ConstantSegment, value: "/metricDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OffersListMetricDefinitions_574264(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the metric definitions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offer: JString (required)
  ##        : Name of an offer.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574266 = path.getOrDefault("resourceGroupName")
  valid_574266 = validateParameter(valid_574266, JString, required = true,
                                 default = nil)
  if valid_574266 != nil:
    section.add "resourceGroupName", valid_574266
  var valid_574267 = path.getOrDefault("subscriptionId")
  valid_574267 = validateParameter(valid_574267, JString, required = true,
                                 default = nil)
  if valid_574267 != nil:
    section.add "subscriptionId", valid_574267
  var valid_574268 = path.getOrDefault("offer")
  valid_574268 = validateParameter(valid_574268, JString, required = true,
                                 default = nil)
  if valid_574268 != nil:
    section.add "offer", valid_574268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574269 = query.getOrDefault("api-version")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574269 != nil:
    section.add "api-version", valid_574269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574270: Call_OffersListMetricDefinitions_574263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the metric definitions.
  ## 
  let valid = call_574270.validator(path, query, header, formData, body)
  let scheme = call_574270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574270.url(scheme.get, call_574270.host, call_574270.base,
                         call_574270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574270, url, valid)

proc call*(call_574271: Call_OffersListMetricDefinitions_574263;
          resourceGroupName: string; subscriptionId: string; offer: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## offersListMetricDefinitions
  ## Get the metric definitions.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offer: string (required)
  ##        : Name of an offer.
  var path_574272 = newJObject()
  var query_574273 = newJObject()
  add(path_574272, "resourceGroupName", newJString(resourceGroupName))
  add(query_574273, "api-version", newJString(apiVersion))
  add(path_574272, "subscriptionId", newJString(subscriptionId))
  add(path_574272, "offer", newJString(offer))
  result = call_574271.call(path_574272, query_574273, nil, nil, nil)

var offersListMetricDefinitions* = Call_OffersListMetricDefinitions_574263(
    name: "offersListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/offers/{offer}/metricDefinitions",
    validator: validate_OffersListMetricDefinitions_574264, base: "",
    url: url_OffersListMetricDefinitions_574265, schemes: {Scheme.Https})
type
  Call_OffersListMetrics_574274 = ref object of OpenApiRestCall_573658
proc url_OffersListMetrics_574276(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/offers/"),
               (kind: VariableSegment, value: "offer"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OffersListMetrics_574275(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get the offer metrics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offer: JString (required)
  ##        : Name of an offer.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574277 = path.getOrDefault("resourceGroupName")
  valid_574277 = validateParameter(valid_574277, JString, required = true,
                                 default = nil)
  if valid_574277 != nil:
    section.add "resourceGroupName", valid_574277
  var valid_574278 = path.getOrDefault("subscriptionId")
  valid_574278 = validateParameter(valid_574278, JString, required = true,
                                 default = nil)
  if valid_574278 != nil:
    section.add "subscriptionId", valid_574278
  var valid_574279 = path.getOrDefault("offer")
  valid_574279 = validateParameter(valid_574279, JString, required = true,
                                 default = nil)
  if valid_574279 != nil:
    section.add "offer", valid_574279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574280 = query.getOrDefault("api-version")
  valid_574280 = validateParameter(valid_574280, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574280 != nil:
    section.add "api-version", valid_574280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574281: Call_OffersListMetrics_574274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the offer metrics.
  ## 
  let valid = call_574281.validator(path, query, header, formData, body)
  let scheme = call_574281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574281.url(scheme.get, call_574281.host, call_574281.base,
                         call_574281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574281, url, valid)

proc call*(call_574282: Call_OffersListMetrics_574274; resourceGroupName: string;
          subscriptionId: string; offer: string; apiVersion: string = "2015-11-01"): Recallable =
  ## offersListMetrics
  ## Get the offer metrics.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offer: string (required)
  ##        : Name of an offer.
  var path_574283 = newJObject()
  var query_574284 = newJObject()
  add(path_574283, "resourceGroupName", newJString(resourceGroupName))
  add(query_574284, "api-version", newJString(apiVersion))
  add(path_574283, "subscriptionId", newJString(subscriptionId))
  add(path_574283, "offer", newJString(offer))
  result = call_574282.call(path_574283, query_574284, nil, nil, nil)

var offersListMetrics* = Call_OffersListMetrics_574274(name: "offersListMetrics",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/offers/{offer}/metrics",
    validator: validate_OffersListMetrics_574275, base: "",
    url: url_OffersListMetrics_574276, schemes: {Scheme.Https})
type
  Call_OffersUnlink_574285 = ref object of OpenApiRestCall_573658
proc url_OffersUnlink_574287(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/offers/"),
               (kind: VariableSegment, value: "offer"),
               (kind: ConstantSegment, value: "/unlink")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OffersUnlink_574286(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Unlink a plan from an offer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offer: JString (required)
  ##        : Name of an offer.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574288 = path.getOrDefault("resourceGroupName")
  valid_574288 = validateParameter(valid_574288, JString, required = true,
                                 default = nil)
  if valid_574288 != nil:
    section.add "resourceGroupName", valid_574288
  var valid_574289 = path.getOrDefault("subscriptionId")
  valid_574289 = validateParameter(valid_574289, JString, required = true,
                                 default = nil)
  if valid_574289 != nil:
    section.add "subscriptionId", valid_574289
  var valid_574290 = path.getOrDefault("offer")
  valid_574290 = validateParameter(valid_574290, JString, required = true,
                                 default = nil)
  if valid_574290 != nil:
    section.add "offer", valid_574290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574291 = query.getOrDefault("api-version")
  valid_574291 = validateParameter(valid_574291, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574291 != nil:
    section.add "api-version", valid_574291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   planLink: JObject (required)
  ##           : New plan link.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574293: Call_OffersUnlink_574285; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unlink a plan from an offer.
  ## 
  let valid = call_574293.validator(path, query, header, formData, body)
  let scheme = call_574293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574293.url(scheme.get, call_574293.host, call_574293.base,
                         call_574293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574293, url, valid)

proc call*(call_574294: Call_OffersUnlink_574285; resourceGroupName: string;
          subscriptionId: string; offer: string; planLink: JsonNode;
          apiVersion: string = "2015-11-01"): Recallable =
  ## offersUnlink
  ## Unlink a plan from an offer.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offer: string (required)
  ##        : Name of an offer.
  ##   planLink: JObject (required)
  ##           : New plan link.
  var path_574295 = newJObject()
  var query_574296 = newJObject()
  var body_574297 = newJObject()
  add(path_574295, "resourceGroupName", newJString(resourceGroupName))
  add(query_574296, "api-version", newJString(apiVersion))
  add(path_574295, "subscriptionId", newJString(subscriptionId))
  add(path_574295, "offer", newJString(offer))
  if planLink != nil:
    body_574297 = planLink
  result = call_574294.call(path_574295, query_574296, nil, nil, body_574297)

var offersUnlink* = Call_OffersUnlink_574285(name: "offersUnlink",
    meth: HttpMethod.HttpPost, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/offers/{offer}/unlink",
    validator: validate_OffersUnlink_574286, base: "", url: url_OffersUnlink_574287,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
