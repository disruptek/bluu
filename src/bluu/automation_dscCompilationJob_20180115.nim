
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AutomationManagement
## version: 2018-01-15
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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
  macServiceName = "automation-dscCompilationJob"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DscCompilationJobListByAutomationAccount_593647 = ref object of OpenApiRestCall_593425
proc url_DscCompilationJobListByAutomationAccount_593649(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/compilationjobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DscCompilationJobListByAutomationAccount_593648(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a list of dsc compilation jobs.
  ## 
  ## http://aka.ms/azureautomationsdk/compilationjoboperations
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
  var valid_593810 = path.getOrDefault("automationAccountName")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "automationAccountName", valid_593810
  var valid_593811 = path.getOrDefault("resourceGroupName")
  valid_593811 = validateParameter(valid_593811, JString, required = true,
                                 default = nil)
  if valid_593811 != nil:
    section.add "resourceGroupName", valid_593811
  var valid_593812 = path.getOrDefault("subscriptionId")
  valid_593812 = validateParameter(valid_593812, JString, required = true,
                                 default = nil)
  if valid_593812 != nil:
    section.add "subscriptionId", valid_593812
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593813 = query.getOrDefault("api-version")
  valid_593813 = validateParameter(valid_593813, JString, required = true,
                                 default = nil)
  if valid_593813 != nil:
    section.add "api-version", valid_593813
  var valid_593814 = query.getOrDefault("$filter")
  valid_593814 = validateParameter(valid_593814, JString, required = false,
                                 default = nil)
  if valid_593814 != nil:
    section.add "$filter", valid_593814
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593841: Call_DscCompilationJobListByAutomationAccount_593647;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve a list of dsc compilation jobs.
  ## 
  ## http://aka.ms/azureautomationsdk/compilationjoboperations
  let valid = call_593841.validator(path, query, header, formData, body)
  let scheme = call_593841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593841.url(scheme.get, call_593841.host, call_593841.base,
                         call_593841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593841, url, valid)

proc call*(call_593912: Call_DscCompilationJobListByAutomationAccount_593647;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## dscCompilationJobListByAutomationAccount
  ## Retrieve a list of dsc compilation jobs.
  ## http://aka.ms/azureautomationsdk/compilationjoboperations
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
  var path_593913 = newJObject()
  var query_593915 = newJObject()
  add(path_593913, "automationAccountName", newJString(automationAccountName))
  add(path_593913, "resourceGroupName", newJString(resourceGroupName))
  add(query_593915, "api-version", newJString(apiVersion))
  add(path_593913, "subscriptionId", newJString(subscriptionId))
  add(query_593915, "$filter", newJString(Filter))
  result = call_593912.call(path_593913, query_593915, nil, nil, nil)

var dscCompilationJobListByAutomationAccount* = Call_DscCompilationJobListByAutomationAccount_593647(
    name: "dscCompilationJobListByAutomationAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/compilationjobs",
    validator: validate_DscCompilationJobListByAutomationAccount_593648, base: "",
    url: url_DscCompilationJobListByAutomationAccount_593649,
    schemes: {Scheme.Https})
type
  Call_DscCompilationJobCreate_593966 = ref object of OpenApiRestCall_593425
proc url_DscCompilationJobCreate_593968(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "compilationJobName" in path,
        "`compilationJobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/compilationjobs/"),
               (kind: VariableSegment, value: "compilationJobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DscCompilationJobCreate_593967(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the Dsc compilation job of the configuration.
  ## 
  ## http://aka.ms/azureautomationsdk/dscconfigurationcompilejoboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   compilationJobName: JString (required)
  ##                     : The DSC configuration Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_593995 = path.getOrDefault("automationAccountName")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "automationAccountName", valid_593995
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
  var valid_593998 = path.getOrDefault("compilationJobName")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "compilationJobName", valid_593998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593999 = query.getOrDefault("api-version")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "api-version", valid_593999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters supplied to the create compilation job operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594001: Call_DscCompilationJobCreate_593966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the Dsc compilation job of the configuration.
  ## 
  ## http://aka.ms/azureautomationsdk/dscconfigurationcompilejoboperations
  let valid = call_594001.validator(path, query, header, formData, body)
  let scheme = call_594001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594001.url(scheme.get, call_594001.host, call_594001.base,
                         call_594001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594001, url, valid)

proc call*(call_594002: Call_DscCompilationJobCreate_593966;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; compilationJobName: string;
          parameters: JsonNode): Recallable =
  ## dscCompilationJobCreate
  ## Creates the Dsc compilation job of the configuration.
  ## http://aka.ms/azureautomationsdk/dscconfigurationcompilejoboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   compilationJobName: string (required)
  ##                     : The DSC configuration Id.
  ##   parameters: JObject (required)
  ##             : The parameters supplied to the create compilation job operation.
  var path_594003 = newJObject()
  var query_594004 = newJObject()
  var body_594005 = newJObject()
  add(path_594003, "automationAccountName", newJString(automationAccountName))
  add(path_594003, "resourceGroupName", newJString(resourceGroupName))
  add(query_594004, "api-version", newJString(apiVersion))
  add(path_594003, "subscriptionId", newJString(subscriptionId))
  add(path_594003, "compilationJobName", newJString(compilationJobName))
  if parameters != nil:
    body_594005 = parameters
  result = call_594002.call(path_594003, query_594004, nil, nil, body_594005)

var dscCompilationJobCreate* = Call_DscCompilationJobCreate_593966(
    name: "dscCompilationJobCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/compilationjobs/{compilationJobName}",
    validator: validate_DscCompilationJobCreate_593967, base: "",
    url: url_DscCompilationJobCreate_593968, schemes: {Scheme.Https})
type
  Call_DscCompilationJobGet_593954 = ref object of OpenApiRestCall_593425
proc url_DscCompilationJobGet_593956(protocol: Scheme; host: string; base: string;
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
  assert "compilationJobName" in path,
        "`compilationJobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/compilationjobs/"),
               (kind: VariableSegment, value: "compilationJobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DscCompilationJobGet_593955(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the Dsc configuration compilation job identified by job id.
  ## 
  ## http://aka.ms/azureautomationsdk/dsccompilationjoboperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   compilationJobName: JString (required)
  ##                     : The DSC configuration Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_593957 = path.getOrDefault("automationAccountName")
  valid_593957 = validateParameter(valid_593957, JString, required = true,
                                 default = nil)
  if valid_593957 != nil:
    section.add "automationAccountName", valid_593957
  var valid_593958 = path.getOrDefault("resourceGroupName")
  valid_593958 = validateParameter(valid_593958, JString, required = true,
                                 default = nil)
  if valid_593958 != nil:
    section.add "resourceGroupName", valid_593958
  var valid_593959 = path.getOrDefault("subscriptionId")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = nil)
  if valid_593959 != nil:
    section.add "subscriptionId", valid_593959
  var valid_593960 = path.getOrDefault("compilationJobName")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "compilationJobName", valid_593960
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593961 = query.getOrDefault("api-version")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "api-version", valid_593961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593962: Call_DscCompilationJobGet_593954; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the Dsc configuration compilation job identified by job id.
  ## 
  ## http://aka.ms/azureautomationsdk/dsccompilationjoboperations
  let valid = call_593962.validator(path, query, header, formData, body)
  let scheme = call_593962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593962.url(scheme.get, call_593962.host, call_593962.base,
                         call_593962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593962, url, valid)

proc call*(call_593963: Call_DscCompilationJobGet_593954;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; compilationJobName: string): Recallable =
  ## dscCompilationJobGet
  ## Retrieve the Dsc configuration compilation job identified by job id.
  ## http://aka.ms/azureautomationsdk/dsccompilationjoboperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   compilationJobName: string (required)
  ##                     : The DSC configuration Id.
  var path_593964 = newJObject()
  var query_593965 = newJObject()
  add(path_593964, "automationAccountName", newJString(automationAccountName))
  add(path_593964, "resourceGroupName", newJString(resourceGroupName))
  add(query_593965, "api-version", newJString(apiVersion))
  add(path_593964, "subscriptionId", newJString(subscriptionId))
  add(path_593964, "compilationJobName", newJString(compilationJobName))
  result = call_593963.call(path_593964, query_593965, nil, nil, nil)

var dscCompilationJobGet* = Call_DscCompilationJobGet_593954(
    name: "dscCompilationJobGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/compilationjobs/{compilationJobName}",
    validator: validate_DscCompilationJobGet_593955, base: "",
    url: url_DscCompilationJobGet_593956, schemes: {Scheme.Https})
type
  Call_DscCompilationJobStreamListByJob_594006 = ref object of OpenApiRestCall_593425
proc url_DscCompilationJobStreamListByJob_594008(protocol: Scheme; host: string;
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
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/compilationjobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/streams")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DscCompilationJobStreamListByJob_594007(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve all the job streams for the compilation Job.
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
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_594009 = path.getOrDefault("automationAccountName")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "automationAccountName", valid_594009
  var valid_594010 = path.getOrDefault("resourceGroupName")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "resourceGroupName", valid_594010
  var valid_594011 = path.getOrDefault("jobId")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "jobId", valid_594011
  var valid_594012 = path.getOrDefault("subscriptionId")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "subscriptionId", valid_594012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_594014: Call_DscCompilationJobStreamListByJob_594006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve all the job streams for the compilation Job.
  ## 
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_DscCompilationJobStreamListByJob_594006;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; jobId: string; subscriptionId: string): Recallable =
  ## dscCompilationJobStreamListByJob
  ## Retrieve all the job streams for the compilation Job.
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
  var path_594016 = newJObject()
  var query_594017 = newJObject()
  add(path_594016, "automationAccountName", newJString(automationAccountName))
  add(path_594016, "resourceGroupName", newJString(resourceGroupName))
  add(query_594017, "api-version", newJString(apiVersion))
  add(path_594016, "jobId", newJString(jobId))
  add(path_594016, "subscriptionId", newJString(subscriptionId))
  result = call_594015.call(path_594016, query_594017, nil, nil, nil)

var dscCompilationJobStreamListByJob* = Call_DscCompilationJobStreamListByJob_594006(
    name: "dscCompilationJobStreamListByJob", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/compilationjobs/{jobId}/streams",
    validator: validate_DscCompilationJobStreamListByJob_594007, base: "",
    url: url_DscCompilationJobStreamListByJob_594008, schemes: {Scheme.Https})
type
  Call_DscCompilationJobGetStream_594018 = ref object of OpenApiRestCall_593425
proc url_DscCompilationJobGetStream_594020(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/compilationjobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/streams/"),
               (kind: VariableSegment, value: "jobStreamId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DscCompilationJobGetStream_594019(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_594021 = path.getOrDefault("automationAccountName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "automationAccountName", valid_594021
  var valid_594022 = path.getOrDefault("resourceGroupName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "resourceGroupName", valid_594022
  var valid_594023 = path.getOrDefault("jobId")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "jobId", valid_594023
  var valid_594024 = path.getOrDefault("subscriptionId")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "subscriptionId", valid_594024
  var valid_594025 = path.getOrDefault("jobStreamId")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "jobStreamId", valid_594025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594026 = query.getOrDefault("api-version")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "api-version", valid_594026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594027: Call_DscCompilationJobGetStream_594018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the job stream identified by job stream id.
  ## 
  ## http://aka.ms/azureautomationsdk/jobstreamoperations
  let valid = call_594027.validator(path, query, header, formData, body)
  let scheme = call_594027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594027.url(scheme.get, call_594027.host, call_594027.base,
                         call_594027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594027, url, valid)

proc call*(call_594028: Call_DscCompilationJobGetStream_594018;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; jobId: string; subscriptionId: string;
          jobStreamId: string): Recallable =
  ## dscCompilationJobGetStream
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
  var path_594029 = newJObject()
  var query_594030 = newJObject()
  add(path_594029, "automationAccountName", newJString(automationAccountName))
  add(path_594029, "resourceGroupName", newJString(resourceGroupName))
  add(query_594030, "api-version", newJString(apiVersion))
  add(path_594029, "jobId", newJString(jobId))
  add(path_594029, "subscriptionId", newJString(subscriptionId))
  add(path_594029, "jobStreamId", newJString(jobStreamId))
  result = call_594028.call(path_594029, query_594030, nil, nil, nil)

var dscCompilationJobGetStream* = Call_DscCompilationJobGetStream_594018(
    name: "dscCompilationJobGetStream", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/compilationjobs/{jobId}/streams/{jobStreamId}",
    validator: validate_DscCompilationJobGetStream_594019, base: "",
    url: url_DscCompilationJobGetStream_594020, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
