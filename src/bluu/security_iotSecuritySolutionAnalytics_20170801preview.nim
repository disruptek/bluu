
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Security Center
## version: 2017-08-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## API spec for Microsoft.Security (Azure Security Center) resource provider
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
  macServiceName = "security-iotSecuritySolutionAnalytics"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_IoTSecuritySolutionsAnalyticsGetAll_593646 = ref object of OpenApiRestCall_593424
proc url_IoTSecuritySolutionsAnalyticsGetAll_593648(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/iotSecuritySolutions/"),
               (kind: VariableSegment, value: "solutionName"),
               (kind: ConstantSegment, value: "/analyticsModels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IoTSecuritySolutionsAnalyticsGetAll_593647(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Security Analytics of a security solution
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The solution manager name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_593821 = path.getOrDefault("solutionName")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "solutionName", valid_593821
  var valid_593822 = path.getOrDefault("resourceGroupName")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "resourceGroupName", valid_593822
  var valid_593823 = path.getOrDefault("subscriptionId")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "subscriptionId", valid_593823
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593824 = query.getOrDefault("api-version")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "api-version", valid_593824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593847: Call_IoTSecuritySolutionsAnalyticsGetAll_593646;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Security Analytics of a security solution
  ## 
  let valid = call_593847.validator(path, query, header, formData, body)
  let scheme = call_593847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593847.url(scheme.get, call_593847.host, call_593847.base,
                         call_593847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593847, url, valid)

proc call*(call_593918: Call_IoTSecuritySolutionsAnalyticsGetAll_593646;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## ioTSecuritySolutionsAnalyticsGetAll
  ## Security Analytics of a security solution
  ##   solutionName: string (required)
  ##               : The solution manager name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_593919 = newJObject()
  var query_593921 = newJObject()
  add(path_593919, "solutionName", newJString(solutionName))
  add(path_593919, "resourceGroupName", newJString(resourceGroupName))
  add(query_593921, "api-version", newJString(apiVersion))
  add(path_593919, "subscriptionId", newJString(subscriptionId))
  result = call_593918.call(path_593919, query_593921, nil, nil, nil)

var ioTSecuritySolutionsAnalyticsGetAll* = Call_IoTSecuritySolutionsAnalyticsGetAll_593646(
    name: "ioTSecuritySolutionsAnalyticsGetAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels",
    validator: validate_IoTSecuritySolutionsAnalyticsGetAll_593647, base: "",
    url: url_IoTSecuritySolutionsAnalyticsGetAll_593648, schemes: {Scheme.Https})
type
  Call_IoTSecuritySolutionsAnalyticsGetDefault_593960 = ref object of OpenApiRestCall_593424
proc url_IoTSecuritySolutionsAnalyticsGetDefault_593962(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/iotSecuritySolutions/"),
               (kind: VariableSegment, value: "solutionName"),
               (kind: ConstantSegment, value: "/analyticsModels/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IoTSecuritySolutionsAnalyticsGetDefault_593961(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Security Analytics of a security solution
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The solution manager name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_593963 = path.getOrDefault("solutionName")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "solutionName", valid_593963
  var valid_593964 = path.getOrDefault("resourceGroupName")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "resourceGroupName", valid_593964
  var valid_593965 = path.getOrDefault("subscriptionId")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "subscriptionId", valid_593965
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593966 = query.getOrDefault("api-version")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "api-version", valid_593966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593967: Call_IoTSecuritySolutionsAnalyticsGetDefault_593960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Security Analytics of a security solution
  ## 
  let valid = call_593967.validator(path, query, header, formData, body)
  let scheme = call_593967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593967.url(scheme.get, call_593967.host, call_593967.base,
                         call_593967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593967, url, valid)

proc call*(call_593968: Call_IoTSecuritySolutionsAnalyticsGetDefault_593960;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## ioTSecuritySolutionsAnalyticsGetDefault
  ## Security Analytics of a security solution
  ##   solutionName: string (required)
  ##               : The solution manager name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_593969 = newJObject()
  var query_593970 = newJObject()
  add(path_593969, "solutionName", newJString(solutionName))
  add(path_593969, "resourceGroupName", newJString(resourceGroupName))
  add(query_593970, "api-version", newJString(apiVersion))
  add(path_593969, "subscriptionId", newJString(subscriptionId))
  result = call_593968.call(path_593969, query_593970, nil, nil, nil)

var ioTSecuritySolutionsAnalyticsGetDefault* = Call_IoTSecuritySolutionsAnalyticsGetDefault_593960(
    name: "ioTSecuritySolutionsAnalyticsGetDefault", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels/default",
    validator: validate_IoTSecuritySolutionsAnalyticsGetDefault_593961, base: "",
    url: url_IoTSecuritySolutionsAnalyticsGetDefault_593962,
    schemes: {Scheme.Https})
type
  Call_IoTSecuritySolutionsAnalyticsAggregatedAlertsList_593971 = ref object of OpenApiRestCall_593424
proc url_IoTSecuritySolutionsAnalyticsAggregatedAlertsList_593973(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/iotSecuritySolutions/"),
               (kind: VariableSegment, value: "solutionName"), (
        kind: ConstantSegment, value: "/analyticsModels/default/aggregatedAlerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IoTSecuritySolutionsAnalyticsAggregatedAlertsList_593972(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Security Analytics of a security solution
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The solution manager name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_593975 = path.getOrDefault("solutionName")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "solutionName", valid_593975
  var valid_593976 = path.getOrDefault("resourceGroupName")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "resourceGroupName", valid_593976
  var valid_593977 = path.getOrDefault("subscriptionId")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "subscriptionId", valid_593977
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $top: JInt
  ##       : The number of results to retrieve.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593978 = query.getOrDefault("api-version")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "api-version", valid_593978
  var valid_593979 = query.getOrDefault("$top")
  valid_593979 = validateParameter(valid_593979, JInt, required = false, default = nil)
  if valid_593979 != nil:
    section.add "$top", valid_593979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593980: Call_IoTSecuritySolutionsAnalyticsAggregatedAlertsList_593971;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Security Analytics of a security solution
  ## 
  let valid = call_593980.validator(path, query, header, formData, body)
  let scheme = call_593980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593980.url(scheme.get, call_593980.host, call_593980.base,
                         call_593980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593980, url, valid)

proc call*(call_593981: Call_IoTSecuritySolutionsAnalyticsAggregatedAlertsList_593971;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## ioTSecuritySolutionsAnalyticsAggregatedAlertsList
  ## Security Analytics of a security solution
  ##   solutionName: string (required)
  ##               : The solution manager name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Top: int
  ##      : The number of results to retrieve.
  var path_593982 = newJObject()
  var query_593983 = newJObject()
  add(path_593982, "solutionName", newJString(solutionName))
  add(path_593982, "resourceGroupName", newJString(resourceGroupName))
  add(query_593983, "api-version", newJString(apiVersion))
  add(path_593982, "subscriptionId", newJString(subscriptionId))
  add(query_593983, "$top", newJInt(Top))
  result = call_593981.call(path_593982, query_593983, nil, nil, nil)

var ioTSecuritySolutionsAnalyticsAggregatedAlertsList* = Call_IoTSecuritySolutionsAnalyticsAggregatedAlertsList_593971(
    name: "ioTSecuritySolutionsAnalyticsAggregatedAlertsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels/default/aggregatedAlerts",
    validator: validate_IoTSecuritySolutionsAnalyticsAggregatedAlertsList_593972,
    base: "", url: url_IoTSecuritySolutionsAnalyticsAggregatedAlertsList_593973,
    schemes: {Scheme.Https})
type
  Call_IoTSecuritySolutionsAnalyticsAggregatedAlertGet_593984 = ref object of OpenApiRestCall_593424
proc url_IoTSecuritySolutionsAnalyticsAggregatedAlertGet_593986(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  assert "aggregatedAlertName" in path,
        "`aggregatedAlertName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/iotSecuritySolutions/"),
               (kind: VariableSegment, value: "solutionName"), (
        kind: ConstantSegment, value: "/analyticsModels/default/aggregatedAlerts/"),
               (kind: VariableSegment, value: "aggregatedAlertName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IoTSecuritySolutionsAnalyticsAggregatedAlertGet_593985(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Security Analytics of a security solution
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The solution manager name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   aggregatedAlertName: JString (required)
  ##                      : Identifier of the aggregated alert
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_593987 = path.getOrDefault("solutionName")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "solutionName", valid_593987
  var valid_593988 = path.getOrDefault("resourceGroupName")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "resourceGroupName", valid_593988
  var valid_593989 = path.getOrDefault("aggregatedAlertName")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "aggregatedAlertName", valid_593989
  var valid_593990 = path.getOrDefault("subscriptionId")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "subscriptionId", valid_593990
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593991 = query.getOrDefault("api-version")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "api-version", valid_593991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593992: Call_IoTSecuritySolutionsAnalyticsAggregatedAlertGet_593984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Security Analytics of a security solution
  ## 
  let valid = call_593992.validator(path, query, header, formData, body)
  let scheme = call_593992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593992.url(scheme.get, call_593992.host, call_593992.base,
                         call_593992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593992, url, valid)

proc call*(call_593993: Call_IoTSecuritySolutionsAnalyticsAggregatedAlertGet_593984;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          aggregatedAlertName: string; subscriptionId: string): Recallable =
  ## ioTSecuritySolutionsAnalyticsAggregatedAlertGet
  ## Security Analytics of a security solution
  ##   solutionName: string (required)
  ##               : The solution manager name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   aggregatedAlertName: string (required)
  ##                      : Identifier of the aggregated alert
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_593994 = newJObject()
  var query_593995 = newJObject()
  add(path_593994, "solutionName", newJString(solutionName))
  add(path_593994, "resourceGroupName", newJString(resourceGroupName))
  add(query_593995, "api-version", newJString(apiVersion))
  add(path_593994, "aggregatedAlertName", newJString(aggregatedAlertName))
  add(path_593994, "subscriptionId", newJString(subscriptionId))
  result = call_593993.call(path_593994, query_593995, nil, nil, nil)

var ioTSecuritySolutionsAnalyticsAggregatedAlertGet* = Call_IoTSecuritySolutionsAnalyticsAggregatedAlertGet_593984(
    name: "ioTSecuritySolutionsAnalyticsAggregatedAlertGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels/default/aggregatedAlerts/{aggregatedAlertName}",
    validator: validate_IoTSecuritySolutionsAnalyticsAggregatedAlertGet_593985,
    base: "", url: url_IoTSecuritySolutionsAnalyticsAggregatedAlertGet_593986,
    schemes: {Scheme.Https})
type
  Call_IoTSecuritySolutionsAnalyticsAggregatedAlertDismiss_593996 = ref object of OpenApiRestCall_593424
proc url_IoTSecuritySolutionsAnalyticsAggregatedAlertDismiss_593998(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  assert "aggregatedAlertName" in path,
        "`aggregatedAlertName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/iotSecuritySolutions/"),
               (kind: VariableSegment, value: "solutionName"), (
        kind: ConstantSegment, value: "/analyticsModels/default/aggregatedAlerts/"),
               (kind: VariableSegment, value: "aggregatedAlertName"),
               (kind: ConstantSegment, value: "/dismiss")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IoTSecuritySolutionsAnalyticsAggregatedAlertDismiss_593997(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Security Analytics of a security solution
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The solution manager name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   aggregatedAlertName: JString (required)
  ##                      : Identifier of the aggregated alert
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_593999 = path.getOrDefault("solutionName")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "solutionName", valid_593999
  var valid_594000 = path.getOrDefault("resourceGroupName")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "resourceGroupName", valid_594000
  var valid_594001 = path.getOrDefault("aggregatedAlertName")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "aggregatedAlertName", valid_594001
  var valid_594002 = path.getOrDefault("subscriptionId")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "subscriptionId", valid_594002
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594003 = query.getOrDefault("api-version")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "api-version", valid_594003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594004: Call_IoTSecuritySolutionsAnalyticsAggregatedAlertDismiss_593996;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Security Analytics of a security solution
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_IoTSecuritySolutionsAnalyticsAggregatedAlertDismiss_593996;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          aggregatedAlertName: string; subscriptionId: string): Recallable =
  ## ioTSecuritySolutionsAnalyticsAggregatedAlertDismiss
  ## Security Analytics of a security solution
  ##   solutionName: string (required)
  ##               : The solution manager name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   aggregatedAlertName: string (required)
  ##                      : Identifier of the aggregated alert
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  add(path_594006, "solutionName", newJString(solutionName))
  add(path_594006, "resourceGroupName", newJString(resourceGroupName))
  add(query_594007, "api-version", newJString(apiVersion))
  add(path_594006, "aggregatedAlertName", newJString(aggregatedAlertName))
  add(path_594006, "subscriptionId", newJString(subscriptionId))
  result = call_594005.call(path_594006, query_594007, nil, nil, nil)

var ioTSecuritySolutionsAnalyticsAggregatedAlertDismiss* = Call_IoTSecuritySolutionsAnalyticsAggregatedAlertDismiss_593996(
    name: "ioTSecuritySolutionsAnalyticsAggregatedAlertDismiss",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels/default/aggregatedAlerts/{aggregatedAlertName}/dismiss",
    validator: validate_IoTSecuritySolutionsAnalyticsAggregatedAlertDismiss_593997,
    base: "", url: url_IoTSecuritySolutionsAnalyticsAggregatedAlertDismiss_593998,
    schemes: {Scheme.Https})
type
  Call_IoTSecuritySolutionsAnalyticsRecommendationsList_594008 = ref object of OpenApiRestCall_593424
proc url_IoTSecuritySolutionsAnalyticsRecommendationsList_594010(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/iotSecuritySolutions/"),
               (kind: VariableSegment, value: "solutionName"), (
        kind: ConstantSegment,
        value: "/analyticsModels/default/aggregatedRecommendations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IoTSecuritySolutionsAnalyticsRecommendationsList_594009(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Security Analytics of a security solution
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The solution manager name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_594011 = path.getOrDefault("solutionName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "solutionName", valid_594011
  var valid_594012 = path.getOrDefault("resourceGroupName")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "resourceGroupName", valid_594012
  var valid_594013 = path.getOrDefault("subscriptionId")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "subscriptionId", valid_594013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $top: JInt
  ##       : The number of results to retrieve.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594014 = query.getOrDefault("api-version")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "api-version", valid_594014
  var valid_594015 = query.getOrDefault("$top")
  valid_594015 = validateParameter(valid_594015, JInt, required = false, default = nil)
  if valid_594015 != nil:
    section.add "$top", valid_594015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594016: Call_IoTSecuritySolutionsAnalyticsRecommendationsList_594008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Security Analytics of a security solution
  ## 
  let valid = call_594016.validator(path, query, header, formData, body)
  let scheme = call_594016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594016.url(scheme.get, call_594016.host, call_594016.base,
                         call_594016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594016, url, valid)

proc call*(call_594017: Call_IoTSecuritySolutionsAnalyticsRecommendationsList_594008;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## ioTSecuritySolutionsAnalyticsRecommendationsList
  ## Security Analytics of a security solution
  ##   solutionName: string (required)
  ##               : The solution manager name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Top: int
  ##      : The number of results to retrieve.
  var path_594018 = newJObject()
  var query_594019 = newJObject()
  add(path_594018, "solutionName", newJString(solutionName))
  add(path_594018, "resourceGroupName", newJString(resourceGroupName))
  add(query_594019, "api-version", newJString(apiVersion))
  add(path_594018, "subscriptionId", newJString(subscriptionId))
  add(query_594019, "$top", newJInt(Top))
  result = call_594017.call(path_594018, query_594019, nil, nil, nil)

var ioTSecuritySolutionsAnalyticsRecommendationsList* = Call_IoTSecuritySolutionsAnalyticsRecommendationsList_594008(
    name: "ioTSecuritySolutionsAnalyticsRecommendationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels/default/aggregatedRecommendations",
    validator: validate_IoTSecuritySolutionsAnalyticsRecommendationsList_594009,
    base: "", url: url_IoTSecuritySolutionsAnalyticsRecommendationsList_594010,
    schemes: {Scheme.Https})
type
  Call_IoTSecuritySolutionsAnalyticsRecommendationGet_594020 = ref object of OpenApiRestCall_593424
proc url_IoTSecuritySolutionsAnalyticsRecommendationGet_594022(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  assert "aggregatedRecommendationName" in path,
        "`aggregatedRecommendationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/iotSecuritySolutions/"),
               (kind: VariableSegment, value: "solutionName"), (
        kind: ConstantSegment,
        value: "/analyticsModels/default/aggregatedRecommendations/"),
               (kind: VariableSegment, value: "aggregatedRecommendationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IoTSecuritySolutionsAnalyticsRecommendationGet_594021(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Security Analytics of a security solution
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The solution manager name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   aggregatedRecommendationName: JString (required)
  ##                               : Identifier of the aggregated recommendation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_594023 = path.getOrDefault("solutionName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "solutionName", valid_594023
  var valid_594024 = path.getOrDefault("resourceGroupName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "resourceGroupName", valid_594024
  var valid_594025 = path.getOrDefault("subscriptionId")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "subscriptionId", valid_594025
  var valid_594026 = path.getOrDefault("aggregatedRecommendationName")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "aggregatedRecommendationName", valid_594026
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
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

proc call*(call_594028: Call_IoTSecuritySolutionsAnalyticsRecommendationGet_594020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Security Analytics of a security solution
  ## 
  let valid = call_594028.validator(path, query, header, formData, body)
  let scheme = call_594028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594028.url(scheme.get, call_594028.host, call_594028.base,
                         call_594028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594028, url, valid)

proc call*(call_594029: Call_IoTSecuritySolutionsAnalyticsRecommendationGet_594020;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; aggregatedRecommendationName: string): Recallable =
  ## ioTSecuritySolutionsAnalyticsRecommendationGet
  ## Security Analytics of a security solution
  ##   solutionName: string (required)
  ##               : The solution manager name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   aggregatedRecommendationName: string (required)
  ##                               : Identifier of the aggregated recommendation
  var path_594030 = newJObject()
  var query_594031 = newJObject()
  add(path_594030, "solutionName", newJString(solutionName))
  add(path_594030, "resourceGroupName", newJString(resourceGroupName))
  add(query_594031, "api-version", newJString(apiVersion))
  add(path_594030, "subscriptionId", newJString(subscriptionId))
  add(path_594030, "aggregatedRecommendationName",
      newJString(aggregatedRecommendationName))
  result = call_594029.call(path_594030, query_594031, nil, nil, nil)

var ioTSecuritySolutionsAnalyticsRecommendationGet* = Call_IoTSecuritySolutionsAnalyticsRecommendationGet_594020(
    name: "ioTSecuritySolutionsAnalyticsRecommendationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels/default/aggregatedRecommendations/{aggregatedRecommendationName}",
    validator: validate_IoTSecuritySolutionsAnalyticsRecommendationGet_594021,
    base: "", url: url_IoTSecuritySolutionsAnalyticsRecommendationGet_594022,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
