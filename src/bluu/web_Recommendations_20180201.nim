
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Recommendations API Client
## version: 2018-02-01
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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
  macServiceName = "web-Recommendations"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RecommendationsList_593646 = ref object of OpenApiRestCall_593424
proc url_RecommendationsList_593648(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/recommendations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsList_593647(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List all recommendations for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593822 = path.getOrDefault("subscriptionId")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "subscriptionId", valid_593822
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   featured: JBool
  ##           : Specify <code>true</code> to return only the most critical recommendations. The default is <code>false</code>, which returns all recommendations.
  ##   $filter: JString
  ##          : Filter is specified by using OData syntax. Example: $filter=channel eq 'Api' or channel eq 'Notification' and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[PT1H|PT1M|P1D]
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593823 = query.getOrDefault("api-version")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "api-version", valid_593823
  var valid_593824 = query.getOrDefault("featured")
  valid_593824 = validateParameter(valid_593824, JBool, required = false, default = nil)
  if valid_593824 != nil:
    section.add "featured", valid_593824
  var valid_593825 = query.getOrDefault("$filter")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "$filter", valid_593825
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593848: Call_RecommendationsList_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all recommendations for a subscription.
  ## 
  let valid = call_593848.validator(path, query, header, formData, body)
  let scheme = call_593848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593848.url(scheme.get, call_593848.host, call_593848.base,
                         call_593848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593848, url, valid)

proc call*(call_593919: Call_RecommendationsList_593646; apiVersion: string;
          subscriptionId: string; featured: bool = false; Filter: string = ""): Recallable =
  ## recommendationsList
  ## List all recommendations for a subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   featured: bool
  ##           : Specify <code>true</code> to return only the most critical recommendations. The default is <code>false</code>, which returns all recommendations.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   Filter: string
  ##         : Filter is specified by using OData syntax. Example: $filter=channel eq 'Api' or channel eq 'Notification' and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[PT1H|PT1M|P1D]
  var path_593920 = newJObject()
  var query_593922 = newJObject()
  add(query_593922, "api-version", newJString(apiVersion))
  add(query_593922, "featured", newJBool(featured))
  add(path_593920, "subscriptionId", newJString(subscriptionId))
  add(query_593922, "$filter", newJString(Filter))
  result = call_593919.call(path_593920, query_593922, nil, nil, nil)

var recommendationsList* = Call_RecommendationsList_593646(
    name: "recommendationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/recommendations",
    validator: validate_RecommendationsList_593647, base: "",
    url: url_RecommendationsList_593648, schemes: {Scheme.Https})
type
  Call_RecommendationsResetAllFilters_593961 = ref object of OpenApiRestCall_593424
proc url_RecommendationsResetAllFilters_593963(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Web/recommendations/reset")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsResetAllFilters_593962(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reset all recommendation opt-out settings for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593964 = path.getOrDefault("subscriptionId")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "subscriptionId", valid_593964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593965 = query.getOrDefault("api-version")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "api-version", valid_593965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593966: Call_RecommendationsResetAllFilters_593961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reset all recommendation opt-out settings for a subscription.
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_RecommendationsResetAllFilters_593961;
          apiVersion: string; subscriptionId: string): Recallable =
  ## recommendationsResetAllFilters
  ## Reset all recommendation opt-out settings for a subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_593968 = newJObject()
  var query_593969 = newJObject()
  add(query_593969, "api-version", newJString(apiVersion))
  add(path_593968, "subscriptionId", newJString(subscriptionId))
  result = call_593967.call(path_593968, query_593969, nil, nil, nil)

var recommendationsResetAllFilters* = Call_RecommendationsResetAllFilters_593961(
    name: "recommendationsResetAllFilters", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/recommendations/reset",
    validator: validate_RecommendationsResetAllFilters_593962, base: "",
    url: url_RecommendationsResetAllFilters_593963, schemes: {Scheme.Https})
type
  Call_RecommendationsDisableRecommendationForSubscription_593970 = ref object of OpenApiRestCall_593424
proc url_RecommendationsDisableRecommendationForSubscription_593972(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/recommendations/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/disable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsDisableRecommendationForSubscription_593971(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Disables the specified rule so it will not apply to a subscription in the future.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Rule name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593973 = path.getOrDefault("name")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "name", valid_593973
  var valid_593974 = path.getOrDefault("subscriptionId")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "subscriptionId", valid_593974
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593975 = query.getOrDefault("api-version")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "api-version", valid_593975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593976: Call_RecommendationsDisableRecommendationForSubscription_593970;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Disables the specified rule so it will not apply to a subscription in the future.
  ## 
  let valid = call_593976.validator(path, query, header, formData, body)
  let scheme = call_593976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593976.url(scheme.get, call_593976.host, call_593976.base,
                         call_593976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593976, url, valid)

proc call*(call_593977: Call_RecommendationsDisableRecommendationForSubscription_593970;
          apiVersion: string; name: string; subscriptionId: string): Recallable =
  ## recommendationsDisableRecommendationForSubscription
  ## Disables the specified rule so it will not apply to a subscription in the future.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Rule name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_593978 = newJObject()
  var query_593979 = newJObject()
  add(query_593979, "api-version", newJString(apiVersion))
  add(path_593978, "name", newJString(name))
  add(path_593978, "subscriptionId", newJString(subscriptionId))
  result = call_593977.call(path_593978, query_593979, nil, nil, nil)

var recommendationsDisableRecommendationForSubscription* = Call_RecommendationsDisableRecommendationForSubscription_593970(
    name: "recommendationsDisableRecommendationForSubscription",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/recommendations/{name}/disable",
    validator: validate_RecommendationsDisableRecommendationForSubscription_593971,
    base: "", url: url_RecommendationsDisableRecommendationForSubscription_593972,
    schemes: {Scheme.Https})
type
  Call_RecommendationsListHistoryForHostingEnvironment_593980 = ref object of OpenApiRestCall_593424
proc url_RecommendationsListHistoryForHostingEnvironment_593982(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hostingEnvironmentName" in path,
        "`hostingEnvironmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "hostingEnvironmentName"),
               (kind: ConstantSegment, value: "/recommendationHistory")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsListHistoryForHostingEnvironment_593981(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get past recommendations for an app, optionally specified by the time range.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   hostingEnvironmentName: JString (required)
  ##                         : Name of the hosting environment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593983 = path.getOrDefault("resourceGroupName")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "resourceGroupName", valid_593983
  var valid_593984 = path.getOrDefault("subscriptionId")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "subscriptionId", valid_593984
  var valid_593985 = path.getOrDefault("hostingEnvironmentName")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "hostingEnvironmentName", valid_593985
  result.add "path", section
  ## parameters in `query` object:
  ##   expiredOnly: JBool
  ##              : Specify <code>false</code> to return all recommendations. The default is <code>true</code>, which returns only expired recommendations.
  ##   api-version: JString (required)
  ##              : API Version
  ##   $filter: JString
  ##          : Filter is specified by using OData syntax. Example: $filter=channel eq 'Api' or channel eq 'Notification' and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[PT1H|PT1M|P1D]
  section = newJObject()
  var valid_593986 = query.getOrDefault("expiredOnly")
  valid_593986 = validateParameter(valid_593986, JBool, required = false, default = nil)
  if valid_593986 != nil:
    section.add "expiredOnly", valid_593986
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593987 = query.getOrDefault("api-version")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "api-version", valid_593987
  var valid_593988 = query.getOrDefault("$filter")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "$filter", valid_593988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593989: Call_RecommendationsListHistoryForHostingEnvironment_593980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get past recommendations for an app, optionally specified by the time range.
  ## 
  let valid = call_593989.validator(path, query, header, formData, body)
  let scheme = call_593989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593989.url(scheme.get, call_593989.host, call_593989.base,
                         call_593989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593989, url, valid)

proc call*(call_593990: Call_RecommendationsListHistoryForHostingEnvironment_593980;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          hostingEnvironmentName: string; expiredOnly: bool = false;
          Filter: string = ""): Recallable =
  ## recommendationsListHistoryForHostingEnvironment
  ## Get past recommendations for an app, optionally specified by the time range.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   expiredOnly: bool
  ##              : Specify <code>false</code> to return all recommendations. The default is <code>true</code>, which returns only expired recommendations.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   hostingEnvironmentName: string (required)
  ##                         : Name of the hosting environment.
  ##   Filter: string
  ##         : Filter is specified by using OData syntax. Example: $filter=channel eq 'Api' or channel eq 'Notification' and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[PT1H|PT1M|P1D]
  var path_593991 = newJObject()
  var query_593992 = newJObject()
  add(path_593991, "resourceGroupName", newJString(resourceGroupName))
  add(query_593992, "expiredOnly", newJBool(expiredOnly))
  add(query_593992, "api-version", newJString(apiVersion))
  add(path_593991, "subscriptionId", newJString(subscriptionId))
  add(path_593991, "hostingEnvironmentName", newJString(hostingEnvironmentName))
  add(query_593992, "$filter", newJString(Filter))
  result = call_593990.call(path_593991, query_593992, nil, nil, nil)

var recommendationsListHistoryForHostingEnvironment* = Call_RecommendationsListHistoryForHostingEnvironment_593980(
    name: "recommendationsListHistoryForHostingEnvironment",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{hostingEnvironmentName}/recommendationHistory",
    validator: validate_RecommendationsListHistoryForHostingEnvironment_593981,
    base: "", url: url_RecommendationsListHistoryForHostingEnvironment_593982,
    schemes: {Scheme.Https})
type
  Call_RecommendationsListRecommendedRulesForHostingEnvironment_593993 = ref object of OpenApiRestCall_593424
proc url_RecommendationsListRecommendedRulesForHostingEnvironment_593995(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hostingEnvironmentName" in path,
        "`hostingEnvironmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "hostingEnvironmentName"),
               (kind: ConstantSegment, value: "/recommendations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsListRecommendedRulesForHostingEnvironment_593994(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get all recommendations for an app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   hostingEnvironmentName: JString (required)
  ##                         : Name of the app.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593996 = path.getOrDefault("resourceGroupName")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "resourceGroupName", valid_593996
  var valid_593997 = path.getOrDefault("subscriptionId")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "subscriptionId", valid_593997
  var valid_593998 = path.getOrDefault("hostingEnvironmentName")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "hostingEnvironmentName", valid_593998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   featured: JBool
  ##           : Specify <code>true</code> to return only the most critical recommendations. The default is <code>false</code>, which returns all recommendations.
  ##   $filter: JString
  ##          : Return only channels specified in the filter. Filter is specified by using OData syntax. Example: $filter=channel eq 'Api' or channel eq 'Notification'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593999 = query.getOrDefault("api-version")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "api-version", valid_593999
  var valid_594000 = query.getOrDefault("featured")
  valid_594000 = validateParameter(valid_594000, JBool, required = false, default = nil)
  if valid_594000 != nil:
    section.add "featured", valid_594000
  var valid_594001 = query.getOrDefault("$filter")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "$filter", valid_594001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594002: Call_RecommendationsListRecommendedRulesForHostingEnvironment_593993;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all recommendations for an app.
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_RecommendationsListRecommendedRulesForHostingEnvironment_593993;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          hostingEnvironmentName: string; featured: bool = false; Filter: string = ""): Recallable =
  ## recommendationsListRecommendedRulesForHostingEnvironment
  ## Get all recommendations for an app.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   featured: bool
  ##           : Specify <code>true</code> to return only the most critical recommendations. The default is <code>false</code>, which returns all recommendations.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   hostingEnvironmentName: string (required)
  ##                         : Name of the app.
  ##   Filter: string
  ##         : Return only channels specified in the filter. Filter is specified by using OData syntax. Example: $filter=channel eq 'Api' or channel eq 'Notification'
  var path_594004 = newJObject()
  var query_594005 = newJObject()
  add(path_594004, "resourceGroupName", newJString(resourceGroupName))
  add(query_594005, "api-version", newJString(apiVersion))
  add(query_594005, "featured", newJBool(featured))
  add(path_594004, "subscriptionId", newJString(subscriptionId))
  add(path_594004, "hostingEnvironmentName", newJString(hostingEnvironmentName))
  add(query_594005, "$filter", newJString(Filter))
  result = call_594003.call(path_594004, query_594005, nil, nil, nil)

var recommendationsListRecommendedRulesForHostingEnvironment* = Call_RecommendationsListRecommendedRulesForHostingEnvironment_593993(
    name: "recommendationsListRecommendedRulesForHostingEnvironment",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{hostingEnvironmentName}/recommendations", validator: validate_RecommendationsListRecommendedRulesForHostingEnvironment_593994,
    base: "", url: url_RecommendationsListRecommendedRulesForHostingEnvironment_593995,
    schemes: {Scheme.Https})
type
  Call_RecommendationsDisableAllForHostingEnvironment_594006 = ref object of OpenApiRestCall_593424
proc url_RecommendationsDisableAllForHostingEnvironment_594008(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hostingEnvironmentName" in path,
        "`hostingEnvironmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "hostingEnvironmentName"),
               (kind: ConstantSegment, value: "/recommendations/disable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsDisableAllForHostingEnvironment_594007(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Disable all recommendations for an app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   hostingEnvironmentName: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594009 = path.getOrDefault("resourceGroupName")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "resourceGroupName", valid_594009
  var valid_594010 = path.getOrDefault("subscriptionId")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "subscriptionId", valid_594010
  var valid_594011 = path.getOrDefault("hostingEnvironmentName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "hostingEnvironmentName", valid_594011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   environmentName: JString (required)
  ##                  : Name of the app.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594012 = query.getOrDefault("api-version")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "api-version", valid_594012
  var valid_594013 = query.getOrDefault("environmentName")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "environmentName", valid_594013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594014: Call_RecommendationsDisableAllForHostingEnvironment_594006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Disable all recommendations for an app.
  ## 
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_RecommendationsDisableAllForHostingEnvironment_594006;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          environmentName: string; hostingEnvironmentName: string): Recallable =
  ## recommendationsDisableAllForHostingEnvironment
  ## Disable all recommendations for an app.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   environmentName: string (required)
  ##                  : Name of the app.
  ##   hostingEnvironmentName: string (required)
  var path_594016 = newJObject()
  var query_594017 = newJObject()
  add(path_594016, "resourceGroupName", newJString(resourceGroupName))
  add(query_594017, "api-version", newJString(apiVersion))
  add(path_594016, "subscriptionId", newJString(subscriptionId))
  add(query_594017, "environmentName", newJString(environmentName))
  add(path_594016, "hostingEnvironmentName", newJString(hostingEnvironmentName))
  result = call_594015.call(path_594016, query_594017, nil, nil, nil)

var recommendationsDisableAllForHostingEnvironment* = Call_RecommendationsDisableAllForHostingEnvironment_594006(
    name: "recommendationsDisableAllForHostingEnvironment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{hostingEnvironmentName}/recommendations/disable",
    validator: validate_RecommendationsDisableAllForHostingEnvironment_594007,
    base: "", url: url_RecommendationsDisableAllForHostingEnvironment_594008,
    schemes: {Scheme.Https})
type
  Call_RecommendationsResetAllFiltersForHostingEnvironment_594018 = ref object of OpenApiRestCall_593424
proc url_RecommendationsResetAllFiltersForHostingEnvironment_594020(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hostingEnvironmentName" in path,
        "`hostingEnvironmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "hostingEnvironmentName"),
               (kind: ConstantSegment, value: "/recommendations/reset")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsResetAllFiltersForHostingEnvironment_594019(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Reset all recommendation opt-out settings for an app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   hostingEnvironmentName: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594021 = path.getOrDefault("resourceGroupName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "resourceGroupName", valid_594021
  var valid_594022 = path.getOrDefault("subscriptionId")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "subscriptionId", valid_594022
  var valid_594023 = path.getOrDefault("hostingEnvironmentName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "hostingEnvironmentName", valid_594023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   environmentName: JString (required)
  ##                  : Name of the app.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594024 = query.getOrDefault("api-version")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "api-version", valid_594024
  var valid_594025 = query.getOrDefault("environmentName")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "environmentName", valid_594025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594026: Call_RecommendationsResetAllFiltersForHostingEnvironment_594018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reset all recommendation opt-out settings for an app.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_RecommendationsResetAllFiltersForHostingEnvironment_594018;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          environmentName: string; hostingEnvironmentName: string): Recallable =
  ## recommendationsResetAllFiltersForHostingEnvironment
  ## Reset all recommendation opt-out settings for an app.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   environmentName: string (required)
  ##                  : Name of the app.
  ##   hostingEnvironmentName: string (required)
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  add(path_594028, "resourceGroupName", newJString(resourceGroupName))
  add(query_594029, "api-version", newJString(apiVersion))
  add(path_594028, "subscriptionId", newJString(subscriptionId))
  add(query_594029, "environmentName", newJString(environmentName))
  add(path_594028, "hostingEnvironmentName", newJString(hostingEnvironmentName))
  result = call_594027.call(path_594028, query_594029, nil, nil, nil)

var recommendationsResetAllFiltersForHostingEnvironment* = Call_RecommendationsResetAllFiltersForHostingEnvironment_594018(
    name: "recommendationsResetAllFiltersForHostingEnvironment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{hostingEnvironmentName}/recommendations/reset",
    validator: validate_RecommendationsResetAllFiltersForHostingEnvironment_594019,
    base: "", url: url_RecommendationsResetAllFiltersForHostingEnvironment_594020,
    schemes: {Scheme.Https})
type
  Call_RecommendationsGetRuleDetailsByHostingEnvironment_594030 = ref object of OpenApiRestCall_593424
proc url_RecommendationsGetRuleDetailsByHostingEnvironment_594032(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hostingEnvironmentName" in path,
        "`hostingEnvironmentName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "hostingEnvironmentName"),
               (kind: ConstantSegment, value: "/recommendations/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsGetRuleDetailsByHostingEnvironment_594031(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get a recommendation rule for an app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the recommendation.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   hostingEnvironmentName: JString (required)
  ##                         : Name of the hosting environment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594033 = path.getOrDefault("resourceGroupName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "resourceGroupName", valid_594033
  var valid_594034 = path.getOrDefault("name")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "name", valid_594034
  var valid_594035 = path.getOrDefault("subscriptionId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "subscriptionId", valid_594035
  var valid_594036 = path.getOrDefault("hostingEnvironmentName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "hostingEnvironmentName", valid_594036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   updateSeen: JBool
  ##             : Specify <code>true</code> to update the last-seen timestamp of the recommendation object.
  ##   recommendationId: JString
  ##                   : The GUID of the recommendation object if you query an expired one. You don't need to specify it to query an active entry.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594037 = query.getOrDefault("api-version")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "api-version", valid_594037
  var valid_594038 = query.getOrDefault("updateSeen")
  valid_594038 = validateParameter(valid_594038, JBool, required = false, default = nil)
  if valid_594038 != nil:
    section.add "updateSeen", valid_594038
  var valid_594039 = query.getOrDefault("recommendationId")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "recommendationId", valid_594039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594040: Call_RecommendationsGetRuleDetailsByHostingEnvironment_594030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a recommendation rule for an app.
  ## 
  let valid = call_594040.validator(path, query, header, formData, body)
  let scheme = call_594040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594040.url(scheme.get, call_594040.host, call_594040.base,
                         call_594040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594040, url, valid)

proc call*(call_594041: Call_RecommendationsGetRuleDetailsByHostingEnvironment_594030;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; hostingEnvironmentName: string;
          updateSeen: bool = false; recommendationId: string = ""): Recallable =
  ## recommendationsGetRuleDetailsByHostingEnvironment
  ## Get a recommendation rule for an app.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the recommendation.
  ##   updateSeen: bool
  ##             : Specify <code>true</code> to update the last-seen timestamp of the recommendation object.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   recommendationId: string
  ##                   : The GUID of the recommendation object if you query an expired one. You don't need to specify it to query an active entry.
  ##   hostingEnvironmentName: string (required)
  ##                         : Name of the hosting environment.
  var path_594042 = newJObject()
  var query_594043 = newJObject()
  add(path_594042, "resourceGroupName", newJString(resourceGroupName))
  add(query_594043, "api-version", newJString(apiVersion))
  add(path_594042, "name", newJString(name))
  add(query_594043, "updateSeen", newJBool(updateSeen))
  add(path_594042, "subscriptionId", newJString(subscriptionId))
  add(query_594043, "recommendationId", newJString(recommendationId))
  add(path_594042, "hostingEnvironmentName", newJString(hostingEnvironmentName))
  result = call_594041.call(path_594042, query_594043, nil, nil, nil)

var recommendationsGetRuleDetailsByHostingEnvironment* = Call_RecommendationsGetRuleDetailsByHostingEnvironment_594030(
    name: "recommendationsGetRuleDetailsByHostingEnvironment",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{hostingEnvironmentName}/recommendations/{name}",
    validator: validate_RecommendationsGetRuleDetailsByHostingEnvironment_594031,
    base: "", url: url_RecommendationsGetRuleDetailsByHostingEnvironment_594032,
    schemes: {Scheme.Https})
type
  Call_RecommendationsDisableRecommendationForHostingEnvironment_594044 = ref object of OpenApiRestCall_593424
proc url_RecommendationsDisableRecommendationForHostingEnvironment_594046(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hostingEnvironmentName" in path,
        "`hostingEnvironmentName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "hostingEnvironmentName"),
               (kind: ConstantSegment, value: "/recommendations/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/disable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsDisableRecommendationForHostingEnvironment_594045(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Disables the specific rule for a web site permanently.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Rule name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   hostingEnvironmentName: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594047 = path.getOrDefault("resourceGroupName")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "resourceGroupName", valid_594047
  var valid_594048 = path.getOrDefault("name")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "name", valid_594048
  var valid_594049 = path.getOrDefault("subscriptionId")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "subscriptionId", valid_594049
  var valid_594050 = path.getOrDefault("hostingEnvironmentName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "hostingEnvironmentName", valid_594050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   environmentName: JString (required)
  ##                  : Site name
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594051 = query.getOrDefault("api-version")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "api-version", valid_594051
  var valid_594052 = query.getOrDefault("environmentName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "environmentName", valid_594052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594053: Call_RecommendationsDisableRecommendationForHostingEnvironment_594044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Disables the specific rule for a web site permanently.
  ## 
  let valid = call_594053.validator(path, query, header, formData, body)
  let scheme = call_594053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594053.url(scheme.get, call_594053.host, call_594053.base,
                         call_594053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594053, url, valid)

proc call*(call_594054: Call_RecommendationsDisableRecommendationForHostingEnvironment_594044;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; environmentName: string;
          hostingEnvironmentName: string): Recallable =
  ## recommendationsDisableRecommendationForHostingEnvironment
  ## Disables the specific rule for a web site permanently.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Rule name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   environmentName: string (required)
  ##                  : Site name
  ##   hostingEnvironmentName: string (required)
  var path_594055 = newJObject()
  var query_594056 = newJObject()
  add(path_594055, "resourceGroupName", newJString(resourceGroupName))
  add(query_594056, "api-version", newJString(apiVersion))
  add(path_594055, "name", newJString(name))
  add(path_594055, "subscriptionId", newJString(subscriptionId))
  add(query_594056, "environmentName", newJString(environmentName))
  add(path_594055, "hostingEnvironmentName", newJString(hostingEnvironmentName))
  result = call_594054.call(path_594055, query_594056, nil, nil, nil)

var recommendationsDisableRecommendationForHostingEnvironment* = Call_RecommendationsDisableRecommendationForHostingEnvironment_594044(
    name: "recommendationsDisableRecommendationForHostingEnvironment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{hostingEnvironmentName}/recommendations/{name}/disable", validator: validate_RecommendationsDisableRecommendationForHostingEnvironment_594045,
    base: "", url: url_RecommendationsDisableRecommendationForHostingEnvironment_594046,
    schemes: {Scheme.Https})
type
  Call_RecommendationsListHistoryForWebApp_594057 = ref object of OpenApiRestCall_593424
proc url_RecommendationsListHistoryForWebApp_594059(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/recommendationHistory")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsListHistoryForWebApp_594058(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get past recommendations for an app, optionally specified by the time range.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Name of the app.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594060 = path.getOrDefault("resourceGroupName")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "resourceGroupName", valid_594060
  var valid_594061 = path.getOrDefault("siteName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "siteName", valid_594061
  var valid_594062 = path.getOrDefault("subscriptionId")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "subscriptionId", valid_594062
  result.add "path", section
  ## parameters in `query` object:
  ##   expiredOnly: JBool
  ##              : Specify <code>false</code> to return all recommendations. The default is <code>true</code>, which returns only expired recommendations.
  ##   api-version: JString (required)
  ##              : API Version
  ##   $filter: JString
  ##          : Filter is specified by using OData syntax. Example: $filter=channel eq 'Api' or channel eq 'Notification' and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[PT1H|PT1M|P1D]
  section = newJObject()
  var valid_594063 = query.getOrDefault("expiredOnly")
  valid_594063 = validateParameter(valid_594063, JBool, required = false, default = nil)
  if valid_594063 != nil:
    section.add "expiredOnly", valid_594063
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594064 = query.getOrDefault("api-version")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "api-version", valid_594064
  var valid_594065 = query.getOrDefault("$filter")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "$filter", valid_594065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594066: Call_RecommendationsListHistoryForWebApp_594057;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get past recommendations for an app, optionally specified by the time range.
  ## 
  let valid = call_594066.validator(path, query, header, formData, body)
  let scheme = call_594066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594066.url(scheme.get, call_594066.host, call_594066.base,
                         call_594066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594066, url, valid)

proc call*(call_594067: Call_RecommendationsListHistoryForWebApp_594057;
          resourceGroupName: string; apiVersion: string; siteName: string;
          subscriptionId: string; expiredOnly: bool = false; Filter: string = ""): Recallable =
  ## recommendationsListHistoryForWebApp
  ## Get past recommendations for an app, optionally specified by the time range.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   expiredOnly: bool
  ##              : Specify <code>false</code> to return all recommendations. The default is <code>true</code>, which returns only expired recommendations.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Name of the app.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   Filter: string
  ##         : Filter is specified by using OData syntax. Example: $filter=channel eq 'Api' or channel eq 'Notification' and startTime eq 2014-01-01T00:00:00Z and endTime eq 2014-12-31T23:59:59Z and timeGrain eq duration'[PT1H|PT1M|P1D]
  var path_594068 = newJObject()
  var query_594069 = newJObject()
  add(path_594068, "resourceGroupName", newJString(resourceGroupName))
  add(query_594069, "expiredOnly", newJBool(expiredOnly))
  add(query_594069, "api-version", newJString(apiVersion))
  add(path_594068, "siteName", newJString(siteName))
  add(path_594068, "subscriptionId", newJString(subscriptionId))
  add(query_594069, "$filter", newJString(Filter))
  result = call_594067.call(path_594068, query_594069, nil, nil, nil)

var recommendationsListHistoryForWebApp* = Call_RecommendationsListHistoryForWebApp_594057(
    name: "recommendationsListHistoryForWebApp", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/recommendationHistory",
    validator: validate_RecommendationsListHistoryForWebApp_594058, base: "",
    url: url_RecommendationsListHistoryForWebApp_594059, schemes: {Scheme.Https})
type
  Call_RecommendationsListRecommendedRulesForWebApp_594070 = ref object of OpenApiRestCall_593424
proc url_RecommendationsListRecommendedRulesForWebApp_594072(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/recommendations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsListRecommendedRulesForWebApp_594071(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all recommendations for an app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Name of the app.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594073 = path.getOrDefault("resourceGroupName")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "resourceGroupName", valid_594073
  var valid_594074 = path.getOrDefault("siteName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "siteName", valid_594074
  var valid_594075 = path.getOrDefault("subscriptionId")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "subscriptionId", valid_594075
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   featured: JBool
  ##           : Specify <code>true</code> to return only the most critical recommendations. The default is <code>false</code>, which returns all recommendations.
  ##   $filter: JString
  ##          : Return only channels specified in the filter. Filter is specified by using OData syntax. Example: $filter=channel eq 'Api' or channel eq 'Notification'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594076 = query.getOrDefault("api-version")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "api-version", valid_594076
  var valid_594077 = query.getOrDefault("featured")
  valid_594077 = validateParameter(valid_594077, JBool, required = false, default = nil)
  if valid_594077 != nil:
    section.add "featured", valid_594077
  var valid_594078 = query.getOrDefault("$filter")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "$filter", valid_594078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594079: Call_RecommendationsListRecommendedRulesForWebApp_594070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all recommendations for an app.
  ## 
  let valid = call_594079.validator(path, query, header, formData, body)
  let scheme = call_594079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594079.url(scheme.get, call_594079.host, call_594079.base,
                         call_594079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594079, url, valid)

proc call*(call_594080: Call_RecommendationsListRecommendedRulesForWebApp_594070;
          resourceGroupName: string; apiVersion: string; siteName: string;
          subscriptionId: string; featured: bool = false; Filter: string = ""): Recallable =
  ## recommendationsListRecommendedRulesForWebApp
  ## Get all recommendations for an app.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   featured: bool
  ##           : Specify <code>true</code> to return only the most critical recommendations. The default is <code>false</code>, which returns all recommendations.
  ##   siteName: string (required)
  ##           : Name of the app.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   Filter: string
  ##         : Return only channels specified in the filter. Filter is specified by using OData syntax. Example: $filter=channel eq 'Api' or channel eq 'Notification'
  var path_594081 = newJObject()
  var query_594082 = newJObject()
  add(path_594081, "resourceGroupName", newJString(resourceGroupName))
  add(query_594082, "api-version", newJString(apiVersion))
  add(query_594082, "featured", newJBool(featured))
  add(path_594081, "siteName", newJString(siteName))
  add(path_594081, "subscriptionId", newJString(subscriptionId))
  add(query_594082, "$filter", newJString(Filter))
  result = call_594080.call(path_594081, query_594082, nil, nil, nil)

var recommendationsListRecommendedRulesForWebApp* = Call_RecommendationsListRecommendedRulesForWebApp_594070(
    name: "recommendationsListRecommendedRulesForWebApp",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/recommendations",
    validator: validate_RecommendationsListRecommendedRulesForWebApp_594071,
    base: "", url: url_RecommendationsListRecommendedRulesForWebApp_594072,
    schemes: {Scheme.Https})
type
  Call_RecommendationsDisableAllForWebApp_594083 = ref object of OpenApiRestCall_593424
proc url_RecommendationsDisableAllForWebApp_594085(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/recommendations/disable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsDisableAllForWebApp_594084(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Disable all recommendations for an app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Name of the app.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594086 = path.getOrDefault("resourceGroupName")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "resourceGroupName", valid_594086
  var valid_594087 = path.getOrDefault("siteName")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "siteName", valid_594087
  var valid_594088 = path.getOrDefault("subscriptionId")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "subscriptionId", valid_594088
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594089 = query.getOrDefault("api-version")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "api-version", valid_594089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594090: Call_RecommendationsDisableAllForWebApp_594083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Disable all recommendations for an app.
  ## 
  let valid = call_594090.validator(path, query, header, formData, body)
  let scheme = call_594090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594090.url(scheme.get, call_594090.host, call_594090.base,
                         call_594090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594090, url, valid)

proc call*(call_594091: Call_RecommendationsDisableAllForWebApp_594083;
          resourceGroupName: string; apiVersion: string; siteName: string;
          subscriptionId: string): Recallable =
  ## recommendationsDisableAllForWebApp
  ## Disable all recommendations for an app.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Name of the app.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594092 = newJObject()
  var query_594093 = newJObject()
  add(path_594092, "resourceGroupName", newJString(resourceGroupName))
  add(query_594093, "api-version", newJString(apiVersion))
  add(path_594092, "siteName", newJString(siteName))
  add(path_594092, "subscriptionId", newJString(subscriptionId))
  result = call_594091.call(path_594092, query_594093, nil, nil, nil)

var recommendationsDisableAllForWebApp* = Call_RecommendationsDisableAllForWebApp_594083(
    name: "recommendationsDisableAllForWebApp", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/recommendations/disable",
    validator: validate_RecommendationsDisableAllForWebApp_594084, base: "",
    url: url_RecommendationsDisableAllForWebApp_594085, schemes: {Scheme.Https})
type
  Call_RecommendationsResetAllFiltersForWebApp_594094 = ref object of OpenApiRestCall_593424
proc url_RecommendationsResetAllFiltersForWebApp_594096(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/recommendations/reset")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsResetAllFiltersForWebApp_594095(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reset all recommendation opt-out settings for an app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Name of the app.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594097 = path.getOrDefault("resourceGroupName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "resourceGroupName", valid_594097
  var valid_594098 = path.getOrDefault("siteName")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "siteName", valid_594098
  var valid_594099 = path.getOrDefault("subscriptionId")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "subscriptionId", valid_594099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594100 = query.getOrDefault("api-version")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "api-version", valid_594100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594101: Call_RecommendationsResetAllFiltersForWebApp_594094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reset all recommendation opt-out settings for an app.
  ## 
  let valid = call_594101.validator(path, query, header, formData, body)
  let scheme = call_594101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594101.url(scheme.get, call_594101.host, call_594101.base,
                         call_594101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594101, url, valid)

proc call*(call_594102: Call_RecommendationsResetAllFiltersForWebApp_594094;
          resourceGroupName: string; apiVersion: string; siteName: string;
          subscriptionId: string): Recallable =
  ## recommendationsResetAllFiltersForWebApp
  ## Reset all recommendation opt-out settings for an app.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Name of the app.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594103 = newJObject()
  var query_594104 = newJObject()
  add(path_594103, "resourceGroupName", newJString(resourceGroupName))
  add(query_594104, "api-version", newJString(apiVersion))
  add(path_594103, "siteName", newJString(siteName))
  add(path_594103, "subscriptionId", newJString(subscriptionId))
  result = call_594102.call(path_594103, query_594104, nil, nil, nil)

var recommendationsResetAllFiltersForWebApp* = Call_RecommendationsResetAllFiltersForWebApp_594094(
    name: "recommendationsResetAllFiltersForWebApp", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/recommendations/reset",
    validator: validate_RecommendationsResetAllFiltersForWebApp_594095, base: "",
    url: url_RecommendationsResetAllFiltersForWebApp_594096,
    schemes: {Scheme.Https})
type
  Call_RecommendationsGetRuleDetailsByWebApp_594105 = ref object of OpenApiRestCall_593424
proc url_RecommendationsGetRuleDetailsByWebApp_594107(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/recommendations/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsGetRuleDetailsByWebApp_594106(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a recommendation rule for an app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the recommendation.
  ##   siteName: JString (required)
  ##           : Name of the app.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594108 = path.getOrDefault("resourceGroupName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "resourceGroupName", valid_594108
  var valid_594109 = path.getOrDefault("name")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "name", valid_594109
  var valid_594110 = path.getOrDefault("siteName")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "siteName", valid_594110
  var valid_594111 = path.getOrDefault("subscriptionId")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "subscriptionId", valid_594111
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   updateSeen: JBool
  ##             : Specify <code>true</code> to update the last-seen timestamp of the recommendation object.
  ##   recommendationId: JString
  ##                   : The GUID of the recommendation object if you query an expired one. You don't need to specify it to query an active entry.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594112 = query.getOrDefault("api-version")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "api-version", valid_594112
  var valid_594113 = query.getOrDefault("updateSeen")
  valid_594113 = validateParameter(valid_594113, JBool, required = false, default = nil)
  if valid_594113 != nil:
    section.add "updateSeen", valid_594113
  var valid_594114 = query.getOrDefault("recommendationId")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "recommendationId", valid_594114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594115: Call_RecommendationsGetRuleDetailsByWebApp_594105;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a recommendation rule for an app.
  ## 
  let valid = call_594115.validator(path, query, header, formData, body)
  let scheme = call_594115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594115.url(scheme.get, call_594115.host, call_594115.base,
                         call_594115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594115, url, valid)

proc call*(call_594116: Call_RecommendationsGetRuleDetailsByWebApp_594105;
          resourceGroupName: string; apiVersion: string; name: string;
          siteName: string; subscriptionId: string; updateSeen: bool = false;
          recommendationId: string = ""): Recallable =
  ## recommendationsGetRuleDetailsByWebApp
  ## Get a recommendation rule for an app.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the recommendation.
  ##   updateSeen: bool
  ##             : Specify <code>true</code> to update the last-seen timestamp of the recommendation object.
  ##   siteName: string (required)
  ##           : Name of the app.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   recommendationId: string
  ##                   : The GUID of the recommendation object if you query an expired one. You don't need to specify it to query an active entry.
  var path_594117 = newJObject()
  var query_594118 = newJObject()
  add(path_594117, "resourceGroupName", newJString(resourceGroupName))
  add(query_594118, "api-version", newJString(apiVersion))
  add(path_594117, "name", newJString(name))
  add(query_594118, "updateSeen", newJBool(updateSeen))
  add(path_594117, "siteName", newJString(siteName))
  add(path_594117, "subscriptionId", newJString(subscriptionId))
  add(query_594118, "recommendationId", newJString(recommendationId))
  result = call_594116.call(path_594117, query_594118, nil, nil, nil)

var recommendationsGetRuleDetailsByWebApp* = Call_RecommendationsGetRuleDetailsByWebApp_594105(
    name: "recommendationsGetRuleDetailsByWebApp", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/recommendations/{name}",
    validator: validate_RecommendationsGetRuleDetailsByWebApp_594106, base: "",
    url: url_RecommendationsGetRuleDetailsByWebApp_594107, schemes: {Scheme.Https})
type
  Call_RecommendationsDisableRecommendationForSite_594119 = ref object of OpenApiRestCall_593424
proc url_RecommendationsDisableRecommendationForSite_594121(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/recommendations/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/disable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsDisableRecommendationForSite_594120(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Disables the specific rule for a web site permanently.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Rule name
  ##   siteName: JString (required)
  ##           : Site name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594122 = path.getOrDefault("resourceGroupName")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "resourceGroupName", valid_594122
  var valid_594123 = path.getOrDefault("name")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "name", valid_594123
  var valid_594124 = path.getOrDefault("siteName")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "siteName", valid_594124
  var valid_594125 = path.getOrDefault("subscriptionId")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "subscriptionId", valid_594125
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594126 = query.getOrDefault("api-version")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "api-version", valid_594126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594127: Call_RecommendationsDisableRecommendationForSite_594119;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Disables the specific rule for a web site permanently.
  ## 
  let valid = call_594127.validator(path, query, header, formData, body)
  let scheme = call_594127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594127.url(scheme.get, call_594127.host, call_594127.base,
                         call_594127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594127, url, valid)

proc call*(call_594128: Call_RecommendationsDisableRecommendationForSite_594119;
          resourceGroupName: string; apiVersion: string; name: string;
          siteName: string; subscriptionId: string): Recallable =
  ## recommendationsDisableRecommendationForSite
  ## Disables the specific rule for a web site permanently.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Rule name
  ##   siteName: string (required)
  ##           : Site name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_594129 = newJObject()
  var query_594130 = newJObject()
  add(path_594129, "resourceGroupName", newJString(resourceGroupName))
  add(query_594130, "api-version", newJString(apiVersion))
  add(path_594129, "name", newJString(name))
  add(path_594129, "siteName", newJString(siteName))
  add(path_594129, "subscriptionId", newJString(subscriptionId))
  result = call_594128.call(path_594129, query_594130, nil, nil, nil)

var recommendationsDisableRecommendationForSite* = Call_RecommendationsDisableRecommendationForSite_594119(
    name: "recommendationsDisableRecommendationForSite",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/recommendations/{name}/disable",
    validator: validate_RecommendationsDisableRecommendationForSite_594120,
    base: "", url: url_RecommendationsDisableRecommendationForSite_594121,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
