
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
  macServiceName = "automation-jobSchedule"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_JobScheduleListByAutomationAccount_596680 = ref object of OpenApiRestCall_596458
proc url_JobScheduleListByAutomationAccount_596682(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/jobSchedules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobScheduleListByAutomationAccount_596681(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of job schedules.
  ## 
  ## http://aka.ms/azureautomationsdk/jobscheduleoperations
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

proc call*(call_596874: Call_JobScheduleListByAutomationAccount_596680;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve a list of job schedules.
  ## 
  ## http://aka.ms/azureautomationsdk/jobscheduleoperations
  let valid = call_596874.validator(path, query, header, formData, body)
  let scheme = call_596874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596874.url(scheme.get, call_596874.host, call_596874.base,
                         call_596874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596874, url, valid)

proc call*(call_596945: Call_JobScheduleListByAutomationAccount_596680;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## jobScheduleListByAutomationAccount
  ## Retrieve a list of job schedules.
  ## http://aka.ms/azureautomationsdk/jobscheduleoperations
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

var jobScheduleListByAutomationAccount* = Call_JobScheduleListByAutomationAccount_596680(
    name: "jobScheduleListByAutomationAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobSchedules",
    validator: validate_JobScheduleListByAutomationAccount_596681, base: "",
    url: url_JobScheduleListByAutomationAccount_596682, schemes: {Scheme.Https})
type
  Call_JobScheduleCreate_596999 = ref object of OpenApiRestCall_596458
proc url_JobScheduleCreate_597001(protocol: Scheme; host: string; base: string;
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
  assert "jobScheduleId" in path, "`jobScheduleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobSchedules/"),
               (kind: VariableSegment, value: "jobScheduleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobScheduleCreate_597000(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Create a job schedule.
  ## 
  ## http://aka.ms/azureautomationsdk/jobscheduleoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   jobScheduleId: JString (required)
  ##                : The job schedule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597028 = path.getOrDefault("automationAccountName")
  valid_597028 = validateParameter(valid_597028, JString, required = true,
                                 default = nil)
  if valid_597028 != nil:
    section.add "automationAccountName", valid_597028
  var valid_597029 = path.getOrDefault("jobScheduleId")
  valid_597029 = validateParameter(valid_597029, JString, required = true,
                                 default = nil)
  if valid_597029 != nil:
    section.add "jobScheduleId", valid_597029
  var valid_597030 = path.getOrDefault("resourceGroupName")
  valid_597030 = validateParameter(valid_597030, JString, required = true,
                                 default = nil)
  if valid_597030 != nil:
    section.add "resourceGroupName", valid_597030
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
  ##             : The parameters supplied to the create job schedule operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597034: Call_JobScheduleCreate_596999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a job schedule.
  ## 
  ## http://aka.ms/azureautomationsdk/jobscheduleoperations
  let valid = call_597034.validator(path, query, header, formData, body)
  let scheme = call_597034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597034.url(scheme.get, call_597034.host, call_597034.base,
                         call_597034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597034, url, valid)

proc call*(call_597035: Call_JobScheduleCreate_596999;
          automationAccountName: string; jobScheduleId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## jobScheduleCreate
  ## Create a job schedule.
  ## http://aka.ms/azureautomationsdk/jobscheduleoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   jobScheduleId: string (required)
  ##                : The job schedule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The parameters supplied to the create job schedule operation.
  var path_597036 = newJObject()
  var query_597037 = newJObject()
  var body_597038 = newJObject()
  add(path_597036, "automationAccountName", newJString(automationAccountName))
  add(path_597036, "jobScheduleId", newJString(jobScheduleId))
  add(path_597036, "resourceGroupName", newJString(resourceGroupName))
  add(query_597037, "api-version", newJString(apiVersion))
  add(path_597036, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597038 = parameters
  result = call_597035.call(path_597036, query_597037, nil, nil, body_597038)

var jobScheduleCreate* = Call_JobScheduleCreate_596999(name: "jobScheduleCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobSchedules/{jobScheduleId}",
    validator: validate_JobScheduleCreate_597000, base: "",
    url: url_JobScheduleCreate_597001, schemes: {Scheme.Https})
type
  Call_JobScheduleGet_596987 = ref object of OpenApiRestCall_596458
proc url_JobScheduleGet_596989(protocol: Scheme; host: string; base: string;
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
  assert "jobScheduleId" in path, "`jobScheduleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobSchedules/"),
               (kind: VariableSegment, value: "jobScheduleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobScheduleGet_596988(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieve the job schedule identified by job schedule name.
  ## 
  ## http://aka.ms/azureautomationsdk/jobscheduleoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   jobScheduleId: JString (required)
  ##                : The job schedule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_596990 = path.getOrDefault("automationAccountName")
  valid_596990 = validateParameter(valid_596990, JString, required = true,
                                 default = nil)
  if valid_596990 != nil:
    section.add "automationAccountName", valid_596990
  var valid_596991 = path.getOrDefault("jobScheduleId")
  valid_596991 = validateParameter(valid_596991, JString, required = true,
                                 default = nil)
  if valid_596991 != nil:
    section.add "jobScheduleId", valid_596991
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

proc call*(call_596995: Call_JobScheduleGet_596987; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the job schedule identified by job schedule name.
  ## 
  ## http://aka.ms/azureautomationsdk/jobscheduleoperations
  let valid = call_596995.validator(path, query, header, formData, body)
  let scheme = call_596995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596995.url(scheme.get, call_596995.host, call_596995.base,
                         call_596995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596995, url, valid)

proc call*(call_596996: Call_JobScheduleGet_596987; automationAccountName: string;
          jobScheduleId: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## jobScheduleGet
  ## Retrieve the job schedule identified by job schedule name.
  ## http://aka.ms/azureautomationsdk/jobscheduleoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   jobScheduleId: string (required)
  ##                : The job schedule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_596997 = newJObject()
  var query_596998 = newJObject()
  add(path_596997, "automationAccountName", newJString(automationAccountName))
  add(path_596997, "jobScheduleId", newJString(jobScheduleId))
  add(path_596997, "resourceGroupName", newJString(resourceGroupName))
  add(query_596998, "api-version", newJString(apiVersion))
  add(path_596997, "subscriptionId", newJString(subscriptionId))
  result = call_596996.call(path_596997, query_596998, nil, nil, nil)

var jobScheduleGet* = Call_JobScheduleGet_596987(name: "jobScheduleGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobSchedules/{jobScheduleId}",
    validator: validate_JobScheduleGet_596988, base: "", url: url_JobScheduleGet_596989,
    schemes: {Scheme.Https})
type
  Call_JobScheduleDelete_597039 = ref object of OpenApiRestCall_596458
proc url_JobScheduleDelete_597041(protocol: Scheme; host: string; base: string;
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
  assert "jobScheduleId" in path, "`jobScheduleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/jobSchedules/"),
               (kind: VariableSegment, value: "jobScheduleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobScheduleDelete_597040(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete the job schedule identified by job schedule name.
  ## 
  ## http://aka.ms/azureautomationsdk/jobscheduleoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   jobScheduleId: JString (required)
  ##                : The job schedule name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597042 = path.getOrDefault("automationAccountName")
  valid_597042 = validateParameter(valid_597042, JString, required = true,
                                 default = nil)
  if valid_597042 != nil:
    section.add "automationAccountName", valid_597042
  var valid_597043 = path.getOrDefault("jobScheduleId")
  valid_597043 = validateParameter(valid_597043, JString, required = true,
                                 default = nil)
  if valid_597043 != nil:
    section.add "jobScheduleId", valid_597043
  var valid_597044 = path.getOrDefault("resourceGroupName")
  valid_597044 = validateParameter(valid_597044, JString, required = true,
                                 default = nil)
  if valid_597044 != nil:
    section.add "resourceGroupName", valid_597044
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

proc call*(call_597047: Call_JobScheduleDelete_597039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the job schedule identified by job schedule name.
  ## 
  ## http://aka.ms/azureautomationsdk/jobscheduleoperations
  let valid = call_597047.validator(path, query, header, formData, body)
  let scheme = call_597047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597047.url(scheme.get, call_597047.host, call_597047.base,
                         call_597047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597047, url, valid)

proc call*(call_597048: Call_JobScheduleDelete_597039;
          automationAccountName: string; jobScheduleId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## jobScheduleDelete
  ## Delete the job schedule identified by job schedule name.
  ## http://aka.ms/azureautomationsdk/jobscheduleoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   jobScheduleId: string (required)
  ##                : The job schedule name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597049 = newJObject()
  var query_597050 = newJObject()
  add(path_597049, "automationAccountName", newJString(automationAccountName))
  add(path_597049, "jobScheduleId", newJString(jobScheduleId))
  add(path_597049, "resourceGroupName", newJString(resourceGroupName))
  add(query_597050, "api-version", newJString(apiVersion))
  add(path_597049, "subscriptionId", newJString(subscriptionId))
  result = call_597048.call(path_597049, query_597050, nil, nil, nil)

var jobScheduleDelete* = Call_JobScheduleDelete_597039(name: "jobScheduleDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/jobSchedules/{jobScheduleId}",
    validator: validate_JobScheduleDelete_597040, base: "",
    url: url_JobScheduleDelete_597041, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
