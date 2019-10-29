
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: MarketplaceOrdering.Agreements
## version: 2015-06-01
## termsOfService: (not provided)
## license: (not provided)
## 
## REST API for MarketplaceOrdering Agreements.
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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "marketplaceordering-Agreements"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563761 = ref object of OpenApiRestCall_563539
proc url_OperationsList_563763(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563762(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Microsoft.MarketplaceOrdering REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563924 = query.getOrDefault("api-version")
  valid_563924 = validateParameter(valid_563924, JString, required = true,
                                 default = nil)
  if valid_563924 != nil:
    section.add "api-version", valid_563924
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563947: Call_OperationsList_563761; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.MarketplaceOrdering REST API operations.
  ## 
  let valid = call_563947.validator(path, query, header, formData, body)
  let scheme = call_563947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563947.url(scheme.get, call_563947.host, call_563947.base,
                         call_563947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563947, url, valid)

proc call*(call_564018: Call_OperationsList_563761; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Microsoft.MarketplaceOrdering REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  var query_564019 = newJObject()
  add(query_564019, "api-version", newJString(apiVersion))
  result = call_564018.call(nil, query_564019, nil, nil, nil)

var operationsList* = Call_OperationsList_563761(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.MarketplaceOrdering/operations",
    validator: validate_OperationsList_563762, base: "", url: url_OperationsList_563763,
    schemes: {Scheme.Https})
type
  Call_MarketplaceAgreementsList_564059 = ref object of OpenApiRestCall_563539
proc url_MarketplaceAgreementsList_564061(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.MarketplaceOrdering/agreements")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplaceAgreementsList_564060(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List marketplace agreements in the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564076 = path.getOrDefault("subscriptionId")
  valid_564076 = validateParameter(valid_564076, JString, required = true,
                                 default = nil)
  if valid_564076 != nil:
    section.add "subscriptionId", valid_564076
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564077 = query.getOrDefault("api-version")
  valid_564077 = validateParameter(valid_564077, JString, required = true,
                                 default = nil)
  if valid_564077 != nil:
    section.add "api-version", valid_564077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564078: Call_MarketplaceAgreementsList_564059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List marketplace agreements in the subscription.
  ## 
  let valid = call_564078.validator(path, query, header, formData, body)
  let scheme = call_564078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564078.url(scheme.get, call_564078.host, call_564078.base,
                         call_564078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564078, url, valid)

proc call*(call_564079: Call_MarketplaceAgreementsList_564059; apiVersion: string;
          subscriptionId: string): Recallable =
  ## marketplaceAgreementsList
  ## List marketplace agreements in the subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_564080 = newJObject()
  var query_564081 = newJObject()
  add(query_564081, "api-version", newJString(apiVersion))
  add(path_564080, "subscriptionId", newJString(subscriptionId))
  result = call_564079.call(path_564080, query_564081, nil, nil, nil)

var marketplaceAgreementsList* = Call_MarketplaceAgreementsList_564059(
    name: "marketplaceAgreementsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MarketplaceOrdering/agreements",
    validator: validate_MarketplaceAgreementsList_564060, base: "",
    url: url_MarketplaceAgreementsList_564061, schemes: {Scheme.Https})
type
  Call_MarketplaceAgreementsGetAgreement_564082 = ref object of OpenApiRestCall_563539
proc url_MarketplaceAgreementsGetAgreement_564084(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "publisherId" in path, "`publisherId` is a required path parameter"
  assert "offerId" in path, "`offerId` is a required path parameter"
  assert "planId" in path, "`planId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MarketplaceOrdering/agreements/"),
               (kind: VariableSegment, value: "publisherId"),
               (kind: ConstantSegment, value: "/offers/"),
               (kind: VariableSegment, value: "offerId"),
               (kind: ConstantSegment, value: "/plans/"),
               (kind: VariableSegment, value: "planId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplaceAgreementsGetAgreement_564083(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get marketplace agreement.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   publisherId: JString (required)
  ##              : Publisher identifier string of image being deployed.
  ##   offerId: JString (required)
  ##          : Offer identifier string of image being deployed.
  ##   planId: JString (required)
  ##         : Plan identifier string of image being deployed.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `publisherId` field"
  var valid_564085 = path.getOrDefault("publisherId")
  valid_564085 = validateParameter(valid_564085, JString, required = true,
                                 default = nil)
  if valid_564085 != nil:
    section.add "publisherId", valid_564085
  var valid_564086 = path.getOrDefault("offerId")
  valid_564086 = validateParameter(valid_564086, JString, required = true,
                                 default = nil)
  if valid_564086 != nil:
    section.add "offerId", valid_564086
  var valid_564087 = path.getOrDefault("planId")
  valid_564087 = validateParameter(valid_564087, JString, required = true,
                                 default = nil)
  if valid_564087 != nil:
    section.add "planId", valid_564087
  var valid_564088 = path.getOrDefault("subscriptionId")
  valid_564088 = validateParameter(valid_564088, JString, required = true,
                                 default = nil)
  if valid_564088 != nil:
    section.add "subscriptionId", valid_564088
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564089 = query.getOrDefault("api-version")
  valid_564089 = validateParameter(valid_564089, JString, required = true,
                                 default = nil)
  if valid_564089 != nil:
    section.add "api-version", valid_564089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564090: Call_MarketplaceAgreementsGetAgreement_564082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get marketplace agreement.
  ## 
  let valid = call_564090.validator(path, query, header, formData, body)
  let scheme = call_564090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564090.url(scheme.get, call_564090.host, call_564090.base,
                         call_564090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564090, url, valid)

proc call*(call_564091: Call_MarketplaceAgreementsGetAgreement_564082;
          publisherId: string; apiVersion: string; offerId: string; planId: string;
          subscriptionId: string): Recallable =
  ## marketplaceAgreementsGetAgreement
  ## Get marketplace agreement.
  ##   publisherId: string (required)
  ##              : Publisher identifier string of image being deployed.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   offerId: string (required)
  ##          : Offer identifier string of image being deployed.
  ##   planId: string (required)
  ##         : Plan identifier string of image being deployed.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_564092 = newJObject()
  var query_564093 = newJObject()
  add(path_564092, "publisherId", newJString(publisherId))
  add(query_564093, "api-version", newJString(apiVersion))
  add(path_564092, "offerId", newJString(offerId))
  add(path_564092, "planId", newJString(planId))
  add(path_564092, "subscriptionId", newJString(subscriptionId))
  result = call_564091.call(path_564092, query_564093, nil, nil, nil)

var marketplaceAgreementsGetAgreement* = Call_MarketplaceAgreementsGetAgreement_564082(
    name: "marketplaceAgreementsGetAgreement", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MarketplaceOrdering/agreements/{publisherId}/offers/{offerId}/plans/{planId}",
    validator: validate_MarketplaceAgreementsGetAgreement_564083, base: "",
    url: url_MarketplaceAgreementsGetAgreement_564084, schemes: {Scheme.Https})
type
  Call_MarketplaceAgreementsCancel_564094 = ref object of OpenApiRestCall_563539
proc url_MarketplaceAgreementsCancel_564096(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "publisherId" in path, "`publisherId` is a required path parameter"
  assert "offerId" in path, "`offerId` is a required path parameter"
  assert "planId" in path, "`planId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MarketplaceOrdering/agreements/"),
               (kind: VariableSegment, value: "publisherId"),
               (kind: ConstantSegment, value: "/offers/"),
               (kind: VariableSegment, value: "offerId"),
               (kind: ConstantSegment, value: "/plans/"),
               (kind: VariableSegment, value: "planId"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplaceAgreementsCancel_564095(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancel marketplace terms.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   publisherId: JString (required)
  ##              : Publisher identifier string of image being deployed.
  ##   offerId: JString (required)
  ##          : Offer identifier string of image being deployed.
  ##   planId: JString (required)
  ##         : Plan identifier string of image being deployed.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `publisherId` field"
  var valid_564097 = path.getOrDefault("publisherId")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "publisherId", valid_564097
  var valid_564098 = path.getOrDefault("offerId")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "offerId", valid_564098
  var valid_564099 = path.getOrDefault("planId")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "planId", valid_564099
  var valid_564100 = path.getOrDefault("subscriptionId")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "subscriptionId", valid_564100
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564101 = query.getOrDefault("api-version")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "api-version", valid_564101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564102: Call_MarketplaceAgreementsCancel_564094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel marketplace terms.
  ## 
  let valid = call_564102.validator(path, query, header, formData, body)
  let scheme = call_564102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564102.url(scheme.get, call_564102.host, call_564102.base,
                         call_564102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564102, url, valid)

proc call*(call_564103: Call_MarketplaceAgreementsCancel_564094;
          publisherId: string; apiVersion: string; offerId: string; planId: string;
          subscriptionId: string): Recallable =
  ## marketplaceAgreementsCancel
  ## Cancel marketplace terms.
  ##   publisherId: string (required)
  ##              : Publisher identifier string of image being deployed.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   offerId: string (required)
  ##          : Offer identifier string of image being deployed.
  ##   planId: string (required)
  ##         : Plan identifier string of image being deployed.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_564104 = newJObject()
  var query_564105 = newJObject()
  add(path_564104, "publisherId", newJString(publisherId))
  add(query_564105, "api-version", newJString(apiVersion))
  add(path_564104, "offerId", newJString(offerId))
  add(path_564104, "planId", newJString(planId))
  add(path_564104, "subscriptionId", newJString(subscriptionId))
  result = call_564103.call(path_564104, query_564105, nil, nil, nil)

var marketplaceAgreementsCancel* = Call_MarketplaceAgreementsCancel_564094(
    name: "marketplaceAgreementsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MarketplaceOrdering/agreements/{publisherId}/offers/{offerId}/plans/{planId}/cancel",
    validator: validate_MarketplaceAgreementsCancel_564095, base: "",
    url: url_MarketplaceAgreementsCancel_564096, schemes: {Scheme.Https})
type
  Call_MarketplaceAgreementsSign_564106 = ref object of OpenApiRestCall_563539
proc url_MarketplaceAgreementsSign_564108(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "publisherId" in path, "`publisherId` is a required path parameter"
  assert "offerId" in path, "`offerId` is a required path parameter"
  assert "planId" in path, "`planId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MarketplaceOrdering/agreements/"),
               (kind: VariableSegment, value: "publisherId"),
               (kind: ConstantSegment, value: "/offers/"),
               (kind: VariableSegment, value: "offerId"),
               (kind: ConstantSegment, value: "/plans/"),
               (kind: VariableSegment, value: "planId"),
               (kind: ConstantSegment, value: "/sign")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplaceAgreementsSign_564107(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sign marketplace terms.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   publisherId: JString (required)
  ##              : Publisher identifier string of image being deployed.
  ##   offerId: JString (required)
  ##          : Offer identifier string of image being deployed.
  ##   planId: JString (required)
  ##         : Plan identifier string of image being deployed.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `publisherId` field"
  var valid_564109 = path.getOrDefault("publisherId")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "publisherId", valid_564109
  var valid_564110 = path.getOrDefault("offerId")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "offerId", valid_564110
  var valid_564111 = path.getOrDefault("planId")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "planId", valid_564111
  var valid_564112 = path.getOrDefault("subscriptionId")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "subscriptionId", valid_564112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564113 = query.getOrDefault("api-version")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "api-version", valid_564113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564114: Call_MarketplaceAgreementsSign_564106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sign marketplace terms.
  ## 
  let valid = call_564114.validator(path, query, header, formData, body)
  let scheme = call_564114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564114.url(scheme.get, call_564114.host, call_564114.base,
                         call_564114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564114, url, valid)

proc call*(call_564115: Call_MarketplaceAgreementsSign_564106; publisherId: string;
          apiVersion: string; offerId: string; planId: string; subscriptionId: string): Recallable =
  ## marketplaceAgreementsSign
  ## Sign marketplace terms.
  ##   publisherId: string (required)
  ##              : Publisher identifier string of image being deployed.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   offerId: string (required)
  ##          : Offer identifier string of image being deployed.
  ##   planId: string (required)
  ##         : Plan identifier string of image being deployed.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_564116 = newJObject()
  var query_564117 = newJObject()
  add(path_564116, "publisherId", newJString(publisherId))
  add(query_564117, "api-version", newJString(apiVersion))
  add(path_564116, "offerId", newJString(offerId))
  add(path_564116, "planId", newJString(planId))
  add(path_564116, "subscriptionId", newJString(subscriptionId))
  result = call_564115.call(path_564116, query_564117, nil, nil, nil)

var marketplaceAgreementsSign* = Call_MarketplaceAgreementsSign_564106(
    name: "marketplaceAgreementsSign", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MarketplaceOrdering/agreements/{publisherId}/offers/{offerId}/plans/{planId}/sign",
    validator: validate_MarketplaceAgreementsSign_564107, base: "",
    url: url_MarketplaceAgreementsSign_564108, schemes: {Scheme.Https})
type
  Call_MarketplaceAgreementsCreate_564144 = ref object of OpenApiRestCall_563539
proc url_MarketplaceAgreementsCreate_564146(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "offerType" in path, "`offerType` is a required path parameter"
  assert "publisherId" in path, "`publisherId` is a required path parameter"
  assert "offerId" in path, "`offerId` is a required path parameter"
  assert "planId" in path, "`planId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MarketplaceOrdering/offerTypes/"),
               (kind: VariableSegment, value: "offerType"),
               (kind: ConstantSegment, value: "/publishers/"),
               (kind: VariableSegment, value: "publisherId"),
               (kind: ConstantSegment, value: "/offers/"),
               (kind: VariableSegment, value: "offerId"),
               (kind: ConstantSegment, value: "/plans/"),
               (kind: VariableSegment, value: "planId"),
               (kind: ConstantSegment, value: "/agreements/current")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplaceAgreementsCreate_564145(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Save marketplace terms.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   publisherId: JString (required)
  ##              : Publisher identifier string of image being deployed.
  ##   offerId: JString (required)
  ##          : Offer identifier string of image being deployed.
  ##   planId: JString (required)
  ##         : Plan identifier string of image being deployed.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   offerType: JString (required)
  ##            : Offer Type, currently only virtualmachine type is supported.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `publisherId` field"
  var valid_564164 = path.getOrDefault("publisherId")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "publisherId", valid_564164
  var valid_564165 = path.getOrDefault("offerId")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "offerId", valid_564165
  var valid_564166 = path.getOrDefault("planId")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "planId", valid_564166
  var valid_564167 = path.getOrDefault("subscriptionId")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "subscriptionId", valid_564167
  var valid_564168 = path.getOrDefault("offerType")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = newJString("virtualmachine"))
  if valid_564168 != nil:
    section.add "offerType", valid_564168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564169 = query.getOrDefault("api-version")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "api-version", valid_564169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Marketplace Terms operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564171: Call_MarketplaceAgreementsCreate_564144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Save marketplace terms.
  ## 
  let valid = call_564171.validator(path, query, header, formData, body)
  let scheme = call_564171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564171.url(scheme.get, call_564171.host, call_564171.base,
                         call_564171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564171, url, valid)

proc call*(call_564172: Call_MarketplaceAgreementsCreate_564144;
          publisherId: string; apiVersion: string; offerId: string; planId: string;
          subscriptionId: string; parameters: JsonNode;
          offerType: string = "virtualmachine"): Recallable =
  ## marketplaceAgreementsCreate
  ## Save marketplace terms.
  ##   publisherId: string (required)
  ##              : Publisher identifier string of image being deployed.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   offerId: string (required)
  ##          : Offer identifier string of image being deployed.
  ##   planId: string (required)
  ##         : Plan identifier string of image being deployed.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   offerType: string (required)
  ##            : Offer Type, currently only virtualmachine type is supported.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Marketplace Terms operation.
  var path_564173 = newJObject()
  var query_564174 = newJObject()
  var body_564175 = newJObject()
  add(path_564173, "publisherId", newJString(publisherId))
  add(query_564174, "api-version", newJString(apiVersion))
  add(path_564173, "offerId", newJString(offerId))
  add(path_564173, "planId", newJString(planId))
  add(path_564173, "subscriptionId", newJString(subscriptionId))
  add(path_564173, "offerType", newJString(offerType))
  if parameters != nil:
    body_564175 = parameters
  result = call_564172.call(path_564173, query_564174, nil, nil, body_564175)

var marketplaceAgreementsCreate* = Call_MarketplaceAgreementsCreate_564144(
    name: "marketplaceAgreementsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MarketplaceOrdering/offerTypes/{offerType}/publishers/{publisherId}/offers/{offerId}/plans/{planId}/agreements/current",
    validator: validate_MarketplaceAgreementsCreate_564145, base: "",
    url: url_MarketplaceAgreementsCreate_564146, schemes: {Scheme.Https})
type
  Call_MarketplaceAgreementsGet_564118 = ref object of OpenApiRestCall_563539
proc url_MarketplaceAgreementsGet_564120(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "offerType" in path, "`offerType` is a required path parameter"
  assert "publisherId" in path, "`publisherId` is a required path parameter"
  assert "offerId" in path, "`offerId` is a required path parameter"
  assert "planId" in path, "`planId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MarketplaceOrdering/offerTypes/"),
               (kind: VariableSegment, value: "offerType"),
               (kind: ConstantSegment, value: "/publishers/"),
               (kind: VariableSegment, value: "publisherId"),
               (kind: ConstantSegment, value: "/offers/"),
               (kind: VariableSegment, value: "offerId"),
               (kind: ConstantSegment, value: "/plans/"),
               (kind: VariableSegment, value: "planId"),
               (kind: ConstantSegment, value: "/agreements/current")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MarketplaceAgreementsGet_564119(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get marketplace terms.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   publisherId: JString (required)
  ##              : Publisher identifier string of image being deployed.
  ##   offerId: JString (required)
  ##          : Offer identifier string of image being deployed.
  ##   planId: JString (required)
  ##         : Plan identifier string of image being deployed.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   offerType: JString (required)
  ##            : Offer Type, currently only virtualmachine type is supported.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `publisherId` field"
  var valid_564121 = path.getOrDefault("publisherId")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "publisherId", valid_564121
  var valid_564122 = path.getOrDefault("offerId")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "offerId", valid_564122
  var valid_564123 = path.getOrDefault("planId")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "planId", valid_564123
  var valid_564124 = path.getOrDefault("subscriptionId")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "subscriptionId", valid_564124
  var valid_564138 = path.getOrDefault("offerType")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = newJString("virtualmachine"))
  if valid_564138 != nil:
    section.add "offerType", valid_564138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564139 = query.getOrDefault("api-version")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "api-version", valid_564139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564140: Call_MarketplaceAgreementsGet_564118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get marketplace terms.
  ## 
  let valid = call_564140.validator(path, query, header, formData, body)
  let scheme = call_564140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564140.url(scheme.get, call_564140.host, call_564140.base,
                         call_564140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564140, url, valid)

proc call*(call_564141: Call_MarketplaceAgreementsGet_564118; publisherId: string;
          apiVersion: string; offerId: string; planId: string; subscriptionId: string;
          offerType: string = "virtualmachine"): Recallable =
  ## marketplaceAgreementsGet
  ## Get marketplace terms.
  ##   publisherId: string (required)
  ##              : Publisher identifier string of image being deployed.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   offerId: string (required)
  ##          : Offer identifier string of image being deployed.
  ##   planId: string (required)
  ##         : Plan identifier string of image being deployed.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   offerType: string (required)
  ##            : Offer Type, currently only virtualmachine type is supported.
  var path_564142 = newJObject()
  var query_564143 = newJObject()
  add(path_564142, "publisherId", newJString(publisherId))
  add(query_564143, "api-version", newJString(apiVersion))
  add(path_564142, "offerId", newJString(offerId))
  add(path_564142, "planId", newJString(planId))
  add(path_564142, "subscriptionId", newJString(subscriptionId))
  add(path_564142, "offerType", newJString(offerType))
  result = call_564141.call(path_564142, query_564143, nil, nil, nil)

var marketplaceAgreementsGet* = Call_MarketplaceAgreementsGet_564118(
    name: "marketplaceAgreementsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MarketplaceOrdering/offerTypes/{offerType}/publishers/{publisherId}/offers/{offerId}/plans/{planId}/agreements/current",
    validator: validate_MarketplaceAgreementsGet_564119, base: "",
    url: url_MarketplaceAgreementsGet_564120, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
