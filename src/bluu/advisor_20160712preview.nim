
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AdvisorManagementClient
## version: 2016-07-12-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## REST APIs for Azure Advisor
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
  macServiceName = "advisor"
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
  ## Lists all the available Advisor REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
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
  ## Lists all the available Advisor REST API operations.
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
  ## Lists all the available Advisor REST API operations.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var query_593902 = newJObject()
  add(query_593902, "api-version", newJString(apiVersion))
  result = call_593901.call(nil, query_593902, nil, nil, nil)

var operationsList* = Call_OperationsList_593646(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Advisor/operations",
    validator: validate_OperationsList_593647, base: "", url: url_OperationsList_593648,
    schemes: {Scheme.Https})
type
  Call_RecommendationsGenerate_593942 = ref object of OpenApiRestCall_593424
proc url_RecommendationsGenerate_593944(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Advisor/generateRecommendations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsGenerate_593943(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Initiates the recommendation generation or computation process for a subscription. This operation is asynchronous. The generated recommendations are stored in a cache in the Advisor service.
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
  ##              : The version of the API to be used with the client request.
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
  if body != nil:
    result.add "body", body

proc call*(call_593961: Call_RecommendationsGenerate_593942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates the recommendation generation or computation process for a subscription. This operation is asynchronous. The generated recommendations are stored in a cache in the Advisor service.
  ## 
  let valid = call_593961.validator(path, query, header, formData, body)
  let scheme = call_593961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593961.url(scheme.get, call_593961.host, call_593961.base,
                         call_593961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593961, url, valid)

proc call*(call_593962: Call_RecommendationsGenerate_593942; apiVersion: string;
          subscriptionId: string): Recallable =
  ## recommendationsGenerate
  ## Initiates the recommendation generation or computation process for a subscription. This operation is asynchronous. The generated recommendations are stored in a cache in the Advisor service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_593963 = newJObject()
  var query_593964 = newJObject()
  add(query_593964, "api-version", newJString(apiVersion))
  add(path_593963, "subscriptionId", newJString(subscriptionId))
  result = call_593962.call(path_593963, query_593964, nil, nil, nil)

var recommendationsGenerate* = Call_RecommendationsGenerate_593942(
    name: "recommendationsGenerate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Advisor/generateRecommendations",
    validator: validate_RecommendationsGenerate_593943, base: "",
    url: url_RecommendationsGenerate_593944, schemes: {Scheme.Https})
type
  Call_RecommendationsGetGenerateRecommendationsStatus_593965 = ref object of OpenApiRestCall_593424
proc url_RecommendationsGetGenerateRecommendationsStatus_593967(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Advisor/generateRecommendations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsGetGenerateRecommendationsStatus_593966(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves the status of the recommendation computation or generation process. Invoke this API after calling the generation recommendation. The URI of this API is returned in the Location field of the response header.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   operationId: JString (required)
  ##              : The operation ID, which can be found from the Location field in the generate recommendation response header.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593968 = path.getOrDefault("subscriptionId")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "subscriptionId", valid_593968
  var valid_593969 = path.getOrDefault("operationId")
  valid_593969 = validateParameter(valid_593969, JString, required = true,
                                 default = nil)
  if valid_593969 != nil:
    section.add "operationId", valid_593969
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593970 = query.getOrDefault("api-version")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "api-version", valid_593970
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593971: Call_RecommendationsGetGenerateRecommendationsStatus_593965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the status of the recommendation computation or generation process. Invoke this API after calling the generation recommendation. The URI of this API is returned in the Location field of the response header.
  ## 
  let valid = call_593971.validator(path, query, header, formData, body)
  let scheme = call_593971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593971.url(scheme.get, call_593971.host, call_593971.base,
                         call_593971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593971, url, valid)

proc call*(call_593972: Call_RecommendationsGetGenerateRecommendationsStatus_593965;
          apiVersion: string; subscriptionId: string; operationId: string): Recallable =
  ## recommendationsGetGenerateRecommendationsStatus
  ## Retrieves the status of the recommendation computation or generation process. Invoke this API after calling the generation recommendation. The URI of this API is returned in the Location field of the response header.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   operationId: string (required)
  ##              : The operation ID, which can be found from the Location field in the generate recommendation response header.
  var path_593973 = newJObject()
  var query_593974 = newJObject()
  add(query_593974, "api-version", newJString(apiVersion))
  add(path_593973, "subscriptionId", newJString(subscriptionId))
  add(path_593973, "operationId", newJString(operationId))
  result = call_593972.call(path_593973, query_593974, nil, nil, nil)

var recommendationsGetGenerateRecommendationsStatus* = Call_RecommendationsGetGenerateRecommendationsStatus_593965(
    name: "recommendationsGetGenerateRecommendationsStatus",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Advisor/generateRecommendations/{operationId}",
    validator: validate_RecommendationsGetGenerateRecommendationsStatus_593966,
    base: "", url: url_RecommendationsGetGenerateRecommendationsStatus_593967,
    schemes: {Scheme.Https})
type
  Call_RecommendationsList_593975 = ref object of OpenApiRestCall_593424
proc url_RecommendationsList_593977(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Advisor/recommendations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsList_593976(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Obtains cached recommendations for a subscription. The recommendations are generated or computed by invoking generateRecommendations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593979 = path.getOrDefault("subscriptionId")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "subscriptionId", valid_593979
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of recommendations per page if a paged version of this API is being used.
  ##   $skipToken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  ##   $filter: JString
  ##          : The filter to apply to the recommendations.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593980 = query.getOrDefault("api-version")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "api-version", valid_593980
  var valid_593981 = query.getOrDefault("$top")
  valid_593981 = validateParameter(valid_593981, JInt, required = false, default = nil)
  if valid_593981 != nil:
    section.add "$top", valid_593981
  var valid_593982 = query.getOrDefault("$skipToken")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "$skipToken", valid_593982
  var valid_593983 = query.getOrDefault("$filter")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "$filter", valid_593983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593984: Call_RecommendationsList_593975; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Obtains cached recommendations for a subscription. The recommendations are generated or computed by invoking generateRecommendations.
  ## 
  let valid = call_593984.validator(path, query, header, formData, body)
  let scheme = call_593984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593984.url(scheme.get, call_593984.host, call_593984.base,
                         call_593984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593984, url, valid)

proc call*(call_593985: Call_RecommendationsList_593975; apiVersion: string;
          subscriptionId: string; Top: int = 0; SkipToken: string = "";
          Filter: string = ""): Recallable =
  ## recommendationsList
  ## Obtains cached recommendations for a subscription. The recommendations are generated or computed by invoking generateRecommendations.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   Top: int
  ##      : The number of recommendations per page if a paged version of this API is being used.
  ##   SkipToken: string
  ##            : The page-continuation token to use with a paged version of this API.
  ##   Filter: string
  ##         : The filter to apply to the recommendations.
  var path_593986 = newJObject()
  var query_593987 = newJObject()
  add(query_593987, "api-version", newJString(apiVersion))
  add(path_593986, "subscriptionId", newJString(subscriptionId))
  add(query_593987, "$top", newJInt(Top))
  add(query_593987, "$skipToken", newJString(SkipToken))
  add(query_593987, "$filter", newJString(Filter))
  result = call_593985.call(path_593986, query_593987, nil, nil, nil)

var recommendationsList* = Call_RecommendationsList_593975(
    name: "recommendationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Advisor/recommendations",
    validator: validate_RecommendationsList_593976, base: "",
    url: url_RecommendationsList_593977, schemes: {Scheme.Https})
type
  Call_SuppressionsList_593988 = ref object of OpenApiRestCall_593424
proc url_SuppressionsList_593990(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Advisor/suppressions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SuppressionsList_593989(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves the list of snoozed or dismissed suppressions for a subscription. The snoozed or dismissed attribute of a recommendation is referred to as a suppression.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593991 = path.getOrDefault("subscriptionId")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "subscriptionId", valid_593991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593992 = query.getOrDefault("api-version")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "api-version", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_SuppressionsList_593988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of snoozed or dismissed suppressions for a subscription. The snoozed or dismissed attribute of a recommendation is referred to as a suppression.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_SuppressionsList_593988; apiVersion: string;
          subscriptionId: string): Recallable =
  ## suppressionsList
  ## Retrieves the list of snoozed or dismissed suppressions for a subscription. The snoozed or dismissed attribute of a recommendation is referred to as a suppression.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  add(query_593996, "api-version", newJString(apiVersion))
  add(path_593995, "subscriptionId", newJString(subscriptionId))
  result = call_593994.call(path_593995, query_593996, nil, nil, nil)

var suppressionsList* = Call_SuppressionsList_593988(name: "suppressionsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Advisor/suppressions",
    validator: validate_SuppressionsList_593989, base: "",
    url: url_SuppressionsList_593990, schemes: {Scheme.Https})
type
  Call_RecommendationsGet_593997 = ref object of OpenApiRestCall_593424
proc url_RecommendationsGet_593999(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "recommendationId" in path,
        "`recommendationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Advisor/recommendations/"),
               (kind: VariableSegment, value: "recommendationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsGet_593998(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Obtains details of a cached recommendation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   recommendationId: JString (required)
  ##                   : The recommendation ID.
  ##   resourceUri: JString (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `recommendationId` field"
  var valid_594000 = path.getOrDefault("recommendationId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "recommendationId", valid_594000
  var valid_594001 = path.getOrDefault("resourceUri")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "resourceUri", valid_594001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594002 = query.getOrDefault("api-version")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "api-version", valid_594002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594003: Call_RecommendationsGet_593997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Obtains details of a cached recommendation.
  ## 
  let valid = call_594003.validator(path, query, header, formData, body)
  let scheme = call_594003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594003.url(scheme.get, call_594003.host, call_594003.base,
                         call_594003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594003, url, valid)

proc call*(call_594004: Call_RecommendationsGet_593997; apiVersion: string;
          recommendationId: string; resourceUri: string): Recallable =
  ## recommendationsGet
  ## Obtains details of a cached recommendation.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   recommendationId: string (required)
  ##                   : The recommendation ID.
  ##   resourceUri: string (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  var path_594005 = newJObject()
  var query_594006 = newJObject()
  add(query_594006, "api-version", newJString(apiVersion))
  add(path_594005, "recommendationId", newJString(recommendationId))
  add(path_594005, "resourceUri", newJString(resourceUri))
  result = call_594004.call(path_594005, query_594006, nil, nil, nil)

var recommendationsGet* = Call_RecommendationsGet_593997(
    name: "recommendationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.Advisor/recommendations/{recommendationId}",
    validator: validate_RecommendationsGet_593998, base: "",
    url: url_RecommendationsGet_593999, schemes: {Scheme.Https})
type
  Call_SuppressionsCreate_594018 = ref object of OpenApiRestCall_593424
proc url_SuppressionsCreate_594020(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "recommendationId" in path,
        "`recommendationId` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Advisor/recommendations/"),
               (kind: VariableSegment, value: "recommendationId"),
               (kind: ConstantSegment, value: "/suppressions/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SuppressionsCreate_594019(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Enables the snoozed or dismissed attribute of a recommendation. The snoozed or dismissed attribute is referred to as a suppression. Use this API to create or update the snoozed or dismissed status of a recommendation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the suppression.
  ##   recommendationId: JString (required)
  ##                   : The recommendation ID.
  ##   resourceUri: JString (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594021 = path.getOrDefault("name")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "name", valid_594021
  var valid_594022 = path.getOrDefault("recommendationId")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "recommendationId", valid_594022
  var valid_594023 = path.getOrDefault("resourceUri")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "resourceUri", valid_594023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594024 = query.getOrDefault("api-version")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "api-version", valid_594024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   suppressionContract: JObject (required)
  ##                      : The snoozed or dismissed attribute; for example, the snooze duration.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594026: Call_SuppressionsCreate_594018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables the snoozed or dismissed attribute of a recommendation. The snoozed or dismissed attribute is referred to as a suppression. Use this API to create or update the snoozed or dismissed status of a recommendation.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_SuppressionsCreate_594018; apiVersion: string;
          name: string; recommendationId: string; suppressionContract: JsonNode;
          resourceUri: string): Recallable =
  ## suppressionsCreate
  ## Enables the snoozed or dismissed attribute of a recommendation. The snoozed or dismissed attribute is referred to as a suppression. Use this API to create or update the snoozed or dismissed status of a recommendation.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   name: string (required)
  ##       : The name of the suppression.
  ##   recommendationId: string (required)
  ##                   : The recommendation ID.
  ##   suppressionContract: JObject (required)
  ##                      : The snoozed or dismissed attribute; for example, the snooze duration.
  ##   resourceUri: string (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  var body_594030 = newJObject()
  add(query_594029, "api-version", newJString(apiVersion))
  add(path_594028, "name", newJString(name))
  add(path_594028, "recommendationId", newJString(recommendationId))
  if suppressionContract != nil:
    body_594030 = suppressionContract
  add(path_594028, "resourceUri", newJString(resourceUri))
  result = call_594027.call(path_594028, query_594029, nil, nil, body_594030)

var suppressionsCreate* = Call_SuppressionsCreate_594018(
    name: "suppressionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.Advisor/recommendations/{recommendationId}/suppressions/{name}",
    validator: validate_SuppressionsCreate_594019, base: "",
    url: url_SuppressionsCreate_594020, schemes: {Scheme.Https})
type
  Call_SuppressionsGet_594007 = ref object of OpenApiRestCall_593424
proc url_SuppressionsGet_594009(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "recommendationId" in path,
        "`recommendationId` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Advisor/recommendations/"),
               (kind: VariableSegment, value: "recommendationId"),
               (kind: ConstantSegment, value: "/suppressions/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SuppressionsGet_594008(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Obtains the details of a suppression.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the suppression.
  ##   recommendationId: JString (required)
  ##                   : The recommendation ID.
  ##   resourceUri: JString (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594010 = path.getOrDefault("name")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "name", valid_594010
  var valid_594011 = path.getOrDefault("recommendationId")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "recommendationId", valid_594011
  var valid_594012 = path.getOrDefault("resourceUri")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "resourceUri", valid_594012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594013 = query.getOrDefault("api-version")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "api-version", valid_594013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594014: Call_SuppressionsGet_594007; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Obtains the details of a suppression.
  ## 
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_SuppressionsGet_594007; apiVersion: string;
          name: string; recommendationId: string; resourceUri: string): Recallable =
  ## suppressionsGet
  ## Obtains the details of a suppression.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   name: string (required)
  ##       : The name of the suppression.
  ##   recommendationId: string (required)
  ##                   : The recommendation ID.
  ##   resourceUri: string (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  var path_594016 = newJObject()
  var query_594017 = newJObject()
  add(query_594017, "api-version", newJString(apiVersion))
  add(path_594016, "name", newJString(name))
  add(path_594016, "recommendationId", newJString(recommendationId))
  add(path_594016, "resourceUri", newJString(resourceUri))
  result = call_594015.call(path_594016, query_594017, nil, nil, nil)

var suppressionsGet* = Call_SuppressionsGet_594007(name: "suppressionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.Advisor/recommendations/{recommendationId}/suppressions/{name}",
    validator: validate_SuppressionsGet_594008, base: "", url: url_SuppressionsGet_594009,
    schemes: {Scheme.Https})
type
  Call_SuppressionsDelete_594031 = ref object of OpenApiRestCall_593424
proc url_SuppressionsDelete_594033(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "recommendationId" in path,
        "`recommendationId` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Advisor/recommendations/"),
               (kind: VariableSegment, value: "recommendationId"),
               (kind: ConstantSegment, value: "/suppressions/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SuppressionsDelete_594032(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Enables the activation of a snoozed or dismissed recommendation. The snoozed or dismissed attribute of a recommendation is referred to as a suppression.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the suppression.
  ##   recommendationId: JString (required)
  ##                   : The recommendation ID.
  ##   resourceUri: JString (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594034 = path.getOrDefault("name")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "name", valid_594034
  var valid_594035 = path.getOrDefault("recommendationId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "recommendationId", valid_594035
  var valid_594036 = path.getOrDefault("resourceUri")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "resourceUri", valid_594036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594037 = query.getOrDefault("api-version")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "api-version", valid_594037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594038: Call_SuppressionsDelete_594031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables the activation of a snoozed or dismissed recommendation. The snoozed or dismissed attribute of a recommendation is referred to as a suppression.
  ## 
  let valid = call_594038.validator(path, query, header, formData, body)
  let scheme = call_594038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594038.url(scheme.get, call_594038.host, call_594038.base,
                         call_594038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594038, url, valid)

proc call*(call_594039: Call_SuppressionsDelete_594031; apiVersion: string;
          name: string; recommendationId: string; resourceUri: string): Recallable =
  ## suppressionsDelete
  ## Enables the activation of a snoozed or dismissed recommendation. The snoozed or dismissed attribute of a recommendation is referred to as a suppression.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   name: string (required)
  ##       : The name of the suppression.
  ##   recommendationId: string (required)
  ##                   : The recommendation ID.
  ##   resourceUri: string (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  var path_594040 = newJObject()
  var query_594041 = newJObject()
  add(query_594041, "api-version", newJString(apiVersion))
  add(path_594040, "name", newJString(name))
  add(path_594040, "recommendationId", newJString(recommendationId))
  add(path_594040, "resourceUri", newJString(resourceUri))
  result = call_594039.call(path_594040, query_594041, nil, nil, nil)

var suppressionsDelete* = Call_SuppressionsDelete_594031(
    name: "suppressionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.Advisor/recommendations/{recommendationId}/suppressions/{name}",
    validator: validate_SuppressionsDelete_594032, base: "",
    url: url_SuppressionsDelete_594033, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
