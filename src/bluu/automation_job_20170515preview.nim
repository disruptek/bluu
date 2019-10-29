
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: AutomationManagement
## version: 2017-05-15-preview
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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
  macServiceName = "automation-job"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_JobListByAutomationAccount_563778 = ref object of OpenApiRestCall_563556
proc url_JobListByAutomationAccount_563780(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobListByAutomationAccount_563779(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of jobs.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_563943 = path.getOrDefault("automationAccountName")
  valid_563943 = validateParameter(valid_563943, JString, required = true,
                                 default = nil)
  if valid_563943 != nil:
    section.add "automationAccountName", valid_563943
  var valid_563944 = path.getOrDefault("subscriptionId")
  valid_563944 = validateParameter(valid_563944, JString, required = true,
                                 default = nil)
  if valid_563944 != nil:
    section.add "subscriptionId", valid_563944
  var valid_563945 = path.getOrDefault("resourceGroupName")
  valid_563945 = validateParameter(valid_563945, JString, required = true,
                                 default = nil)
  if valid_563945 != nil:
    section.add "resourceGroupName", valid_563945
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563946 = query.getOrDefault("api-version")
  valid_563946 = validateParameter(valid_563946, JString, required = true,
                                 default = nil)
  if valid_563946 != nil:
    section.add "api-version", valid_563946
  var valid_563947 = query.getOrDefault("$filter")
  valid_563947 = validateParameter(valid_563947, JString, required = false,
                                 default = nil)
  if valid_563947 != nil:
    section.add "$filter", valid_563947
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_563948 = header.getOrDefault("clientRequestId")
  valid_563948 = validateParameter(valid_563948, JString, required = false,
                                 default = nil)
  if valid_563948 != nil:
    section.add "clientRequestId", valid_563948
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563975: Call_JobListByAutomationAccount_563778; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a list of jobs.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_563975.validator(path, query, header, formData, body)
  let scheme = call_563975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563975.url(scheme.get, call_563975.host, call_563975.base,
                         call_563975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563975, url, valid)

proc call*(call_564046: Call_JobListByAutomationAccount_563778; apiVersion: string;
          automationAccountName: string; subscriptionId: string;
          resourceGroupName: string; Filter: string = ""): Recallable =
  ## jobListByAutomationAccount
  ## Retrieve a list of jobs.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_564047 = newJObject()
  var query_564049 = newJObject()
  add(query_564049, "api-version", newJString(apiVersion))
  add(path_564047, "automationAccountName", newJString(automationAccountName))
  add(path_564047, "subscriptionId", newJString(subscriptionId))
  add(path_564047, "resourceGroupName", newJString(resourceGroupName))
  add(query_564049, "$filter", newJString(Filter))
  result = call_564046.call(path_564047, query_564049, nil, nil, nil)

var jobListByAutomationAccount* = Call_JobListByAutomationAccount_563778(
    name: "jobListByAutomationAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs",
    validator: validate_JobListByAutomationAccount_563779, base: "",
    url: url_JobListByAutomationAccount_563780, schemes: {Scheme.Https})
type
  Call_JobCreate_564101 = ref object of OpenApiRestCall_563556
proc url_JobCreate_564103(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobCreate_564102(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a job of the runbook.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   jobName: JString (required)
  ##          : The job name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_564130 = path.getOrDefault("automationAccountName")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "automationAccountName", valid_564130
  var valid_564131 = path.getOrDefault("subscriptionId")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "subscriptionId", valid_564131
  var valid_564132 = path.getOrDefault("resourceGroupName")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "resourceGroupName", valid_564132
  var valid_564133 = path.getOrDefault("jobName")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "jobName", valid_564133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564134 = query.getOrDefault("api-version")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "api-version", valid_564134
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_564135 = header.getOrDefault("clientRequestId")
  valid_564135 = validateParameter(valid_564135, JString, required = false,
                                 default = nil)
  if valid_564135 != nil:
    section.add "clientRequestId", valid_564135
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters supplied to the create job operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564137: Call_JobCreate_564101; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a job of the runbook.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_564137.validator(path, query, header, formData, body)
  let scheme = call_564137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564137.url(scheme.get, call_564137.host, call_564137.base,
                         call_564137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564137, url, valid)

proc call*(call_564138: Call_JobCreate_564101; apiVersion: string;
          automationAccountName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode; jobName: string): Recallable =
  ## jobCreate
  ## Create a job of the runbook.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   parameters: JObject (required)
  ##             : The parameters supplied to the create job operation.
  ##   jobName: string (required)
  ##          : The job name.
  var path_564139 = newJObject()
  var query_564140 = newJObject()
  var body_564141 = newJObject()
  add(query_564140, "api-version", newJString(apiVersion))
  add(path_564139, "automationAccountName", newJString(automationAccountName))
  add(path_564139, "subscriptionId", newJString(subscriptionId))
  add(path_564139, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564141 = parameters
  add(path_564139, "jobName", newJString(jobName))
  result = call_564138.call(path_564139, query_564140, nil, nil, body_564141)

var jobCreate* = Call_JobCreate_564101(name: "jobCreate", meth: HttpMethod.HttpPut,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobName}",
                                    validator: validate_JobCreate_564102,
                                    base: "", url: url_JobCreate_564103,
                                    schemes: {Scheme.Https})
type
  Call_JobGet_564088 = ref object of OpenApiRestCall_563556
proc url_JobGet_564090(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobGet_564089(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the job identified by job name.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   jobName: JString (required)
  ##          : The job name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_564091 = path.getOrDefault("automationAccountName")
  valid_564091 = validateParameter(valid_564091, JString, required = true,
                                 default = nil)
  if valid_564091 != nil:
    section.add "automationAccountName", valid_564091
  var valid_564092 = path.getOrDefault("subscriptionId")
  valid_564092 = validateParameter(valid_564092, JString, required = true,
                                 default = nil)
  if valid_564092 != nil:
    section.add "subscriptionId", valid_564092
  var valid_564093 = path.getOrDefault("resourceGroupName")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "resourceGroupName", valid_564093
  var valid_564094 = path.getOrDefault("jobName")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "jobName", valid_564094
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564095 = query.getOrDefault("api-version")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "api-version", valid_564095
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_564096 = header.getOrDefault("clientRequestId")
  valid_564096 = validateParameter(valid_564096, JString, required = false,
                                 default = nil)
  if valid_564096 != nil:
    section.add "clientRequestId", valid_564096
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564097: Call_JobGet_564088; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the job identified by job name.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_564097.validator(path, query, header, formData, body)
  let scheme = call_564097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564097.url(scheme.get, call_564097.host, call_564097.base,
                         call_564097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564097, url, valid)

proc call*(call_564098: Call_JobGet_564088; apiVersion: string;
          automationAccountName: string; subscriptionId: string;
          resourceGroupName: string; jobName: string): Recallable =
  ## jobGet
  ## Retrieve the job identified by job name.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   jobName: string (required)
  ##          : The job name.
  var path_564099 = newJObject()
  var query_564100 = newJObject()
  add(query_564100, "api-version", newJString(apiVersion))
  add(path_564099, "automationAccountName", newJString(automationAccountName))
  add(path_564099, "subscriptionId", newJString(subscriptionId))
  add(path_564099, "resourceGroupName", newJString(resourceGroupName))
  add(path_564099, "jobName", newJString(jobName))
  result = call_564098.call(path_564099, query_564100, nil, nil, nil)

var jobGet* = Call_JobGet_564088(name: "jobGet", meth: HttpMethod.HttpGet,
                              host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobName}",
                              validator: validate_JobGet_564089, base: "",
                              url: url_JobGet_564090, schemes: {Scheme.Https})
type
  Call_JobGetOutput_564142 = ref object of OpenApiRestCall_563556
proc url_JobGetOutput_564144(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/output")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobGetOutput_564143(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the job output identified by job name.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   jobName: JString (required)
  ##          : The name of the job to be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_564145 = path.getOrDefault("automationAccountName")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "automationAccountName", valid_564145
  var valid_564146 = path.getOrDefault("subscriptionId")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "subscriptionId", valid_564146
  var valid_564147 = path.getOrDefault("resourceGroupName")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "resourceGroupName", valid_564147
  var valid_564148 = path.getOrDefault("jobName")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "jobName", valid_564148
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564149 = query.getOrDefault("api-version")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "api-version", valid_564149
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_564150 = header.getOrDefault("clientRequestId")
  valid_564150 = validateParameter(valid_564150, JString, required = false,
                                 default = nil)
  if valid_564150 != nil:
    section.add "clientRequestId", valid_564150
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564151: Call_JobGetOutput_564142; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the job output identified by job name.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_564151.validator(path, query, header, formData, body)
  let scheme = call_564151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564151.url(scheme.get, call_564151.host, call_564151.base,
                         call_564151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564151, url, valid)

proc call*(call_564152: Call_JobGetOutput_564142; apiVersion: string;
          automationAccountName: string; subscriptionId: string;
          resourceGroupName: string; jobName: string): Recallable =
  ## jobGetOutput
  ## Retrieve the job output identified by job name.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   jobName: string (required)
  ##          : The name of the job to be created.
  var path_564153 = newJObject()
  var query_564154 = newJObject()
  add(query_564154, "api-version", newJString(apiVersion))
  add(path_564153, "automationAccountName", newJString(automationAccountName))
  add(path_564153, "subscriptionId", newJString(subscriptionId))
  add(path_564153, "resourceGroupName", newJString(resourceGroupName))
  add(path_564153, "jobName", newJString(jobName))
  result = call_564152.call(path_564153, query_564154, nil, nil, nil)

var jobGetOutput* = Call_JobGetOutput_564142(name: "jobGetOutput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobName}/output",
    validator: validate_JobGetOutput_564143, base: "", url: url_JobGetOutput_564144,
    schemes: {Scheme.Https})
type
  Call_JobResume_564155 = ref object of OpenApiRestCall_563556
proc url_JobResume_564157(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/resume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobResume_564156(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Resume the job identified by jobName.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   jobName: JString (required)
  ##          : The job name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_564158 = path.getOrDefault("automationAccountName")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "automationAccountName", valid_564158
  var valid_564159 = path.getOrDefault("subscriptionId")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "subscriptionId", valid_564159
  var valid_564160 = path.getOrDefault("resourceGroupName")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "resourceGroupName", valid_564160
  var valid_564161 = path.getOrDefault("jobName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "jobName", valid_564161
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564162 = query.getOrDefault("api-version")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "api-version", valid_564162
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_564163 = header.getOrDefault("clientRequestId")
  valid_564163 = validateParameter(valid_564163, JString, required = false,
                                 default = nil)
  if valid_564163 != nil:
    section.add "clientRequestId", valid_564163
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564164: Call_JobResume_564155; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resume the job identified by jobName.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_564164.validator(path, query, header, formData, body)
  let scheme = call_564164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564164.url(scheme.get, call_564164.host, call_564164.base,
                         call_564164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564164, url, valid)

proc call*(call_564165: Call_JobResume_564155; apiVersion: string;
          automationAccountName: string; subscriptionId: string;
          resourceGroupName: string; jobName: string): Recallable =
  ## jobResume
  ## Resume the job identified by jobName.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   jobName: string (required)
  ##          : The job name.
  var path_564166 = newJObject()
  var query_564167 = newJObject()
  add(query_564167, "api-version", newJString(apiVersion))
  add(path_564166, "automationAccountName", newJString(automationAccountName))
  add(path_564166, "subscriptionId", newJString(subscriptionId))
  add(path_564166, "resourceGroupName", newJString(resourceGroupName))
  add(path_564166, "jobName", newJString(jobName))
  result = call_564165.call(path_564166, query_564167, nil, nil, nil)

var jobResume* = Call_JobResume_564155(name: "jobResume", meth: HttpMethod.HttpPost,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobName}/resume",
                                    validator: validate_JobResume_564156,
                                    base: "", url: url_JobResume_564157,
                                    schemes: {Scheme.Https})
type
  Call_JobGetRunbookContent_564168 = ref object of OpenApiRestCall_563556
proc url_JobGetRunbookContent_564170(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/runbookContent")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobGetRunbookContent_564169(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the runbook content of the job identified by job name.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   jobName: JString (required)
  ##          : The job name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_564171 = path.getOrDefault("automationAccountName")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "automationAccountName", valid_564171
  var valid_564172 = path.getOrDefault("subscriptionId")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "subscriptionId", valid_564172
  var valid_564173 = path.getOrDefault("resourceGroupName")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "resourceGroupName", valid_564173
  var valid_564174 = path.getOrDefault("jobName")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "jobName", valid_564174
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564175 = query.getOrDefault("api-version")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "api-version", valid_564175
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_564176 = header.getOrDefault("clientRequestId")
  valid_564176 = validateParameter(valid_564176, JString, required = false,
                                 default = nil)
  if valid_564176 != nil:
    section.add "clientRequestId", valid_564176
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564177: Call_JobGetRunbookContent_564168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the runbook content of the job identified by job name.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_564177.validator(path, query, header, formData, body)
  let scheme = call_564177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564177.url(scheme.get, call_564177.host, call_564177.base,
                         call_564177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564177, url, valid)

proc call*(call_564178: Call_JobGetRunbookContent_564168; apiVersion: string;
          automationAccountName: string; subscriptionId: string;
          resourceGroupName: string; jobName: string): Recallable =
  ## jobGetRunbookContent
  ## Retrieve the runbook content of the job identified by job name.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   jobName: string (required)
  ##          : The job name.
  var path_564179 = newJObject()
  var query_564180 = newJObject()
  add(query_564180, "api-version", newJString(apiVersion))
  add(path_564179, "automationAccountName", newJString(automationAccountName))
  add(path_564179, "subscriptionId", newJString(subscriptionId))
  add(path_564179, "resourceGroupName", newJString(resourceGroupName))
  add(path_564179, "jobName", newJString(jobName))
  result = call_564178.call(path_564179, query_564180, nil, nil, nil)

var jobGetRunbookContent* = Call_JobGetRunbookContent_564168(
    name: "jobGetRunbookContent", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobName}/runbookContent",
    validator: validate_JobGetRunbookContent_564169, base: "",
    url: url_JobGetRunbookContent_564170, schemes: {Scheme.Https})
type
  Call_JobStop_564181 = ref object of OpenApiRestCall_563556
proc url_JobStop_564183(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobStop_564182(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Stop the job identified by jobName.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   jobName: JString (required)
  ##          : The job name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_564184 = path.getOrDefault("automationAccountName")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "automationAccountName", valid_564184
  var valid_564185 = path.getOrDefault("subscriptionId")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "subscriptionId", valid_564185
  var valid_564186 = path.getOrDefault("resourceGroupName")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "resourceGroupName", valid_564186
  var valid_564187 = path.getOrDefault("jobName")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "jobName", valid_564187
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564188 = query.getOrDefault("api-version")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "api-version", valid_564188
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_564189 = header.getOrDefault("clientRequestId")
  valid_564189 = validateParameter(valid_564189, JString, required = false,
                                 default = nil)
  if valid_564189 != nil:
    section.add "clientRequestId", valid_564189
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564190: Call_JobStop_564181; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop the job identified by jobName.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_564190.validator(path, query, header, formData, body)
  let scheme = call_564190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564190.url(scheme.get, call_564190.host, call_564190.base,
                         call_564190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564190, url, valid)

proc call*(call_564191: Call_JobStop_564181; apiVersion: string;
          automationAccountName: string; subscriptionId: string;
          resourceGroupName: string; jobName: string): Recallable =
  ## jobStop
  ## Stop the job identified by jobName.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   jobName: string (required)
  ##          : The job name.
  var path_564192 = newJObject()
  var query_564193 = newJObject()
  add(query_564193, "api-version", newJString(apiVersion))
  add(path_564192, "automationAccountName", newJString(automationAccountName))
  add(path_564192, "subscriptionId", newJString(subscriptionId))
  add(path_564192, "resourceGroupName", newJString(resourceGroupName))
  add(path_564192, "jobName", newJString(jobName))
  result = call_564191.call(path_564192, query_564193, nil, nil, nil)

var jobStop* = Call_JobStop_564181(name: "jobStop", meth: HttpMethod.HttpPost,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobName}/stop",
                                validator: validate_JobStop_564182, base: "",
                                url: url_JobStop_564183, schemes: {Scheme.Https})
type
  Call_JobStreamListByJob_564194 = ref object of OpenApiRestCall_563556
proc url_JobStreamListByJob_564196(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/streams")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobStreamListByJob_564195(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieve a list of jobs streams identified by job name.
  ## 
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   jobName: JString (required)
  ##          : The job name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_564197 = path.getOrDefault("automationAccountName")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "automationAccountName", valid_564197
  var valid_564198 = path.getOrDefault("subscriptionId")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "subscriptionId", valid_564198
  var valid_564199 = path.getOrDefault("resourceGroupName")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "resourceGroupName", valid_564199
  var valid_564200 = path.getOrDefault("jobName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "jobName", valid_564200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564201 = query.getOrDefault("api-version")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "api-version", valid_564201
  var valid_564202 = query.getOrDefault("$filter")
  valid_564202 = validateParameter(valid_564202, JString, required = false,
                                 default = nil)
  if valid_564202 != nil:
    section.add "$filter", valid_564202
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_564203 = header.getOrDefault("clientRequestId")
  valid_564203 = validateParameter(valid_564203, JString, required = false,
                                 default = nil)
  if valid_564203 != nil:
    section.add "clientRequestId", valid_564203
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564204: Call_JobStreamListByJob_564194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a list of jobs streams identified by job name.
  ## 
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  let valid = call_564204.validator(path, query, header, formData, body)
  let scheme = call_564204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564204.url(scheme.get, call_564204.host, call_564204.base,
                         call_564204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564204, url, valid)

proc call*(call_564205: Call_JobStreamListByJob_564194; apiVersion: string;
          automationAccountName: string; subscriptionId: string;
          resourceGroupName: string; jobName: string; Filter: string = ""): Recallable =
  ## jobStreamListByJob
  ## Retrieve a list of jobs streams identified by job name.
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   jobName: string (required)
  ##          : The job name.
  var path_564206 = newJObject()
  var query_564207 = newJObject()
  add(query_564207, "api-version", newJString(apiVersion))
  add(path_564206, "automationAccountName", newJString(automationAccountName))
  add(path_564206, "subscriptionId", newJString(subscriptionId))
  add(path_564206, "resourceGroupName", newJString(resourceGroupName))
  add(query_564207, "$filter", newJString(Filter))
  add(path_564206, "jobName", newJString(jobName))
  result = call_564205.call(path_564206, query_564207, nil, nil, nil)

var jobStreamListByJob* = Call_JobStreamListByJob_564194(
    name: "jobStreamListByJob", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobName}/streams",
    validator: validate_JobStreamListByJob_564195, base: "",
    url: url_JobStreamListByJob_564196, schemes: {Scheme.Https})
type
  Call_JobStreamGet_564208 = ref object of OpenApiRestCall_563556
proc url_JobStreamGet_564210(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "jobStreamId" in path, "`jobStreamId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/streams/"),
               (kind: VariableSegment, value: "jobStreamId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobStreamGet_564209(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the job stream identified by job stream id.
  ## 
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobStreamId: JString (required)
  ##              : The job stream id.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   jobName: JString (required)
  ##          : The job name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_564211 = path.getOrDefault("automationAccountName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "automationAccountName", valid_564211
  var valid_564212 = path.getOrDefault("subscriptionId")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "subscriptionId", valid_564212
  var valid_564213 = path.getOrDefault("jobStreamId")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "jobStreamId", valid_564213
  var valid_564214 = path.getOrDefault("resourceGroupName")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "resourceGroupName", valid_564214
  var valid_564215 = path.getOrDefault("jobName")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "jobName", valid_564215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564216 = query.getOrDefault("api-version")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "api-version", valid_564216
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_564217 = header.getOrDefault("clientRequestId")
  valid_564217 = validateParameter(valid_564217, JString, required = false,
                                 default = nil)
  if valid_564217 != nil:
    section.add "clientRequestId", valid_564217
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564218: Call_JobStreamGet_564208; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the job stream identified by job stream id.
  ## 
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  let valid = call_564218.validator(path, query, header, formData, body)
  let scheme = call_564218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564218.url(scheme.get, call_564218.host, call_564218.base,
                         call_564218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564218, url, valid)

proc call*(call_564219: Call_JobStreamGet_564208; apiVersion: string;
          automationAccountName: string; subscriptionId: string;
          jobStreamId: string; resourceGroupName: string; jobName: string): Recallable =
  ## jobStreamGet
  ## Retrieve the job stream identified by job stream id.
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobStreamId: string (required)
  ##              : The job stream id.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   jobName: string (required)
  ##          : The job name.
  var path_564220 = newJObject()
  var query_564221 = newJObject()
  add(query_564221, "api-version", newJString(apiVersion))
  add(path_564220, "automationAccountName", newJString(automationAccountName))
  add(path_564220, "subscriptionId", newJString(subscriptionId))
  add(path_564220, "jobStreamId", newJString(jobStreamId))
  add(path_564220, "resourceGroupName", newJString(resourceGroupName))
  add(path_564220, "jobName", newJString(jobName))
  result = call_564219.call(path_564220, query_564221, nil, nil, nil)

var jobStreamGet* = Call_JobStreamGet_564208(name: "jobStreamGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobName}/streams/{jobStreamId}",
    validator: validate_JobStreamGet_564209, base: "", url: url_JobStreamGet_564210,
    schemes: {Scheme.Https})
type
  Call_JobSuspend_564222 = ref object of OpenApiRestCall_563556
proc url_JobSuspend_564224(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/suspend")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobSuspend_564223(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Suspend the job identified by job name.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   jobName: JString (required)
  ##          : The job name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_564225 = path.getOrDefault("automationAccountName")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "automationAccountName", valid_564225
  var valid_564226 = path.getOrDefault("subscriptionId")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "subscriptionId", valid_564226
  var valid_564227 = path.getOrDefault("resourceGroupName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "resourceGroupName", valid_564227
  var valid_564228 = path.getOrDefault("jobName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "jobName", valid_564228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564229 = query.getOrDefault("api-version")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "api-version", valid_564229
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_564230 = header.getOrDefault("clientRequestId")
  valid_564230 = validateParameter(valid_564230, JString, required = false,
                                 default = nil)
  if valid_564230 != nil:
    section.add "clientRequestId", valid_564230
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564231: Call_JobSuspend_564222; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suspend the job identified by job name.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_564231.validator(path, query, header, formData, body)
  let scheme = call_564231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564231.url(scheme.get, call_564231.host, call_564231.base,
                         call_564231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564231, url, valid)

proc call*(call_564232: Call_JobSuspend_564222; apiVersion: string;
          automationAccountName: string; subscriptionId: string;
          resourceGroupName: string; jobName: string): Recallable =
  ## jobSuspend
  ## Suspend the job identified by job name.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   jobName: string (required)
  ##          : The job name.
  var path_564233 = newJObject()
  var query_564234 = newJObject()
  add(query_564234, "api-version", newJString(apiVersion))
  add(path_564233, "automationAccountName", newJString(automationAccountName))
  add(path_564233, "subscriptionId", newJString(subscriptionId))
  add(path_564233, "resourceGroupName", newJString(resourceGroupName))
  add(path_564233, "jobName", newJString(jobName))
  result = call_564232.call(path_564233, query_564234, nil, nil, nil)

var jobSuspend* = Call_JobSuspend_564222(name: "jobSuspend",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobName}/suspend",
                                      validator: validate_JobSuspend_564223,
                                      base: "", url: url_JobSuspend_564224,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
