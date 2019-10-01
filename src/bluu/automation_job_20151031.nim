
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AutomationManagement
## version: 2015-10-31
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

  OpenApiRestCall_596458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596458): Option[Scheme] {.used.} =
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
  macServiceName = "automation-job"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_JobListByAutomationAccount_596680 = ref object of OpenApiRestCall_596458
proc url_JobListByAutomationAccount_596682(protocol: Scheme; host: string;
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

proc validate_JobListByAutomationAccount_596681(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of jobs.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_596843 = path.getOrDefault("automationAccountName")
  valid_596843 = validateParameter(valid_596843, JString, required = true,
                                 default = nil)
  if valid_596843 != nil:
    section.add "automationAccountName", valid_596843
  var valid_596844 = path.getOrDefault("resourceGroupName")
  valid_596844 = validateParameter(valid_596844, JString, required = true,
                                 default = nil)
  if valid_596844 != nil:
    section.add "resourceGroupName", valid_596844
  var valid_596845 = path.getOrDefault("subscriptionId")
  valid_596845 = validateParameter(valid_596845, JString, required = true,
                                 default = nil)
  if valid_596845 != nil:
    section.add "subscriptionId", valid_596845
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596846 = query.getOrDefault("api-version")
  valid_596846 = validateParameter(valid_596846, JString, required = true,
                                 default = nil)
  if valid_596846 != nil:
    section.add "api-version", valid_596846
  var valid_596847 = query.getOrDefault("$filter")
  valid_596847 = validateParameter(valid_596847, JString, required = false,
                                 default = nil)
  if valid_596847 != nil:
    section.add "$filter", valid_596847
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596874: Call_JobListByAutomationAccount_596680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a list of jobs.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_596874.validator(path, query, header, formData, body)
  let scheme = call_596874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596874.url(scheme.get, call_596874.host, call_596874.base,
                         call_596874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596874, url, valid)

proc call*(call_596945: Call_JobListByAutomationAccount_596680;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## jobListByAutomationAccount
  ## Retrieve a list of jobs.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_596946 = newJObject()
  var query_596948 = newJObject()
  add(path_596946, "automationAccountName", newJString(automationAccountName))
  add(path_596946, "resourceGroupName", newJString(resourceGroupName))
  add(query_596948, "api-version", newJString(apiVersion))
  add(path_596946, "subscriptionId", newJString(subscriptionId))
  add(query_596948, "$filter", newJString(Filter))
  result = call_596945.call(path_596946, query_596948, nil, nil, nil)

var jobListByAutomationAccount* = Call_JobListByAutomationAccount_596680(
    name: "jobListByAutomationAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs",
    validator: validate_JobListByAutomationAccount_596681, base: "",
    url: url_JobListByAutomationAccount_596682, schemes: {Scheme.Https})
type
  Call_JobCreate_596999 = ref object of OpenApiRestCall_596458
proc url_JobCreate_597001(protocol: Scheme; host: string; base: string; route: string;
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
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobCreate_597000(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a job of the runbook.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   jobId: JString (required)
  ##        : The job id.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597028 = path.getOrDefault("automationAccountName")
  valid_597028 = validateParameter(valid_597028, JString, required = true,
                                 default = nil)
  if valid_597028 != nil:
    section.add "automationAccountName", valid_597028
  var valid_597029 = path.getOrDefault("resourceGroupName")
  valid_597029 = validateParameter(valid_597029, JString, required = true,
                                 default = nil)
  if valid_597029 != nil:
    section.add "resourceGroupName", valid_597029
  var valid_597030 = path.getOrDefault("jobId")
  valid_597030 = validateParameter(valid_597030, JString, required = true,
                                 default = nil)
  if valid_597030 != nil:
    section.add "jobId", valid_597030
  var valid_597031 = path.getOrDefault("subscriptionId")
  valid_597031 = validateParameter(valid_597031, JString, required = true,
                                 default = nil)
  if valid_597031 != nil:
    section.add "subscriptionId", valid_597031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597032 = query.getOrDefault("api-version")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = nil)
  if valid_597032 != nil:
    section.add "api-version", valid_597032
  result.add "query", section
  section = newJObject()
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

proc call*(call_597034: Call_JobCreate_596999; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a job of the runbook.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_597034.validator(path, query, header, formData, body)
  let scheme = call_597034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597034.url(scheme.get, call_597034.host, call_597034.base,
                         call_597034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597034, url, valid)

proc call*(call_597035: Call_JobCreate_596999; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; jobId: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## jobCreate
  ## Create a job of the runbook.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobId: string (required)
  ##        : The job id.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The parameters supplied to the create job operation.
  var path_597036 = newJObject()
  var query_597037 = newJObject()
  var body_597038 = newJObject()
  add(path_597036, "automationAccountName", newJString(automationAccountName))
  add(path_597036, "resourceGroupName", newJString(resourceGroupName))
  add(query_597037, "api-version", newJString(apiVersion))
  add(path_597036, "jobId", newJString(jobId))
  add(path_597036, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597038 = parameters
  result = call_597035.call(path_597036, query_597037, nil, nil, body_597038)

var jobCreate* = Call_JobCreate_596999(name: "jobCreate", meth: HttpMethod.HttpPut,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobId}",
                                    validator: validate_JobCreate_597000,
                                    base: "", url: url_JobCreate_597001,
                                    schemes: {Scheme.Https})
type
  Call_JobGet_596987 = ref object of OpenApiRestCall_596458
proc url_JobGet_596989(protocol: Scheme; host: string; base: string; route: string;
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
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobGet_596988(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the job identified by job id.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   jobId: JString (required)
  ##        : The job id.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_596990 = path.getOrDefault("automationAccountName")
  valid_596990 = validateParameter(valid_596990, JString, required = true,
                                 default = nil)
  if valid_596990 != nil:
    section.add "automationAccountName", valid_596990
  var valid_596991 = path.getOrDefault("resourceGroupName")
  valid_596991 = validateParameter(valid_596991, JString, required = true,
                                 default = nil)
  if valid_596991 != nil:
    section.add "resourceGroupName", valid_596991
  var valid_596992 = path.getOrDefault("jobId")
  valid_596992 = validateParameter(valid_596992, JString, required = true,
                                 default = nil)
  if valid_596992 != nil:
    section.add "jobId", valid_596992
  var valid_596993 = path.getOrDefault("subscriptionId")
  valid_596993 = validateParameter(valid_596993, JString, required = true,
                                 default = nil)
  if valid_596993 != nil:
    section.add "subscriptionId", valid_596993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596994 = query.getOrDefault("api-version")
  valid_596994 = validateParameter(valid_596994, JString, required = true,
                                 default = nil)
  if valid_596994 != nil:
    section.add "api-version", valid_596994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596995: Call_JobGet_596987; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the job identified by job id.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_596995.validator(path, query, header, formData, body)
  let scheme = call_596995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596995.url(scheme.get, call_596995.host, call_596995.base,
                         call_596995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596995, url, valid)

proc call*(call_596996: Call_JobGet_596987; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; jobId: string;
          subscriptionId: string): Recallable =
  ## jobGet
  ## Retrieve the job identified by job id.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobId: string (required)
  ##        : The job id.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_596997 = newJObject()
  var query_596998 = newJObject()
  add(path_596997, "automationAccountName", newJString(automationAccountName))
  add(path_596997, "resourceGroupName", newJString(resourceGroupName))
  add(query_596998, "api-version", newJString(apiVersion))
  add(path_596997, "jobId", newJString(jobId))
  add(path_596997, "subscriptionId", newJString(subscriptionId))
  result = call_596996.call(path_596997, query_596998, nil, nil, nil)

var jobGet* = Call_JobGet_596987(name: "jobGet", meth: HttpMethod.HttpGet,
                              host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobId}",
                              validator: validate_JobGet_596988, base: "",
                              url: url_JobGet_596989, schemes: {Scheme.Https})
type
  Call_JobGetOutput_597039 = ref object of OpenApiRestCall_596458
proc url_JobGetOutput_597041(protocol: Scheme; host: string; base: string;
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
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/output")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobGetOutput_597040(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the job output identified by job id.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   jobId: JString (required)
  ##        : The job id.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597042 = path.getOrDefault("automationAccountName")
  valid_597042 = validateParameter(valid_597042, JString, required = true,
                                 default = nil)
  if valid_597042 != nil:
    section.add "automationAccountName", valid_597042
  var valid_597043 = path.getOrDefault("resourceGroupName")
  valid_597043 = validateParameter(valid_597043, JString, required = true,
                                 default = nil)
  if valid_597043 != nil:
    section.add "resourceGroupName", valid_597043
  var valid_597044 = path.getOrDefault("jobId")
  valid_597044 = validateParameter(valid_597044, JString, required = true,
                                 default = nil)
  if valid_597044 != nil:
    section.add "jobId", valid_597044
  var valid_597045 = path.getOrDefault("subscriptionId")
  valid_597045 = validateParameter(valid_597045, JString, required = true,
                                 default = nil)
  if valid_597045 != nil:
    section.add "subscriptionId", valid_597045
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597046 = query.getOrDefault("api-version")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = nil)
  if valid_597046 != nil:
    section.add "api-version", valid_597046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597047: Call_JobGetOutput_597039; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the job output identified by job id.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_597047.validator(path, query, header, formData, body)
  let scheme = call_597047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597047.url(scheme.get, call_597047.host, call_597047.base,
                         call_597047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597047, url, valid)

proc call*(call_597048: Call_JobGetOutput_597039; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; jobId: string;
          subscriptionId: string): Recallable =
  ## jobGetOutput
  ## Retrieve the job output identified by job id.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobId: string (required)
  ##        : The job id.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597049 = newJObject()
  var query_597050 = newJObject()
  add(path_597049, "automationAccountName", newJString(automationAccountName))
  add(path_597049, "resourceGroupName", newJString(resourceGroupName))
  add(query_597050, "api-version", newJString(apiVersion))
  add(path_597049, "jobId", newJString(jobId))
  add(path_597049, "subscriptionId", newJString(subscriptionId))
  result = call_597048.call(path_597049, query_597050, nil, nil, nil)

var jobGetOutput* = Call_JobGetOutput_597039(name: "jobGetOutput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobId}/output",
    validator: validate_JobGetOutput_597040, base: "", url: url_JobGetOutput_597041,
    schemes: {Scheme.Https})
type
  Call_JobResume_597051 = ref object of OpenApiRestCall_596458
proc url_JobResume_597053(protocol: Scheme; host: string; base: string; route: string;
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
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/resume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobResume_597052(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Resume the job identified by jobId.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   jobId: JString (required)
  ##        : The job id.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597054 = path.getOrDefault("automationAccountName")
  valid_597054 = validateParameter(valid_597054, JString, required = true,
                                 default = nil)
  if valid_597054 != nil:
    section.add "automationAccountName", valid_597054
  var valid_597055 = path.getOrDefault("resourceGroupName")
  valid_597055 = validateParameter(valid_597055, JString, required = true,
                                 default = nil)
  if valid_597055 != nil:
    section.add "resourceGroupName", valid_597055
  var valid_597056 = path.getOrDefault("jobId")
  valid_597056 = validateParameter(valid_597056, JString, required = true,
                                 default = nil)
  if valid_597056 != nil:
    section.add "jobId", valid_597056
  var valid_597057 = path.getOrDefault("subscriptionId")
  valid_597057 = validateParameter(valid_597057, JString, required = true,
                                 default = nil)
  if valid_597057 != nil:
    section.add "subscriptionId", valid_597057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597058 = query.getOrDefault("api-version")
  valid_597058 = validateParameter(valid_597058, JString, required = true,
                                 default = nil)
  if valid_597058 != nil:
    section.add "api-version", valid_597058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597059: Call_JobResume_597051; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resume the job identified by jobId.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_597059.validator(path, query, header, formData, body)
  let scheme = call_597059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597059.url(scheme.get, call_597059.host, call_597059.base,
                         call_597059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597059, url, valid)

proc call*(call_597060: Call_JobResume_597051; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; jobId: string;
          subscriptionId: string): Recallable =
  ## jobResume
  ## Resume the job identified by jobId.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobId: string (required)
  ##        : The job id.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597061 = newJObject()
  var query_597062 = newJObject()
  add(path_597061, "automationAccountName", newJString(automationAccountName))
  add(path_597061, "resourceGroupName", newJString(resourceGroupName))
  add(query_597062, "api-version", newJString(apiVersion))
  add(path_597061, "jobId", newJString(jobId))
  add(path_597061, "subscriptionId", newJString(subscriptionId))
  result = call_597060.call(path_597061, query_597062, nil, nil, nil)

var jobResume* = Call_JobResume_597051(name: "jobResume", meth: HttpMethod.HttpPost,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobId}/resume",
                                    validator: validate_JobResume_597052,
                                    base: "", url: url_JobResume_597053,
                                    schemes: {Scheme.Https})
type
  Call_JobGetRunbookContent_597063 = ref object of OpenApiRestCall_596458
proc url_JobGetRunbookContent_597065(protocol: Scheme; host: string; base: string;
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
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/runbookContent")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobGetRunbookContent_597064(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the runbook content of the job identified by job id.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   jobId: JString (required)
  ##        : The job id.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597066 = path.getOrDefault("automationAccountName")
  valid_597066 = validateParameter(valid_597066, JString, required = true,
                                 default = nil)
  if valid_597066 != nil:
    section.add "automationAccountName", valid_597066
  var valid_597067 = path.getOrDefault("resourceGroupName")
  valid_597067 = validateParameter(valid_597067, JString, required = true,
                                 default = nil)
  if valid_597067 != nil:
    section.add "resourceGroupName", valid_597067
  var valid_597068 = path.getOrDefault("jobId")
  valid_597068 = validateParameter(valid_597068, JString, required = true,
                                 default = nil)
  if valid_597068 != nil:
    section.add "jobId", valid_597068
  var valid_597069 = path.getOrDefault("subscriptionId")
  valid_597069 = validateParameter(valid_597069, JString, required = true,
                                 default = nil)
  if valid_597069 != nil:
    section.add "subscriptionId", valid_597069
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597070 = query.getOrDefault("api-version")
  valid_597070 = validateParameter(valid_597070, JString, required = true,
                                 default = nil)
  if valid_597070 != nil:
    section.add "api-version", valid_597070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597071: Call_JobGetRunbookContent_597063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the runbook content of the job identified by job id.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_597071.validator(path, query, header, formData, body)
  let scheme = call_597071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597071.url(scheme.get, call_597071.host, call_597071.base,
                         call_597071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597071, url, valid)

proc call*(call_597072: Call_JobGetRunbookContent_597063;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; jobId: string; subscriptionId: string): Recallable =
  ## jobGetRunbookContent
  ## Retrieve the runbook content of the job identified by job id.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobId: string (required)
  ##        : The job id.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597073 = newJObject()
  var query_597074 = newJObject()
  add(path_597073, "automationAccountName", newJString(automationAccountName))
  add(path_597073, "resourceGroupName", newJString(resourceGroupName))
  add(query_597074, "api-version", newJString(apiVersion))
  add(path_597073, "jobId", newJString(jobId))
  add(path_597073, "subscriptionId", newJString(subscriptionId))
  result = call_597072.call(path_597073, query_597074, nil, nil, nil)

var jobGetRunbookContent* = Call_JobGetRunbookContent_597063(
    name: "jobGetRunbookContent", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobId}/runbookContent",
    validator: validate_JobGetRunbookContent_597064, base: "",
    url: url_JobGetRunbookContent_597065, schemes: {Scheme.Https})
type
  Call_JobStop_597075 = ref object of OpenApiRestCall_596458
proc url_JobStop_597077(protocol: Scheme; host: string; base: string; route: string;
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
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobStop_597076(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Stop the job identified by jobId.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   jobId: JString (required)
  ##        : The job id.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597078 = path.getOrDefault("automationAccountName")
  valid_597078 = validateParameter(valid_597078, JString, required = true,
                                 default = nil)
  if valid_597078 != nil:
    section.add "automationAccountName", valid_597078
  var valid_597079 = path.getOrDefault("resourceGroupName")
  valid_597079 = validateParameter(valid_597079, JString, required = true,
                                 default = nil)
  if valid_597079 != nil:
    section.add "resourceGroupName", valid_597079
  var valid_597080 = path.getOrDefault("jobId")
  valid_597080 = validateParameter(valid_597080, JString, required = true,
                                 default = nil)
  if valid_597080 != nil:
    section.add "jobId", valid_597080
  var valid_597081 = path.getOrDefault("subscriptionId")
  valid_597081 = validateParameter(valid_597081, JString, required = true,
                                 default = nil)
  if valid_597081 != nil:
    section.add "subscriptionId", valid_597081
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597082 = query.getOrDefault("api-version")
  valid_597082 = validateParameter(valid_597082, JString, required = true,
                                 default = nil)
  if valid_597082 != nil:
    section.add "api-version", valid_597082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597083: Call_JobStop_597075; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop the job identified by jobId.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_597083.validator(path, query, header, formData, body)
  let scheme = call_597083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597083.url(scheme.get, call_597083.host, call_597083.base,
                         call_597083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597083, url, valid)

proc call*(call_597084: Call_JobStop_597075; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; jobId: string;
          subscriptionId: string): Recallable =
  ## jobStop
  ## Stop the job identified by jobId.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobId: string (required)
  ##        : The job id.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597085 = newJObject()
  var query_597086 = newJObject()
  add(path_597085, "automationAccountName", newJString(automationAccountName))
  add(path_597085, "resourceGroupName", newJString(resourceGroupName))
  add(query_597086, "api-version", newJString(apiVersion))
  add(path_597085, "jobId", newJString(jobId))
  add(path_597085, "subscriptionId", newJString(subscriptionId))
  result = call_597084.call(path_597085, query_597086, nil, nil, nil)

var jobStop* = Call_JobStop_597075(name: "jobStop", meth: HttpMethod.HttpPost,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobId}/stop",
                                validator: validate_JobStop_597076, base: "",
                                url: url_JobStop_597077, schemes: {Scheme.Https})
type
  Call_JobStreamListByJob_597087 = ref object of OpenApiRestCall_596458
proc url_JobStreamListByJob_597089(protocol: Scheme; host: string; base: string;
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
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/streams")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobStreamListByJob_597088(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieve a list of jobs streams identified by job id.
  ## 
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   jobId: JString (required)
  ##        : The job Id.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597090 = path.getOrDefault("automationAccountName")
  valid_597090 = validateParameter(valid_597090, JString, required = true,
                                 default = nil)
  if valid_597090 != nil:
    section.add "automationAccountName", valid_597090
  var valid_597091 = path.getOrDefault("resourceGroupName")
  valid_597091 = validateParameter(valid_597091, JString, required = true,
                                 default = nil)
  if valid_597091 != nil:
    section.add "resourceGroupName", valid_597091
  var valid_597092 = path.getOrDefault("jobId")
  valid_597092 = validateParameter(valid_597092, JString, required = true,
                                 default = nil)
  if valid_597092 != nil:
    section.add "jobId", valid_597092
  var valid_597093 = path.getOrDefault("subscriptionId")
  valid_597093 = validateParameter(valid_597093, JString, required = true,
                                 default = nil)
  if valid_597093 != nil:
    section.add "subscriptionId", valid_597093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597094 = query.getOrDefault("api-version")
  valid_597094 = validateParameter(valid_597094, JString, required = true,
                                 default = nil)
  if valid_597094 != nil:
    section.add "api-version", valid_597094
  var valid_597095 = query.getOrDefault("$filter")
  valid_597095 = validateParameter(valid_597095, JString, required = false,
                                 default = nil)
  if valid_597095 != nil:
    section.add "$filter", valid_597095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597096: Call_JobStreamListByJob_597087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a list of jobs streams identified by job id.
  ## 
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  let valid = call_597096.validator(path, query, header, formData, body)
  let scheme = call_597096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597096.url(scheme.get, call_597096.host, call_597096.base,
                         call_597096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597096, url, valid)

proc call*(call_597097: Call_JobStreamListByJob_597087;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; jobId: string; subscriptionId: string;
          Filter: string = ""): Recallable =
  ## jobStreamListByJob
  ## Retrieve a list of jobs streams identified by job id.
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobId: string (required)
  ##        : The job Id.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_597098 = newJObject()
  var query_597099 = newJObject()
  add(path_597098, "automationAccountName", newJString(automationAccountName))
  add(path_597098, "resourceGroupName", newJString(resourceGroupName))
  add(query_597099, "api-version", newJString(apiVersion))
  add(path_597098, "jobId", newJString(jobId))
  add(path_597098, "subscriptionId", newJString(subscriptionId))
  add(query_597099, "$filter", newJString(Filter))
  result = call_597097.call(path_597098, query_597099, nil, nil, nil)

var jobStreamListByJob* = Call_JobStreamListByJob_597087(
    name: "jobStreamListByJob", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobId}/streams",
    validator: validate_JobStreamListByJob_597088, base: "",
    url: url_JobStreamListByJob_597089, schemes: {Scheme.Https})
type
  Call_JobStreamGet_597100 = ref object of OpenApiRestCall_596458
proc url_JobStreamGet_597102(protocol: Scheme; host: string; base: string;
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
  assert "jobId" in path, "`jobId` is a required path parameter"
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
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/streams/"),
               (kind: VariableSegment, value: "jobStreamId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobStreamGet_597101(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the job stream identified by job stream id.
  ## 
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   jobId: JString (required)
  ##        : The job id.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobStreamId: JString (required)
  ##              : The job stream id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597103 = path.getOrDefault("automationAccountName")
  valid_597103 = validateParameter(valid_597103, JString, required = true,
                                 default = nil)
  if valid_597103 != nil:
    section.add "automationAccountName", valid_597103
  var valid_597104 = path.getOrDefault("resourceGroupName")
  valid_597104 = validateParameter(valid_597104, JString, required = true,
                                 default = nil)
  if valid_597104 != nil:
    section.add "resourceGroupName", valid_597104
  var valid_597105 = path.getOrDefault("jobId")
  valid_597105 = validateParameter(valid_597105, JString, required = true,
                                 default = nil)
  if valid_597105 != nil:
    section.add "jobId", valid_597105
  var valid_597106 = path.getOrDefault("subscriptionId")
  valid_597106 = validateParameter(valid_597106, JString, required = true,
                                 default = nil)
  if valid_597106 != nil:
    section.add "subscriptionId", valid_597106
  var valid_597107 = path.getOrDefault("jobStreamId")
  valid_597107 = validateParameter(valid_597107, JString, required = true,
                                 default = nil)
  if valid_597107 != nil:
    section.add "jobStreamId", valid_597107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597108 = query.getOrDefault("api-version")
  valid_597108 = validateParameter(valid_597108, JString, required = true,
                                 default = nil)
  if valid_597108 != nil:
    section.add "api-version", valid_597108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597109: Call_JobStreamGet_597100; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the job stream identified by job stream id.
  ## 
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  let valid = call_597109.validator(path, query, header, formData, body)
  let scheme = call_597109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597109.url(scheme.get, call_597109.host, call_597109.base,
                         call_597109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597109, url, valid)

proc call*(call_597110: Call_JobStreamGet_597100; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; jobId: string;
          subscriptionId: string; jobStreamId: string): Recallable =
  ## jobStreamGet
  ## Retrieve the job stream identified by job stream id.
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobId: string (required)
  ##        : The job id.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobStreamId: string (required)
  ##              : The job stream id.
  var path_597111 = newJObject()
  var query_597112 = newJObject()
  add(path_597111, "automationAccountName", newJString(automationAccountName))
  add(path_597111, "resourceGroupName", newJString(resourceGroupName))
  add(query_597112, "api-version", newJString(apiVersion))
  add(path_597111, "jobId", newJString(jobId))
  add(path_597111, "subscriptionId", newJString(subscriptionId))
  add(path_597111, "jobStreamId", newJString(jobStreamId))
  result = call_597110.call(path_597111, query_597112, nil, nil, nil)

var jobStreamGet* = Call_JobStreamGet_597100(name: "jobStreamGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobId}/streams/{jobStreamId}",
    validator: validate_JobStreamGet_597101, base: "", url: url_JobStreamGet_597102,
    schemes: {Scheme.Https})
type
  Call_JobSuspend_597113 = ref object of OpenApiRestCall_596458
proc url_JobSuspend_597115(protocol: Scheme; host: string; base: string; route: string;
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
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/suspend")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobSuspend_597114(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Suspend the job identified by jobId.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   jobId: JString (required)
  ##        : The job id.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597116 = path.getOrDefault("automationAccountName")
  valid_597116 = validateParameter(valid_597116, JString, required = true,
                                 default = nil)
  if valid_597116 != nil:
    section.add "automationAccountName", valid_597116
  var valid_597117 = path.getOrDefault("resourceGroupName")
  valid_597117 = validateParameter(valid_597117, JString, required = true,
                                 default = nil)
  if valid_597117 != nil:
    section.add "resourceGroupName", valid_597117
  var valid_597118 = path.getOrDefault("jobId")
  valid_597118 = validateParameter(valid_597118, JString, required = true,
                                 default = nil)
  if valid_597118 != nil:
    section.add "jobId", valid_597118
  var valid_597119 = path.getOrDefault("subscriptionId")
  valid_597119 = validateParameter(valid_597119, JString, required = true,
                                 default = nil)
  if valid_597119 != nil:
    section.add "subscriptionId", valid_597119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597120 = query.getOrDefault("api-version")
  valid_597120 = validateParameter(valid_597120, JString, required = true,
                                 default = nil)
  if valid_597120 != nil:
    section.add "api-version", valid_597120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597121: Call_JobSuspend_597113; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suspend the job identified by jobId.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_597121.validator(path, query, header, formData, body)
  let scheme = call_597121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597121.url(scheme.get, call_597121.host, call_597121.base,
                         call_597121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597121, url, valid)

proc call*(call_597122: Call_JobSuspend_597113; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; jobId: string;
          subscriptionId: string): Recallable =
  ## jobSuspend
  ## Suspend the job identified by jobId.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   jobId: string (required)
  ##        : The job id.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597123 = newJObject()
  var query_597124 = newJObject()
  add(path_597123, "automationAccountName", newJString(automationAccountName))
  add(path_597123, "resourceGroupName", newJString(resourceGroupName))
  add(query_597124, "api-version", newJString(apiVersion))
  add(path_597123, "jobId", newJString(jobId))
  add(path_597123, "subscriptionId", newJString(subscriptionId))
  result = call_597122.call(path_597123, query_597124, nil, nil, nil)

var jobSuspend* = Call_JobSuspend_597113(name: "jobSuspend",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobId}/suspend",
                                      validator: validate_JobSuspend_597114,
                                      base: "", url: url_JobSuspend_597115,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
