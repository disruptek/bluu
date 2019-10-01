
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "marketplaceordering-Agreements"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567863 = ref object of OpenApiRestCall_567641
proc url_OperationsList_567865(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567864(path: JsonNode; query: JsonNode;
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
  var valid_568024 = query.getOrDefault("api-version")
  valid_568024 = validateParameter(valid_568024, JString, required = true,
                                 default = nil)
  if valid_568024 != nil:
    section.add "api-version", valid_568024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568047: Call_OperationsList_567863; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.MarketplaceOrdering REST API operations.
  ## 
  let valid = call_568047.validator(path, query, header, formData, body)
  let scheme = call_568047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568047.url(scheme.get, call_568047.host, call_568047.base,
                         call_568047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568047, url, valid)

proc call*(call_568118: Call_OperationsList_567863; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Microsoft.MarketplaceOrdering REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  var query_568119 = newJObject()
  add(query_568119, "api-version", newJString(apiVersion))
  result = call_568118.call(nil, query_568119, nil, nil, nil)

var operationsList* = Call_OperationsList_567863(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.MarketplaceOrdering/operations",
    validator: validate_OperationsList_567864, base: "", url: url_OperationsList_567865,
    schemes: {Scheme.Https})
type
  Call_MarketplaceAgreementsList_568159 = ref object of OpenApiRestCall_567641
proc url_MarketplaceAgreementsList_568161(protocol: Scheme; host: string;
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

proc validate_MarketplaceAgreementsList_568160(path: JsonNode; query: JsonNode;
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
  var valid_568176 = path.getOrDefault("subscriptionId")
  valid_568176 = validateParameter(valid_568176, JString, required = true,
                                 default = nil)
  if valid_568176 != nil:
    section.add "subscriptionId", valid_568176
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568177 = query.getOrDefault("api-version")
  valid_568177 = validateParameter(valid_568177, JString, required = true,
                                 default = nil)
  if valid_568177 != nil:
    section.add "api-version", valid_568177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568178: Call_MarketplaceAgreementsList_568159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List marketplace agreements in the subscription.
  ## 
  let valid = call_568178.validator(path, query, header, formData, body)
  let scheme = call_568178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568178.url(scheme.get, call_568178.host, call_568178.base,
                         call_568178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568178, url, valid)

proc call*(call_568179: Call_MarketplaceAgreementsList_568159; apiVersion: string;
          subscriptionId: string): Recallable =
  ## marketplaceAgreementsList
  ## List marketplace agreements in the subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568180 = newJObject()
  var query_568181 = newJObject()
  add(query_568181, "api-version", newJString(apiVersion))
  add(path_568180, "subscriptionId", newJString(subscriptionId))
  result = call_568179.call(path_568180, query_568181, nil, nil, nil)

var marketplaceAgreementsList* = Call_MarketplaceAgreementsList_568159(
    name: "marketplaceAgreementsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MarketplaceOrdering/agreements",
    validator: validate_MarketplaceAgreementsList_568160, base: "",
    url: url_MarketplaceAgreementsList_568161, schemes: {Scheme.Https})
type
  Call_MarketplaceAgreementsGetAgreement_568182 = ref object of OpenApiRestCall_567641
proc url_MarketplaceAgreementsGetAgreement_568184(protocol: Scheme; host: string;
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

proc validate_MarketplaceAgreementsGetAgreement_568183(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get marketplace agreement.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   offerId: JString (required)
  ##          : Offer identifier string of image being deployed.
  ##   planId: JString (required)
  ##         : Plan identifier string of image being deployed.
  ##   publisherId: JString (required)
  ##              : Publisher identifier string of image being deployed.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `offerId` field"
  var valid_568185 = path.getOrDefault("offerId")
  valid_568185 = validateParameter(valid_568185, JString, required = true,
                                 default = nil)
  if valid_568185 != nil:
    section.add "offerId", valid_568185
  var valid_568186 = path.getOrDefault("planId")
  valid_568186 = validateParameter(valid_568186, JString, required = true,
                                 default = nil)
  if valid_568186 != nil:
    section.add "planId", valid_568186
  var valid_568187 = path.getOrDefault("publisherId")
  valid_568187 = validateParameter(valid_568187, JString, required = true,
                                 default = nil)
  if valid_568187 != nil:
    section.add "publisherId", valid_568187
  var valid_568188 = path.getOrDefault("subscriptionId")
  valid_568188 = validateParameter(valid_568188, JString, required = true,
                                 default = nil)
  if valid_568188 != nil:
    section.add "subscriptionId", valid_568188
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568189 = query.getOrDefault("api-version")
  valid_568189 = validateParameter(valid_568189, JString, required = true,
                                 default = nil)
  if valid_568189 != nil:
    section.add "api-version", valid_568189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568190: Call_MarketplaceAgreementsGetAgreement_568182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get marketplace agreement.
  ## 
  let valid = call_568190.validator(path, query, header, formData, body)
  let scheme = call_568190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568190.url(scheme.get, call_568190.host, call_568190.base,
                         call_568190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568190, url, valid)

proc call*(call_568191: Call_MarketplaceAgreementsGetAgreement_568182;
          apiVersion: string; offerId: string; planId: string; publisherId: string;
          subscriptionId: string): Recallable =
  ## marketplaceAgreementsGetAgreement
  ## Get marketplace agreement.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   offerId: string (required)
  ##          : Offer identifier string of image being deployed.
  ##   planId: string (required)
  ##         : Plan identifier string of image being deployed.
  ##   publisherId: string (required)
  ##              : Publisher identifier string of image being deployed.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568192 = newJObject()
  var query_568193 = newJObject()
  add(query_568193, "api-version", newJString(apiVersion))
  add(path_568192, "offerId", newJString(offerId))
  add(path_568192, "planId", newJString(planId))
  add(path_568192, "publisherId", newJString(publisherId))
  add(path_568192, "subscriptionId", newJString(subscriptionId))
  result = call_568191.call(path_568192, query_568193, nil, nil, nil)

var marketplaceAgreementsGetAgreement* = Call_MarketplaceAgreementsGetAgreement_568182(
    name: "marketplaceAgreementsGetAgreement", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MarketplaceOrdering/agreements/{publisherId}/offers/{offerId}/plans/{planId}",
    validator: validate_MarketplaceAgreementsGetAgreement_568183, base: "",
    url: url_MarketplaceAgreementsGetAgreement_568184, schemes: {Scheme.Https})
type
  Call_MarketplaceAgreementsCancel_568194 = ref object of OpenApiRestCall_567641
proc url_MarketplaceAgreementsCancel_568196(protocol: Scheme; host: string;
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

proc validate_MarketplaceAgreementsCancel_568195(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancel marketplace terms.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   offerId: JString (required)
  ##          : Offer identifier string of image being deployed.
  ##   planId: JString (required)
  ##         : Plan identifier string of image being deployed.
  ##   publisherId: JString (required)
  ##              : Publisher identifier string of image being deployed.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `offerId` field"
  var valid_568197 = path.getOrDefault("offerId")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "offerId", valid_568197
  var valid_568198 = path.getOrDefault("planId")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "planId", valid_568198
  var valid_568199 = path.getOrDefault("publisherId")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "publisherId", valid_568199
  var valid_568200 = path.getOrDefault("subscriptionId")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "subscriptionId", valid_568200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568201 = query.getOrDefault("api-version")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "api-version", valid_568201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568202: Call_MarketplaceAgreementsCancel_568194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel marketplace terms.
  ## 
  let valid = call_568202.validator(path, query, header, formData, body)
  let scheme = call_568202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568202.url(scheme.get, call_568202.host, call_568202.base,
                         call_568202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568202, url, valid)

proc call*(call_568203: Call_MarketplaceAgreementsCancel_568194;
          apiVersion: string; offerId: string; planId: string; publisherId: string;
          subscriptionId: string): Recallable =
  ## marketplaceAgreementsCancel
  ## Cancel marketplace terms.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   offerId: string (required)
  ##          : Offer identifier string of image being deployed.
  ##   planId: string (required)
  ##         : Plan identifier string of image being deployed.
  ##   publisherId: string (required)
  ##              : Publisher identifier string of image being deployed.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568204 = newJObject()
  var query_568205 = newJObject()
  add(query_568205, "api-version", newJString(apiVersion))
  add(path_568204, "offerId", newJString(offerId))
  add(path_568204, "planId", newJString(planId))
  add(path_568204, "publisherId", newJString(publisherId))
  add(path_568204, "subscriptionId", newJString(subscriptionId))
  result = call_568203.call(path_568204, query_568205, nil, nil, nil)

var marketplaceAgreementsCancel* = Call_MarketplaceAgreementsCancel_568194(
    name: "marketplaceAgreementsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MarketplaceOrdering/agreements/{publisherId}/offers/{offerId}/plans/{planId}/cancel",
    validator: validate_MarketplaceAgreementsCancel_568195, base: "",
    url: url_MarketplaceAgreementsCancel_568196, schemes: {Scheme.Https})
type
  Call_MarketplaceAgreementsSign_568206 = ref object of OpenApiRestCall_567641
proc url_MarketplaceAgreementsSign_568208(protocol: Scheme; host: string;
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

proc validate_MarketplaceAgreementsSign_568207(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sign marketplace terms.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   offerId: JString (required)
  ##          : Offer identifier string of image being deployed.
  ##   planId: JString (required)
  ##         : Plan identifier string of image being deployed.
  ##   publisherId: JString (required)
  ##              : Publisher identifier string of image being deployed.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `offerId` field"
  var valid_568209 = path.getOrDefault("offerId")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "offerId", valid_568209
  var valid_568210 = path.getOrDefault("planId")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "planId", valid_568210
  var valid_568211 = path.getOrDefault("publisherId")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "publisherId", valid_568211
  var valid_568212 = path.getOrDefault("subscriptionId")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "subscriptionId", valid_568212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
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

proc call*(call_568214: Call_MarketplaceAgreementsSign_568206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sign marketplace terms.
  ## 
  let valid = call_568214.validator(path, query, header, formData, body)
  let scheme = call_568214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568214.url(scheme.get, call_568214.host, call_568214.base,
                         call_568214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568214, url, valid)

proc call*(call_568215: Call_MarketplaceAgreementsSign_568206; apiVersion: string;
          offerId: string; planId: string; publisherId: string; subscriptionId: string): Recallable =
  ## marketplaceAgreementsSign
  ## Sign marketplace terms.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   offerId: string (required)
  ##          : Offer identifier string of image being deployed.
  ##   planId: string (required)
  ##         : Plan identifier string of image being deployed.
  ##   publisherId: string (required)
  ##              : Publisher identifier string of image being deployed.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568216 = newJObject()
  var query_568217 = newJObject()
  add(query_568217, "api-version", newJString(apiVersion))
  add(path_568216, "offerId", newJString(offerId))
  add(path_568216, "planId", newJString(planId))
  add(path_568216, "publisherId", newJString(publisherId))
  add(path_568216, "subscriptionId", newJString(subscriptionId))
  result = call_568215.call(path_568216, query_568217, nil, nil, nil)

var marketplaceAgreementsSign* = Call_MarketplaceAgreementsSign_568206(
    name: "marketplaceAgreementsSign", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MarketplaceOrdering/agreements/{publisherId}/offers/{offerId}/plans/{planId}/sign",
    validator: validate_MarketplaceAgreementsSign_568207, base: "",
    url: url_MarketplaceAgreementsSign_568208, schemes: {Scheme.Https})
type
  Call_MarketplaceAgreementsCreate_568244 = ref object of OpenApiRestCall_567641
proc url_MarketplaceAgreementsCreate_568246(protocol: Scheme; host: string;
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

proc validate_MarketplaceAgreementsCreate_568245(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Save marketplace terms.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   offerId: JString (required)
  ##          : Offer identifier string of image being deployed.
  ##   planId: JString (required)
  ##         : Plan identifier string of image being deployed.
  ##   publisherId: JString (required)
  ##              : Publisher identifier string of image being deployed.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   offerType: JString (required)
  ##            : Offer Type, currently only virtualmachine type is supported.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `offerId` field"
  var valid_568264 = path.getOrDefault("offerId")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "offerId", valid_568264
  var valid_568265 = path.getOrDefault("planId")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "planId", valid_568265
  var valid_568266 = path.getOrDefault("publisherId")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "publisherId", valid_568266
  var valid_568267 = path.getOrDefault("subscriptionId")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "subscriptionId", valid_568267
  var valid_568268 = path.getOrDefault("offerType")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = newJString("virtualmachine"))
  if valid_568268 != nil:
    section.add "offerType", valid_568268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Marketplace Terms operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568271: Call_MarketplaceAgreementsCreate_568244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Save marketplace terms.
  ## 
  let valid = call_568271.validator(path, query, header, formData, body)
  let scheme = call_568271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568271.url(scheme.get, call_568271.host, call_568271.base,
                         call_568271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568271, url, valid)

proc call*(call_568272: Call_MarketplaceAgreementsCreate_568244;
          apiVersion: string; offerId: string; planId: string; publisherId: string;
          subscriptionId: string; parameters: JsonNode;
          offerType: string = "virtualmachine"): Recallable =
  ## marketplaceAgreementsCreate
  ## Save marketplace terms.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   offerId: string (required)
  ##          : Offer identifier string of image being deployed.
  ##   planId: string (required)
  ##         : Plan identifier string of image being deployed.
  ##   publisherId: string (required)
  ##              : Publisher identifier string of image being deployed.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   offerType: string (required)
  ##            : Offer Type, currently only virtualmachine type is supported.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Marketplace Terms operation.
  var path_568273 = newJObject()
  var query_568274 = newJObject()
  var body_568275 = newJObject()
  add(query_568274, "api-version", newJString(apiVersion))
  add(path_568273, "offerId", newJString(offerId))
  add(path_568273, "planId", newJString(planId))
  add(path_568273, "publisherId", newJString(publisherId))
  add(path_568273, "subscriptionId", newJString(subscriptionId))
  add(path_568273, "offerType", newJString(offerType))
  if parameters != nil:
    body_568275 = parameters
  result = call_568272.call(path_568273, query_568274, nil, nil, body_568275)

var marketplaceAgreementsCreate* = Call_MarketplaceAgreementsCreate_568244(
    name: "marketplaceAgreementsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MarketplaceOrdering/offerTypes/{offerType}/publishers/{publisherId}/offers/{offerId}/plans/{planId}/agreements/current",
    validator: validate_MarketplaceAgreementsCreate_568245, base: "",
    url: url_MarketplaceAgreementsCreate_568246, schemes: {Scheme.Https})
type
  Call_MarketplaceAgreementsGet_568218 = ref object of OpenApiRestCall_567641
proc url_MarketplaceAgreementsGet_568220(protocol: Scheme; host: string;
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

proc validate_MarketplaceAgreementsGet_568219(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get marketplace terms.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   offerId: JString (required)
  ##          : Offer identifier string of image being deployed.
  ##   planId: JString (required)
  ##         : Plan identifier string of image being deployed.
  ##   publisherId: JString (required)
  ##              : Publisher identifier string of image being deployed.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   offerType: JString (required)
  ##            : Offer Type, currently only virtualmachine type is supported.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `offerId` field"
  var valid_568221 = path.getOrDefault("offerId")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "offerId", valid_568221
  var valid_568222 = path.getOrDefault("planId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "planId", valid_568222
  var valid_568223 = path.getOrDefault("publisherId")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "publisherId", valid_568223
  var valid_568224 = path.getOrDefault("subscriptionId")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "subscriptionId", valid_568224
  var valid_568238 = path.getOrDefault("offerType")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = newJString("virtualmachine"))
  if valid_568238 != nil:
    section.add "offerType", valid_568238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
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

proc call*(call_568240: Call_MarketplaceAgreementsGet_568218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get marketplace terms.
  ## 
  let valid = call_568240.validator(path, query, header, formData, body)
  let scheme = call_568240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568240.url(scheme.get, call_568240.host, call_568240.base,
                         call_568240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568240, url, valid)

proc call*(call_568241: Call_MarketplaceAgreementsGet_568218; apiVersion: string;
          offerId: string; planId: string; publisherId: string;
          subscriptionId: string; offerType: string = "virtualmachine"): Recallable =
  ## marketplaceAgreementsGet
  ## Get marketplace terms.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   offerId: string (required)
  ##          : Offer identifier string of image being deployed.
  ##   planId: string (required)
  ##         : Plan identifier string of image being deployed.
  ##   publisherId: string (required)
  ##              : Publisher identifier string of image being deployed.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   offerType: string (required)
  ##            : Offer Type, currently only virtualmachine type is supported.
  var path_568242 = newJObject()
  var query_568243 = newJObject()
  add(query_568243, "api-version", newJString(apiVersion))
  add(path_568242, "offerId", newJString(offerId))
  add(path_568242, "planId", newJString(planId))
  add(path_568242, "publisherId", newJString(publisherId))
  add(path_568242, "subscriptionId", newJString(subscriptionId))
  add(path_568242, "offerType", newJString(offerType))
  result = call_568241.call(path_568242, query_568243, nil, nil, nil)

var marketplaceAgreementsGet* = Call_MarketplaceAgreementsGet_568218(
    name: "marketplaceAgreementsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MarketplaceOrdering/offerTypes/{offerType}/publishers/{publisherId}/offers/{offerId}/plans/{planId}/agreements/current",
    validator: validate_MarketplaceAgreementsGet_568219, base: "",
    url: url_MarketplaceAgreementsGet_568220, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
