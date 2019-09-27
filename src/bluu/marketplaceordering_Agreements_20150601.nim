
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  macServiceName = "marketplaceordering-Agreements"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593630 = ref object of OpenApiRestCall_593408
proc url_OperationsList_593632(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593631(path: JsonNode; query: JsonNode;
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
  var valid_593791 = query.getOrDefault("api-version")
  valid_593791 = validateParameter(valid_593791, JString, required = true,
                                 default = nil)
  if valid_593791 != nil:
    section.add "api-version", valid_593791
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593814: Call_OperationsList_593630; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.MarketplaceOrdering REST API operations.
  ## 
  let valid = call_593814.validator(path, query, header, formData, body)
  let scheme = call_593814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593814.url(scheme.get, call_593814.host, call_593814.base,
                         call_593814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593814, url, valid)

proc call*(call_593885: Call_OperationsList_593630; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Microsoft.MarketplaceOrdering REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  var query_593886 = newJObject()
  add(query_593886, "api-version", newJString(apiVersion))
  result = call_593885.call(nil, query_593886, nil, nil, nil)

var operationsList* = Call_OperationsList_593630(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.MarketplaceOrdering/operations",
    validator: validate_OperationsList_593631, base: "", url: url_OperationsList_593632,
    schemes: {Scheme.Https})
type
  Call_MarketplaceAgreementsList_593926 = ref object of OpenApiRestCall_593408
proc url_MarketplaceAgreementsList_593928(protocol: Scheme; host: string;
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

proc validate_MarketplaceAgreementsList_593927(path: JsonNode; query: JsonNode;
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
  var valid_593943 = path.getOrDefault("subscriptionId")
  valid_593943 = validateParameter(valid_593943, JString, required = true,
                                 default = nil)
  if valid_593943 != nil:
    section.add "subscriptionId", valid_593943
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593944 = query.getOrDefault("api-version")
  valid_593944 = validateParameter(valid_593944, JString, required = true,
                                 default = nil)
  if valid_593944 != nil:
    section.add "api-version", valid_593944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593945: Call_MarketplaceAgreementsList_593926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List marketplace agreements in the subscription.
  ## 
  let valid = call_593945.validator(path, query, header, formData, body)
  let scheme = call_593945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593945.url(scheme.get, call_593945.host, call_593945.base,
                         call_593945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593945, url, valid)

proc call*(call_593946: Call_MarketplaceAgreementsList_593926; apiVersion: string;
          subscriptionId: string): Recallable =
  ## marketplaceAgreementsList
  ## List marketplace agreements in the subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_593947 = newJObject()
  var query_593948 = newJObject()
  add(query_593948, "api-version", newJString(apiVersion))
  add(path_593947, "subscriptionId", newJString(subscriptionId))
  result = call_593946.call(path_593947, query_593948, nil, nil, nil)

var marketplaceAgreementsList* = Call_MarketplaceAgreementsList_593926(
    name: "marketplaceAgreementsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MarketplaceOrdering/agreements",
    validator: validate_MarketplaceAgreementsList_593927, base: "",
    url: url_MarketplaceAgreementsList_593928, schemes: {Scheme.Https})
type
  Call_MarketplaceAgreementsGetAgreement_593949 = ref object of OpenApiRestCall_593408
proc url_MarketplaceAgreementsGetAgreement_593951(protocol: Scheme; host: string;
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

proc validate_MarketplaceAgreementsGetAgreement_593950(path: JsonNode;
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
  var valid_593952 = path.getOrDefault("offerId")
  valid_593952 = validateParameter(valid_593952, JString, required = true,
                                 default = nil)
  if valid_593952 != nil:
    section.add "offerId", valid_593952
  var valid_593953 = path.getOrDefault("planId")
  valid_593953 = validateParameter(valid_593953, JString, required = true,
                                 default = nil)
  if valid_593953 != nil:
    section.add "planId", valid_593953
  var valid_593954 = path.getOrDefault("publisherId")
  valid_593954 = validateParameter(valid_593954, JString, required = true,
                                 default = nil)
  if valid_593954 != nil:
    section.add "publisherId", valid_593954
  var valid_593955 = path.getOrDefault("subscriptionId")
  valid_593955 = validateParameter(valid_593955, JString, required = true,
                                 default = nil)
  if valid_593955 != nil:
    section.add "subscriptionId", valid_593955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593956 = query.getOrDefault("api-version")
  valid_593956 = validateParameter(valid_593956, JString, required = true,
                                 default = nil)
  if valid_593956 != nil:
    section.add "api-version", valid_593956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593957: Call_MarketplaceAgreementsGetAgreement_593949;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get marketplace agreement.
  ## 
  let valid = call_593957.validator(path, query, header, formData, body)
  let scheme = call_593957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593957.url(scheme.get, call_593957.host, call_593957.base,
                         call_593957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593957, url, valid)

proc call*(call_593958: Call_MarketplaceAgreementsGetAgreement_593949;
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
  var path_593959 = newJObject()
  var query_593960 = newJObject()
  add(query_593960, "api-version", newJString(apiVersion))
  add(path_593959, "offerId", newJString(offerId))
  add(path_593959, "planId", newJString(planId))
  add(path_593959, "publisherId", newJString(publisherId))
  add(path_593959, "subscriptionId", newJString(subscriptionId))
  result = call_593958.call(path_593959, query_593960, nil, nil, nil)

var marketplaceAgreementsGetAgreement* = Call_MarketplaceAgreementsGetAgreement_593949(
    name: "marketplaceAgreementsGetAgreement", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MarketplaceOrdering/agreements/{publisherId}/offers/{offerId}/plans/{planId}",
    validator: validate_MarketplaceAgreementsGetAgreement_593950, base: "",
    url: url_MarketplaceAgreementsGetAgreement_593951, schemes: {Scheme.Https})
type
  Call_MarketplaceAgreementsCancel_593961 = ref object of OpenApiRestCall_593408
proc url_MarketplaceAgreementsCancel_593963(protocol: Scheme; host: string;
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

proc validate_MarketplaceAgreementsCancel_593962(path: JsonNode; query: JsonNode;
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
  var valid_593964 = path.getOrDefault("offerId")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "offerId", valid_593964
  var valid_593965 = path.getOrDefault("planId")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "planId", valid_593965
  var valid_593966 = path.getOrDefault("publisherId")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "publisherId", valid_593966
  var valid_593967 = path.getOrDefault("subscriptionId")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "subscriptionId", valid_593967
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593968 = query.getOrDefault("api-version")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "api-version", valid_593968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593969: Call_MarketplaceAgreementsCancel_593961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel marketplace terms.
  ## 
  let valid = call_593969.validator(path, query, header, formData, body)
  let scheme = call_593969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593969.url(scheme.get, call_593969.host, call_593969.base,
                         call_593969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593969, url, valid)

proc call*(call_593970: Call_MarketplaceAgreementsCancel_593961;
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
  var path_593971 = newJObject()
  var query_593972 = newJObject()
  add(query_593972, "api-version", newJString(apiVersion))
  add(path_593971, "offerId", newJString(offerId))
  add(path_593971, "planId", newJString(planId))
  add(path_593971, "publisherId", newJString(publisherId))
  add(path_593971, "subscriptionId", newJString(subscriptionId))
  result = call_593970.call(path_593971, query_593972, nil, nil, nil)

var marketplaceAgreementsCancel* = Call_MarketplaceAgreementsCancel_593961(
    name: "marketplaceAgreementsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MarketplaceOrdering/agreements/{publisherId}/offers/{offerId}/plans/{planId}/cancel",
    validator: validate_MarketplaceAgreementsCancel_593962, base: "",
    url: url_MarketplaceAgreementsCancel_593963, schemes: {Scheme.Https})
type
  Call_MarketplaceAgreementsSign_593973 = ref object of OpenApiRestCall_593408
proc url_MarketplaceAgreementsSign_593975(protocol: Scheme; host: string;
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

proc validate_MarketplaceAgreementsSign_593974(path: JsonNode; query: JsonNode;
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
  var valid_593976 = path.getOrDefault("offerId")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "offerId", valid_593976
  var valid_593977 = path.getOrDefault("planId")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "planId", valid_593977
  var valid_593978 = path.getOrDefault("publisherId")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "publisherId", valid_593978
  var valid_593979 = path.getOrDefault("subscriptionId")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "subscriptionId", valid_593979
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593980 = query.getOrDefault("api-version")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "api-version", valid_593980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593981: Call_MarketplaceAgreementsSign_593973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sign marketplace terms.
  ## 
  let valid = call_593981.validator(path, query, header, formData, body)
  let scheme = call_593981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593981.url(scheme.get, call_593981.host, call_593981.base,
                         call_593981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593981, url, valid)

proc call*(call_593982: Call_MarketplaceAgreementsSign_593973; apiVersion: string;
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
  var path_593983 = newJObject()
  var query_593984 = newJObject()
  add(query_593984, "api-version", newJString(apiVersion))
  add(path_593983, "offerId", newJString(offerId))
  add(path_593983, "planId", newJString(planId))
  add(path_593983, "publisherId", newJString(publisherId))
  add(path_593983, "subscriptionId", newJString(subscriptionId))
  result = call_593982.call(path_593983, query_593984, nil, nil, nil)

var marketplaceAgreementsSign* = Call_MarketplaceAgreementsSign_593973(
    name: "marketplaceAgreementsSign", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MarketplaceOrdering/agreements/{publisherId}/offers/{offerId}/plans/{planId}/sign",
    validator: validate_MarketplaceAgreementsSign_593974, base: "",
    url: url_MarketplaceAgreementsSign_593975, schemes: {Scheme.Https})
type
  Call_MarketplaceAgreementsCreate_594011 = ref object of OpenApiRestCall_593408
proc url_MarketplaceAgreementsCreate_594013(protocol: Scheme; host: string;
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

proc validate_MarketplaceAgreementsCreate_594012(path: JsonNode; query: JsonNode;
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
  var valid_594031 = path.getOrDefault("offerId")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "offerId", valid_594031
  var valid_594032 = path.getOrDefault("planId")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "planId", valid_594032
  var valid_594033 = path.getOrDefault("publisherId")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "publisherId", valid_594033
  var valid_594034 = path.getOrDefault("subscriptionId")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "subscriptionId", valid_594034
  var valid_594035 = path.getOrDefault("offerType")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = newJString("virtualmachine"))
  if valid_594035 != nil:
    section.add "offerType", valid_594035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594036 = query.getOrDefault("api-version")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "api-version", valid_594036
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

proc call*(call_594038: Call_MarketplaceAgreementsCreate_594011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Save marketplace terms.
  ## 
  let valid = call_594038.validator(path, query, header, formData, body)
  let scheme = call_594038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594038.url(scheme.get, call_594038.host, call_594038.base,
                         call_594038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594038, url, valid)

proc call*(call_594039: Call_MarketplaceAgreementsCreate_594011;
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
  var path_594040 = newJObject()
  var query_594041 = newJObject()
  var body_594042 = newJObject()
  add(query_594041, "api-version", newJString(apiVersion))
  add(path_594040, "offerId", newJString(offerId))
  add(path_594040, "planId", newJString(planId))
  add(path_594040, "publisherId", newJString(publisherId))
  add(path_594040, "subscriptionId", newJString(subscriptionId))
  add(path_594040, "offerType", newJString(offerType))
  if parameters != nil:
    body_594042 = parameters
  result = call_594039.call(path_594040, query_594041, nil, nil, body_594042)

var marketplaceAgreementsCreate* = Call_MarketplaceAgreementsCreate_594011(
    name: "marketplaceAgreementsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MarketplaceOrdering/offerTypes/{offerType}/publishers/{publisherId}/offers/{offerId}/plans/{planId}/agreements/current",
    validator: validate_MarketplaceAgreementsCreate_594012, base: "",
    url: url_MarketplaceAgreementsCreate_594013, schemes: {Scheme.Https})
type
  Call_MarketplaceAgreementsGet_593985 = ref object of OpenApiRestCall_593408
proc url_MarketplaceAgreementsGet_593987(protocol: Scheme; host: string;
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

proc validate_MarketplaceAgreementsGet_593986(path: JsonNode; query: JsonNode;
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
  var valid_593988 = path.getOrDefault("offerId")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "offerId", valid_593988
  var valid_593989 = path.getOrDefault("planId")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "planId", valid_593989
  var valid_593990 = path.getOrDefault("publisherId")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "publisherId", valid_593990
  var valid_593991 = path.getOrDefault("subscriptionId")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "subscriptionId", valid_593991
  var valid_594005 = path.getOrDefault("offerType")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = newJString("virtualmachine"))
  if valid_594005 != nil:
    section.add "offerType", valid_594005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594006 = query.getOrDefault("api-version")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "api-version", valid_594006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594007: Call_MarketplaceAgreementsGet_593985; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get marketplace terms.
  ## 
  let valid = call_594007.validator(path, query, header, formData, body)
  let scheme = call_594007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594007.url(scheme.get, call_594007.host, call_594007.base,
                         call_594007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594007, url, valid)

proc call*(call_594008: Call_MarketplaceAgreementsGet_593985; apiVersion: string;
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
  var path_594009 = newJObject()
  var query_594010 = newJObject()
  add(query_594010, "api-version", newJString(apiVersion))
  add(path_594009, "offerId", newJString(offerId))
  add(path_594009, "planId", newJString(planId))
  add(path_594009, "publisherId", newJString(publisherId))
  add(path_594009, "subscriptionId", newJString(subscriptionId))
  add(path_594009, "offerType", newJString(offerType))
  result = call_594008.call(path_594009, query_594010, nil, nil, nil)

var marketplaceAgreementsGet* = Call_MarketplaceAgreementsGet_593985(
    name: "marketplaceAgreementsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MarketplaceOrdering/offerTypes/{offerType}/publishers/{publisherId}/offers/{offerId}/plans/{planId}/agreements/current",
    validator: validate_MarketplaceAgreementsGet_593986, base: "",
    url: url_MarketplaceAgreementsGet_593987, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
