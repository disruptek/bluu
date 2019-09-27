
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Security Insights
## version: 2019-01-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## API spec for Microsoft.SecurityInsights (Azure Security Insights) resource provider
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

  OpenApiRestCall_593438 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593438](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593438): Option[Scheme] {.used.} =
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
  macServiceName = "securityinsights-SecurityInsights"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593660 = ref object of OpenApiRestCall_593438
proc url_OperationsList_593662(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593661(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all operations available Azure Security Insights Resource Provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593834 = query.getOrDefault("api-version")
  valid_593834 = validateParameter(valid_593834, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_593834 != nil:
    section.add "api-version", valid_593834
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593857: Call_OperationsList_593660; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all operations available Azure Security Insights Resource Provider.
  ## 
  let valid = call_593857.validator(path, query, header, formData, body)
  let scheme = call_593857.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593857.url(scheme.get, call_593857.host, call_593857.base,
                         call_593857.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593857, url, valid)

proc call*(call_593928: Call_OperationsList_593660;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## operationsList
  ## Lists all operations available Azure Security Insights Resource Provider.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  var query_593929 = newJObject()
  add(query_593929, "api-version", newJString(apiVersion))
  result = call_593928.call(nil, query_593929, nil, nil, nil)

var operationsList* = Call_OperationsList_593660(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.SecurityInsights/operations",
    validator: validate_OperationsList_593661, base: "", url: url_OperationsList_593662,
    schemes: {Scheme.Https})
type
  Call_CasesAggregationsGet_593969 = ref object of OpenApiRestCall_593438
proc url_CasesAggregationsGet_593971(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "aggregationsName" in path,
        "`aggregationsName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/aggregations/"),
               (kind: VariableSegment, value: "aggregationsName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CasesAggregationsGet_593970(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get aggregative result for the given resources under the defined workspace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   aggregationsName: JString (required)
  ##                   : The aggregation name. Supports - Cases
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593986 = path.getOrDefault("resourceGroupName")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "resourceGroupName", valid_593986
  var valid_593987 = path.getOrDefault("subscriptionId")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "subscriptionId", valid_593987
  var valid_593988 = path.getOrDefault("aggregationsName")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "aggregationsName", valid_593988
  var valid_593989 = path.getOrDefault("workspaceName")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "workspaceName", valid_593989
  var valid_593990 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "operationalInsightsResourceProvider", valid_593990
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593991 = query.getOrDefault("api-version")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_593991 != nil:
    section.add "api-version", valid_593991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593992: Call_CasesAggregationsGet_593969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get aggregative result for the given resources under the defined workspace
  ## 
  let valid = call_593992.validator(path, query, header, formData, body)
  let scheme = call_593992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593992.url(scheme.get, call_593992.host, call_593992.base,
                         call_593992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593992, url, valid)

proc call*(call_593993: Call_CasesAggregationsGet_593969;
          resourceGroupName: string; subscriptionId: string;
          aggregationsName: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## casesAggregationsGet
  ## Get aggregative result for the given resources under the defined workspace
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   aggregationsName: string (required)
  ##                   : The aggregation name. Supports - Cases
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_593994 = newJObject()
  var query_593995 = newJObject()
  add(path_593994, "resourceGroupName", newJString(resourceGroupName))
  add(query_593995, "api-version", newJString(apiVersion))
  add(path_593994, "subscriptionId", newJString(subscriptionId))
  add(path_593994, "aggregationsName", newJString(aggregationsName))
  add(path_593994, "workspaceName", newJString(workspaceName))
  add(path_593994, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_593993.call(path_593994, query_593995, nil, nil, nil)

var casesAggregationsGet* = Call_CasesAggregationsGet_593969(
    name: "casesAggregationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/aggregations/{aggregationsName}",
    validator: validate_CasesAggregationsGet_593970, base: "",
    url: url_CasesAggregationsGet_593971, schemes: {Scheme.Https})
type
  Call_AlertRuleTemplatesList_593996 = ref object of OpenApiRestCall_593438
proc url_AlertRuleTemplatesList_593998(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/alertRuleTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertRuleTemplatesList_593997(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all alert rule templates.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593999 = path.getOrDefault("resourceGroupName")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "resourceGroupName", valid_593999
  var valid_594000 = path.getOrDefault("subscriptionId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "subscriptionId", valid_594000
  var valid_594001 = path.getOrDefault("workspaceName")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "workspaceName", valid_594001
  var valid_594002 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "operationalInsightsResourceProvider", valid_594002
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594003 = query.getOrDefault("api-version")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594003 != nil:
    section.add "api-version", valid_594003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594004: Call_AlertRuleTemplatesList_593996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all alert rule templates.
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_AlertRuleTemplatesList_593996;
          resourceGroupName: string; subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRuleTemplatesList
  ## Gets all alert rule templates.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  add(path_594006, "resourceGroupName", newJString(resourceGroupName))
  add(query_594007, "api-version", newJString(apiVersion))
  add(path_594006, "subscriptionId", newJString(subscriptionId))
  add(path_594006, "workspaceName", newJString(workspaceName))
  add(path_594006, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594005.call(path_594006, query_594007, nil, nil, nil)

var alertRuleTemplatesList* = Call_AlertRuleTemplatesList_593996(
    name: "alertRuleTemplatesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRuleTemplates",
    validator: validate_AlertRuleTemplatesList_593997, base: "",
    url: url_AlertRuleTemplatesList_593998, schemes: {Scheme.Https})
type
  Call_AlertRuleTemplatesGet_594008 = ref object of OpenApiRestCall_593438
proc url_AlertRuleTemplatesGet_594010(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "alertRuleTemplateId" in path,
        "`alertRuleTemplateId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/alertRuleTemplates/"),
               (kind: VariableSegment, value: "alertRuleTemplateId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertRuleTemplatesGet_594009(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the alert rule template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   alertRuleTemplateId: JString (required)
  ##                      : Alert rule template ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594011 = path.getOrDefault("resourceGroupName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "resourceGroupName", valid_594011
  var valid_594012 = path.getOrDefault("subscriptionId")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "subscriptionId", valid_594012
  var valid_594013 = path.getOrDefault("alertRuleTemplateId")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "alertRuleTemplateId", valid_594013
  var valid_594014 = path.getOrDefault("workspaceName")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "workspaceName", valid_594014
  var valid_594015 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "operationalInsightsResourceProvider", valid_594015
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594016 = query.getOrDefault("api-version")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594016 != nil:
    section.add "api-version", valid_594016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594017: Call_AlertRuleTemplatesGet_594008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert rule template.
  ## 
  let valid = call_594017.validator(path, query, header, formData, body)
  let scheme = call_594017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594017.url(scheme.get, call_594017.host, call_594017.base,
                         call_594017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594017, url, valid)

proc call*(call_594018: Call_AlertRuleTemplatesGet_594008;
          resourceGroupName: string; subscriptionId: string;
          alertRuleTemplateId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRuleTemplatesGet
  ## Gets the alert rule template.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   alertRuleTemplateId: string (required)
  ##                      : Alert rule template ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594019 = newJObject()
  var query_594020 = newJObject()
  add(path_594019, "resourceGroupName", newJString(resourceGroupName))
  add(query_594020, "api-version", newJString(apiVersion))
  add(path_594019, "subscriptionId", newJString(subscriptionId))
  add(path_594019, "alertRuleTemplateId", newJString(alertRuleTemplateId))
  add(path_594019, "workspaceName", newJString(workspaceName))
  add(path_594019, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594018.call(path_594019, query_594020, nil, nil, nil)

var alertRuleTemplatesGet* = Call_AlertRuleTemplatesGet_594008(
    name: "alertRuleTemplatesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRuleTemplates/{alertRuleTemplateId}",
    validator: validate_AlertRuleTemplatesGet_594009, base: "",
    url: url_AlertRuleTemplatesGet_594010, schemes: {Scheme.Https})
type
  Call_AlertRulesList_594021 = ref object of OpenApiRestCall_593438
proc url_AlertRulesList_594023(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/alertRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertRulesList_594022(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets all alert rules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
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
  var valid_594026 = path.getOrDefault("workspaceName")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "workspaceName", valid_594026
  var valid_594027 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "operationalInsightsResourceProvider", valid_594027
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594028 = query.getOrDefault("api-version")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594028 != nil:
    section.add "api-version", valid_594028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594029: Call_AlertRulesList_594021; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all alert rules.
  ## 
  let valid = call_594029.validator(path, query, header, formData, body)
  let scheme = call_594029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594029.url(scheme.get, call_594029.host, call_594029.base,
                         call_594029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594029, url, valid)

proc call*(call_594030: Call_AlertRulesList_594021; resourceGroupName: string;
          subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesList
  ## Gets all alert rules.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594031 = newJObject()
  var query_594032 = newJObject()
  add(path_594031, "resourceGroupName", newJString(resourceGroupName))
  add(query_594032, "api-version", newJString(apiVersion))
  add(path_594031, "subscriptionId", newJString(subscriptionId))
  add(path_594031, "workspaceName", newJString(workspaceName))
  add(path_594031, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594030.call(path_594031, query_594032, nil, nil, nil)

var alertRulesList* = Call_AlertRulesList_594021(name: "alertRulesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules",
    validator: validate_AlertRulesList_594022, base: "", url: url_AlertRulesList_594023,
    schemes: {Scheme.Https})
type
  Call_AlertRulesCreateOrUpdate_594046 = ref object of OpenApiRestCall_593438
proc url_AlertRulesCreateOrUpdate_594048(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "ruleId" in path, "`ruleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/alertRules/"),
               (kind: VariableSegment, value: "ruleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertRulesCreateOrUpdate_594047(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594049 = path.getOrDefault("resourceGroupName")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "resourceGroupName", valid_594049
  var valid_594050 = path.getOrDefault("subscriptionId")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "subscriptionId", valid_594050
  var valid_594051 = path.getOrDefault("ruleId")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "ruleId", valid_594051
  var valid_594052 = path.getOrDefault("workspaceName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "workspaceName", valid_594052
  var valid_594053 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "operationalInsightsResourceProvider", valid_594053
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594054 = query.getOrDefault("api-version")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594054 != nil:
    section.add "api-version", valid_594054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   alertRule: JObject (required)
  ##            : The alert rule
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594056: Call_AlertRulesCreateOrUpdate_594046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the alert rule.
  ## 
  let valid = call_594056.validator(path, query, header, formData, body)
  let scheme = call_594056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594056.url(scheme.get, call_594056.host, call_594056.base,
                         call_594056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594056, url, valid)

proc call*(call_594057: Call_AlertRulesCreateOrUpdate_594046;
          resourceGroupName: string; alertRule: JsonNode; subscriptionId: string;
          ruleId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesCreateOrUpdate
  ## Creates or updates the alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   alertRule: JObject (required)
  ##            : The alert rule
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594058 = newJObject()
  var query_594059 = newJObject()
  var body_594060 = newJObject()
  add(path_594058, "resourceGroupName", newJString(resourceGroupName))
  add(query_594059, "api-version", newJString(apiVersion))
  if alertRule != nil:
    body_594060 = alertRule
  add(path_594058, "subscriptionId", newJString(subscriptionId))
  add(path_594058, "ruleId", newJString(ruleId))
  add(path_594058, "workspaceName", newJString(workspaceName))
  add(path_594058, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594057.call(path_594058, query_594059, nil, nil, body_594060)

var alertRulesCreateOrUpdate* = Call_AlertRulesCreateOrUpdate_594046(
    name: "alertRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}",
    validator: validate_AlertRulesCreateOrUpdate_594047, base: "",
    url: url_AlertRulesCreateOrUpdate_594048, schemes: {Scheme.Https})
type
  Call_AlertRulesGet_594033 = ref object of OpenApiRestCall_593438
proc url_AlertRulesGet_594035(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "ruleId" in path, "`ruleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/alertRules/"),
               (kind: VariableSegment, value: "ruleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertRulesGet_594034(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594036 = path.getOrDefault("resourceGroupName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "resourceGroupName", valid_594036
  var valid_594037 = path.getOrDefault("subscriptionId")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "subscriptionId", valid_594037
  var valid_594038 = path.getOrDefault("ruleId")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "ruleId", valid_594038
  var valid_594039 = path.getOrDefault("workspaceName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "workspaceName", valid_594039
  var valid_594040 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "operationalInsightsResourceProvider", valid_594040
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594041 = query.getOrDefault("api-version")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594041 != nil:
    section.add "api-version", valid_594041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594042: Call_AlertRulesGet_594033; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert rule.
  ## 
  let valid = call_594042.validator(path, query, header, formData, body)
  let scheme = call_594042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594042.url(scheme.get, call_594042.host, call_594042.base,
                         call_594042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594042, url, valid)

proc call*(call_594043: Call_AlertRulesGet_594033; resourceGroupName: string;
          subscriptionId: string; ruleId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesGet
  ## Gets the alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594044 = newJObject()
  var query_594045 = newJObject()
  add(path_594044, "resourceGroupName", newJString(resourceGroupName))
  add(query_594045, "api-version", newJString(apiVersion))
  add(path_594044, "subscriptionId", newJString(subscriptionId))
  add(path_594044, "ruleId", newJString(ruleId))
  add(path_594044, "workspaceName", newJString(workspaceName))
  add(path_594044, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594043.call(path_594044, query_594045, nil, nil, nil)

var alertRulesGet* = Call_AlertRulesGet_594033(name: "alertRulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}",
    validator: validate_AlertRulesGet_594034, base: "", url: url_AlertRulesGet_594035,
    schemes: {Scheme.Https})
type
  Call_AlertRulesDelete_594061 = ref object of OpenApiRestCall_593438
proc url_AlertRulesDelete_594063(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "ruleId" in path, "`ruleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/alertRules/"),
               (kind: VariableSegment, value: "ruleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertRulesDelete_594062(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Delete the alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594064 = path.getOrDefault("resourceGroupName")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "resourceGroupName", valid_594064
  var valid_594065 = path.getOrDefault("subscriptionId")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "subscriptionId", valid_594065
  var valid_594066 = path.getOrDefault("ruleId")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "ruleId", valid_594066
  var valid_594067 = path.getOrDefault("workspaceName")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "workspaceName", valid_594067
  var valid_594068 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "operationalInsightsResourceProvider", valid_594068
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594069 = query.getOrDefault("api-version")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594069 != nil:
    section.add "api-version", valid_594069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594070: Call_AlertRulesDelete_594061; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the alert rule.
  ## 
  let valid = call_594070.validator(path, query, header, formData, body)
  let scheme = call_594070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594070.url(scheme.get, call_594070.host, call_594070.base,
                         call_594070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594070, url, valid)

proc call*(call_594071: Call_AlertRulesDelete_594061; resourceGroupName: string;
          subscriptionId: string; ruleId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesDelete
  ## Delete the alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594072 = newJObject()
  var query_594073 = newJObject()
  add(path_594072, "resourceGroupName", newJString(resourceGroupName))
  add(query_594073, "api-version", newJString(apiVersion))
  add(path_594072, "subscriptionId", newJString(subscriptionId))
  add(path_594072, "ruleId", newJString(ruleId))
  add(path_594072, "workspaceName", newJString(workspaceName))
  add(path_594072, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594071.call(path_594072, query_594073, nil, nil, nil)

var alertRulesDelete* = Call_AlertRulesDelete_594061(name: "alertRulesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}",
    validator: validate_AlertRulesDelete_594062, base: "",
    url: url_AlertRulesDelete_594063, schemes: {Scheme.Https})
type
  Call_ActionsListByAlertRule_594074 = ref object of OpenApiRestCall_593438
proc url_ActionsListByAlertRule_594076(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "ruleId" in path, "`ruleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/alertRules/"),
               (kind: VariableSegment, value: "ruleId"),
               (kind: ConstantSegment, value: "/actions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActionsListByAlertRule_594075(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all actions of alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594077 = path.getOrDefault("resourceGroupName")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "resourceGroupName", valid_594077
  var valid_594078 = path.getOrDefault("subscriptionId")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "subscriptionId", valid_594078
  var valid_594079 = path.getOrDefault("ruleId")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "ruleId", valid_594079
  var valid_594080 = path.getOrDefault("workspaceName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "workspaceName", valid_594080
  var valid_594081 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "operationalInsightsResourceProvider", valid_594081
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594082 = query.getOrDefault("api-version")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594082 != nil:
    section.add "api-version", valid_594082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594083: Call_ActionsListByAlertRule_594074; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all actions of alert rule.
  ## 
  let valid = call_594083.validator(path, query, header, formData, body)
  let scheme = call_594083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594083.url(scheme.get, call_594083.host, call_594083.base,
                         call_594083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594083, url, valid)

proc call*(call_594084: Call_ActionsListByAlertRule_594074;
          resourceGroupName: string; subscriptionId: string; ruleId: string;
          workspaceName: string; operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## actionsListByAlertRule
  ## Gets all actions of alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594085 = newJObject()
  var query_594086 = newJObject()
  add(path_594085, "resourceGroupName", newJString(resourceGroupName))
  add(query_594086, "api-version", newJString(apiVersion))
  add(path_594085, "subscriptionId", newJString(subscriptionId))
  add(path_594085, "ruleId", newJString(ruleId))
  add(path_594085, "workspaceName", newJString(workspaceName))
  add(path_594085, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594084.call(path_594085, query_594086, nil, nil, nil)

var actionsListByAlertRule* = Call_ActionsListByAlertRule_594074(
    name: "actionsListByAlertRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}/actions",
    validator: validate_ActionsListByAlertRule_594075, base: "",
    url: url_ActionsListByAlertRule_594076, schemes: {Scheme.Https})
type
  Call_AlertRulesCreateOrUpdateAction_594101 = ref object of OpenApiRestCall_593438
proc url_AlertRulesCreateOrUpdateAction_594103(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "ruleId" in path, "`ruleId` is a required path parameter"
  assert "actionId" in path, "`actionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/alertRules/"),
               (kind: VariableSegment, value: "ruleId"),
               (kind: ConstantSegment, value: "/actions/"),
               (kind: VariableSegment, value: "actionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertRulesCreateOrUpdateAction_594102(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the action of alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   actionId: JString (required)
  ##           : Action ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594104 = path.getOrDefault("resourceGroupName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "resourceGroupName", valid_594104
  var valid_594105 = path.getOrDefault("subscriptionId")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "subscriptionId", valid_594105
  var valid_594106 = path.getOrDefault("ruleId")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "ruleId", valid_594106
  var valid_594107 = path.getOrDefault("actionId")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "actionId", valid_594107
  var valid_594108 = path.getOrDefault("workspaceName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "workspaceName", valid_594108
  var valid_594109 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "operationalInsightsResourceProvider", valid_594109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594110 = query.getOrDefault("api-version")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594110 != nil:
    section.add "api-version", valid_594110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   action: JObject (required)
  ##         : The action
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594112: Call_AlertRulesCreateOrUpdateAction_594101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the action of alert rule.
  ## 
  let valid = call_594112.validator(path, query, header, formData, body)
  let scheme = call_594112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594112.url(scheme.get, call_594112.host, call_594112.base,
                         call_594112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594112, url, valid)

proc call*(call_594113: Call_AlertRulesCreateOrUpdateAction_594101;
          resourceGroupName: string; action: JsonNode; subscriptionId: string;
          ruleId: string; actionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesCreateOrUpdateAction
  ## Creates or updates the action of alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   action: JObject (required)
  ##         : The action
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   actionId: string (required)
  ##           : Action ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594114 = newJObject()
  var query_594115 = newJObject()
  var body_594116 = newJObject()
  add(path_594114, "resourceGroupName", newJString(resourceGroupName))
  if action != nil:
    body_594116 = action
  add(query_594115, "api-version", newJString(apiVersion))
  add(path_594114, "subscriptionId", newJString(subscriptionId))
  add(path_594114, "ruleId", newJString(ruleId))
  add(path_594114, "actionId", newJString(actionId))
  add(path_594114, "workspaceName", newJString(workspaceName))
  add(path_594114, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594113.call(path_594114, query_594115, nil, nil, body_594116)

var alertRulesCreateOrUpdateAction* = Call_AlertRulesCreateOrUpdateAction_594101(
    name: "alertRulesCreateOrUpdateAction", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}/actions/{actionId}",
    validator: validate_AlertRulesCreateOrUpdateAction_594102, base: "",
    url: url_AlertRulesCreateOrUpdateAction_594103, schemes: {Scheme.Https})
type
  Call_AlertRulesGetAction_594087 = ref object of OpenApiRestCall_593438
proc url_AlertRulesGetAction_594089(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "ruleId" in path, "`ruleId` is a required path parameter"
  assert "actionId" in path, "`actionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/alertRules/"),
               (kind: VariableSegment, value: "ruleId"),
               (kind: ConstantSegment, value: "/actions/"),
               (kind: VariableSegment, value: "actionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertRulesGetAction_594088(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the action of alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   actionId: JString (required)
  ##           : Action ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594090 = path.getOrDefault("resourceGroupName")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "resourceGroupName", valid_594090
  var valid_594091 = path.getOrDefault("subscriptionId")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "subscriptionId", valid_594091
  var valid_594092 = path.getOrDefault("ruleId")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "ruleId", valid_594092
  var valid_594093 = path.getOrDefault("actionId")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "actionId", valid_594093
  var valid_594094 = path.getOrDefault("workspaceName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "workspaceName", valid_594094
  var valid_594095 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "operationalInsightsResourceProvider", valid_594095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594096 = query.getOrDefault("api-version")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594096 != nil:
    section.add "api-version", valid_594096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594097: Call_AlertRulesGetAction_594087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the action of alert rule.
  ## 
  let valid = call_594097.validator(path, query, header, formData, body)
  let scheme = call_594097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594097.url(scheme.get, call_594097.host, call_594097.base,
                         call_594097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594097, url, valid)

proc call*(call_594098: Call_AlertRulesGetAction_594087; resourceGroupName: string;
          subscriptionId: string; ruleId: string; actionId: string;
          workspaceName: string; operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesGetAction
  ## Gets the action of alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   actionId: string (required)
  ##           : Action ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594099 = newJObject()
  var query_594100 = newJObject()
  add(path_594099, "resourceGroupName", newJString(resourceGroupName))
  add(query_594100, "api-version", newJString(apiVersion))
  add(path_594099, "subscriptionId", newJString(subscriptionId))
  add(path_594099, "ruleId", newJString(ruleId))
  add(path_594099, "actionId", newJString(actionId))
  add(path_594099, "workspaceName", newJString(workspaceName))
  add(path_594099, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594098.call(path_594099, query_594100, nil, nil, nil)

var alertRulesGetAction* = Call_AlertRulesGetAction_594087(
    name: "alertRulesGetAction", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}/actions/{actionId}",
    validator: validate_AlertRulesGetAction_594088, base: "",
    url: url_AlertRulesGetAction_594089, schemes: {Scheme.Https})
type
  Call_AlertRulesDeleteAction_594117 = ref object of OpenApiRestCall_593438
proc url_AlertRulesDeleteAction_594119(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "ruleId" in path, "`ruleId` is a required path parameter"
  assert "actionId" in path, "`actionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/alertRules/"),
               (kind: VariableSegment, value: "ruleId"),
               (kind: ConstantSegment, value: "/actions/"),
               (kind: VariableSegment, value: "actionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertRulesDeleteAction_594118(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the action of alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   actionId: JString (required)
  ##           : Action ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594120 = path.getOrDefault("resourceGroupName")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "resourceGroupName", valid_594120
  var valid_594121 = path.getOrDefault("subscriptionId")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "subscriptionId", valid_594121
  var valid_594122 = path.getOrDefault("ruleId")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "ruleId", valid_594122
  var valid_594123 = path.getOrDefault("actionId")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "actionId", valid_594123
  var valid_594124 = path.getOrDefault("workspaceName")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "workspaceName", valid_594124
  var valid_594125 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "operationalInsightsResourceProvider", valid_594125
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594126 = query.getOrDefault("api-version")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594126 != nil:
    section.add "api-version", valid_594126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594127: Call_AlertRulesDeleteAction_594117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the action of alert rule.
  ## 
  let valid = call_594127.validator(path, query, header, formData, body)
  let scheme = call_594127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594127.url(scheme.get, call_594127.host, call_594127.base,
                         call_594127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594127, url, valid)

proc call*(call_594128: Call_AlertRulesDeleteAction_594117;
          resourceGroupName: string; subscriptionId: string; ruleId: string;
          actionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesDeleteAction
  ## Delete the action of alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   actionId: string (required)
  ##           : Action ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594129 = newJObject()
  var query_594130 = newJObject()
  add(path_594129, "resourceGroupName", newJString(resourceGroupName))
  add(query_594130, "api-version", newJString(apiVersion))
  add(path_594129, "subscriptionId", newJString(subscriptionId))
  add(path_594129, "ruleId", newJString(ruleId))
  add(path_594129, "actionId", newJString(actionId))
  add(path_594129, "workspaceName", newJString(workspaceName))
  add(path_594129, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594128.call(path_594129, query_594130, nil, nil, nil)

var alertRulesDeleteAction* = Call_AlertRulesDeleteAction_594117(
    name: "alertRulesDeleteAction", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}/actions/{actionId}",
    validator: validate_AlertRulesDeleteAction_594118, base: "",
    url: url_AlertRulesDeleteAction_594119, schemes: {Scheme.Https})
type
  Call_BookmarksList_594131 = ref object of OpenApiRestCall_593438
proc url_BookmarksList_594133(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/bookmarks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BookmarksList_594132(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all bookmarks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594134 = path.getOrDefault("resourceGroupName")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "resourceGroupName", valid_594134
  var valid_594135 = path.getOrDefault("subscriptionId")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "subscriptionId", valid_594135
  var valid_594136 = path.getOrDefault("workspaceName")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "workspaceName", valid_594136
  var valid_594137 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "operationalInsightsResourceProvider", valid_594137
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594138 = query.getOrDefault("api-version")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594138 != nil:
    section.add "api-version", valid_594138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594139: Call_BookmarksList_594131; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all bookmarks.
  ## 
  let valid = call_594139.validator(path, query, header, formData, body)
  let scheme = call_594139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594139.url(scheme.get, call_594139.host, call_594139.base,
                         call_594139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594139, url, valid)

proc call*(call_594140: Call_BookmarksList_594131; resourceGroupName: string;
          subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarksList
  ## Gets all bookmarks.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594141 = newJObject()
  var query_594142 = newJObject()
  add(path_594141, "resourceGroupName", newJString(resourceGroupName))
  add(query_594142, "api-version", newJString(apiVersion))
  add(path_594141, "subscriptionId", newJString(subscriptionId))
  add(path_594141, "workspaceName", newJString(workspaceName))
  add(path_594141, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594140.call(path_594141, query_594142, nil, nil, nil)

var bookmarksList* = Call_BookmarksList_594131(name: "bookmarksList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks",
    validator: validate_BookmarksList_594132, base: "", url: url_BookmarksList_594133,
    schemes: {Scheme.Https})
type
  Call_BookmarksCreateOrUpdate_594156 = ref object of OpenApiRestCall_593438
proc url_BookmarksCreateOrUpdate_594158(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "bookmarkId" in path, "`bookmarkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/bookmarks/"),
               (kind: VariableSegment, value: "bookmarkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BookmarksCreateOrUpdate_594157(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the bookmark.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594159 = path.getOrDefault("resourceGroupName")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "resourceGroupName", valid_594159
  var valid_594160 = path.getOrDefault("bookmarkId")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "bookmarkId", valid_594160
  var valid_594161 = path.getOrDefault("subscriptionId")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "subscriptionId", valid_594161
  var valid_594162 = path.getOrDefault("workspaceName")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "workspaceName", valid_594162
  var valid_594163 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "operationalInsightsResourceProvider", valid_594163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594164 = query.getOrDefault("api-version")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594164 != nil:
    section.add "api-version", valid_594164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   bookmark: JObject (required)
  ##           : The bookmark
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594166: Call_BookmarksCreateOrUpdate_594156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the bookmark.
  ## 
  let valid = call_594166.validator(path, query, header, formData, body)
  let scheme = call_594166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594166.url(scheme.get, call_594166.host, call_594166.base,
                         call_594166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594166, url, valid)

proc call*(call_594167: Call_BookmarksCreateOrUpdate_594156;
          resourceGroupName: string; bookmarkId: string; subscriptionId: string;
          bookmark: JsonNode; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarksCreateOrUpdate
  ## Creates or updates the bookmark.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   bookmark: JObject (required)
  ##           : The bookmark
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594168 = newJObject()
  var query_594169 = newJObject()
  var body_594170 = newJObject()
  add(path_594168, "resourceGroupName", newJString(resourceGroupName))
  add(query_594169, "api-version", newJString(apiVersion))
  add(path_594168, "bookmarkId", newJString(bookmarkId))
  add(path_594168, "subscriptionId", newJString(subscriptionId))
  if bookmark != nil:
    body_594170 = bookmark
  add(path_594168, "workspaceName", newJString(workspaceName))
  add(path_594168, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594167.call(path_594168, query_594169, nil, nil, body_594170)

var bookmarksCreateOrUpdate* = Call_BookmarksCreateOrUpdate_594156(
    name: "bookmarksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}",
    validator: validate_BookmarksCreateOrUpdate_594157, base: "",
    url: url_BookmarksCreateOrUpdate_594158, schemes: {Scheme.Https})
type
  Call_BookmarksGet_594143 = ref object of OpenApiRestCall_593438
proc url_BookmarksGet_594145(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "bookmarkId" in path, "`bookmarkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/bookmarks/"),
               (kind: VariableSegment, value: "bookmarkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BookmarksGet_594144(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a bookmark.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594146 = path.getOrDefault("resourceGroupName")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "resourceGroupName", valid_594146
  var valid_594147 = path.getOrDefault("bookmarkId")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "bookmarkId", valid_594147
  var valid_594148 = path.getOrDefault("subscriptionId")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "subscriptionId", valid_594148
  var valid_594149 = path.getOrDefault("workspaceName")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "workspaceName", valid_594149
  var valid_594150 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "operationalInsightsResourceProvider", valid_594150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594151 = query.getOrDefault("api-version")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594151 != nil:
    section.add "api-version", valid_594151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594152: Call_BookmarksGet_594143; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a bookmark.
  ## 
  let valid = call_594152.validator(path, query, header, formData, body)
  let scheme = call_594152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594152.url(scheme.get, call_594152.host, call_594152.base,
                         call_594152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594152, url, valid)

proc call*(call_594153: Call_BookmarksGet_594143; resourceGroupName: string;
          bookmarkId: string; subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarksGet
  ## Gets a bookmark.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594154 = newJObject()
  var query_594155 = newJObject()
  add(path_594154, "resourceGroupName", newJString(resourceGroupName))
  add(query_594155, "api-version", newJString(apiVersion))
  add(path_594154, "bookmarkId", newJString(bookmarkId))
  add(path_594154, "subscriptionId", newJString(subscriptionId))
  add(path_594154, "workspaceName", newJString(workspaceName))
  add(path_594154, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594153.call(path_594154, query_594155, nil, nil, nil)

var bookmarksGet* = Call_BookmarksGet_594143(name: "bookmarksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}",
    validator: validate_BookmarksGet_594144, base: "", url: url_BookmarksGet_594145,
    schemes: {Scheme.Https})
type
  Call_BookmarksDelete_594171 = ref object of OpenApiRestCall_593438
proc url_BookmarksDelete_594173(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "bookmarkId" in path, "`bookmarkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/bookmarks/"),
               (kind: VariableSegment, value: "bookmarkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BookmarksDelete_594172(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Delete the bookmark.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594174 = path.getOrDefault("resourceGroupName")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "resourceGroupName", valid_594174
  var valid_594175 = path.getOrDefault("bookmarkId")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "bookmarkId", valid_594175
  var valid_594176 = path.getOrDefault("subscriptionId")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "subscriptionId", valid_594176
  var valid_594177 = path.getOrDefault("workspaceName")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "workspaceName", valid_594177
  var valid_594178 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "operationalInsightsResourceProvider", valid_594178
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594179 = query.getOrDefault("api-version")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594179 != nil:
    section.add "api-version", valid_594179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594180: Call_BookmarksDelete_594171; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the bookmark.
  ## 
  let valid = call_594180.validator(path, query, header, formData, body)
  let scheme = call_594180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594180.url(scheme.get, call_594180.host, call_594180.base,
                         call_594180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594180, url, valid)

proc call*(call_594181: Call_BookmarksDelete_594171; resourceGroupName: string;
          bookmarkId: string; subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarksDelete
  ## Delete the bookmark.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594182 = newJObject()
  var query_594183 = newJObject()
  add(path_594182, "resourceGroupName", newJString(resourceGroupName))
  add(query_594183, "api-version", newJString(apiVersion))
  add(path_594182, "bookmarkId", newJString(bookmarkId))
  add(path_594182, "subscriptionId", newJString(subscriptionId))
  add(path_594182, "workspaceName", newJString(workspaceName))
  add(path_594182, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594181.call(path_594182, query_594183, nil, nil, nil)

var bookmarksDelete* = Call_BookmarksDelete_594171(name: "bookmarksDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}",
    validator: validate_BookmarksDelete_594172, base: "", url: url_BookmarksDelete_594173,
    schemes: {Scheme.Https})
type
  Call_BookmarkRelationsList_594184 = ref object of OpenApiRestCall_593438
proc url_BookmarkRelationsList_594186(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "bookmarkId" in path, "`bookmarkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/bookmarks/"),
               (kind: VariableSegment, value: "bookmarkId"),
               (kind: ConstantSegment, value: "/relations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BookmarkRelationsList_594185(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all bookmark relations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594188 = path.getOrDefault("resourceGroupName")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "resourceGroupName", valid_594188
  var valid_594189 = path.getOrDefault("bookmarkId")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "bookmarkId", valid_594189
  var valid_594190 = path.getOrDefault("subscriptionId")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "subscriptionId", valid_594190
  var valid_594191 = path.getOrDefault("workspaceName")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "workspaceName", valid_594191
  var valid_594192 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "operationalInsightsResourceProvider", valid_594192
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Sorts the results. Optional.
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $top: JInt
  ##       : Returns only the first n results. Optional.
  ##   $skipToken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   $filter: JString
  ##          : Filters the results, based on a Boolean condition. Optional.
  section = newJObject()
  var valid_594193 = query.getOrDefault("$orderby")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "$orderby", valid_594193
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594194 = query.getOrDefault("api-version")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594194 != nil:
    section.add "api-version", valid_594194
  var valid_594195 = query.getOrDefault("$top")
  valid_594195 = validateParameter(valid_594195, JInt, required = false, default = nil)
  if valid_594195 != nil:
    section.add "$top", valid_594195
  var valid_594196 = query.getOrDefault("$skipToken")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = nil)
  if valid_594196 != nil:
    section.add "$skipToken", valid_594196
  var valid_594197 = query.getOrDefault("$filter")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "$filter", valid_594197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594198: Call_BookmarkRelationsList_594184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all bookmark relations.
  ## 
  let valid = call_594198.validator(path, query, header, formData, body)
  let scheme = call_594198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594198.url(scheme.get, call_594198.host, call_594198.base,
                         call_594198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594198, url, valid)

proc call*(call_594199: Call_BookmarkRelationsList_594184;
          resourceGroupName: string; bookmarkId: string; subscriptionId: string;
          workspaceName: string; operationalInsightsResourceProvider: string;
          Orderby: string = ""; apiVersion: string = "2019-01-01-preview"; Top: int = 0;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## bookmarkRelationsList
  ## Gets all bookmark relations.
  ##   Orderby: string
  ##          : Sorts the results. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Top: int
  ##      : Returns only the first n results. Optional.
  ##   SkipToken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   Filter: string
  ##         : Filters the results, based on a Boolean condition. Optional.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594200 = newJObject()
  var query_594201 = newJObject()
  add(query_594201, "$orderby", newJString(Orderby))
  add(path_594200, "resourceGroupName", newJString(resourceGroupName))
  add(query_594201, "api-version", newJString(apiVersion))
  add(path_594200, "bookmarkId", newJString(bookmarkId))
  add(path_594200, "subscriptionId", newJString(subscriptionId))
  add(query_594201, "$top", newJInt(Top))
  add(query_594201, "$skipToken", newJString(SkipToken))
  add(path_594200, "workspaceName", newJString(workspaceName))
  add(query_594201, "$filter", newJString(Filter))
  add(path_594200, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594199.call(path_594200, query_594201, nil, nil, nil)

var bookmarkRelationsList* = Call_BookmarkRelationsList_594184(
    name: "bookmarkRelationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}/relations",
    validator: validate_BookmarkRelationsList_594185, base: "",
    url: url_BookmarkRelationsList_594186, schemes: {Scheme.Https})
type
  Call_BookmarkRelationsCreateOrUpdateRelation_594216 = ref object of OpenApiRestCall_593438
proc url_BookmarkRelationsCreateOrUpdateRelation_594218(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "bookmarkId" in path, "`bookmarkId` is a required path parameter"
  assert "relationName" in path, "`relationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/bookmarks/"),
               (kind: VariableSegment, value: "bookmarkId"),
               (kind: ConstantSegment, value: "/relations/"),
               (kind: VariableSegment, value: "relationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BookmarkRelationsCreateOrUpdateRelation_594217(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the bookmark relation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   relationName: JString (required)
  ##               : Relation Name
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594219 = path.getOrDefault("resourceGroupName")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "resourceGroupName", valid_594219
  var valid_594220 = path.getOrDefault("bookmarkId")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "bookmarkId", valid_594220
  var valid_594221 = path.getOrDefault("subscriptionId")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "subscriptionId", valid_594221
  var valid_594222 = path.getOrDefault("relationName")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "relationName", valid_594222
  var valid_594223 = path.getOrDefault("workspaceName")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "workspaceName", valid_594223
  var valid_594224 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "operationalInsightsResourceProvider", valid_594224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594225 = query.getOrDefault("api-version")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594225 != nil:
    section.add "api-version", valid_594225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   relationInputModel: JObject (required)
  ##                     : The relation input model
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594227: Call_BookmarkRelationsCreateOrUpdateRelation_594216;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates the bookmark relation.
  ## 
  let valid = call_594227.validator(path, query, header, formData, body)
  let scheme = call_594227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594227.url(scheme.get, call_594227.host, call_594227.base,
                         call_594227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594227, url, valid)

proc call*(call_594228: Call_BookmarkRelationsCreateOrUpdateRelation_594216;
          resourceGroupName: string; bookmarkId: string;
          relationInputModel: JsonNode; subscriptionId: string;
          relationName: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarkRelationsCreateOrUpdateRelation
  ## Creates the bookmark relation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   relationInputModel: JObject (required)
  ##                     : The relation input model
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   relationName: string (required)
  ##               : Relation Name
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594229 = newJObject()
  var query_594230 = newJObject()
  var body_594231 = newJObject()
  add(path_594229, "resourceGroupName", newJString(resourceGroupName))
  add(query_594230, "api-version", newJString(apiVersion))
  add(path_594229, "bookmarkId", newJString(bookmarkId))
  if relationInputModel != nil:
    body_594231 = relationInputModel
  add(path_594229, "subscriptionId", newJString(subscriptionId))
  add(path_594229, "relationName", newJString(relationName))
  add(path_594229, "workspaceName", newJString(workspaceName))
  add(path_594229, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594228.call(path_594229, query_594230, nil, nil, body_594231)

var bookmarkRelationsCreateOrUpdateRelation* = Call_BookmarkRelationsCreateOrUpdateRelation_594216(
    name: "bookmarkRelationsCreateOrUpdateRelation", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}/relations/{relationName}",
    validator: validate_BookmarkRelationsCreateOrUpdateRelation_594217, base: "",
    url: url_BookmarkRelationsCreateOrUpdateRelation_594218,
    schemes: {Scheme.Https})
type
  Call_BookmarkRelationsGetRelation_594202 = ref object of OpenApiRestCall_593438
proc url_BookmarkRelationsGetRelation_594204(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "bookmarkId" in path, "`bookmarkId` is a required path parameter"
  assert "relationName" in path, "`relationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/bookmarks/"),
               (kind: VariableSegment, value: "bookmarkId"),
               (kind: ConstantSegment, value: "/relations/"),
               (kind: VariableSegment, value: "relationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BookmarkRelationsGetRelation_594203(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a bookmark relation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   relationName: JString (required)
  ##               : Relation Name
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594205 = path.getOrDefault("resourceGroupName")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "resourceGroupName", valid_594205
  var valid_594206 = path.getOrDefault("bookmarkId")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "bookmarkId", valid_594206
  var valid_594207 = path.getOrDefault("subscriptionId")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "subscriptionId", valid_594207
  var valid_594208 = path.getOrDefault("relationName")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "relationName", valid_594208
  var valid_594209 = path.getOrDefault("workspaceName")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "workspaceName", valid_594209
  var valid_594210 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "operationalInsightsResourceProvider", valid_594210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594211 = query.getOrDefault("api-version")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594211 != nil:
    section.add "api-version", valid_594211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594212: Call_BookmarkRelationsGetRelation_594202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a bookmark relation.
  ## 
  let valid = call_594212.validator(path, query, header, formData, body)
  let scheme = call_594212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594212.url(scheme.get, call_594212.host, call_594212.base,
                         call_594212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594212, url, valid)

proc call*(call_594213: Call_BookmarkRelationsGetRelation_594202;
          resourceGroupName: string; bookmarkId: string; subscriptionId: string;
          relationName: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarkRelationsGetRelation
  ## Gets a bookmark relation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   relationName: string (required)
  ##               : Relation Name
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594214 = newJObject()
  var query_594215 = newJObject()
  add(path_594214, "resourceGroupName", newJString(resourceGroupName))
  add(query_594215, "api-version", newJString(apiVersion))
  add(path_594214, "bookmarkId", newJString(bookmarkId))
  add(path_594214, "subscriptionId", newJString(subscriptionId))
  add(path_594214, "relationName", newJString(relationName))
  add(path_594214, "workspaceName", newJString(workspaceName))
  add(path_594214, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594213.call(path_594214, query_594215, nil, nil, nil)

var bookmarkRelationsGetRelation* = Call_BookmarkRelationsGetRelation_594202(
    name: "bookmarkRelationsGetRelation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}/relations/{relationName}",
    validator: validate_BookmarkRelationsGetRelation_594203, base: "",
    url: url_BookmarkRelationsGetRelation_594204, schemes: {Scheme.Https})
type
  Call_BookmarkRelationsDeleteRelation_594232 = ref object of OpenApiRestCall_593438
proc url_BookmarkRelationsDeleteRelation_594234(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "bookmarkId" in path, "`bookmarkId` is a required path parameter"
  assert "relationName" in path, "`relationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/bookmarks/"),
               (kind: VariableSegment, value: "bookmarkId"),
               (kind: ConstantSegment, value: "/relations/"),
               (kind: VariableSegment, value: "relationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BookmarkRelationsDeleteRelation_594233(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the bookmark relation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   relationName: JString (required)
  ##               : Relation Name
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594235 = path.getOrDefault("resourceGroupName")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "resourceGroupName", valid_594235
  var valid_594236 = path.getOrDefault("bookmarkId")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "bookmarkId", valid_594236
  var valid_594237 = path.getOrDefault("subscriptionId")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "subscriptionId", valid_594237
  var valid_594238 = path.getOrDefault("relationName")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "relationName", valid_594238
  var valid_594239 = path.getOrDefault("workspaceName")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "workspaceName", valid_594239
  var valid_594240 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "operationalInsightsResourceProvider", valid_594240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594241 = query.getOrDefault("api-version")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594241 != nil:
    section.add "api-version", valid_594241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594242: Call_BookmarkRelationsDeleteRelation_594232;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the bookmark relation.
  ## 
  let valid = call_594242.validator(path, query, header, formData, body)
  let scheme = call_594242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594242.url(scheme.get, call_594242.host, call_594242.base,
                         call_594242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594242, url, valid)

proc call*(call_594243: Call_BookmarkRelationsDeleteRelation_594232;
          resourceGroupName: string; bookmarkId: string; subscriptionId: string;
          relationName: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarkRelationsDeleteRelation
  ## Delete the bookmark relation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   relationName: string (required)
  ##               : Relation Name
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594244 = newJObject()
  var query_594245 = newJObject()
  add(path_594244, "resourceGroupName", newJString(resourceGroupName))
  add(query_594245, "api-version", newJString(apiVersion))
  add(path_594244, "bookmarkId", newJString(bookmarkId))
  add(path_594244, "subscriptionId", newJString(subscriptionId))
  add(path_594244, "relationName", newJString(relationName))
  add(path_594244, "workspaceName", newJString(workspaceName))
  add(path_594244, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594243.call(path_594244, query_594245, nil, nil, nil)

var bookmarkRelationsDeleteRelation* = Call_BookmarkRelationsDeleteRelation_594232(
    name: "bookmarkRelationsDeleteRelation", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}/relations/{relationName}",
    validator: validate_BookmarkRelationsDeleteRelation_594233, base: "",
    url: url_BookmarkRelationsDeleteRelation_594234, schemes: {Scheme.Https})
type
  Call_CasesList_594246 = ref object of OpenApiRestCall_593438
proc url_CasesList_594248(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CasesList_594247(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all cases.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594249 = path.getOrDefault("resourceGroupName")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "resourceGroupName", valid_594249
  var valid_594250 = path.getOrDefault("subscriptionId")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "subscriptionId", valid_594250
  var valid_594251 = path.getOrDefault("workspaceName")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "workspaceName", valid_594251
  var valid_594252 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "operationalInsightsResourceProvider", valid_594252
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Sorts the results. Optional.
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $top: JInt
  ##       : Returns only the first n results. Optional.
  ##   $skipToken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   $filter: JString
  ##          : Filters the results, based on a Boolean condition. Optional.
  section = newJObject()
  var valid_594253 = query.getOrDefault("$orderby")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = nil)
  if valid_594253 != nil:
    section.add "$orderby", valid_594253
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594254 = query.getOrDefault("api-version")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594254 != nil:
    section.add "api-version", valid_594254
  var valid_594255 = query.getOrDefault("$top")
  valid_594255 = validateParameter(valid_594255, JInt, required = false, default = nil)
  if valid_594255 != nil:
    section.add "$top", valid_594255
  var valid_594256 = query.getOrDefault("$skipToken")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "$skipToken", valid_594256
  var valid_594257 = query.getOrDefault("$filter")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = nil)
  if valid_594257 != nil:
    section.add "$filter", valid_594257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594258: Call_CasesList_594246; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all cases.
  ## 
  let valid = call_594258.validator(path, query, header, formData, body)
  let scheme = call_594258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594258.url(scheme.get, call_594258.host, call_594258.base,
                         call_594258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594258, url, valid)

proc call*(call_594259: Call_CasesList_594246; resourceGroupName: string;
          subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string; Orderby: string = "";
          apiVersion: string = "2019-01-01-preview"; Top: int = 0;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## casesList
  ## Gets all cases.
  ##   Orderby: string
  ##          : Sorts the results. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Top: int
  ##      : Returns only the first n results. Optional.
  ##   SkipToken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   Filter: string
  ##         : Filters the results, based on a Boolean condition. Optional.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594260 = newJObject()
  var query_594261 = newJObject()
  add(query_594261, "$orderby", newJString(Orderby))
  add(path_594260, "resourceGroupName", newJString(resourceGroupName))
  add(query_594261, "api-version", newJString(apiVersion))
  add(path_594260, "subscriptionId", newJString(subscriptionId))
  add(query_594261, "$top", newJInt(Top))
  add(query_594261, "$skipToken", newJString(SkipToken))
  add(path_594260, "workspaceName", newJString(workspaceName))
  add(query_594261, "$filter", newJString(Filter))
  add(path_594260, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594259.call(path_594260, query_594261, nil, nil, nil)

var casesList* = Call_CasesList_594246(name: "casesList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases",
                                    validator: validate_CasesList_594247,
                                    base: "", url: url_CasesList_594248,
                                    schemes: {Scheme.Https})
type
  Call_CasesCreateOrUpdate_594275 = ref object of OpenApiRestCall_593438
proc url_CasesCreateOrUpdate_594277(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "caseId" in path, "`caseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases/"),
               (kind: VariableSegment, value: "caseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CasesCreateOrUpdate_594276(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates or updates the case.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594278 = path.getOrDefault("resourceGroupName")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "resourceGroupName", valid_594278
  var valid_594279 = path.getOrDefault("caseId")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "caseId", valid_594279
  var valid_594280 = path.getOrDefault("subscriptionId")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "subscriptionId", valid_594280
  var valid_594281 = path.getOrDefault("workspaceName")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "workspaceName", valid_594281
  var valid_594282 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "operationalInsightsResourceProvider", valid_594282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594283 = query.getOrDefault("api-version")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594283 != nil:
    section.add "api-version", valid_594283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   case: JObject (required)
  ##       : The case
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594285: Call_CasesCreateOrUpdate_594275; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the case.
  ## 
  let valid = call_594285.validator(path, query, header, formData, body)
  let scheme = call_594285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594285.url(scheme.get, call_594285.host, call_594285.base,
                         call_594285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594285, url, valid)

proc call*(call_594286: Call_CasesCreateOrUpdate_594275; resourceGroupName: string;
          `case`: JsonNode; caseId: string; subscriptionId: string;
          workspaceName: string; operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## casesCreateOrUpdate
  ## Creates or updates the case.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   case: JObject (required)
  ##       : The case
  ##   caseId: string (required)
  ##         : Case ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594287 = newJObject()
  var query_594288 = newJObject()
  var body_594289 = newJObject()
  add(path_594287, "resourceGroupName", newJString(resourceGroupName))
  add(query_594288, "api-version", newJString(apiVersion))
  if `case` != nil:
    body_594289 = `case`
  add(path_594287, "caseId", newJString(caseId))
  add(path_594287, "subscriptionId", newJString(subscriptionId))
  add(path_594287, "workspaceName", newJString(workspaceName))
  add(path_594287, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594286.call(path_594287, query_594288, nil, nil, body_594289)

var casesCreateOrUpdate* = Call_CasesCreateOrUpdate_594275(
    name: "casesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}",
    validator: validate_CasesCreateOrUpdate_594276, base: "",
    url: url_CasesCreateOrUpdate_594277, schemes: {Scheme.Https})
type
  Call_CasesGet_594262 = ref object of OpenApiRestCall_593438
proc url_CasesGet_594264(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "caseId" in path, "`caseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases/"),
               (kind: VariableSegment, value: "caseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CasesGet_594263(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a case.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594265 = path.getOrDefault("resourceGroupName")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "resourceGroupName", valid_594265
  var valid_594266 = path.getOrDefault("caseId")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "caseId", valid_594266
  var valid_594267 = path.getOrDefault("subscriptionId")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "subscriptionId", valid_594267
  var valid_594268 = path.getOrDefault("workspaceName")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "workspaceName", valid_594268
  var valid_594269 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "operationalInsightsResourceProvider", valid_594269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594270 = query.getOrDefault("api-version")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594270 != nil:
    section.add "api-version", valid_594270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594271: Call_CasesGet_594262; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a case.
  ## 
  let valid = call_594271.validator(path, query, header, formData, body)
  let scheme = call_594271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594271.url(scheme.get, call_594271.host, call_594271.base,
                         call_594271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594271, url, valid)

proc call*(call_594272: Call_CasesGet_594262; resourceGroupName: string;
          caseId: string; subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## casesGet
  ## Gets a case.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   caseId: string (required)
  ##         : Case ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594273 = newJObject()
  var query_594274 = newJObject()
  add(path_594273, "resourceGroupName", newJString(resourceGroupName))
  add(query_594274, "api-version", newJString(apiVersion))
  add(path_594273, "caseId", newJString(caseId))
  add(path_594273, "subscriptionId", newJString(subscriptionId))
  add(path_594273, "workspaceName", newJString(workspaceName))
  add(path_594273, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594272.call(path_594273, query_594274, nil, nil, nil)

var casesGet* = Call_CasesGet_594262(name: "casesGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}",
                                  validator: validate_CasesGet_594263, base: "",
                                  url: url_CasesGet_594264,
                                  schemes: {Scheme.Https})
type
  Call_CasesDelete_594290 = ref object of OpenApiRestCall_593438
proc url_CasesDelete_594292(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "caseId" in path, "`caseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases/"),
               (kind: VariableSegment, value: "caseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CasesDelete_594291(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the case.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594293 = path.getOrDefault("resourceGroupName")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "resourceGroupName", valid_594293
  var valid_594294 = path.getOrDefault("caseId")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "caseId", valid_594294
  var valid_594295 = path.getOrDefault("subscriptionId")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = nil)
  if valid_594295 != nil:
    section.add "subscriptionId", valid_594295
  var valid_594296 = path.getOrDefault("workspaceName")
  valid_594296 = validateParameter(valid_594296, JString, required = true,
                                 default = nil)
  if valid_594296 != nil:
    section.add "workspaceName", valid_594296
  var valid_594297 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594297 = validateParameter(valid_594297, JString, required = true,
                                 default = nil)
  if valid_594297 != nil:
    section.add "operationalInsightsResourceProvider", valid_594297
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594298 = query.getOrDefault("api-version")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594298 != nil:
    section.add "api-version", valid_594298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594299: Call_CasesDelete_594290; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the case.
  ## 
  let valid = call_594299.validator(path, query, header, formData, body)
  let scheme = call_594299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594299.url(scheme.get, call_594299.host, call_594299.base,
                         call_594299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594299, url, valid)

proc call*(call_594300: Call_CasesDelete_594290; resourceGroupName: string;
          caseId: string; subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## casesDelete
  ## Delete the case.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   caseId: string (required)
  ##         : Case ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594301 = newJObject()
  var query_594302 = newJObject()
  add(path_594301, "resourceGroupName", newJString(resourceGroupName))
  add(query_594302, "api-version", newJString(apiVersion))
  add(path_594301, "caseId", newJString(caseId))
  add(path_594301, "subscriptionId", newJString(subscriptionId))
  add(path_594301, "workspaceName", newJString(workspaceName))
  add(path_594301, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594300.call(path_594301, query_594302, nil, nil, nil)

var casesDelete* = Call_CasesDelete_594290(name: "casesDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}",
                                        validator: validate_CasesDelete_594291,
                                        base: "", url: url_CasesDelete_594292,
                                        schemes: {Scheme.Https})
type
  Call_CommentsListByCase_594303 = ref object of OpenApiRestCall_593438
proc url_CommentsListByCase_594305(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "caseId" in path, "`caseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases/"),
               (kind: VariableSegment, value: "caseId"),
               (kind: ConstantSegment, value: "/comments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CommentsListByCase_594304(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets all case comments.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594306 = path.getOrDefault("resourceGroupName")
  valid_594306 = validateParameter(valid_594306, JString, required = true,
                                 default = nil)
  if valid_594306 != nil:
    section.add "resourceGroupName", valid_594306
  var valid_594307 = path.getOrDefault("caseId")
  valid_594307 = validateParameter(valid_594307, JString, required = true,
                                 default = nil)
  if valid_594307 != nil:
    section.add "caseId", valid_594307
  var valid_594308 = path.getOrDefault("subscriptionId")
  valid_594308 = validateParameter(valid_594308, JString, required = true,
                                 default = nil)
  if valid_594308 != nil:
    section.add "subscriptionId", valid_594308
  var valid_594309 = path.getOrDefault("workspaceName")
  valid_594309 = validateParameter(valid_594309, JString, required = true,
                                 default = nil)
  if valid_594309 != nil:
    section.add "workspaceName", valid_594309
  var valid_594310 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594310 = validateParameter(valid_594310, JString, required = true,
                                 default = nil)
  if valid_594310 != nil:
    section.add "operationalInsightsResourceProvider", valid_594310
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Sorts the results. Optional.
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $top: JInt
  ##       : Returns only the first n results. Optional.
  ##   $skipToken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   $filter: JString
  ##          : Filters the results, based on a Boolean condition. Optional.
  section = newJObject()
  var valid_594311 = query.getOrDefault("$orderby")
  valid_594311 = validateParameter(valid_594311, JString, required = false,
                                 default = nil)
  if valid_594311 != nil:
    section.add "$orderby", valid_594311
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594312 = query.getOrDefault("api-version")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594312 != nil:
    section.add "api-version", valid_594312
  var valid_594313 = query.getOrDefault("$top")
  valid_594313 = validateParameter(valid_594313, JInt, required = false, default = nil)
  if valid_594313 != nil:
    section.add "$top", valid_594313
  var valid_594314 = query.getOrDefault("$skipToken")
  valid_594314 = validateParameter(valid_594314, JString, required = false,
                                 default = nil)
  if valid_594314 != nil:
    section.add "$skipToken", valid_594314
  var valid_594315 = query.getOrDefault("$filter")
  valid_594315 = validateParameter(valid_594315, JString, required = false,
                                 default = nil)
  if valid_594315 != nil:
    section.add "$filter", valid_594315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594316: Call_CommentsListByCase_594303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all case comments.
  ## 
  let valid = call_594316.validator(path, query, header, formData, body)
  let scheme = call_594316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594316.url(scheme.get, call_594316.host, call_594316.base,
                         call_594316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594316, url, valid)

proc call*(call_594317: Call_CommentsListByCase_594303; resourceGroupName: string;
          caseId: string; subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string; Orderby: string = "";
          apiVersion: string = "2019-01-01-preview"; Top: int = 0;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## commentsListByCase
  ## Gets all case comments.
  ##   Orderby: string
  ##          : Sorts the results. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   caseId: string (required)
  ##         : Case ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Top: int
  ##      : Returns only the first n results. Optional.
  ##   SkipToken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   Filter: string
  ##         : Filters the results, based on a Boolean condition. Optional.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594318 = newJObject()
  var query_594319 = newJObject()
  add(query_594319, "$orderby", newJString(Orderby))
  add(path_594318, "resourceGroupName", newJString(resourceGroupName))
  add(query_594319, "api-version", newJString(apiVersion))
  add(path_594318, "caseId", newJString(caseId))
  add(path_594318, "subscriptionId", newJString(subscriptionId))
  add(query_594319, "$top", newJInt(Top))
  add(query_594319, "$skipToken", newJString(SkipToken))
  add(path_594318, "workspaceName", newJString(workspaceName))
  add(query_594319, "$filter", newJString(Filter))
  add(path_594318, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594317.call(path_594318, query_594319, nil, nil, nil)

var commentsListByCase* = Call_CommentsListByCase_594303(
    name: "commentsListByCase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/comments",
    validator: validate_CommentsListByCase_594304, base: "",
    url: url_CommentsListByCase_594305, schemes: {Scheme.Https})
type
  Call_CaseCommentsCreateComment_594334 = ref object of OpenApiRestCall_593438
proc url_CaseCommentsCreateComment_594336(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "caseId" in path, "`caseId` is a required path parameter"
  assert "caseCommentId" in path, "`caseCommentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases/"),
               (kind: VariableSegment, value: "caseId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "caseCommentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CaseCommentsCreateComment_594335(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the case comment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseCommentId: JString (required)
  ##                : Case comment ID
  ##   caseId: JString (required)
  ##         : Case ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594337 = path.getOrDefault("resourceGroupName")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "resourceGroupName", valid_594337
  var valid_594338 = path.getOrDefault("caseCommentId")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "caseCommentId", valid_594338
  var valid_594339 = path.getOrDefault("caseId")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "caseId", valid_594339
  var valid_594340 = path.getOrDefault("subscriptionId")
  valid_594340 = validateParameter(valid_594340, JString, required = true,
                                 default = nil)
  if valid_594340 != nil:
    section.add "subscriptionId", valid_594340
  var valid_594341 = path.getOrDefault("workspaceName")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "workspaceName", valid_594341
  var valid_594342 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "operationalInsightsResourceProvider", valid_594342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594343 = query.getOrDefault("api-version")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594343 != nil:
    section.add "api-version", valid_594343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   caseComment: JObject (required)
  ##              : The case comment
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594345: Call_CaseCommentsCreateComment_594334; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the case comment.
  ## 
  let valid = call_594345.validator(path, query, header, formData, body)
  let scheme = call_594345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594345.url(scheme.get, call_594345.host, call_594345.base,
                         call_594345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594345, url, valid)

proc call*(call_594346: Call_CaseCommentsCreateComment_594334;
          resourceGroupName: string; caseCommentId: string; caseId: string;
          subscriptionId: string; caseComment: JsonNode; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## caseCommentsCreateComment
  ## Creates the case comment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   caseCommentId: string (required)
  ##                : Case comment ID
  ##   caseId: string (required)
  ##         : Case ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   caseComment: JObject (required)
  ##              : The case comment
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594347 = newJObject()
  var query_594348 = newJObject()
  var body_594349 = newJObject()
  add(path_594347, "resourceGroupName", newJString(resourceGroupName))
  add(query_594348, "api-version", newJString(apiVersion))
  add(path_594347, "caseCommentId", newJString(caseCommentId))
  add(path_594347, "caseId", newJString(caseId))
  add(path_594347, "subscriptionId", newJString(subscriptionId))
  if caseComment != nil:
    body_594349 = caseComment
  add(path_594347, "workspaceName", newJString(workspaceName))
  add(path_594347, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594346.call(path_594347, query_594348, nil, nil, body_594349)

var caseCommentsCreateComment* = Call_CaseCommentsCreateComment_594334(
    name: "caseCommentsCreateComment", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/comments/{caseCommentId}",
    validator: validate_CaseCommentsCreateComment_594335, base: "",
    url: url_CaseCommentsCreateComment_594336, schemes: {Scheme.Https})
type
  Call_CasesGetComment_594320 = ref object of OpenApiRestCall_593438
proc url_CasesGetComment_594322(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "caseId" in path, "`caseId` is a required path parameter"
  assert "caseCommentId" in path, "`caseCommentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases/"),
               (kind: VariableSegment, value: "caseId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "caseCommentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CasesGetComment_594321(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a case comment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseCommentId: JString (required)
  ##                : Case comment ID
  ##   caseId: JString (required)
  ##         : Case ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594323 = path.getOrDefault("resourceGroupName")
  valid_594323 = validateParameter(valid_594323, JString, required = true,
                                 default = nil)
  if valid_594323 != nil:
    section.add "resourceGroupName", valid_594323
  var valid_594324 = path.getOrDefault("caseCommentId")
  valid_594324 = validateParameter(valid_594324, JString, required = true,
                                 default = nil)
  if valid_594324 != nil:
    section.add "caseCommentId", valid_594324
  var valid_594325 = path.getOrDefault("caseId")
  valid_594325 = validateParameter(valid_594325, JString, required = true,
                                 default = nil)
  if valid_594325 != nil:
    section.add "caseId", valid_594325
  var valid_594326 = path.getOrDefault("subscriptionId")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "subscriptionId", valid_594326
  var valid_594327 = path.getOrDefault("workspaceName")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "workspaceName", valid_594327
  var valid_594328 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "operationalInsightsResourceProvider", valid_594328
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594329 = query.getOrDefault("api-version")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594329 != nil:
    section.add "api-version", valid_594329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594330: Call_CasesGetComment_594320; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a case comment.
  ## 
  let valid = call_594330.validator(path, query, header, formData, body)
  let scheme = call_594330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594330.url(scheme.get, call_594330.host, call_594330.base,
                         call_594330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594330, url, valid)

proc call*(call_594331: Call_CasesGetComment_594320; resourceGroupName: string;
          caseCommentId: string; caseId: string; subscriptionId: string;
          workspaceName: string; operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## casesGetComment
  ## Gets a case comment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   caseCommentId: string (required)
  ##                : Case comment ID
  ##   caseId: string (required)
  ##         : Case ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594332 = newJObject()
  var query_594333 = newJObject()
  add(path_594332, "resourceGroupName", newJString(resourceGroupName))
  add(query_594333, "api-version", newJString(apiVersion))
  add(path_594332, "caseCommentId", newJString(caseCommentId))
  add(path_594332, "caseId", newJString(caseId))
  add(path_594332, "subscriptionId", newJString(subscriptionId))
  add(path_594332, "workspaceName", newJString(workspaceName))
  add(path_594332, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594331.call(path_594332, query_594333, nil, nil, nil)

var casesGetComment* = Call_CasesGetComment_594320(name: "casesGetComment",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/comments/{caseCommentId}",
    validator: validate_CasesGetComment_594321, base: "", url: url_CasesGetComment_594322,
    schemes: {Scheme.Https})
type
  Call_CaseRelationsList_594350 = ref object of OpenApiRestCall_593438
proc url_CaseRelationsList_594352(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "caseId" in path, "`caseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases/"),
               (kind: VariableSegment, value: "caseId"),
               (kind: ConstantSegment, value: "/relations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CaseRelationsList_594351(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets all case relations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594353 = path.getOrDefault("resourceGroupName")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "resourceGroupName", valid_594353
  var valid_594354 = path.getOrDefault("caseId")
  valid_594354 = validateParameter(valid_594354, JString, required = true,
                                 default = nil)
  if valid_594354 != nil:
    section.add "caseId", valid_594354
  var valid_594355 = path.getOrDefault("subscriptionId")
  valid_594355 = validateParameter(valid_594355, JString, required = true,
                                 default = nil)
  if valid_594355 != nil:
    section.add "subscriptionId", valid_594355
  var valid_594356 = path.getOrDefault("workspaceName")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "workspaceName", valid_594356
  var valid_594357 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "operationalInsightsResourceProvider", valid_594357
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Sorts the results. Optional.
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $top: JInt
  ##       : Returns only the first n results. Optional.
  ##   $skipToken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   $filter: JString
  ##          : Filters the results, based on a Boolean condition. Optional.
  section = newJObject()
  var valid_594358 = query.getOrDefault("$orderby")
  valid_594358 = validateParameter(valid_594358, JString, required = false,
                                 default = nil)
  if valid_594358 != nil:
    section.add "$orderby", valid_594358
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594359 = query.getOrDefault("api-version")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594359 != nil:
    section.add "api-version", valid_594359
  var valid_594360 = query.getOrDefault("$top")
  valid_594360 = validateParameter(valid_594360, JInt, required = false, default = nil)
  if valid_594360 != nil:
    section.add "$top", valid_594360
  var valid_594361 = query.getOrDefault("$skipToken")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "$skipToken", valid_594361
  var valid_594362 = query.getOrDefault("$filter")
  valid_594362 = validateParameter(valid_594362, JString, required = false,
                                 default = nil)
  if valid_594362 != nil:
    section.add "$filter", valid_594362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594363: Call_CaseRelationsList_594350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all case relations.
  ## 
  let valid = call_594363.validator(path, query, header, formData, body)
  let scheme = call_594363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594363.url(scheme.get, call_594363.host, call_594363.base,
                         call_594363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594363, url, valid)

proc call*(call_594364: Call_CaseRelationsList_594350; resourceGroupName: string;
          caseId: string; subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string; Orderby: string = "";
          apiVersion: string = "2019-01-01-preview"; Top: int = 0;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## caseRelationsList
  ## Gets all case relations.
  ##   Orderby: string
  ##          : Sorts the results. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   caseId: string (required)
  ##         : Case ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Top: int
  ##      : Returns only the first n results. Optional.
  ##   SkipToken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   Filter: string
  ##         : Filters the results, based on a Boolean condition. Optional.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594365 = newJObject()
  var query_594366 = newJObject()
  add(query_594366, "$orderby", newJString(Orderby))
  add(path_594365, "resourceGroupName", newJString(resourceGroupName))
  add(query_594366, "api-version", newJString(apiVersion))
  add(path_594365, "caseId", newJString(caseId))
  add(path_594365, "subscriptionId", newJString(subscriptionId))
  add(query_594366, "$top", newJInt(Top))
  add(query_594366, "$skipToken", newJString(SkipToken))
  add(path_594365, "workspaceName", newJString(workspaceName))
  add(query_594366, "$filter", newJString(Filter))
  add(path_594365, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594364.call(path_594365, query_594366, nil, nil, nil)

var caseRelationsList* = Call_CaseRelationsList_594350(name: "caseRelationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/relations",
    validator: validate_CaseRelationsList_594351, base: "",
    url: url_CaseRelationsList_594352, schemes: {Scheme.Https})
type
  Call_CaseRelationsCreateOrUpdateRelation_594381 = ref object of OpenApiRestCall_593438
proc url_CaseRelationsCreateOrUpdateRelation_594383(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "caseId" in path, "`caseId` is a required path parameter"
  assert "relationName" in path, "`relationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases/"),
               (kind: VariableSegment, value: "caseId"),
               (kind: ConstantSegment, value: "/relations/"),
               (kind: VariableSegment, value: "relationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CaseRelationsCreateOrUpdateRelation_594382(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the case relation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   relationName: JString (required)
  ##               : Relation Name
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594384 = path.getOrDefault("resourceGroupName")
  valid_594384 = validateParameter(valid_594384, JString, required = true,
                                 default = nil)
  if valid_594384 != nil:
    section.add "resourceGroupName", valid_594384
  var valid_594385 = path.getOrDefault("caseId")
  valid_594385 = validateParameter(valid_594385, JString, required = true,
                                 default = nil)
  if valid_594385 != nil:
    section.add "caseId", valid_594385
  var valid_594386 = path.getOrDefault("subscriptionId")
  valid_594386 = validateParameter(valid_594386, JString, required = true,
                                 default = nil)
  if valid_594386 != nil:
    section.add "subscriptionId", valid_594386
  var valid_594387 = path.getOrDefault("relationName")
  valid_594387 = validateParameter(valid_594387, JString, required = true,
                                 default = nil)
  if valid_594387 != nil:
    section.add "relationName", valid_594387
  var valid_594388 = path.getOrDefault("workspaceName")
  valid_594388 = validateParameter(valid_594388, JString, required = true,
                                 default = nil)
  if valid_594388 != nil:
    section.add "workspaceName", valid_594388
  var valid_594389 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "operationalInsightsResourceProvider", valid_594389
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594390 = query.getOrDefault("api-version")
  valid_594390 = validateParameter(valid_594390, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594390 != nil:
    section.add "api-version", valid_594390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   relationInputModel: JObject (required)
  ##                     : The relation input model
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594392: Call_CaseRelationsCreateOrUpdateRelation_594381;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the case relation.
  ## 
  let valid = call_594392.validator(path, query, header, formData, body)
  let scheme = call_594392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594392.url(scheme.get, call_594392.host, call_594392.base,
                         call_594392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594392, url, valid)

proc call*(call_594393: Call_CaseRelationsCreateOrUpdateRelation_594381;
          resourceGroupName: string; caseId: string; relationInputModel: JsonNode;
          subscriptionId: string; relationName: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## caseRelationsCreateOrUpdateRelation
  ## Creates or updates the case relation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   caseId: string (required)
  ##         : Case ID
  ##   relationInputModel: JObject (required)
  ##                     : The relation input model
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   relationName: string (required)
  ##               : Relation Name
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594394 = newJObject()
  var query_594395 = newJObject()
  var body_594396 = newJObject()
  add(path_594394, "resourceGroupName", newJString(resourceGroupName))
  add(query_594395, "api-version", newJString(apiVersion))
  add(path_594394, "caseId", newJString(caseId))
  if relationInputModel != nil:
    body_594396 = relationInputModel
  add(path_594394, "subscriptionId", newJString(subscriptionId))
  add(path_594394, "relationName", newJString(relationName))
  add(path_594394, "workspaceName", newJString(workspaceName))
  add(path_594394, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594393.call(path_594394, query_594395, nil, nil, body_594396)

var caseRelationsCreateOrUpdateRelation* = Call_CaseRelationsCreateOrUpdateRelation_594381(
    name: "caseRelationsCreateOrUpdateRelation", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/relations/{relationName}",
    validator: validate_CaseRelationsCreateOrUpdateRelation_594382, base: "",
    url: url_CaseRelationsCreateOrUpdateRelation_594383, schemes: {Scheme.Https})
type
  Call_CaseRelationsGetRelation_594367 = ref object of OpenApiRestCall_593438
proc url_CaseRelationsGetRelation_594369(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "caseId" in path, "`caseId` is a required path parameter"
  assert "relationName" in path, "`relationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases/"),
               (kind: VariableSegment, value: "caseId"),
               (kind: ConstantSegment, value: "/relations/"),
               (kind: VariableSegment, value: "relationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CaseRelationsGetRelation_594368(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a case relation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   relationName: JString (required)
  ##               : Relation Name
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594370 = path.getOrDefault("resourceGroupName")
  valid_594370 = validateParameter(valid_594370, JString, required = true,
                                 default = nil)
  if valid_594370 != nil:
    section.add "resourceGroupName", valid_594370
  var valid_594371 = path.getOrDefault("caseId")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "caseId", valid_594371
  var valid_594372 = path.getOrDefault("subscriptionId")
  valid_594372 = validateParameter(valid_594372, JString, required = true,
                                 default = nil)
  if valid_594372 != nil:
    section.add "subscriptionId", valid_594372
  var valid_594373 = path.getOrDefault("relationName")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "relationName", valid_594373
  var valid_594374 = path.getOrDefault("workspaceName")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = nil)
  if valid_594374 != nil:
    section.add "workspaceName", valid_594374
  var valid_594375 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "operationalInsightsResourceProvider", valid_594375
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594376 = query.getOrDefault("api-version")
  valid_594376 = validateParameter(valid_594376, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594376 != nil:
    section.add "api-version", valid_594376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594377: Call_CaseRelationsGetRelation_594367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a case relation.
  ## 
  let valid = call_594377.validator(path, query, header, formData, body)
  let scheme = call_594377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594377.url(scheme.get, call_594377.host, call_594377.base,
                         call_594377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594377, url, valid)

proc call*(call_594378: Call_CaseRelationsGetRelation_594367;
          resourceGroupName: string; caseId: string; subscriptionId: string;
          relationName: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## caseRelationsGetRelation
  ## Gets a case relation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   caseId: string (required)
  ##         : Case ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   relationName: string (required)
  ##               : Relation Name
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594379 = newJObject()
  var query_594380 = newJObject()
  add(path_594379, "resourceGroupName", newJString(resourceGroupName))
  add(query_594380, "api-version", newJString(apiVersion))
  add(path_594379, "caseId", newJString(caseId))
  add(path_594379, "subscriptionId", newJString(subscriptionId))
  add(path_594379, "relationName", newJString(relationName))
  add(path_594379, "workspaceName", newJString(workspaceName))
  add(path_594379, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594378.call(path_594379, query_594380, nil, nil, nil)

var caseRelationsGetRelation* = Call_CaseRelationsGetRelation_594367(
    name: "caseRelationsGetRelation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/relations/{relationName}",
    validator: validate_CaseRelationsGetRelation_594368, base: "",
    url: url_CaseRelationsGetRelation_594369, schemes: {Scheme.Https})
type
  Call_CaseRelationsDeleteRelation_594397 = ref object of OpenApiRestCall_593438
proc url_CaseRelationsDeleteRelation_594399(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "caseId" in path, "`caseId` is a required path parameter"
  assert "relationName" in path, "`relationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases/"),
               (kind: VariableSegment, value: "caseId"),
               (kind: ConstantSegment, value: "/relations/"),
               (kind: VariableSegment, value: "relationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CaseRelationsDeleteRelation_594398(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the case relation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   relationName: JString (required)
  ##               : Relation Name
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594400 = path.getOrDefault("resourceGroupName")
  valid_594400 = validateParameter(valid_594400, JString, required = true,
                                 default = nil)
  if valid_594400 != nil:
    section.add "resourceGroupName", valid_594400
  var valid_594401 = path.getOrDefault("caseId")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = nil)
  if valid_594401 != nil:
    section.add "caseId", valid_594401
  var valid_594402 = path.getOrDefault("subscriptionId")
  valid_594402 = validateParameter(valid_594402, JString, required = true,
                                 default = nil)
  if valid_594402 != nil:
    section.add "subscriptionId", valid_594402
  var valid_594403 = path.getOrDefault("relationName")
  valid_594403 = validateParameter(valid_594403, JString, required = true,
                                 default = nil)
  if valid_594403 != nil:
    section.add "relationName", valid_594403
  var valid_594404 = path.getOrDefault("workspaceName")
  valid_594404 = validateParameter(valid_594404, JString, required = true,
                                 default = nil)
  if valid_594404 != nil:
    section.add "workspaceName", valid_594404
  var valid_594405 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594405 = validateParameter(valid_594405, JString, required = true,
                                 default = nil)
  if valid_594405 != nil:
    section.add "operationalInsightsResourceProvider", valid_594405
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594406 = query.getOrDefault("api-version")
  valid_594406 = validateParameter(valid_594406, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594406 != nil:
    section.add "api-version", valid_594406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594407: Call_CaseRelationsDeleteRelation_594397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the case relation.
  ## 
  let valid = call_594407.validator(path, query, header, formData, body)
  let scheme = call_594407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594407.url(scheme.get, call_594407.host, call_594407.base,
                         call_594407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594407, url, valid)

proc call*(call_594408: Call_CaseRelationsDeleteRelation_594397;
          resourceGroupName: string; caseId: string; subscriptionId: string;
          relationName: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## caseRelationsDeleteRelation
  ## Delete the case relation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   caseId: string (required)
  ##         : Case ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   relationName: string (required)
  ##               : Relation Name
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594409 = newJObject()
  var query_594410 = newJObject()
  add(path_594409, "resourceGroupName", newJString(resourceGroupName))
  add(query_594410, "api-version", newJString(apiVersion))
  add(path_594409, "caseId", newJString(caseId))
  add(path_594409, "subscriptionId", newJString(subscriptionId))
  add(path_594409, "relationName", newJString(relationName))
  add(path_594409, "workspaceName", newJString(workspaceName))
  add(path_594409, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594408.call(path_594409, query_594410, nil, nil, nil)

var caseRelationsDeleteRelation* = Call_CaseRelationsDeleteRelation_594397(
    name: "caseRelationsDeleteRelation", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/relations/{relationName}",
    validator: validate_CaseRelationsDeleteRelation_594398, base: "",
    url: url_CaseRelationsDeleteRelation_594399, schemes: {Scheme.Https})
type
  Call_DataConnectorsList_594411 = ref object of OpenApiRestCall_593438
proc url_DataConnectorsList_594413(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/dataConnectors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataConnectorsList_594412(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets all data connectors.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594414 = path.getOrDefault("resourceGroupName")
  valid_594414 = validateParameter(valid_594414, JString, required = true,
                                 default = nil)
  if valid_594414 != nil:
    section.add "resourceGroupName", valid_594414
  var valid_594415 = path.getOrDefault("subscriptionId")
  valid_594415 = validateParameter(valid_594415, JString, required = true,
                                 default = nil)
  if valid_594415 != nil:
    section.add "subscriptionId", valid_594415
  var valid_594416 = path.getOrDefault("workspaceName")
  valid_594416 = validateParameter(valid_594416, JString, required = true,
                                 default = nil)
  if valid_594416 != nil:
    section.add "workspaceName", valid_594416
  var valid_594417 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594417 = validateParameter(valid_594417, JString, required = true,
                                 default = nil)
  if valid_594417 != nil:
    section.add "operationalInsightsResourceProvider", valid_594417
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594418 = query.getOrDefault("api-version")
  valid_594418 = validateParameter(valid_594418, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594418 != nil:
    section.add "api-version", valid_594418
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594419: Call_DataConnectorsList_594411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all data connectors.
  ## 
  let valid = call_594419.validator(path, query, header, formData, body)
  let scheme = call_594419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594419.url(scheme.get, call_594419.host, call_594419.base,
                         call_594419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594419, url, valid)

proc call*(call_594420: Call_DataConnectorsList_594411; resourceGroupName: string;
          subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## dataConnectorsList
  ## Gets all data connectors.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594421 = newJObject()
  var query_594422 = newJObject()
  add(path_594421, "resourceGroupName", newJString(resourceGroupName))
  add(query_594422, "api-version", newJString(apiVersion))
  add(path_594421, "subscriptionId", newJString(subscriptionId))
  add(path_594421, "workspaceName", newJString(workspaceName))
  add(path_594421, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594420.call(path_594421, query_594422, nil, nil, nil)

var dataConnectorsList* = Call_DataConnectorsList_594411(
    name: "dataConnectorsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/dataConnectors",
    validator: validate_DataConnectorsList_594412, base: "",
    url: url_DataConnectorsList_594413, schemes: {Scheme.Https})
type
  Call_DataConnectorsCreateOrUpdate_594436 = ref object of OpenApiRestCall_593438
proc url_DataConnectorsCreateOrUpdate_594438(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "dataConnectorId" in path, "`dataConnectorId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/dataConnectors/"),
               (kind: VariableSegment, value: "dataConnectorId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataConnectorsCreateOrUpdate_594437(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the data connector.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   dataConnectorId: JString (required)
  ##                  : Connector ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594439 = path.getOrDefault("resourceGroupName")
  valid_594439 = validateParameter(valid_594439, JString, required = true,
                                 default = nil)
  if valid_594439 != nil:
    section.add "resourceGroupName", valid_594439
  var valid_594440 = path.getOrDefault("subscriptionId")
  valid_594440 = validateParameter(valid_594440, JString, required = true,
                                 default = nil)
  if valid_594440 != nil:
    section.add "subscriptionId", valid_594440
  var valid_594441 = path.getOrDefault("workspaceName")
  valid_594441 = validateParameter(valid_594441, JString, required = true,
                                 default = nil)
  if valid_594441 != nil:
    section.add "workspaceName", valid_594441
  var valid_594442 = path.getOrDefault("dataConnectorId")
  valid_594442 = validateParameter(valid_594442, JString, required = true,
                                 default = nil)
  if valid_594442 != nil:
    section.add "dataConnectorId", valid_594442
  var valid_594443 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594443 = validateParameter(valid_594443, JString, required = true,
                                 default = nil)
  if valid_594443 != nil:
    section.add "operationalInsightsResourceProvider", valid_594443
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594444 = query.getOrDefault("api-version")
  valid_594444 = validateParameter(valid_594444, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594444 != nil:
    section.add "api-version", valid_594444
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dataConnector: JObject (required)
  ##                : The data connector
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594446: Call_DataConnectorsCreateOrUpdate_594436; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the data connector.
  ## 
  let valid = call_594446.validator(path, query, header, formData, body)
  let scheme = call_594446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594446.url(scheme.get, call_594446.host, call_594446.base,
                         call_594446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594446, url, valid)

proc call*(call_594447: Call_DataConnectorsCreateOrUpdate_594436;
          resourceGroupName: string; subscriptionId: string;
          dataConnector: JsonNode; workspaceName: string; dataConnectorId: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## dataConnectorsCreateOrUpdate
  ## Creates or updates the data connector.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   dataConnector: JObject (required)
  ##                : The data connector
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   dataConnectorId: string (required)
  ##                  : Connector ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594448 = newJObject()
  var query_594449 = newJObject()
  var body_594450 = newJObject()
  add(path_594448, "resourceGroupName", newJString(resourceGroupName))
  add(query_594449, "api-version", newJString(apiVersion))
  add(path_594448, "subscriptionId", newJString(subscriptionId))
  if dataConnector != nil:
    body_594450 = dataConnector
  add(path_594448, "workspaceName", newJString(workspaceName))
  add(path_594448, "dataConnectorId", newJString(dataConnectorId))
  add(path_594448, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594447.call(path_594448, query_594449, nil, nil, body_594450)

var dataConnectorsCreateOrUpdate* = Call_DataConnectorsCreateOrUpdate_594436(
    name: "dataConnectorsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/dataConnectors/{dataConnectorId}",
    validator: validate_DataConnectorsCreateOrUpdate_594437, base: "",
    url: url_DataConnectorsCreateOrUpdate_594438, schemes: {Scheme.Https})
type
  Call_DataConnectorsGet_594423 = ref object of OpenApiRestCall_593438
proc url_DataConnectorsGet_594425(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "dataConnectorId" in path, "`dataConnectorId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/dataConnectors/"),
               (kind: VariableSegment, value: "dataConnectorId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataConnectorsGet_594424(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a data connector.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   dataConnectorId: JString (required)
  ##                  : Connector ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594426 = path.getOrDefault("resourceGroupName")
  valid_594426 = validateParameter(valid_594426, JString, required = true,
                                 default = nil)
  if valid_594426 != nil:
    section.add "resourceGroupName", valid_594426
  var valid_594427 = path.getOrDefault("subscriptionId")
  valid_594427 = validateParameter(valid_594427, JString, required = true,
                                 default = nil)
  if valid_594427 != nil:
    section.add "subscriptionId", valid_594427
  var valid_594428 = path.getOrDefault("workspaceName")
  valid_594428 = validateParameter(valid_594428, JString, required = true,
                                 default = nil)
  if valid_594428 != nil:
    section.add "workspaceName", valid_594428
  var valid_594429 = path.getOrDefault("dataConnectorId")
  valid_594429 = validateParameter(valid_594429, JString, required = true,
                                 default = nil)
  if valid_594429 != nil:
    section.add "dataConnectorId", valid_594429
  var valid_594430 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594430 = validateParameter(valid_594430, JString, required = true,
                                 default = nil)
  if valid_594430 != nil:
    section.add "operationalInsightsResourceProvider", valid_594430
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594431 = query.getOrDefault("api-version")
  valid_594431 = validateParameter(valid_594431, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594431 != nil:
    section.add "api-version", valid_594431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594432: Call_DataConnectorsGet_594423; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a data connector.
  ## 
  let valid = call_594432.validator(path, query, header, formData, body)
  let scheme = call_594432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594432.url(scheme.get, call_594432.host, call_594432.base,
                         call_594432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594432, url, valid)

proc call*(call_594433: Call_DataConnectorsGet_594423; resourceGroupName: string;
          subscriptionId: string; workspaceName: string; dataConnectorId: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## dataConnectorsGet
  ## Gets a data connector.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   dataConnectorId: string (required)
  ##                  : Connector ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594434 = newJObject()
  var query_594435 = newJObject()
  add(path_594434, "resourceGroupName", newJString(resourceGroupName))
  add(query_594435, "api-version", newJString(apiVersion))
  add(path_594434, "subscriptionId", newJString(subscriptionId))
  add(path_594434, "workspaceName", newJString(workspaceName))
  add(path_594434, "dataConnectorId", newJString(dataConnectorId))
  add(path_594434, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594433.call(path_594434, query_594435, nil, nil, nil)

var dataConnectorsGet* = Call_DataConnectorsGet_594423(name: "dataConnectorsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/dataConnectors/{dataConnectorId}",
    validator: validate_DataConnectorsGet_594424, base: "",
    url: url_DataConnectorsGet_594425, schemes: {Scheme.Https})
type
  Call_DataConnectorsDelete_594451 = ref object of OpenApiRestCall_593438
proc url_DataConnectorsDelete_594453(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "dataConnectorId" in path, "`dataConnectorId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/dataConnectors/"),
               (kind: VariableSegment, value: "dataConnectorId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataConnectorsDelete_594452(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the data connector.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   dataConnectorId: JString (required)
  ##                  : Connector ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594454 = path.getOrDefault("resourceGroupName")
  valid_594454 = validateParameter(valid_594454, JString, required = true,
                                 default = nil)
  if valid_594454 != nil:
    section.add "resourceGroupName", valid_594454
  var valid_594455 = path.getOrDefault("subscriptionId")
  valid_594455 = validateParameter(valid_594455, JString, required = true,
                                 default = nil)
  if valid_594455 != nil:
    section.add "subscriptionId", valid_594455
  var valid_594456 = path.getOrDefault("workspaceName")
  valid_594456 = validateParameter(valid_594456, JString, required = true,
                                 default = nil)
  if valid_594456 != nil:
    section.add "workspaceName", valid_594456
  var valid_594457 = path.getOrDefault("dataConnectorId")
  valid_594457 = validateParameter(valid_594457, JString, required = true,
                                 default = nil)
  if valid_594457 != nil:
    section.add "dataConnectorId", valid_594457
  var valid_594458 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594458 = validateParameter(valid_594458, JString, required = true,
                                 default = nil)
  if valid_594458 != nil:
    section.add "operationalInsightsResourceProvider", valid_594458
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594459 = query.getOrDefault("api-version")
  valid_594459 = validateParameter(valid_594459, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594459 != nil:
    section.add "api-version", valid_594459
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594460: Call_DataConnectorsDelete_594451; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the data connector.
  ## 
  let valid = call_594460.validator(path, query, header, formData, body)
  let scheme = call_594460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594460.url(scheme.get, call_594460.host, call_594460.base,
                         call_594460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594460, url, valid)

proc call*(call_594461: Call_DataConnectorsDelete_594451;
          resourceGroupName: string; subscriptionId: string; workspaceName: string;
          dataConnectorId: string; operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## dataConnectorsDelete
  ## Delete the data connector.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   dataConnectorId: string (required)
  ##                  : Connector ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594462 = newJObject()
  var query_594463 = newJObject()
  add(path_594462, "resourceGroupName", newJString(resourceGroupName))
  add(query_594463, "api-version", newJString(apiVersion))
  add(path_594462, "subscriptionId", newJString(subscriptionId))
  add(path_594462, "workspaceName", newJString(workspaceName))
  add(path_594462, "dataConnectorId", newJString(dataConnectorId))
  add(path_594462, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594461.call(path_594462, query_594463, nil, nil, nil)

var dataConnectorsDelete* = Call_DataConnectorsDelete_594451(
    name: "dataConnectorsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/dataConnectors/{dataConnectorId}",
    validator: validate_DataConnectorsDelete_594452, base: "",
    url: url_DataConnectorsDelete_594453, schemes: {Scheme.Https})
type
  Call_EntitiesList_594464 = ref object of OpenApiRestCall_593438
proc url_EntitiesList_594466(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/entities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EntitiesList_594465(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all entities.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594467 = path.getOrDefault("resourceGroupName")
  valid_594467 = validateParameter(valid_594467, JString, required = true,
                                 default = nil)
  if valid_594467 != nil:
    section.add "resourceGroupName", valid_594467
  var valid_594468 = path.getOrDefault("subscriptionId")
  valid_594468 = validateParameter(valid_594468, JString, required = true,
                                 default = nil)
  if valid_594468 != nil:
    section.add "subscriptionId", valid_594468
  var valid_594469 = path.getOrDefault("workspaceName")
  valid_594469 = validateParameter(valid_594469, JString, required = true,
                                 default = nil)
  if valid_594469 != nil:
    section.add "workspaceName", valid_594469
  var valid_594470 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "operationalInsightsResourceProvider", valid_594470
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594471 = query.getOrDefault("api-version")
  valid_594471 = validateParameter(valid_594471, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594471 != nil:
    section.add "api-version", valid_594471
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594472: Call_EntitiesList_594464; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all entities.
  ## 
  let valid = call_594472.validator(path, query, header, formData, body)
  let scheme = call_594472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594472.url(scheme.get, call_594472.host, call_594472.base,
                         call_594472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594472, url, valid)

proc call*(call_594473: Call_EntitiesList_594464; resourceGroupName: string;
          subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## entitiesList
  ## Gets all entities.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594474 = newJObject()
  var query_594475 = newJObject()
  add(path_594474, "resourceGroupName", newJString(resourceGroupName))
  add(query_594475, "api-version", newJString(apiVersion))
  add(path_594474, "subscriptionId", newJString(subscriptionId))
  add(path_594474, "workspaceName", newJString(workspaceName))
  add(path_594474, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594473.call(path_594474, query_594475, nil, nil, nil)

var entitiesList* = Call_EntitiesList_594464(name: "entitiesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/entities",
    validator: validate_EntitiesList_594465, base: "", url: url_EntitiesList_594466,
    schemes: {Scheme.Https})
type
  Call_EntitiesGet_594476 = ref object of OpenApiRestCall_593438
proc url_EntitiesGet_594478(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/entities/"),
               (kind: VariableSegment, value: "entityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EntitiesGet_594477(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an entity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   entityId: JString (required)
  ##           : entity ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594479 = path.getOrDefault("resourceGroupName")
  valid_594479 = validateParameter(valid_594479, JString, required = true,
                                 default = nil)
  if valid_594479 != nil:
    section.add "resourceGroupName", valid_594479
  var valid_594480 = path.getOrDefault("entityId")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = nil)
  if valid_594480 != nil:
    section.add "entityId", valid_594480
  var valid_594481 = path.getOrDefault("subscriptionId")
  valid_594481 = validateParameter(valid_594481, JString, required = true,
                                 default = nil)
  if valid_594481 != nil:
    section.add "subscriptionId", valid_594481
  var valid_594482 = path.getOrDefault("workspaceName")
  valid_594482 = validateParameter(valid_594482, JString, required = true,
                                 default = nil)
  if valid_594482 != nil:
    section.add "workspaceName", valid_594482
  var valid_594483 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594483 = validateParameter(valid_594483, JString, required = true,
                                 default = nil)
  if valid_594483 != nil:
    section.add "operationalInsightsResourceProvider", valid_594483
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594484 = query.getOrDefault("api-version")
  valid_594484 = validateParameter(valid_594484, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594484 != nil:
    section.add "api-version", valid_594484
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594485: Call_EntitiesGet_594476; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an entity.
  ## 
  let valid = call_594485.validator(path, query, header, formData, body)
  let scheme = call_594485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594485.url(scheme.get, call_594485.host, call_594485.base,
                         call_594485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594485, url, valid)

proc call*(call_594486: Call_EntitiesGet_594476; resourceGroupName: string;
          entityId: string; subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## entitiesGet
  ## Gets an entity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   entityId: string (required)
  ##           : entity ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594487 = newJObject()
  var query_594488 = newJObject()
  add(path_594487, "resourceGroupName", newJString(resourceGroupName))
  add(query_594488, "api-version", newJString(apiVersion))
  add(path_594487, "entityId", newJString(entityId))
  add(path_594487, "subscriptionId", newJString(subscriptionId))
  add(path_594487, "workspaceName", newJString(workspaceName))
  add(path_594487, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594486.call(path_594487, query_594488, nil, nil, nil)

var entitiesGet* = Call_EntitiesGet_594476(name: "entitiesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/entities/{entityId}",
                                        validator: validate_EntitiesGet_594477,
                                        base: "", url: url_EntitiesGet_594478,
                                        schemes: {Scheme.Https})
type
  Call_EntitiesExpand_594489 = ref object of OpenApiRestCall_593438
proc url_EntitiesExpand_594491(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/entities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/expand")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EntitiesExpand_594490(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Expands an entity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   entityId: JString (required)
  ##           : entity ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594509 = path.getOrDefault("resourceGroupName")
  valid_594509 = validateParameter(valid_594509, JString, required = true,
                                 default = nil)
  if valid_594509 != nil:
    section.add "resourceGroupName", valid_594509
  var valid_594510 = path.getOrDefault("entityId")
  valid_594510 = validateParameter(valid_594510, JString, required = true,
                                 default = nil)
  if valid_594510 != nil:
    section.add "entityId", valid_594510
  var valid_594511 = path.getOrDefault("subscriptionId")
  valid_594511 = validateParameter(valid_594511, JString, required = true,
                                 default = nil)
  if valid_594511 != nil:
    section.add "subscriptionId", valid_594511
  var valid_594512 = path.getOrDefault("workspaceName")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "workspaceName", valid_594512
  var valid_594513 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594513 = validateParameter(valid_594513, JString, required = true,
                                 default = nil)
  if valid_594513 != nil:
    section.add "operationalInsightsResourceProvider", valid_594513
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594514 = query.getOrDefault("api-version")
  valid_594514 = validateParameter(valid_594514, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594514 != nil:
    section.add "api-version", valid_594514
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters required to execute an expand operation on the given entity.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594516: Call_EntitiesExpand_594489; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Expands an entity.
  ## 
  let valid = call_594516.validator(path, query, header, formData, body)
  let scheme = call_594516.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594516.url(scheme.get, call_594516.host, call_594516.base,
                         call_594516.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594516, url, valid)

proc call*(call_594517: Call_EntitiesExpand_594489; resourceGroupName: string;
          entityId: string; subscriptionId: string; parameters: JsonNode;
          workspaceName: string; operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## entitiesExpand
  ## Expands an entity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   entityId: string (required)
  ##           : entity ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   parameters: JObject (required)
  ##             : The parameters required to execute an expand operation on the given entity.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594518 = newJObject()
  var query_594519 = newJObject()
  var body_594520 = newJObject()
  add(path_594518, "resourceGroupName", newJString(resourceGroupName))
  add(query_594519, "api-version", newJString(apiVersion))
  add(path_594518, "entityId", newJString(entityId))
  add(path_594518, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594520 = parameters
  add(path_594518, "workspaceName", newJString(workspaceName))
  add(path_594518, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594517.call(path_594518, query_594519, nil, nil, body_594520)

var entitiesExpand* = Call_EntitiesExpand_594489(name: "entitiesExpand",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/entities/{entityId}/expand",
    validator: validate_EntitiesExpand_594490, base: "", url: url_EntitiesExpand_594491,
    schemes: {Scheme.Https})
type
  Call_EntityQueriesList_594521 = ref object of OpenApiRestCall_593438
proc url_EntityQueriesList_594523(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/entityQueries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EntityQueriesList_594522(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets all entity queries.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594524 = path.getOrDefault("resourceGroupName")
  valid_594524 = validateParameter(valid_594524, JString, required = true,
                                 default = nil)
  if valid_594524 != nil:
    section.add "resourceGroupName", valid_594524
  var valid_594525 = path.getOrDefault("subscriptionId")
  valid_594525 = validateParameter(valid_594525, JString, required = true,
                                 default = nil)
  if valid_594525 != nil:
    section.add "subscriptionId", valid_594525
  var valid_594526 = path.getOrDefault("workspaceName")
  valid_594526 = validateParameter(valid_594526, JString, required = true,
                                 default = nil)
  if valid_594526 != nil:
    section.add "workspaceName", valid_594526
  var valid_594527 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594527 = validateParameter(valid_594527, JString, required = true,
                                 default = nil)
  if valid_594527 != nil:
    section.add "operationalInsightsResourceProvider", valid_594527
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594528 = query.getOrDefault("api-version")
  valid_594528 = validateParameter(valid_594528, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594528 != nil:
    section.add "api-version", valid_594528
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594529: Call_EntityQueriesList_594521; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all entity queries.
  ## 
  let valid = call_594529.validator(path, query, header, formData, body)
  let scheme = call_594529.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594529.url(scheme.get, call_594529.host, call_594529.base,
                         call_594529.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594529, url, valid)

proc call*(call_594530: Call_EntityQueriesList_594521; resourceGroupName: string;
          subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## entityQueriesList
  ## Gets all entity queries.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594531 = newJObject()
  var query_594532 = newJObject()
  add(path_594531, "resourceGroupName", newJString(resourceGroupName))
  add(query_594532, "api-version", newJString(apiVersion))
  add(path_594531, "subscriptionId", newJString(subscriptionId))
  add(path_594531, "workspaceName", newJString(workspaceName))
  add(path_594531, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594530.call(path_594531, query_594532, nil, nil, nil)

var entityQueriesList* = Call_EntityQueriesList_594521(name: "entityQueriesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/entityQueries",
    validator: validate_EntityQueriesList_594522, base: "",
    url: url_EntityQueriesList_594523, schemes: {Scheme.Https})
type
  Call_EntityQueriesGet_594533 = ref object of OpenApiRestCall_593438
proc url_EntityQueriesGet_594535(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "entityQueryId" in path, "`entityQueryId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/entityQueries/"),
               (kind: VariableSegment, value: "entityQueryId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EntityQueriesGet_594534(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets an entity query.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   entityQueryId: JString (required)
  ##                : entity query ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594536 = path.getOrDefault("resourceGroupName")
  valid_594536 = validateParameter(valid_594536, JString, required = true,
                                 default = nil)
  if valid_594536 != nil:
    section.add "resourceGroupName", valid_594536
  var valid_594537 = path.getOrDefault("entityQueryId")
  valid_594537 = validateParameter(valid_594537, JString, required = true,
                                 default = nil)
  if valid_594537 != nil:
    section.add "entityQueryId", valid_594537
  var valid_594538 = path.getOrDefault("subscriptionId")
  valid_594538 = validateParameter(valid_594538, JString, required = true,
                                 default = nil)
  if valid_594538 != nil:
    section.add "subscriptionId", valid_594538
  var valid_594539 = path.getOrDefault("workspaceName")
  valid_594539 = validateParameter(valid_594539, JString, required = true,
                                 default = nil)
  if valid_594539 != nil:
    section.add "workspaceName", valid_594539
  var valid_594540 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594540 = validateParameter(valid_594540, JString, required = true,
                                 default = nil)
  if valid_594540 != nil:
    section.add "operationalInsightsResourceProvider", valid_594540
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594541 = query.getOrDefault("api-version")
  valid_594541 = validateParameter(valid_594541, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594541 != nil:
    section.add "api-version", valid_594541
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594542: Call_EntityQueriesGet_594533; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an entity query.
  ## 
  let valid = call_594542.validator(path, query, header, formData, body)
  let scheme = call_594542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594542.url(scheme.get, call_594542.host, call_594542.base,
                         call_594542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594542, url, valid)

proc call*(call_594543: Call_EntityQueriesGet_594533; resourceGroupName: string;
          entityQueryId: string; subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## entityQueriesGet
  ## Gets an entity query.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   entityQueryId: string (required)
  ##                : entity query ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594544 = newJObject()
  var query_594545 = newJObject()
  add(path_594544, "resourceGroupName", newJString(resourceGroupName))
  add(query_594545, "api-version", newJString(apiVersion))
  add(path_594544, "entityQueryId", newJString(entityQueryId))
  add(path_594544, "subscriptionId", newJString(subscriptionId))
  add(path_594544, "workspaceName", newJString(workspaceName))
  add(path_594544, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594543.call(path_594544, query_594545, nil, nil, nil)

var entityQueriesGet* = Call_EntityQueriesGet_594533(name: "entityQueriesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/entityQueries/{entityQueryId}",
    validator: validate_EntityQueriesGet_594534, base: "",
    url: url_EntityQueriesGet_594535, schemes: {Scheme.Https})
type
  Call_OfficeConsentsList_594546 = ref object of OpenApiRestCall_593438
proc url_OfficeConsentsList_594548(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/officeConsents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OfficeConsentsList_594547(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets all office365 consents.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594549 = path.getOrDefault("resourceGroupName")
  valid_594549 = validateParameter(valid_594549, JString, required = true,
                                 default = nil)
  if valid_594549 != nil:
    section.add "resourceGroupName", valid_594549
  var valid_594550 = path.getOrDefault("subscriptionId")
  valid_594550 = validateParameter(valid_594550, JString, required = true,
                                 default = nil)
  if valid_594550 != nil:
    section.add "subscriptionId", valid_594550
  var valid_594551 = path.getOrDefault("workspaceName")
  valid_594551 = validateParameter(valid_594551, JString, required = true,
                                 default = nil)
  if valid_594551 != nil:
    section.add "workspaceName", valid_594551
  var valid_594552 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594552 = validateParameter(valid_594552, JString, required = true,
                                 default = nil)
  if valid_594552 != nil:
    section.add "operationalInsightsResourceProvider", valid_594552
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594553 = query.getOrDefault("api-version")
  valid_594553 = validateParameter(valid_594553, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594553 != nil:
    section.add "api-version", valid_594553
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594554: Call_OfficeConsentsList_594546; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all office365 consents.
  ## 
  let valid = call_594554.validator(path, query, header, formData, body)
  let scheme = call_594554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594554.url(scheme.get, call_594554.host, call_594554.base,
                         call_594554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594554, url, valid)

proc call*(call_594555: Call_OfficeConsentsList_594546; resourceGroupName: string;
          subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## officeConsentsList
  ## Gets all office365 consents.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594556 = newJObject()
  var query_594557 = newJObject()
  add(path_594556, "resourceGroupName", newJString(resourceGroupName))
  add(query_594557, "api-version", newJString(apiVersion))
  add(path_594556, "subscriptionId", newJString(subscriptionId))
  add(path_594556, "workspaceName", newJString(workspaceName))
  add(path_594556, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594555.call(path_594556, query_594557, nil, nil, nil)

var officeConsentsList* = Call_OfficeConsentsList_594546(
    name: "officeConsentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/officeConsents",
    validator: validate_OfficeConsentsList_594547, base: "",
    url: url_OfficeConsentsList_594548, schemes: {Scheme.Https})
type
  Call_OfficeConsentsGet_594558 = ref object of OpenApiRestCall_593438
proc url_OfficeConsentsGet_594560(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "consentId" in path, "`consentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/officeConsents/"),
               (kind: VariableSegment, value: "consentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OfficeConsentsGet_594559(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets an office365 consent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   consentId: JString (required)
  ##            : consent ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594561 = path.getOrDefault("resourceGroupName")
  valid_594561 = validateParameter(valid_594561, JString, required = true,
                                 default = nil)
  if valid_594561 != nil:
    section.add "resourceGroupName", valid_594561
  var valid_594562 = path.getOrDefault("subscriptionId")
  valid_594562 = validateParameter(valid_594562, JString, required = true,
                                 default = nil)
  if valid_594562 != nil:
    section.add "subscriptionId", valid_594562
  var valid_594563 = path.getOrDefault("workspaceName")
  valid_594563 = validateParameter(valid_594563, JString, required = true,
                                 default = nil)
  if valid_594563 != nil:
    section.add "workspaceName", valid_594563
  var valid_594564 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594564 = validateParameter(valid_594564, JString, required = true,
                                 default = nil)
  if valid_594564 != nil:
    section.add "operationalInsightsResourceProvider", valid_594564
  var valid_594565 = path.getOrDefault("consentId")
  valid_594565 = validateParameter(valid_594565, JString, required = true,
                                 default = nil)
  if valid_594565 != nil:
    section.add "consentId", valid_594565
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594566 = query.getOrDefault("api-version")
  valid_594566 = validateParameter(valid_594566, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594566 != nil:
    section.add "api-version", valid_594566
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594567: Call_OfficeConsentsGet_594558; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an office365 consent.
  ## 
  let valid = call_594567.validator(path, query, header, formData, body)
  let scheme = call_594567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594567.url(scheme.get, call_594567.host, call_594567.base,
                         call_594567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594567, url, valid)

proc call*(call_594568: Call_OfficeConsentsGet_594558; resourceGroupName: string;
          subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string; consentId: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## officeConsentsGet
  ## Gets an office365 consent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   consentId: string (required)
  ##            : consent ID
  var path_594569 = newJObject()
  var query_594570 = newJObject()
  add(path_594569, "resourceGroupName", newJString(resourceGroupName))
  add(query_594570, "api-version", newJString(apiVersion))
  add(path_594569, "subscriptionId", newJString(subscriptionId))
  add(path_594569, "workspaceName", newJString(workspaceName))
  add(path_594569, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_594569, "consentId", newJString(consentId))
  result = call_594568.call(path_594569, query_594570, nil, nil, nil)

var officeConsentsGet* = Call_OfficeConsentsGet_594558(name: "officeConsentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/officeConsents/{consentId}",
    validator: validate_OfficeConsentsGet_594559, base: "",
    url: url_OfficeConsentsGet_594560, schemes: {Scheme.Https})
type
  Call_OfficeConsentsDelete_594571 = ref object of OpenApiRestCall_593438
proc url_OfficeConsentsDelete_594573(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "consentId" in path, "`consentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/officeConsents/"),
               (kind: VariableSegment, value: "consentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OfficeConsentsDelete_594572(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the office365 consent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   consentId: JString (required)
  ##            : consent ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594574 = path.getOrDefault("resourceGroupName")
  valid_594574 = validateParameter(valid_594574, JString, required = true,
                                 default = nil)
  if valid_594574 != nil:
    section.add "resourceGroupName", valid_594574
  var valid_594575 = path.getOrDefault("subscriptionId")
  valid_594575 = validateParameter(valid_594575, JString, required = true,
                                 default = nil)
  if valid_594575 != nil:
    section.add "subscriptionId", valid_594575
  var valid_594576 = path.getOrDefault("workspaceName")
  valid_594576 = validateParameter(valid_594576, JString, required = true,
                                 default = nil)
  if valid_594576 != nil:
    section.add "workspaceName", valid_594576
  var valid_594577 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594577 = validateParameter(valid_594577, JString, required = true,
                                 default = nil)
  if valid_594577 != nil:
    section.add "operationalInsightsResourceProvider", valid_594577
  var valid_594578 = path.getOrDefault("consentId")
  valid_594578 = validateParameter(valid_594578, JString, required = true,
                                 default = nil)
  if valid_594578 != nil:
    section.add "consentId", valid_594578
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594579 = query.getOrDefault("api-version")
  valid_594579 = validateParameter(valid_594579, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594579 != nil:
    section.add "api-version", valid_594579
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594580: Call_OfficeConsentsDelete_594571; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the office365 consent.
  ## 
  let valid = call_594580.validator(path, query, header, formData, body)
  let scheme = call_594580.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594580.url(scheme.get, call_594580.host, call_594580.base,
                         call_594580.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594580, url, valid)

proc call*(call_594581: Call_OfficeConsentsDelete_594571;
          resourceGroupName: string; subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string; consentId: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## officeConsentsDelete
  ## Delete the office365 consent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   consentId: string (required)
  ##            : consent ID
  var path_594582 = newJObject()
  var query_594583 = newJObject()
  add(path_594582, "resourceGroupName", newJString(resourceGroupName))
  add(query_594583, "api-version", newJString(apiVersion))
  add(path_594582, "subscriptionId", newJString(subscriptionId))
  add(path_594582, "workspaceName", newJString(workspaceName))
  add(path_594582, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_594582, "consentId", newJString(consentId))
  result = call_594581.call(path_594582, query_594583, nil, nil, nil)

var officeConsentsDelete* = Call_OfficeConsentsDelete_594571(
    name: "officeConsentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/officeConsents/{consentId}",
    validator: validate_OfficeConsentsDelete_594572, base: "",
    url: url_OfficeConsentsDelete_594573, schemes: {Scheme.Https})
type
  Call_ProductSettingsUpdate_594597 = ref object of OpenApiRestCall_593438
proc url_ProductSettingsUpdate_594599(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "settingsName" in path, "`settingsName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/settings/"),
               (kind: VariableSegment, value: "settingsName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductSettingsUpdate_594598(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the setting.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   settingsName: JString (required)
  ##               : The setting name. Supports- Fusion, UEBA
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594600 = path.getOrDefault("resourceGroupName")
  valid_594600 = validateParameter(valid_594600, JString, required = true,
                                 default = nil)
  if valid_594600 != nil:
    section.add "resourceGroupName", valid_594600
  var valid_594601 = path.getOrDefault("subscriptionId")
  valid_594601 = validateParameter(valid_594601, JString, required = true,
                                 default = nil)
  if valid_594601 != nil:
    section.add "subscriptionId", valid_594601
  var valid_594602 = path.getOrDefault("settingsName")
  valid_594602 = validateParameter(valid_594602, JString, required = true,
                                 default = nil)
  if valid_594602 != nil:
    section.add "settingsName", valid_594602
  var valid_594603 = path.getOrDefault("workspaceName")
  valid_594603 = validateParameter(valid_594603, JString, required = true,
                                 default = nil)
  if valid_594603 != nil:
    section.add "workspaceName", valid_594603
  var valid_594604 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594604 = validateParameter(valid_594604, JString, required = true,
                                 default = nil)
  if valid_594604 != nil:
    section.add "operationalInsightsResourceProvider", valid_594604
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594605 = query.getOrDefault("api-version")
  valid_594605 = validateParameter(valid_594605, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594605 != nil:
    section.add "api-version", valid_594605
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   settings: JObject (required)
  ##           : The setting
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594607: Call_ProductSettingsUpdate_594597; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the setting.
  ## 
  let valid = call_594607.validator(path, query, header, formData, body)
  let scheme = call_594607.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594607.url(scheme.get, call_594607.host, call_594607.base,
                         call_594607.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594607, url, valid)

proc call*(call_594608: Call_ProductSettingsUpdate_594597; settings: JsonNode;
          resourceGroupName: string; subscriptionId: string; settingsName: string;
          workspaceName: string; operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## productSettingsUpdate
  ## Updates the setting.
  ##   settings: JObject (required)
  ##           : The setting
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   settingsName: string (required)
  ##               : The setting name. Supports- Fusion, UEBA
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594609 = newJObject()
  var query_594610 = newJObject()
  var body_594611 = newJObject()
  if settings != nil:
    body_594611 = settings
  add(path_594609, "resourceGroupName", newJString(resourceGroupName))
  add(query_594610, "api-version", newJString(apiVersion))
  add(path_594609, "subscriptionId", newJString(subscriptionId))
  add(path_594609, "settingsName", newJString(settingsName))
  add(path_594609, "workspaceName", newJString(workspaceName))
  add(path_594609, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594608.call(path_594609, query_594610, nil, nil, body_594611)

var productSettingsUpdate* = Call_ProductSettingsUpdate_594597(
    name: "productSettingsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/settings/{settingsName}",
    validator: validate_ProductSettingsUpdate_594598, base: "",
    url: url_ProductSettingsUpdate_594599, schemes: {Scheme.Https})
type
  Call_ProductSettingsGet_594584 = ref object of OpenApiRestCall_593438
proc url_ProductSettingsGet_594586(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "settingsName" in path, "`settingsName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/settings/"),
               (kind: VariableSegment, value: "settingsName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductSettingsGet_594585(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets a setting.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   settingsName: JString (required)
  ##               : The setting name. Supports- Fusion, UEBA
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594587 = path.getOrDefault("resourceGroupName")
  valid_594587 = validateParameter(valid_594587, JString, required = true,
                                 default = nil)
  if valid_594587 != nil:
    section.add "resourceGroupName", valid_594587
  var valid_594588 = path.getOrDefault("subscriptionId")
  valid_594588 = validateParameter(valid_594588, JString, required = true,
                                 default = nil)
  if valid_594588 != nil:
    section.add "subscriptionId", valid_594588
  var valid_594589 = path.getOrDefault("settingsName")
  valid_594589 = validateParameter(valid_594589, JString, required = true,
                                 default = nil)
  if valid_594589 != nil:
    section.add "settingsName", valid_594589
  var valid_594590 = path.getOrDefault("workspaceName")
  valid_594590 = validateParameter(valid_594590, JString, required = true,
                                 default = nil)
  if valid_594590 != nil:
    section.add "workspaceName", valid_594590
  var valid_594591 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_594591 = validateParameter(valid_594591, JString, required = true,
                                 default = nil)
  if valid_594591 != nil:
    section.add "operationalInsightsResourceProvider", valid_594591
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594592 = query.getOrDefault("api-version")
  valid_594592 = validateParameter(valid_594592, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_594592 != nil:
    section.add "api-version", valid_594592
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594593: Call_ProductSettingsGet_594584; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a setting.
  ## 
  let valid = call_594593.validator(path, query, header, formData, body)
  let scheme = call_594593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594593.url(scheme.get, call_594593.host, call_594593.base,
                         call_594593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594593, url, valid)

proc call*(call_594594: Call_ProductSettingsGet_594584; resourceGroupName: string;
          subscriptionId: string; settingsName: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## productSettingsGet
  ## Gets a setting.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   settingsName: string (required)
  ##               : The setting name. Supports- Fusion, UEBA
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_594595 = newJObject()
  var query_594596 = newJObject()
  add(path_594595, "resourceGroupName", newJString(resourceGroupName))
  add(query_594596, "api-version", newJString(apiVersion))
  add(path_594595, "subscriptionId", newJString(subscriptionId))
  add(path_594595, "settingsName", newJString(settingsName))
  add(path_594595, "workspaceName", newJString(workspaceName))
  add(path_594595, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_594594.call(path_594595, query_594596, nil, nil, nil)

var productSettingsGet* = Call_ProductSettingsGet_594584(
    name: "productSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/settings/{settingsName}",
    validator: validate_ProductSettingsGet_594585, base: "",
    url: url_ProductSettingsGet_594586, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
