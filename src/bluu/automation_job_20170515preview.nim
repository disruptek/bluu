
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_596848 = header.getOrDefault("clientRequestId")
  valid_596848 = validateParameter(valid_596848, JString, required = false,
                                 default = nil)
  if valid_596848 != nil:
    section.add "clientRequestId", valid_596848
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596875: Call_JobListByAutomationAccount_596680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a list of jobs.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_596875.validator(path, query, header, formData, body)
  let scheme = call_596875.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596875.url(scheme.get, call_596875.host, call_596875.base,
                         call_596875.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596875, url, valid)

proc call*(call_596946: Call_JobListByAutomationAccount_596680;
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
  var path_596947 = newJObject()
  var query_596949 = newJObject()
  add(path_596947, "automationAccountName", newJString(automationAccountName))
  add(path_596947, "resourceGroupName", newJString(resourceGroupName))
  add(query_596949, "api-version", newJString(apiVersion))
  add(path_596947, "subscriptionId", newJString(subscriptionId))
  add(query_596949, "$filter", newJString(Filter))
  result = call_596946.call(path_596947, query_596949, nil, nil, nil)

var jobListByAutomationAccount* = Call_JobListByAutomationAccount_596680(
    name: "jobListByAutomationAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs",
    validator: validate_JobListByAutomationAccount_596681, base: "",
    url: url_JobListByAutomationAccount_596682, schemes: {Scheme.Https})
type
  Call_JobCreate_597001 = ref object of OpenApiRestCall_596458
proc url_JobCreate_597003(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobCreate_597002(path: JsonNode; query: JsonNode; header: JsonNode;
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
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: JString (required)
  ##          : The job name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597030 = path.getOrDefault("automationAccountName")
  valid_597030 = validateParameter(valid_597030, JString, required = true,
                                 default = nil)
  if valid_597030 != nil:
    section.add "automationAccountName", valid_597030
  var valid_597031 = path.getOrDefault("resourceGroupName")
  valid_597031 = validateParameter(valid_597031, JString, required = true,
                                 default = nil)
  if valid_597031 != nil:
    section.add "resourceGroupName", valid_597031
  var valid_597032 = path.getOrDefault("subscriptionId")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = nil)
  if valid_597032 != nil:
    section.add "subscriptionId", valid_597032
  var valid_597033 = path.getOrDefault("jobName")
  valid_597033 = validateParameter(valid_597033, JString, required = true,
                                 default = nil)
  if valid_597033 != nil:
    section.add "jobName", valid_597033
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597034 = query.getOrDefault("api-version")
  valid_597034 = validateParameter(valid_597034, JString, required = true,
                                 default = nil)
  if valid_597034 != nil:
    section.add "api-version", valid_597034
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_597035 = header.getOrDefault("clientRequestId")
  valid_597035 = validateParameter(valid_597035, JString, required = false,
                                 default = nil)
  if valid_597035 != nil:
    section.add "clientRequestId", valid_597035
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

proc call*(call_597037: Call_JobCreate_597001; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a job of the runbook.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_597037.validator(path, query, header, formData, body)
  let scheme = call_597037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597037.url(scheme.get, call_597037.host, call_597037.base,
                         call_597037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597037, url, valid)

proc call*(call_597038: Call_JobCreate_597001; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string; parameters: JsonNode): Recallable =
  ## jobCreate
  ## Create a job of the runbook.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The job name.
  ##   parameters: JObject (required)
  ##             : The parameters supplied to the create job operation.
  var path_597039 = newJObject()
  var query_597040 = newJObject()
  var body_597041 = newJObject()
  add(path_597039, "automationAccountName", newJString(automationAccountName))
  add(path_597039, "resourceGroupName", newJString(resourceGroupName))
  add(query_597040, "api-version", newJString(apiVersion))
  add(path_597039, "subscriptionId", newJString(subscriptionId))
  add(path_597039, "jobName", newJString(jobName))
  if parameters != nil:
    body_597041 = parameters
  result = call_597038.call(path_597039, query_597040, nil, nil, body_597041)

var jobCreate* = Call_JobCreate_597001(name: "jobCreate", meth: HttpMethod.HttpPut,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobName}",
                                    validator: validate_JobCreate_597002,
                                    base: "", url: url_JobCreate_597003,
                                    schemes: {Scheme.Https})
type
  Call_JobGet_596988 = ref object of OpenApiRestCall_596458
proc url_JobGet_596990(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobGet_596989(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the job identified by job name.
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
  ##   jobName: JString (required)
  ##          : The job name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_596991 = path.getOrDefault("automationAccountName")
  valid_596991 = validateParameter(valid_596991, JString, required = true,
                                 default = nil)
  if valid_596991 != nil:
    section.add "automationAccountName", valid_596991
  var valid_596992 = path.getOrDefault("resourceGroupName")
  valid_596992 = validateParameter(valid_596992, JString, required = true,
                                 default = nil)
  if valid_596992 != nil:
    section.add "resourceGroupName", valid_596992
  var valid_596993 = path.getOrDefault("subscriptionId")
  valid_596993 = validateParameter(valid_596993, JString, required = true,
                                 default = nil)
  if valid_596993 != nil:
    section.add "subscriptionId", valid_596993
  var valid_596994 = path.getOrDefault("jobName")
  valid_596994 = validateParameter(valid_596994, JString, required = true,
                                 default = nil)
  if valid_596994 != nil:
    section.add "jobName", valid_596994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596995 = query.getOrDefault("api-version")
  valid_596995 = validateParameter(valid_596995, JString, required = true,
                                 default = nil)
  if valid_596995 != nil:
    section.add "api-version", valid_596995
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_596996 = header.getOrDefault("clientRequestId")
  valid_596996 = validateParameter(valid_596996, JString, required = false,
                                 default = nil)
  if valid_596996 != nil:
    section.add "clientRequestId", valid_596996
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596997: Call_JobGet_596988; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the job identified by job name.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_596997.validator(path, query, header, formData, body)
  let scheme = call_596997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596997.url(scheme.get, call_596997.host, call_596997.base,
                         call_596997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596997, url, valid)

proc call*(call_596998: Call_JobGet_596988; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string): Recallable =
  ## jobGet
  ## Retrieve the job identified by job name.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The job name.
  var path_596999 = newJObject()
  var query_597000 = newJObject()
  add(path_596999, "automationAccountName", newJString(automationAccountName))
  add(path_596999, "resourceGroupName", newJString(resourceGroupName))
  add(query_597000, "api-version", newJString(apiVersion))
  add(path_596999, "subscriptionId", newJString(subscriptionId))
  add(path_596999, "jobName", newJString(jobName))
  result = call_596998.call(path_596999, query_597000, nil, nil, nil)

var jobGet* = Call_JobGet_596988(name: "jobGet", meth: HttpMethod.HttpGet,
                              host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobName}",
                              validator: validate_JobGet_596989, base: "",
                              url: url_JobGet_596990, schemes: {Scheme.Https})
type
  Call_JobGetOutput_597042 = ref object of OpenApiRestCall_596458
proc url_JobGetOutput_597044(protocol: Scheme; host: string; base: string;
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

proc validate_JobGetOutput_597043(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the job output identified by job name.
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
  ##   jobName: JString (required)
  ##          : The name of the job to be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597045 = path.getOrDefault("automationAccountName")
  valid_597045 = validateParameter(valid_597045, JString, required = true,
                                 default = nil)
  if valid_597045 != nil:
    section.add "automationAccountName", valid_597045
  var valid_597046 = path.getOrDefault("resourceGroupName")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = nil)
  if valid_597046 != nil:
    section.add "resourceGroupName", valid_597046
  var valid_597047 = path.getOrDefault("subscriptionId")
  valid_597047 = validateParameter(valid_597047, JString, required = true,
                                 default = nil)
  if valid_597047 != nil:
    section.add "subscriptionId", valid_597047
  var valid_597048 = path.getOrDefault("jobName")
  valid_597048 = validateParameter(valid_597048, JString, required = true,
                                 default = nil)
  if valid_597048 != nil:
    section.add "jobName", valid_597048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597049 = query.getOrDefault("api-version")
  valid_597049 = validateParameter(valid_597049, JString, required = true,
                                 default = nil)
  if valid_597049 != nil:
    section.add "api-version", valid_597049
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_597050 = header.getOrDefault("clientRequestId")
  valid_597050 = validateParameter(valid_597050, JString, required = false,
                                 default = nil)
  if valid_597050 != nil:
    section.add "clientRequestId", valid_597050
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597051: Call_JobGetOutput_597042; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the job output identified by job name.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_597051.validator(path, query, header, formData, body)
  let scheme = call_597051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597051.url(scheme.get, call_597051.host, call_597051.base,
                         call_597051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597051, url, valid)

proc call*(call_597052: Call_JobGetOutput_597042; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string): Recallable =
  ## jobGetOutput
  ## Retrieve the job output identified by job name.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The name of the job to be created.
  var path_597053 = newJObject()
  var query_597054 = newJObject()
  add(path_597053, "automationAccountName", newJString(automationAccountName))
  add(path_597053, "resourceGroupName", newJString(resourceGroupName))
  add(query_597054, "api-version", newJString(apiVersion))
  add(path_597053, "subscriptionId", newJString(subscriptionId))
  add(path_597053, "jobName", newJString(jobName))
  result = call_597052.call(path_597053, query_597054, nil, nil, nil)

var jobGetOutput* = Call_JobGetOutput_597042(name: "jobGetOutput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobName}/output",
    validator: validate_JobGetOutput_597043, base: "", url: url_JobGetOutput_597044,
    schemes: {Scheme.Https})
type
  Call_JobResume_597055 = ref object of OpenApiRestCall_596458
proc url_JobResume_597057(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobResume_597056(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Resume the job identified by jobName.
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
  ##   jobName: JString (required)
  ##          : The job name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597058 = path.getOrDefault("automationAccountName")
  valid_597058 = validateParameter(valid_597058, JString, required = true,
                                 default = nil)
  if valid_597058 != nil:
    section.add "automationAccountName", valid_597058
  var valid_597059 = path.getOrDefault("resourceGroupName")
  valid_597059 = validateParameter(valid_597059, JString, required = true,
                                 default = nil)
  if valid_597059 != nil:
    section.add "resourceGroupName", valid_597059
  var valid_597060 = path.getOrDefault("subscriptionId")
  valid_597060 = validateParameter(valid_597060, JString, required = true,
                                 default = nil)
  if valid_597060 != nil:
    section.add "subscriptionId", valid_597060
  var valid_597061 = path.getOrDefault("jobName")
  valid_597061 = validateParameter(valid_597061, JString, required = true,
                                 default = nil)
  if valid_597061 != nil:
    section.add "jobName", valid_597061
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597062 = query.getOrDefault("api-version")
  valid_597062 = validateParameter(valid_597062, JString, required = true,
                                 default = nil)
  if valid_597062 != nil:
    section.add "api-version", valid_597062
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_597063 = header.getOrDefault("clientRequestId")
  valid_597063 = validateParameter(valid_597063, JString, required = false,
                                 default = nil)
  if valid_597063 != nil:
    section.add "clientRequestId", valid_597063
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597064: Call_JobResume_597055; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resume the job identified by jobName.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_597064.validator(path, query, header, formData, body)
  let scheme = call_597064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597064.url(scheme.get, call_597064.host, call_597064.base,
                         call_597064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597064, url, valid)

proc call*(call_597065: Call_JobResume_597055; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string): Recallable =
  ## jobResume
  ## Resume the job identified by jobName.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The job name.
  var path_597066 = newJObject()
  var query_597067 = newJObject()
  add(path_597066, "automationAccountName", newJString(automationAccountName))
  add(path_597066, "resourceGroupName", newJString(resourceGroupName))
  add(query_597067, "api-version", newJString(apiVersion))
  add(path_597066, "subscriptionId", newJString(subscriptionId))
  add(path_597066, "jobName", newJString(jobName))
  result = call_597065.call(path_597066, query_597067, nil, nil, nil)

var jobResume* = Call_JobResume_597055(name: "jobResume", meth: HttpMethod.HttpPost,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobName}/resume",
                                    validator: validate_JobResume_597056,
                                    base: "", url: url_JobResume_597057,
                                    schemes: {Scheme.Https})
type
  Call_JobGetRunbookContent_597068 = ref object of OpenApiRestCall_596458
proc url_JobGetRunbookContent_597070(protocol: Scheme; host: string; base: string;
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

proc validate_JobGetRunbookContent_597069(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the runbook content of the job identified by job name.
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
  ##   jobName: JString (required)
  ##          : The job name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597071 = path.getOrDefault("automationAccountName")
  valid_597071 = validateParameter(valid_597071, JString, required = true,
                                 default = nil)
  if valid_597071 != nil:
    section.add "automationAccountName", valid_597071
  var valid_597072 = path.getOrDefault("resourceGroupName")
  valid_597072 = validateParameter(valid_597072, JString, required = true,
                                 default = nil)
  if valid_597072 != nil:
    section.add "resourceGroupName", valid_597072
  var valid_597073 = path.getOrDefault("subscriptionId")
  valid_597073 = validateParameter(valid_597073, JString, required = true,
                                 default = nil)
  if valid_597073 != nil:
    section.add "subscriptionId", valid_597073
  var valid_597074 = path.getOrDefault("jobName")
  valid_597074 = validateParameter(valid_597074, JString, required = true,
                                 default = nil)
  if valid_597074 != nil:
    section.add "jobName", valid_597074
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597075 = query.getOrDefault("api-version")
  valid_597075 = validateParameter(valid_597075, JString, required = true,
                                 default = nil)
  if valid_597075 != nil:
    section.add "api-version", valid_597075
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_597076 = header.getOrDefault("clientRequestId")
  valid_597076 = validateParameter(valid_597076, JString, required = false,
                                 default = nil)
  if valid_597076 != nil:
    section.add "clientRequestId", valid_597076
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597077: Call_JobGetRunbookContent_597068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the runbook content of the job identified by job name.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_597077.validator(path, query, header, formData, body)
  let scheme = call_597077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597077.url(scheme.get, call_597077.host, call_597077.base,
                         call_597077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597077, url, valid)

proc call*(call_597078: Call_JobGetRunbookContent_597068;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string): Recallable =
  ## jobGetRunbookContent
  ## Retrieve the runbook content of the job identified by job name.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The job name.
  var path_597079 = newJObject()
  var query_597080 = newJObject()
  add(path_597079, "automationAccountName", newJString(automationAccountName))
  add(path_597079, "resourceGroupName", newJString(resourceGroupName))
  add(query_597080, "api-version", newJString(apiVersion))
  add(path_597079, "subscriptionId", newJString(subscriptionId))
  add(path_597079, "jobName", newJString(jobName))
  result = call_597078.call(path_597079, query_597080, nil, nil, nil)

var jobGetRunbookContent* = Call_JobGetRunbookContent_597068(
    name: "jobGetRunbookContent", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobName}/runbookContent",
    validator: validate_JobGetRunbookContent_597069, base: "",
    url: url_JobGetRunbookContent_597070, schemes: {Scheme.Https})
type
  Call_JobStop_597081 = ref object of OpenApiRestCall_596458
proc url_JobStop_597083(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobStop_597082(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Stop the job identified by jobName.
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
  ##   jobName: JString (required)
  ##          : The job name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597084 = path.getOrDefault("automationAccountName")
  valid_597084 = validateParameter(valid_597084, JString, required = true,
                                 default = nil)
  if valid_597084 != nil:
    section.add "automationAccountName", valid_597084
  var valid_597085 = path.getOrDefault("resourceGroupName")
  valid_597085 = validateParameter(valid_597085, JString, required = true,
                                 default = nil)
  if valid_597085 != nil:
    section.add "resourceGroupName", valid_597085
  var valid_597086 = path.getOrDefault("subscriptionId")
  valid_597086 = validateParameter(valid_597086, JString, required = true,
                                 default = nil)
  if valid_597086 != nil:
    section.add "subscriptionId", valid_597086
  var valid_597087 = path.getOrDefault("jobName")
  valid_597087 = validateParameter(valid_597087, JString, required = true,
                                 default = nil)
  if valid_597087 != nil:
    section.add "jobName", valid_597087
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597088 = query.getOrDefault("api-version")
  valid_597088 = validateParameter(valid_597088, JString, required = true,
                                 default = nil)
  if valid_597088 != nil:
    section.add "api-version", valid_597088
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_597089 = header.getOrDefault("clientRequestId")
  valid_597089 = validateParameter(valid_597089, JString, required = false,
                                 default = nil)
  if valid_597089 != nil:
    section.add "clientRequestId", valid_597089
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597090: Call_JobStop_597081; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop the job identified by jobName.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_597090.validator(path, query, header, formData, body)
  let scheme = call_597090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597090.url(scheme.get, call_597090.host, call_597090.base,
                         call_597090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597090, url, valid)

proc call*(call_597091: Call_JobStop_597081; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string): Recallable =
  ## jobStop
  ## Stop the job identified by jobName.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The job name.
  var path_597092 = newJObject()
  var query_597093 = newJObject()
  add(path_597092, "automationAccountName", newJString(automationAccountName))
  add(path_597092, "resourceGroupName", newJString(resourceGroupName))
  add(query_597093, "api-version", newJString(apiVersion))
  add(path_597092, "subscriptionId", newJString(subscriptionId))
  add(path_597092, "jobName", newJString(jobName))
  result = call_597091.call(path_597092, query_597093, nil, nil, nil)

var jobStop* = Call_JobStop_597081(name: "jobStop", meth: HttpMethod.HttpPost,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobName}/stop",
                                validator: validate_JobStop_597082, base: "",
                                url: url_JobStop_597083, schemes: {Scheme.Https})
type
  Call_JobStreamListByJob_597094 = ref object of OpenApiRestCall_596458
proc url_JobStreamListByJob_597096(protocol: Scheme; host: string; base: string;
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

proc validate_JobStreamListByJob_597095(path: JsonNode; query: JsonNode;
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
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: JString (required)
  ##          : The job name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597097 = path.getOrDefault("automationAccountName")
  valid_597097 = validateParameter(valid_597097, JString, required = true,
                                 default = nil)
  if valid_597097 != nil:
    section.add "automationAccountName", valid_597097
  var valid_597098 = path.getOrDefault("resourceGroupName")
  valid_597098 = validateParameter(valid_597098, JString, required = true,
                                 default = nil)
  if valid_597098 != nil:
    section.add "resourceGroupName", valid_597098
  var valid_597099 = path.getOrDefault("subscriptionId")
  valid_597099 = validateParameter(valid_597099, JString, required = true,
                                 default = nil)
  if valid_597099 != nil:
    section.add "subscriptionId", valid_597099
  var valid_597100 = path.getOrDefault("jobName")
  valid_597100 = validateParameter(valid_597100, JString, required = true,
                                 default = nil)
  if valid_597100 != nil:
    section.add "jobName", valid_597100
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597101 = query.getOrDefault("api-version")
  valid_597101 = validateParameter(valid_597101, JString, required = true,
                                 default = nil)
  if valid_597101 != nil:
    section.add "api-version", valid_597101
  var valid_597102 = query.getOrDefault("$filter")
  valid_597102 = validateParameter(valid_597102, JString, required = false,
                                 default = nil)
  if valid_597102 != nil:
    section.add "$filter", valid_597102
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_597103 = header.getOrDefault("clientRequestId")
  valid_597103 = validateParameter(valid_597103, JString, required = false,
                                 default = nil)
  if valid_597103 != nil:
    section.add "clientRequestId", valid_597103
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597104: Call_JobStreamListByJob_597094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a list of jobs streams identified by job name.
  ## 
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  let valid = call_597104.validator(path, query, header, formData, body)
  let scheme = call_597104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597104.url(scheme.get, call_597104.host, call_597104.base,
                         call_597104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597104, url, valid)

proc call*(call_597105: Call_JobStreamListByJob_597094;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          Filter: string = ""): Recallable =
  ## jobStreamListByJob
  ## Retrieve a list of jobs streams identified by job name.
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The job name.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_597106 = newJObject()
  var query_597107 = newJObject()
  add(path_597106, "automationAccountName", newJString(automationAccountName))
  add(path_597106, "resourceGroupName", newJString(resourceGroupName))
  add(query_597107, "api-version", newJString(apiVersion))
  add(path_597106, "subscriptionId", newJString(subscriptionId))
  add(path_597106, "jobName", newJString(jobName))
  add(query_597107, "$filter", newJString(Filter))
  result = call_597105.call(path_597106, query_597107, nil, nil, nil)

var jobStreamListByJob* = Call_JobStreamListByJob_597094(
    name: "jobStreamListByJob", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobName}/streams",
    validator: validate_JobStreamListByJob_597095, base: "",
    url: url_JobStreamListByJob_597096, schemes: {Scheme.Https})
type
  Call_JobStreamGet_597108 = ref object of OpenApiRestCall_596458
proc url_JobStreamGet_597110(protocol: Scheme; host: string; base: string;
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

proc validate_JobStreamGet_597109(path: JsonNode; query: JsonNode; header: JsonNode;
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
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: JString (required)
  ##          : The job name.
  ##   jobStreamId: JString (required)
  ##              : The job stream id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597111 = path.getOrDefault("automationAccountName")
  valid_597111 = validateParameter(valid_597111, JString, required = true,
                                 default = nil)
  if valid_597111 != nil:
    section.add "automationAccountName", valid_597111
  var valid_597112 = path.getOrDefault("resourceGroupName")
  valid_597112 = validateParameter(valid_597112, JString, required = true,
                                 default = nil)
  if valid_597112 != nil:
    section.add "resourceGroupName", valid_597112
  var valid_597113 = path.getOrDefault("subscriptionId")
  valid_597113 = validateParameter(valid_597113, JString, required = true,
                                 default = nil)
  if valid_597113 != nil:
    section.add "subscriptionId", valid_597113
  var valid_597114 = path.getOrDefault("jobName")
  valid_597114 = validateParameter(valid_597114, JString, required = true,
                                 default = nil)
  if valid_597114 != nil:
    section.add "jobName", valid_597114
  var valid_597115 = path.getOrDefault("jobStreamId")
  valid_597115 = validateParameter(valid_597115, JString, required = true,
                                 default = nil)
  if valid_597115 != nil:
    section.add "jobStreamId", valid_597115
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597116 = query.getOrDefault("api-version")
  valid_597116 = validateParameter(valid_597116, JString, required = true,
                                 default = nil)
  if valid_597116 != nil:
    section.add "api-version", valid_597116
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_597117 = header.getOrDefault("clientRequestId")
  valid_597117 = validateParameter(valid_597117, JString, required = false,
                                 default = nil)
  if valid_597117 != nil:
    section.add "clientRequestId", valid_597117
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597118: Call_JobStreamGet_597108; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the job stream identified by job stream id.
  ## 
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  let valid = call_597118.validator(path, query, header, formData, body)
  let scheme = call_597118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597118.url(scheme.get, call_597118.host, call_597118.base,
                         call_597118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597118, url, valid)

proc call*(call_597119: Call_JobStreamGet_597108; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string; jobStreamId: string): Recallable =
  ## jobStreamGet
  ## Retrieve the job stream identified by job stream id.
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The job name.
  ##   jobStreamId: string (required)
  ##              : The job stream id.
  var path_597120 = newJObject()
  var query_597121 = newJObject()
  add(path_597120, "automationAccountName", newJString(automationAccountName))
  add(path_597120, "resourceGroupName", newJString(resourceGroupName))
  add(query_597121, "api-version", newJString(apiVersion))
  add(path_597120, "subscriptionId", newJString(subscriptionId))
  add(path_597120, "jobName", newJString(jobName))
  add(path_597120, "jobStreamId", newJString(jobStreamId))
  result = call_597119.call(path_597120, query_597121, nil, nil, nil)

var jobStreamGet* = Call_JobStreamGet_597108(name: "jobStreamGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobName}/streams/{jobStreamId}",
    validator: validate_JobStreamGet_597109, base: "", url: url_JobStreamGet_597110,
    schemes: {Scheme.Https})
type
  Call_JobSuspend_597122 = ref object of OpenApiRestCall_596458
proc url_JobSuspend_597124(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobSuspend_597123(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Suspend the job identified by job name.
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
  ##   jobName: JString (required)
  ##          : The job name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597125 = path.getOrDefault("automationAccountName")
  valid_597125 = validateParameter(valid_597125, JString, required = true,
                                 default = nil)
  if valid_597125 != nil:
    section.add "automationAccountName", valid_597125
  var valid_597126 = path.getOrDefault("resourceGroupName")
  valid_597126 = validateParameter(valid_597126, JString, required = true,
                                 default = nil)
  if valid_597126 != nil:
    section.add "resourceGroupName", valid_597126
  var valid_597127 = path.getOrDefault("subscriptionId")
  valid_597127 = validateParameter(valid_597127, JString, required = true,
                                 default = nil)
  if valid_597127 != nil:
    section.add "subscriptionId", valid_597127
  var valid_597128 = path.getOrDefault("jobName")
  valid_597128 = validateParameter(valid_597128, JString, required = true,
                                 default = nil)
  if valid_597128 != nil:
    section.add "jobName", valid_597128
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597129 = query.getOrDefault("api-version")
  valid_597129 = validateParameter(valid_597129, JString, required = true,
                                 default = nil)
  if valid_597129 != nil:
    section.add "api-version", valid_597129
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_597130 = header.getOrDefault("clientRequestId")
  valid_597130 = validateParameter(valid_597130, JString, required = false,
                                 default = nil)
  if valid_597130 != nil:
    section.add "clientRequestId", valid_597130
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597131: Call_JobSuspend_597122; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suspend the job identified by job name.
  ## 
  ## http://aka.ms/azureautomationsdk/joboperations
  let valid = call_597131.validator(path, query, header, formData, body)
  let scheme = call_597131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597131.url(scheme.get, call_597131.host, call_597131.base,
                         call_597131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597131, url, valid)

proc call*(call_597132: Call_JobSuspend_597122; automationAccountName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string): Recallable =
  ## jobSuspend
  ## Suspend the job identified by job name.
  ## http://aka.ms/azureautomationsdk/joboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The job name.
  var path_597133 = newJObject()
  var query_597134 = newJObject()
  add(path_597133, "automationAccountName", newJString(automationAccountName))
  add(path_597133, "resourceGroupName", newJString(resourceGroupName))
  add(query_597134, "api-version", newJString(apiVersion))
  add(path_597133, "subscriptionId", newJString(subscriptionId))
  add(path_597133, "jobName", newJString(jobName))
  result = call_597132.call(path_597133, query_597134, nil, nil, nil)

var jobSuspend* = Call_JobSuspend_597122(name: "jobSuspend",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobs/{jobName}/suspend",
                                      validator: validate_JobSuspend_597123,
                                      base: "", url: url_JobSuspend_597124,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
